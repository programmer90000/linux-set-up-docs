CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17
TARGET = set-middle-mouse-button-to-auto-scroll

all: $(TARGET)

$(TARGET): set-middle-mouse-button-to-auto-scroll.cpp
	$(CXX) $(CXXFLAGS) set-middle-mouse-button-to-auto-scroll.cpp -o $(TARGET)

clean:
	rm -f $(TARGET)

run: $(TARGET)
	@echo "Using HOME directory: $(HOME)"
	./$(TARGET)

log-view:
	@if [ -n "$(HOME)" ]; then \
		if [ -f "$(HOME)/c-plus-plus-logs.txt" ]; then \
			echo "=== Log File Contents (from $(HOME)/c-plus-plus-logs.txt) ==="; \
			tail -20 "$(HOME)/c-plus-plus-logs.txt"; \
		else \
			echo "Log file not found at $(HOME)/c-plus-plus-logs.txt"; \
			echo "Available files in $(HOME)/:"; \
			ls -la "$(HOME)/" | grep -E "(\.txt|\.log)" || echo "No log files found"; \
		fi; \
	else \
		echo "HOME environment variable not set!"; \
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

.PHONY: all clean run install log-view log-clear env-info