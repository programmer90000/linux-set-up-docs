CXX = g++
CXXFLAGS = -Wall -Wextra
TARGET = set-middle-mouse-button-to-auto-scroll

all: $(TARGET)

$(TARGET): set-middle-mouse-button-to-auto-scroll.cpp
	$(CXX) $(CXXFLAGS) set-middle-mouse-button-to-auto-scroll.cpp -o $(TARGET)

clean:
	rm -f $(TARGET)

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run