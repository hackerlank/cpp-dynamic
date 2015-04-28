--
-- Premake script (http://premake.github.io)
--

local BOOST_ROOT = os.getenv('BOOST_ROOT') or ''

solution 'cpp-json'
    configurations  {'Debug', 'Release'}
    language        'C++'
    targetdir       'bin'

    filter 'configurations:Debug'
        defines     { 'DEBUG' }
        flags       { 'Symbols' }

    filter 'configurations:Release'
        defines     { 'NDEBUG' }
        flags       { 'Symbols', 'Optimize' }

    filter 'action:vs*'
        defines
        {
            'WIN32',
            'WIN32_LEAN_AND_MEAN',
            '_WIN32_WINNT=0x0600',
            '_CRT_SECURE_NO_WARNINGS',
            '_SCL_SECURE_NO_WARNINGS',
            'NOMINMAX',
        }
        includedirs { BOOST_ROOT }
        libdirs     { BOOST_ROOT .. '/stage/lib' }
        links       'ws2_32'        

    filter 'action:gmake'
        buildoptions    '-std=c++11'
        links           'pthread'
        defines
        {
            '__STDC_LIMIT_MACROS',
            '_ELPP_STACKTRACE_ON_CRASH',
        }

    project 'unittest'
        location    'build'
        kind        'ConsoleApp'
        defines     'GTEST_HAS_TR1_TUPLE'
        files
        {
            'dep/gtest/src/gtest-all.cc',
            'test/*.h',
            'test/*.cpp',
        }
        includedirs
        {
            'src',
            'dep/gtest',
            'dep/gtest/include',
        }
        links 'cpp-json'
        
    project 'cpp-json'
        location    'build'
        kind        'StaticLib'
        includedirs 'src'
        files
        {
            'src/*.h',
            'src/*.cpp',
        }
