"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

UISpecification subclass:#UIEventCallbackSubSpec
	instanceVariableNames:'valueChangeSelector doubleClickSelector focusOutSelector
		focusInSelector requestValueChangeSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!UIEventCallbackSubSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"



!

documentation
"
    Not normally used by applications.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.
"

! !

!UIEventCallbackSubSpec class methodsFor:'interface - painter'!

addBindingsTo:env for:anInstance channel:aChannel


    "/ special - don't add inherited stuff (i.e. no super-addBindings)

    self 
        adaptApects:#(
                        focusInSelector
                        focusOutSelector
                        valueChangeSelector
                        doubleClickSelector
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil

    "Modified: / 26.10.1997 / 03:22:00 / cg"
! !

!UIEventCallbackSubSpec methodsFor:'accessing'!

doubleClickSelector
    "return doubleClickSelector"

    ^ doubleClickSelector

    "Created: 17.1.1997 / 20:15:57 / cg"
!

doubleClickSelector:something
    "set doubleClickSelector"

    doubleClickSelector := something.

    "Created: 17.1.1997 / 20:15:57 / cg"
!

focusInSelector
    "return the value of the instance variable 'focusInSelector' (automatically generated)"

    ^ focusInSelector

    "Created: 28.3.1997 / 21:48:17 / cg"
!

focusInSelector:something
    "set the value of the instance variable 'focusInSelector' (automatically generated)"

    focusInSelector := something.

    "Created: 28.3.1997 / 21:48:17 / cg"
!

focusOutSelector
    "return the value of the instance variable 'focusOutSelector' (automatically generated)"

    ^ focusOutSelector

    "Created: 25.1.1997 / 18:14:23 / cg"
!

focusOutSelector:something
    "set the value of the instance variable 'focusOutSelector' (automatically generated)"

    focusOutSelector := something.

    "Created: 25.1.1997 / 18:14:23 / cg"
!

requestValueChangeSelector
    "return requestValueChangeSelector"

    ^ requestValueChangeSelector

    "Created: / 20.6.1998 / 13:40:15 / cg"
!

requestValueChangeSelector:something
    "set requestValueChangeSelector"

    requestValueChangeSelector := something.

    "Created: / 20.6.1998 / 13:40:20 / cg"
!

valueChangeSelector
    "return valueChangeSelector"

    ^ valueChangeSelector

    "Created: 14.2.1997 / 15:55:23 / cg"
!

valueChangeSelector:something
    "set valueChangeSelector"

    valueChangeSelector := something.

    "Created: 14.2.1997 / 15:55:24 / cg"
! !

!UIEventCallbackSubSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    valueChangeSelector isNil ifTrue:[
        l add:#valueChangeSelector
    ].
    requestValueChangeSelector isNil ifTrue:[
        l add:#requestValueChangeSelector
    ].
    doubleClickSelector isNil ifTrue:[
        l add:#doubleClickSelector
    ].
    focusOutSelector isNil ifTrue:[
        l add:#focusOutSelector
    ].
    focusInSelector isNil ifTrue:[
        l add:#focusInSelector
    ].
    ^ l

    "Created: / 28.3.1997 / 22:04:05 / cg"
    "Modified: / 20.6.1998 / 13:40:37 / cg"
! !

!UIEventCallbackSubSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/UIEventCallbackSubSpec.st,v 1.12 2016-11-04 15:25:48 cg Exp $'
! !

