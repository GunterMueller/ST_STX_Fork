"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

Object subclass:#MiniInspector
	instanceVariableNames:'inspectedObject commandArg inputStream'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Debugging-Support'
!

!MiniInspector class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    a primitive (non graphical) inspector for use on systems without
    graphics or when the real inspector dies (i.e. the UI is locked).
    Sometimes useful as a last chance to fix a broken UI / event handling.
    Needs a console.

        MiniInspector openOn: Display

    Attention:
        all printing is done via lowLevel _errorPrint messages,
        to ensure that output is to stderr, even if a logger is present, 
        or Stderr has been set to some other stream (Transcript).
        Also to avoid the logger's interfering and adding imestamp information.

    [author:]
        Claus Gittinger
"
! !

!MiniInspector class methodsFor:'instance creation'!

openOn:anObject
    ^ self openOn:anObject input:nil
!

openOn:anObject input:inputStreamOrNil
    |anInspector|

    anInspector := (self new) initializeFor:anObject.
    anInspector inputStream:inputStreamOrNil.
    anInspector enter.
    ^ anInspector
! !

!MiniInspector methodsFor:'accessing'!

inputStream:something
    inputStream := something.
! !

!MiniInspector methodsFor:'private'!

callInspect:anotherObject message:msg
    msg _errorPrintCR.
    
    MiniInspector openOn:anotherObject input:inputStream.

    'Back in previous inspector on: ' _errorPrint.  
    inspectedObject displayString _errorPrintCR.
!

commandLoop
    |cmd valid lastValue|

    'MiniInspector on ' _errorPrint.  
    inspectedObject displayString _errorPrintCR.
    '' _errorPrintCR.

    [true] whileTrue:[
        valid := false.
        cmd := self getCommand:'inspector> '.
        cmd isNil ifTrue:[   "/ EOF -> quit
            cmd := $q
        ].
        cmd isNumber ifTrue:[
            valid := true.
            self inspectInstvar:cmd of:inspectedObject
        ].
        (cmd == $i) ifTrue:[
            valid := true.
            self printInstVarsOf:inspectedObject
        ].
        (cmd == $p) ifTrue:[
            valid := true.
            inspectedObject displayString _errorPrintCR
        ].
        (cmd == $c) ifTrue:[
            valid := true.
            inspectedObject class displayString _errorPrintCR
        ].
        (cmd == $C) ifTrue:[
            valid := true.
            self callInspect:inspectedObject class message:'inspecting class...'.
        ].
        (cmd == $d) ifTrue:[
            valid := true.
            ObjectMemory dumpObject:inspectedObject
        ].
        (cmd == $D) ifTrue:[
            valid := true.
            ObjectMemory dumpObject:inspectedObject class
        ].
        ((cmd == $e) or:[ cmd == $E ]) ifTrue:[
            valid := true.
            lastValue := Parser evaluate:commandArg receiver:inspectedObject.
            (cmd == $e) ifTrue:[
                lastValue _errorPrintCR.
            ].
        ].
        (cmd == $$) ifTrue:[
            valid := true.
            self callInspect:lastValue message:'inspecting last value...'.
        ].
        (cmd == $*) ifTrue:[
            valid := true.
            inspectedObject becomeNil.
            ^ cmd.
        ].
        (cmd == $I) ifTrue:[
            valid := true.
            self interpreterLoopWith:inspectedObject
        ].

        (cmd == $q) ifTrue:[
            ^ cmd.
        ].

        valid ifFalse: [
            'valid commands:
 p ...... print inspected object
 i ...... print instvars
 d ...... VM-dump inspected object
 P ...... print inspected object''s class
 D ...... VM-dump inspected object''s class

 I ...... interpreter
 e expr   evaluate expression & print result ("E" to not print)
 $        inspect the value of the last evaluated expression

 C ...... inspect class
 <Num> .. inspect instvar num (1..)

 * ...... becomeNil and quit (dangerous)
 q ...... quit
'           _errorPrintCR
        ]
    ].

    "Modified: / 03-02-2014 / 10:19:46 / cg"
!

enter
    AbortOperationRequest handle:[:ex |
        '** Abort Signal caught - back in previous debugLevel' _errorPrintCR.
        ex restart
    ] do:[
        Error handle:[:ex |
            |yesNo|

            'Error while executing command: ' _errorPrint.
            ex description _errorPrintCR.
            yesNo := self getCommand:'- (i)gnore / (p)roceed / (d)ebug ? '.
            yesNo == $d ifTrue:[
                ex reject
            ].
            yesNo == $p ifTrue:[
                ex proceed
            ].
            ex restart
        ] do:[
            self commandLoop.
        ].
    ].
    ^ nil
!

getCharacter
    inputStream isNil ifTrue:[
        "/ globally blocking
        ^ Character fromUser
    ].
    ^ inputStream next
!

getCommand:prompt
    |cmd c num arg|

    prompt _errorPrint.

    c := cmd := self getCharacter.
    c isNil ifTrue:[
        ^ nil.
    ].
    c isDigit ifTrue:[
        num := 0.
        [
            num := (num * 10) + c digitValue.
            c := self getCharacter.
        ] doWhile:[c notNil and:[c isDigit]].
        ^ num "/ numeric
    ].

    c := self getCharacter.
    [c notNil and:[c isEndOfLineCharacter not and:[c isSeparator ]]] whileTrue:[ c := self getCharacter ].
    arg := ''.
    [c notNil and:[c isEndOfLineCharacter]] whileFalse:[
        arg := arg copyWith:c.
        c := self getCharacter
    ].
    commandArg := arg.
    ^ cmd

    "Modified: / 03-02-2014 / 10:16:49 / cg"
!

initializeFor:anObject
    inspectedObject := anObject.
    ^self
!

inspect:anObject
    inspectedObject := anObject.
!

inspectInstvar:which of:anObject
    |numInsts idx|

    numInsts := anObject class instSize.

    which > numInsts ifTrue:[
        idx := which - numInsts.
        idx > anObject basicSize ifTrue:[
            'invalid indexed instvar index: ' _errorPrint. idx _errorPrintCR
        ] ifFalse:[
            self callInspect:(anObject basicAt:idx) message:('Inspecting indexed instVar ',which printString,'...')
        ]
    ] ifFalse: [
        which < 0 ifTrue:[
            'invalid instVar # (must be >= 1)' _errorPrintCR
        ] ifFalse:[
            self callInspect:(anObject instVarAt:which) message:('Inspecting instVar ',which printString,'...')
        ].
    ]

    "Modified: 20.5.1996 / 10:27:40 / cg"
!

interpreterLoopWith:anObject
    |line done rslt|

    'read-eval-print loop; exit with empty line' _errorPrintCR.
    '' _errorPrintCR.

    done := false.
    [done] whileFalse:[
        '> ' _errorPrint.

        line := Processor activeProcess stdin nextLine.
        (line size == 0) ifTrue:[
            done := true
        ] ifFalse:[
            rslt := Compiler
                evaluate:line
                in:nil
                receiver:anObject
                notifying:nil
                ifFail:[].
            rslt _errorPrintCR.
        ]
    ]
!

printInstVarsOf:anObject
    |n "{ Class: SmallInteger }" names |

    n := anObject class instSize.
    names := anObject class allInstVarNames.

    'number of instvars: ' _errorPrint. n _errorPrintCR.
    1 to:n do:[:i |
        (i printStringLeftPaddedTo:2) _errorPrint.
        ' {' _errorPrint. (names at:i) _errorPrint. '}' _errorPrint.
        ': ' _errorPrint.
        ((anObject instVarAt:i) displayString contractAtEndTo:160) _errorPrintCR
    ].

    n := anObject basicSize.
    n > 0 ifTrue:[
        'number of indexed instvars: ' _errorPrint. n _errorPrintCR.
        n > 10 ifTrue:[n := 10].
        1 to:n do:[:i |
            ' [' _errorPrint. i _errorPrint. ']: ' _errorPrint.
            ((anObject basicAt:i) displayString contractAtEndTo:160) _errorPrintCR
        ]
    ].

    "Modified: 20.5.1996 / 10:27:45 / cg"
! !

!MiniInspector class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

