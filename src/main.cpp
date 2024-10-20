#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>

#define GLM_FORCE_RADIANS
#define GLM_FORCE_DEPTH_ZERO_TO_ONE

#define internal static

#include <glm/vec4.hpp>
#include <glm/mat4x4.hpp>

#include <stdio.h>
#include <string.h>

#include <vulkan/vulkan.h>

uint32_t g_uWindowWidth = 800;
uint32_t g_uWindowHeight = 600;

typedef struct {
  VkInstance vkInstance;
} SVKApplicationState;

SVKApplicationState g_pvkApplicationState = {0};

internal void Cleanup(GLFWwindow* window)
{

  vkDestroyInstance(g_pvkApplicationState.vkInstance, NULL);
  glfwDestroyWindow(window);
  glfwTerminate();
}

#define VK_CHECK(result) if (result != VK_SUCCESS) { fprintf(stderr, "Vulkan error: %d\n", result); exit(EXIT_FAILURE); }

internal void InitVulkan() {
    VkApplicationInfo appInfo = {
        .sType = VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pApplicationName = "Vulkan Base",
        .applicationVersion = VK_MAKE_VERSION(1, 0, 0),
        .pEngineName = "Some",
        .engineVersion = VK_MAKE_VERSION(1, 0, 0),
        .apiVersion = VK_API_VERSION_1_0,
    };

    VkInstanceCreateInfo createInfo = {
        .sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .pApplicationInfo = &appInfo,
    };

    uint32_t glfwExtensionCount = 0;
    const char** glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount);
    if (!glfwExtensions) {
        fprintf(stderr, "Failed to get required GLFW extensions!\n");
        exit(EXIT_FAILURE);
    }

    // Stack allocation if glfwExtensionCount is reasonably small (e.g., 64)
    const char* requiredExtensions[64];
    assert(glfwExtensionCount + 1 <= sizeof(requiredExtensions) / sizeof(requiredExtensions[0]));

    // Copy GLFW extensions and add VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME
    memcpy(requiredExtensions, glfwExtensions, glfwExtensionCount * sizeof(char*));
    requiredExtensions[glfwExtensionCount] = VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME;

    createInfo.enabledExtensionCount = glfwExtensionCount + 1;
    createInfo.ppEnabledExtensionNames = requiredExtensions;
    createInfo.flags |= VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;

    VK_CHECK(vkCreateInstance(&createInfo, NULL, &g_pvkApplicationState.vkInstance));
}


int main()
{
  glfwInit();

  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
  glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
  GLFWwindow* window = glfwCreateWindow(
    g_uWindowWidth, g_uWindowHeight, "Vulkan window", NULL, NULL
  );

  InitVulkan();

  while (!glfwWindowShouldClose(window)) {
    glfwPollEvents();
  }


  Cleanup(window);

  return 0;
}
