"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

Object subclass:#DrawAdaptor
	instanceVariableNames:'value drawValue'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!DrawAdaptor class methodsFor:'documentation'!

copyright 
"
 COPYRIGHT (c) 2008 by eXept Software AG
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
    DrawAdaptor constains to values:
        - any Object
        - a replacement Object to be used only for draw operations.

    Use this class whenever you want to show something different for a given object -
    e.g. to show some language specific text instead of a symbol or any object in ComboBoxes/PopUpLists.

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]
        value       Object      the original object
        drawValue   Object      the replacement object used for draw operations

    [class variables:]

    [see also:]

"
!

examples
"
                                                                                    [exBegin]
    |labelList top comboList|

    labelList := DrawAdaptor collection:#(File Classes System Windows)
                             withResources:Launcher classResources.

     top := StandardSystemView new.
     top extent:(300 @ 200).

     comboList := ComboListView in:top.
     comboList origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     comboList bottomInset:(comboList preferredExtent y negated).

     comboList list:labelList.
     comboList contents:labelList first.
     comboList action:[:selected | Transcript showCR:selected realValue].
     top open.
                                                                                     [exEnd]

"
! !

!DrawAdaptor class methodsFor:'instance creation'!

collection:aCollectionOfObjects withResources:resourcePack
    "create a collection of DrawAdaptors from aCollectionOfObjects (usually strings or symbols).
     Use resourcePack to do the translation"

    ^ aCollectionOfObjects collect:[:each|
            self value:each withResources:resourcePack
        ].


    "
      self collection:#(a File c) withResources:Launcher classResources
    "
!

value:value
    ^ self new realValue:value
!

value:value drawValue:drawValue 
    ^ self new value:value drawValue:drawValue 
!

value:anObject withResources:resourcePack
    "Create a DrawAdaptor for anObject,
     Resolved via the translations in resourcePack"

    ^ self new value:anObject drawValue:(resourcePack string:anObject)

    "
      self value:#Hello withResources:Launcher classResources
    "
! !

!DrawAdaptor methodsFor:'accessing'!

asString
    ^ drawValue
!

drawValue
    ^ drawValue ? value
!

drawValue:something
    drawValue := something.
!

realValue
    ^ value
!

realValue:something
    value := something.
!

string
    ^ drawValue
!

value:valueArg drawValue:drawValueArg 
    value := valueArg.
    drawValue := drawValueArg.
! !

!DrawAdaptor methodsFor:'comparing'!

= anObject
    "two TranslatedSymbols are equal, if they have the same symbol"

    self species == anObject species ifTrue:[
        ^ value = anObject realValue.
    ].
    ^ value = anObject.

    "
        (self value:#hash drawValue:'x') = #hash
        (self value:#hash drawValue:'x') = 1
        (self value:#hash drawValue:'x') = (self value:#hash drawValue:'y')
    "
!

hash
    "equal, if they have the same realObject"

    ^ value hash
! !

!DrawAdaptor methodsFor:'delegation drawing'!

ascentOn:aGc
    ^ self drawValue ascentOn:aGc
!

displayOn:aGCOrStream
    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        self drawValue displayOn:aGCOrStream x:0 y:0.
    ] ifTrue:[
        aGCOrStream
            nextPutAll:self className;
            nextPut:$(.
        self realValue printOn:aGCOrStream.
        aGCOrStream nextPutAll:'->'.
        self drawValue printOn:aGCOrStream.
        aGCOrStream nextPut:$).
    ].
!

displayOn:aGc x:x y:y opaque:opaque
    "copied from object, but do the ascent handling here"

    self drawValue displayOn:aGc x:x y:y opaque:opaque.
!

heightOn:aGC
    "return the height of the receiver, if it is to be displayed on aGC"

    ^ self drawValue heightOn:aGC
!

printOn:aStream
    "this hast to be redefined to allow access from ComboLists via pressing the first character key"

    ^ self drawValue printOn:aStream
!

widthFrom:startIndex to:endIndex on:aGC
    "return the width of the receiver, if it is to be displayed on aGC"

    ^ self drawValue widthFrom:startIndex to:endIndex on:aGC
!

widthOn:aGc
    ^ self drawValue widthOn:aGc
! !

!DrawAdaptor methodsFor:'misc'!

rebindWith:resources
    drawValue := resources string:value
! !

!DrawAdaptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/DrawAdaptor.st,v 1.7 2014-07-10 12:23:21 cg Exp $'
! !

