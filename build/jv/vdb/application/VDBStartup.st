"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb/application' }"

"{ NameSpace: Smalltalk }"

StandaloneStartup subclass:#VDBStartup
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI'
!

!VDBStartup class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBStartup class methodsFor:'constants & defaults'!

applicationRegistryPath
    "the key under which this application stores its process ID in the registry
     as a collection of path-components.
     i.e. if #('foo' 'bar' 'baz') is returned here, the current applications ID will be stored
     in HKEY_CURRENT_USER\Software\foo\bar\baz\CurrentID.
     (would also be used as a relative path for a temporary lock file under unix).
     Used to detect if another instance of this application is already running."

    ^ #('vdb')

    "Modified: / 21-09-2014 / 01:29:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

applicationUUID
    "answer an application-specific unique uuid.
     This is used as the name of some exclusive OS-resource, which is used to find out,
     if another instance of this application is already running.
     Under win32, a mutex is used; under unix, an exclusive file in the tempDir could be used.
     If redefined, please return a real UUID (i.e. UUID fromString:'.....') and not a string or
     similar possibly conflicting identifier.
     You can paste a fresh worldwide unique id via the editor's more-misc-paste UUID menuFunction."

    ^ UUID fromString:'57b09330-4126-11e4-a80f-606720e43e2c'

    "Modified: / 21-09-2014 / 01:29:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBStartup class methodsFor:'defaults'!

allowDebugOption
    "enable/disable the --debug startup option.
     Can be redefined in subclasses to enable it"

    ^ true

    "Created: / 08-09-2014 / 19:30:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBStartup class methodsFor:'private'!

loadPreferenceFile: file

    "Created: / 07-06-2017 / 09:49:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBStartup class methodsFor:'queries'!

applicationName
    ^ 'vdb'

    "Created: / 06-06-2017 / 22:50:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBStartup class methodsFor:'startup'!

main:argv
    "Application entry point. `argv` is the array of command arguments (as Array of Strings)"

    | optparser positional settingsFile settingsSuppressed replay 
      programExecutable programArgs programPid attach 
      debugger debuggerApp |

    settingsSuppressed := false.
    replay := false.
    attach := false.

    "/ Parse options...
    optparser := CmdLineParser new
                    ignoreUnknownOptions: true;
                    on: #('--help') do:[
                        self usage
                    ];
                    on: #('--preferences') do:[:filename |
                        | file |

                        file := filename asFilename.
                        file isReadable ifFalse:[
                            self error: 'preference file does not exists or not readable: ' , filename.
                        ].
                        file isRegularFile ifFalse:[
                            self error: 'preference file is not a regular file: ' , filename.
                        ].
                        settingsFile := file.
                    ];
                    on: #('--no-preferences') do:[
                        settingsSuppressed := true
                    ];
                    on: #('--replay') do:[
                        replay := true
                    ];
                    yourself.
    [
        positional := optparser parse:argv.
    ] on: CmdLineOptionError do:[:ex |
        self error: ex description.
    ].


    "/ Now validate and process options
    settingsSuppressed ifFalse:[
        | settings |

        settingsFile notNil ifTrue:[
            settingsFile exists ifFalse:[
                self error: 'preference file does not exist: ', settingsFile pathName
            ].
            settingsFile isDirectory ifTrue:[
                self error: 'preference file is not a regular file: ', settingsFile pathName
            ].
            settingsFile isReadable ifFalse:[
                self error: 'preference file is not a readable (check permissions): ', settingsFile pathName
            ].
            settings := UserPreferences loadSettingsFrom: settingsFile.
        ] ifFalse:[
            settings := UserPreferences loadSettings.
        ].
        UserPreferences setCurrent: settings.
    ].

    replay ifTrue:[ 
        OperatingSystem isLinuxLike ifFalse:[ 
            self error: 'replay not supported on this platform'.
        ].
        RR available ifFalse:[ 
            self error: 'cannot replay because rr not available'
        ].
    ].

    "/ Parse positional arguments - there are two forms:
    "/
    "/   vdb [OPTIONS] [PROGRAM [ARGS]]
    "/   vdb [OPTIONS] [PID]
    "/
    "/ [OPTIONS] have already been processed, the rest is in `positional`
    "/ variable

    positional notEmpty ifTrue:[
        programExecutable := positional first.
        programExecutable asFilename exists ifFalse:[
            "Try to find the executable in PATH..."

            | path |

            path := OperatingSystem pathOfCommand: programExecutable.
            path notNil ifTrue:[
                programExecutable := path.
            ].
        ].
        programPid := Integer fromString: positional first onError: [ nil ].
        programArgs := positional copyFrom: 2.

        replay ifTrue:[ 
            programArgs notEmptyOrNil ifTrue:[ 
                self error: 'cannot specify program args when replaying'.
            ].
        ] ifFalse:[
            "/ If * programExecutable does not exists
            "/    * AND programPid is not nil (i.e., first positional argument can be converted to an integer)
            "/    * AND programArguments are empty
            "/ then interpret positional argument as PID and attach to it.
            "/ Otherwise, interpret positional arguments
            (programExecutable asFilename exists not and: [ programPid notNil and: [ programArgs isEmpty ]]) ifTrue:[
                attach := true.
            ] ifFalse:[
                programExecutable asFilename exists ifFalse:[
                    self error: 'cannot find program executable: ', programExecutable.
                ].
            ].
        ].
    ].

    Debugger := DebugView ? MiniDebugger.
    Inspector := InspectorView ? MiniInspector.

    debugger := GDBDebugger new.
    attach ifTrue:[
        debugger attach: programPid
    ] ifFalse:[
        programExecutable notNil ifTrue:[
            debugger executable: programExecutable arguments: programArgs.
        ].
    ].
    Smalltalk openDisplay.
    debuggerApp := VDBDebuggerApplication new.
    debuggerApp debugger: debugger.
    debuggerApp open.
    replay ifTrue:[ 
        debuggerApp doAttachToRR
    ]. 

    "
        VDBStartup main: #()
        VDBStartup main: #('ls')
        VDBStartup main: #('/bin/ls' '/tmp')
    "

    "Modified: / 29-07-2018 / 08:51:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usage
    Stdout nextPutAll:'usage: '; nextPutAll: self applicationName; nextPutAll: ' [OPTIONS] [PROGRAM [ARGS][ '; cr.
    Stdout nextPutAll:'       '; nextPutAll: self applicationName; nextPutAll: ' [OPTIONS] [PID]'; cr.
                                                                          "|"
    Stdout nextPutLine:'
options:
 --replay ..................... replay last rr record
 --preference FILE ............ read user settings from FILE
 --no-preferences ............. do not read user settings at all
 --help ....................... output this message
'.

    Smalltalk exitIfStandalone: 0.

    "Modified: / 29-07-2018 / 08:55:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBStartup class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

