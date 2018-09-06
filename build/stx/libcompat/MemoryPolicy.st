"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MemoryPolicy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-VisualWorks'
!

!MemoryPolicy class methodsFor:'documentation'!

documentation
"
    This is a dummy stub - only present to provide a superclass for
    some VW Public Domain code (which subclass or add loose code to MemoryPolicy).
"
! !

!MemoryPolicy methodsFor:'accessing'!

ensureFreeMemory: anInteger
	" for compatibility "
! !

!MemoryPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/MemoryPolicy.st,v 1.2 2015-03-27 13:24:27 cg Exp $'
! !

