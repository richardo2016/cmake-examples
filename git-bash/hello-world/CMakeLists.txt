cmake_minimum_required(VERSION 3.5)

find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
	set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
	set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
endif(CCACHE_FOUND)

project(hello-world)

file(GLOB_RECURSE SOURCE "src/*.c*")

add_executable(${PROJECT_NAME} ${SOURCE})