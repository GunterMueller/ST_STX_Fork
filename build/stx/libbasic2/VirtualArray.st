"
 COPYRIGHT (c) 2012 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

SequenceableCollection subclass:#VirtualArray
	instanceVariableNames:'generator size'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!VirtualArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by Claus Gittinger
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
    An Array which computes its values on demand and does NOT remember those values.
    Use this to present huge files/hex dumps to a text editor.

    [author:]
        Claus Gittinger

    [see also:]
        LazyArray
"
!

examples
"
                                                                [exBegin]
    |squaresLines|

    squaresLines := VirtualArray new.
    squaresLines generator:[:index | index squared printString].
    squaresLines setSize:100000.

    squaresLines inspect.
    TextView openWith:squaresLines
                                                                [exEnd]
"
! !

!VirtualArray methodsFor:'accessing'!

generator
    "the element value generator; a block which gets the index as argument"

    ^ generator
!

generator:aBlock
    "set the element value generator; a block which gets the index as argument"

    generator := aBlock.
!

setSize:anInteger 
    size := anInteger.
!

size
    "the virtual size"

    ^ size
! !

!VirtualArray methodsFor:'collection protocol'!

at:index
    ^ generator value:index

    "Created: / 27-02-2012 / 20:40:03 / cg"
!

at:index put:value
    self noModificationError.

    "Created: / 27-02-2012 / 20:40:33 / cg"
!

grow:howBig
    "change the receiver's size"

    self setSize:howBig
! !

!VirtualArray methodsFor:'inspecting'!

displayOn:aGCOrStream
    "print a representation of the receiver on aGCOrStream for display in inspectors etc."

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    aGCOrStream nextPutAll:('VirtualArray(size=%1, generator=%2)' 
                                bindWith:size with:generator printString).
! !

!VirtualArray methodsFor:'queries'!

species
    "return the type of collection to be returned by collect, select etc."

    ^ OrderedCollection
! !

!VirtualArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

