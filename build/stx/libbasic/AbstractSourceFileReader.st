"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#AbstractSourceFileReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!AbstractSourceFileReader class methodsFor:'documentation'!

documentation
"
    Abstract common superclass for source file readers
"
! !

!AbstractSourceFileReader class methodsFor:'fileIn'!

fileIn: aFilename

    ^self new fileIn: aFilename

    "Created: / 16-08-2009 / 10:14:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

fileInStream: aStream

    ^self new fileInStream: aStream

    "Created: / 16-08-2009 / 10:15:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!AbstractSourceFileReader class methodsFor:'queries'!

isAbstract
    ^ self == AbstractSourceFileReader
! !

!AbstractSourceFileReader methodsFor:'fileIn'!

fileIn:aFilename

    | stream |
    [stream := aFilename asFilename readStream.
    self fileInStream: stream]
        ensure:
            [stream notNil ifTrue:[stream close]]

    "Modified: / 15-08-2009 / 14:47:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-08-2010 / 14:38:35 / cg"
!

fileInStream:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!AbstractSourceFileReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^'$Id$'
! !

