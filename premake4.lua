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
            'dep/double-conversion',
            BOOST_ROOT,
        }
        links
        {
            'cpp-json',
            'double-conversion',
        }
        if os.get() == 'windows' then
        defines 
        {
            'WIN32',
            'WIN32_LEAN_AND_MEAN',
            '_WIN32_WINNT=0x0600',
            '_CRT_SECURE_NO_WARNINGS',
            '_SCL_SECURE_NO_WARNINGS',
            'NOMINMAX',
        }
        libdirs
        {
            BOOST_ROOT .. '/stage/lib',
        }
        end
        
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
            'dep/double-conversion',
            BOOST_ROOT,
        }        
        if os.get() == 'windows' then
        defines 
        {
            'WIN32',
            'WIN32_LEAN_AND_MEAN',
            '_WIN32_WINNT=0x0600',
            '_CRT_SECURE_NO_WARNINGS',
            '_SCL_SECURE_NO_WARNINGS',
            'NOMINMAX',
        }
        end
        
    project 'double-conversion'
        location 'build'
        kind 'StaticLib'
        uuid '8701594A-72B8-4a6a-AEF3-6B41BBC33E65'
        files
        {
            'dep/double-conversion/*.cc',
            'dep/double-conversion/*.h',
        }
        includedirs
        {
            'dep/double-conversion',
        }

    
        