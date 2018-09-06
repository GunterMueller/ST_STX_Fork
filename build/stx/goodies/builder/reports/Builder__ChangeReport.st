"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

Report subclass:#ChangeReport
	instanceVariableNames:'gofer'
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports-Unfinished'
!


!ChangeReport methodsFor:'accessing'!

changesFor: aResolvedVersion
	| references patch |
	references := gofer allResolved
		select: [ :each | each packageName = aResolvedVersion packageName ].
	patch := MCPatch 
		fromBase: (references size > 1 
			ifTrue: [ (references at: references size - 1) version snapshot ]
			ifFalse: [ MCSnapshot empty ])
		target: aResolvedVersion version snapshot.
	^ patch operations asSortedCollection
!

resolved
	^ gofer resolved
! !

!ChangeReport methodsFor:'generating'!

generateChange: aPatch on: aStream
	aPatch isAddition
		ifTrue: [ ^ self generateChangeAddition: aPatch on: aStream ].
	aPatch isModification
		ifTrue: [ ^ self generateChangeModification: aPatch on: aStream ].
	aPatch isRemoval
		ifTrue: [ ^ self generateChangeRemoval: aPatch on: aStream ]
!

generateChangeAddition: aPatch on: aStream
	aStream tab; tab; tab; nextPutAll: '<item action="add">'; nextPutAll: (self encode: (self convert: aPatch summary)); nextPutAll: '</item>'; nextPut: Character lf
!

generateChangeModification: aPatch on: aStream
	aStream tab; tab; tab; nextPutAll: '<item action="change">'; nextPutAll: (self encode: (self convert: aPatch summary)); nextPutAll: '</item>'; nextPut: Character lf
!

generateChangeRemoval: aPatch on: aStream
	aStream tab; tab; tab; nextPutAll: '<item action="remove">'; nextPutAll: (self encode: (self convert: aPatch summary)); nextPutAll: '</item>'; nextPut: Character lf
!

generateChangeSet: aResolvedVersion on: aStream
	| info |
	info := aResolvedVersion version info.
	aStream tab; nextPutAll: '<logentry version="'; nextPutAll: (self encode: info name); nextPutAll: '">'; nextPut: Character lf.
	aStream tab; tab; nextPutAll: '<date>'; nextPutAll: (self encode: info date yyyymmdd); space; nextPutAll: (self encode: info time print24); nextPutAll: '</date>'; nextPut: Character lf.
	aStream tab; tab; nextPutAll: '<author>'; nextPutAll: (self encode: info author); nextPutAll: '</author>'; nextPut: Character lf.
	aStream tab; tab; nextPutAll: '<msg>'; nextPutAll: (self encode: (self convert: info message)); nextPutAll: '</msg>'; nextPut: Character lf.
	"aStream tab; tab; nextPutAll: '<items>'; nextPut: Character lf.
	(self changesFor: aResolvedVersion)
		do: [ :each | self generateChange: each on: aStream ].
	aStream tab; tab; nextPutAll: '</items>'; nextPut: Character lf."
	aStream tab; nextPutAll: '</logentry>'; nextPut: Character lf
!

generateOn: aStream
	aStream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'; nextPut: Character lf.
	aStream nextPutAll: '<changelog>'; nextPut: Character lf.
	self resolved
		do: [ :each | self generateChangeSet: each on: aStream ].
	aStream nextPutAll: '<changelog>'
! !

!ChangeReport methodsFor:'initialization'!

initializeOn: aCollection
	gofer := Gofer new.
	aCollection do: [ :each | gofer package: each ]
! !

!ChangeReport methodsFor:'running'!

run
        | stream |
        stream := (Filename defaultDirectory directory / 'changelog.xml') writeStream.
        [ self generateOn: stream ]
                ensure: [ stream close ]
! !

!ChangeReport class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

