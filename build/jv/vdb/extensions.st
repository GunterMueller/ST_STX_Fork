"{ Package: 'jv:vdb' }"!

!GDBDebugger methodsFor:'event handling'!

onRRExitEvent:anRRExitEvent
    | status |

    anRRExitEvent rr announcer unsubscribe: self.
    status := anRRExitEvent status.
    (status success or:[ status status == #signal and:[status code == OperatingSystem sigTERM ]]) ifFalse:[ 
        Dialog warn: (self class classResources string: 'Replay server terminated with error')
    ].

    "Created: / 31-07-2018 / 09:37:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'commands - API'!

targetConnectRR: rr
    "Connect to rr replay server"

    "/ rr suggest to connect as follows:
    "/ 
    "/     gdb '-l' '10000' '-ex' 'set sysroot /' '-ex' 'target extended-remote 127.0.0.1:9876' ...
    "/
    self send: (GDBMI_gdb_set arguments: #('sysroot' '/')).
    self targetConnect: 'extended-remote'  parameters: (Array with: '127.0.0.1:' with: rr port).
    rr announcer when: RRExitEvent send: #onRRExitEvent: to: self.

    "Created: / 26-07-2018 / 21:48:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2018 / 09:38:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject methodsFor:'inspecting'!

inspector2TabVariable
    <inspector2Tab>

    | varObjApp |

    varObjApp := Smalltalk at: #VDBVariableObjectListApplication ifAbsent:[ ^ nil ].
    ^ (self newInspector2Tab)
        label:'Variable';
        priority:95;
        "/ view: [ ... ];
        application: [ varObjApp new debugger: debugger; variableObjectList: (Array with: self); yourself ];
        "/ text: [ ... ];
        yourself

    "Modified: / 03-02-2018 / 09:58:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-vdb'!

vdbFrameFiltersEnabled
    "Return true, if VDB should enable frame filters by default."

    ^ self at: #vdbFrameFiltersEnabled ifAbsent:[ false ].

    "    
    UserPreferences current vdbFrameFiltersEnabled.
    UserPreferences current vdbFrameFiltersEnabled: true.
    UserPreferences current vdbFrameFiltersEnabled: false.
    "

    "Created: / 10-04-2018 / 11:05:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-vdb'!

vdbFrameFiltersEnabled: aBoolean
    "Set whether VDB should enable frame filters by default."

    ^ self at: #vdbFrameFiltersEnabled put: aBoolean

    "    
    UserPreferences current vdbFrameFiltersEnabled.
    UserPreferences current vdbFrameFiltersEnabled: true.
    UserPreferences current vdbFrameFiltersEnabled: false.
    "

    "Created: / 10-04-2018 / 11:05:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-vdb'!

vdbPrettyPrintingEnabled
    "Return true, if VDB should enable pretty printing by default."

    ^ self at: #vdbPrettyPrintingEnabled ifAbsent:[ false ].

    "    
    UserPreferences current vdbPrettyPrintingEnabled.
    UserPreferences current vdbPrettyPrintingEnabled: true.
    UserPreferences current vdbPrettyPrintingEnabled: false.
    "

    "Created: / 10-04-2018 / 11:06:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-vdb'!

vdbPrettyPrintingEnabled: aBoolean
    "Set whether VDB should enable pretty printing by default."

    ^ self at: #vdbPrettyPrintingEnabled put: aBoolean

    "    
    UserPreferences current vdbPrettyPrintingEnabled.
    UserPreferences current vdbPrettyPrintingEnabled: true.
    UserPreferences current vdbPrettyPrintingEnabled: false.
    "

    "Created: / 10-04-2018 / 11:06:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!jv_vdb class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
