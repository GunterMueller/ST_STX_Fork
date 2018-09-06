"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libcomp' }"

Object variableSubclass:#Reference
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

Reference variableSubclass:#ContextVariableReference
	instanceVariableNames:'context index'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Reference
!

Reference::ContextVariableReference variableSubclass:#ArgumentReference
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Reference
!

Reference::ContextVariableReference variableSubclass:#LocalVariableReference
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Reference
!

!Reference class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

example1
    |foo ref|

    ref := Reference forLocal:1 in:thisContext.
    ref inspect

    "
     self example1
    "
!

example2
"/    |foo ref|
"/
"/    foo := 123.
"/    ref := &foo.
"/    ref inspect

    "
     self example2
    "
! !

!Reference class methodsFor:'instance creation'!

forArgument:argIndex in:aContext
    ^ ArgumentReference new
        context:aContext index:argIndex
!

forLocal:varIndex in:aContext
    ^ LocalVariableReference new
        context:aContext index:varIndex
! !

!Reference::ContextVariableReference methodsFor:'accessing'!

context:contextArg index:indexArg 
    context := contextArg.
    index := indexArg.
! !

!Reference::ArgumentReference methodsFor:'accessing'!

value
    ^ context argAt:index
!

value:newValue
    self error:'write into argument ref'.
    ^ newValue
! !

!Reference::LocalVariableReference methodsFor:'accessing'!

value
    ^ context varAt:index
!

value:newValue
    ^ context varAt:index put:newValue
! !

!Reference class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/Reference.st,v 1.3 2003-08-29 19:21:52 cg Exp $'
! !
