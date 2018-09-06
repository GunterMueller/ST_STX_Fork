"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1991 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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

ByteCodeCompiler subclass:#Decompiler
	instanceVariableNames:'hasLineNo bytes literals index listStream outputStream'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!Decompiler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    only for stx-debugging. Not for public eyes.

    Decompiler decompile:(someClass compiledMethodAt:#someSelector)
"
! !

!Decompiler class methodsFor:'decompiling'!

decompile:aMethod
    ^ self decompile:aMethod to:Transcript

    "
     Decompiler decompile:(FileBrowser compiledMethodAt:#initialize)
     Decompiler decompile:(Decompiler compiledMethodAt:#decompile:to:)
    "

    "Modified: / 06-08-2006 / 15:31:39 / cg"
!

decompile:aMethod to:aStream
    ^ (self new) decompile:aMethod to:aStream

    "Decompiler decompile:(FileBrowser compiledMethodAt:#initialize)"

    "Created: 16.4.1996 / 20:25:55 / cg"
! !

!Decompiler methodsFor:'decompiling'!

decompile:aMethod to:aStream
    |nBytes byte sym sel lineNr who method insnIndex1 insnIndex2 n nCol|

    nCol := 7.    
    listStream := nil.
    outputStream := aStream.

    (method := aMethod) isNil ifTrue:[
        aStream showCR:'nil method'.
        ^ self
    ].   
    method := method originalMethodIfWrapped.

    aStream cr.
    aStream show:'decompiling '.

    method isMethod ifTrue:[
        who := method who.
        who notNil ifTrue:[
            classToCompileFor := who at:1.
            aStream showCR:(classToCompileFor name , '>>' , (who at:2)).
        ]
    ].
    aStream show:('nA: ' , method numArgs printString).
    aStream show:(' nV: ' , method numVars printString).
    aStream show:(' nT: ' , method stackSize printString).
    aStream cr.
    aStream cr.

    bytes := method byteCode.
    bytes isNil ifTrue:[
        method isLazyMethod ifTrue:[
            method := method asExecutableMethod.
            bytes := method byteCode.
            aStream showCR:'(lazyMethod; showing resulting code when compiled on first invokation)'.
            aStream cr.
        ].
    ].
    bytes isNil ifTrue:[
        aStream showCR:'no bytecode'.
        ^ self
    ].
    literals := method literals.
    index := 1.
    nBytes := bytes size.
    [index <= nBytes] whileTrue:[
        listStream := '' writeStream.

        self showPC.
        insnIndex1 := index.

        sym := self symbolicCodeFor:(bytes at:index).
        listStream show:sym.
"
        extra notNil ifTrue:[Transcript show:(extra printString)].
"
        index := index + 1.
        hasLineNo ifTrue:[
            lineNr := bytes at:index.
            index := index + 1.
            sym == #LINE16 ifTrue:[
                lineNr := (lineNr << 8) + (bytes at:index).
                index := index + 1.

            ].
        ] ifFalse:[
            lineNr := nil
        ].
        extra notNil ifTrue:[
            listStream show:' '.
            byte := bytes at:index.

            "compute argument showXXX selector from extra ..."

            sel := 'show' , extra , ':'.
            sel at:5 put:(sel at:5) asUppercase.
            self perform:sel asSymbol with:byte
        ].
        insnIndex2 := index-1.

        insnIndex1 to:insnIndex2 do:[:i |
            outputStream show:((bytes at:i) hexPrintString:2).
            outputStream show:' '.
        ].
        n := (insnIndex2-insnIndex1) * 3.
        outputStream spaces:(nCol*3 - n).
        outputStream show:(listStream contents).

        lineNr notNil ifTrue:[
            aStream show:' ['; show:lineNr; show:']'
        ].
        aStream showCR:''
    ]

    "Created: / 16-04-1996 / 20:27:18 / cg"
    "Modified: / 22-10-2010 / 11:48:15 / cg"
    "Modified: / 12-04-2013 / 01:35:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showAbsOffset:byte
    |offs b2|

    index := index + 1.
    b2 := (bytes at:index).
    offs := byte + (b2 bitShift:8).
    index := index + 1.
    listStream show:offs printString.
    listStream show:' ('.
    listStream show:offs printString.
    listStream show:')'

    "Modified: 16.4.1996 / 20:27:53 / cg"
!

showAbsOffsetLevel:byte
    |offs b2|

    index := index + 1.
    b2 := (bytes at:index).
    offs := byte + (b2 bitShift:8).
    index := index + 1.
    listStream show:offs printString.
    listStream show:' ('.
    listStream show:offs printString.
    listStream show:')'.
    self showNvarNargsAt:index.
    index := index + 2

    "Modified: 16.4.1996 / 20:27:57 / cg"
!

showExtraOp:op
    "/ listStream show:(op printString); show:' '.

    index := index + 1.
    op == 0 ifTrue:[
        listStream show:'SEND_VL '.
        self showLineNo:(bytes at:index).
        listStream show:' nargs:' , (bytes at:index) printString; show:' '.
        index := index + 1.
        self showLiteral32:0.
        ^ self.
    ].
    op == 1 ifTrue:[
        listStream show:'SUPERSEND_VL '.
        self showLineNo:(bytes at:index).
        listStream show:' nargs:' , (bytes at:index) printString; show:' '.
        index := index + 1.
        self showLiteral32:0.
        self showLiteral32:0.
        ^ self.
    ].
    op == 2 ifTrue:[
        listStream show:'PUSH_VL_LIT '.
        self showLiteral32:0.
        ^ self.
    ].
    self shouldImplement.
    op == 3 ifTrue:[
    ].
    op == 4 ifTrue:[
    ].
!

showIndex:byte
    listStream show:byte printString.
    index := index + 1

    "Modified: 16.4.1996 / 20:27:59 / cg"
!

showIndexLevel:byte
    self showIndex:byte.
    self showNvarNargsAt:index.
    index := index + 2
!

showInstvarIndex:byte
    listStream show:byte printString.
    classToCompileFor notNil ifTrue:[
        listStream show:'('.
        listStream show:(classToCompileFor allInstVarNames at:byte ifAbsent:'???? [' , byte printString ,']').
        listStream show:')'.
    ].
    index := index + 1

    "Modified: 16.4.1996 / 20:28:06 / cg"
!

showLevelIndex:byte
    |lvl idx|

    lvl := byte.
    index := index + 1.
    idx := bytes at:index.

    listStream show:idx printString.
    index := index + 1.

    listStream show:' lvl: '; show:lvl printString.
!

showLineNo:byte
    listStream show:' line:' , byte printString.
    index := index + 1

    "Modified: 16.4.1996 / 20:28:10 / cg"
!

showLit1:ignored
    self showLit:1
!

showLit2:ignored
    self showLit:2
!

showLit3:ignored
    self showLit:3
!

showLit4:ignored
    self showLit:4
!

showLit5:ignored
    self showLit:5
!

showLit6:ignored
    self showLit:6
!

showLit7:ignored
    self showLit:7
!

showLit8:ignored
    self showLit:8
!

showLit9:ignored
    self showLit:9
!

showLit:litIndex
    |lit|

    lit := literals at:litIndex ifAbsent:'*** badIndex ***'.
    lit isBehavior ifTrue:[
        listStream show:lit name
    ] ifFalse:[
        lit isBlock ifTrue:[
            listStream show:'[a block]'
        ] ifFalse:[
            (lit isNumber or:[lit isString or:[lit isSymbol]]) ifTrue:[
                listStream show:lit storeString
            ] ifFalse:[
                listStream show:'{', lit printString , '}'
            ]
        ]
    ]

    "Modified: / 08-08-2006 / 00:45:46 / cg"
!

showLiteral16:byte
    |litIndex|

    litIndex := bytes unsignedInt16At:index MSB:false.
    listStream show:litIndex printString; space.
    self showLit:litIndex.
    index := index + 2
!

showLiteral32:byte
    |litIndex|

    litIndex := bytes unsignedInt32At:index MSB:false.
    listStream show:litIndex printString; space.
    self showLit:litIndex.
    index := index + 4
!

showLiteral:byte
    index := index + 1.
    listStream show:byte printString; space.
    self showLit:byte
!

showLiteralAt:index
    |offs|

    offs := bytes at:index.
    self showLit:offs
!

showLongOffset:byte
    |offs|

    index := index + 1.
    (byte > 127) ifTrue:[
        offs := byte - 256 - 128
    ] ifFalse:[
        offs := byte + 128
    ].
    listStream show:offs printString.
    listStream show:' ('.
    listStream show:(index + offs) printString.
    listStream show:')'

    "Modified: 16.4.1996 / 20:28:30 / cg"
!

showLongOffsetLevel:byte
    self showLongOffset:byte.
    self showNvarNargsAt:index.
    index := index + 2
!

showLsendArgs:byte
    |litIndex|

    listStream show:byte printString.
    listStream show:' '.
    index := index + 1.
    litIndex := bytes unsignedInt16At:index MSB:false.
    listStream show:(literals at:litIndex) printString.
    index := index + 2

    "Modified: 16.4.1996 / 20:28:35 / cg"
!

showLsuperSendArgs:byte
    |litIndex|

    listStream show:byte printString.
    listStream show:' '.
    index := index + 1.
    litIndex := bytes unsignedInt16At:index MSB:false.
    listStream show:(literals at:litIndex) printString.
    index := index + 2.

    litIndex := bytes unsignedInt16At:index MSB:false.
    listStream show:(literals at:litIndex) printString.
    index := index + 2
!

showNumber16:byte
    listStream show:(bytes signedInt16At:index MSB:false) printString.
    index := index + 2

    "Modified: 16.4.1996 / 20:28:37 / cg"
!

showNumber:byte
    listStream show:byte signExtendedByteValue printString.
    index := index + 1

    "Modified: 16.4.1996 / 20:28:38 / cg"
!

showNvarNargsAt:index
    listStream show:' nv='.
    listStream show:(bytes at:index) printString.
    listStream show:' na='.
    listStream show:(bytes at:(index + 1)) printString

    "Modified: 16.4.1996 / 20:28:40 / cg"
!

showOffset:byte
    |offs|

    index := index + 1.
    (byte > 127) ifTrue:[
        offs := byte - 256
    ] ifFalse:[
        offs := byte
    ].
    listStream show:(offs printString).
    listStream show:' ('.
    listStream show:(index + offs) printString.
    listStream show:')'

    "Modified: 16.4.1996 / 20:28:43 / cg"
!

showOffsetLevel:byte
    self showOffset:byte.
    self showNvarNargsAt:index.
    index := index + 2
!

showPC
    outputStream show:(index printStringRadix:10 size:3 fill:(Character space)).
    outputStream show:': '.

    "Modified: 4.6.1997 / 12:07:33 / cg"
!

showSendArgs:byte
    listStream show:byte printString.
    listStream show:' '.
    index := index + 1.
    self showLiteralAt:index.
    index := index + 1

    "Modified: 16.4.1996 / 20:28:50 / cg"
!

showSpecialGlobal:byte
    |specialIndex|

    specialIndex := bytes at:index.
    index := index + 1.
"/    listStream show:specialIndex printString.

    listStream 
        show:((self specialGlobals) at:specialIndex + 1)

    "Modified: 4.6.1997 / 12:18:45 / cg"
!

showSpecialSend:byte
    |specialIndex|

    specialIndex := bytes at:index.
    index := index + 1.
"/    listStream show:specialIndex printString.
    listStream show:'#'.
    listStream show:((self specialSends) at:specialIndex + 1)

    "Modified: 4.6.1997 / 12:34:01 / cg"
!

showSuperSendArgs:byte
    listStream show:byte printString.
    listStream show:' '.
    index := index + 1.
    self showLiteralAt:index.
    index := index + 1.
    listStream show:' '.
    self showLiteralAt:index.
    index := index + 1

    "Modified: 16.4.1996 / 20:28:58 / cg"
!

showUnsigned16:byte
    listStream show:(bytes wordAt:index MSB:false) printString.
    index := index + 2

    "Created: / 17-08-2015 / 14:51:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showUnsigned32:byte
    listStream show:(bytes doubleWordAt:index MSB:false) printString.
    index := index + 2

    "Created: / 17-08-2015 / 14:53:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showVeryLongOffset:byte
    |offs|

    index := index + 1.
    (byte > 127) ifTrue:[
        offs := byte - 256 - 256
    ] ifFalse:[
        offs := byte + 256
    ].
    listStream show:offs printString.
    listStream show:' ('.
    listStream show:(index + offs) printString.
    listStream show:')'

    "Modified: 16.4.1996 / 20:29:00 / cg"
!

showVeryLongOffsetLevel:byte
    self showVeryLongOffset:byte.
    self showNvarNargsAt:index.
    index := index + 2
!

symbolicCodeFor:aByte
    |syms extras lnos sym|

    syms := #(  retTop         " 0  "
                retNil
                retTrue
                retFalse
                ret0
                retSelf         " 5  "
                over
                homeRetTop
                LINE
                LINE16
                pushNil         " 10 "
                pushTrue
                pushFalse
                sendSelf
                pushLit
                pushSelf        " 15 "
                pushNum
                pushNum16
                drop
                send
                superSend       " 20 "
                send0
                send1
                send2
                send3
                sendDrop        " 25 "
                sendDrop0
                sendDrop1
                sendDrop2
                sendDrop3
                pushMethodArg   " 30 "
                pushMethodVar
                pushBlockArg
                pushBlockVar
                pushInstVar
                pushClassVar    " 35 "
                pushGlobal
                storeMethodVar
                storeBlockVar
                storeInstVar
                storeClassVar   " 40 "
                storeGlobal  
                pushOuterBlockArg
                pushOuter1BlockArg
                pushOuter2BlockArg
                equal           " 45 "
                notEqual
                dup
                equal0
                notEqual0
                falseJump       " 50 "
                trueJump
                nilJump
                notNilJump
                jump
                makeBlock       " 55 "
                zeroJump
                notZeroJump
                eqJump
                notEqJump
                falseJump       " 60 "
                trueJump
                nilJump
                notNilJump
                jump
                makeBlock       " 65 "
                zeroJump
                notZeroJump
                eqJump
                notEqJump
                falseJump       " 70 "
                trueJump
                nilJump
                notNilJump
                jump
                makeBlock       " 75 "
                zeroJump
                notZeroJump
                eqJump
                notEqJump
                pushMethodVar1  " 80 "
                pushMethodVar2
                pushMethodVar3
                pushMethodVar4
                pushMethodVar5
                pushMethodVar6  " 85 "
                pushMethodArg1
                pushMethodArg2
                pushMethodArg3
                pushMethodArg4
                pushInstVar1    " 90 "
                pushInstVar2
                pushInstVar3
                pushInstVar4
                pushInstVar5
                pushInstVar6    " 95 "
                pushInstVar7
                pushInstVar8
                pushInstVar9
                pushInstVar10
                storeMethodVar1 " 100 "
                storeMethodVar2
                storeMethodVar3
                storeMethodVar4
                storeMethodVar5
                storeMethodVar6 " 105 "
                nil
                nil
                nil
                nil
                storeInstVar1   " 110 "
                storeInstVar2
                storeInstVar3
                storeInstVar4
                storeInstVar5
                storeInstVar6  " 115 "
                storeInstVar7
                storeInstVar8
                storeInstVar9
                storeInstVar10
                push0           " 120 "
                push1
                pushMinus1
                sendPlus1
                sendMinus1
                incMethodVar    " 125 "
                decMethodVar
                retNum
                pushOuterBlockVar       "16r80"
                storeOuterBlockVar
                'send1 #='            " 130 "
                'send1 #+'
                'send1 #~='
                'send1 #-'
                'send0 #class'
                'send1 #at:'          " 135 "
                'send2 #at:put:'
                'send1 #bitAnd:'
                'send1 #bitOr:'
                push2
                pushBlockArg1   " 140 "
                pushBlockArg2
                pushBlockArg3
                pushBlockArg4
                pushContext             "16r90"
                'send1 #>'          " 145 "
                'send1 #>='
                'send1 #<'
                'send1 #<='
                nil
                nil             " 150 "
                'send0 #value'
                'send1 #value:'
                'send0 #size'
                nil
                nil             " 155 "
                make0Block             
                makeNILBlock
                nil             " 158 "
                nil             " 159 "
                retMvar1        " 160 " "16rA0"
                retMvar2        
                retMvar3        
                retMvar4        
                retMvar5        
                retMvar6        " 165 "
                retIvar1        
                retIvar2        
                retIvar3        
                retIvar4        
                retIvar5        " 170 "
                retIvar6        
                retIvar7        
                retIvar8        
                retMarg1        
                retMarg2        " 175 "
                pushClassInstVar
                storeClassInstVar
                'send2 #value:value:'
                not
                sendSelf0       " 180 "
                sendSelf1
                sendSelf2
                sendSelf3
                sendSelfDrop0   
                sendSelfDrop1   " 185 "
                sendSelfDrop2
                sendSelfDrop3
                isNil
                notNil
                falseJumpAbs    " 190 "
                trueJumpAbs     
                nilJumpAbs     
                notNilJumpAbs   
                jumpAbs        
                makeBlockAbs    " 195 "
                zeroJumpAbs
                notZeroJumpAbs
                eqJumpAbs
                notEqJumpAbs    " 199 "
                pushGlobal      " 200 "
                pushLLit
                jmpFalseL
                jmpTrueL
                vl_op
                lsend           "   205 " 
                lsuperSend
                lsendSelf         
                pushGT0
                nil
                sendArrayNew    "   210 " 
                'send0 #basicNew'      
                sendGT0
                'send0 #new'
                sendBasicNewN
                sendNewN        "   215 " 
                sendLogAnd
                sendLogOr
                pushGlobL
                storeGlobL
                nil              "  220 " 
                nil                  
                pushLit1             
                pushLit2              
                pushLit3             
                pushLit4             
                pushLit5             
                pushLit6             
                pushLit7            
                pushLit8            
                'send1 #*'          "   230 "
                sendSpecial      "   231 "
                pushBlockVar1
                pushBlockVar2
                pushBlockVar3
                storeBlockVar1
                storeBlockVar2
                storeBlockVar3
                refCheck
                pushMethodLocal
                storeMethodLocal      " 240 "
                storeBlockLocal       " 241 "
                storeOuterBlockLocal  " 242 "
                swap                  " 243 "
                SOURCEPOS8            " 244 "
                SOURCEPOS16           " 245 "
                SOURCEPOS32           " 246 "
              ).

    lnos := #(  false          " 0  "
                false   
                false   
                false   
                false
                false          " 5  "
                false
                false
                true
                true
                false          " 10 "
                false
                false
                true
                false
                false          " 15 "
                false
                false
                false
                true
                true           " 20 "
                true 
                true 
                true 
                true 
                true           " 25 "
                true 
                true 
                true 
                true 
                false          " 30 "
                false
                false
                false
                false
                false          " 35 "
                false
                false
                false
                false
                false           " 40 "
                false
                false
                false
                false
                false           " 45 "
                false
                false
                false
                false
                false       " 50 "
                false
                false
                false
                false
                false       " 55 "
                false
                false
                false
                false
                false       " 60 "
                false
                false
                false
                false
                false       " 65 "
                false
                false
                false
                false
                false       " 70 "
                false
                false
                false
                false
                false       " 75 "
                false
                false
                false
                false 
                false  " 80 "
                false
                false
                false
                false
                false  " 85 "
                false
                false
                false
                false
                false    " 90 "
                false
                false
                false
                false
                false    " 95 "
                false
                false
                false
                false
                false " 100 "
                false
                false
                false
                false
                false " 105 "
                true
                true
                true
                true
                false   " 110 "
                false
                false
                false
                false
                false  " 115 "
                false
                false
                false
                false
                false           " 120 "
                false
                false
                true
                true
                true    " 125 "
                true
                false
                false              "/ 128 pushOuterBlockVar
                false
                true          " 130 "
                true
                true
                true
                false
                true          " 135 "
                true
                true
                true
                false
                false   " 140 "
                false
                false
                false
                false
                true          " 145 "
                true
                true
                true
                true
                true        " 150 "
                true
                true
                true
                true
                true             " 155 "
                false
                false
                true
                true
                false        " 160 "
                false
                false
                false
                false
                false        " 165 "
                false
                false
                false
                false
                false        " 170 "
                false
                false
                false
                false
                false        " 175 "
                false
                false
                true
                true
                true         " 180 "
                true
                true
                true
                true
                true         " 185 "
                true
                true
                false
                false
                false         " 190 "
                false
                false
                false
                false
                false         " 195 "
                false
                false
                false
                false         " 199 "
                false         " 200 "
                false
                false
                false
                false
                true            " 205 " 
                true
                true
                true
                false
                false           " 210 "      " arrayNew "
                true                         " basicNew "
                true                         " > 0 "
                true                         " new "
                true                         " basicNew: "
                true            " 215 "      " new: "
                true
                true
                false
                false
                false           " 220 " 
                false
                false
                false
                false
                false           " 225 " 
                false
                false
                false
                false           " 229 " 
                true            " 230 "
                true            " 231 "
                false
                false
                false
                false
                false
                false
                false
                false
                false           " 240 "
                false           " 241 "
                false           " 242 "
                false           " 243 "
                false           " 244 "
                false           " 245 "
                false           " 246 "
              ).

    extras := #(nil             " 0  "
                nil
                nil
                nil
                nil
                nil             " 5  "
                nil
                nil
                nil
                nil
                nil             " 10 "
                nil
                nil
                sendArgs
                literal
                nil             " 15 "
                number
                number16
                nil
                sendArgs
                superSendArgs   " 20 "
                literal
                literal
                literal
                literal
                sendArgs        " 25 "
                literal
                literal
                literal
                literal
                index           " 30 "
                index
                index
                index
                instvarIndex
                literal         " 35 "
                literal
                index
                index
                instvarIndex
                literal         " 40 "
                literal     
                levelIndex
                index
                index
                nil             " 45 "
                nil
                nil
                nil
                nil
                offset          " 50 "
                offset
                offset
                offset
                offset
                offsetLevel     " 55 "
                offset
                offset
                offset
                offset
                longOffset      " 60 "
                longOffset
                longOffset
                longOffset
                longOffset
                longOffsetLevel " 65 "
                longOffset
                longOffset
                longOffset
                longOffset
                veryLongOffset  " 70 "
                veryLongOffset
                veryLongOffset
                veryLongOffset
                veryLongOffset
                veryLongOffsetLevel  " 75 "
                veryLongOffset
                veryLongOffset
                veryLongOffset
                veryLongOffset
                nil             " 80 "
                nil
                nil
                nil
                nil
                nil             " 85 "
                nil
                nil
                nil
                nil
                nil             " 90 "
                nil
                nil
                nil
                nil
                nil             " 95 "
                nil
                nil
                nil
                nil
                nil             " 100 "
                nil
                nil
                nil
                nil
                nil             " 105 "
                nil
                nil
                nil
                nil
                nil             " 110 "
                nil
                nil
                nil
                nil
                nil             " 115 "
                nil
                nil
                nil
                nil
                nil             " 120 "
                nil
                nil
                nil
                nil
                index           " 125 "
                index
                number
                levelIndex      "/ 128 pushOuterBlockVar
                levelIndex
                nil             " 130 "
                nil
                nil
                nil
                nil
                nil             " 135 "
                nil
                nil
                nil
                nil
                nil             " 140 "
                nil
                nil
                nil
                nil
                nil             " 145 "
                nil
                nil
                nil
                nil
                nil             " 150 "
                nil
                nil
                nil
                nil
                nil             " 155 "
                nil
                nil
                nil
                nil
                nil             " 160 "
                nil
                nil
                nil
                nil
                nil             " 165 "
                nil
                nil
                nil
                nil
                nil             " 170 "
                nil
                nil
                nil
                nil
                nil             " 175 "
                index
                index
                nil
                nil
                literal         " 180 "
                literal
                literal
                literal
                literal         
                literal         " 185 "
                literal
                literal
                nil
                nil
                absOffset       " 190 "
                absOffset
                absOffset
                absOffset
                absOffset
                absOffsetLevel  " 195 "
                absOffset
                absOffset
                absOffset
                absOffset       " 199 "
                specialGlobal   " 200 "
                literal16
                nil
                nil
                extraOp
                lsendArgs       " 205 "
                lsuperSendArgs
                lsendArgs
                nil
                nil
                nil             " 210 "
                nil
                nil
                nil
                nil
                nil             " 215 "
                nil
                nil
                literal16        
                literal16     
                nil             " 220 "
                nil
                lit1
                lit2
                lit3
                lit4            " 225 "
                lit5
                lit6
                lit7
                lit8
                nil             " 230 "
                specialSend     " 231 "
                nil
                nil
                nil
                nil
                nil
                nil
                nil
                index
                index           " 240 "
                index           " 241 "
                levelIndex      " 242 "
                nil             " 243 "
                index           " 244 "
                unsigned16      " 245 "
                unsigned32      " 246 "
             ).

    sym := syms at:(aByte + 1).
    sym isNil ifTrue:[
        extra := nil.
        hasLineNo := nil.
    ] ifFalse:[
        extra := extras at:(aByte + 1).
        hasLineNo := lnos at:(aByte + 1).
    ].
    ^ sym.

    "Modified: / 02-09-1995 / 00:12:11 / claus"
    "Modified: / 25-10-2011 / 21:58:24 / cg"
    "Modified: / 31-05-2015 / 04:05:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Decompiler class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

