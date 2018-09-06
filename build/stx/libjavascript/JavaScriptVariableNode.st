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

VariableNode subclass:#JavaScriptVariableNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptVariableNode class methodsFor:'documentation'!

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

!JavaScriptVariableNode methodsFor:'queries'!

isImmutable
    "/ self isMethodArg ifTrue:[^ true].
    ^ false

    "Modified: / 23-02-2007 / 13:26:20 / cg"
! !

!JavaScriptVariableNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitJavaScriptVariableNode:self 
! !

!JavaScriptVariableNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptVariableNode.st,v 1.6 2013-09-20 00:51:23 vrany Exp $'
! !

