"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Registry subclass:#HandleRegistry
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!HandleRegistry class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    HandleRegistries are like Registries, in that they watch for the death of
    a registered object. However, they send a self-change notification, passing the registered
    handle as argument, instead of creating a shallow copy and letting it do the finalization.
    Use Registry for objects which know themself how to clean up;
    use HandleRegistry, if someone else does the cleanup.

    [author:]
        Claus Gittinger
"
! !

!HandleRegistry methodsFor:'dispose handling'!

informDispose:someHandle
    "an element was disposed; let my dependents know about this"

    self changed:#finalize with:someHandle
! !

!HandleRegistry methodsFor:'redefined to block'!

register:anObject
    "not useful for HandleRegistry - use #register:as:"

    self shouldNotImplement
!

registerChange:anObject
    "not useful for HandleRegistry"

    self shouldNotImplement
! !

!HandleRegistry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: HandleRegistry.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !



