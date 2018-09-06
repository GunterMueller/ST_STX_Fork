"{ Package: 'stx:goodies/monticello' }"

MCFileBasedRepository subclass:#MCDirectoryRepository
	instanceVariableNames:'directory'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!


!MCDirectoryRepository class methodsFor:'initialization'!

new
    ^self basicNew initialize
! !

!MCDirectoryRepository class methodsFor:'instance creation'!

directory: aStringOrFileDirectory

    ^self new directory: aStringOrFileDirectory

    "Created: / 16-09-2010 / 14:51:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2010 / 15:59:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

morphicConfigure
	| directory |
	^ (directory := UIManager default chooseDirectory) ifNotNil:
		[
		self new directory: directory]
! !

!MCDirectoryRepository class methodsFor:'as yet unclassified'!

fillInTheBlankRequest
    "superclass MCRepository class says that I am responsible to implement this method"

    ^ self shouldImplement
! !

!MCDirectoryRepository class methodsFor:'queries'!

creationTemplate
    "superclass MCRepository class says that I am responsible to implement this method"

    ^
'MCDirectoryRepository 
    directory: ''%1'''
        bindWith: (Filename currentDirectory asAbsoluteFilename / 'package-cache') asString

    "Modified: / 16-09-2010 / 14:53:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2011 / 20:31:31 / cg"
!

description
	^ 'directory'
! !

!MCDirectoryRepository methodsFor:'accessing'!

description
	^ directory pathName
!

directory
	^ directory
!

directory: aStringOrDirectory

    directory := aStringOrDirectory isString 
        ifTrue:[FileDirectory directoryNamed: aStringOrDirectory]
        ifFalse:[aStringOrDirectory].

    "Modified: / 16-09-2010 / 15:58:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCDirectoryRepository methodsFor:'as yet unclassified'!

isValid
	^directory exists
!

literalArrayEncoding

    ^Array 
        with: self class name asSymbol
        with: #directory:
        with: directory pathName "directoryName"

    "
        (MCDirectoryRepository directory: '/tmp')
            literalArrayEncoding decodeAsLiteralArray
    "

    "Created: / 16-09-2010 / 16:01:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2011 / 21:01:25 / cg"
!

readStreamForFileNamed: aString do: aBlock
	| file val |
	file := FileStream readOnlyFileNamed: (directory fullNameFor: aString).
	val := aBlock value: file.
	file close.
	^ val
!

writeStreamForFileNamed: aString replace: aBoolean do: aBlock
	| file sel |
	sel := aBoolean ifTrue: [#forceNewFileNamed:] ifFalse: [#newFileNamed:].
	file := FileStream perform: sel with: (directory fullNameFor: aString).
	aBlock value: file.
	file close.
! !

!MCDirectoryRepository methodsFor:'comparing'!

hash
	^ directory pathName hash
! !

!MCDirectoryRepository methodsFor:'displaying'!

displayString

    ^directory pathName "/ directoryName

    "Created: / 14-09-2010 / 23:18:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2011 / 21:00:33 / cg"
! !

!MCDirectoryRepository methodsFor:'initialization'!

initialize
	super initialize.
	directory := FileDirectory default
! !

!MCDirectoryRepository methodsFor:'queries'!

allFileNames
	^ (directory entries sortBy: [:a :b | a modificationTime >= b modificationTime]) collect: [:ea | ea name]
! !

!MCDirectoryRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDirectoryRepository.st,v 1.7 2014-02-12 14:53:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDirectoryRepository.st,v 1.7 2014-02-12 14:53:38 cg Exp $'
!

version_SVN
    ^ '$Id: MCDirectoryRepository.st,v 1.7 2014-02-12 14:53:38 cg Exp $'
! !

