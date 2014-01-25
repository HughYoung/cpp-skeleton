
# TODO: localize to oses
set(BINDIR bin)
set(LIBDIR lib)

# Make sure that CMAKE_INSTALL_PREFIX is absolute.  If we don't do this, it
# seems that we get relative values for the RPATH (which making
# CMAKE_INSTALL_RPATH absolute doesn't help??), which results in broken
# binaries.
if(NOT IS_ABSOLUTE ${CMAKE_INSTALL_PREFIX})
  message(STATUS "Warning: CMAKE_INSTALL_PREFIX relative path interpreted relative to 
  build directory location.")
  set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_PREFIX}")
endif()
