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

Object subclass:#InstrumentationInfo
	instanceVariableNames:'owningMethod'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Instrumentation'
!

!InstrumentationInfo class methodsFor:'documentation'!

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
    (sub)instances of me are placed by the instrumenting compiler into the literal
    array of instrumented methods. 
    The InstrumentingCompiler generates code to update these, as code is executed.
"
! !

!InstrumentationInfo class methodsFor:'cleanup'!

allInfosDo:aBlock
    InstrumentedMethod allInstancesDo:[:m |
        self allInfosOfMethod:m do:aBlock 
    ].

    "Created: / 27-04-2010 / 12:09:03 / cg"
!

allInfosOfClass:aClass do:aBlock
    aClass instAndClassMethodsDo:[:m |
        m isInstrumented ifTrue:[
            self allInfosOfMethod:m do:aBlock
        ].
    ].

    "Created: / 27-04-2010 / 12:09:03 / cg"
!

allInfosOfMethod:aMethod do:aBlock
    aMethod literalsDo:[:l |
        (l isKindOf:self) ifTrue:[
            aBlock value:l.
        ]
    ].

    "Created: / 27-04-2010 / 12:09:03 / cg"
!

cleanAllInfoFor:aClass withChange:withChangeNotifications
    aClass instAndClassMethodsDo:[:m |
        m isInstrumented ifTrue:[
            m cleanInstrumentationInfoWithChange:withChangeNotifications
        ].
    ].
!

cleanAllInfoWithChange:withChange
    self allInfosDo:[:info |
        info cleanInfoWithChange:withChange.
    ].

    "
     InstrumentingCompiler::InstrumentationInfo cleanAllInfo
     InstrumentingCompiler::MethodInvocationInfo cleanAllInfo
    "

    "Modified: / 27-04-2010 / 12:10:07 / cg"
    "Created: / 20-07-2011 / 19:00:37 / cg"
! !

!InstrumentationInfo methodsFor:'accessing'!

currentInstrumentationContext

    "Created: / 08-08-2011 / 14:41:58 / cg"
!

owningMethod:something
    owningMethod := something.
! !

!InstrumentationInfo methodsFor:'cleanup'!

cleanInfoWithChange:withChange
    self subclassResponsibility
! !

!InstrumentationInfo methodsFor:'instrumentation probe calls'!

entry:callingContext
    "called on entry from instrumented code"

    "Created: / 27-04-2010 / 12:06:48 / cg"
! !

!InstrumentationInfo methodsFor:'private'!

changeClassToAlreadyEntered
    "nothing done here"
!

changeClassToCoverageAndAlreadyEntered
    "nothing done here"
! !

!InstrumentationInfo methodsFor:'testing'!

isBlockExecutionInfo
    ^ false

    "Created: / 07-08-2011 / 17:06:54 / cg"
!

isMethodInvocationInfo
    ^ false

    "Created: / 08-08-2011 / 14:40:31 / cg"
!

isSpecialInstrumentationInfoLiteral
    "return true, if the receiver is a special instrumentation info
     object as placed into the literal array of instrumented methods"

    ^ true

    "Created: / 07-08-2011 / 17:04:27 / cg"
!

isStatementExecutionInfo
    ^ false

    "Created: / 08-08-2011 / 14:40:43 / cg"
!

isVariableAccessExecutionInfo
    ^ false
! !

!InstrumentationInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/InstrumentationInfo.st,v 1.7 2015-01-29 18:16:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/InstrumentationInfo.st,v 1.7 2015-01-29 18:16:51 cg Exp $'
! !

