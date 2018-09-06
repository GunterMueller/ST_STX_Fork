"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

ValueModel subclass:#ValueHolder
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!ValueHolder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    A valueHolder can be used as a model for editFields, buttons etc.
    It stores some value internally, and sends update messages to its
    dependents when changed.

    Notice:
        this class was implemented using protocol information
        from alpha testers - it may not be complete or compatible to
        the corresponding ST-80 class.
        If you encounter any incompatibilities, please forward a note
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger
"
!

examples 
"
    See many examples in DialogBox & EditField

    edit strings:
                                                                        [exBegin]
        |firstName lastName dialog|

        firstName := ValueHolder newString.
        lastName := ValueHolder newString.

        dialog := Dialog new.
        (dialog addTextLabel:'Name:') adjust:#left.
        dialog addInputFieldOn:firstName.
        dialog addVerticalSpace.
        (dialog addTextLabel:'Address:') adjust:#left.
        dialog addInputFieldOn:lastName.

        dialog addAbortButton; addOkButton.

        dialog open.
        dialog accepted ifTrue:[
            Transcript show:firstName value; show:' '; showCR:lastName value
        ]
                                                                        [exEnd]
"
! !

!ValueHolder class methodsFor:'instance creation'!

newBoolean
    "return a new ValueHolder holding false as initial value"

    ^ self with:false
!

newFraction
    "return a new ValueHolder holding 0.0 as initial value.
     The name is somewhat missleading - actually it should be called newFloat."

    ^ self with:0.0
!

newNumber
    "return a new ValueHolder holding 0 as initial value"

    ^ self with:0 
!

newString
    "return a new ValueHolder holding an empty string as initial value"

    ^ self with:''
!

with:anObject
    "return a new ValueHolder holding anObject as initial value"

    ^ (super new) setValue:anObject
! !

!ValueHolder methodsFor:'accessing'!

setValue:anObject
    "set my value without notification."

    value := anObject.
!

value
    "return my value"

    ^ value
! !

!ValueHolder methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    aGCOrStream
        nextPutAll:self class name;
        nextPut:$(.
    value displayOn:aGCOrStream.
    aGCOrStream nextPut:$)
!

printOn:aStream
    "return a string for display in inspectors etc."

    self class name printOn:aStream.
    aStream nextPutAll:'('.
    value printOn:aStream.
    aStream nextPutAll:')'
! !

!ValueHolder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

