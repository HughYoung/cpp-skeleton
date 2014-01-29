
include(CMakeParseArguments)
include (GenerateExportHeader)

# ----------------------------
# Register an executable for compilation.
# 
# a441_add_executable(target_name <src1> <src2> ... <srcN>
#                           [DEPENDS var1 var2 ... varN]
#                           [LINK_LIBRARIES var1 var2 ... varN] )
#
macro(a441_add_executable target_name)

  cmake_parse_arguments(a441exe ""
                                "" 
                                "DEPENDS;LINK_LIBRARIES" 
				${ARGN} )

  set(a441exe_srcs ${a441exe_UNPARSED_ARGUMENTS})

  add_executable( ${target_name} ${a441exe_srcs} )

  if(a441exe_DEPENDS)
    add_dependencies(${target_name} ${a441exe_DEPENDS})
  endif()
  if(a441exe_LINK_LIBRARIES)
    target_link_libraries(${target_name} ${a441exe_LINK_LIBRARIES})
  endif()
endmacro()

# ----------------------------
# Helper function to add a test.  Registers executable for compilation,
# links to GoogleTest and calls add_test.
# 
# a441_add_test(target_name <src1> <src2> ... <srcN>
#                           [DEPENDS var1 var2 ... varN]
#                           [LINK_LIBRARIES var1 var2 ... varN] )
#
# 
#
macro(a441_add_test target_name)
    cmake_parse_arguments(a441test ""
                                "" 
                                "DEPENDS;LINK_LIBRARIES" 
				${ARGN} )

    list(APPEND a441test_LINK_LIBRARIES "${GTEST_BOTH_LIBRARIES}")

    if(UNIX)
      list(APPEND a441test_LINK_LIBRARIES pthread)
    endif()    

    a441_add_executable(${target_name} "${a441test_UNPARSED_ARGUMENTS}"
                                       DEPENDS "${a441test_DEPENDS}" 
                                       LINK_LIBRARIES "${a441test_LINK_LIBRARIES}" )
    add_test(${target_name} ${target_name})
  
endmacro()

# ----------------------------
# Register a library for compilation. 
# 
# a441_add_library(target_name <src1> <src2> ... <srcN>
#                              [PLUGIN] 
#                              [DEPENDS var1 var2 ... varN]
#                              [LINK_LIBRARIES var1 var2 ... varN] )
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
                                "DEPENDS;LINK_LIBRARIES" 
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
