"
 COPYRIGHT (c) 2010 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Method variableSubclass:#InstrumentedMethod
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Instrumentation'
!

!InstrumentedMethod class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by eXept Software AG
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
    Instances of me are created by the instrumenting compiler.

    [author:]
        Claus Gittinger
"
! !

!InstrumentedMethod class methodsFor:'cleanup'!

cleanAllInfoWithChange:withChange
    InstrumentationInfo cleanAllInfoWithChange:withChange

    "Created: / 20-07-2011 / 19:01:21 / cg"
! !

!InstrumentedMethod methodsFor:'accessing'!

blockInvocationInfo
    "return a collection of all block-info objects"

    |info|

    info := OrderedCollection new.
    self literalsDo:[:lit |
        (lit isSpecialInstrumentationInfoLiteral
        and:[ lit isBlockExecutionInfo ]) ifTrue:[
            info add:lit
        ]
    ].
    ^ info

    "Created: / 27-04-2010 / 13:47:21 / cg"
    "Modified: / 07-08-2011 / 17:05:02 / cg"
!

invokedViaPerform
    "true if the method is ever invoked via perform"

    |info|

    info := self methodInvocationInfo.
    ^ info notNil and:[info invokedViaPerform]

    "Created: / 27-04-2010 / 18:23:10 / cg"
!

methodInvocationInfo
    "return the one and only method-invocatin info"

    ^ self 
        literalsDetect:[:lit | 
                lit isSpecialInstrumentationInfoLiteral
                and:[ lit isMethodInvocationInfo]] 
        ifNone:nil

    "Created: / 27-04-2010 / 13:34:01 / cg"
!

statementInvocationInfo
    "return all statement infos (but not block infos)"

    |info|

    info := OrderedCollection new.
    self literalsDo:[:lit | 
        (lit isSpecialInstrumentationInfoLiteral
        and:[ lit isStatementExecutionInfo 
        and:[ lit isBlockExecutionInfo not]]) ifTrue:[
            info add:lit
        ]
    ].
    ^ info

    "Modified (comment): / 30-09-2011 / 12:05:06 / cg"
! !

!InstrumentedMethod methodsFor:'cleanup'!

cleanInstrumentationInfoWithChange:doChangeNotifications   
    ^ self 
        literalsDo:[:lit | 
            lit isSpecialInstrumentationInfoLiteral ifTrue:[
                lit cleanInfoWithChange:doChangeNotifications
            ]
        ].
! !

!InstrumentedMethod methodsFor:'queries'!

hasBeenCalled
    "return true, if I have been called"

    |info|

    ^ (info := self methodInvocationInfo) notNil
    and:[ info hasBeenCalled ]

    "Created: / 27-04-2010 / 13:03:33 / cg"
!

haveAllBlocksBeenExecuted
    "return true if all of my blocks have been called"

    ^ self blockInvocationInfo conform:[:eachBlockInfo | eachBlockInfo callCount > 0]

    "Modified: / 27-04-2010 / 13:44:46 / cg"
!

isInstrumented
    ^ true

    "Created: / 27-04-2010 / 12:25:39 / cg"
! !

!InstrumentedMethod class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/InstrumentedMethod.st,v 1.12 2015-01-29 18:17:17 cg Exp $'
! !

