cmake_minimum_required(VERSION 3.15)
project(IU_F19_CC_Assignment3 C)

set(CMAKE_C_STANDARD 99)

set(_TEST_FILE program.toy)

set(_PARSER_SOURCE toy.y)
set(_LEXER_SOURCE toy.l)

set(_PARSER_TARGET ToyParser)
set(_LEXER_TARGET ToyLexer)


SET(BISON_${_PARSER_TARGET}_COMPILE_FLAGS "${BISON_${_PARSER_TARGET}_COMPILE_FLAGS}")
SET(FLEX_${_LEXER_TARGET}_COMPILE_FLAGS "${FLEX_${_LEXER_TARGET}_COMPILE_FLAGS}")

find_package(BISON)
find_package(FLEX)
BISON_TARGET(${_PARSER_TARGET} ${_PARSER_SOURCE} ${CMAKE_CURRENT_BINARY_DIR}/toy_parser.c)
FLEX_TARGET(${_LEXER_TARGET} ${_LEXER_SOURCE} ${CMAKE_CURRENT_BINARY_DIR}/toy_lexer.c)


ADD_FLEX_BISON_DEPENDENCY(${_LEXER_TARGET} ${_PARSER_TARGET})

include_directories(${CMAKE_CURRENT_BINARY_DIR})

configure_file(${_TEST_FILE} program.toy COPYONLY)
add_executable(IU_F19_CC_Assignment3
        ${BISON_ToyParser_OUTPUTS}
        ${FLEX_ToyLexer_OUTPUTS}
        )
