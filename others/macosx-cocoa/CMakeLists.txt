cmake_minimum_required(VERSION 3.5)

project(macosx-gui)

# enable ccache
find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
	set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
	set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
endif(CCACHE_FOUND)

file(GLOB_RECURSE src_list "src/*.c*")
file(GLOB_RECURSE src_platform_list "src/*.m*")

# Add an executable with the above sources
add_executable(macosx-gui ${src_list} ${src_platform_list})

include(CheckIncludeFiles)
include(CheckCSourceCompiles)

set(BUILD_TYPE "")
set(flags "")
set(cflags "")
set(ccflags "-std=c++11")

set(WEBVIEW_LIBS "-framework WebKit")
set(COCOA_LIBS "-framework Cocoa")
set(CARBON_LIBS "-framework Carbon")
set(IOKIT_LIBS "-framework IOKit")

set(cflags "${cflags} -DOBJC_OLD_DISPATCH_PROTOTYPES=1")
set(ccflags "${ccflags} -DOBJC_OLD_DISPATCH_PROTOTYPES=1")
set(link_flags "${link_flags} -mmacosx-version-min=10.9 ${WEBVIEW_LIBS} ${COCOA_LIBS}")

set(flags "${flags} -mmacosx-version-min=10.9")

# if(${BUILD_TYPE} STREQUAL "release")
# 	set(flags "${flags} -O3 -s -w -fvisibility=hidden")
#     set(flags "${flags} -fomit-frame-pointer")

# 	set(link_flags "${link_flags} -static-libstdc++")
# 	add_definitions(-DNDEBUG=1)
# endif()

set_source_files_properties(${src_platform_list} PROPERTIES COMPILE_FLAGS "-x objective-c++")

include_directories("${PROJECT_SOURCE_DIR}/include" "${CMAKE_CURRENT_BINARY_DIR}")

set(CMAKE_C_FLAGS "${flags} ${cflags}")
set(CMAKE_CXX_FLAGS "${flags} ${ccflags}")

set_target_properties(macosx-gui PROPERTIES LINK_FLAGS ${link_flags})