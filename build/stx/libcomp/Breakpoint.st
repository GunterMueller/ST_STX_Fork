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
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Breakpoint
	instanceVariableNames:'position description line isReached method'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Debugging'
!

!Breakpoint class methodsFor:'documentation'!

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
    statement breakpoint support.
    Instances of me are placed into a (bytecode-) compiled method's
    literal array and are sent messages dynamically when a statement
    with a breakpoint is about to be executed.
"    
! !

!Breakpoint class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!Breakpoint class methodsFor:'queries'!

breakpointDescriptionClass
    "redefinable in subclasses"
    
    ^ BreakpointDescription
! !

!Breakpoint class methodsFor:'utilities'!

disableAllBreakpoints
    MethodWithBreakpoints allBreakpointedMethods do:[:m |
        m disableAllBreakpoints
    ]

    "Created: / 03-02-2014 / 10:35:55 / cg"
! !

!Breakpoint methodsFor:'accessing'!

description
    ^ description
!

description:aBreakpointDescription
    description := aBreakpointDescription.
!

isReached
    ^ isReached
!

isReached:aBoolean
    isReached := aBoolean.
!

line
    "the lineNr"
    
    ^ line
!

line:lineArg
    self assert:lineArg >= 0.
    line := lineArg.
!

method:something
    method := something.
!

position
    ^ position
!

position:anInteger
    position := anInteger.

    "Modified (format): / 02-08-2012 / 09:26:03 / cg"
!

position:positionArg line:lineArg
    position := positionArg.
    line := lineArg.
    self assert:lineArg >= 0.

    "Created: / 02-08-2012 / 09:26:27 / cg"
! !

!Breakpoint methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ method := nil.
    "/ position := nil.
    description := self class breakpointDescriptionClass new.
    "/ line := nil.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 21-08-2014 / 09:35:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Breakpoint methodsFor:'printing & storing'!

printBreakpointNrInDebuggerOn:aStream
    "to be redefined for concrete debuggers"
!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    aStream nextPutAll: 'BPNT '.
    self printBreakpointNrInDebuggerOn:aStream.
    aStream nextPutAll: ' at'.
    position notNil ifTrue:[
        aStream
            nextPutAll: ' source position:';
            nextPutAll: position printString.
    ].
    line notNil ifTrue:[
        aStream
            nextPutAll: ' line:';
            nextPutAll: line printString.
    ].
    (position isNil and:[line isNil]) ifTrue:[
        aStream nextPutAll: ' ???'
    ]

    "Modified: / 24-04-2013 / 20:42:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Breakpoint methodsFor:'support'!

beInvisible
    "make this breakpoint hidden (in gutter)"

    description beInvisible
!

beTracepoint
    "make this breakpoint a tracepoint"

    description beTracepoint

    "Created: / 27-01-2012 / 13:56:11 / cg"
!

break
    "invoked by the breakPoint's code (see BreakPointNode)"

    <resource: #skipInDebuggersWalkBack>

    |sender mthd where lineNr message 
     source sourceLines sourceLine prevLine nextLine|

    description isEnabled ifFalse:[^ self].
    sender := thisContext sender.
    (description shouldBreakIn: sender) ifTrue:[
        message := 'Breakpoint encountered at line %1 in %2'.
        where := '?'.

        mthd := method.
        mthd notNil ifTrue:[
            mthd mclass isNil ifTrue:[
                mthd := sender method.
            ].
            where := mthd whoString.

            (lineNr := self line) notNil ifTrue:[
                (source := mthd source) notNil ifTrue:[
                    sourceLines := source asStringCollection.
                    sourceLine := sourceLines at:lineNr ifAbsent:[nil].
                    sourceLine notNil ifTrue:[
                        sourceLine := (sourceLine withoutLeadingSeparators contractAtEndTo:60) allItalic withColor:Color red darkened.
                        message := 'Breakpoint encountered at:\\%3\\line %1 in %2'.
                        lineNr > 1 ifTrue:[
                            prevLine := sourceLines at:(lineNr-1) ifAbsent:[nil].
                            prevLine notEmptyOrNil ifTrue:[
                                prevLine := prevLine withoutLeadingSeparators.
                                prevLine notEmpty ifTrue:[
                                    prevLine := (prevLine contractAtEndTo:60) allItalic.
                                    prevLine := '...', Character cr , prevLine.
                                ] ifFalse:[
                                    prevLine := '...'.
                                ].  
                                prevLine := prevLine withColor:Color grey.
                                message := 'Breakpoint encountered at:\\%4\%3\\line %1 in %2'.
                            ].
                        ].
                        lineNr < (sourceLines size) ifTrue:[
                            nextLine := sourceLines at:(lineNr+1) ifAbsent:[nil].
                            nextLine notEmptyOrNil ifTrue:[
                                nextLine := nextLine withoutLeadingSeparators.
                                nextLine notEmpty ifTrue:[
                                    nextLine := (nextLine withoutLeadingSeparators contractAtEndTo:60) allItalic.
                                    nextLine := nextLine , Character cr , '...'.
                                ] ifFalse:[
                                    nextLine := '...'.
                                ].    
                                nextLine := nextLine withColor:Color grey.

                                prevLine notNil ifTrue:[
                                    message := 'Breakpoint encountered at:\\%4\%3\%5\\line %1 in %2'.
                                ] ifFalse:[
                                    message := 'Breakpoint encountered at:\\%3\%5\\line %1 in %2'.
                                ].
                            ].
                        ].
                    ].    
                ].    
            ].    
        ].
        BreakPointInterrupt
            raiseRequestWith: self
            errorString:(message withCRs 
                                    bindWith:self line 
                                    with:where 
                                    with:sourceLine
                                    with:prevLine
                                    with:nextLine)
            "/ in:sender.
    ].
    (description shouldTraceIn: sender) ifTrue:[
        Transcript 
            show:Timestamp now;
            showCR:(' Trace %1 [%2]' bindWith:sender methodPrintString with:self line)
    ].

    "Created: / 15-06-2011 / 12:48:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2011 / 18:17:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-10-2017 / 15:24:35 / cg"
!

disable
    "disable this breakpoint"

    "/ if there is currently an ignore on this breakpoint in the debugger, remove it
    DebugView stopIgnoringHaltsFor:method atLineNr:line.
    description disable
!

toggle
    "toggle this breakpoint"

    "/ if there is currently an ignore on this breakpoint in the debugger, remove it
    DebugView stopIgnoringHaltsFor:method atLineNr:line.
    description toggle

    "Created: / 17-06-2011 / 13:40:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2011 / 18:18:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-01-2012 / 10:41:03 / cg"
!

toggleTracing
    "toggle this breakpoint"

    description toggleTracing

    "Created: / 27-01-2012 / 13:56:05 / cg"
! !

!Breakpoint methodsFor:'testing'!

isEnabled

    "Bad coding here, state should be full object"

    ^description isEnabled

    "Created: / 28-06-2011 / 08:27:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTracepoint
    ^description isTracepoint
!

isVisible
    ^description isVisible
! !

!Breakpoint class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id $'
! !

