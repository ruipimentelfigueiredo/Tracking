project(HybridEstimator)
cmake_minimum_required(VERSION 2.8)
aux_source_directory(. SRC_LIST)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

SET(CMAKE_CXX_FLAGS_DEBUG   "${CMAKE_CXX_FLAGS_DEBUG} -Wall -g -std=c++11") #the -g option is implicit...
SET(CMAKE_CXX_FLAGS_RELEASE "-Wall -O3 -std=c++11")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS_DEBUG}") #Default build mode is release mode

include_directories(.)
add_library(${PROJECT_NAME} ${SRC_LIST})
target_link_libraries( ${PROJECT_NAME})


add_executable(test tests/main.cpp)
target_link_libraries(test ${PROJECT_NAME})
