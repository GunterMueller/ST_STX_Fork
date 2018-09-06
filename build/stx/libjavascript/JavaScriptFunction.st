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

Method variableSubclass:#JavaScriptFunction
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptFunction class methodsFor:'documentation'!

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

!JavaScriptFunction methodsFor:'compiler interface'!

mclass:aClass
    mclass := aClass
!

programmingLanguage
    ^  STXJavaScriptLanguage instance
! !

!JavaScriptFunction methodsFor:'printing & storing'!

selectorPrintStringInBrowserFor:selector
    ^ selector upTo:$:
!

selectorPrintStringInBrowserFor:selector class:aClass
    |nsPart selPart idx ns as|

    selector isNameSpaceSelector ifFalse:[
        idx := selector indexOf:$: startingAt:2.
        idx == 0 ifTrue:[ idx := selector size+1 ].
        as := (1 to:self numArgs collect:[:i | 'a%1' bindWith:i]) asStringWith:', '.
        ^ (selector copyTo:idx-1) allBold,'(',as,')'           
    ].

    idx := selector indexOf:$: startingAt:3.
    selPart := selector copyFrom:idx+2.
    nsPart := selector copyFrom:2 to:idx-1.
    ns := Smalltalk at:nsPart asSymbol.
    ^ selPart allBold,'(',')', ' {',nsPart,'}'.
! !

!JavaScriptFunction class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptFunction.st,v 1.7 2011-01-28 08:43:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptFunction.st,v 1.7 2011-01-28 08:43:02 cg Exp $'
! !
