# [F19] Compiler Construction - Assignment 3

*Innopolis University, 2019*<br>
*Compiler Construction, 3rd year, 1st semester*<br>

**Author:**<br>
Gleb Petrakov

## Description

This is the third assignment of the Compiler Construction course, Innopolis University.

Task: implement parser for Toy language using lex/flex and yacc/bison.


## Running

You will need to run latest generic flex and bison for program to work properly.

### GitHub Actions
You can see output in GitHub Actions tab of the repository.<br>
Workflow triggered on push only (GitHub limitation).


### CMake
You will need something, that can build with CMake, CLion from JetBrains for example.
Or you can try to build it by hand.

### Manually
Just run `./build.sh` and `./toy.out`.


## Testing

Parser takes input from `program.toy` file, so put it there.
Or just change the `CMakeLists.txt` variable.

