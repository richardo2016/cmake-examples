# Set the minimum version of CMake that can be used
# To find the cmake version run
# $ cmake --version
cmake_minimum_required(VERSION 3.5)

# Set the project name
project (atomic-test)

file(GLOB_RECURSE src_list "src/*.c*")
# Create a sources variable with a link to all cpp files to compile

set(CMAKE_CXX_FLAGS "-std=c++11")

# Add an executable with the above sources
add_executable(atomic-test ${src_list})

# Set the directories that should be included in the build command for this target
# when running g++ these will be included as -I/directory/path/
target_include_directories(atomic-test
    PRIVATE 
        ${PROJECT_SOURCE_DIR}/include
)
