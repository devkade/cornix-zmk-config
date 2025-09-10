# Install script for directory: /Users/kade/Areas/cornix-zmk-config/zephyr/drivers

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/Users/kade/zephyr-sdk-0.17.4/arm-zephyr-eabi/bin/arm-zephyr-eabi-objdump")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/disk/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/interrupt_controller/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/misc/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/pcie/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/usb/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/usb_c/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/adc/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/clock_control/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/flash/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/gpio/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/hwinfo/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/input/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/kscan/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/pinctrl/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/sensor/cmake_install.cmake")
  include("/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/timer/cmake_install.cmake")

endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/kade/Areas/cornix-zmk-config/build/reset/zephyr/drivers/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
