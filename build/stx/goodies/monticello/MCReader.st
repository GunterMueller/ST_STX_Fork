"{ Package: 'stx:goodies/monticello' }""{ NameSpace: Smalltalk }"Object subclass:#MCReader	instanceVariableNames:'stream'	classVariableNames:''	poolDictionaries:''	category:'SCM-Monticello-Storing'!


!MCReader class methodsFor:'instance creation'!

on: aStringOrStream
        ^ self new stream: aStringOrStream readStream

    "Modified: / 25-11-2011 / 16:57:41 / cg"
!

on: aStream name: aFileName
	| class |
	class := self readerClassForFileNamed: aFileName.
	^ class
		ifNil: [self error: 'Unsupported format: ', aFileName]
		ifNotNil: [class on: aStream]
! !

!MCReader class methodsFor:'testing'!

canReadFileNamed: fileName
	^ (fileName endsWith: self extension)
!

concreteSubclasses
    "must make sure that the package is fully loaded;
     otherwise, subclasses are not found"

    self projectDefinitionClass ensureFullyLoaded.
    ^ self allSubclasses reject: [:c | c isAbstract]
!

isAbstract
	^ (self respondsTo: #extension) not
!

readerClassForFileNamed: fileName
	^ self concreteSubclasses
		detect: [:c | c canReadFileNamed: fileName]
		ifNone: [nil]
! !

!MCReader methodsFor:'accessing'!

stream: aStream
	stream := aStream
! !

!MCReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCReader.st,v 1.6 2015-02-07 11:09:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCReader.st,v 1.6 2015-02-07 11:09:03 cg Exp $'
!

version_SVN
    ^ '$Id: MCReader.st,v 1.6 2015-02-07 11:09:03 cg Exp $'
! !

