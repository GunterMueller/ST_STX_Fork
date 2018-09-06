"
 COPYRIGHT (c) 2012 by Claus Gittinger
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

Method variableSubclass:#MethodWithBreakpoints
	instanceVariableNames:'originalMethod'
	classVariableNames:'BreakpointedMethods'
	poolDictionaries:''
	category:'Kernel-Methods'
!

!MethodWithBreakpoints class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by Claus Gittinger
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

    [author:]
        Claus Gittinger

    [see also:]
        Tools::BreakpointService
"
! !

!MethodWithBreakpoints class methodsFor:'instance creation'!

new
    |newMethod|

    newMethod := super new.
    BreakpointedMethods add:newMethod.
    ^ newMethod
!

new:numLiterals
    |newMethod|

    newMethod := super new:numLiterals.
    BreakpointedMethods add:newMethod.
    ^ newMethod
! !

!MethodWithBreakpoints class methodsFor:'class initialization'!

initialize
    BreakpointedMethods := WeakIdentitySet new.
! !

!MethodWithBreakpoints class methodsFor:'misc'!

removeAllBreakpoints
    "remove all statement breakpoints on any method in the whole system"

    MethodWithBreakpoints allBreakpointedMethods do:[:m | m restoreOriginalMethod]
! !

!MethodWithBreakpoints class methodsFor:'queries'!

allBreakpointedMethods
    |invalidBreakpoints|

    BreakpointedMethods isNil ifTrue:[^ #() ].
    invalidBreakpoints := BreakpointedMethods select:[:m | m mclass isNil].
    invalidBreakpoints do:[:each | BreakpointedMethods remove:each ifAbsent:nil].
    ^ BreakpointedMethods asOrderedCollection
! !

!MethodWithBreakpoints methodsFor:'accessing'!

originalMethod
    ^ originalMethod
!

originalMethod:something
    originalMethod := something.
! !

!MethodWithBreakpoints methodsFor:'enumeration'!

breakpointsDo:aBlock
    self literalsDo:[:lit | 
        lit class == Breakpoint ifTrue:[
            aBlock value:lit 
        ]
    ].

    "Created: / 03-02-2014 / 10:34:45 / cg"
! !

!MethodWithBreakpoints methodsFor:'misc'!

disableAllBreakpoints
    "disable all of my breakpoints"

    self breakpointsDo:[:bp | bp disable].
!

disableBreakpointInLine:lineNr
    "disable one of my breakpoints"

    self breakpointsDo:[:bp | 
        bp line == lineNr ifTrue:[
            bp disable
        ].
    ].
!

restoreOriginalMethod
    "remove myself - i.e. replace by the original method 
     (i.e. the one without line breakpoints)"

    | cls selector original |

    (cls := self mclass) notNil ifTrue:[
        (selector := self selector) notNil ifTrue:[
            self breakPoint:#cg.
            "/ disable my breakpoints, in case it is currently active
            self disableAllBreakpoints.
            
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
                original setCategory: self category  .
            ].
            cls basicAddSelector:selector withMethod:original.
            BreakpointedMethods remove:self ifAbsent:[].
        ]
    ]

    "Modified: / 29-08-2013 / 01:17:05 / cg"
    "Modified: / 10-05-2014 / 11:03:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodWithBreakpoints methodsFor:'queries'!

hasEnabledBreakpoints
    "true if any of my breakpoints is actually enabled"

    self breakpointsDo:[:any | 
        any isEnabled ifTrue:[
            any isTracepoint ifFalse:[ ^ true].
        ].    
    ].
    ^ false.
!

hasEnabledTracepoints
    "true if any of my tracepoints is actually enabled"

    self breakpointsDo:[:any | 
        any isEnabled ifTrue:[
            any isTracepoint ifTrue:[
                ^ true
            ].
        ].
    ].
    ^ false.
!

isMethodWithBreakpoints
    ^ true

    "Created: / 01-08-2012 / 17:26:59 / cg"
! !

!MethodWithBreakpoints class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


MethodWithBreakpoints initialize!
