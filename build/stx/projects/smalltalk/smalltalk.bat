@ECHO OFF

::  _____                 _ _ _        _ _         ____   __               
:: /  ___|               | | | |      | | |       / /\ \ / /               
:: \ `--. _ __ ___   __ _| | | |_ __ _| | | __   / /  \ V /                
::  `--. \ '_ ` _ \ / _` | | | __/ _` | | |/ /  / /   /   \                
:: /\__/ / | | | | | (_| | | | || (_| | |   <  / /   / /^\ \               
:: \____/|_| |_| |_|\__,_|_|_|\__\__,_|_|_|\_\/_/    \/   \/               
::                                                                         
::  _    _ _                  _                            _               
:: | |  | (_)                | |                          | |              
:: | |  | |_ _ __    ______  | |     __ _ _   _ _ __   ___| |__   ___ _ __ 
:: | |/\| | | '_ \  |______| | |    / _` | | | | '_ \ / __| '_ \ / _ \ '__|
:: \  /\  / | | | |          | |___| (_| | |_| | | | | (__| | | |  __/ |   
::  \/  \/|_|_| |_|          \_____/\__,_|\__,_|_| |_|\___|_| |_|\___|_|

:: ==================================
:: The startup script for smalltalk =
:: ==================================
:: This script is vastly improved previous smalltalk.bat.
:: In previous versions, smalltalk used to be the executable itself.
:: This lead to problems on systems, where things like the PATH or STX_LIBDIR should be set in advance.
:: Now, here is a place to do such things ...

:: ==========
:: Contents =
:: ==========
:: Every section is separated by these words: Next section follows =

:: 1 - Versions; batch files switches; setting on ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
:: 2 - Configuration
:: 3 - PowerShell detection
:: 4 - Timer section
:: 5 - Adjusting according to the configuration
:: 6 - Checking variable and logic consistency
:: 7 - Verify existence of paths and files from configuration
:: 8 - A work-flow based on the configuration
:: 9 - Running the command
:: 10 - User defined functions
:: 11 - Support information (like help, about, version)


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: *******************************************************************************************
:: Beginning                                                                                 *
:: *******************************************************************************************

:: ==========
:: Versions =
:: ==========
:: This script
SET "batch_script_version=1.6.8"
:: Smalltalk/X
SET "stx_version_default=8.0.0"
:: Do not change following line, $STX_VERSION_DEFAULT serves
:: as placeholder and it's being replaced during installation
:: process (`rake install`)
SET "stx_version=%stx_version_default%"

:: ====================
:: Comments and style =
:: ====================
:: USING :: instead of REM is a hack for now supported and it makes the bat execution much faster
:: The reason is: REM is a command that has to be processed by cmd.exe, but the :: is a sign followed
:: by :.  The first : makes the interpreter ignore the line altogether.

:: If Microsoft should drop support of :: hack. Change you have to change all :: back to REM

:: =========================================
:: Batch file accepts following parameters =
:: =========================================
:: Enclosing the input parameter with double quotes is a correct way how to do it

IF "%~1"=="--help" ECHO: & ECHO "stx.com help, for the laucher use --help-launcher." & ECHO: & GOTO stx_help
IF "%~1"=="-h" ECHO: & ECHO "stx.com help, for the laucher use --help-launcher." & ECHO: & GOTO stx_help
IF "%~1"=="/h" ECHO: & ECHO "stx.com help, for the laucher use --help-launcher." & GOTO stx_help
IF "%~1"=="/?" ECHO: & ECHO "stx.com help, for the laucher use --help-launcher." & GOTO stx_help

IF "%~1"=="--help-launcher" ECHO: & GOTO stx_help_launcher
IF "%~1"=="-h-l" ECHO: & GOTO stx_help_launcher
IF "%~1"=="/h-l" ECHO: & GOTO stx_help_launcher

IF "%~1"=="--about" (
    ECHO: & CALL :stx_about %batch_script_version% %stx_version%
    GOTO :EOF
)
IF "%~1"=="-a" (
    ECHO: & CALL :stx_about %batch_script_version% %stx_version%
    GOTO :EOF
)
IF "%~1"=="/a" (
    ECHO: & CALL :stx_about %batch_script_version% %stx_version%
    GOTO :EOF
)

IF "%~1"=="--version" (
    ECHO: & CALL :stx_version %batch_script_version% %stx_version%
    GOTO :EOF
)
IF "%~1"=="-v" (
    ECHO: & CALL :stx_version %batch_script_version% %stx_version%
    GOTO :EOF
)
IF "%~1"=="/v" (
    ECHO: & CALL :stx_version %batch_script_version% %stx_version%
    GOTO :EOF
)

:: ==================
:: Batch file flags =
:: ==================
:: Here for the correct deletion of the filled variables when script finishes
:: ENABLEEXTENSIONS - enable or disable command processor extensions. These
:: arguments takes precedence over the CMD /E:ON or /E:OFF
:: ENABLEDELAYEDEXPANSION - enable or disable delayed environment variable
:: expansion. These arguments takes precedence over the CMD /V:ON or /V:OFF switches.
VERIFY OTHER 2>nul
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
IF ERRORLEVEL 1 (
    REM No color as expansion is not yet enabled
    ECHO "Unable to enable extensions.  Fix it."
    SET "exit_value=1"
    GOTO exit_sequence 
)


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: *******************************************************************************************
:: Configuration                                                                             *
:: *******************************************************************************************
:: Now all the variables except the for configuration file are in the configuration file.
:: For more see variable configuration_file_path

:: ==================================
:: Clearing the shell prior the run =
:: ==================================
::CLS

:: ===========================================
:: Reading variables from external .cfg file =
:: ===========================================
:: The only variable that can not be validated (be careful when changing it^!)
:: The reason is that it is before the validation process
SET "configuration_file_path=%~dp0"
SET "configuration_file=smalltalk.cfg"
SET "configuration_file_with_path=!configuration_file_path!!configuration_file!"
IF NOT EXIST !configuration_file_with_path! (
    SET "message="Smalltalk configuration file: !configuration_file! not found. Fix it.""
    SET "__numeric.exit_value=1"
    CALL :exit_sequence !message!
    GOTO :EOF
)

:: EOL stops comments from being parsed
:: otherwise split lines at the = char into two tokens
FOR /F "EOL=# delims== tokens=1,*" %%A IN (!configuration_file_with_path!) DO (
    REM proper lines have both a and b set
    REM if okay, assign property to some kind of namespace
    REM so some.property becomes test.some.property in batch-land
    IF NOT "%%A"=="" IF NOT "%%B"=="" SET "stx.%%A=%%B"
)


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:: =============
:: Start timer =
:: =============
IF "!stx.__binary.use_timer!"=="TRUE" (
    CALL :time_in_seconds __start
    ECHO:
    ECHO "[INFO] Start timer. START at: !__start! [seconds]"
    ECHO:
    
)


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:: To see stx. namespace uncomment below
:: SET "stx."

:: =================================================
:: Expanding variables from the configuration file =
:: =================================================
:: Variable needs expanding if shell pseudo-variable is used e.g. ...dp0

:: ===================
:: Stx bin directory =
:: ===================
IF NOT "!stx.stx_bin_dir!"=="" (
    CALL :expand_path !stx.stx_bin_dir! stx.stx_bin_dir
    IF ERRORLEVEL 1 (
        ECHO "[ERROR] -> stx.stx_bin_dir <- variable error in  check your configuration file -> !stx.stx_bin_dir! <-"
        GOTO :EOF 
    )
)

:: ===================================
:: Stx quick start and image details =
:: ===================================
IF NOT "!stx.image_path!"=="" (
    CALL :expand_path !stx.image_path! stx.image_path
    IF ERRORLEVEL 1 (
        ECHO "[ERROR] -> stx.image_path <- variable error in  check your configuration file -> !stx.image_path! <-"
        GOTO :EOF 
    )
)

:: =============
:: Stx logging =
:: =============
IF NOT "!stx.log_directory!"=="" (
    CALL :expand_path !stx.log_directory! stx.log_directory
    IF ERRORLEVEL 1 (
        ECHO "[ERROR] -> stx.log_directory <- variable error in  check your configuration file -> !stx.log_directory! <-"
        GOTO :EOF 
    )
)

:: ==================================================================================
:: Script's internal variables                                                      =
:: WARNING: DO NOT TOUCH THE SET VALUES BELOW UNLESS YOU KNOW WHAT YOU ARE DOING!!! =
:: ==================================================================================
:: minimal powershell version, otherwise fall-back is triggered
:: The path for powershell contains v1.0 for all powershell versions!!!!
SET "minimal_powershell_version=2.0"
:: this variable is directly accessed also in powershell file
SET "powershell_version_all_functionality=3.0"
SET "PowerShellVersion="""
SET "RuntimeVersion="""

:: Setting powershell script path and filename
SET "powershell_script_path=%~dp0"
SET "powershell_file=smalltalk.ps1"
SET "powershell_script_file=!powershell_script_path!!powershell_file!"

:: Fallback option must be always active
SET "__binary.powershell_detected=FALSE"

:: Default value is not to use stx command-line switches
SET "stx_manual_switch_detected=FALSE"

:: default script exit value ^(^=0 - everything OK, ^<^>0 - not OK^)
SET "__numeric.exit_value=0"

:: Make sure variable is undefined
SET "internal_runtime_options="

:: Used for switches enter by user at command-line,
:: making sure variable is undefined at the beginning
:: This variable is accessed directly from powershell file
SET "stx_switch="

:: Make sure variable is undefined
SET "stx_date_time="


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: *******************************************************************************************
:: PowerShell detection                                                                      *
:: *******************************************************************************************

:: =============================================
:: Calling user function :powershell_detection =
:: =============================================
CALL :powershell_detection __binary.powershell_detected PowerShellVersion RuntimeVersion

:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: *******************************************************************************************
:: Adjusting according to the configuration                                                  *
:: *******************************************************************************************

:: =============
:: Shell Color =
:: =============
IF "!stx.__binary.colored_stdout!"=="TRUE" (
    IF "!__binary.powershell_detected!"=="TRUE" (
        SET "use_color=TRUE"
    ) ELSE (
        SET "use_color=FALSE"
    )
) ELSE (
    SET "use_color=FALSE"
)

:: ============
:: Image name =
:: ============
SET "default_image_name="!stx.image_name:"=!!stx.image_suffix:"=!""

:: ============================
:: Add encoding to the suffix =
:: ============================
:: Allowed values ASCII, UTF8 (default), UTF16 (in Microsoft world that is called Unicode), UTF32
:: Note: If UTF16 is used you can view log file while StX is running, in all other cases you have to close StX before viewing the file
IF "!stx.log_file_encoding!"=="ASCII" (
    SET "stx.log_suffix="_ascii!stx.log_suffix:"=!""
) ELSE IF "!stx.log_file_encoding!"=="UTF8" (
    SET "stx.log_suffix="_utf8!stx.log_suffix:"=!""
) ELSE IF "!stx.log_file_encoding!"=="UTF16" (
    SET "stx.log_suffix="_utf16!stx.log_suffix:"=!""
) ELSE IF "!stx.log_file_encoding!"=="UTF32" (
    SET "stx.log_suffix="_utf32!stx.log_suffix:"=!""
) ELSE (
    SET "message="Invalid log file encoding: !stx.log_file_encoding!. Fix it and run the script again.""
    SET "__numeric.exit_value=1"
    CALL :exit_sequence !message!
    GOTO :EOF
)

:: =================================================
:: UTF16 alias Microsoft's Unicode name conversion =
:: =================================================
IF "!stx.log_file_encoding!"=="UTF16" (
    SET "stx.log_file_encoding=Unicode"
)

:: =================
:: Log file format =
:: =================
:: Using wmic os get as it is probably the only locales independent way to get time on Windows
:: Date: Using date ISO 8601 format YYYY-MM-DD with time part
:: Time: Using time and date format independent of locales
:: Note: back ticks are there for powershell compatibility
IF "!stx.__binary.log_add_datepart!"=="TRUE" (
    FOR /F %%A IN ('wmic os get LocalDateTime ^| find "."') DO SET "dts=%%A"
    SET "stx_date_time=!dts:~0,4!-!dts:~4,2!-!dts:~6,2!"
    IF "!stx.__binary.log_add_timepart!"=="TRUE" (
        SET "stx_date_time=!stx_date_time!_!dts:~8,2!"`;"!dts:~10,2!"`;"!dts:~12,2!"
    )
    SET "log_filename="!stx.log_name:"=!_!stx_date_time!!stx.log_suffix:"=!""
) ELSE (
    FOR /F %%A IN ('wmic os get LocalDateTime ^| find "."') DO SET "dts=%%A"
    IF "!stx.__binary.log_add_timepart!"=="TRUE" (
        SET "stx_date_time=!dts:~8,2!"`;"!dts:~10,2!"`;"!dts:~12,2!"
        SET "log_filename="!stx.log_name:"=!_!stx_date_time!!stx.log_suffix:"=!""
    ) ELSE (
        SET "log_filename="!stx.log_name:"=!!stx.log_suffix:"=!""
    )
)

:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: *******************************************************************************************
:: Checking variable and logic consistency                                                   *
:: *******************************************************************************************

:: ==============================================
:: Checking the PowerShell file (.ps1) presence =
:: ==============================================
IF NOT EXIST "!powershell_script_file!" (
    SET "message="PowerShell file missing: !powershell_script_path!smalltalk.ps1.  Fix it.""
    SET "__numeric.exit_value=1"
    CALL :exit_sequence !message!
    GOTO :EOF
)


:: =======================
:: Variables' validation =
:: =======================
IF "!stx.verify_variables_syntax!"=="TRUE" (
    REM must be used (inside IF^^!)
    REM =====================================================================
    REM Validate __binary for TRUE^/FALSE and if it does not contain spaces =
    REM =====================================================================
    REM Checks if the variable contains correctly written TRUE^/FALSE
    REM additionally it also checks if additional space was not added by mistake
    REM var -7 extracts the last 7 characters from var
    FOR /F "tokens=3 delims=^." %%A IN ('SET stx.__binary.') DO (
        SET "temp_test=%%A"
        IF "!temp_test:~-5!"=="=TRUE" (
            IF NOT "!temp_test!"=="!temp_test: =!" (
                SET "__numeric.exit_value=1"
                SET "first_message="Incorrect configuration additional space detected.""
                SET "first_message="Correct the variable: __binary.!temp_test!""
                CALL :exit_sequence !first_message! !second_message!
                GOTO :EOF
            )
        ) ELSE IF "!temp_test:~-6!"=="=FALSE" (
            IF NOT "!temp_test!"=="!temp_test: =!" (
                SET "__numeric.exit_value=1"
                SET "first_message="Incorrect configuration additional space detected.""
                SET "second_message="Correct the variable: __binary.!temp_test!""
                CALL :exit_sequence !first_message! !second_message!
                GOTO :EOF
            )
        ) ELSE (
            IF NOT "!temp_test!"=="!temp_test: =!" (
                SET "__numeric.exit_value=1"
                SET "first_message="Incorrect configuration additional space detected.""
                SET "second_message="Correct the variable: __binary.!temp_test!""
                CALL :exit_sequence !first_message! !second_message!
                GOTO :EOF
            ) ELSE (
                SET "first_message="Incorrect configuration mistake in TRUE^/FALSE detected.""
                SET "second_message="Correct the variable: __binary.!temp_test!""
                SET "__numeric.exit_value=1"
                CALL :exit_sequence !first_message! !second_message!
                GOTO :EOF
            )
        )
    )
    
    REM must be used (inside IF^^!)
    REM  ===================================================================
    REM  Validate if __binary values are numeric and do not contain spaces =
    REM  ===================================================================
    REM 1. FOR - variable extraction bla value
    REM 2. FOR - extracting integer value
    REM 3. FOR - testing integer
    FOR /F "tokens=3 delims=^." %%A IN ('SET stx.__numeric.') DO (
        SET "temp_test=%%A"
        FOR /F "tokens=2 delims==" %%B IN ("!temp_test!") DO SET "test_integer=%%B"
        SET "ugh="&FOR /F "delims=0123456789" %%C IN ("!test_integer!") DO SET "ugh=%%~C"
        IF defined ugh (
            IF NOT "!temp_test!"=="!temp_test: =!" (
                SET "__numeric.exit_value=1"
                SET "first_message="Incorrect configuration additional space detected.""
                SET "second_message="Correct the variable: __binary.!temp_test!""
                CALL :exit_sequence !first_message! !second_message!
                GOTO :EOF
            ) ELSE (
                SET "__numeric.exit_value=1"
                SET "message="Incorrect configuration detected - integer value is not an integer.""
                CALL :exit_sequence !message!
                GOTO :EOF
            )
        ) ELSE (
              IF NOT "!temp_test!"=="!temp_test: =!" (
                  SET "__numeric.exit_value=1"
                  SET "first_message="Incorrect configuration additional space detected.""
                  SET "second_message="Correct the variable: __binary.!temp_test!""
                  CALL :exit_sequence !first_message! !second_message!
                  GOTO :EOF
              )
        )
    )
    REM must be used (inside IF^^!)
    REM ===============================================================
    REM Validate path variables to contain double quotes or backslash =
    REM ===============================================================

    REM ========================================================
    REM Check beginning of the string to contain double quotes =
    REM ========================================================
    REM Checking image variables
    SET "correct_substring=!stx.image_name:~0,1!"
    IF NOT !correct_substring!==^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected missing double quotes at stx.image_name variable: - !stx.image_name! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    SET "correct_substring=!stx.image_suffix:~0,1!"
    IF NOT !correct_substring!==^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected missing double quotes at stx.image_suffix variable: - !stx.image_suffix! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )

    REM Checking logging variables
    SET "correct_substring=!stx.log_name:~0,1!"
    IF NOT !correct_substring!==^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected missing double quotes at stx.log_name variable: - !stx.log_name! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    SET "correct_substring=!stx.log_suffix:~0,1!"
    IF NOT !correct_substring!==^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected missing double quotes at stx.log_suffix variable: - !stx.log_suffix! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    SET "correct_substring=!log_filename:~0,1!"
    IF NOT !correct_substring!==^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected missing double quotes at log_filename variable: - !log_filename! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    REM clearing temp variable
    SET "correct_substring="
    
    REM ===========================================================================================
    REM Checking string's end to contain either backslash and double quotes or just double quotes =
    REM ===========================================================================================
    REM Checking image variables
    IF NOT !stx.stx_bin_dir:~-2!==\^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected.  Missing backslash at variable stx.stx_bin_dir: - !stx.stx_bin_dir! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )

    REM Checking image variables
    IF NOT !stx.image_path:~-2!==\^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected.  Missing backslash at variable stx.image_path: - !stx.image_path! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    IF NOT !stx.image_name:~-1!==^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected missing double quotes at stx.image_name variable: - !stx.image_name! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    IF NOT !stx.image_suffix:~-1!==^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected missing double quotes at stx.image_suffix variable: - !stx.image_suffix! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )

    REM Checking logging variables
    IF NOT !stx.log_directory:~-2!==\^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected.  Missing backslash at variable stx.log_directory: - !stx.log_directory! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    IF NOT !stx.log_name:~-1!==^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected missing double quotes at stx.log_name variable: - !stx.log_name! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    IF NOT !stx.log_suffix:~-1!==^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected missing double quotes at stx.log_suffix variable: - !stx.log_suffix! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    IF NOT !log_filename:~-1!==^" (
        SET "__numeric.exit_value=1"
        SET "message="Incorrect configuration detected missing double quotes at log_filename variable: - !log_filename! -""
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    REM must be used (inside IF^^!)
    REM ===========================================
    REM Print validation message if user wants to =
    REM ===========================================
    IF "!stx.verify_print_message!"=="TRUE" (
        CALL :print_message !use_color! !stx.stdout_VerboseBackgroundColor! !stx.stdout_VerboseForegroundColor! "===============================" "Variable syntax validated.    =" "==============================="
        ECHO:
    )
)

:: =============
:: Quick start =
:: =============
:: Note: quick start should not be used with image functionality
:: If there is a mistake in image functionality (start_with_image=FALSE and list_available_images=TRUE)
:: THEN quick start is used
IF "!stx.__binary.stx_quick_start!"=="TRUE" (
    IF "!stx.__binary.start_with_image!"=="TRUE" (
        CALL :print_message !use_color! !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] Your configuration flawed - compensating." "[WARN] stx_quick_start=TRUE AND start_with_image=TRUE which makes no sense."
        ECHO:
        SET "stx.__binary.stx_quick_start=FALSE"
    ) ELSE IF "!stx.__binary.list_available_images!"=="TRUE" (
        CALL :print_message !use_color! !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] Your configuration flawed - compensating." "[WARN] start_with_image=FALSE, list_available_images=TRUE, AND stx_quick_start=TRUE which makes no sense." "[WARN] Using only stx_quick_start=TRUE"
        ECHO:
        SET "stx.__binary.list_available_images=FALSE"
    )
)

:: ==========================================================================
:: Pair stx.__binary.start_with_image ^& stx.__binary.list_available_images =
:: ==========================================================================
:: NOTE: not using :print_message -> sending too many messages
IF "!stx.__binary.start_with_image!"=="FALSE" (
    IF "!stx.__binary.list_available_images!"=="TRUE" (
        IF "!use_color!"=="TRUE" (
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] Your configuration flawed - compensating."
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] start_with_image=FALSE AND list_available_images=TRUE which makes no sense."
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] Setting list_available_images=FALSE."
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] To fix it either set start_with_image=TRUE or list_available_images=FALSE"
        ) ELSE (
            ECHO "[WARN] Your configuration flawed - compensating."
            ECHO "[WARN] start_with_image=FALSE AND list_available_images=TRUE which makes no sense."
            ECHO "[WARN] Setting list_available_images=FALSE."
            ECHO "[WARN] To fix it either set start_with_image=TRUE or list_available_images=FALSE"
        )
        ECHO:
        SET "stx.__binary.list_available_images=FALSE"
    )
)

:: ============================================================================================
:: Pair variables (work together) stx.__binary.record_log_file and stx.__binary.append_to_log =
:: ============================================================================================
:: NOTE: not using :print_message -> sending too many messages
IF "!stx.__binary.record_log_file!"=="FALSE" (
    IF "!stx.__binary.append_to_log!"=="TRUE" (
        ECHO:
        IF "!use_color!"=="TRUE" (
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] Your configuration flawed - compensating."
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] record_log_file=FALSE AND append_to_log=TRUE which makes no sense."
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] Setting append_to_log=FALSE."
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] To fix it either set record_log_file=TRUE or append_to_log=FALSE"
        ) ELSE (
            ECHO "[WARN] Your configuration flawed - compensating."
            ECHO "[WARN] record_log_file=FALSE AND append_to_log=TRUE which makes no sense."
            ECHO "[WARN] Setting append_to_log=FALSE."
            ECHO "[WARN] To fix it either set record_log_file=TRUE or append_to_log=FALSE"
        )
        ECHO:
        SET "stx.__binary.append_to_log=FALSE"
    )
)


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: *******************************************************************************************
:: Verify existence of paths and files from configuration                                    *
:: *******************************************************************************************

:: ===================================================
:: Selecting an executable                           =
:: Checking for a presence of %smalltalk_executable% =
:: ===================================================
:: Your path to smalltalk & and exec (bat,cmd,com,exe, etc.)
:: change the line below, if the support stuff is not found in the
:: directory where stx-bin.com / stx.com resides.  (exe is for GUI only)
:: STX_LIB_DIR=<path_to_support_files>

:: Change to the specified bin directory
pushd "!stx.stx_bin_dir!"
IF EXIST "stx-bin.com" (
    IF "!stx.__binary.run_via_shell!"=="TRUE" (
        SET "selected_executable=stx-bin.com"
     ) ELSE (
        SET "selected_executable=stx-bin.exe"
     )
    SET "stx_home=!stx.stx_bin_dir:"=!.."
    SET "stx_topdir=!stx.stx_bin_dir:"=!..\lib\smalltalkx\!stx_version!"
    SET "stx_libdir=!stx.stx_bin_dir:"=!..\lib\smalltalkx\!stx_version!\lib"
    SET "stx_packagepath=!stx.stx_bin_dir:"=!..\lib\smalltalkx\!stx_version!\packages"
    SET "smalltalk_executable=!stx.stx_bin_dir:"=!!selected_executable!"
) ELSE IF EXIST "stx.com" (
     IF "!stx.__binary.run_via_shell!"=="TRUE" (
        SET "selected_executable=stx.com"
     ) ELSE (
        SET "selected_executable=stx.exe"
     )
    SET "smalltalk_executable="!stx.stx_bin_dir:"=!!selected_executable!""
) ELSE (

    SET "message="The executable stx-bin^.com;exe perhaps stx^.com;exe NOT found.""
    SET "__numeric.exit_value=1"
    CALL :exit_sequence !message!
    GOTO :EOF
)
:: return back
popd

:: ==========================================================================================
:: Checking if the image at the path really exists.                                         =
:: using temporary variable due to the fact that NOT exists needs already expanded variable =
:: ==========================================================================================
SET "temp_stx.image_path=!stx.image_path:"=!!default_image_name:"=!"

IF "!stx.__binary.start_with_image!"=="TRUE" (
    IF "!stx.__binary.list_available_images!"=="FALSE" (
        IF NOT EXIST "!temp_stx.image_path!" (
            REM TOO DEEP MUST FIX
            REM CALL :colorEcho stx.stdout_cmd_warning "[WARN] The default image: !stx.image_path:"=!!default_image_name:"=! was not found."
            REM CALL :colorEcho stx.stdout_cmd_warning "[WARN] No image will loaded. If you want to load from image fix your path or image name."
            ECHO:
            SET "stx.__binary.start_with_image=FALSE"
        )
    )
)

:: clearing temp variable
SET "temp_stx.image_path="

:: ===============================================================================
:: Checking existence of logging directory, if not found all logging is disabled =
:: ===============================================================================
IF NOT EXIST "!stx.log_directory!" (
    CALL :print_message !use_color! !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] The logging path: !stx.log_directory! NOT found." "[WARN] Logging will be DISABLED."
    ECHO:
    SET "stx.__binary.start_with_image=FALSE"
    SET "stx.__binary.append_to_log=FALSE"
)

:: ================================================================
:: Checking existence of log file if not found append is disabled =
:: ================================================================
IF NOT EXIST "!log_filename!" (
    CALL :print_message !use_color! !stx.stdout_VerboseBackgroundColor! !stx.stdout_VerboseForegroundColor! "[INFO] No log file found turning off the append mode."
    ECHO:
    SET "stx.__binary.append_to_log=FALSE"
)


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: *******************************************************************************************
:: A work-flow based on the configuration                                                    *
:: *******************************************************************************************

:: =================================================================
:: If powershell detected, get powershell executable from registry =
:: =================================================================
:: FINDSTR is there for Windows XP compatibility
IF "!__binary.powershell_detected!"=="TRUE" (
    (FOR /F "tokens=3" %%A IN ('REG QUERY "HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /v path ^| FINDSTR "^.*\.exe$"') DO (
         SET "powershell_exec=%%A"
    )) || REM
    IF ERRORLEVEL 1 (
        SET "first_message="[ERROR] Powershell detected, but executable !powershell_exec! not found.""
        SET "second_message="Fix your system.""
        SET "__numeric.exit_value=1"
        CALL :exit_sequence !first_message! !second_message!
        GOTO :EOF
    )
)

:: ===================================================
:: Powershell detected? (so we can log into a file?) =
:: ===================================================
IF "!stx.__binary.record_log_file!"=="TRUE" (
    IF "!__binary.powershell_detected!"=="FALSE" (
        SET "stx.__binary.record_log_file=FALSE"
        SET "stx.__binary.append_to_log=FALSE"
    )
)


:: =====================================================
:: Adding all parameters available to the %stx_switch% =
:: Making sure previous switches are taken in account  =
:: =====================================================
:: Cycle all command-line switches entered in the shell by the user
:: Encircle all switches (both - and --) by double-quotes
:: Ignore the command-line switches already with double quotes
:: Replace single quotes with double quotes if such switch is found
REM IF "%1" NEQ "" will cause problems if %1 is enclosed in quotes itself.
REM and you must have the extensions turn on

IF NOT "%~1"=="" (
    SET "stx_manual_switch_detected=TRUE"
    SET "detect_double_switch=--"
    SET "detect_single_switch=-"
    SET "detect_double_quote="-"
    SET "detect_single_quote='-"

    FOR %%A IN (%*) DO (
        SET "temp_string=%%~A"
        IF DEFINED stx_switch (
            REM Detect if "" around a switch are used and leave the switch alone
            IF "!temp_string:~0,2!"=="!detect_double_quote!" (
                SET "stx_switch=!stx_switch! %%A"
            REM Detect if '' around a switch are used and convert them to ""
            ) ELSE IF "!temp_string:~0,2!"=="!detect_single_quote!" (
                SET "changed_string=!temp_string:'="!"
                SET "stx_switch=!stx_switch! !changed_string!"
            REM if -- found encircle it with double quotes
            ) ELSE IF "!temp_string:~0,2!"=="!detect_double_switch!" (
                SET stx_switch=!stx_switch! ^"%%~A^"
            REM checks a string for "-" if it contains it it will add double-quotes
            ) ELSE IF "!temp_string:~0,1!"=="!detect_single_switch!" (
                SET stx_switch=!stx_switch! ^"%%~A^"
            ) ELSE (
                SET "stx_switch=!stx_switch! %%A"
            )
        REM stx_switch is not yet defined - first run
        ) ELSE (
            REM Detect if "" around a switch are used
            IF "!temp_string:~0,2!"=="!detect_double_quote!" (
                SET stx_switch=!stx_switch! %%A
            REM Detect if '' around a switch are used and convert them to ""
            ) ELSE IF "!temp_string:~0,2!"=="!detect_single_quote!" (
                SET "changed_string=!temp_string:'="!"
                SET "stx_switch=!stx_switch! !changed_string!"
            REM All other options
            ) ELSE (
                SET stx_switch=^"%%A^"
            )
        )
    )
    REM clearing used variables
    SET "detect_switch_double="
    SET "detect_single_switch="
    SET "detect_double_quote="
    SET "detect_single_quote="
)

:: ======================================================
:: Block CMD PowerShell mode from using manual Switches =
:: ======================================================
IF "!stx_manual_switch_detected!"=="TRUE" (
    IF "!stx.__binary.cmd_in_powershell!"=="TRUE" (
        ECHO:
        CALL :print_message !use_color! !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] You can not simultaneously pass command-line switches to stx.com and log using CMD PowerShell mode - __binary.cmd_in_powershell=TRUE" "[WARN] Switching off LOGGING and executing only via cmd.exe."
        ECHO:
        SET "stx.__binary.record_log_file=FALSE"
        SET "stx.__binary.append_to_log=FALSE"
    )
)

:: =================================
:: Three ways to start Smalltalk/X =
:: =================================
:: TRUE;TRUE   - User will be asked for input; with which image to start
:: TRUE;FALSE  - Stx will start with the default image configured
:: FALSE;FALSE - Quick start - StX will start without an image
IF "!stx.__binary.start_with_image!"=="TRUE" (
    IF "!stx.__binary.list_available_images!"=="TRUE" (
        REM USER INPUT
        CALL :user_menu !stx.image_path! stx.image_name !stx.image_suffix!
        CALL :print_message !use_color! !stx.stdout_VerboseBackgroundColor! !stx.stdout_VerboseForegroundColor! "[INFO] Loading selected image !stx.image_name!"
        SET "user_selected_image=!stx.image_name!"
        IF DEFINED internal_runtime_options (
            SET "stx_switch=!stx_switch! !internal_runtime_options! "--image" !user_selected_image!"
        ) ELSE (
            SET "stx_switch=!stx_switch! "--image" !user_selected_image!"
        )
        SET "user_selected_image="
    ) ELSE (
        CALL :print_message !use_color! !stx.stdout_VerboseBackgroundColor! !stx.stdout_VerboseForegroundColor! "[INFO] DEFAULT IMAGE: !stx.image_path:"=!!default_image_name:"=! starts"
        IF DEFINED internal_runtime_options (
            SET "stx_switch="--image" !default_image_name! !internal_runtime_options! !stx_switch!"
        ) ELSE (
            SET "stx_switch="--image" !default_image_name! !stx_switch!"
        )
    )
) ELSE (
    IF "!stx.__binary.stx_quick_start!"=="TRUE" (
        IF "!stx_manual_switch_detected!"=="TRUE" (
            CALL :print_message !use_color! !stx.stdout_VerboseBackgroundColor! !stx.stdout_VerboseForegroundColor! "[INFO] Manual switch detected - configuration is ignored"
            SET "stx_switch= !stx_switch!"
        ) ELSE IF DEFINED internal_runtime_options (
            SET "stx_switch="--ignoreImage" !stx_switch! !internal_runtime_options! "--quick""
        ) ELSE (
            SET "stx_switch="--ignoreImage" !stx_switch! "--quick""
        )
        REM clearing configured values
        SET "stx.image_path="
        SET "default_image_name="
    )
)

:: =======================================
:: Check if user wants to command prompt =
:: =======================================
:: note: cmd /U causes the output to pipes or file to be Unicode
IF "!stx.__binary.close_shell!"=="TRUE" (
    SET "cmd_close=/U /C"
) ELSE (
    SET "cmd_close=/U /K"
)

:: =============================================================================
:: Check if the log file is not too big (with jumping into log file directory) =
:: =============================================================================
:: NOTE: not using :print_message -> sending too many messages
:: Changing to log directory
pushd "!stx.log_directory!"
IF "!stx.__binary.append_to_log!"=="TRUE" (
    (FOR %%A IN (!log_filename!) DO (
        SET "file_size=%%~zA"
    )) || REM
    IF ERRORLEVEL 1 (
        SET "message="Error checking size of the file: !log_filename:"=!.""
        SET "__numeric.exit_value=1"
        CALL :exit_sequence !message!
        GOTO :EOF
    )
    IF !file_size! GEQ !stx.__numeric.warning_logfile_size! (
        ECHO:
        IF "!use_color!"=="TRUE" (
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "==================================================================================================================="
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] BIG_FAT_WARNING: your log file !log_filename:"=! is larger than !stx.__numeric.warning_logfile_size! Bytes. "
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] This can slow down your StX."
            CALL :printInColor !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "==================================================================================================================="
        ) ELSE (
            ECHO "====================================================================================================================="
            ECHO "[WARN] BIG_FAT_WARNING: your log file !log_filename:"=! is larger than !stx.__numeric.warning_logfile_size! Bytes. "
            ECHO "[WARN] This can slow down your StX."
            ECHO "====================================================================================================================="
        )
        ECHO:
        PAUSE
    )
)
:: Return back from the log directory
popd


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: *******************************************************************************************
:: Running the command                                                                       *
:: *******************************************************************************************

:: =================================
:: Preparing command for execution =
:: =================================
IF "!stx.__binary.record_log_file!"=="TRUE" (
    REM -WindowStyle Normal Sets the window style to Normal, Minimized, Maximized or Hidden.
    REM -NoProfile - launches without a profile
    REM -ExecutionPolicy Bypass - does not ask for passwords if used privileged command.
    SET exec_command$=CALL !powershell_exec! -WindowStyle Normal -nologo -noninteractive -NoProfile -ExecutionPolicy Bypass -Command "& {!powershell_script_file! -executable '!smalltalk_executable:"=!' -log_file '!stx.log_directory:"=!!log_filename:"=!' -log_file_encoding '!stx.log_file_encoding!' -append_to_log '!stx.__binary.append_to_log!' -cmd_close '!cmd_close!' -PowerShellVersion '!PowerShellVersion!' -cmd_in_powershell '!stx.__binary.cmd_in_powershell!' -stx_manual_switch_detected '!stx_manual_switch_detected!'};"
) ELSE (
    ECHO:
    CALL :print_message !use_color! !stx.stdout_WarningBackgroundColor! !stx.stdout_WarningForegroundColor! "[WARN] NO LOGGING"
    ECHO:
    CALL :print_message !use_color! !stx.stdout_VerboseBackgroundColor! !stx.stdout_VerboseForegroundColor! "[INFO] User disabled or limitation applies." "[INFO] Executing: cmd.exe !cmd_close:"=! CALL !smalltalk_executable:"=! !stx_switch!"
    SET "exec_command$=cmd.exe !cmd_close! CALL !smalltalk_executable:"=! !stx_switch!"
)

:: ===========
:: Execution =
:: ===========
:: An alternative working too
REM START /B /W !exec_command$!

:: An alternatives NOT working properly (for unknown reason) - as a warning 
REM ECHO " "exec: !%exec_command%!"
REM CALL %%exec_command%%

:: Calling the dynamic variable exec_command$ this way works 100%
:: The suffix $ at the variable is to make sure there is no variable collision with the current environment
CALL !exec_command$!
:: To view error level even from PowerShell
:: ECHO "Errorlevel: !errorlevel!"
:: PAUSE
IF NOT "%ERRORLEVEL%"=="0" (
    SET "message="The command !exec_command$! was executed incorrectly.""
    SET "__numeric.exit_value=1"
    CALL :exit_sequence !message!
    GOTO :EOF
)

:: ==================================
:: Correctly ending the application =
:: ==================================
IF "__binary.close_shell"=="FALSE" (
    ECHO:
    IF "!use_color!"=="TRUE" (
        CALL :printInColor !stx.stdout_VerboseBackgroundColor! !stx.stdout_VerboseForegroundColor! "[INFO] End. Waiting till final exit."
    ) ELSE (
        ECHO "[INFO] End. Waiting till final exit."
    )
    PAUSE
) ELSE (
    ECHO:
    IF "!use_color!"=="TRUE" (
        CALL :printInColor !stx.stdout_VerboseBackgroundColor! !stx.stdout_VerboseForegroundColor! "[INFO] End. Exiting correctly."
    ) ELSE (
        ECHO "[INFO] End. Exiting correctly."
    )
    IF "!stx.__binary.use_timer!"=="TRUE" (
        REM ===========================
        REM End timer and show result =
        REM ===========================
        CALL :time_in_seconds __end
        ECHO "[INFO] timer end. Duration: !__end! [seconds]"
        ECHO:
        SET /A "_elapsed=!__end!-!__start!"
        ECHO "[INFO] Timer: !_elapsed! seconds."
    )
)
ENDLOCAL
EXIT /B 0



:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Next section follows 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: *******************************************************************************************
:: User defined functions                                                                    *
:: *******************************************************************************************

:exit_sequence
IF NOT "!__numeric.exit_value!"=="0" (
    IF NOT "%~1"=="" (
        ECHO:
        CALL :print_message !use_color! !stx.stdout_ErrorForegroundColor! !stx.stdout_ErrorBackgroundColor! "[ERROR] "%1""
    )
    IF NOT "%~2"=="" (
        CALL :print_message !use_color! !stx.stdout_ErrorForegroundColor! !stx.stdout_ErrorBackgroundColor! "[ERROR] "%2""
    )
    ECHO:
    CALL :print_message !use_color! !stx.stdout_ErrorForegroundColor! !stx.stdout_ErrorBackgroundColor! "[ERROR] Exiting with error. Script __numeric.exit_value: !__numeric.exit_value!." "[ERROR] Batch errorlevel: !ERRORLEVEL!"
    PAUSE
    REM Cleanup namespace stx.
    REM nul redirection stops error output if no stx. var is set
    FOR /F "tokens=1 delims==" %%V IN ('SET stx. 2^>NUL') DO (
        SET "%%V="
    )
    REM Deallocate variables
    ENDLOCAL
    EXIT /B 1
) ELSE (
    ECHO:
    CALL :print_message !use_color! !stx.stdout_VerboseBackgroundColor! !stx.stdout_VerboseForegroundColor! "[INFO] Exiting correctly."
    REM Cleanup namespace stx.
    REM nul redirection stops error output if no stx. var is set
    FOR /F "tokens=1 delims==" %%V IN ('SET stx. 2^>NUL') DO (
        SET "%%V="
    )
    
    call :cleanupColorPrint
    REM Deallocate variables
    ENDLOCAL
    EXIT /B 0
)

:: =============================
:: Detect available powershell =
:: =============================
:powershell_detection

SET "registry_path="HKLM\SOFTWARE\Microsoft\PowerShell""
SET "latest_powershell_version=0"
SET "runtime_version="""
SET /A "counter=1"

:: Check if registry path to PowerShell exists
REG QUERY !registry_path!>NUL
IF /I NOT "!ERRORLEVEL!"=="0" (
    ECHO:
    ECHO "[ERROR] Registry path: !registry_path! does not exist."
    ECHO "[ERROR] Powershell NOT detected."
    SET "powershell_detected=FALSE"
    GOTO end_powershell_detection
)

:: ~ expands the given variable
:: The ^ escapes (protects) the pipe during the initial batch parsing.
:: double %% is there as holder for FOR.
:: :"= replaces all the double quotes in the variable with nothing
:: The '\\' in regexp is included for WindowsXP compatibility - req query returns also its version in the query
(FOR /F "delims=" %%A IN ('REG QUERY "!registry_path!" ^| FINDSTR "^.*\\[0-9]$"') DO (
    REM "ECHO "DEBUG:__PowerShellRegistryVersion.!counter!=%%~A"
    SET "__PowerShellRegistryVersion.!counter!=%%~A"
    SET /A "counter+=1"
)) || REM
IF ERRORLEVEL 1 (
    ECHO:
    ECHO "[ERROR] Query: REG QUERY "!registry_path!" ^| FINDSTR "^.*\\[0-9]$" probably error in registry."
    SET "powershell_detected=FALSE"
    PAUSE
    GOTO end_powershell_detection
)

:: Found powershell registry token=2* takes 'counter=registry path'. delims== selects everything right of "="; ending with only registry path.
(FOR /F "tokens=2* delims==" %%A IN ('SET __PowerShellRegistryVersion.') DO (
    (FOR /F "tokens=3" %%R IN ('REG QUERY %%~A /v Install ^| FIND "Install"') DO (
        SET "PowerShellInstalled=%%~R"
    )) || REM
    IF ERRORLEVEL 1 (
        ECHO:
        ECHO "[ERROR] Query: REG QUERY "REG QUERY %%~A /v Install ^| FIND "Install" did not find any Install key. probably error in registry."
        SET "powershell_detected=FALSE"
        PAUSE
        GOTO end_powershell_detection
    )
    IF NOT "!PowerShellInstalled!"=="0x1" (
        ECHO:
        ECHO "[INFO] The PowerShell PSCompatibleVersion ^(1.0 or 2.0^) is not installed."
        SET "powershell_detected=FALSE"
        GOTO end_powershell_detection
    )

    (FOR /F "tokens=3" %%P IN ('REG QUERY "%%~A\PowerShellEngine" /v PowerShellVersion ^| FIND "PowerShellVersion"') DO (
        SET "PowerShellVersion=%%~P"
    )) || REM
    IF ERRORLEVEL 1 (
        ECHO:
        ECHO "[ERROR] Query: REG QUERY "REG QUERY "%%~A\PowerShellEngine" /v PowerShellVersion ^| FIND "PowerShellVersion"" did not find any PowerShellVersion key. probably error in registry."
        SET "powershell_detected=FALSE"
        PAUSE
        GOTO end_powershell_detection
    )
    REM GEQ - greater than or equal
    IF "!PowerShellVersion!" GEQ "!minimal_powershell_version!" (
        SET "powershell_detected=TRUE"
    ) ELSE (
        SET "powershell_detected=FALSE"
    )

    FOR /F "tokens=3" %%V IN ('REG QUERY "%%~A\PowerShellEngine" /v RuntimeVersion ^| FIND "RuntimeVersion"') DO SET "RuntimeVersion=%%~V"
    IF "!latest_powershell_version!" LSS "!PowerShellVersion!" (
        SET "latest_powershell_version=!PowerShellVersion!"
        SET "runtime_version=!RuntimeVersion!"
    )
)) || REM
    IF ERRORLEVEL 1 (
        ECHO:
        ECHO "[ERROR] Command SET __PowerShellRegistryVersion.  Something wrong with your shell (command prompt)."
        SET "powershell_detected=FALSE"
        PAUSE
        GOTO end_powershell_detection
    )

IF "!powershell_detected!"=="TRUE" (
    ECHO:
    ECHO "[INFO] PowerShell detected: ->!powershell_detected!<-.
    ECHO "[INFO] The latest latest_powershell_version found: !latest_powershell_version!."
    ECHO "[INFO] With the runtime being: !runtime_version!."
) ELSE (
    ECHO:
    ECHO "[INFO] PowerShell NOT detected. Fallback mode activated.
)

:end_powershell_detection

SET "%~1=!powershell_detected!"
SET "%~2=!latest_powershell_version!"
SET "%~3=!runtime_version!"

EXIT /B

:: ==================
:: Create user menu =
:: ==================
:user_menu

:: Normal path can be with or without double quotes.  If the path contains spaces it must be enclosed by double quotes.
SET "input_image_path=%~1"
SET "input_image_suffix=%~3"

:: Init
SET /A "counter_get_answer=1"
SET /A "counter_get_file=1"

:: %%A - double %% due to FOR loop and %A as an array
:: within FOR filename with suffix: %%~nxA
:: For does not change ERRORLEVEL but uses exit_code for more see: http://stackoverflow.com/questions/34987885/what-are-the-errorlevel-values-set-by-internal-cmd-exe-commands 
:: However, the '|| REM' trick captures the ERRORLEVEL from the DIR executed as for command.
:: -DN - order by date (the newest first) and in alphabetic order
ECHO "--------------- User input ------------------------------------------------------------------------------------"
ECHO "Select your stx image (sorted from the newest; if files of same then alphabetic order is used):"
ECHO:
(FOR /F "delims=" %%A IN ('dir !input_image_path!^*^.!input_image_suffix! /B /O^:-DN 2^>NUL') DO (
    SET "__stx_image_path.%counter_get_answer%=%%~dpnxA"
    ECHO "[!counter_get_answer!]  => !__stx_image_path.%counter_get_answer%!
    SET /A "counter_get_answer+=1"
)) || REM
IF ERRORLEVEL 1 (
    ECHO "No files with mask !input_image_path:"=!^*^.!input_image_suffix:"=!"
    ECHO "Will exit now."
    PAUSE
    REM This is a "trick" to exit directly the function
    REM (GOTO) 2^^>NUL behaves nearly same as exit /B but executes the block behind it
    (GOTO) 2>NUL & ENDLOCAL & EXIT /B
)
ECHO:
ECHO "[0]  Exit"
ECHO:
ECHO "---------------------------------------------------------------------------------------------------------------"
ECHO:

SET /P "user_input="Enter a choice: ""
:: -----------------------------
:: prevent hijacking the input -
:: -----------------------------
:: ECHO "DEBUG: .!user_input!.
:: ECHO "DEBUG: strip quotes: .!user_input:"=!.
SET "user_input=!user_input:"=!"

:: If you really want to reject the variable with any quotation mark...
:: FIND /V-  Displays all lines NOT containing the specified string.
SET user_input | FIND /V """" >NUL
IF ERRORLEVEL 1 (
   SET "user_input="
   ECHO "[ERROR] You are trying to hijack the input. Exiting."
   ECHO "[ERROR] Batch errorlevel: !ERRORLEVEL!"
   PAUSE
   REM This is a "trick" to exit directly the function
   REM (GOTO) 2^^>NUL behaves nearly same as exit /B but executes the block behind it
   (GOTO) 2>NUL & ENDLOCAL & EXIT /B 1
)
:: ---------------------------------
:: END prevent hijacking the input -
:: ---------------------------------

:: User choose to exit
IF "!user_input!"=="0" (
    ECHO "[INFO] You have selected to exit voluntary. Goodbye."
    (GOTO) 2>NUL & ENDLOCAL & EXIT /B 0
)

REM A solution for unknown number of options at the time asking the question
REM ugh must not be used anywhere else!
REM Verification that user has entered a number from the given selection
SET "ugh="&FOR /F "delims=0123456789" %%I IN ("!user_input!") DO SET "ugh=%%~I"
IF defined ugh (
    ECHO:
    ECHO "[INFO] The input -> !user_input! <- was outside the given choices."
    SET "ugh="
    PAUSE
    GOTO user_menu
) ELSE (
    IF "!user_input!" GTR "0" (
        IF "!user_input!" LSS "!counter_get_answer!" (
            REM ECHO "DEBUG: Your answer is: -> %user_input% <-."
            SET "verified_user_input=!user_input!"
        ) ELSE (
            ECHO:
            ECHO "[INFO] The input2 -> !user_input! <- was outside the given choices."
            PAUSE
            GOTO user_menu
        )
    ) ELSE (
        ECHO:
        ECHO "[INFO] The input3 -> !user_input! <- was outside the given choices."
        PAUSE
        GOTO user_menu
    )
)

:: Getting path and file name from user answer
SET "stx_break="
(FOR /F "delims=" %%A IN ('dir !input_image_path!^*^.!input_image_suffix! /B /O^:-DN 2^>NUL') DO IF NOT DEFINED stx_break (
    IF "!verified_user_input!"=="!counter_get_file!" (
      SET "__stx_image_path="%%~dpnxA""
      SET "stx_break=yes"
    ) ELSE IF "!counter_get_answer!" LSS "!counter_get_file!" (
      SET "__stx_image_path="Unknown path""
      SET "stx_break=yes"
    )
    SET /A "counter_get_file+=1"
)) || REM
IF ERRORLEVEL 1 (
    ECHO "Error converting the user answer ->!verified_user_input! to path."
    PAUSE
    REM This is a "trick" to exit directly the function
    REM (GOTO) 2^^>NUL behaves nearly same as exit /B but executes the block behind it
    (GOTO) 2>NUL & ENDLOCAL & EXIT /B
)
:: Clearing
SET "stx_break="

SET "%2=!__stx_image_path!"
SET "__stx_image_path="
SET "verified_user_input="
SET "input_image_path="
SET "input_image_suffix="

EXIT /B

:: ======================================
:: Printing stdout messages with colors =
:: ======================================
:print_message
SET "use_color=%1"
SET "stdout_VerboseBackgroundColor=%2"
SET "stdout_VerboseForegroundColor=%3"

SET "message1=%4"
SET "message2=%5"
SET "message3=%6"

IF "%use_color%"=="TRUE" (
    IF DEFINED message1 (
        CALL :printInColor %stdout_VerboseBackgroundColor% %stdout_VerboseForegroundColor% %message1%
    ) ELSE (
        CALL :printInColor %stdout_VerboseBackgroundColor% %stdout_VerboseForegroundColor% "[ERROR] No message defined."
    )
    IF DEFINED message2 (
        CALL :printInColor %stdout_VerboseBackgroundColor% %stdout_VerboseForegroundColor% %message2%
        IF DEFINED message3 (
            CALL :printInColor %stdout_VerboseBackgroundColor% %stdout_VerboseForegroundColor% %message2%
        )
    )
) ELSE (
    IF DEFINED message1 (
        ECHO "%message1%"
    ) ELSE (
        ECHO "[ERROR] No message defined."
    )
    IF DEFINED message2 (
        ECHO "%message2%"
        IF DEFINED message3 (
            ECHO "%message3%"
        )
    )
)
GOTO :EOF

:: ======================================
:: Native Shell coloring for Windows 10 =
:: ======================================
:: just stub - NOT FINISHED!!!
:printInColorWin10

:: Windows 10 detection
::FOR /F "tokens=2 delims=[" %%I IN ('ver') DO (
::   ECHO %%I
::   FOR /F "tokens=2-3 delims=. " %%V IN ("%%I") DO (
::       SET version=%%V.%%W
::       IF "!version!" LSS "10.0" (
::           ECHO "Older windows than Windows 10"
::       ) ELSE (
::           ECHO "Windows 10 or newer"
::       )
::   )
::)

:: ANSI Colors for Windows 10
REM ECHO [101;93m STYLES [0m
REM ECHO ^<ESC^>[0m [0mReset[0m
REM ECHO ^<ESC^>[1m [1mBold[0m
REM ECHO ^<ESC^>[4m [4mUnderline[0m
REM ECHO ^<ESC^>[7m [7mInverse[0m
REM ECHO.
REM ECHO [101;93m NORMAL FOREGROUND COLORS [0m
REM ECHO ^<ESC^>[30m [30mBlack[0m (black)
REM ECHO ^<ESC^>[31m [31mRed[0m
REM ECHO ^<ESC^>[32m [32mGreen[0m
REM ECHO ^<ESC^>[33m [33mYellow[0m
REM ECHO ^<ESC^>[34m [34mBlue[0m
REM ECHO ^<ESC^>[35m [35mMagenta[0m
REM ECHO ^<ESC^>[36m [36mCyan[0m
REM ECHO ^<ESC^>[37m [37mWhite[0m
REM ECHO.
REM ECHO [101;93m NORMAL BACKGROUND COLORS [0m
REM ECHO ^<ESC^>[40m [40mBlack[0m
REM ECHO ^<ESC^>[41m [41mRed[0m
REM ECHO ^<ESC^>[42m [42mGreen[0m
REM ECHO ^<ESC^>[43m [43mYellow[0m
REM ECHO ^<ESC^>[44m [44mBlue[0m
REM ECHO ^<ESC^>[45m [45mMagenta[0m
REM ECHO ^<ESC^>[46m [46mCyan[0m
REM ECHO ^<ESC^>[47m [47mWhite[0m (white)
REM ECHO.
REM ECHO [101;93m STRONG FOREGROUND COLORS [0m
REM ECHO ^<ESC^>[90m [90mWhite[0m
REM ECHO ^<ESC^>[91m [91mRed[0m
REM ECHO ^<ESC^>[92m [92mGreen[0m
REM ECHO ^<ESC^>[93m [93mYellow[0m
REM ECHO ^<ESC^>[94m [94mBlue[0m
REM ECHO ^<ESC^>[95m [95mMagenta[0m
REM ECHO ^<ESC^>[96m [96mCyan[0m
REM ECHO ^<ESC^>[97m [97mWhite[0m
REM ECHO.
REM ECHO [101;93m STRONG BACKGROUND COLORS [0m
REM ECHO ^<ESC^>[100m [100mBlack[0m
REM ECHO ^<ESC^>[101m [101mRed[0m
REM ECHO ^<ESC^>[102m [102mGreen[0m
REM ECHO ^<ESC^>[103m [103mYellow[0m
REM ECHO ^<ESC^>[104m [104mBlue[0m
REM ECHO ^<ESC^>[105m [105mMagenta[0m
REM ECHO ^<ESC^>[106m [106mCyan[0m
REM ECHO ^<ESC^>[107m [107mWhite[0m
REM ECHO.
REM ECHO [101;93m COMBINATIONS [0m
REM ECHO ^<ESC^>[31m                     [31mred foreground color[0m
REM ECHO ^<ESC^>[7m                      [7minverse foreground ^<-^> background[0m
REM ECHO ^<ESC^>[7;31m                   [7;31minverse red foreground color[0m
REM ECHO ^<ESC^>[7m and nested ^<ESC^>[31m [7mbefore [31mnested[0m
REM ECHO ^<ESC^>[31m and nested ^<ESC^>[7m [31mbefore [7mnested[0m
GOTO :EOF

:: ============================================
:: Coloring of information text in Batch file =
:: ============================================
:: There is no native support for ANSI colors on the console till Windows 10 (excluded).
:: It is rather tricky to color only one line just via CMD - any hack does not work properly with this complex batch file
:: The best way till Windows 10 is actually to use PowerShell!  In Windows 10 the proper use is to use native ANSI colors (not done yet).
:printInColor
SET "background=%1"
SET "foreground=%2"
SET "message=%3"

REM Message was "'%*'" but now since we are passing colors we have to limit it
:: Saves original color and then sets the new color for the message
SET long_command= ^
$window_private_data = (Get-Host).PrivateData;^
$saved_background_color = $window_private_data.VerboseBackgroundColor;^
$saved_foreground_color = $window_private_data.VerboseForegroundColor;^
$window_private_data.VerboseBackgroundColor = "'%background%'";^
$window_private_data.VerboseForegroundColor = "'%foreground%'";^
Write-Verbose -Message "'%message%'" -Verbose;^
$window_private_data.VerboseBackgroundColor = $saved_background_color;^
$window_private_data.VerboseForegroundColor = $saved_foreground_color;

CALL powershell -nologo -noninteractive -NoProfile -ExecutionPolicy Bypass -Command %long_command%
GOTO :EOF

:time_in_seconds
FOR /F %%A IN ('wmic os get LocalDateTime ^| find "."') DO (
    SET "dts=%%A"
    REM Issue with octal representation (08 and 09 are invalid octal representation and others are too but are accepted)
    REM Workaround implemented below:
    IF "!dts:~8,1!"=="0" (
        SET "hours=!dts:~9,1!"
    ) ELSE (
        SET "hours=!dts:~8,2!"
    )
    SET /A _time_in_seconds=!hours!*3600^
                            +!dts:~10,1!*10*60^
                            +!dts:~11,1!*60^
                            +!dts:~12,1!*10^
                            +!dts:~13,1! >nul
)
SET "%~1=!_time_in_seconds!"
GOTO :EOF


:: =============================================
:: Expanding variables from configuration file =
:: =============================================
:: Must be last in this section
:expand_path
SET "%2=%1"
GOTO :EOF


REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
REM Next section follows 
REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: *******************************************************************************************
:: Support information (like help, about, version)
:: *******************************************************************************************

:: ==============
:: Help section =
:: ==============
:stx_help
IF EXIST "stx-bin.com" (
    CALL stx-bin.com --help
) ELSE IF EXIST "stx.com" (
    CALL stx.com --help
) ELSE (
    ECHO "[WARN] The executable stx-bin.^(com^|exe^) or stx.^(com^|exe^) NOT found.""
    ECHO "[WARN] Exiting with error. Script __numeric.exit_value: 1."
    PAUSE
    GOTO :EOF
)

GOTO :EOF

:stx_help_launcher
ECHO ====================
ECHO The configuration: =
ECHO ====================
ECHO Note: The configuration is done via .cfg file.  The only configuration that can be done in the batch file
ECHO        is for the configuration file itself.  You can change the configuration path via configuration_file_path variable
ECHO        and the configuration file name via configuration_file variable.
ECHO:
ECHO Note2: Notice that Microsoft is using Unicode as an alias for UTF16 (which is wrong but we have to deal with it).
ECHO:
ECHO:
ECHO ======================================
ECHO The features of this advanced script =
ECHO ======================================
ECHO:
ECHO -- Quick start (with close or leave open the shell after Smalltalk start)
ECHO -- Starting with default image on defined path
ECHO -- Starting with any image (user is prompted to select one via menu) on defined path
ECHO -- Logging into a file - either overwrite or append at start start (minimal PowerShell 2.0 is required)
ECHO                        - User can change the log file encoding to ASCII, UTF8 (default), UTF16, UTF32
ECHO                        - User can decide if he wants a date and/or time part added to the log file
ECHO -- The script automatically detects PowerShell version and based on that decides which functionality will be available.
ECHO -- Error handling on the batch and PowerShell level - user is informed about the details of error
ECHO -- Batch file tries to exit gracefully, if possible
ECHO:
ECHO The advanced features:
ECHO -- A warning limit is in place for the log file size.  If it gets too large as it may slowdown the Smalltalk.
ECHO -- User can decide if there will be a shell opened for error messages or if Smalltalk will for from shell and
ECHO    will not display any messages on the command prompt.
ECHO -- User can choose if the validation process is active and if the successful message is shown.
ECHO -- User can choose which redirect will be used in PowerShell - if the native one or cmd.exe one (little bit faster in most cases).
ECHO -- When user enters his own switches then manual switches feature is used.  Now the powershell uses System.Diagnostics.ProcessStartInfo 
ECHO -- object to execute the stx executable.  It brings two benefits: 
ECHO -- a) stdout and stderrr are independent and asynchronous from the executable
ECHO -- b) all output is recorded correctly into the log file.
ECHO:
ECHO:
ECHO:
ECHO -------------------------------------------------------------------------------------------
ECHO User settings
ECHO -------------------------------------------------------------------------------------------
ECHO: ===================
ECHO Stx bin directory =
ECHO ===================
ECHO Setting: stx_bin_dir - 
ECHO Impact: defines the directory containing the executable
ECHO Note: do not forget the last backslash ^(\^) and double quotes when changing to custom path
ECHO stx_bin_dir="%~dp0"
ECHO:
ECHO ===================================
ECHO Stx quick start and image details =
ECHO ===================================
ECHO Setting: __binary.stx_quick_start
ECHO Impact: Uses flags --ignoreImage and --quick start to start StX as fast as possible
ECHO TRUE - switches on the quick start
ECHO FALSE - skips this option
ECHO __binary.stx_quick_start=FALSE
ECHO:
ECHO Setting: image_path, image_name, image_suffix
ECHO Impact: variables are self-explanatory
ECHO Note: do not forget the last backslash ^(\^) and double quotes when changing to custom path
ECHO image_path="%~dp0"
ECHO Setting: image_name - how should the default image be named
ECHO image_name="st"
ECHO image_suffix=".img"
ECHO:
ECHO Impact: Pair variables (affect each other):__binary.start_with_image and __binary.list_available_images
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO note: Before using image functionality check image path, name, and suffix
ECHO:
ECHO Setting: __binary.start_with_image
ECHO Impact: Stx starts (or not) with image.
ECHO TRUE - image functionality will be used
ECHO FALSE - image functionality ignored
ECHO __binary.start_with_image=FALSE
ECHO:
ECHO Setting: __binary.list_available_images
ECHO Impact: User menu is show when used; it shows all images within the directory (excluding subdirectories) and users selects one.
ECHO        If switched off only default image (see image_path, image_name, image_suffix) is used.
ECHO Note: IF start_with_image=FALSE and list_available_images=TRUE then a warning message is shown and append_to_log is set to FALSE automatically)
ECHO TRUE - Switches on the user menu
ECHO FALSE - no interaction from user required
ECHO __binary.list_available_images=FALSE
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO:
ECHO =================
ECHO Stx logging     =
ECHO =================
ECHO Impact: Pair variables (affect each other): __binary.record_log_file and __binary.append_to_log
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO Setting: __binary.record_log_file
ECHO Impact: Both standard output and standard error are redirected to a log file
ECHO Note: At least PowerShell 2.0 is required (WindowsXP and newer)
ECHO TRUE - turns on the logging functionality
ECHO FALSE - turns off the logging
ECHO __binary.record_log_file=TRUE
ECHO:
ECHO Setting: __binary.append_to_log
ECHO Impact: Appends the log file.  Uses a PowerShell when appending.
ECHO Note: IF record_log_file=FALSE and append_to_log=TRUE then a warning message is shown and append_to_log is set to FALSE automatically)
ECHO TRUE - if log file is found it will be appended.  If not a new one will be created 
ECHO FALSE - the append functionality is turned off (the log file will be overwritten every time StX is executed)
ECHO __binary.append_to_log=TRUE
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO:
ECHO Setting: log_directory, log_name, log_suffix
ECHO Impact: Directory sets a log file directory (others are self-explanatory)
ECHO If a change would be done, double quotes must be present: e.g. "C:\prg_sdk\Stx_stable\"
ECHO Note: do not forget the last backslash ^(\^) and double quotes when changing to custom path
ECHO log_directory="%~dp0"
ECHO Setting: log_name sets name for log file
ECHO log_name="smalltalk"
ECHO log_suffix=".log"
ECHO:
ECHO Setting: __binary.log_add_datepart
ECHO Impact: Adds a date part based on ISO 8601 to the log file; format YYYY-MM-DD ('-' as a separator)
ECHO TRUE - Switch on this option
ECHO FALSE - Skips this option
ECHO __binary.log_add_datepart=TRUE
ECHO:
ECHO Setting: __binary.log_add_timepart
ECHO Impact: Adds a time part to the log file; format hh;mm;ss (non-ISO ';' as a separator)
ECHO Note: the ISO 8601 separator is not compatible with file-system)
ECHO TRUE - Switch on this option
ECHO FALSE - Skips this option
ECHO __binary.log_add_timepart=FALSE
ECHO:
ECHO Setting: log_file_encoding
ECHO Impact: Changes log file encoding
ECHO Allowed values ASCII, UTF8 (default), UTF16 (in Microsoft world that is called Unicode), UTF32
ECHO Note: only UTF16 is using Tee-Object which enables you to have all the features the developer envisioned for the logging process
ECHO       you can simultaneously see the output in shell, view the log file while using StX and have the wished encoding
ECHO       all other encodings carry some limitation due to the powershell tools limitation
ECHO log_file_encoding=UTF8
ECHO:
ECHO =================
ECHO Stx shell       =
ECHO =================
ECHO Setting: __binary.close_shell
ECHO Impact: When set to TRUE closes the shell upon StX exit
ECHO TRUE - Switch on this option
ECHO FALSE - Skips this option
ECHO __binary.close_shell=TRUE
ECHO:
ECHO Setting: __binary.run_via_shell
ECHO Impact: start with shell (.com) or just the GUI without shell (.exe)
ECHO TRUE - uses stx.com executable
ECHO FALSE - uses stx.exe executable
ECHO __binary.run_via_shell=TRUE
ECHO:
ECHO:
ECHO -------------------------------------------------------------------------------------------
ECHO Advanced user settings
ECHO -------------------------------------------------------------------------------------------
ECHO ====================
ECHO Validate variables =
ECHO ====================
ECHO: Setting: verify_variables_syntax
ECHO Impact: Verifies the syntax of the batch file variables - e.g. batch file is very picky on spaces
ECHO TRUE - active validation
ECHO FALSE - inactive validation (NOT recommended)
ECHO verify_variables_syntax=TRUE
ECHO:
ECHO Setting: verify_print_message
ECHO Impact: shows message when the verification is complete
ECHO TRUE - Switch on this option
ECHO FALSE - message is not shown
ECHO verify_print_message=FALSE
ECHO:
ECHO =======================
ECHO Log file size warning =
ECHO =======================
ECHO Setting: __numeric.warning_logfile_size - Above what file size should a log file warning be shown?
ECHO Impact: If the limit is reached a warning message is shown to the user
ECHO Print user waring if the log file is getting too big - for 32MB in bytes
ECHO the bigger log-file, the slower the logging process gets
ECHO __numeric.warning_logfile_size=33554432
ECHO:
ECHO ====================
ECHO Stdout redirection =
ECHO ====================
ECHO Setting: cmd_in_powershell
ECHO Impact: The cmd.exe redirection is faster even when called from powershell
ECHO         There could be unforeseen issues with it so there is a switch (no manual switches are allowed)
ECHO         When no colors are used then black background and gray foreground is used (warning messages are still highlighted)
ECHO         When colors are used then the same color schema is used
ECHO TRUE - uses cmd.exe for redirecting output
ECHO FALSE - uses powershell for redirection (default)
ECHO __binary.cmd_in_powershell=TRUE
ECHO:
ECHO =============
ECHO Start timer =
ECHO =============
ECHO Setting: use_timer
ECHO Impact: Measures time between start of the script and correct ending. Measurement unit are seconds.
ECHO TRUE - uses timer
ECHO FALSE - switches off timer
ECHO __binary.use_timer=FALSE
ECHO:
ECHO ==============
ECHO Colored text =
ECHO ==============
ECHO Setting: colored_stdout
ECHO Impact: Will adjust based on the color setting the stdout output from both batch and powershell
ECHO        note: in powershell there are default colors used when setting is is turned off (FALSE.
ECHO TRUE - uses colored output
ECHO FALSE - uses default colors available
ECHO __binary.colored_stdout=TRUE
ECHO:
ECHO ===================
ECHO Stdout text color =
ECHO ===================
ECHO colors that can be used
ECHO Black, DarkBlue, DarkGreen, DarkCyan, DarkRedDarkMagenta, DarkYellow,
ECHO Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White
ECHO:
ECHO - verbose text (this is color used for normal usually [INFO] messages)
ECHO stdout_VerboseBackgroundColor=Black
ECHO stdout_VerboseForegroundColor=DarkGreen
ECHO:
ECHO - warning text
ECHO stdout_WarningBackgroundColor=Black
ECHO stdout_WarningForegroundColor=Yellow
ECHO:
ECHO - error
ECHO stdout_ErrorBackgroundColor=White
ECHO stdout_ErrorForegroundColor=Red
ECHO:
ECHO:
ECHO:
ECHO ===================
ECHO Known limitations =
ECHO ===================
ECHO:
ECHO 1) For any logging you need to have at least PowerShell 2.0
ECHO 2) User menu searches only the log_directory.  The subdirectories are excluded from the search (doable but the script is already too complex)
ECHO 3) When logging user can chose to use colors or not.  If user does not wish to have custom color then no color for batch file and native colors in powershell are used.
ECHO 4) When using "pure" powershell redirection an error is shown at the start of the log file that is a bug in powershell (produces error: FullyQualifiedErrorId : NativeCommandError ) 
ECHO    The error can be ignored.
ECHO 5) The .lnk files are tested on Windows 7 SP1 (known to not work on Windows XP, you have to use the batch file directly.)
ECHO 6) When using CMD PowerShell mode manual (user) switches can not be used.  When used the batch file forces CMD only mode.
ECHO 7) The launcher can have issues with double-quotes and quotes within - escape them when needed - e.g. use double double quotes to escape
ECHO 8) Issues with the "!" character to add it you have to use escape ^ character e.g. --eval "Transcript showCR: 'Bang^^^!'."
ECHO 9) Any switch containing question mark (?) will be ignored - batch file FOR limitation e.g. smalltalk -I --quick --eval "Transcript showCR: 'How are you?'."
ECHO    The whole "Transcript showCR: 'How are you?'." will be "eaten" by batches FOR statement.
ECHO:
ECHO:
ECHO:
ECHO usage: (%~nx0) [--help] [--help-launcher] [--about] [--version] [stx shell switches]
ECHO:
ECHO args to startup script:
ECHO       --help or -h or /h or /? ................ displays "stx.com" help
ECHO       --help-launcher or -h-l or /h-l ......... displays "%~nx0" help
ECHO       --about or -a or /a      ................ shows about section
ECHO       --version or -v or /v    ................ version information about %~nx0 and Smalltalk/X
ECHO:
ECHO In the future:
ECHO      --ldd .................. show which shared libraries are used - NOT DONE YET
ECHO      --gdb .................. run with gdb-Debugger - NOT DONE YET
ECHO      --cgdb ................. run with cgdb-Debugger - NOT DONE YET
ECHO:

:: This section is commented out on purpose - There are tricks for batch files -> does not need to be part of the user help

:: " =================================="
:: " Batch or Powershell Tip & tricks ="
:: " =================================="

:: " =============================================="
:: " Tee-Object, Add-Content, Out-File + encoding ="
:: " =============================================="
::The 'Tee-object' and Add-Content was introduced in PowerShell 3.0 -> that the reason why there is such limitation.
::
::The reason why the script is using also different logging types than 'Tee-object' is the fact that 'Tee-Object'
::supports only UTF16 (alias Unicode in Microsoft world) encoding.
::Note: 'Tee-Object' append flag is '-a' (note: for 'tee' command it is '--append')
::
::'Add-content' can change encoding and you can view the messages in the shell but you can not view the file when StX is running (locked even for read)
::'Out-File' can also change encoding, but you will not see the messages in the shell (only in StX launcher).  On the other hand you can view the file during
::StX session.

:: " =============================================="
:: " Empty lines in batch files ="
:: " =============================================="
:: NOTE: ECHO: is a reliable and fast way to print empty line.  Other ways are: ECHO( ECHO/

:: " =============="
:: " Redirections ="
:: " =============="

REM powershell ... cmd.exe /c command '2>&1' -> Let cmd.exe handle redirection
REM powershell ... cmd.exe /c command 2>&1 -> Let powershell.exe handle redirection

REM Details
REM PowerShell:
REM cmd.exe /c command 2>&1 -> redirect error stream (2) to success stream (1)
REM fixes it when running from within PS but not the command prompt

REM Batch file:
REM ...cmd /c "ECHO "Hello from standard error 1>&2" 2>&1 | %{ "$_" } | tee... 
REM 

:: " ====================="
:: " Exiting batch files ="
:: " ====================="
:: To require pressing ctrl+C from the user (alias force ctrl+C)
:: cmd /c exit -1073741510

:: To directly exit user function (used via CALL)
:: This is a "trick" to exit directly the function
:: (GOTO) 2^^>NUL behaves nearly same as exit /B but executes the block behind it
:: (GOTO) 2>NUL & ENDLOCAL & EXIT /B 1

:: " ========================"
:: " Miscellaneous in batch ="
:: " ========================"
:: A nice solution for printing out a known number of options:
:: for %%I in (1 2 3 4 5 x) do if #%user_input%==#%%I goto run%%I
:: then you have to have label for every number e.g. :run1, :run2

GOTO :EOF

:: ===============
:: About section =
:: ===============
:stx_about
ECHO " _____                 _ _ _        _ _         ____   __               "
ECHO "/  ___|               | | | |      | | |       / /\ \ / /               "
ECHO "\ `--. _ __ ___   __ _| | | |_ __ _| | | __   / /  \ V /                "
ECHO " `--. \ '_ ` _ \ / _` | | | __/ _` | | |/ /  / /   /   \                "
ECHO "/\__/ / | | | | | (_| | | | || (_| | |   <  / /   / /^\ \               "
ECHO "\____/|_| |_| |_|\__,_|_|_|\__\__,_|_|_|\_\/_/    \/   \/               "
ECHO "                                                                        "
ECHO " _    _ _                  _                            _               "
ECHO "| |  | (_)                | |                          | |              "
ECHO "| |  | |_ _ __    ______  | |     __ _ _   _ _ __   ___| |__   ___ _ __ "
ECHO "| |/\| | | '_ \  |______| | |    / _` | | | | '_ \ / __| '_ \ / _ \ '__|"
ECHO "\  /\  / | | | |          | |___| (_| | |_| | | | | (__| | | |  __/ |   "
ECHO " \/  \/|_|_| |_|          \_____/\__,_|\__,_|_| |_|\___|_| |_|\___|_|   "
ECHO:
ECHO Author:   Patrik Svestka
ECHO Contact: "patrik.svestka|dot|gmail<dot>com"
ECHO Alias:    tukanos
ECHO You can find me at: Bitbucket(https://bitbucket.org/-tukanos-/) or github (https://github.com/tukanos/)
ECHO:
ECHO License:  MIT License (more at https://opensource.org/licenses/MIT)
ECHO:
ECHO Versions: The %~nx0 executed is at version: "=>%~1<="
ECHO           Smalltalk/X is at version: "=>%~2<="
ECHO:
ECHO Special thanks:   Jan Vrany         - for Smalltalk and VM support during writing of this script
ECHO                   Claus Gittinger   - for creating all Smalltalk/X environment
ECHO:
ECHO                   Rob van der Woude - for having great pages about batch files  (http://http://www.robvanderwoude.com)
ECHO                   Simon Sheppard - for having great catalog at (https://ss64.com/nt/)
ECHO:
ECHO This script was tested on: Windows 7 SP1 x64 (enterprise), Windows XP SP3 x86 (stx-bin),
ECHO                            Windows 10 Pro (10.0.14393), (thanks Jan), Window 2008 R2 SP1 x64 (enterprise)
ECHO:
ECHO Short description: This file enables you to run stx(-bin).com(exe) with additional features like:
ECHO Logging, quick start, starting via image (default or with user interaction), etc.
ECHO:
ECHO To find out more on how to run this .bat file with --help-launcher switch

GOTO :EOF

:: =================
:: Version section =
:: =================
:stx_version
ECHO The %~nx0 executed is at version: "=>%~1<="
ECHO:
ECHO Smalltalk/X is at version: "=>%~2<="
ECHO:
ECHO The stx(-bin).com version output:
IF EXIST "stx-bin.com" (
    CALL stx-bin.com --version
) ELSE IF EXIST "stx.com" (
    CALL stx.com --version
) ELSE (
    ECHO "[WARN] The executable stx-bin.^(com^|exe^) or stx.^(com^|exe^) NOT found.""
    ECHO "[WARN] Exiting with error. Script __numeric.exit_value: 1."
    PAUSE
    GOTO :EOF
)

GOTO :EOF

:: *******************************************************************************************
:: End                                                                                       *
:: *******************************************************************************************