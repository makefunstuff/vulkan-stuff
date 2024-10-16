CC = clang++
CFLAGS = -Wall -Wextra -std=c++11
CFLAGS_DEBUG = $(CFLAGS) -g -O0
CFLAGS_RELEASE = $(CFLAGS) -O2
TARGET = vkstf
SRC_DIR = src
OUT_DIR = build
LIBS =-lglfw -lvulkan
DEBUG_DIR = $(OUT_DIR)/debug
RELEASE_DIR = $(OUT_DIR)/release
INSTALL_DIR = /usr/local/bin

# Find all .cpp files in the src directory
SRCS = $(wildcard $(SRC_DIR)/*.cpp)
# Generate lists of object files for debug and release builds
OBJS_DEBUG = $(patsubst $(SRC_DIR)/%.cpp,$(DEBUG_DIR)/%.o,$(SRCS))
OBJS_RELEASE = $(patsubst $(SRC_DIR)/%.cpp,$(RELEASE_DIR)/%.o,$(SRCS))

all: debug release

debug: $(DEBUG_DIR)/$(TARGET)

release: $(RELEASE_DIR)/$(TARGET)

# Debug build
$(DEBUG_DIR)/$(TARGET): $(OBJS_DEBUG) | $(DEBUG_DIR)
	$(CC) $(CFLAGS_DEBUG) $(LIBS) -o $@ $(OBJS_DEBUG)

$(DEBUG_DIR)/%.o: $(SRC_DIR)/%.cpp | $(DEBUG_DIR)
	$(CC) $(CFLAGS_DEBUG) $(LIBS) -c $< -o $@

# Release build
$(RELEASE_DIR)/$(TARGET): $(OBJS_RELEASE) | $(RELEASE_DIR)
	$(CC) $(CFLAGS_RELEASE) $(LIBS) -o $@ $(OBJS_RELEASE)

$(RELEASE_DIR)/%.o: $(SRC_DIR)/%.cpp | $(RELEASE_DIR)
	$(CC) $(CFLAGS_RELEASE) $(LIBS) -c $< -o $@

$(DEBUG_DIR) $(RELEASE_DIR):
	mkdir -p $@

# Run the program
run: debug
	./$(DEBUG_DIR)/$(TARGET)

clean:
	rm -rf $(OUT_DIR)

install: $(RELEASE_DIR)/$(TARGET)
	install -m 755 $< $(INSTALL_DIR)

.PHONY: all debug release clean install
