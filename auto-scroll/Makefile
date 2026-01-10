CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17 -pthread
TARGET = set-middle-mouse-button-to-auto-scroll

all: $(TARGET)

$(TARGET): set-middle-mouse-button-to-auto-scroll.cpp
	$(CXX) $(CXXFLAGS) set-middle-mouse-button-to-auto-scroll.cpp -o $(TARGET)

clean:
	rm -f $(TARGET)

run: $(TARGET)
	@echo "Starting continuous logging application..."
	@echo "Press Ctrl+C to stop"
	@echo "----------------------------------------"
	./$(TARGET)

run-background: $(TARGET)
	@echo "Starting in background..."
	@echo "Log file: $(HOME)/c-plus-plus-logs.txt"
	@echo "To stop: kill $$(pgrep -f $(TARGET))"
	@echo "To view logs: tail -f $(HOME)/c-plus-plus-logs.txt"
	@./$(TARGET) > /dev/null 2>&1 &

stop:
	@if pgrep -f $(TARGET) > /dev/null; then \
		echo "Stopping $(TARGET)..."; \
		pkill -f $(TARGET); \
		sleep 1; \
		if pgrep -f $(TARGET) > /dev/null; then \
			echo "Process still running, forcing stop..."; \
			pkill -9 -f $(TARGET); \
		fi; \
		echo "Stopped."; \
	else \
		echo "$(TARGET) is not running."; \
	fi

status:
	@if pgrep -f $(TARGET) > /dev/null; then \
		echo "$(TARGET) is RUNNING"; \
		ps -fp $$(pgrep -f $(TARGET)) | tail -1; \
		echo "Log file: $(HOME)/c-plus-plus-logs.txt"; \
		echo "To view logs: tail -f $(HOME)/c-plus-plus-logs.txt"; \
	else \
		echo "$(TARGET) is NOT RUNNING"; \
	fi

log-tail:
	@if [ -n "$(HOME)" ] && [ -f "$(HOME)/c-plus-plus-logs.txt" ]; then \
		echo "Tailing log file (Ctrl+C to stop):"; \
		echo "----------------------------------------"; \
		tail -f "$(HOME)/c-plus-plus-logs.txt"; \
	else \
		echo "Log file not found at $(HOME)/c-plus-plus-logs.txt"; \
	fi

install: $(TARGET)
	@echo "Installing..."
	@echo "Home directory detected: $(HOME)"
	cp $(TARGET) /usr/local/bin/
	@echo "Installed to /usr/local/bin/$(TARGET)"

log-view:
	@if [ -n "$(HOME)" ] && [ -f "$(HOME)/c-plus-plus-logs.txt" ]; then \
		echo "=== Last 20 log entries ==="; \
		tail -40 "$(HOME)/c-plus-plus-logs.txt"; \
	else \
		echo "Log file not found at $(HOME)/c-plus-plus-logs.txt"; \
	fi

log-clear:
	@if [ -n "$(HOME)" ] && [ -f "$(HOME)/c-plus-plus-logs.txt" ]; then \
		echo "Clearing log file at $(HOME)/c-plus-plus-logs.txt"; \
		> "$(HOME)/c-plus-plus-logs.txt"; \
		echo "Log file cleared"; \
	else \
		echo "No log file to clear at $(HOME)/c-plus-plus-logs.txt"; \
	fi

env-info:
	@echo "=== Environment Information ==="
	@echo "HOME: $(HOME)"
	@echo "USER: $(USER)"
	@echo "PWD: $(PWD)"
	@echo "CXX: $(CXX)"

.PHONY: all clean run run-background stop status log-tail log-view log-clear env-info