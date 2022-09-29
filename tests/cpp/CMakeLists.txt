project(HelloWorld)
cmake_minimum_required(VERSION 3.0)

include_directories(include)

add_executable(hello_world main.cpp helpers.cpp)
