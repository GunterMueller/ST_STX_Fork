"{ Package: 'stx:goodies/sunit' }"

Object subclass:#SUnitNameResolver
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Preload'
!


!SUnitNameResolver class methodsFor:'Camp Smalltalk'!

classNamed: aSymbol
    ^Smalltalk at: aSymbol ifAbsent: [nil]
!

defaultLogDevice
    ^Transcript
!

errorObject

    ^Exception
"/  ^Error

    "Modified: / 11-09-2010 / 15:10:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mnuExceptionObject
	^MessageNotUnderstood
!

notificationObject
	^Notification
! !

!SUnitNameResolver class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/SUnitNameResolver.st,v 1.7 2011-06-29 19:15:49 cg Exp $'
!

version_SVN
    ^ '§Id: SUnitNameResolver.st 204 2010-09-11 15:21:51Z vranyj1 §'
! !
