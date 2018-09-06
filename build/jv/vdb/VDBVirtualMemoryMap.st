"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

Object subclass:#VDBVirtualMemoryMap
	instanceVariableNames:'regions'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Tools'
!

!VDBVirtualMemoryMap class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBVirtualMemoryMap class methodsFor:'instance creation'!

fromSysInternalsVmmapDump: aStringOrFilenameOrStream
    | s |

    s := aStringOrFilenameOrStream readStream.
    ^ [
        self new initializeFromSysInternalsVmmapDump: s
    ] ensure:[ 
        s close.
    ].

    "Created: / 13-10-2017 / 12:11:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVirtualMemoryMap methodsFor:'reading'!

initializeFromSysInternalsVmmapDump: aStream
    "
    Initializes regions from SysInterna's vmmap.exe dump (.mmp)
    "
    | dump snapshot |

    dump := XML::XMLParser parse: aStream.
    snapshot := (dump / 'root' / 'Snapshots' / 'Snapshot') last.
    regions := (snapshot / 'MemoryRegions' / 'Region') 
                select:[ :node | 
                    (node @ 'Commit') ~= '0'.
                ]
                thenCollect:[ :node |
                    | region |

                    region := VDBVirtualMemoryRegion new
                                address:     (node @ 'Address') asInteger;
                                size:        (node @ 'Size') asInteger;
                                protection:  (node @ 'Protection') asInteger;
                                comment:     (node @ 'Details');
                                yourself.
                ] as: OrderedCollection.

    regions sort:[ :a :b | a address  < b address ].

    "Created: / 13-10-2017 / 12:06:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

