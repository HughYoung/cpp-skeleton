include(ExternalProject)

macro(GTestQueueDownloadBuild)
  
  set_directory_properties(PROPERTIES EP_PREFIX ${CMAKE_BINARY_DIR}/ThirdParty)
  
  # Modified from http://stackoverflow.com/a/9695234/2930355
  ExternalProject_Add(
    googletest
    URL https://googletest.googlecode.com/files/gtest-1.7.0.zip
    TIMEOUT 20
    # Force separate output paths for debug and release builds to allow easy
    # identification of correct lib in subsequent TARGET_LINK_LIBRARIES commands
    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
               -DBUILD_SHARED_LIBS:BOOL=OFF
               -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG:PATH=DebugLibs
               -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE:PATH=ReleaseLibs
               -Dgtest_force_shared_crt=ON
    # Disable install step
    INSTALL_COMMAND ""
    # Wrap download, configure and build steps in a script to log output
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON )

  set(PREFIX "${CMAKE_STATIC_LIBRARY_PREFIX}")
  set(SUFFIX "${CMAKE_STATIC_LIBRARY_SUFFIX}")


  ExternalProject_Get_Property(googletest source_dir)
  set(GTEST_FOUND TRUE CACHE INTERNAL "" FORCE)
  set(GTEST_INCLUDE_DIR "${source_dir}/include" CACHE STRING "Location of GTest sources" FORCE)
  ExternalProject_Get_Property(googletest binary_dir)
  set(GTEST_MAIN_LIBRARY "${binary_dir}/ReleaseLibs/${PREFIX}gtest${SUFFIX}" CACHE STRING "" FORCE)
  set(GTEST_MAIN_LIBRARY_DEBUG "${binary_dir}/DebugLibs/${PREFIX}gtest_main${SUFFIX}" CACHE STRING "" FORCE)
  set(GTEST_LIBRARY "${binary_dir}/ReleaseLibs/${PREFIX}gtest_main${SUFFIX}" CACHE STRING "" FORCE)
  set(GTEST_LIBRARY_DEBUG "${binary_dir}/DebugLibs/${PREFIX}gtest_main${SUFFIX}" CACHE STRING "" FORCE)
endmacro()

macro(A441_Find_GTest)
  enable_testing()

  # Start by scanning for an already existing GoogleTest package
  find_package(GTest)
  if(NOT GTEST_DOWNLOAD_AND_BUILD)
    if(NOT GTEST_FOUND)
      message(WARNING "Could not find GTest. It will be downloaded and compiled during project build process.")
      option(GTEST_DOWNLOAD_AND_BUILD "Uncheck this and reconfigure this project if you want to use your system's GTest package" ON)
    endif()
  endif()
  
  # If we can't find it, mark it to download and build later.
  if(GTEST_DOWNLOAD_AND_BUILD)
    GTestQueueDownloadBuild()

    # Select the proper set of libraries based on build type
    if(CMAKE_BUILD_TYPE MATCHES Debug)
      set(GTEST_BOTH_LIBRARIES "${GTEST_MAIN_LIBRARY_DEBUG};${GTEST_LIBRARY_DEBUG}" CACHE STRING "" FORCE)
    else()
      set(GTEST_BOTH_LIBRARIES "${GTEST_MAIN_LIBRARY};${GTEST_LIBRARY}" CACHE STRING "" FORCE)
    endif()
  endif()

  include_directories(${GTEST_INCLUDE_DIR})
  # include_directories(${GTEST_INCLUDE_DIR} ${CMAKE_BINARY_DIR})
endmacro()

if(a441_testing_enabled)
  A441_Find_GTest()
endif()
