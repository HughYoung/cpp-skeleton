
include(ExternalProject)

macro(GetGTest)
# Add gtest

set_directory_properties(PROPERTIES EP_PREFIX ${CMAKE_BINARY_DIR}/ThirdParty)

ExternalProject_Add(
    googletest
    URL https://googletest.googlecode.com/files/gtest-1.7.0.zip
    TIMEOUT 20
    # Force separate output paths for debug and release builds to allow easy
    # identification of correct lib in subsequent TARGET_LINK_LIBRARIES commands
    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
               -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG:PATH=DebugLibs
               -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE:PATH=ReleaseLibs
               -Dgtest_force_shared_crt=ON
    # Disable install step
    INSTALL_COMMAND ""
    # Wrap download, configure and build steps in a script to log output
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON)

if(MSVC)
  set(PREFIX "")
  set(SUFFIX ".lib")
else()
  set(PREFIX "lib")
  set(SUFFIX ".a")
endif()

ExternalProject_Get_Property(googletest source_dir)
set(GTEST_FOUND TRUE CACHE INTERNAL "" FORCE)
set(GTEST_INCLUDE_DIR "${source_dir}/include" CACHE STRING "Location of GTest sources" FORCE)
ExternalProject_Get_Property(googletest binary_dir)
set(GTEST_MAIN_LIBRARY "${binary_dir}/ReleaseLibs/${PREFIX}gtest${SUFFIX}" CACHE STRING "" FORCE)
set(GTEST_MAIN_LIBRARY_DEBUG "${binary_dir}/DebugLibs/${PREFIX}gtest_main${SUFFIX}" CACHE STRING "" FORCE)
set(GTEST_LIBRARY "${binary_dir}/ReleaseLibs/${PREFIX}gtest_main${SUFFIX}" CACHE STRING "" FORCE)
set(GTEST_LIBRARY_DEBUG "${binary_dir}/DebugLibs/${PREFIX}gtest_main${SUFFIX}" CACHE STRING "" FORCE)
endmacro()

if(a441_testing_enabled)

  enable_testing()

  # Find them libs!
  if(NOT DEFINED GTEST_USING_EXTERNAL_PROJECT)
    message("attempting to find package gtest...")
    find_package(GTest)
    if(NOT GTEST_FOUND)
      message("failed!")
      set(GTEST_USING_EXTERNAL_PROJECT TRUE CACHE INTERNAL "" FORCE)
    endif()
  endif()
  if(GTEST_USING_EXTERNAL_PROJECT)
    message("attempting to get gtest externally.")
    GetGTest()
    if(CMAKE_BUILD_TYPE MATCHES DEBUG)
      set(GTEST_BOTH_LIBRARIES "${GTEST_MAIN_LIBRARY_DEBUG};${GTEST_LIBRARY_DEBUG}" CACHE STRING "" FORCE)
    else()
      set(GTEST_BOTH_LIBRARIES "${GTEST_MAIN_LIBRARY};${GTEST_LIBRARY}" CACHE STRING "" FORCE)
    endif()
  endif()

  include_directories(${GTEST_INCLUDE_DIR} ${CMAKE_BINARY_DIR})
endif()
