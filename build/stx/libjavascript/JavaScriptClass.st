"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2000 by eXept Software AG
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

Class subclass:#JavaScriptClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Framework'
!

!JavaScriptClass class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaScriptClass class methodsFor:'compiler interface'!

evaluatorClass
    self name = JavaScriptClass name ifTrue:[
	^ super evaluatorClass
    ].
    ^ JavaScriptParser
!

parserClass
    self name = JavaScriptClass name ifTrue:[
	^ super parserClass
    ].
    ^ JavaScriptParser
! !

!JavaScriptClass class methodsFor:'queries'!

basicFileOutDefinitionOn:aStream withNameSpace:forceNameSpace withPackage:showPackage
    "append an expression on aStream, which defines myself."

    self == JavaScriptClass ifTrue:[
        ^ super basicFileOutDefinitionOn:aStream withNameSpace:forceNameSpace withPackage:showPackage
    ].

    self class
        basicFileOutDefinitionOf:self 
        on:aStream 
        withNameSpace:forceNameSpace 
        withPackage:showPackage 

"/    aStream nextPutAll:'public class '.
"/    aStream nextPutAll:self name.
"/    aStream nextPutAll:' extends '.
"/    aStream nextPutAll:self superclass name.
"/    aStream cr.
"/
"/    aStream nextPutAll:'{'.
"/    aStream cr.
"/
"/    self classVarNames do:[:eachVarName |
"/        aStream tab; nextPutAll:'static var '; nextPutAll:eachVarName; nextPutAll:';'; cr.
"/    ].
"/    self instVarNames do:[:eachVarName |
"/        aStream tab; nextPutAll:'var '; nextPutAll:eachVarName; nextPutAll:';'; cr.
"/    ].
"/    aStream nextPutAll:'}'.
"/    aStream cr.

    "Modified: / 30-01-2011 / 17:20:53 / cg"
!

isJavaScriptClass
    ^ true
! !

!JavaScriptClass methodsFor:'instance creation'!

new
    ^ self basicNew __initialize__ initialize.
! !

!JavaScriptClass methodsFor:'queries'!

nameInBrowser
    "return a nameString as shown in browsers"

    ^ (self name ? '_') , '()'

    "Modified: / 22-05-2017 / 13:34:26 / stefan"
! !

!JavaScriptClass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptClass.st,v 1.11 2017-05-23 10:34:32 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptClass.st,v 1.11 2017-05-23 10:34:32 stefan Exp $'
! !

