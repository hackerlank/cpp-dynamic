# cpp-json


Runtime dynamic json type for C++.


## Introduction

This component was taken from [folly](https://github.com/facebook/folly/blob/master/folly/dynamic.h), 
with efforts porting to Visual C++.


## Usage

``` Cpp
dynamic twelve = 12; // creates a dynamic that holds an integer
dynamic str = "string"; // yep, this one is an fbstring

// A few other types.
dynamic nul = nullptr;
dynamic boolean = false;

// Arrays can be initialized with brackets.
dynamic array = { "array ", "of ", 4, " elements" };
assert(array.size() == 4);
dynamic emptyArray = {};
assert(array.empty());

// Maps from dynamics to dynamics are called objects.  The
// dynamic::object constant is how you make an empty map from dynamics
// to dynamics.
dynamic map = dynamic::object;
map["something"] = 12;
map["another_something"] = map["something"] * 2;

// Dynamic objects may be intialized this way
dynamic map2 = dynamic::object("something", 12)("another_something", 24);

// Parsing JSON strings and using them.
std::string jsonDocument = "({\"key\":12,\"key2\":[false, null, true, \"yay\"]})";
dynamic parsed = parseJson(jsonDocument);
assert(parsed["key"] == 12);
assert(parsed["key2"][0] == false);
assert(parsed["key2"][1] == nullptr);

// Building the same document programatically.
dynamic sonOfAJ = dynamic::object
  ("key", 12)
  ("key2", { false, nullptr, true, "yay" });

// Printing.  (See also toPrettyJson)
auto str = toJson(sonOfAJ);
assert(jsonDocument.compare(str) == 0);    
```

## Build

To build the library and test suits(on Windows)

1. Obtain boost library(http://boost.org) 
2. Set environment variable `BOOST_ROOT` as directory path of boost library
3. Build `boost.system` `($BOOST_ROOT)/stage/lib`
4. Run `build-msvc2013.bat` to generate Visual C++ 2013 solution files
5. Build the solution files with Visual Studio 2013(or Visual Studio 2013 express)

