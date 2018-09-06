"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

SyntaxElement subclass:#SyntaxElementVariable
	instanceVariableNames:'name assigned'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView-Syntax'
!

!SyntaxElementVariable class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    documentation to be added

    [author:]

    [instance variables:]

    [class variables:]

    [see also:]
"
! !

!SyntaxElementVariable methodsFor:'accessing'!

assigned
    ^ assigned ? false
!

assigned:something
    assigned := something.
!

name
    ^ name
!

name:something
    name := something.
! !

!SyntaxElementVariable methodsFor:'queries'!

isClass
    ^ type == #class
!

isGlobal 
    ^ (type == #GlobalVariable) or:[ type == #class]
!

isInstanceVariable
    ^ (type == #InstanceVariable) 
!

isVariable
    ^ true
! !

!SyntaxElementVariable class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

