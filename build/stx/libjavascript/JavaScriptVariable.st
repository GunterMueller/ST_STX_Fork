"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

Variable subclass:#JavaScriptVariable
	instanceVariableNames:'index initExpression'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptVariable class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaScriptVariable class methodsFor:'instance creation'!

type:type name:name index:index
    ^ self new type:type name:name index:index
! !

!JavaScriptVariable methodsFor:'accessing'!

expressionForSetup
    ^ initExpression
!

expressionForSetup:expr
    initExpression := expr
!

index
    "return the value of the instance variable 'index' (automatically generated)"

    ^ index
!

type:typeArg name:nameString index:indexArg
    "/ self assert:nameString notNil.

    type := typeArg.
    name := nameString.
    index := indexArg

    "Modified: / 27-08-2018 / 13:40:24 / Claus Gittinger"
! !

!JavaScriptVariable methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'JSVariable('.
    aStream nextPutAll:name.
    aStream nextPutAll:')'.
! !

!JavaScriptVariable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptVariable.st,v 1.6 2018-08-27 11:40:52 cg Exp $'
! !

