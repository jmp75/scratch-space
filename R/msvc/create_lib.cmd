@echo OFF

@set THIS_DIR=%~d0%~p0

@call %THIS_DIR%setup_vcpp.cmd

@set DEF_FILE=%1
@if not exist %DEF_FILE% mkdir %LIBDIR32%

@set OUT_FOLDER=%2
@set LIB_NAME_NO_EXT=%3


@set LIBDIR32=.\%OUT_FOLDER%\i386
@set LIBDIR64=.\%OUT_FOLDER%\x64
@if not exist %LIBDIR32% mkdir %LIBDIR32%
@if not exist %LIBDIR64% mkdir %LIBDIR64%

@set LIB_EXE=lib

%LIB_EXE% /nologo /def:%DEF_FILE% /out:%LIBDIR64%\%LIB_NAME_NO_EXT%.lib /machine:x64
%LIB_EXE% /nologo /def:%DEF_FILE% /out:%LIBDIR32%\%LIB_NAME_NO_EXT%.lib /machine:x86

@goto end

:error_no_deffile
@echo ERROR: File not found: %DEF_FILE%.
@exit /B 1

:end
@exit /B 0
