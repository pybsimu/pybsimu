cmake_minimum_required(VERSION 3.18.2)
project(pybsimu VERSION 1.0)

# C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Common installation directories
include(GNUInstallDirs)

# Use -fPIC even if statically compiled
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# ============
# ibsimu library
# ============
#

#set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
find_library(
    IBSIMU_LIBRARY 
    NAMES ibsimu-1.0.6dev
    HINTS /home/ubuntu/lib)
add_library(pybsimu IMPORTED SHARED GLOBAL)
add_library(pybsimu::pybsimu ALIAS pybsimu)
set_target_properties(pybsimu PROPERTIES IMPORTED_LOCATION ${IBSIMU_LIBRARY})
target_include_directories(pybsimu INTERFACE /home/ubuntu/include/ibsimu-1.0.6dev)


# =======
# Install
# =======

# See official documentation on exporting targets:
# https://cmake.org/cmake/help/latest/guide/importing-exporting/index.html#exporting-targets

# Install the target with C++ code
#install(
#    TARGETS pybsimu
#    EXPORT pybsimuTargets
#    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
#    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install the exported targets
#install(
#    EXPORT pybsimuTargets
#    FILE pybsimuTargets.cmake
#    NAMESPACE pybsimu::
#    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/pybsimu)

# Create a CMake package
include(CMakePackageConfigHelpers)

# Prepare the Config.cmake.in content
set(PACKAGE_INIT_MACRO "@PACKAGE_INIT@")
set(CONFIG_CMAKE_IN "\
@PACKAGE_INIT_MACRO@\n\
include(\"\${CMAKE_CURRENT_LIST_DIR}/pybsimuTargets.cmake\")\n\
check_required_components(pybsimu)\n"
)

# Create Config.cmake.in
file(CONFIGURE
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Config.cmake.in
    CONTENT ${CONFIG_CMAKE_IN}
    @ONLY)

# Create pybsimuConfig.cmake
configure_package_config_file(
    ${CMAKE_CURRENT_BINARY_DIR}/Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/pybsimuConfig.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/pybsimu)

# Create pybsimuConfigVersion.cmake
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/pybsimuConfigVersion.cmake"
    VERSION "${version}"
    COMPATIBILITY AnyNewerVersion
)

# Install CMake package files
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/pybsimuConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/pybsimuConfigVersion.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/pybsimu
)

# ===============
# Python bindings
# ===============

# Find Python3 and NumPy
find_package(Python3 COMPONENTS Interpreter Development.Module REQUIRED)

# Handle where to install the resulting Python package
if(CALL_FROM_SETUP_PY)
    # The CMakeExtension will set CMAKE_INSTALL_PREFIX to the root
    # of the resulting wheel archive
    set(PYBSIMU_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
else()
    # The Python package is installed directly in the folder of the
    # detected interpreter (system, user, or virtualenv)
    set(PYBSIMU_INSTALL_PREFIX ${Python3_SITELIB})
endif()

# =============
# SWIG bindings
# =============

if(EXAMPLE_WITH_SWIG)
    # Rename the executable
    #set_target_properties(print_answer PROPERTIES OUTPUT_NAME print_answer_swig)

    # Add the bindings
    add_subdirectory(bindings_swig)
endif()

# =================
# Pybind11 bindings
# =================

if(EXAMPLE_WITH_PYBIND11)
    # Rename the executable
    set_target_properties(print_answer PROPERTIES OUTPUT_NAME print_answer_pybind11)

    # Add the bindings
    add_subdirectory(bindings_pybind11)
endif()
