"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

ReadWriteStream subclass:#RWBinaryOrTextStream
	instanceVariableNames:'isBinary name'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!RWBinaryOrTextStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    This is a dummy, mimicry class to allow some squeak code to access
    UserPreferences.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.
"
! !

!RWBinaryOrTextStream class methodsFor:'Instance Creation'!

on: aCollection

	| new |
	new := super on: aCollection asString.
	aCollection class = ByteArray
		ifTrue: [ new binary ].
	^new
! !

!RWBinaryOrTextStream methodsFor:'Adding'!

nextPut: charOrByte

	super nextPut: charOrByte asCharacter
!

nextPutAll: aCollection
	^super nextPutAll: aCollection asString
! !

!RWBinaryOrTextStream methodsFor:'Positioning'!

reset
        "Set the receiver's position to the beginning of the sequence of objects."

        super reset.
        isBinary ifNil: [isBinary := false].
        collection class == ByteArray ifTrue: ["Store as String and convert as needed."
                collection := collection asString.
                isBinary := true].

    "Modified: / 12-09-2010 / 13:32:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RWBinaryOrTextStream methodsFor:'accessing'!

ascii
	isBinary := false
!

binary

	isBinary := true
!

contents

        ^self isBinary
                ifTrue: [ super contents asByteArray ]
                ifFalse: [ super contents asString ]

    "Modified: / 12-09-2010 / 13:32:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isBinary

        ^isBinary == true
!

name
	
	^name
!

name: aString

	name := aString
!

next

	| obj |
	obj := super next.
	self isBinary ifTrue: [ obj := obj asInteger ].
	^obj
!

next: count

"Returns the next count elements in the receiver's collection."

| result |
self isBinary
        ifTrue: [ result := #[] ]
        ifFalse: [result := collection species new ].
count timesRepeat: [ 
        self atEnd ifTrue: [ ^ result ].
        result add: self next ].
^result

    "Modified: / 12-09-2010 / 13:32:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

next: n into: aCollection startingAt: startIndex
	"Read n objects into the given collection. 
	Return aCollection or a partial copy if less than
	n elements have been read."
	| obj |
	0 to: n-1 do:[:i|
		self atEnd ifTrue: [ ^aCollection copyFrom: 1 to: startIndex+i-1 ].
		obj := self next.
		self isBinary ifTrue: [ obj := obj asInteger ].
		aCollection at: startIndex+i put: obj].
	^aCollection
!

next: anInteger putAll: aCollection startingAt: startIndex
	"Store the next anInteger elements from the given collection."
	(startIndex = 1 and:[anInteger = aCollection size])
		ifTrue:[^self nextPutAll: aCollection].
	^self nextPutAll: (aCollection copyFrom: startIndex to: startIndex+anInteger-1)
!

text

	isBinary := false
! !

!RWBinaryOrTextStream methodsFor:'converting'!

readStream
	"polymorphic with SequenceableCollection.  Return self"

	^ self
! !

!RWBinaryOrTextStream methodsFor:'fileIn/Out'!

fileIn
"/
"/    | val chunk |

    ^ super fileIn.

"/     self breakPoint: #jv.
"/     [self atEnd] whileFalse:  [
"/             self skipSeparators.
"/             val := (self peekFor: $!!) 
"/                     ifTrue: [ | chunk classReader |
"/                             chunk := self nextChunk.
"/                             classReader := chunk evaluate.
"/                             classReader scanFrom: self]
"/                     ifFalse: 
"/                             [self nextChunk evaluate]       
"/     ].
"/     ^ val

    "Modified: / 12-09-2010 / 15:34:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RWBinaryOrTextStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/RWBinaryOrTextStream.st,v 1.8 2018-03-07 14:48:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/RWBinaryOrTextStream.st,v 1.8 2018-03-07 14:48:00 cg Exp $'
!

version_SVN
    ^ '$Id: RWBinaryOrTextStream.st,v 1.8 2018-03-07 14:48:00 cg Exp $'
! !

