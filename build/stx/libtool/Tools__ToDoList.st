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

List subclass:#ToDoList
	instanceVariableNames:'validationPending validationProcess validationInvalid'
	classVariableNames:'TheOneAndOnlyToDoList WarningSeverity ErrorSeverity InfoSeverity'
	poolDictionaries:''
	category:'Interface-Smalltalk-ToDo'
!

!ToDoList class methodsFor:'documentation'!

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

!ToDoList class methodsFor:'accessing'!

theOneAndOnlyToDoList
    TheOneAndOnlyToDoList isNil ifTrue:[
        TheOneAndOnlyToDoList := self new.
    ].
    ^ TheOneAndOnlyToDoList

    "
     TheOneAndOnlyToDoList := nil
    "

    "Created: / 21-10-2006 / 20:57:48 / cg"
    "Modified: / 21-10-2006 / 23:06:27 / cg"
! !

!ToDoList class methodsFor:'class initialization'!

initialize
    WarningSeverity := 1.
    ErrorSeverity := 2.
    InfoSeverity := 0.

    "
     TheOneAndOnlyToDoList := nil.
     self initialize
    "

    "Created: / 21-10-2006 / 19:43:37 / cg"
    "Modified: / 21-10-2006 / 22:11:40 / cg"
! !

!ToDoList class methodsFor:'constants'!

errorSeverity
    ^ ErrorSeverity
!

highPriority
    ^ 75

    "Created: / 21-10-2006 / 20:43:56 / cg"
!

highestPriority
    ^ 100

    "Created: / 21-10-2006 / 20:43:24 / cg"
!

infoSeverity
    ^ InfoSeverity
!

lowPriority
    ^ 25

    "Created: / 21-10-2006 / 20:43:42 / cg"
!

mediumPriority
    ^ 50

    "Created: / 21-10-2006 / 20:43:37 / cg"
!

warningSeverity
    ^ WarningSeverity
! !

!ToDoList methodsFor:'accessing'!

add:anEntry
    (anEntry isAlreadyPresentIn:self) ifFalse:[
        anEntry list:self.
        super add:anEntry.
        Smalltalk addDependent:self.
    ].

    "Created: / 21-10-2006 / 21:14:42 / cg"
    "Modified: / 21-10-2006 / 23:03:13 / cg"
! !

!ToDoList methodsFor:'change & update'!

revalidate
    |wasPending|

    [
        wasPending := validationPending ? false.
        validationPending := true.
        wasPending ifTrue:[
            validationInvalid := true
        ].
    ] valueUninterruptably.
    wasPending ifTrue:[^ self].

    validationProcess := 
        [
            [
                |index entry|

                validationInvalid := false.
                index := 1.
                [index <= self size] whileTrue:[
                    entry := self at:index.
                    entry revalidate.
                    index <= self size ifTrue:[
                        ((self at:index) sameAs:entry) ifTrue:[
                            "/ it did not remove itself
                            index := index + 1
                        ]
                    ].
                    validationInvalid ifTrue:[
                        validationInvalid := false.
                        index := 1.
                    ].
                ].
            ] ensure:[
                validationPending := false.
                validationProcess := nil.
                validationInvalid := false.
            ].
        ] fork.

    "Created: / 21-10-2006 / 23:02:34 / cg"
    "Modified: / 23-10-2006 / 22:40:11 / cg"
!

update:something with:aParameter from:changedObject
     changedObject == Smalltalk ifTrue:[
        something == #methodTrap ifTrue:[^ self].
        self revalidate.
        ^ self.
    ].
    ^ super update:something with:aParameter from:changedObject

    "Created: / 21-10-2006 / 23:02:05 / cg"
    "Modified: / 23-10-2006 / 22:20:52 / cg"
! !

!ToDoList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__ToDoList.st,v 1.4 2008/08/20 19:41:31 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ToDoList initialize!
