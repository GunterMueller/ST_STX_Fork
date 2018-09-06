"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

TestCase subclass:#MAFileModelTest
	instanceVariableNames:'model'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Models'
!


!MAFileModelTest class methodsFor:'testing'!

isAbstract
        ^ self name = #MAFileModelTest
        or:[ self name = #'Magritte::MAFileModelTest' ]
! !

!MAFileModelTest methodsFor:'private'!

actualClass
	^ self subclassResponsibility
! !

!MAFileModelTest methodsFor:'running'!

setUp
	super setUp.
	model := self actualClass new
!

tearDown
	model finalize
! !

!MAFileModelTest methodsFor:'testing'!

testComparing
	| other |
	other := self actualClass new.
	other 
		filename: 'something.dat';
		contents: (ByteArray with: 1 with: 2 with: 3).

	self assert: model = model.
	
	self deny: model = other.
	self deny: other = model.
	other finalize.	"should be in tearDown;  for now, at least let's discard when we pass"
!

testContents
	self assert: model contents isEmpty.

	model contents: (ByteArray with: 1 with: 2 with: 3).
	self assert: model contents = (ByteArray with: 1 with: 2 with: 3).
	self assert: model filesize = 3
!

testFilename
	self assert: model filename = 'unknown'.
	self assert: model extension isEmpty.

	model filename: 'test.txt'.
	self assert: model filename = 'test.txt'.
	self assert: model extension = 'txt'
!

testIsEmpty
	self assert: model isEmpty.

	model filename: 'foo.txt'.
	self assert: model isEmpty.

	model mimetype: 'text/plain'.
	self assert: model isEmpty.

	model contents: 'hello'.
	self deny: model isEmpty
!

testMimetype
	self assert: model mimetype = 'application/octet-stream'.
	self assert: model maintype = 'application'.
	self assert: model subtype = 'octet-stream'.

	model mimetype: 'text/html'.
	self assert: model mimetype = 'text/html'.
	self assert: model maintype = 'text'.
	self assert: model subtype = 'html'
!

testMimetypeApplication
	model mimetype: 'application/pdf'.

	self assert: model isApplication.
	self deny: model isAudio.
	self deny: model isImage.
	self deny: model isText.
	self deny: model isVideo
!

testMimetypeAudio
	model mimetype: 'audio/mpeg'.

	self deny: model isApplication.
	self assert: model isAudio.
	self deny: model isImage.
	self deny: model isText.
	self deny: model isVideo
!

testMimetypeDefault
	self assert: model isApplication.
	self deny: model isAudio.
	self deny: model isImage.
	self deny: model isText.
	self deny: model isVideo
!

testMimetypeImage
	model mimetype: 'image/png'.

	self deny: model isApplication.
	self deny: model isAudio.
	self assert: model isImage.
	self deny: model isText.
	self deny: model isVideo
!

testMimetypeText
	model mimetype: 'text/xml'.

	self deny: model isApplication.
	self deny: model isAudio.
	self deny: model isImage.
	self assert: model isText.
	self deny: model isVideo
!

testMimetypeVideo
	model mimetype: 'video/mpeg'.
	
	self deny: model isApplication.
	self deny: model isAudio.
	self deny: model isImage.
	self deny: model isText.
	self assert: model isVideo
! !

!MAFileModelTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAFileModelTest.st,v 1.2 2009-07-30 08:01:04 cg Exp $'
! !
