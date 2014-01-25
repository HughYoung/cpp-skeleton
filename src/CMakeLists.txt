project(cppskel)

set( srcs file_1.cpp
          file_2.cpp )

set( hdrs file_1.h
          file_2.h )

set( test_srcs test/test_1.cpp
               test/test_2.cpp )

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

a441_add_library( a441manuscript ${srcs} TEST_SOURCES ${test_srcs} )

a441_install_targets( a441manuscript )
