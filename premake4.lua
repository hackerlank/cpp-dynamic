--
-- Premake4 build script (http://industriousone.com/premake/download)
--

local BOOST_ROOT = os.getenv('BOOST_ROOT') or ''

solution 'cpp-json'
    configurations {'Debug', 'Release'}
    language 'C++'
    targetdir 'bin'
    platforms {'x32','x64'}

    configuration 'Debug'
        defines { 'DEBUG' }
        flags { 'Symbols' }

    configuration 'Release'
        defines { 'NDEBUG' }
        flags { 'Symbols', 'Optimize' }

    configuration 'vs*'
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
        libdirs { BOOST_ROOT .. '/stage/lib' }
        links 'ws2_32'        

    configuration 'gmake'
        buildoptions '-std=c++11'
        defines
        {
            '__STDC_LIMIT_MACROS',
            '_ELPP_STACKTRACE_ON_CRASH',
        }

    project 'unittest'
        location 'build'
        kind 'ConsoleApp'
        uuid '31BC2F58-F374-4984-B490-F1F08ED02DD3'
        defines
        {
            'GTEST_HAS_TR1_TUPLE',
        }
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
        links
        {
            'cpp-json',
        }
        
    project 'cpp-json'
        location 'build'
        kind 'StaticLib'
        uuid '23431524-7099-4E72-8D4F-DC4A21F720A8'
        files
        {
            'src/*.h',
            'src/*.cpp',
        }
        includedirs
        {
            'src',
        }
