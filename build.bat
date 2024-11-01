@echo off

REM Set Vulkan SDK environment variables
set VULKAN_SDK=C:\VulkanSDK\1.3.296.0
set PATH=%VULKAN_SDK%\Bin;%VULKAN_SDK%\Bin32;%PATH%
set INCLUDE=%VULKAN_SDK%\Include;%INCLUDE%
set LIB=%VULKAN_SDK%\Lib;%VULKAN_SDK%\Lib32;%LIB%

REM Add vcpkg paths for GLFW
set VCPKG_ROOT=C:\Users\pluga\Code\vcpkg\installed\x64-windows
set INCLUDE=%VCPKG_ROOT%\include;%INCLUDE%
set LIB=%VCPKG_ROOT%\lib;%LIB%
set PATH=%VCPKG_ROOT%\bin;%PATH%

REM Call Visual Studio build tools
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

REM Create build directory if it doesn't exist
if not exist build mkdir build

REM Build the main program with correct runtime and add shell32.lib
pushd build
cl /EHsc /std:c++17 /MD -Zi -FC -Fe:main.exe ..\src\main.cpp user32.lib gdi32.lib kernel32.lib glfw3.lib Vulkan-1.lib shell32.lib

ECHO "compiling shaders"
%VULKAN_SDK%\Bin\glslc.exe ..\res\shaders\shader.vert -o vert.spv
%VULKAN_SDK%\Bin\glslc.exe ..\res\shaders\shader.frag -o frag.spv
popd
