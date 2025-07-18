# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "gal")
project(${PROJECT_NAME} LANGUAGES CXX)

# Added by natsuk4ze for c++ 20
set(CMAKE_CXX_STANDARD 20)

# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
cmake_policy(VERSION 3.14...3.25)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "gal_plugin")

# Any new source files that you add to the plugin should be added here.
list(APPEND PLUGIN_SOURCES
  "gal_plugin.cpp"
  "gal_plugin.h"
)

# Define the plugin library target. Its name must not be changed (see comment
# on PLUGIN_NAME above).
add_library(${PLUGIN_NAME} SHARED
  "include/gal/gal_plugin_c_api.h"
  "gal_plugin_c_api.cpp"
  ${PLUGIN_SOURCES}
)

# Added by natsuk4ze for c++ 20
if(MSVC)
  target_compile_options(${PLUGIN_NAME} PRIVATE /await)
endif()

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

# Source include directories and library dependencies. Add any plugin-specific
# dependencies here.
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)

# Add WinRT library support for Windows Runtime APIs
# Required for Flutter 3.32+ and Windows App SDK compatibility
if(WIN32)
  # Link Windows Runtime library for WinRT API support
  # This resolves unresolved symbols for:
  # - WINRT_IMPL_RoGetActivationFactory
  # - WINRT_IMPL_RoOriginateLanguageException
  # - WINRT_IMPL_RoFailFastWithErrorContext
  # - WINRT_IMPL_RoTransformError
  target_link_libraries(${PLUGIN_NAME} PRIVATE windowsapp)
  
  # Optional: Add version check for Windows 10 vs 11 compatibility
  if(CMAKE_SYSTEM_VERSION VERSION_GREATER_EQUAL "10.0.22000")
    # Windows 11 specific optimizations could go here
    message(STATUS "Building for Windows 11 with Windows App SDK compatibility")
  else()
    # Windows 10 compatibility mode
    message(STATUS "Building for Windows 10 with UWP/WinRT compatibility")
  endif()
endif()

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(gal_bundled_libraries
  ""
  PARENT_SCOPE
)
