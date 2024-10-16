#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>

#define GLM_FORCE_RADIANS
#define GLM_FORCE_DEPTH_ZERO_TO_ONE

#define internal static

#include <glm/vec4.hpp>
#include <glm/mat4x4.hpp>

#include <stdio.h>

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

internal void
InitVulkan()
{
  VkApplicationInfo appInfo;
  appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
  appInfo.pApplicationName = "Vulkan Base";
  appInfo.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
  appInfo.pEngineName = "Some";
  appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
  appInfo.apiVersion = VK_API_VERSION_1_0;

  VkInstanceCreateInfo createInfo;
  createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
  createInfo.pApplicationInfo = &appInfo;

  uint32_t glfwExtensionCount = 0;
  const char** glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount);

  createInfo.enabledLayerCount = 0;

  const char** requiredExtensions = (const char**) malloc(glfwExtensionCount * sizeof(char*));

  for (uint32_t i = 0; i < glfwExtensionCount; i++) {
      requiredExtensions[i] = glfwExtensions[i];
  }

  // Add VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME
  requiredExtensions = (const char**) realloc(requiredExtensions, (glfwExtensionCount + 1) * sizeof(char*));

  requiredExtensions[glfwExtensionCount] = VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME;

  createInfo.flags |= VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;
  createInfo.enabledExtensionCount = glfwExtensionCount + 1;
  createInfo.ppEnabledExtensionNames = requiredExtensions;

  if (vkCreateInstance(&createInfo, NULL, &g_pvkApplicationState.vkInstance) != VK_SUCCESS) {
      fprintf(stderr, "failed to create instance!\n");
      exit(EXIT_FAILURE);
  }

  free(requiredExtensions);
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
