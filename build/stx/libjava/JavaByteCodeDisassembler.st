"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

JavaByteCodeProcessor subclass:#JavaByteCodeDisassembler
	instanceVariableNames:'outStream placeholders format lastLno'
	classVariableNames:'StandardFormat ExtendedFormat'
	poolDictionaries:''
	category:'Languages-Java-Bytecode'
!

!JavaByteCodeDisassembler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaByteCodeDisassembler class methodsFor:'initialization'!

initialize
    Verbose := false.
    StandardFormat := '  %(PC) %(ISN) %(OPERANDS)'.
    ExtendedFormat := '  %(PC) [%(OPCODE)] %(ISN) %(OPERANDS) %(STACK)'.

    "Modified: / 22-03-2011 / 17:07:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-03-2011 / 20:53:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeDisassembler class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!JavaByteCodeDisassembler class methodsFor:'disassembling'!

diassemble:aMethod 
    ^ self new diassemble:aMethod.

    "Created: / 17-03-2011 / 17:41:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

diassemble:aMethod to: aStream 
    ^ self new diassemble:aMethod to: aStream

    "Created: / 22-03-2011 / 21:13:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeDisassembler methodsFor:'disassembling'!

diassemble:aJavaMethod 
    self diassemble:aJavaMethod to:Transcript.

    "Created: / 17-03-2011 / 17:42:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 22:43:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

diassemble:aJavaMethod to:aStream 
    |fakeArgArray size|

    outStream := aStream.
    size := aJavaMethod javaNumArgs.
    fakeArgArray := Array new:size.
    1 to:size
        do:[:index | fakeArgArray at:index put:('Arg ' , index printString) ].
    self prettyPrintHeaderFor:aJavaMethod.
    self 
        process:aJavaMethod
        receiver:aJavaMethod javaClass
        arguments:fakeArgArray.

    "Created: / 17-03-2011 / 22:21:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-03-2011 / 15:59:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeDisassembler methodsFor:'helpers - constants'!

address
^ 'address'.

    "Created: / 20-03-2011 / 21:20:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

arrayLength
    ^ 'arrayLength'

    "Created: / 20-03-2011 / 18:31:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

arrayRef
    ^ 'arrayRef'

    "Created: / 20-03-2011 / 18:24:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dimensions
^'count1, [count2,...]'.

    "Created: / 20-03-2011 / 21:26:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

empty
    ^ 'EMPTY'

    "Created: / 20-03-2011 / 18:30:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

excRef
    ^ 'exceptionRef'

    "Created: / 20-03-2011 / 18:36:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

index
    ^ 'index'

    "Created: / 20-03-2011 / 18:28:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

key
^'key'.

    "Created: / 20-03-2011 / 21:24:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

nothing
    ^ ''

    "Created: / 20-03-2011 / 18:31:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

null
    ^ 'null'

    "Created: / 20-03-2011 / 18:29:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

objRef
^ 'objectRef'

    "Created: / 20-03-2011 / 18:24:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

result
    ^ 'result'

    "Created: / 20-03-2011 / 18:40:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

sep
^ ', '.

    "Created: / 20-03-2011 / 18:28:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

size
    ^ 'size'

    "Created: / 20-03-2011 / 18:30:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

stackGroupClose
    ^ '}'.

    "Created: / 20-03-2011 / 21:02:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

stackGroupOpen
^'{'.

    "Created: / 20-03-2011 / 21:02:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

value
    ^ 'value'

    "Created: / 20-03-2011 / 18:24:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

valueMarked
    ^ 'valueX'

    "Created: / 20-03-2011 / 20:58:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

valueMarked2
    ^ 'valueY'

    "Created: / 20-03-2011 / 21:33:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

varArgs
^'[arg1, arg2, ...] '.

    "Created: / 20-03-2011 / 21:16:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

whatever
    ^ '..'

    "Created: / 20-03-2011 / 18:31:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeDisassembler methodsFor:'helpers - instruction groups'!

arrayValueLoader    
self 
        writeInstructionWithArgs: self nothing
        stackBefore: self arrayRef , self sep , self index
        after: self value.

    "Created: / 20-03-2011 / 19:58:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

arrayValueStorer
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self arrayRef , self sep , self index , self sep , self value
        after: self whatever.

    "Created: / 20-03-2011 / 20:01:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

constPusher: const
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self whatever
        after: const.

    "Created: / 20-03-2011 / 20:39:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fieldLoader: index 
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self whatever
        after: (self prettyPrintField: index).

    "Created: / 20-03-2011 / 20:43:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:23:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fieldStorer: index 
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: (self prettyPrintField: index)
        after: self whatever.

    "Created: / 20-03-2011 / 20:53:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:23:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

indexedFieldLoader
    | index |

    wide 
        ifTrue: 
            [ index := self fetchIndex2.
            wide := false. ]
        ifFalse: [ index := self fetchIndex ].
    self 
        writeInstructionWithArgs: (self prettyPrintField: index)
        stackBefore: self whatever
        after: self whatever.

    "Created: / 20-03-2011 / 20:44:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 19-05-2011 / 10:38:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

indexedFieldStorer
    | index |

    wide 
        ifTrue: 
            [ index := self fetchIndex2.
            wide := false. ]
        ifFalse: [ index := self fetchIndex ].
    self 
        writeInstructionWithArgs: (self prettyPrintField: index)
        stackBefore: (self prettyPrintValue:'newVal')
        after: self whatever.

    "Created: / 20-03-2011 / 20:53:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 19-05-2011 / 13:04:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

returnIfFinished
    (pc >= byteCode size) ifTrue: [ self leaveProcessorWith: nil ].

    "Created: / 21-03-2011 / 14:54:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

twoValuesBasedJumper
    self 
        writeInstructionWithArgs: (self prettyPrintJump: self fetchBytes2)
        stackBefore: self value , self sep , self value
        after: self whatever.

    "Created: / 20-03-2011 / 21:10:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 23:03:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

twoValuesManipulator
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self value , self sep , self value         after: self result.

    "Created: / 20-03-2011 / 20:31:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

valueBasedJumper
    self 
        writeInstructionWithArgs: (self prettyPrintJump: self fetchBytes2)
        stackBefore: self value
        after: self whatever.

    "Created: / 20-03-2011 / 21:09:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 13:03:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

valueLoader
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self whatever
        after: self value.

    "Created: / 20-03-2011 / 20:25:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

valueManipulator
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self value
        after: self result.

    "Created: / 20-03-2011 / 20:27:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

valueReturner
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self value
        after: self empty.
    self returnIfFinished.

    "Created: / 20-03-2011 / 20:48:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 14:55:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeDisassembler methodsFor:'helpers - printing'!

prettyPrintArgs: argsString 
    ^argsString printString

    "Created: / 20-03-2011 / 17:30:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 20:42:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prettyPrintByte: val 
    ^ self prettyPrintValue: val.

    "Created: / 20-03-2011 / 21:46:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

prettyPrintExceptionTable: table 
    table isNil ifTrue: [ ^ '' ].
    ^ 'Throws:' 
        , (table inject: '' into: [:acc :each | acc , ' ' , each javaName ]).

    "Created: / 22-03-2011 / 16:16:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-06-2011 / 17:19:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-10-2013 / 22:42:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prettyPrintField: fieldIndex 
    ^ 'FIELD ' , fieldIndex printString , ': ' 
        , (context at: fieldIndex + 1) displayString.

    "Created: / 20-03-2011 / 17:31:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:57:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

prettyPrintHeaderFor: javaMethod 
    outStream
        cr;
        print: (javaMethod signatureNameWithModifiers);
        cr;
        print: ('defined in: ' , javaMethod javaClass printString);
        cr;
        print: '# arg slots: ' , javaMethod numArgs printString , ', ';
        print: '# var slots: ' , javaMethod numVars printString , ', ';
        print: '# stack slots: ', javaMethod stackSize printString , ' ';
        cr;
        print: (self prettyPrintExceptionTable: javaMethod exceptionTable);
        cr.

    "Created: / 22-03-2011 / 15:59:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-10-2012 / 11:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prettyPrintIndex: index 
    ^ (constantPool at: index) displayString , ' [' , index printString 
        , '@CP]'.

    "Created: / 20-03-2011 / 17:20:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-03-2011 / 16:48:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

prettyPrintJump: jmpNum 
    ^ 'JMP to: ' , (instrPointer + jmpNum ) printString.

    "Modified: / 21-03-2011 / 14:25:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

prettyPrintLineNumber
    |lineNumber|
    lineNumber := method lineNumberForPC0: instrPointer.
    lineNumber isNil ifTrue: [^''].
    ^ (lineNumber printString leftPaddedTo: 4
        with: Character space)

    "Modified: / 22-03-2011 / 17:04:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 11-09-2013 / 03:42:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prettyPrintLookupSwitchMadness
    | paddingSize  default  npairs  result |
    result := TextStream on: ''.
    paddingSize := self skipPadding.
    default := self fetchBytes4.
    npairs := self fetchBytes4.
    result
        print: 'PADDING: ';
        print: paddingSize printString;
        print: ' NPAIRS: ';
        print: npairs printString;
        cr.
    result
        print: ('      [ ');
        cr.
    npairs timesRepeat:
        
            [ result
                print: '      ';
                print: (self fetchBytes4 printString);
                print: ': ';
                print: (self prettyPrintJump: self fetchBytes4);
                cr. ].
    result
        print: ('      default');
        print: ': ';
        print: (self prettyPrintJump: default);
        cr.
    result
        print: ('   ]');
        cr.
    ^ result stringContents.

    "Created: / 20-03-2011 / 21:23:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-03-2011 / 15:03:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2011 / 17:31:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prettyPrintRef: ref

    ^ ref prettyPrintString.

    "Created: / 20-03-2011 / 17:20:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-08-2011 / 21:12:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prettyPrintStackBefore: beforeString after: afterString 
    ^ 'STACK: [' , beforeString printString , ' -> ' , afterString printString , ']'.

    "Created: / 20-03-2011 / 17:24:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

prettyPrintTableSwitchMadness
    | paddingSize  default  low  high  result |

    result := TextStream on: ''.
    paddingSize := self skipPadding.
    default := self fetchBytes4.
    low := self fetchBytes4.
    high := self fetchBytes4.
    result
        print: 'PADDING: ';
        print: paddingSize printString;
        print: ' LOW: ';
        print: low printString;
        print: ' HIGH: ';
        print: high printString;
        cr.
    result
        print: ('   [ ');
        cr.
    low to: high
        do: 
            [:index | 
            result
                nextPutAll:'  '; print: (index printString);
                print: ': ';
                print: (self prettyPrintJump: self fetchBytes4);
                cr. ].
                result
                print: ('   default');
                print: ': ';
                print: (self prettyPrintJump: default);
                                cr. 
    result
        print: ('   ]');
        cr.
    ^ result stringContents.

    "Created: / 20-03-2011 / 21:34:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:01:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2011 / 17:29:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prettyPrintType: type
    type = 4 ifTrue: [ ^ 'boolean'].
    type = 5 ifTrue: [ ^'char'].
    type = 6 ifTrue: [ ^  'float'  ].
    type = 7 ifTrue: [ ^'double' ].
    type = 8 ifTrue: [ ^  'byte'  ].
    type = 9 ifTrue: [ ^ 'short'  ].
    type = 10 ifTrue: [ ^'int'  ].
    type = 11 ifTrue: [ ^ 'long'  ].

    "Created: / 20-03-2011 / 20:12:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

prettyPrintValue: val 
    ^ val printString.

    "Created: / 20-03-2011 / 18:16:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

writeInstructionWithArgs: argsString stackBefore: stackBefore after: stackAfter 
    placeholders
        at: 'PC'
            put: (instrPointer printString leftPaddedTo: 3 with: Character space);
        at: 'LINENUMBER' put: self prettyPrintLineNumber;
        at: 'OPCODE' put: (op printString leftPaddedTo: 3 with: Character space);
        at: 'ISN'
            put: ((OpSwitchTable at: op + 1) asUppercase printString paddedTo: 10);
        at: 'OPERANDS' put: ((self prettyPrintArgs: argsString) paddedTo: 25);
        at: 'STACK'
            put: (self prettyPrintStackBefore: stackBefore after: stackAfter).
    format expandPlaceholdersWith: placeholders on: outStream.
    outStream cr.

    "Created: / 20-03-2011 / 19:56:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 20:56:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-03-2011 / 17:00:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

writeLine: lno

    outStream nextPutAll: 'LINE '.
    lno printOn: outStream.
    outStream cr.

    "Modified: / 22-03-2011 / 17:00:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 22-03-2011 / 20:53:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeDisassembler methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ outStream := nil.
    placeholders := Dictionary new.
    format := StandardFormat.
              "/ExtendedFormat.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 22-03-2011 / 20:53:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeDisassembler methodsFor:'instructions'!

aaload
    self 
        arrayValueLoader.

    "Modified: / 20-03-2011 / 19:59:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

aastore
    self 
        arrayValueStorer.

    "Modified: / 20-03-2011 / 20:01:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

aconst_null
    self 
        constPusher: 'null'.

    "Modified: / 20-03-2011 / 20:39:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

aload

    self 
        writeInstructionWithArgs: (self prettyPrintField: self fetchIndex)
        stackBefore: self whatever
        after: self objRef.

    "Modified: / 21-03-2011 / 15:45:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

aload: arg 
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self whatever
        after: (self prettyPrintField: arg).

    "Modified: / 21-03-2011 / 16:30:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

anewarray
self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)
        stackBefore: self size 
        after: self arrayRef.

    "Modified: / 20-03-2011 / 20:09:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

areturn
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self objRef
        after: self empty.
    self returnIfFinished.

    "Modified: / 21-03-2011 / 14:55:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

arraylength
 self 
        writeInstructionWithArgs: self nothing
        stackBefore: self arrayRef
         after: self arrayLength.

    "Modified: / 20-03-2011 / 20:16:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

astore
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex)
        stackBefore: self objRef
            after: self whatever.

    "Modified: / 20-03-2011 / 20:19:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

astore: arg 
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self objRef
            after: self whatever.

    "Modified: / 20-03-2011 / 20:19:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

athrow
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self objRef
        after: self empty , self sep , self excRef.
        self returnIfFinished.

    "Modified: / 22-03-2011 / 14:24:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

baload
self arrayValueLoader.

    "Modified: / 20-03-2011 / 19:59:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

bastore
    self 
        arrayValueStorer.

    "Modified: / 20-03-2011 / 20:01:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

bipush
    self 
        writeInstructionWithArgs: (self prettyPrintByte: self fetchByte)
        stackBefore: self whatever
        after: self value.

    "Modified: / 20-03-2011 / 21:32:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

breakpoint
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self whatever
            after: self whatever.

    "Modified: / 20-03-2011 / 20:26:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

caload
self arrayValueLoader.

    "Modified: / 20-03-2011 / 19:59:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

castore
    self 
        arrayValueStorer.

    "Modified: / 20-03-2011 / 20:02:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

checkcast
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)
        stackBefore: self objRef
            after: self objRef.

    "Modified: / 20-03-2011 / 20:23:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

d2f
    self 
        valueManipulator.

    "Modified: / 20-03-2011 / 20:27:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

d2i
  self valueManipulator.

    "Modified: / 20-03-2011 / 20:27:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

d2l
 self valueManipulator.

    "Modified: / 20-03-2011 / 20:28:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dadd
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:31:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

daload
self arrayValueLoader.

    "Modified: / 20-03-2011 / 19:59:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dastore
    self 
        arrayValueStorer.

    "Modified: / 20-03-2011 / 20:01:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dcmpg
 self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:31:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dcmpl
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:31:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dconst: arg 
    self constPusher: arg.

    "Modified: / 20-03-2011 / 20:39:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ddiv
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:31:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dload
    self indexedFieldLoader.

    "Modified: / 20-03-2011 / 20:44:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dload: arg 
self fieldLoader: arg.

    "Modified: / 20-03-2011 / 20:45:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dmul
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:31:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dneg
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:28:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

drem
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:31:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dreturn
    self valueReturner.

    "Modified: / 20-03-2011 / 20:47:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dstore
    self indexedFieldStorer.

    "Modified: / 20-03-2011 / 20:54:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dstore: arg 
self fieldStorer: arg.

    "Modified: / 20-03-2011 / 20:55:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dsub
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:32:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dup
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self value
        after: self valueMarked , self sep , self valueMarked.

    "Modified: / 20-03-2011 / 20:58:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dup2
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self stackGroupOpen , self value , self sep , self value , self stackGroupClose
            after: self stackGroupOpen , self value , self sep , self value , self stackGroupClose , self sep , self stackGroupOpen , self value , self sep , self value , self stackGroupClose.

    "Modified: / 20-03-2011 / 21:03:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dup2_x1
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self stackGroupOpen , self value , self sep , self value 
                , self stackGroupClose
        after: self stackGroupOpen , self value , self sep , self value 
                , self stackGroupClose , self sep 
                , self stackGroupOpen , self value 
                , self sep , self value 
                    , self stackGroupClose.

    "Modified: / 20-03-2011 / 21:06:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dup2_x2
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self stackGroupOpen , self value , self sep , self value 
                , self stackGroupClose , self sep , self stackGroupOpen , self valueMarked , self sep , self valueMarked 
                                , self stackGroupClose
        after: self stackGroupOpen , self valueMarked , self sep , self valueMarked 
                , self stackGroupClose , self sep 
                , self stackGroupOpen , self value 
                , self sep , self value 
                        , self stackGroupClose , self sep ,  self stackGroupOpen , self valueMarked , self sep , self valueMarked 
                , self stackGroupClose.

    "Modified: / 20-03-2011 / 21:07:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dup_x1
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self value , self sep , self valueMarked
        after: self valueMarked , self sep , self value , self sep 
                    , self valueMarked.

    "Modified: / 20-03-2011 / 21:00:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dup_x2
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self value , self sep , self value , self sep , self valueMarked
        after: self valueMarked , self sep , self value , self sep , self value , self sep ,
                     self valueMarked.

    "Modified: / 20-03-2011 / 21:01:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

f2d
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:28:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

f2i
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:28:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

f2l
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:28:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fadd
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:32:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

faload
self arrayValueLoader.

    "Modified: / 20-03-2011 / 20:00:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fastore
    self 
        arrayValueStorer.

    "Modified: / 20-03-2011 / 20:01:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fcmpg
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:32:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fcmpl
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:32:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fconst: arg 
    self constPusher: arg.

    "Modified: / 20-03-2011 / 20:39:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fdiv
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:32:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fload
self indexedFieldLoader.

    "Modified: / 20-03-2011 / 20:44:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fload: arg 
self fieldLoader: arg.

    "Modified: / 20-03-2011 / 20:45:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fmul
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:32:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fneg
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:28:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

frem
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:32:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

freturn
    self valueReturner.

    "Modified: / 20-03-2011 / 20:48:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fstore
self indexedFieldStorer.

    "Modified: / 20-03-2011 / 20:54:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fstore: arg 
   self fieldStorer: arg.

    "Modified: / 20-03-2011 / 20:55:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fsub
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:32:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

getfield
    | index |

    index := self fetchIndex2.
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: index)
        stackBefore: self objRef
        after: self objRef.

    "Modified: / 21-03-2011 / 16:25:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

getstatic
    | index |

    index := self fetchIndex2.
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: index)
        stackBefore: self whatever
        after: self objRef.

    "Modified: / 21-03-2011 / 16:25:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

goto

    self 
        writeInstructionWithArgs: (self prettyPrintJump: self fetchBytes2)
        stackBefore: self whatever
        after: self whatever.
        self returnIfFinished.

    "Modified: / 22-03-2011 / 14:30:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

goto_w
    self 
        writeInstructionWithArgs: (self prettyPrintJump: self fetchBytes4)
        stackBefore: self whatever
        after: self whatever.
        self returnIfFinished.

    "Modified: / 22-03-2011 / 14:30:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

i2d
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:28:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

i2f
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:29:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

i2l
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:29:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

i_dup
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

iadd
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:33:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iaload
self arrayValueLoader.

    "Modified: / 20-03-2011 / 20:00:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iand
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:33:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iastore
    self 
        arrayValueStorer.

    "Modified: / 20-03-2011 / 20:02:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iconst: arg
self constPusher: arg.

    "Created: / 20-03-2011 / 20:41:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

idiv
self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:33:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifacmpeq
   self twoValuesBasedJumper.

    "Modified: / 20-03-2011 / 21:11:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifacmpne
    self twoValuesBasedJumper.

    "Modified: / 20-03-2011 / 21:11:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifeq
self valueBasedJumper.

    "Modified: / 20-03-2011 / 21:11:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifge
self valueBasedJumper.

    "Modified: / 20-03-2011 / 21:11:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifgt
self valueBasedJumper.

    "Modified: / 20-03-2011 / 21:11:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmpeq
    self twoValuesBasedJumper.

    "Modified: / 20-03-2011 / 21:10:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmpge
self twoValuesBasedJumper.

    "Modified: / 20-03-2011 / 21:11:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmpgt
self twoValuesBasedJumper.

    "Modified: / 20-03-2011 / 21:11:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmple
self twoValuesBasedJumper.

    "Modified: / 20-03-2011 / 21:11:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmplt
self twoValuesBasedJumper.

    "Modified: / 20-03-2011 / 21:11:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmpne
self twoValuesBasedJumper.

    "Modified: / 20-03-2011 / 21:11:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifle
self valueBasedJumper.

    "Modified: / 20-03-2011 / 21:11:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iflt
self valueBasedJumper.

    "Modified: / 20-03-2011 / 21:11:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifne
self valueBasedJumper.

    "Modified: / 20-03-2011 / 21:11:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifnonnull
self valueBasedJumper.

    "Modified: / 20-03-2011 / 21:11:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifnull
self valueBasedJumper.

    "Modified: / 20-03-2011 / 21:12:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iinc

    wide 
        ifTrue: 
            [ self 
                writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2) 
                        , self sep , (self prettyPrintByte: self fetchBytes2)
                stackBefore: self objRef
                after: self result.
            wide := false. ]
        ifFalse: 
            [ self 
                writeInstructionWithArgs: (self prettyPrintField: self fetchIndex) 
                        , self sep , (self prettyPrintByte: self fetchByte)
                stackBefore: self objRef
                after: self result. ].

    "Modified: / 21-03-2011 / 16:23:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iload
self indexedFieldLoader.

    "Modified: / 20-03-2011 / 20:44:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iload: index 
    self fieldLoader: index.

    "Modified: / 20-03-2011 / 20:45:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

imul
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:33:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ineg
     self valueManipulator.

    "Modified: / 20-03-2011 / 20:30:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

instanceof
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)
        stackBefore: self objRef
            after: self result.

    "Modified: / 20-03-2011 / 20:21:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

int2byte
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:29:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

int2char
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:29:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

int2short
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:29:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

invdynamic
    | index |

    index := self fetchIndex2.
    pc := pc + 2.
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: index)                 
        stackBefore: self objRef , self sep , self varArgs
        after: self whatever.

    "Created: / 25-02-2015 / 19:37:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invinterface
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2) , self sep , ( self prettyPrintByte: self fetchByte) , self sep , 0 printString
        stackBefore: self objRef , self sep , self varArgs
        after: self whatever.

    "Modified: / 20-03-2011 / 21:15:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

invnonvirt
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)                 
        stackBefore: self objRef , self sep , self varArgs
        after: self whatever.

    "Modified: / 20-03-2011 / 21:17:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 25-02-2015 / 19:36:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invstatic
   self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)
        stackBefore: self varArgs
           after: self whatever.

    "Modified: / 20-03-2011 / 21:17:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

invvirt
     self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)
        stackBefore: self objRef , self sep , self varArgs
             after: self whatever.

    "Modified: / 20-03-2011 / 21:18:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ior
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:33:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

irem
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:33:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ireturn
   self valueReturner.

    "Modified: / 20-03-2011 / 20:48:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ishl
   self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:34:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ishr
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:34:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

istore
self indexedFieldStorer.

    "Modified: / 20-03-2011 / 20:54:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

istore: arg 
self fieldStorer: arg.

    "Modified: / 20-03-2011 / 20:55:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

isub
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:34:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iushr
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:34:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ixor
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:34:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

jsr
      self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)
        stackBefore: self whatever
              after: self address.

    "Modified: / 20-03-2011 / 21:20:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

jsr_w
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchBytes4)
        stackBefore: self whatever
        after: self address.

    "Modified: / 21-03-2011 / 13:03:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

l2d
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:29:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

l2f
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:29:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

l2i
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:29:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ladd
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:35:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

laload
self arrayValueLoader.

    "Modified: / 20-03-2011 / 20:00:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

land
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:35:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lastore
    self 
        arrayValueStorer.

    "Modified: / 20-03-2011 / 20:02:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lcmp
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:35:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lconst: arg 
    self constPusher: arg.

    "Modified: / 20-03-2011 / 20:41:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ldc1
self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex)
        stackBefore: self whatever
        after: self value.

    "Modified: / 20-03-2011 / 21:21:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ldc2
   self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)
        stackBefore: self whatever
           after: self value.

    "Modified: / 20-03-2011 / 21:21:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ldc2w
self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)
        stackBefore: self whatever
        after: self value.

    "Modified: / 22-03-2011 / 14:18:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ldiv
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:36:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lload
self indexedFieldLoader.

    "Modified: / 20-03-2011 / 20:44:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lload: arg 
self fieldLoader: arg.

    "Modified: / 20-03-2011 / 20:45:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lmul
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:36:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lneg
   self valueManipulator.

    "Modified: / 20-03-2011 / 20:29:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lookupswtch
    self 
        writeInstructionWithArgs: (self prettyPrintLookupSwitchMadness)
        stackBefore: self key
            after: self whatever.

    "Modified: / 20-03-2011 / 21:24:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lor
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:36:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lrem
   self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:36:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lreturn
    self valueReturner.

    "Modified: / 20-03-2011 / 20:48:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lshl
  self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:36:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lshr
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:36:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lstore
self indexedFieldStorer.

    "Modified: / 20-03-2011 / 20:54:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lstore: arg 
    self fieldStorer: arg.

    "Modified: / 20-03-2011 / 20:55:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lsub
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:36:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lushr
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:36:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lxor
    self twoValuesManipulator.

    "Modified: / 20-03-2011 / 20:36:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

monenter
  self 
        writeInstructionWithArgs: self nothing
        stackBefore: self objRef
        after: self whatever.

    "Modified: / 20-03-2011 / 20:20:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

monexit
self 
        writeInstructionWithArgs: self nothing
        stackBefore: self objRef
        after: self whatever.

    "Modified: / 20-03-2011 / 20:20:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

multianewarray
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2) 
                , self sep , (self prettyPrintByte: self fetchByte)
        stackBefore: self dimensions
        after: self arrayRef.

    "Modified: / 20-03-2011 / 21:25:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

new
self 
        writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)
        stackBefore: self whatever
        after: self objRef.

    "Modified: / 20-03-2011 / 20:07:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

newarray
self 
        writeInstructionWithArgs: (self prettyPrintType: self fetchByte)
        stackBefore: self size 
        after: self arrayRef.

    "Modified: / 20-03-2011 / 20:10:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

nop
   self 
        writeInstructionWithArgs: self nothing
        stackBefore: self whatever
           after: self whatever.

    "Modified: / 20-03-2011 / 21:26:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pop1
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self value
            after: self whatever.

    "Modified: / 20-03-2011 / 21:27:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pop2
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self value , self sep , self value
            after: self whatever.

    "Modified: / 20-03-2011 / 21:27:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

putfield
    | index |

    index := self fetchIndex2.
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: index)
        stackBefore: self objRef , self sep , self value
        after: self whatever.

    "Modified: / 21-03-2011 / 16:26:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

putstatic
    | index |

    index := self fetchIndex2.
    self 
        writeInstructionWithArgs: (self prettyPrintIndex: index)
        stackBefore: self value
        after: self whatever.

    "Modified: / 21-03-2011 / 16:26:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ret
    wide 
        ifTrue: 
            [ self 
                writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex2)
                stackBefore: self whatever
                after: self whatever.
            wide := false. ]
        ifFalse: 
            [ self 
                writeInstructionWithArgs: (self prettyPrintIndex: self fetchIndex)
                stackBefore: self whatever
                after: self whatever. ].
                self returnIfFinished.

    "Modified: / 21-03-2011 / 14:57:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ret_w
    self halt: 'spec doesnt know about me, what shall I do?'.

    "Modified: / 20-03-2011 / 21:31:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

return
    self 
        writeInstructionWithArgs: self nothing
        stackBefore: self whatever
        after: self empty.
    self returnIfFinished.

    "Modified: / 21-03-2011 / 14:56:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

saload
self arrayValueLoader.

    "Modified: / 20-03-2011 / 20:00:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

sastore
    self 
        arrayValueStorer.

    "Modified: / 20-03-2011 / 20:03:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

sipush
    self 
        writeInstructionWithArgs: (self prettyPrintByte: self fetchBytes2)
        stackBefore: self whatever
            after: self value.

    "Modified: / 20-03-2011 / 21:33:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

swap
    self 
        writeInstructionWithArgs: (self prettyPrintByte: self fetchByte)
        stackBefore: self valueMarked , self sep , self valueMarked2
            after: self valueMarked2 , self sep , self valueMarked.

    "Modified: / 20-03-2011 / 21:33:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

tableswtch
    self 
        writeInstructionWithArgs: (self prettyPrintTableSwitchMadness)
        stackBefore: self index
            after: self whatever.

    "Modified: / 20-03-2011 / 21:34:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

wide
    wide := true.
     self 
        writeInstructionWithArgs: self nothing
        stackBefore: self whatever
             after: self whatever.

    "Modified: / 20-03-2011 / 21:48:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeDisassembler methodsFor:'processing loop'!

handleAbstractMethod
^nil.

    "Created: / 22-03-2011 / 14:51:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

initializeContextVars
    1 to: numVars
        do: [:idx | context at: (numArgs + idx) put: 'Var ' , idx printString. ]

    "Modified: / 21-03-2011 / 15:28:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

switch: opcode

    | lno |
    "bytecode positions in line number table starts with 0, not 1"
    lno := method lineNumberForPC0: instrPointer - 1.
    lastLno ~~ lno ifTrue:[self writeLine: (lastLno := lno)].
    ^super switch: opcode

    "Created: / 22-03-2011 / 20:57:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-09-2013 / 03:22:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeDisassembler class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaByteCodeDisassembler.st,v 1.10 2015-05-07 21:35:59 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: JavaByteCodeDisassembler.st,v 1.10 2015-05-07 21:35:59 cg Exp $'
! !


JavaByteCodeDisassembler initialize!
