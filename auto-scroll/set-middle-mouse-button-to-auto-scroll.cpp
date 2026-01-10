#include <iostream>
#include <fstream>
#include <ctime>
#include <string>
#include <filesystem>
#include <cstdlib>
#include <thread>
#include <chrono>
#include <atomic>
#include <csignal>
#include <cstring>
#include <vector>
#include <dirent.h>
#include <fcntl.h>
#include <unistd.h>
#include <poll.h>
#include <linux/input.h>
#include <sys/ioctl.h>
#include <algorithm>

// Global atomic flags for signal handling and toggle state
std::atomic<bool> running(true);
std::atomic<int> middleButtonPressCount(0);
std::atomic<bool> toggleState(false);
std::atomic<bool> buttonWasPressed(false);

// Signal handler for graceful shutdown
void signalHandler(int signal) {
    if (signal == SIGINT || signal == SIGTERM) {
        std::cout << "\nReceived shutdown signal. Stopping..." << std::endl;
        running = false;
    }
}

// Get current timestamp as string
std::string getCurrentTimestamp() {
    std::time_t now = std::time(nullptr);
    char buffer[80];
    std::strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", std::localtime(&now));
    return std::string(buffer);
}

// Get username from environment
std::string getUsername() {
    const char* user = std::getenv("USER");
    if (user) return std::string(user);

    user = std::getenv("USERNAME");
    if (user) return std::string(user);

    return "unknown";
}

// Get home directory from environment
std::string getHomeDirectory() {
    const char* home = std::getenv("HOME");
    if (home) {
        return std::string(home);
    }

    // Fallback: try to construct from username
    std::string username = getUsername();
    if (username != "unknown") {
        return "/home/" + username;
    }

    return ".";
}

bool createDirectoryIfNeeded(const std::string& path) {
    try {
        std::filesystem::path dirPath(path);
        if (!std::filesystem::exists(dirPath.parent_path())) {
            std::filesystem::create_directories(dirPath.parent_path());
        }
        return true;
    } catch (...) {
        return false;
    }
}

// Function to write log entry for middle button toggle
void writeLogEntry(std::ofstream& logFile, const std::string& homeDir, 
                   const std::string& username, int pressCount, bool newState) {
    std::string timestamp = getCurrentTimestamp();

    logFile << "[" << timestamp << "] ";
    logFile << "MIDDLE MOUSE BUTTON TOGGLE" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Action: " << (newState ? "TURNED ON" : "TURNED OFF") << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Press count: " << pressCount << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Current state: " << (newState ? "ON" : "OFF") << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "User: " << username << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Home directory: " << homeDir << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Timestamp (Unix): " << std::time(nullptr) << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "----------------------------------------" << std::endl;

    // Flush to ensure data is written immediately
    logFile.flush();

    // Print to console with visual indicator
    std::cout << "[" << timestamp << "] ";
    std::cout << (newState ? "ON " : "OFF");
    std::cout << " - Middle mouse toggled! (Total presses: " << pressCount << ")" << std::endl;
}

// Structure to hold device information
struct InputDevice {
    int fd;
    std::string path;
    std::string name;
};

// Function to check if a device is a mouse
bool isMouseDevice(const std::string& path) {
    int fd = open(path.c_str(), O_RDONLY);
    if (fd < 0) {
        return false;
    }

    // Read device capabilities
    unsigned long evbit[EV_MAX/8/sizeof(unsigned long) + 1] = {0};
    if (ioctl(fd, EVIOCGBIT(0, sizeof(evbit)), evbit) < 0) {
        close(fd);
        return false;
    }

    // Check if device supports EV_KEY (buttons)
    if (!(evbit[0] & (1 << EV_KEY))) {
        close(fd);
        return false;
    }

    // Read key/button capabilities
    unsigned long keybit[KEY_MAX/8/sizeof(unsigned long) + 1] = {0};
    if (ioctl(fd, EVIOCGBIT(EV_KEY, sizeof(keybit)), keybit) < 0) {
        close(fd);
        return false;
    }

    // Check for mouse buttons (BTN_LEFT, BTN_RIGHT, BTN_MIDDLE)
    bool hasMouseButtons = false;
    if (keybit[BTN_LEFT/8/sizeof(unsigned long)] & (1 << (BTN_LEFT % (8*sizeof(unsigned long))))) {
        hasMouseButtons = true;
    }
    if (keybit[BTN_RIGHT/8/sizeof(unsigned long)] & (1 << (BTN_RIGHT % (8*sizeof(unsigned long))))) {
        hasMouseButtons = true;
    }
    if (keybit[BTN_MIDDLE/8/sizeof(unsigned long)] & (1 << (BTN_MIDDLE % (8*sizeof(unsigned long))))) {
        hasMouseButtons = true;
    }

    // Get device name
    char name[256] = "Unknown";
    if (ioctl(fd, EVIOCGNAME(sizeof(name)), name) >= 0) {
        // Check if name contains "mouse" (case insensitive)
        std::string lowerName = name;
        std::transform(lowerName.begin(), lowerName.end(), lowerName.begin(), ::tolower);
        if (lowerName.find("mouse") != std::string::npos) {
            hasMouseButtons = true;
        }
    }

    close(fd);
    return hasMouseButtons;
}

int main() {
    // Set up signal handlers for graceful shutdown
    std::signal(SIGINT, signalHandler);
    std::signal(SIGTERM, signalHandler);

    std::string homeDir = getHomeDirectory();
    std::string username = getUsername();
    std::string logFilePath = homeDir + "/c-plus-plus-logs.txt";
    
    std::cout << "========================================" << std::endl;
    std::cout << "Middle Mouse Button Toggle Logger" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << "Home directory: " << homeDir << std::endl;
    std::cout << "Username: " << username << std::endl;
    std::cout << "Log file path: " << logFilePath << std::endl;
    std::cout << "Initial state: " << (toggleState.load() ? "ON" : "OFF") << std::endl;
    std::cout << "PID: " << getpid() << std::endl;
    std::cout << "----------------------------------------" << std::endl;
    std::cout << "Listening for middle mouse button presses..." << std::endl;
    std::cout << "Press Ctrl+C to exit" << std::endl;
    std::cout << "========================================" << std::endl;

    // Try to create the directory if needed
    if (!createDirectoryIfNeeded(logFilePath)) {
        std::cerr << "Warning: Could not create directory for log file" << std::endl;
    }

    // Open log file for appending (open once and keep it open)
    std::ofstream logFile;
    logFile.open(logFilePath, std::ios::app);

    if (!logFile.is_open()) {
        std::cerr << "Error: Could not open log file at " << logFilePath << std::endl;
        std::cerr << "Make sure you have write permissions in " << homeDir << std::endl;
        std::cout << "Exiting..." << std::endl;
        return 1;
    }

    // Write initial log entry
    std::string timestamp = getCurrentTimestamp();
    logFile << "\n\n[" << timestamp << "] ";
    logFile << "=== Middle Mouse Toggle Logger Started ===" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Initial state: " << (toggleState.load() ? "ON" : "OFF") << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "PID: " << getpid() << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "User: " << username << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Home: " << homeDir << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Log file: " << logFilePath << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Method: Direct input device access" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Behavior: Toggle ON/OFF with each press" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "----------------------------------------" << std::endl;
    logFile.flush();

    // Find all mouse devices
    std::vector<InputDevice> devices;
    std::cout << "Searching for mouse devices..." << std::endl;

    DIR* dir = opendir("/dev/input");
    if (!dir) {
        std::cerr << "Cannot open /dev/input directory" << std::endl;
        logFile << "[" << getCurrentTimestamp() << "] ";
        logFile << "ERROR: Cannot open /dev/input directory" << std::endl;
        logFile.close();
        return 1;
    }

    struct dirent* entry;
    while ((entry = readdir(dir)) != nullptr) {
        std::string name = entry->d_name;

        // Look for event devices (event*)
        if (name.compare(0, 5, "event") == 0) {
            std::string path = "/dev/input/" + name;

            if (isMouseDevice(path)) {
                // Get device name
                int fd = open(path.c_str(), O_RDONLY);
                if (fd >= 0) {
                    char devName[256] = "Unknown";
                    ioctl(fd, EVIOCGNAME(sizeof(devName)), devName);
                    close(fd);

                    // Try to open for reading events
                    fd = open(path.c_str(), O_RDONLY | O_NONBLOCK);
                    if (fd >= 0) {
                        InputDevice device;
                        device.fd = fd;
                        device.path = path;
                        device.name = devName;
                        devices.push_back(device);

                        std::cout << "✓ Found mouse: " << device.name 
                                  << " at " << path << std::endl;

                        logFile << "[" << getCurrentTimestamp() << "] ";
                        logFile << "Found mouse device: " << device.name 
                                << " at " << path << std::endl;
                    }
                }
            }
        }
    }
    closedir(dir);

    if (devices.empty()) {
        int fd = open("/dev/input/event7", O_RDONLY | O_NONBLOCK);
        if (fd >= 0) {
            InputDevice device;
            device.fd = fd;
            device.path = "/dev/input/event7";
            device.name = "USB Optical Mouse (event7)";
            devices.push_back(device);

            std::cout << "✓ Using device: " << device.path << std::endl;

            logFile << "[" << getCurrentTimestamp() << "] ";
            logFile << "Using device: " << device.path << std::endl;
        } else {
            std::cerr << "No mouse devices found!" << std::endl;
            std::cerr << "Try running with sudo: sudo ./set-middle-mouse-button-to-auto-scroll" << std::endl;
            logFile << "[" << getCurrentTimestamp() << "] ";
            logFile << "ERROR: No mouse devices found" << std::endl;
            logFile.close();
            return 1;
        }
    }

    std::cout << "Found " << devices.size() << " mouse device(s)" << std::endl;
    std::cout << "Now listening for middle mouse button presses..." << std::endl;
    std::cout << "Click the middle mouse button (scroll wheel) to toggle ON/OFF." << std::endl;
    std::cout << "Current state: " << (toggleState.load() ? "ON" : "OFF") << std::endl;
    std::cout << "----------------------------------------" << std::endl;

    logFile << "[" << getCurrentTimestamp() << "] ";
    logFile << "Input monitoring initialized successfully" << std::endl;
    logFile << "[" << getCurrentTimestamp() << "] ";
    logFile << "Ready to detect middle mouse button toggle presses" << std::endl;
    logFile.flush();

    // Prepare for polling
    std::vector<pollfd> fds;
    for (const auto& device : devices) {
        pollfd pfd;
        pfd.fd = device.fd;
        pfd.events = POLLIN;
        pfd.revents = 0;
        fds.push_back(pfd);
    }

    // Main event loop
    while (running) {
        // Poll all device file descriptors
        int ret = poll(fds.data(), fds.size(), 100); // 100ms timeout

        if (ret < 0) {
            if (errno != EINTR) {
                std::cerr << "Poll error: " << strerror(errno) << std::endl;
            }
            break;
        }

        if (ret == 0) {
            // Timeout - continue
            continue;
        }

        // Check each device for events
        for (size_t i = 0; i < devices.size(); i++) {
            if (fds[i].revents & POLLIN) {
                struct input_event ev;
                ssize_t bytes_read;

                // Read all available events from this device
                while (running) {
                    bytes_read = read(devices[i].fd, &ev, sizeof(ev));

                    if (bytes_read < (ssize_t)sizeof(ev)) {
                        // No more events or error
                        if (bytes_read < 0 && errno != EAGAIN) {
                            std::cerr << "Error reading from " << devices[i].path << ": " 
                                      << strerror(errno) << std::endl;
                        }
                        break;
                    }

                    // Check for button events (EV_KEY type)
                    if (ev.type == EV_KEY) {
                        // Check for middle mouse button
                        bool is_middle_button = false;

                        if (ev.code == BTN_MIDDLE) {
                            is_middle_button = true;
                        } else if (ev.code == 274) {
                            is_middle_button = true;
                        } else if (ev.code == 3) {
                            is_middle_button = true;
                        } else if (ev.code == 275) {
                            is_middle_button = true;
                        }

                        if (is_middle_button) {
                            // Only trigger on button press (value == 1). Make sure we don't trigger multiple times for the same press
                            if (ev.value == 1 && !buttonWasPressed) {
                                buttonWasPressed = true;

                                // Toggle the state
                                bool oldState = toggleState.load();
                                bool newState = !oldState;
                                toggleState.store(newState);

                                // Increment press count
                                middleButtonPressCount++;

                                // Write to log
                                writeLogEntry(logFile, homeDir, username, middleButtonPressCount, newState);

                                // Update console status line
                                std::cout << "\rCurrent state: " << (newState ? "ON" : "OFF")
                                          << " | Total toggles: " << middleButtonPressCount
                                          << " " << std::flush;
                            }
                            // Reset buttonWasPressed when button is released
                            else if (ev.value == 0) {
                                buttonWasPressed = false;
                            }

                            if (ev.value == 1) {
                                std::cout << "\n[" << getCurrentTimestamp() << "] ";
                                std::cout << "DEBUG: Middle button PRESSED - toggling state" << std::endl;
                            }
                        }
                    }
                }
            }
        }

        // Small sleep to prevent CPU spinning
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }

    // Write final log entry
    timestamp = getCurrentTimestamp();
    logFile << "\n[" << timestamp << "] ";
    logFile << "=== Middle Mouse Toggle Logger Stopped ===" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Final state: " << (toggleState.load() ? "ON" : "OFF") << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Total toggle actions: " << middleButtonPressCount << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Shutdown reason: User interrupt" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "----------------------------------------\n" << std::endl;
    logFile.flush();

    // Cleanup
    for (auto& device : devices) {
        close(device.fd);
    }

    // Close the log file
    logFile.close();

    // Final console output
    std::cout << "\n========================================" << std::endl;
    std::cout << "Application stopped." << std::endl;
    std::cout << "Final state: " << (toggleState.load() ? "ON" : "OFF") << std::endl;
    std::cout << "Total toggle actions: " << middleButtonPressCount << std::endl;
    std::cout << "Log file: " << logFilePath << std::endl;

    if (middleButtonPressCount > 0) {
        std::cout << "✓ Successfully detected " << middleButtonPressCount << " toggle action(s)!" << std::endl;
    } else {
        std::cout << "⚠ No middle button presses were detected." << std::endl;
        std::cout << "   Try running with sudo: sudo ./middle-mouse-toggle" << std::endl;
    }

    std::cout << "========================================" << std::endl;

    return 0;
}