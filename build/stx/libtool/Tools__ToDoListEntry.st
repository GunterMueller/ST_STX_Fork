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

Object subclass:#ToDoListEntry
	instanceVariableNames:'list stillValid severity priority timestamp message'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk-ToDo'
!

!ToDoListEntry class methodsFor:'documentation'!

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

!ToDoListEntry methodsFor:'accessing'!

errorColor
    ^ Color rgbValue:16rCF0000
!

hasHighSeverity
    ^ (severity ? 0) >= (Tools::ToDoList errorSeverity)
!

list:something
    list := something.
!

message
    self hasHighSeverity ifTrue:[ 
        ^ message colorizeAllWith:self errorColor
    ].

    ^ message
!

message:something
    message := something.
!

priority
    ^ priority ? 0

    "Modified: / 22-10-2006 / 11:09:36 / cg"
!

priority:priorityOrPrioritySymbol 
    priorityOrPrioritySymbol isSymbol ifTrue:[
        priorityOrPrioritySymbol == #low ifTrue:[
            priority := ToDoList lowPriority.
            ^ self.
        ].
        priorityOrPrioritySymbol == #medium ifTrue:[
            priority := ToDoList mediumPriority.
            ^ self.
        ].
        priorityOrPrioritySymbol == #high ifTrue:[
            priority := ToDoList highPriority.
            ^ self.
        ].
        self error:'bad argument'
    ].
    priority := priorityOrPrioritySymbol.
!

priorityString
    |s|

    s := (priority ? 0) printString.
    self hasHighSeverity ifTrue:[ 
        ^ s colorizeAllWith:self errorColor
    ].
    ^ s

    "Modified: / 22-10-2006 / 11:09:36 / cg"
!

severity
    ^ severity ? 0

    "Modified: / 22-10-2006 / 11:09:42 / cg"
!

severity:severityOrSeveritySymbol
    severityOrSeveritySymbol isSymbol ifTrue:[
        severityOrSeveritySymbol == #info ifTrue:[
            severity := ToDoList infoSeverity.
            ^ self.
        ].
        severityOrSeveritySymbol == #warning ifTrue:[
            severity := ToDoList warningSeverity.
            ^ self.
        ].
        severityOrSeveritySymbol == #error ifTrue:[
            severity := ToDoList errorSeverity.
            ^ self.
        ].
        self error:'bad argument'
    ].
    severity := severityOrSeveritySymbol.
!

severity:severityArg priority:priorityArg timestamp:timestampArg message:messageArg 
    self severity:severityArg.
    self priority:priorityArg.
    timestamp := timestampArg.
    message := messageArg.
!

severityString
    |sev|

    sev := self severity.
    sev >= (Tools::ToDoList errorSeverity) ifTrue:[ ^ 'E' allBold colorizeAllWith:self errorColor].
    sev >= (Tools::ToDoList warningSeverity) ifTrue:[ ^ 'W' ].
    sev >= (Tools::ToDoList infoSeverity) ifTrue:[ ^ 'i' ].
    ^ ' '

    "Modified: / 22-10-2006 / 11:09:42 / cg"
!

stillValid
    ^ stillValid ? true

    "Created: / 21-10-2006 / 20:45:33 / cg"
!

time
    ^ timestamp asTime

    "Created: / 21-10-2006 / 20:58:14 / cg"
!

timestamp
    ^ timestamp
! !

!ToDoListEntry methodsFor:'duplicate detection'!

isAlreadyPresentIn:aList
    ^ aList contains:[:anEntry | anEntry sameAs:self ].

    "Created: / 21-10-2006 / 21:36:57 / cg"
!

sameAs:anotherEntry
    self subclassResponsibility

    "Created: / 21-10-2006 / 21:37:42 / cg"
!

sameAsCompilerWarningToDoListEntry:anotherEntry
    ^ false

    "Created: / 21-10-2006 / 21:40:47 / cg"
! !

!ToDoListEntry methodsFor:'initialization'!

initialize
    severity := Tools::ToDoList warningSeverity.
    priority := Tools::ToDoList highPriority.
    timestamp := Timestamp now.
    message := 'Check this'

    "Created: / 20-11-2006 / 15:00:39 / cg"
! !

!ToDoListEntry methodsFor:'misc'!

browse
    self subclassResponsibility

    "Created: / 22-10-2006 / 01:37:42 / cg"
! !

!ToDoListEntry methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:message

    "Created: / 21-10-2006 / 23:13:39 / cg"
! !

!ToDoListEntry methodsFor:'validation'!

checkIfStillValid
    self subclassResponsibility

    "Created: / 21-10-2006 / 21:30:29 / cg"
!

revalidate
    self checkIfStillValid ifFalse:[
        stillValid := false.
        list removeIdentical:self ifAbsent:[].
        Smalltalk removeDependent:self.
    ].

    "Created: / 21-10-2006 / 20:46:03 / cg"
    "Modified: / 21-10-2006 / 22:00:52 / cg"
! !

!ToDoListEntry class methodsFor:'documentation'!

version
    ^ '$Id: Tools__ToDoListEntry.st 7854 2012-01-30 17:49:41Z vranyj1 $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__ToDoListEntry.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

