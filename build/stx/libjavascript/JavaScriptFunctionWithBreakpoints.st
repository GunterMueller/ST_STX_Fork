"
 COPYRIGHT (c) 2013 by Claus Gittinger
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

JavaScriptFunction variableSubclass:#JavaScriptFunctionWithBreakpoints
	instanceVariableNames:'originalMethod'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptFunctionWithBreakpoints class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by Claus Gittinger
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
    support for line-Breakpoints

    instances of me are created when line-breakpoints are placed.
    The only function I serve is to provide the originalMethod information,
    and an easy way to check for having a breakpoint (is breakpointed).

    Caveat:
        very stupid - had to repead the definition from MethodWithBreakpoints.
        Probably it is a stupid idea, to implement breakpointed methods this way (by inheritance),
        instead of having some attribute in the method (such as in an annotation).
        May someone change that?...

    [author:]
        Claus Gittinger

    [see also:]
        Tools::BreakpointService
"
! !

!JavaScriptFunctionWithBreakpoints methodsFor:'accessing'!

originalMethod
    ^ originalMethod
!

originalMethod:something
    originalMethod := something.
! !

!JavaScriptFunctionWithBreakpoints methodsFor:'enumerating'!

breakpointsDo:aBlock
    self literalsDo:[:lit | 
        lit class == Breakpoint ifTrue:[
            aBlock value:lit 
        ]
    ].

    "Created: / 03-02-2014 / 10:34:45 / cg"
! !

!JavaScriptFunctionWithBreakpoints methodsFor:'misc'!

restoreOriginalMethod
    "remove myself - i.e. replace by the original method 
     (i.e. the one without line breakpoints)"

    |cls selector original|

    (cls := self mclass) notNil ifTrue:[
        (selector := self selector) notNil ifTrue:[
            "/ self halt.
            originalMethod notNil ifTrue:[ 
                original := originalMethod
            ] ifFalse:[
                original := self programmingLanguage compilerClass
                                        compile: self source 
                                        in: self mclass 
                                        notifying:nil 
                                        install:false 
                                        ifFail:[ self error:'Failed to recompile method' ].
                original setPackage: self package.
                original setCategory: self category.
            ].                                               
            cls basicAddSelector:selector withMethod:originalMethod    
        ]
    ]

    "Modified: / 10-05-2014 / 11:04:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptFunctionWithBreakpoints methodsFor:'queries'!

hasEnabledBreakpoints
    "true if any of my breakpoints is actually enabled"

    self breakpointsDo:[:any | 
        any isEnabled ifTrue:[^ true].
    ].
    ^ false.
!

isMethodWithBreakpoints
    ^ true

    "Created: / 01-08-2012 / 17:26:59 / cg"
! !

!JavaScriptFunctionWithBreakpoints class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptFunctionWithBreakpoints.st,v 1.5 2015-01-29 23:49:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptFunctionWithBreakpoints.st,v 1.5 2015-01-29 23:49:00 cg Exp $'
! !

