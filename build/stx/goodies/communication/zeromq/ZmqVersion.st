"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

Magnitude subclass:#ZmqVersion
	instanceVariableNames:'major minor patch'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqVersion comment:'ZmqVersion represents major-minor-patch type of versioning.Instance Variables:	major	<SmallInteger>	minor	<SmallInteger>	patch	<SmallInteger>'
!

!ZmqVersion class methodsFor:'documentation'!

documentation
"
ZmqVersion represents major-minor-patch type of versioning.

Instance Variables:
	major	<SmallInteger>
	minor	<SmallInteger>
	patch	<SmallInteger>

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ZmqVersion class methodsFor:'as yet unclassified'!

fromArray: anThreeElementArrayOfIntegers
	^self perform: #major:minor:patch: withArguments: anThreeElementArrayOfIntegers.
!

fromString: aString
	"Conerts minor.major.patch version string e.g. 1.34.12 to ZmqVersion object"

	^self fromArray: ((aString splitOn: $.) collect: [ :part | part asInteger ]) asArray
!

major: major minor: minor patch: patch
	^ (self new)
		major: major;
		minor: minor;
		patch: patch;
		yourself
!

toVersion: aZmqVersionOrString
	^ aZmqVersionOrString isString
		ifTrue: [ self fromString: aZmqVersionOrString ]
		ifFalse: [ aZmqVersionOrString ]
! !

!ZmqVersion methodsFor:'accessing'!

major
	^ major
!

major: anObject
	major := anObject
!

minor
	^ minor
!

minor: anObject
	minor := anObject
!

patch
	^ patch
!

patch: anObject
	patch := anObject
! !

!ZmqVersion methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: self major asString.
	aStream nextPut: $..
	aStream nextPutAll: self minor asString.	
	aStream nextPut: $..
	aStream nextPutAll: self patch asString.	

	
! !

!ZmqVersion methodsFor:'testing'!

< aZMQVersion
	self major < aZMQVersion major ifTrue:[^true].
	self major > aZMQVersion major ifTrue:[^false].
	self minor < aZMQVersion minor ifTrue:[^true].
	self minor > aZMQVersion minor ifTrue:[^false].
	self patch < aZMQVersion patch ifTrue:[^true].
	self patch > aZMQVersion patch ifTrue:[^false].		
	^false.
!

= aZMQVersion
        ^ aZMQVersion major = self major 
        and: [ aZMQVersion minor = self minor 
        and: [ aZMQVersion patch = self patch ] ]
!

between: min and: max
	^ self >= (self toVersion: min) and: [ self <= (self toVersion: max) ]
!

hash
        ^ ((self major hash bitShift:8)
        bitXor: (self minor hash bitShift:4))
        bitXor: (self patch hash)
!

toVersion: aZmqVersionOrString
	^ self class toVersion: aZmqVersionOrString.
! !

!ZmqVersion class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqVersion.st,v 1.2 2018-05-10 20:43:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqVersion.st,v 1.2 2018-05-10 20:43:18 cg Exp $'
! !

