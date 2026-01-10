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

// Global atomic flag for signal handling
std::atomic<bool> running(true);
std::atomic<int> middleButtonPressCount(0);

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

// Function to write log entry for middle button press
void writeLogEntry(std::ofstream& logFile, const std::string& homeDir, 
                   const std::string& username, int pressCount) {
    std::string timestamp = getCurrentTimestamp();

    logFile << "[" << timestamp << "] ";
    logFile << "MIDDLE MOUSE BUTTON PRESS DETECTED" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Press count: " << pressCount << std::endl;
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

    // Print to console
    std::cout << "[" << timestamp << "] ";
    std::cout << "✓ Middle mouse button pressed! (Total: " << pressCount << " times)" << std::endl;
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
    
    std::cout << "Starting mouse detection application..." << std::endl;
    std::cout << "Home directory: " << homeDir << std::endl;
    std::cout << "Username: " << username << std::endl;
    std::cout << "Log file path: " << logFilePath << std::endl;
    std::cout << "PID: " << getpid() << std::endl;
    std::cout << "Press Ctrl+C to stop." << std::endl;
    std::cout << "----------------------------------------" << std::endl;

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
    logFile << "=== Middle Mouse Logger Started ===" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Monitoring middle mouse button presses" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "PID: " << getpid() << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "User: " << username << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Home: " << homeDir << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "----------------------------------------" << std::endl;
    logFile.flush();

    // TODO: Add device discovery and event handling
    std::cout << "Device detection setup complete." << std::endl;
    std::cout << "TODO: Implement mouse device discovery and event handling." << std::endl;

    int iteration = 0;

    // Temporary main loop while we implement device detection
    while (running && iteration < 10) {
        iteration++;

        // Simulate a middle button press for testing
        static int simulatedPressCount = 0;
        if (iteration % 3 == 0) {
            simulatedPressCount++;
            writeLogEntry(logFile, homeDir, username, simulatedPressCount);
        }

        // Wait for 2 seconds
        std::this_thread::sleep_for(std::chrono::seconds(2));
        
        if (!running) break;
    }

    // Write final log entry
    timestamp = getCurrentTimestamp();
    logFile << "\n[" << timestamp << "] ";
    logFile << "=== Middle Mouse Logger Stopped ===" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Total middle button presses detected: " << middleButtonPressCount << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Shutdown reason: User interrupt" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "----------------------------------------\n" << std::endl;
    logFile.flush();

    logFile.close();
    
    // Final console output
    std::cout << "\n----------------------------------------" << std::endl;
    std::cout << "Application stopped." << std::endl;
    std::cout << "Total simulated presses: " << middleButtonPressCount << std::endl;
    std::cout << "Log file: " << logFilePath << std::endl;
    
    return 0;
}