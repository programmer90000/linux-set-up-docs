#include <iostream>
#include <fstream>
#include <ctime>
#include <string>
#include <filesystem>
#include <cstdlib>

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

int main() {
    std::string homeDir = getHomeDirectory();
    std::string username = getUsername();
    std::string logFilePath = homeDir + "/c-plus-plus-logs.txt";

    std::cout << "Home directory: " << homeDir << std::endl;
    std::cout << "Username: " << username << std::endl;
    std::cout << "Log file path: " << logFilePath << std::endl;

    // Try to create the directory if needed
    if (!createDirectoryIfNeeded(logFilePath)) {
        std::cerr << "Warning: Could not create directory for log file" << std::endl;
    }

    std::ofstream logFile;
    logFile.open(logFilePath, std::ios::app);

    if (!logFile.is_open()) {
        std::cerr << "Error: Could not open log file at " << logFilePath << std::endl;
        std::cerr << "Make sure you have write permissions in " << homeDir << std::endl;
        std::cout << "This is a C++ app. (Logging failed)" << std::endl;
        return 1;
    }

    // Log information
    std::string timestamp = getCurrentTimestamp();
    logFile << "[" << timestamp << "] ";
    logFile << "Application started by user: " << username << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Home directory: " << homeDir << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "Program: set-middle-mouse-button-to-auto-scroll" << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "[" << timestamp << "] ";
    logFile << "Log file: " << logFilePath << std::endl;
    logFile << "[" << timestamp << "] ";
    logFile << "----------------------------------------" << std::endl;

    logFile.close();

    // Output to console
    std::cout << "Log written to: " << logFilePath << std::endl;

    return 0;
}