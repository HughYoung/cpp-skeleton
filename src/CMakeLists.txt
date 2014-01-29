project(cppskel)

set( srcs main.cpp )

a441_add_executable( cppskel_hello ${srcs} )

a441_install_targets( cppskel_hello )

set( lib_srcs lib.cpp )
a441_add_library( cppskel_sample_lib ${lib_srcs} )

set( test_srcs test.cpp )
a441_add_test( cppskel_test "${test_srcs}" DEPENDS cppskel_sample_lib 
                                           LINK_LIBRARIES cppskel_sample_lib)
