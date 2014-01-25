
include(CMakeParseArguments)
include (GenerateExportHeader)

# ----------------------------
# Register a library for compilation. 
# 
# a441_add_library(target_name <src1> <src2> ... <srcN>
#                              [PLUGIN] 
#                              [DEPENDS var1 var2 ... varN]
#                              [LINK_LIBRARIES var1 var2 ... varN]
#                              [TEST_SOURCES src1 src2 ... srcN] )
#
# Parameters:
# PLUGIN - Build library as a dynamically linked module (rather than a shared library)
# DEPENDS - List of dependent projects
# LINK_LIBRARIES - List of libraries to link to
# TEST_SOURCES - List of sources for unit tests (unit tests must be enabled)
# 
macro(a441_add_library target_name)

  cmake_parse_arguments(a441lib "PLUGIN"
                                "" 
                                "DEPENDS;LINK_LIBRARIES;TEST_SOURCES" 
				${ARGN} )

  set(a441lib_type SHARED)
  if(a441lib_PLUGIN)
    set(a441lib_type MODULE)
  endif()

  set(a441lib_srcs ${a441lib_UNPARSED_ARGUMENTS})

  add_library( ${target_name} ${a441lib_type} ${a441lib_srcs} )

  GENERATE_EXPORT_HEADER(${target_name})

  include_directories(${CMAKE_CURRENT_BINARY_DIR})

  if(a441lib_DEPENDS)
    add_dependencies(${target_name} ${a441lib_DEPENDS})
  endif()
  if(a441lib_LINK_LIBRARIES)
    target_link_libraries(${target_name} ${a441lib_LINK_LIBRARIES})
  endif()
  if(a441lib_PLUGIN)
    # For plugins, leave off any standard libraray prefix.
    set_target_properties(${target_name} PROPERTIES PREFIX "")
  else()
    # Only do so-versioning for non-plugins
    set_target_properties(${target_name} PROPERTIES
      SOVERSION ${VERSION_MAJOR}
      VERSION "${VERSION_MAJOR}.${VERSION_MINOR}")
  endif()


  if(a441_testing_enabled AND a441lib_TEST_SOURCES)
    # Make sure the library is linked against the unit test framework
    # Create an executable test runner, and link it to the library.
    set(_a441_testexe_name ${target_name}_test)
    add_executable(${_a441_testexe_name} ${a441lib_TEST_SOURCES})
    add_dependencies(${_a441_testexe_name} ${target_name} googletest)
    target_link_libraries(${_a441_testexe_name} ${target_name} ${GTEST_BOTH_LIBRARIES})
    if(UNIX)
      target_link_libraries(${_a441_testexe_name} pthread)
    endif()
    add_test(${_a441_testexe_name} ${_a441_testexe_name})
  endif()

  
endmacro()

# ------------------------
# Install a target to the default location.
# 
# a441_install_targets target1 target2 ... targetN
#
# Targets can be shared or static libraries, executables, or any combination of the three
macro(a441_install_targets)
  install(TARGETS ${ARGN}
    RUNTIME DESTINATION ${BINDIR} COMPONENT main
    LIBRARY DESTINATION ${LIBDIR} COMPONENT main
    ARCHIVE DESTINATION ${LIBDIR} COMPONENT development)
endmacro()
