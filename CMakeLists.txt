##
# CPP Skeleton Project
# By Studio A441
# (C) 2014 Hugh Young

cmake_minimum_required(VERSION 2.8)

#Set your project name here
project(a441_all)

#Set ON to enable unit testing by default
option(a441_testing_enabled "Enable unit testing" OFF)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(A441FirstRun)
include(A441Macros)
include(A441Skeleton)
include(A441Testing)

set(VERSION_MAJOR 0)
set(VERSION_MINOR 0)
set(VERSION_BUILD 0)

#Add new subdirectories here
add_subdirectory(src)
