"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

Magnitude subclass:#VersionNumber
	instanceVariableNames:'numbers'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-helpers'
!

VersionNumber comment:'I am a version number.  My representation allows me to handle an entire tree of versions.  Once created, an instance should not change (note: VersionNumbers could be canonicalized like Symbols, but are not currently).  

I am a magnitude so that you can see if one version preceeds another (only if the two versions are in the same branch).  

	''2.1'' asVersion < ''2.2.1'' asVersion	"true"
	''2.3'' asVersion < ''2.2.1'' asVersion	"error different branches"
	''2.3'' asVersion inSameBranchAs: ''2.2.1'' asVersion	"false, why the previous one failed."	
	''2.1'' asVersion = ''2.1'' asVersion		"true, obviously"

To get the next version number in the same branch:

	''2.3.4'' asVersion next	"2.3.5"

To get the next version number, starting a new branch:

	''2.3.4'' asVersion branchNext		"2.3.4.1"

To get the common base version of any two version numbers (useful for merging):

	''2.3.8'' asVersion commonBase: ''2.3.4.1'' asVersion		"2.3.4"'
!

!VersionNumber class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Taken from KomPackaging in squeak.

    [author:]

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
!

history
    "Created: / 20.5.2003 / 08:29:00 / james"
! !

!VersionNumber class methodsFor:'as yet unclassified'!

first

	^self fromCollection: #(1)
!

fromCollection: aCollection

	^self new
		initializeNumbers: aCollection;
		yourself
!

fromString: aString

	^self fromCollection: 
		((aString findTokens: '.') collect: [:ea | ea asNumber ])
	
! !

!VersionNumber methodsFor:'accessing'!

branchNext

	^self class fromCollection: (numbers, (Array with: 1))
!

commonBase: aVersion

	| smallNums largeNums cutoff |
	(aVersion numbers size <= numbers size) 
		ifTrue: [smallNums := aVersion numbers. largeNums := numbers] 
		ifFalse: [smallNums := numbers. largeNums := aVersion numbers].

	cutoff := (1 to: smallNums size) 
		detect: [ :in | ((smallNums at: in) ~= (largeNums at: in))] 
		ifNone: [^self class fromCollection: smallNums].

	^self class fromCollection: 
		((numbers copyFrom: 1 to: (cutoff - 1)), 
		(Array with: ((smallNums at: cutoff) min: (largeNums at: cutoff))))
!

next

	| tmp |
	tmp := numbers copy.
	tmp at: numbers size put: (numbers last + 1).
	^self class fromCollection: tmp
!

numbers
	"Answer a copy (to discourage people from directly changing a version number).
	VersionNumbers should never change, instead, instantiate a new instance."

	^numbers copy
!

previous

	| tmp |
	numbers last = 1 ifTrue: 
		[^self class fromCollection: (numbers allButLast)].
	tmp := numbers copy.
	tmp at: numbers size put: (numbers last - 1).
	^self class fromCollection: tmp
! !

!VersionNumber methodsFor:'comparing'!

< another 
	"Answer whether the receiver is less than the argument."

	| tmp |
	(self inSameBranchAs: another) ifFalse: 
		[^self error: 'Receiver and argument in different branches'].

	tmp := another numbers.
	(tmp size = numbers size) ifTrue:
		[1 to: numbers size do: 
			[ :in | (numbers at: in) < (tmp at: in) ifTrue: [^true]].
		^false].

	^numbers size < tmp size
!

= aVersion

	^numbers = aVersion numbers
!

hash

	^numbers hash
! !

!VersionNumber methodsFor:'initialization'!

initializeNumbers: aCollection

	aCollection do: [ :ea | 
		ea <= 0 ifTrue: 
			[^self error: 'VersionNumbers cannot contain zero or negative numbers']].

	numbers := aCollection asArray
! !

!VersionNumber methodsFor:'printing'!

printOn: strm

	self storeOn: strm
!

storeOn: strm

	strm nextPut: $'.
	self versionStringOn: strm.
	strm nextPutAll: ''' asVersion'.
!

versionString

	^String streamContents: [ :strm | self versionStringOn: strm ]
!

versionStringOn: strm

	| first |
	first := true.
	numbers do: [ :ea |
		first ifFalse: [strm nextPut: $.].
		first := false.
		ea printOn: strm]
	
! !

!VersionNumber methodsFor:'testing'!

inSameBranchAs: aVersion

	| less more |
	(aVersion numbers size <= numbers size) 
		ifTrue: [less := aVersion numbers. more := numbers] 
		ifFalse: [less := numbers. more := aVersion numbers].

	1 to: (less size - 1) do: [ :in | ((less at: in) = (more at: in)) ifFalse: [^false]].
	^less size = more size or:
		[(less at: less size) <= (more at: less size)]
! !

!VersionNumber class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/VersionNumber.st,v 1.2 2006/01/10 09:31:53 cg Exp $'
! !