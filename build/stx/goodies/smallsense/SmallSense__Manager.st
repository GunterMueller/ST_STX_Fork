"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

Object subclass:#Manager
	instanceVariableNames:'classes accessLock updater updaterThread seqno'
	classVariableNames:'Instance'
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Types-Info'
!

!Manager class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!Manager class methodsFor:'instance creation'!

flush
    "flushes the cached singleton"

    self flushSingleton

    "
     self flushSingleton
    "

    "Created: / 16-12-2011 / 01:37:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2014 / 17:34:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flushSingleton
    "flushes the cached singleton"

    Instance notNil ifTrue:[ 
        Instance release.
    ].
    Instance := nil

    "
     self flushSingleton
    "

    "Modified: / 21-11-2014 / 17:34:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instance
    "returns a singleton"

    Instance isNil ifTrue:[
        Instance := self new
    ].
    ^ Instance.

    "Created: / 27-11-2011 / 15:30:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2015 / 14:29:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    ^ self basicNew initialize.

    "Modified: / 21-08-2015 / 14:30:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Manager methodsFor:'accessing'!

infoForClass: class

    | info |

    accessLock critical:[
        info := self basicInfoForClass: class.
    ].
    ^info

    "Created: / 27-11-2011 / 16:15:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoForClassOrNil: class

    ^classes at: class name ifAbsent: nil

    "Created: / 27-11-2011 / 17:15:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Manager methodsFor:'accessing-private'!

basicInfoForClass: class

    class isNil ifTrue:[^nil].

    ^classes at: class name ifAbsentPut:[
        ClassInfo new
            setManager: self
            className: class name
    ].

    "Created: / 27-11-2011 / 16:47:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Manager methodsFor:'change & update'!

update:what with:param from:sender
    "Invoked when an object that I depend upon sends a change notification."

    UserPreferences current smallSenseBackgroundTypingEnabled ifFalse:[ ^ self ].

    sender ~~ Smalltalk ifTrue:[
        super update:what with:param from:sender.
        ^self.
    ].

    what == #methodInClass ifTrue:[
        "/ If this is anonymous class, do not bother...        

        | nm |

        nm := param first name.
        (nm isSymbol and:[ Smalltalk includesKey: nm ]) ifTrue:[
            self updateInfoForMethod: (param first >> param second).
        ].
        ^self.
    ].
    

"/    Transcript show: 'SmallSense: Smalltalk changed: ', what , ' with: ', param printString.

    "Modified: / 18-03-2014 / 12:27:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Manager methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    classes := Dictionary new.
    accessLock := Semaphore forMutualExclusion.
    updater := BackgroundQueueProcessingJob 
                    named: 'SmallSense background updater' 
                    on: [:classOrMethod|self delayedUpdateInfoForClassOrMethod: classOrMethod].
    updater priority: Processor userBackgroundPriority - 1.

    UserPreferences current smallSenseEnabled ifTrue:[
        Smalltalk addDependent: self.
    ].
    seqno := 0

    "Modified: / 22-10-2013 / 10:56:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    "Invoked when a new instance is created."

    classes := nil.
    accessLock := Semaphore forMutualExclusion.
    updater stopAndRemoveAll.

    UserPreferences current smallSenseEnabled ifTrue:[
        Smalltalk removeDependent: self.
    ].

    "Created: / 21-11-2014 / 17:36:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Manager methodsFor:'updating'!

updateInfoForClass: class

    | info |

    class programmingLanguage isSmalltalk ifFalse:[ ^ self ].
    info := self infoForClassOrNil: class.
    (info isNil or:[(info seqno ? 0) < (seqno - 100)]) ifTrue:[
        updater add: class
    ].
    seqno := seqno == SmallInteger maxVal ifTrue: [1] ifFalse:[seqno + 1]

    "Created: / 27-11-2011 / 17:46:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-10-2013 / 11:38:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateInfoForMethod: method

    | info |

    method programmingLanguage isSmalltalk ifFalse:[ ^ self ].
    info := self basicInfoForClass: method mclass.
    info isNil ifTrue:[
        updater add: method mclass
    ] ifFalse:[
        updater add: method
    ]

    "Created: / 28-11-2011 / 19:30:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Manager methodsFor:'updating-delayed'!

delayedUpdateInfoForClass: class

    | superclass info instVarNames instVarTypes probe nprobed sourceStream |

    superclass := class superclass.
    superclass notNil ifTrue:[self updateInfoForClass: superclass].
    info := self infoForClass: class.
    info isErrorneous ifTrue:[ ^ self ].
    info seqno: seqno.
    [
        instVarNames := class allInstVarNames.
        instVarTypes := instVarNames collect: [:instvar | info infoForInstvar: instvar ]. 
        "/ Check for the source stream - if none, then do not add methods (one cannot
        "/ infer types without a source anyway  and mark the class errorneous...
        [ 
            sourceStream := class sourceStream.
        ] on: Error do:[ 
            sourceStream := nil.
            info errorneous: true. 
            ^ self.
        ].
        class methodsDo:[:mthd|updater add:mthd].

        probe := [:instance |
            instVarTypes withIndexDo: [:instVarType :i | 
                instVarType union: ((Type withClass: (instance instVarAt: i) class) type trustfullness: 70). 
            ].
            nprobed := nprobed + 1.
            nprobed > 100 ifTrue:[
                "/ Probe at most 100 instancess
                ^ self
            ].   
        ].
        nprobed := 0.
        class allInstancesDo: probe.
        "/ Maube an abstract class?
        nprobed < 100 ifTrue:[ 
            class allSubInstancesDo: probe
        ].
    ] on: Error do:[:ex |  
        info errorneous: true.  
        Logger error:'Error when infering instvars for %1: %2' with: class name with: ex description
    ]

    "Created: / 27-11-2011 / 18:04:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2015 / 17:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delayedUpdateInfoForClassOrMethod: classOrMethod
    | currentThread |

    currentThread := Processor activeProcess.
    updaterThread ~~ currentThread ifTrue:[ 
        updaterThread := currentThread.
        updaterThread addExitAction:[ 
            updater stopAndRemoveAll.
        ].
    ].

    [
        classOrMethod isBehavior ifTrue:[
           self delayedUpdateInfoForClass: classOrMethod.
        ].
        classOrMethod isMethod ifTrue:[
           self delayedUpdateInfoForMethod: classOrMethod.
        ]
    ] on: Error do:[:ex|
        Logger error: 'Error when infering for %1: %2' with: classOrMethod with: ex description.
    ]

    "Created: / 27-11-2011 / 18:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2014 / 17:39:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delayedUpdateInfoForMethod: method

    | inferencer |

    [
        method mclass isNil ifTrue:["Obsolete method" ^ self ].
        method mclass programmingLanguage isSmalltalk ifFalse: [ ^ self ].
    "/    Transcript showCR: 'SmallSense: updating info for: ', method printString.
        inferencer := SmalltalkInferencer forMethod: method.
        inferencer process.
    ] on: Error do:[:ex |  
        Logger error:'Error when infering for method %1: %2' with: method printString with: ex description
    ]

    "Created: / 27-11-2011 / 18:06:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 21-11-2014 / 16:55:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Manager class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

