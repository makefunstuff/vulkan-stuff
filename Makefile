CC = clang++
CFLAGS = -Wall -Wextra -std=c++17
CFLAGS_DEBUG = $(CFLAGS) -g -O0
CFLAGS_RELEASE = $(CFLAGS) -O2
TARGET = vkmain
SRC_DIR = src
OUT_DIR = build
DEBUG_DIR = $(OUT_DIR)/debug
RELEASE_DIR = $(OUT_DIR)/release
INSTALL_DIR = /usr/local/bin

# Vulkan and GLFW paths (adjust these to match your system)
VULKAN_SDK = $(HOME)/VulkanSDK/1.3.296.0/macOS
GLFW_PATH = /opt/homebrew/Cellar/glfw/3.4

# Include and library paths
INCLUDES = -I$(VULKAN_SDK)/include -I$(GLFW_PATH)/include
LDFLAGS = -L$(VULKAN_SDK)/lib -L$(GLFW_PATH)/lib
LIBS = -lvulkan -lglfw

# Add runtime path for dynamic libraries
RPATH = -Wl,-rpath,$(VULKAN_SDK)/lib

# Find all .cpp files in the src directory
SRCS = $(wildcard $(SRC_DIR)/*.cpp)
# Generate lists of object files for debug and release builds
OBJS_DEBUG = $(patsubst $(SRC_DIR)/%.cpp,$(DEBUG_DIR)/%.o,$(SRCS))
OBJS_RELEASE = $(patsubst $(SRC_DIR)/%.cpp,$(RELEASE_DIR)/%.o,$(SRCS))

.PHONY: all debug release clean install run

all: debug release

debug: $(DEBUG_DIR)/$(TARGET)

release: $(RELEASE_DIR)/$(TARGET)

# Debug build
$(DEBUG_DIR)/$(TARGET): $(OBJS_DEBUG) | $(DEBUG_DIR)
	$(CC) $(CFLAGS_DEBUG) $(LDFLAGS) $(RPATH) -o $@ $(OBJS_DEBUG) $(LIBS)

$(DEBUG_DIR)/%.o: $(SRC_DIR)/%.cpp | $(DEBUG_DIR)
	$(CC) $(CFLAGS_DEBUG) $(INCLUDES) -c $< -o $@

# Release build
$(RELEASE_DIR)/$(TARGET): $(OBJS_RELEASE) | $(RELEASE_DIR)
	$(CC) $(CFLAGS_RELEASE) $(LDFLAGS) $(RPATH) -o $@ $(OBJS_RELEASE) $(LIBS)

$(RELEASE_DIR)/%.o: $(SRC_DIR)/%.cpp | $(RELEASE_DIR)
	$(CC) $(CFLAGS_RELEASE) $(INCLUDES) -c $< -o $@

$(DEBUG_DIR) $(RELEASE_DIR):
	mkdir -p $@

run: debug
	./$(DEBUG_DIR)/$(TARGET)

clean:
	rm -rf $(OUT_DIR)

install: $(RELEASE_DIR)/$(TARGET)
	install -m 755 $< $(INSTALL_DIR)
