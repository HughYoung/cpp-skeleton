#
# Set a CMAKE_FIRST_RUN flag indicating that this is the first CMake run for
# this build directory.
#
# This allows us to override some default cmake cache values, but only on the
# first run.  On further runs the user is free to change these defaults without
# being overriden.
#
IF(NOT A441_NOT_FIRST_CMAKE_RUN)
        SET(CMAKE_FIRST_RUN ON)
        SET(A441_NOT_FIRST_CMAKE_RUN ON CACHE INTERNAL "Indicate that this is not the first CMake run" FORCE)
ELSE(NOT A441_NOT_FIRST_CMAKE_RUN)
        SET(FIRST_CMAKE_RUN OFF)
ENDIF(NOT A441_NOT_FIRST_CMAKE_RUN)

if (CMAKE_FIRST_RUN)
  # Override default compile flags the first time cmake is run.
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall" CACHE STRING "Flags used by 
  the compiler during all build types." FORCE)
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall" CACHE STRING "Flags for C compiler." FORCE)
endif()

if (NOT CMAKE_BUILD_TYPE)
  set( CMAKE_BUILD_TYPE Release CACHE STRING
       "Choose the type of build, options are: None Debug Release RelWithDebInfo
       MinSizeRel."
       FORCE )
endif()
