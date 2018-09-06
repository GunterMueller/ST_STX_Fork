"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCWriter
	instanceVariableNames:'stream'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Storing'
!


!MCWriter class methodsFor:'accessing'!

extension
	^ self readerClass extension
!

readerClass
	^ self subclassResponsibility 
! !

!MCWriter class methodsFor:'writing'!

on: aStream
	^ self new stream: aStream
! !

!MCWriter methodsFor:'as yet unclassified'!

stream
	^ stream
!

stream: aStream
	stream := aStream
! !

!MCWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCWriter.st,v 1.5 2012-09-11 21:31:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCWriter.st,v 1.5 2012-09-11 21:31:32 cg Exp $'
!

version_SVN
    ^ '§Id: MCWriter.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
