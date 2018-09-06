"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ToDoListEntry subclass:#CompilerWarningToDoListEntry
	instanceVariableNames:'checkAction className class selector position equalityParameter'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk-ToDo'
!

!CompilerWarningToDoListEntry class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!CompilerWarningToDoListEntry class methodsFor:'instance creation'!

new
    ^ self basicNew initialize

    "Created: / 20-11-2006 / 14:58:52 / cg"
! !

!CompilerWarningToDoListEntry class methodsFor:'notification'!

notifyTodo:msg position:position
     className:className selector:selector
     severity:severityOrSeveritySymbol priority:priorityOrPrioritySymbol
     equalityParameter:equalityParameter checkAction:checkAction

    |entry brwsr|

    (brwsr := Tools::ToDoListBrowser current) isNil ifTrue:[^ self ].

    entry := self new.
    entry
        severity:severityOrSeveritySymbol
        priority:priorityOrPrioritySymbol
        timestamp:(Timestamp now)
        message:msg
        className:className
        selector:selector
        checkAction:checkAction
        equalityParameter:equalityParameter
        position:position.

    (Tools::ToDoNotification notNil and:[Tools::ToDoNotification isHandled]) ifTrue:[
        Tools::ToDoNotification raiseRequestWith:entry
    ] ifFalse:[
        brwsr addEntry:entry
    ].

    "Created: / 15-03-2007 / 18:08:06 / cg"
! !

!CompilerWarningToDoListEntry methodsFor:'accessing'!

className
    ^ className

    "Created: / 22-10-2006 / 01:39:43 / cg"
!

className:classNameArg selector:selectorArg checkAction:checkActionArg equalityParameter:equalityParameterArg 
    checkAction := checkActionArg.
    className := classNameArg.
    selector := selectorArg.
    equalityParameter := equalityParameterArg.

    "Created: / 22-10-2006 / 01:38:26 / cg"
!

className:classNameArg selector:selectorArg checkAction:checkActionArg equalityParameter:equalityParameterArg position:positionArg
    checkAction := checkActionArg.
    className := classNameArg.
    selector := selectorArg.
    equalityParameter := equalityParameterArg.
    position := positionArg.

    "Created: / 22-10-2006 / 01:38:26 / cg"
!

equalityParameter
    ^ equalityParameter

    "Created: / 21-10-2006 / 21:57:01 / cg"
!

methodOrClassName
    selector isNil ifTrue:[^ className ].
    ^ className,' ',selector

    "Created: / 22-10-2006 / 11:05:21 / cg"
!

position
    ^ position
!

position:something
    position := something.
!

problemClass
    ^ Smalltalk classNamed:className

    "Created: / 21-10-2006 / 21:50:38 / cg"
    "Modified: / 22-10-2006 / 01:39:39 / cg"
!

problemClassName
    ^ className

    "Created: / 22-10-2006 / 01:40:11 / cg"
!

problemMethod
    |cls|

    selector isNil ifTrue:[^ nil].

    cls := self problemClass.
    cls isNil ifTrue:[^ nil].

    ^ cls compiledMethodAt:selector

    "Created: / 22-10-2006 / 02:42:39 / cg"
!

problemSelector
    ^ selector

    "Created: / 21-10-2006 / 21:50:58 / cg"
!

severity:severityArg priority:priorityArg timestamp:timestampArg 
        message:msgArg className:classNameArg selector:selectorArg 
        checkAction:checkActionArg equalityParameter:equalityParameterArg
        position:positionArg

    self
        severity:severityArg 
        priority:priorityArg 
        timestamp:timestampArg 
        message:msgArg.
    self 
        className:classNameArg 
        selector:selectorArg 
        checkAction:checkActionArg 
        equalityParameter:equalityParameterArg.
    self
        position:positionArg
!

update:something with:aParameter from:changedObject
    self revalidate.

    "Created: / 21-10-2006 / 21:28:35 / cg"
! !

!CompilerWarningToDoListEntry methodsFor:'duplicate detection'!

sameAs:anotherEntry
    ^ anotherEntry sameAsCompilerWarningToDoListEntry:self

    "Created: / 21-10-2006 / 21:38:15 / cg"
!

sameAsCompilerWarningToDoListEntry:anotherEntry
    anotherEntry problemClassName = className ifFalse:[^ false].
    anotherEntry problemSelector = selector ifFalse:[^ false].
    anotherEntry equalityParameter = equalityParameter ifFalse:[^ false].
    anotherEntry message = message ifFalse:[^ false].
    ^ true

    "Created: / 21-10-2006 / 21:41:57 / cg"
    "Modified: / 22-10-2006 / 01:40:03 / cg"
! !

!CompilerWarningToDoListEntry methodsFor:'misc'!

browse
    |brwsr pos|

    brwsr := UserPreferences browserClass 
        openInClass:(self problemClass) selector:selector.

    (pos := position) isArray ifTrue:[
        pos := pos first.
    ] ifFalse:[
        (pos isKindOf:Interval) ifTrue:[
            pos := pos start.
        ]
    ].

    brwsr codeView cursorToCharacterPosition:pos.
"/    brwsr codeView selectLine:(brwsr codeView cursorLine).

    "Created: / 22-10-2006 / 01:38:11 / cg"
    "Modified: / 11-11-2006 / 14:49:35 / cg"
! !

!CompilerWarningToDoListEntry methodsFor:'validation'!

checkByReparsing
    |stillValid cls mthd|

    Tools::ToDoNotification isNil ifTrue:[^ false].

    stillValid := false.
    Tools::ToDoNotification handle:[:ex |
        stillValid := (ex parameter sameAs:self).
        ex proceed.
    ] do:[
        (cls := self problemClass) isNil ifTrue:[
            "/ class is gone.
            ^ false.
        ].
        (mthd := cls compiledMethodAt:selector) isNil ifTrue:[   
            "/ mthod is gone
            ^ false.
        ].
        Compiler 
            compile:mthd source 
            forClass:cls
            install:false.
    ].
    ^ stillValid.

    "Created: / 21-10-2006 / 21:31:27 / cg"
    "Modified: / 20-11-2006 / 15:34:29 / cg"
!

checkIfClassIsStillValid
    className notNil ifTrue:[
        (Smalltalk classNamed:className) isNil ifTrue:[^ false].
    ].
    ^ true

    "Created: / 21-10-2006 / 21:58:26 / cg"
    "Modified: / 22-10-2006 / 01:41:53 / cg"
!

checkIfSelectorIsStillValid
    selector notNil ifTrue:[
        self problemClass isNil ifTrue:[^ false].      
        (self problemClass compiledMethodAt:selector) isNil ifTrue:[^ false].
    ].
    ^ true

    "Created: / 21-10-2006 / 21:58:44 / cg"
    "Modified: / 22-10-2006 / 01:40:40 / cg"
!

checkIfStillValid
    self checkIfClassIsStillValid ifFalse:[^ false].
    self checkIfSelectorIsStillValid ifFalse:[^ false].

    checkAction isNil ifTrue:[
        ^ self checkByReparsing
    ].

    ^ (checkAction value:self)

    "Created: / 21-10-2006 / 21:31:27 / cg"
    "Modified: / 20-11-2006 / 15:34:29 / cg"
! !

!CompilerWarningToDoListEntry class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__CompilerWarningToDoListEntry.st,v 1.13 2015-02-20 13:12:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__CompilerWarningToDoListEntry.st,v 1.13 2015-02-20 13:12:01 cg Exp $'
! !

