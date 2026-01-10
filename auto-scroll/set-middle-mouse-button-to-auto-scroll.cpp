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

// Global atomic flag for signal handling
std::atomic<bool> running(true);

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

// Function to write log entry
void writeLogEntry(std::ofstream& logFile, const std::string& homeDir,
                   const std::string& username, int iteration) {
    std::string timestamp = getCurrentTimestamp();

    logFile << "[" << timestamp << "] ";
    logFile << "Iteration: " << iteration << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "User: " << username << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Home directory: " << homeDir << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Program: set-middle-mouse-button-to-auto-scroll" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Status: Running continuously" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Uptime: " << (iteration * 5) << " seconds" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "PID: " << getpid() << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "----------------------------------------" << std::endl;

    // Flush to ensure data is written immediately
    logFile.flush();
}

// Function to display status
void displayStatus(int iteration, const std::string& logFilePath) {
    std::string timestamp = getCurrentTimestamp();
    std::cout << "[" << timestamp << "] ";
    std::cout << "Iteration " << iteration << " completed." << std::endl;
    std::cout << "[" << timestamp << "] ";
    std::cout << "Total uptime: " << (iteration * 5) << " seconds" << std::endl;
    std::cout << "[" << timestamp << "] ";
    std::cout << "Log file: " << logFilePath << std::endl;

    // Show log file size every 5 iterations
    if (iteration % 5 == 0) {
        try {
            auto size = std::filesystem::file_size(logFilePath);
            std::cout << "[" << timestamp << "] ";
            std::cout << "Log file size: " << size << " bytes" << std::endl;
        } catch (...) {
            // Ignore errors for file size
        }
    }
}

int main() {
    // Set up signal handlers for graceful shutdown
    std::signal(SIGINT, signalHandler);
    std::signal(SIGTERM, signalHandler);

    std::string homeDir = getHomeDirectory();
    std::string username = getUsername();
    std::string logFilePath = homeDir + "/c-plus-plus-logs.txt";
    
    std::cout << "Starting continuous logging application..." << std::endl;
    std::cout << "Home directory: " << homeDir << std::endl;
    std::cout << "Username: " << username << std::endl;
    std::cout << "Log file path: " << logFilePath << std::endl;
    std::cout << "PID: " << getpid() << std::endl;
    std::cout << "Logging every 5 seconds. Press Ctrl+C to stop." << std::endl;
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
    logFile << "=== Application Started ===" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Starting continuous logging" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Log interval: 5 seconds" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "PID: " << getpid() << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "User: " << username << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Home: " << homeDir << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "----------------------------------------" << std::endl;
    logFile.flush();

    int iteration = 0;

    // Main loop
    while (running) {
        iteration++;

        // Write log entry
        writeLogEntry(logFile, homeDir, username, iteration);

        // Display status on console
        displayStatus(iteration, logFilePath);

        // Wait for 5 seconds
        if (running) {
            for (int i = 0; i < 5 && running; i++) {
                std::this_thread::sleep_for(std::chrono::seconds(1));
            }
        }
    }

    // Write final log entry
    timestamp = getCurrentTimestamp();
    logFile << "\n[" << timestamp << "] ";
    logFile << "=== Application Stopped ===" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Total iterations: " << iteration << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Total runtime: " << (iteration * 5) << " seconds" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Shutdown reason: User interrupt" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "----------------------------------------\n" << std::endl;
    logFile.flush();

    logFile.close();
    
    // Final console output
    std::cout << "\n----------------------------------------" << std::endl;
    std::cout << "Application stopped." << std::endl;
    std::cout << "Total runtime: " << (iteration * 5) << " seconds" << std::endl;
    std::cout << "Total log entries: " << iteration << std::endl;
    std::cout << "Log file: " << logFilePath << std::endl;
    
    return 0;
}