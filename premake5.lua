--
-- Premake script (http://premake.github.io)
--

-- https://github.com/ichenq/usr
local USR_ROOT = os.getenv('USR_ROOT') or 'E:/Library/usr'
local BOOST_ROOT = os.getenv('BOOST_ROOT') or 'E:/Library/boost_1_58_0'

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
        includedirs 
        { 
            BOOST_ROOT,
            USR_ROOT .. '/include'
        }
        libdirs
        { 
            BOOST_ROOT .. '/stage/lib',
            USR_ROOT .. '/lib/x86',
        }
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
        files
        {
            'test/*.h',
            'test/*.cpp',
        }
        includedirs
        {
            'src',
        }
        links 
        {   
            'cpp-json',
            'gtest',
        }
        
    project 'cpp-json'
        location    'build'
        kind        'StaticLib'
        includedirs 'src'
        files
        {
            'src/*.h',
            'src/*.cpp',
        }
