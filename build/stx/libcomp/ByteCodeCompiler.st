"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

Parser subclass:#ByteCodeCompiler
	instanceVariableNames:'codeBytes codeIndex litArray stackDelta extra lineno extraLiteral
		maxStackDepth relocList methodTempVars numTemp maxNumTemp
		methodClass extraOP allLiterals allIdenticalLiterals
		breakpointedLines currentLineNumber'
	classVariableNames:'JumpToAbsJump ShareCode ListCompiledMethods NewCodeSet
		NewPrimitives'
	poolDictionaries:''
	category:'System-Compiler'
!

!ByteCodeCompiler class methodsFor:'documentation'!

byteCode
"
    TOS   - top of stack
    NOS   - next on stack
    uu    - byte-valued unsigned (0..16rFF)
    uuuu  - twoByte-valued unsigned (0..16rFFFF); msb-first
    ll    - byte-valued literal index (0..16rFF)
    nn    - byte-valued signed (-128..+127)
    nnnn  - twoByte-valued signed (16r-8000 .. 16r7FFF)

    Notes:
        - bytecode optimized for space, not interpreter speed,
          since JITTER is assumed to be present and compensate for decoding
          overhead.
        - number assignments due to backward compatible extensions of the
          bytecode set - reassignment & cleanup would be nice.
        - codes marked with (*) make the minimal set; all others duplicate
          the functionality of a minimalSet code, but provides dense encoding

    definition of ST/X byteCode:

    *   00          RET_TOP         return TOS from current context
        01          RET_NIL         return nil from current context
        02          RET_TRUE        return true from current context
        03          RET_FALSE       return false from current context
        04          RET_0           return 0 (zero) from current context
        05          RET_SELF        return the current receiver from current context
    *   06          DUP_OVER        push NOS (used with inlined loops)
    *   07          HOME_RET_TOP    return TOS from home context (method return from block)
        08 uu       LINENO          line number information dummy
    *   09 uuuu     LINENO16        line number information dummy
        0A          PUSH_NIL        push nil onto stack
        0B          PUSH_TRUE       push true onto stack
        0C          PUSH_FALSE      push false onto stack
        0D          SEND_SELF       self-send
    *   0E ll       PUSH_LIT        push a literal
        0F          PUSH_SELF       push the current receiver onto stack
        10 nn       PUSH_NUM        push a byte-valued smallInteger onto stack
        11 nnnn     PUSH_NUM16      push a twoByte-valued smallInteger onto stack
    *   12          DROP            pop & forget
    *   13          SEND            send
    *   14          SUPER_SEND      super-send (actually: directed send)
        15          SEND0           send 0-arg message
        16          SEND1           send 1-arg message
        17          SEND2           send 2-arg message
        18          SEND3           send 3-arg message
        19          SEND_DROP       send & forget result
        1A          SEND0_DROP      send 0-arg message & forget result
        1B          SEND1_DROP      send 1-arg message & forget result
        1C          SEND2_DROP      send 2-arg message & forget result
        1D          SEND3_DROP      send 3-arg message & forget result
    *   1E          PUSH_MARG       push method arg
    *   1F          PUSH_MVAR       push method variable
    *   20          PUSH_BARG       push block arg
    *   21          PUSH_BVAR       push block variable
    *   22          PUSH_IVAR       push instance variable
        23          PUSH_CVAR       -- obsolete -- no longer used.
    *   24          PUSH_GLOB       push global
    *   25          STORE_MVAR      pop and store into method variable
    *   26          STORE_BVAR      pop and store into block variable
    *   27          STORE_IVAR      pop and store into instance variable
        28          STORE_CVAR      -- obsolete -- no longer used.
    *   29          STORE_GLOB      pop and store into global
    *   2A          PUSH_OBARG      push outer block arg (n levels)
        2B          PUSH_OBARG1     push outer block arg (1 level)
        2C          PUSH_OBARG2     push outer block arg (2 levels)
        2D          EQEQ            == -> pop a,b; push a==b
        2E          NENE            ~~ -> pop a,b; push a~~b
    *   2F          DUP             duplicate TOS
        30          EQEQ0           ==0 -> pop a; push a==0
        31          NENE0           ~~0 -> pop a; push a~~0

        32          JMP_FALSE       pop; branch if false
        33          JMP_TRUE        pop; branch if true
        34          JMP_NIL         pop; branch if nil
        35          JMP_NOTNIL      pop; branch if not nil
        36          JMP             branch always
        37          MAKE_BLOCK      make a block
        38          JMP_ZERO        pop; branch if ==0
        39          JMP_NOTZERO     pop; branch if ~~0
        3A          JMP_EQEQ        pop a,b; branch if a==b
        3B          JMP_NENE        pop a,b; branch if a~~b

        3C          JMPL_FALSE      like above, extended branch delta, (add +128/-128 to offs)
        ...          ...
        45          JMPL_NENE       like above, extended branch delta, (add +128/-128 to offs)

        46          JMPVL_FALSE     like above, extended branch delta, (add +256/-256 to offs)
        ...          ...
        4F          JMPVL_NENE      like above, extended branch delta, (add +256/-256 to offs)

        50          PUSH_MVAR1      push method variable 1 (first variable)
        51          PUSH_MVAR2      push method variable 2
        52          PUSH_MVAR3      push method variable 3
        53          PUSH_MVAR4      push method variable 4
        54          PUSH_MVAR5      push method variable 5
        55          PUSH_MVAR6      push method variable 6

        56          PUSH_MARG1      push method arg 1
        57          PUSH_MARG2      push method arg 2
        58          PUSH_MARG3      push method arg 3
        59          PUSH_MARG4      push method arg 4

        5A          PUSH_IVAR1      push inst variable 1 (first variable)
        5B          PUSH_IVAR2      push inst variable 2
        5C          PUSH_IVAR3      push inst variable 3
        5D          PUSH_IVAR4      push inst variable 4
        5E          PUSH_IVAR5      push inst variable 5
        5F          PUSH_IVAR6      push inst variable 6
        60          PUSH_IVAR7      push inst variable 7
        61          PUSH_IVAR8      push inst variable 8
        62          PUSH_IVAR9      push inst variable 9
        63          PUSH_IVAR10     push inst variable 10

        64          STORE_MVAR1     pop and store into method variable 1 (first variable)
        65          STORE_MVAR2     pop and store into method variable 2
        66          STORE_MVAR3     pop and store into method variable 3
        67          STORE_MVAR4     pop and store into method variable 4
        68          STORE_MVAR5     pop and store into method variable 5
        69          STORE_MVAR6     pop and store into method variable 6

        6A          unused
        6B          unused
        6C          unused
        6D          unused

        6E          STORE_IVAR1     pop and store into inst variable 1 (first variable)
        6F          STORE_IVAR2     pop and store into inst variable 2
        70          STORE_IVAR3     pop and store into inst variable 3
        71          STORE_IVAR4     pop and store into inst variable 4
        72          STORE_IVAR5     pop and store into inst variable 5
        73          STORE_IVAR6     pop and store into inst variable 6
        74          STORE_IVAR7     pop and store into inst variable 7
        75          STORE_IVAR8     pop and store into inst variable 8
        76          STORE_IVAR9     pop and store into inst variable 9
        77          STORE_IVAR10    pop and store into inst variable 10

        78          PUSH_0          push smallinteger 0 constant
        79          PUSH_1          push smallinteger 1 constant
        7A          PUSH_M1         push smallinteger -1 constant

        7B          SEND_PLUS1      send '+ 1' to TOS; replace TOS by result
        7C          SEND_MINUS1     send '- 1' to TOS; replace TOS by result
        7D          INC_MVAR        send '+ 1' to a method variable; store result into same mvar (for inlined loops)
        7E          DEC_MVAR        send '- 1' to a method variable; store result into same mvar (for inlined loops)
        7F nn       RET_NUM         return a smallInteger from current context
    *   80          PUSH_OBVAR      push outer block variable
    *   81          STORE_OBVAR     pop and store into outer block variable

        82          SEND_EQ         send #=
        83          SEND_PLUS       send #+
        84          SEND_NE         send #~=
        85          SEND_MINUS      send #-
        86          SEND_CLASS      send #class
        87          SEND_AT         send #at:
        88          SEND_ATPUT      send #at:put:
        89          SEND_BITAND     send #bitAnd:
        8A          SEND_BITOR      send #bitOr:

        8B          PUSH_2          push constant 2

        8C          PUSH_BARG1      push block argument 1
        8D          PUSH_BARG2
        8E          PUSH_BARG3
        8F          PUSH_BARG4

    *   90          PUSH_CONTEXT    push thisContext

        91          SEND_GT         send >
        92          SEND_GE         send >=
        93          SEND_LT         send <
        94          SEND_LE         send <=

        95          UNUSED_149      obsolete; was: send #next
        96          UNUSED_150      obsolete; was: send #peek
        97          SEND_VALUE      send #value
        98          SEND_VALUE1     send #value:
        99          SEND_SIZE       send #size
        9A          UNUSED_154
        9B          UNUSED_155

        9C          MK0BLOCK        make a 0-returning block
        9D          MKNILBLOCK      make a nil-returning block

        9E          UNUSED_158      obsolete; was: send #asInteger */
        9F          UNUSED_159      obsolete; was: send #rounded */

        A0          RET_MVAR1       return method variable 1 from current context
        A1          RET_MVAR2       return method variable 2 from current context
        A2          RET_MVAR3
        A3          RET_MVAR4
        A4          RET_MVAR5
        A5          RET_MVAR6       return method variable 6 from current context

        A6          RET_IVAR1       return instance variable 1 from current context
        A7          RET_IVAR2       return instance variable 2 from current context
        A8          RET_IVAR3
        A9          RET_IVAR4
        AA          RET_IVAR5
        AB          RET_IVAR6
        AC          RET_IVAR7
        AD          RET_IVAR8       return instance variable 8 from current context

        AE          RET_MARG1       return method arg 1 from current context
        AF          RET_MARG2       return method arg 1 from current context

        B0          PUSH_CIVAR      obsolete; push class instance variable
        B1          STORE_CIVAR     obsolete; store top of stack in class instance variable

        B2          SEND_VALUE2     send #value:value:
        B3          SEND_NOT        send #not

        B4          SEND_SELF0      send a 0-arg message to self
        B5          SEND_SELF1      send a 1-arg message to self
        B6          SEND_SELF2      send a 2-arg message to self
        B7          SEND_SELF3      send a 3-arg message to self

        B8          SEND_SELF_DROP0 send a 0-arg message to self forget result
        B9          SEND_SELF_DROP1 send a 1-arg message to self forget result
        BA          SEND_SELF_DROP2 send a 2-arg message to self forget result
        BB          SEND_SELF_DROP3 send a 3-arg message to self forget result

        BC          ISNIL           replace TOS by 'TOS isNil'
        BD          NOTNIL          replace TOS by 'TOS notNil'

        BE uuuu     JMPA_FALSE      jumps to absolute offset (2 byte hi-lo)
        BF uuuu     JMPA_TRUE
        C0 uuuu     JMPA_NIL
        C1 uuuu     JMPA_NOTNIL
        C2 uuuu     JMPA
        C3          MAKE_ABLOCK
        C4 uuuu     JMPA_ZERO
        C5 uuuu     JMPA_NOTZERO
        C6 uuuu     JMPA_EQ
        C7 uuuu     JMPA_NOTEQ

        C8 xx       PUSH_GSPECIAL   push a special global; xx specifies what:
           00        Array   (push 'Smalltalk at:#Array'; i.e. the Array class)
           01        String  (push 'Smalltalk at:#String'; i.e. the String class)
           02        FloatArray
           03        DoubleArray
           04        Point
           05        Symbol
           06        Smalltalk
           07        Processor
           08        SmallInteger
           09        Character
           0A        Float
           0B        Process
           0C        Set
           0D        IdentitySet
           0E        Dictionary
           0F        IdentityDictionary
           10        Semaphore
           11        OrderedCollection

        C9 uuuu     PUSH_LLIT       push a literal (2-byte literal-number)

        CA nn       JMP_FALSE_L     jump if top is false (+127 .. -128)
        CB nn       JMP_TRUE_L      jump if top is true

        CC          UNUSED_204
        CD          LSEND_MSG       send with 16 bit literal index */
        CE          LSUPERSEND_MSG  super send with 16 bit literal index */
        CF          LSEND_SELF      self-send send with 16 bit literal index */
        D0          PUSH_GT0        push 'TOS > 0'; leaves original TOS as NOS

        D1          UNUSED_209

        D2          SEND_ARRAY_NEW  use for new/basicNew; top is size (0 for Array new)
        D3          SEND_BASICNEW   top is class (receiver)
        D4          SEND_GT0        replace TOS by result of send 'TOS > 0'
        D5          SEND_NEW        top is class (receiver)
        D6          SEND_BASICNEWN  top is class (receiver) and arg
        D7          SEND_NEWN       top is class (receiver) and arg
        D8          SEND_LOGAND     send &
        D9          SEND_LOGOR      send |

        DA uuuu     PUSH_LGLOB      push global variable word index literal
        DB uuuu     STORE_LGLOB     store global with word index literal

        DC          UNUSED_220
        DE          UNUSED_221

        DF          PUSH_LIT1       push 1st literal
        E0          PUSH_LIT2       push 2nd literal
        E1          PUSH_LIT3       push literal 3
        E2          PUSH_LIT4       push literal 4
        E3          PUSH_LIT5       push literal 5
        E4          PUSH_LIT6       push literal 6
        E5          PUSH_LIT7       push literal 7
        E6          PUSH_LIT8       push literal 8

        E7          SEND_MUL        send #*
        E8 xx       SEND_SPECIAL    special send; as specified by xx:
           00         top           send #top
           01         bottom        send #bottom
           02         left          send #left
           03         right         send #right
           04         x             send #x
           05         y             send #y
           06         width         send #width
           07         height        send #height
           08         origin        send #origin
           09         extent        send #extent
           0A         asInteger     send #asInteger
           0B         rounded       send #rounded
           0C         next          send #next
           0D         peek          send #peek

        E9          PUSH_BVAR1      push block variable 1
        EA          PUSH_BVAR2      push block variable 2
        EB          PUSH_BVAR3      push block variable 3

        EC          STORE_BVAR1     store TOS in block variable 1 and drop
        ED          STORE_BVAR2     store TOS in block variable 2 and drop
        EE          STORE_BVAR3     store TOS in block variable 3 and drop

     *  EF          BLOCK_REF       internal - check if a block is referenced by TOS

        F0          PUSH_LVAR       push local variable 0..numArgs-1 for args; numArgs..numArgs+nLocal-1 for mVars
        F1          STORE_LVAR      store local variable 0..numArgs-1 for args; numArgs..numArgs+nLocal-1 for mVars
        F2          STORE_OUTBLOCK_LVAR store local variable in outer context 0..numArgs-1 for args; numArgs..numArgs+nLocal-1 for bVars
        F3          SWAP            swap TOS with NOS

        F4          SOURCEPOS8 uu   source position information (offset in source, dummy) 
        F5          SOURCEPOS16 uuuu  source position information (offset in source, dummy) 
        F6          SOURCEPOS32 uuuuuuuu source position information (offset in source, dummy) 
        F7          UNUSED_247
        F8          UNUSED_248
        F9          UNUSED_249
        FA          UNUSED_250
        FB          UNUSED_251
        FC          UNUSED_252
        FD          UNUSED_253
        FE          UNUSED_254
        FF          UNUSED_255

    [author:]
        Claus Gittinger

"
!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    This class performs compilation into ByteCodes.
    First, parsing is done using superclass methods,
    then the parse-tree is converted into an array of symbolic codes
    and a relocation table;
    these two are finally combined into a byteArray of the codes.

    (the intermediate step through symbolic codes is for debugging
     only - it may vanish in future releases)

    There are many dependencies to the run-time-system (especially the
    interpreter) in here - be careful when playing around ...

    [Instance variables:]

	codeBytes       <ByteArry>              bytecodes
	codeIndex       <SmallInteger>          next index to put into code array
	litArray        <OrderedCollection>     literals
	stackDelta      <SmallInteger>          return value of byteCodeFor:
	extra           <Symbol>                return value of byteCodeFor:
	lineno          <Boolean>               return value of byteCodeFor:
	extraLiteral    <Symbol>                return value of byteCodeFor:
	maxStackDepth   <SmallInteger>          stack need of method
	relocList       <Array>                 used temporary for relocation

    [Class variables:]

	JumpToAbsJump   <Dictionary>            internal table to map opcodes

	STCCompilationDefines                   passed to stc as command line arguments
	STCCompilationIncludes
	STCCompilationOptions
			<String>

	STCCompilation  <Symbol>                #always, #primitiveOnly or #never
						controls when stc compilation is wanted

	ShareCode       <Boolean>               reuse byteArrays for common (simple) code sequences
						This is normally a 'good' optimization,
						except if you plan to modify the byteCodes.

    [author:]
	Claus Gittinger

"
!

examples
"
    a GNU-Smalltalk method:                                                                    
                                                                        [exBegin]
    Compiler 
        compile:'bla
    <category: ''tests''>

    ^ 123
'
        forClass: Object
                                                                        [exEnd]
"
! !

!ByteCodeCompiler class methodsFor:'initialization'!

initialize
    Smalltalk vmMajorVersionNr >= 5 ifTrue:[
        NewCodeSet := true.
        NewPrimitives := true.
    ] ifFalse:[
        NewCodeSet := false.
        NewPrimitives := false.
    ].
    ShareCode := true.
    ListCompiledMethods := false.

    "Modified: / 15.11.2001 / 17:20:51 / cg"
!

newCodeSet
    ^ NewCodeSet

!

newCodeSet:aBoolean
    NewCodeSet := aBoolean.

    "
     ByteCodeCompiler newCodeSet:true
    "
!

newPrimitives
    ^ NewPrimitives

!

newPrimitives:aBoolean
    NewPrimitives := aBoolean.

    "
     ByteCodeCompiler newPrimitives:true
    "
! !

!ByteCodeCompiler class methodsFor:'instance creation'!

new

    "/ Pretty ugly hack. A caller to compiler may provide a set of breakpoints
    "/ that has to be injected to the code. However, since breakpoint injection
    "/ is actually done by a subclass or me, so we have to return this subclass here.
    "/ This subclass-to-tranform API is bit unfortunate.
    ^ self ~~ ByteCodeCompiler ifTrue:[ 
        super new.
    ] ifFalse:[ 
        | breakpoints |

        breakpoints := BreakpointQuery query.
        breakpoints notEmptyOrNil ifTrue:[ 
            ByteCodeCompilerWithBreakpointSupport new
                breakpoints: breakpoints;
                yourself.
        ] ifFalse:[ 
            super new.
        ].
    ].

    "Created: / 08-05-2014 / 11:01:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteCodeCompiler class methodsFor:'compiling methods'!

compile:methodText forClass:classToCompileFor
    "compile a source-string for a method in classToCompileFor.
     Returns the new method, #Error or nil."

    ^ self
        compile:methodText
        forClass:classToCompileFor
        inCategory:(self asYetUncategorizedMethodCategory)
        notifying:nil
        install:true
        skipIfSame:false
        silent:false
!

compile:aString forClass:aClass inCategory:cat
    "compile a source-string for a method in classToCompileFor.
     The method will get cat as category.
     Returns the new method, #Error or nil."

    ^ self
        compile:aString
        forClass:aClass
        inCategory:cat
        notifying:nil
        install:true
        skipIfSame:false
        silent:false
        foldConstants:true

    "Modified: / 30-09-2011 / 12:44:23 / cg"
!

compile:aString forClass:aClass inCategory:cat notifying:requestor
    "compile a source-string for a method in classToCompileFor.
     errors are forwarded to requestor.
     The method will get cat as category.
     Returns the new method, #Error or nil."

    ^ self
	compile:aString
	forClass:aClass
	inCategory:cat
	notifying:requestor
	install:true
	skipIfSame:false
	silent:false
!

compile:aString forClass:aClass inCategory:cat notifying:requestor install:install
    "compile a source-string for a method in classToCompileFor.
     The install-argument controls if the method is to be installed into the
     classes method-dictionary, or just to be compiled and a method object to be returned.
     Errors are forwarded to requestor. The method will get cat as category.
     Returns the new method, #Error or nil."

    ^ self
        compile:aString
        forClass:aClass
        inCategory:cat
        notifying:requestor
        install:install
        skipIfSame:false
        silent:false

!

compile:aString forClass:aClass inCategory:cat notifying:requestor
		 install:install skipIfSame:skipIfSame
    "compile a source-string for a method in classToCompileFor.
     The install-argument controls if the method is to be installed into the
     classes method-dictionary, or just to be compiled and a method object to be returned.
     Errors are forwarded to requestor. The method will get cat as category.
     If skipIsSame is true, and the source is the same as an existing
     methods source, this is a noop (for fast fileIn).
     Returns the new method, #Error or nil."

    ^ self
	compile:aString
	forClass:aClass
	inCategory:cat
	notifying:requestor
	install:install
	skipIfSame:skipIfSame
	silent:false
!

compile:aString forClass:aClass inCategory:cat notifying:requestor
                 install:install skipIfSame:skipIfSame silent:silent
    "compile a source-string for a method in aClass.
     errors are forwarded to requestor.
     The method will get cat as category.
     if install is true, the method is installed in the class.
     if skipIfSame, the method is not installed if there is no change
     (used when filing in).
     if silent is true, no warnings are output.
     Returns the new method, #Error or nil."

    ^ self
        compile:aString
        forClass:aClass
        inCategory:cat
        notifying:requestor
        install:install
        skipIfSame:skipIfSame
        silent:silent
        foldConstants:true
!

compile:aStringArg forClass:aClassArg inCategory:cat notifying:requestor
                 install:install skipIfSame:skipIfSame silent:silent foldConstants:fold

    "the basic workhorse method for compiling:
     compile a source-string for a method in classToCompileFor.
     errors are forwarded to requestor
     (report on Transcript and return #Error, if requestor is nil).

     The new method will get cat as category.
     If install is true, the method will go into the classes method-table,
     otherwise the method is simply returned (for anonymous methods).
     If skipIsSame is true, and the source is the same as an existing
     methods source, this is a noop (for fast fileIn).
     The argument, silent controls if errors are to be reported.
     Returns the method, #Error or nil."

    ^ self new
        compile:aStringArg 
        forClass:aClassArg 
        inCategory:cat 
        notifying:requestor
        install:install 
        skipIfSame:skipIfSame 
        silent:silent 
        foldConstants:fold
!

compile:methodText forClass:classToCompileFor install:doInstall
    "compile a source-string for a method in classToCompileFor.
     The install-argument controls if the method is to be installed into the
     classes method-dictionary, or just to be compiled and a method object to be returned.
     Returns the new method, #Error or nil."

    ^ self
        compile:methodText
        forClass:classToCompileFor
        inCategory:(self defaultMethodCategory)
        notifying:nil
        install:doInstall
        skipIfSame:false
        silent:false
!

compile:methodText forClass:classToCompileFor notifying:requestor
    "compile a source-string for a method in classToCompileFor.
     Errors are forwarded to requestor.
     Returns the new method, #Error or nil."

    ^ self
        compile:methodText
        forClass:classToCompileFor
        inCategory:(self defaultMethodCategory)
        notifying:requestor
        install:true
        skipIfSame:false
        silent:false
!

compile:textOrStream in:aClass notifying:requestor ifFail:exceptionBlock
    "name alias for ST-80 compatibility.
     Returns the new method, or the value from exceptionBlock."

    ^ self new 
        compile:textOrStream 
        in:aClass 
        notifying:requestor 
        ifFail:exceptionBlock
!

compile:textOrStream in:aClass notifying:requestor install:install ifFail:exceptionBlock
    "name alias for ST-80 compatibility.
     Returns the new method, or the value from exceptionBlock."

    ^ self new 
        compile:textOrStream 
        in:aClass 
        notifying:requestor
        install:install
        ifFail:exceptionBlock

    "Created: / 15-10-2010 / 10:39:27 / cg"
!

stcCompileMethod:aMethod
    ParserFlags
	withSTCCompilation:#always
	do:[
	    self
		compile:(aMethod source)
		forClass:(aMethod mclass)
		inCategory:(aMethod category)
	].
! !

!ByteCodeCompiler class methodsFor:'constants'!

byteCodeFor:aSymbol
    "returns the numeric code for some symbolic bytecodes."

    (aSymbol == #retNil) ifTrue:[^ 1].
    (aSymbol == #retTrue) ifTrue:[^ 2].
    (aSymbol == #retFalse) ifTrue:[^ 3].
    (aSymbol == #ret0) ifTrue:[^ 4].
    (aSymbol == #retSelf) ifTrue:[^5].
    (aSymbol == #retNum) ifTrue:[^ 127].
    (aSymbol == #retTop) ifTrue:[^ 0].

    (aSymbol == #mk0Block) ifTrue:[^ 156].
    (aSymbol == #mkNilBlock) ifTrue:[^ 157].

    (aSymbol == #push0) ifTrue:[^120].
    (aSymbol == #push1) ifTrue:[^121].
    (aSymbol == #push2) ifTrue:[^139].
    (aSymbol == #pushMinus1) ifTrue:[^122].
    (aSymbol == #pushNil) ifTrue:[^ 10].
    (aSymbol == #pushTrue) ifTrue:[^ 11].
    (aSymbol == #pushFalse) ifTrue:[^ 12].
    (aSymbol == #pushSelf) ifTrue:[^ 15].
    self error:'unknown instruction'.
! !

!ByteCodeCompiler class methodsFor:'defaults'!

allowExtensionsToPrivateClasses
    ^ ParserFlags allowExtensionsToPrivateClasses
!

asYetUncategorizedMethodCategory
    ^ '* As yet uncategorized *'
!

defaultMethodCategory
    "/ ^ '** As yet uncategorized **'.
    ^ '* uncategorized *'
! !

!ByteCodeCompiler class methodsFor:'private-utilities'!

stringWithSimpleCRs:aString
    |src dst ch|

    dst := String writeStream.
    src := aString readStream.
    [src atEnd] whileFalse:[
	ch := src next.
	ch = Character return ifTrue:[
	    src peek == Character linefeed ifTrue:[
		src next.
	    ].
	    ch := Character cr.
	].
	dst nextPut:ch
    ].
    ^ dst contents
! !

!ByteCodeCompiler class methodsFor:'stc compilation defaults'!

canCreateMachineCode
    "return true, if compilation to machine code is supported.
     Currently, all SYSV4, Linux and WinNT/XP systems do so;
     REAL/IX and HPUX9.x do not
	(due to the need for dynamic loading of object files, which is not supported by those).
     MIPS ULTRIX is almost finished, but not yet released.
     (late note - we no longer care for REAL/IX, HPUX9.x and MIPS ULTRIX)"

    ^ ObjectFileLoader notNil and:[ ObjectFileLoader canLoadObjectFiles ].

    "
     Compiler canCreateMachineCode
    "

    "Modified: / 13.9.1995 / 15:15:11 / claus"
    "Modified: / 3.9.1998 / 15:56:07 / cg"
!

ccCompilationOptions
    <resource: #obsolete>

    "return the options used with cc compilation.
     This method remains here for backward compatibility (older script files)"

    ^ ParserFlags ccCompilationOptions

    "
     Compiler ccCompilationOptions
    "

    "Modified: 5.11.1996 / 17:38:56 / cg"
!

ccCompilationOptions:aString
    <resource: #obsolete>
    
    "define the compilation options
     to be used when compiling to machine code.
     These are passed to cc. Can be set from your private.rc file.
     This method remains here for backward compatibility (older script files)"

    ParserFlags ccCompilationOptions:aString

    "
     Compiler ccCompilationOptions:'-O'
     Compiler ccCompilationOptions:'-O -fPIC'
     Compiler ccCompilationOptions
    "

    "Created: 5.11.1996 / 17:37:05 / cg"
    "Modified: 5.11.1996 / 17:38:32 / cg"
!

ccPath
    <resource: #obsolete>

    "return the path to (name of) the cc command for incremental method compilation.
     This method remains here for backward compatibility (older script files)"

    ^ ParserFlags ccPath

    "
     CC := nil
     Compiler ccPath
     Compiler ccPath:'gcc'
    "

    "Modified: / 13.9.1995 / 15:15:04 / claus"
    "Created: / 5.11.1996 / 17:35:40 / cg"
    "Modified: / 4.9.1998 / 15:48:40 / cg"
!

ccPath:aPathOrCommandName
    <resource: #obsolete>

    "set the path to the cc command for incremental method compilation.
     This method remains here for backward compatibility (older script files)"

    ParserFlags ccPath:aPathOrCommandName

    "
     Compiler ccPath
     Compiler ccPath:'gcc'
     Compiler ccPath:'bcc32'
    "

    "Modified: / 13.9.1995 / 15:15:04 / claus"
    "Created: / 5.11.1996 / 17:38:11 / cg"
    "Modified: / 23.8.1998 / 13:58:57 / cg"
!

stcCompilation
    <resource: #obsolete>

    "return the flag which controls compilation to machine code.
     If #always, methods are always compiled to machine code (which takes
     longer, but provides faster code). If #none, methods are never compiled
     to machine code, instead for non-primitive ones, compilation is to bytecode
     and for primitive ones, a trapping stub is generated.
     Anything else lets the compiler compile to bytecode,
     except for methods containing primitive code.
     This can be set from your private.rc file or from a workspace
     for selective compilation to machine code.
     This method remains here for backward compatibility (older script files)"

    ^ ParserFlags stcCompilation

    "
     Compiler stcCompilation
    "
!

stcCompilation:how
    <resource: #obsolete>

    "set the flag which controls compilation to machine code.
     If #always, methods are always compiled to machine code (which takes
     longer, but provides faster code). If #none, methods are never compiled
     to machine code, instead for non-primitive ones, compilation is to bytecode
     and for primitive ones, a trapping stub is generated.
     Anything else lets the compiler compile to bytecode,
     except for methods containing primitive code.
     This can be set from your private.rc file or from a workspace
     for selective compilation to machine code.
     This method remains here for backward compatibility (older script files)"

    |ret|

    ret := ParserFlags stcCompilation.
    ParserFlags stcCompilation:how.
    ^ ret

    "
     Compiler stcCompilation:#always
     Compiler stcCompilation:#never
     Compiler stcCompilation:#default
    "
!

stcCompilationDefines
    <resource: #obsolete>

    "return the defines used with stc compilation.
     This method remains here for backward compatibility (older script files)"

    ^ ParserFlags stcCompilationDefines
!

stcCompilationDefines:aString
    <resource: #obsolete>

    "define the flags (for example, additional -D defines)
     to be used when compiling to machine code.
     These are passed to stc. Can be set from your private.rc file.
     This method remains here for backward compatibility (older script files)"

    ParserFlags stcCompilationDefines:aString

    "
     Compiler stcCompilationDefines:'-DVGL -DDEBUG'
     Compiler stcCompilationDefines:'-DWIN32'
    "

    "Modified: / 23.8.1998 / 14:00:40 / cg"
!

stcCompilationIncludes
    <resource: #obsolete>

    "return the includes used with stc compilation.
     This method remains here for backward compatibility (older script files)"

    ^ ParserFlags stcCompilationIncludes
!

stcCompilationIncludes:aString
    <resource: #obsolete>

    "define the include directories via additional -I flags.
     These are passed to stc. Can be set in your private.rc file.
     This method remains here for backward compatibility (older script files)"

    ParserFlags stcCompilationIncludes:aString

    "
     Compiler stcCompilationIncludes:'-I/usr/local/include -I../../include'
     Compiler stcCompilationIncludes:(Compiler stcCompilationIncludes , ' -I../../libxt')
    "

    "Modified: 18.7.1997 / 18:04:25 / cg"
!

stcCompilationOptions
    <resource: #obsolete>

    "return the options used with stc compilation.
     This method remains here for backward compatibility (older script files)"

    ^ ParserFlags stcCompilationOptions
!

stcCompilationOptions:aString
    <resource: #obsolete>

    "define the compilation options
     to be used when compiling to machine code.
     These are passed to stc. Can be set from your private.rc file.
     This method remains here for backward compatibility (older script files)"

    ParserFlags stcCompilationOptions:aString

    "
     Compiler stcCompilationOptions:'+optinline'
    "
!

stcModulePath
    <resource: #obsolete>

    "return the path, where temporary modules are created.
     This method remains here for backward compatibility (older script files)"

    ^ ParserFlags stcModulePath

    "Created: 12.7.1996 / 12:15:26 / cg"
!

stcModulePath:aPath
    <resource: #obsolete>

    "set the path to the directory, where temporary modules are created.
     Obsolete; knowledge moved to parserFlags,
     where it is also obsolete now, as this should not be set from the outside,
     but instead rely totally on the userPreferences.
     This method remains here for backward compatibility (older script files)"

    ParserFlags stcModulePath:aPath

    "Created: 12.7.1996 / 12:15:49 / cg"
!

stcPath
    <resource: #obsolete>

    "return the path to the stc command, or nil if not found.
     This method remains here for backward compatibility (older script files)"

    ^ ParserFlags stcPath

    "
     Compiler stcPath
    "

    "Modified: 13.9.1995 / 14:37:26 / claus"
!

stcPath:aPath
    <resource: #obsolete>

    "set the path to the stc command - useful if private stc is wanted.
     This method remains here for backward compatibility (older script files)"

    ParserFlags stcPath:aPath

    "
     Compiler stcPath:'../../stc/stc'
     Compiler stcPath:'..\stc\stc'
    "

    "Modified: / 13.9.1995 / 14:37:26 / claus"
    "Modified: / 23.8.1998 / 13:59:24 / cg"
!

stcPathOf:command
    "return the path to an stc command, or nil if not found."

    |f d reqdSuffix cmd|

    "/
    "/ care for executable suffix
    "/
    cmd := command.
    OperatingSystem isMSDOSlike ifTrue:[
	reqdSuffix := 'exe'
    ] ifFalse:[
	OperatingSystem isVMSlike ifTrue:[
	    reqdSuffix := 'EXE'
	].
    ].
    reqdSuffix notNil ifTrue:[
	(f := cmd asFilename) suffix isEmpty ifTrue:[
	    cmd := (f withSuffix:reqdSuffix) name
	]
    ].
    "/
    "/ for our convenience, also check in current
    "/ and parent directories; even if PATH does not
    "/ include them ...
    "/
    "/ look in current ...
    d := Filename currentDirectory.
    (f := d construct:cmd) isExecutable ifTrue:[
	^ f pathName
    ].
    "/ look in ../stc ...
    d := d construct:'..'.
    (f := (d construct:'stc') construct:cmd) isExecutable ifTrue:[
	^ f pathName
    ].
    "/ look in ../../stc ...
    d := d construct:'..'.
    (f := (d construct:'stc') construct:cmd) isExecutable ifTrue:[
	^ f pathName
    ].

    "/
    "/ ok, stc must be installed in some directory along the PATH
    "/
    ^ OperatingSystem pathOfCommand:command

    "
     Compiler stcPathOf:'stc'
    "

    "Created: 13.9.1995 / 14:37:16 / claus"
! !

!ByteCodeCompiler methodsFor:'Compatibility-ST80'!

compile:textOrStream in:aClass notifying:requestor ifFail:exceptionBlock
    "name alias for ST-80 compatibility"

    ^ self
           compile:textOrStream
           forClass:aClass
           inCategory:(self class defaultMethodCategory)
           notifying:requestor
           install:true
           skipIfSame:false
           silent:false
           foldConstants:true
           ifFail:exceptionBlock.
!

compile:textOrStream in:aClass notifying:requestor install:install ifFail:exceptionBlock
    "name alias for ST-80 compatibility"

    ^ self
           compile:textOrStream
           forClass:aClass
           inCategory:(self class defaultMethodCategory)
           notifying:requestor
           install:install
           skipIfSame:false
           silent:false
           foldConstants:true
           ifFail:exceptionBlock.

    "Created: / 15-10-2010 / 10:39:42 / cg"
!

from:aStream class:aClass context:ctx notifying:aRequestor
    classToCompileFor := aClass.
    self source:aStream.

    self setClassToCompileFor:aClass.
    self notifying:aRequestor.

    "Created: / 30-01-2011 / 03:38:00 / cg"
! !

!ByteCodeCompiler methodsFor:'accessing'!

code
    "return the bytecode array - only valid after code-generation"

    ^ codeBytes
!

literalArray
    "return the literal array - only valid after parsing"

    ^ litArray
!

maxStackDepth
    "return the stack-need of the method - only valid after code-generation"

    ^ maxStackDepth
!

methodClass
    ^ methodClass ? Method
!

methodClass:aClass
    methodClass := aClass
! !

!ByteCodeCompiler methodsFor:'code generation'!

byteCodeFor:aSymbol
    "given a symbolic instruction, return the corresponding bytecode.
     as a side-effect, leave number of bytes pushed/popped by this instr.
     in stackDelta, and, if the instruction needs extra arguments, leave
     this info in extra. Also lineno is set to true, if this code has line
     information and extraLiteral is set if any hidden send is performed by it."

    "standard bytecodes"

    (aSymbol == #pushNil) ifTrue:[stackDelta := 1. ^ 10].
    (aSymbol == #pushTrue) ifTrue:[stackDelta := 1. ^ 11].
    (aSymbol == #pushFalse) ifTrue:[stackDelta := 1. ^ 12].
    (aSymbol == #pushLit) ifTrue:[stackDelta := 1. extra := #lit. ^ 14].
    (aSymbol == #pushLitS) ifTrue:[stackDelta := 1. extra := #index. ^ 14].
    (aSymbol == #pushSelf) ifTrue:[stackDelta := 1. ^ 15].
    (aSymbol == #pushNum) ifTrue:[stackDelta := 1. extra := #number. ^ 16].

    (aSymbol == #pushMethodArg) ifTrue:[stackDelta := 1. extra := #index. ^ 30].
    (aSymbol == #pushMethodVar) ifTrue:[stackDelta := 1. extra := #index. ^ 31].
    (aSymbol == #pushBlockArg) ifTrue:[stackDelta := 1. extra := #index. ^ 32].
    (aSymbol == #pushBlockVar) ifTrue:[stackDelta := 1. extra := #index. ^ 33].
    (aSymbol == #pushInstVar) ifTrue:[stackDelta := 1. extra := #index. ^ 34].
    (aSymbol == #pushOuterBlockArg) ifTrue:[stackDelta := 1. extra := #indexLevel. ^ 42].
    (aSymbol == #pushOuterBlockVar) ifTrue:[stackDelta := 1. extra := #indexLevel. ^ 128].

    (aSymbol == #retTop) ifTrue:[stackDelta := -1. ^ 0].
    (aSymbol == #retSelf) ifTrue:[^5].

    (aSymbol == #==) ifTrue:[stackDelta := -1. extraLiteral := aSymbol. ^ 45].
    (aSymbol == #~~) ifTrue:[stackDelta := -1. extraLiteral := aSymbol. ^ 46].

    (aSymbol == #falseJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 50].
    (aSymbol == #trueJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 51].
    (aSymbol == #nilJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 52].
    (aSymbol == #notNilJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 53].
    (aSymbol == #jump) ifTrue:[extra := #offset. ^ 54].
    (aSymbol == #makeBlock) ifTrue:[stackDelta := 1. extra := #offsetNvarNarg. ^ 55].
    (aSymbol == #zeroJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 56].
    (aSymbol == #notZeroJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 57].
    (aSymbol == #eqJump) ifTrue:[stackDelta := -2. extra := #offset. ^ 58].
    (aSymbol == #notEqJump) ifTrue:[stackDelta := -2. extra := #offset. ^ 59].

    (aSymbol == #lineno) ifTrue:[lineno := true. ^ 8].
    (aSymbol == #lineno16) ifTrue:[lineno := true. ^ 9].

    (aSymbol == #sourcepos8)  ifTrue:[extra := #index.      ^ 244].
    (aSymbol == #sourcepos16) ifTrue:[extra := #unsigned16. ^ 245].
    (aSymbol == #sourcepos32) ifTrue:[extra := #unsigned32. ^ 246].

    (aSymbol == #send) ifTrue:[lineno := true. extra := #special. ^ 19].
    (aSymbol == #superSend) ifTrue:[lineno := true. extra := #special. ^ 20].
    (aSymbol == #sendSelf) ifTrue:[lineno := true. extra := #special. ^ 13].

    (aSymbol == #drop) ifTrue:[stackDelta := -1. ^ 18].
    (aSymbol == #dup) ifTrue:[stackDelta := 1. ^ 47].

    (aSymbol == #storeMethodVar) ifTrue:[extra := #index. stackDelta := -1. ^ 37].
    (aSymbol == #storeBlockVar) ifTrue:[extra := #index. stackDelta := -1. ^ 38].
    (aSymbol == #storeInstVar) ifTrue:[extra := #index. stackDelta := -1. ^ 39].

    (aSymbol == #pushClassVarS) ifTrue:[stackDelta := 1. extra := #speciallitS. ^ 35].
    (aSymbol == #pushGlobalS) ifTrue:[stackDelta := 1. extra := #speciallitS. ^ 36].

    (aSymbol == #storeClassVarS) ifTrue:[extra := #speciallitS.stackDelta := -1. ^ 40].
    (aSymbol == #storeGlobalS) ifTrue:[extra := #speciallitS. stackDelta := -1. ^ 41].
    (aSymbol == #pushSpecialGlobal) ifTrue:[stackDelta := 1. extra := #index. ^ 200].

    (aSymbol == #storeOuterBlockVar) ifTrue:[stackDelta := -1. extra := #indexLevel. ^ 129].

    (aSymbol == #pushClassInstVar) ifTrue:[stackDelta := 1. extra := #index. ^ 176].
    (aSymbol == #storeClassInstVar) ifTrue:[extra := #index.stackDelta := -1. ^ 177].

    "optimized bytecodes"

    (aSymbol == #pushMethodVar1) ifTrue:[stackDelta := 1. ^80].
    (aSymbol == #pushMethodVar2) ifTrue:[stackDelta := 1. ^81].
    (aSymbol == #pushMethodVar3) ifTrue:[stackDelta := 1. ^82].
    (aSymbol == #pushMethodVar4) ifTrue:[stackDelta := 1. ^83].
    (aSymbol == #pushMethodVar5) ifTrue:[stackDelta := 1. ^84].
    (aSymbol == #pushMethodVar6) ifTrue:[stackDelta := 1. ^85].

    (aSymbol == #pushMethodArg1) ifTrue:[stackDelta := 1. ^86].
    (aSymbol == #pushMethodArg2) ifTrue:[stackDelta := 1. ^87].
    (aSymbol == #pushMethodArg3) ifTrue:[stackDelta := 1. ^88].
    (aSymbol == #pushMethodArg4) ifTrue:[stackDelta := 1. ^89].

    (aSymbol == #retNil) ifTrue:[^ 1].
    (aSymbol == #retTrue) ifTrue:[^ 2].
    (aSymbol == #retFalse) ifTrue:[^ 3].
    (aSymbol == #ret0) ifTrue:[^ 4].
    (aSymbol == #retNum) ifTrue:[extra := #number. ^ 127].
    (aSymbol == #homeRetTop) ifTrue:[^ 7].

    (aSymbol == #pushNum16) ifTrue:[stackDelta := 1. extra := #number16. ^ 17].
    (aSymbol == #push0) ifTrue:[stackDelta := 1. ^120].
    (aSymbol == #push1) ifTrue:[stackDelta := 1. ^121].
    (aSymbol == #push2) ifTrue:[stackDelta := 1. ^139].
    (aSymbol == #pushMinus1) ifTrue:[stackDelta := 1. ^122].

    (aSymbol == #send0) ifTrue:[lineno := true. extra := #index. ^21].
    (aSymbol == #send1) ifTrue:[lineno := true. extra := #index. stackDelta := -1. ^22].
    (aSymbol == #send2) ifTrue:[lineno := true. extra := #index. stackDelta := -2. ^23].
    (aSymbol == #send3) ifTrue:[lineno := true. extra := #index. stackDelta := -3. ^24].

    (aSymbol == #sendSelf0) ifTrue:[lineno := true. extra := #index. stackDelta := 1. ^180].
    (aSymbol == #sendSelf1) ifTrue:[lineno := true. extra := #index. ^181].
    (aSymbol == #sendSelf2) ifTrue:[lineno := true. extra := #index. stackDelta := -1. ^182].
    (aSymbol == #sendSelf3) ifTrue:[lineno := true. extra := #index. stackDelta := -2. ^183].
    (aSymbol == #sendSelfDrop0) ifTrue:[lineno := true. extra := #index. ^184].
    (aSymbol == #sendSelfDrop1) ifTrue:[lineno := true. extra := #index. stackDelta := -1. ^185].
    (aSymbol == #sendSelfDrop2) ifTrue:[lineno := true. extra := #index. stackDelta := -2. ^186].
    (aSymbol == #sendSelfDrop3) ifTrue:[lineno := true. extra := #index. stackDelta := -3. ^187].

    (aSymbol == #sendDrop) ifTrue:[lineno := true. extra := #special. ^25].
    (aSymbol == #sendDrop0) ifTrue:[lineno := true. extra := #index. stackDelta := -1. ^26].
    (aSymbol == #sendDrop1) ifTrue:[lineno := true. extra := #index. stackDelta := -2. ^27].
    (aSymbol == #sendDrop2) ifTrue:[lineno := true. extra := #index. stackDelta := -3. ^28].
    (aSymbol == #sendDrop3) ifTrue:[lineno := true. extra := #index. stackDelta := -4. ^29].

    (aSymbol == #pushInstVar1) ifTrue:[stackDelta := 1. ^90].
    (aSymbol == #pushInstVar2) ifTrue:[stackDelta := 1. ^91].
    (aSymbol == #pushInstVar3) ifTrue:[stackDelta := 1. ^92].
    (aSymbol == #pushInstVar4) ifTrue:[stackDelta := 1. ^93].
    (aSymbol == #pushInstVar5) ifTrue:[stackDelta := 1. ^94].
    (aSymbol == #pushInstVar6) ifTrue:[stackDelta := 1. ^95].
    (aSymbol == #pushInstVar7) ifTrue:[stackDelta := 1. ^96].
    (aSymbol == #pushInstVar8) ifTrue:[stackDelta := 1. ^97].
    (aSymbol == #pushInstVar9) ifTrue:[stackDelta := 1. ^98].
    (aSymbol == #pushInstVar10) ifTrue:[stackDelta := 1. ^99].

    (aSymbol == #storeMethodVar1) ifTrue:[stackDelta := -1. ^100].
    (aSymbol == #storeMethodVar2) ifTrue:[stackDelta := -1. ^101].
    (aSymbol == #storeMethodVar3) ifTrue:[stackDelta := -1. ^102].
    (aSymbol == #storeMethodVar4) ifTrue:[stackDelta := -1. ^103].
    (aSymbol == #storeMethodVar5) ifTrue:[stackDelta := -1. ^104].
    (aSymbol == #storeMethodVar6) ifTrue:[stackDelta := -1. ^105].

    (aSymbol == #storeInstVar1) ifTrue:[stackDelta := -1. ^110].
    (aSymbol == #storeInstVar2) ifTrue:[stackDelta := -1. ^111].
    (aSymbol == #storeInstVar3) ifTrue:[stackDelta := -1. ^112].
    (aSymbol == #storeInstVar4) ifTrue:[stackDelta := -1. ^113].
    (aSymbol == #storeInstVar5) ifTrue:[stackDelta := -1. ^114].
    (aSymbol == #storeInstVar6) ifTrue:[stackDelta := -1. ^115].
    (aSymbol == #storeInstVar7) ifTrue:[stackDelta := -1. ^116].
    (aSymbol == #storeInstVar8) ifTrue:[stackDelta := -1. ^117].
    (aSymbol == #storeInstVar9) ifTrue:[stackDelta := -1. ^118].
    (aSymbol == #storeInstVar10) ifTrue:[stackDelta := -1. ^119].

    (aSymbol == #pushLit1) ifTrue:[stackDelta := 1. ^ 222].
    (aSymbol == #pushLit2) ifTrue:[stackDelta := 1. ^ 223].
    (aSymbol == #pushLit3) ifTrue:[stackDelta := 1. ^ 224].
    (aSymbol == #pushLit4) ifTrue:[stackDelta := 1. ^ 225].
    (aSymbol == #pushLit5) ifTrue:[stackDelta := 1. ^ 226].
    (aSymbol == #pushLit6) ifTrue:[stackDelta := 1. ^ 227].
    (aSymbol == #pushLit7) ifTrue:[stackDelta := 1. ^ 228].
    (aSymbol == #pushLit8) ifTrue:[stackDelta := 1. ^ 229].

    (aSymbol == #retMethodVar1) ifTrue:[^160].
    (aSymbol == #retMethodVar2) ifTrue:[^161].
    (aSymbol == #retMethodVar3) ifTrue:[^162].
    (aSymbol == #retMethodVar4) ifTrue:[^163].
    (aSymbol == #retMethodVar5) ifTrue:[^164].
    (aSymbol == #retMethodVar6) ifTrue:[^165].

    (aSymbol == #retInstVar1) ifTrue:[^166].
    (aSymbol == #retInstVar2) ifTrue:[^167].
    (aSymbol == #retInstVar3) ifTrue:[^168].
    (aSymbol == #retInstVar4) ifTrue:[^169].
    (aSymbol == #retInstVar5) ifTrue:[^170].
    (aSymbol == #retInstVar6) ifTrue:[^171].
    (aSymbol == #retInstVar7) ifTrue:[^172].
    (aSymbol == #retInstVar8) ifTrue:[^173].

    (aSymbol == #retMethodArg1) ifTrue:[^174].
    (aSymbol == #retMethodArg2) ifTrue:[^175].

    (aSymbol == #pushBlockArg1) ifTrue:[stackDelta := 1. ^140].
    (aSymbol == #pushBlockArg2) ifTrue:[stackDelta := 1. ^141].
    (aSymbol == #pushBlockArg3) ifTrue:[stackDelta := 1. ^142].
    (aSymbol == #pushBlockArg4) ifTrue:[stackDelta := 1. ^143].

    (aSymbol == #pushOuter1BlockArg) ifTrue:[stackDelta := 1. extra := #index. ^ 43].
    (aSymbol == #pushOuter2BlockArg) ifTrue:[stackDelta := 1. extra := #index. ^ 44].

    (aSymbol == #=) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^130].
    (aSymbol == #+) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^131].
    (aSymbol == #~=) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^132].
    (aSymbol == #-) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^133].
    (aSymbol == #*) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^230].
    (aSymbol == #class) ifTrue:[extraLiteral := aSymbol. ^134].
"/    (aSymbol == #x) ifTrue:[lineno := true. extraLiteral := aSymbol. ^106].
"/    (aSymbol == #y) ifTrue:[lineno := true. extraLiteral := aSymbol. ^107].
"/    (aSymbol == #width) ifTrue:[lineno := true. extraLiteral := aSymbol. ^108].
"/    (aSymbol == #height) ifTrue:[lineno := true. extraLiteral := aSymbol. ^109].
"/    (aSymbol == #origin) ifTrue:[lineno := true. extraLiteral := aSymbol. ^154].
"/    (aSymbol == #extent) ifTrue:[lineno := true. extraLiteral := aSymbol. ^155].
    (aSymbol == #at:) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^135].
    (aSymbol == #at:put:)ifTrue:[lineno := true. stackDelta := -2. extraLiteral := aSymbol. ^136].
    (aSymbol == #bitAnd:) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^137].
    (aSymbol == #bitOr:) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^138].
    (aSymbol == #plus1) ifTrue:[lineno := true. extraLiteral := #+. ^123].
    (aSymbol == #minus1) ifTrue:[lineno := true. extraLiteral := #-. ^124].

    (aSymbol == #incMethodVar) ifTrue:[lineno := true. extraLiteral := #+. extra := #index. ^125].
    (aSymbol == #decMethodVar) ifTrue:[lineno := true. extraLiteral := #-. extra := #index. ^126].

    (aSymbol == #eq0) ifTrue:[extraLiteral := #==. ^48].
    (aSymbol == #ne0) ifTrue:[extraLiteral := #~~. ^49].

    (aSymbol == #>) ifTrue:[lineno := true. extraLiteral := aSymbol. stackDelta := -1. ^ 145].
    (aSymbol == #>=) ifTrue:[lineno := true. extraLiteral := aSymbol. stackDelta := -1. ^ 146].
    (aSymbol == #<) ifTrue:[lineno := true. extraLiteral := aSymbol. stackDelta := -1. ^ 147].
    (aSymbol == #<=) ifTrue:[lineno := true. extraLiteral := aSymbol. stackDelta := -1. ^ 148].
"/    (aSymbol == #next) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 149].
"/    (aSymbol == #peek) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 150].
    (aSymbol == #value) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 151].
    (aSymbol == #value:) ifTrue:[lineno := true. extraLiteral := aSymbol.  stackDelta := -1. ^ 152].
    (aSymbol == #value:value:) ifTrue:[lineno := true. extraLiteral := aSymbol.  stackDelta := -2. ^ 178].
    (aSymbol == #size) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 153].
"/    (aSymbol == #asInteger) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 158].
"/    (aSymbol == #rounded) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 159].
    (aSymbol == #mk0Block) ifTrue:[^ 156].
    (aSymbol == #mkNilBlock) ifTrue:[^ 157].

    (aSymbol == #gt0) ifTrue:[lineno := true. extraLiteral := #>. ^ 212].
    (aSymbol == #pushgt0) ifTrue:[lineno := true. stackDelta := 1. extraLiteral := #>. ^ 208].
    (aSymbol == #basicNew) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 211].
    (aSymbol == #new) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 213].
    (aSymbol == #basicNew:) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 214].
    (aSymbol == #new:) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 215].

    (aSymbol == #pushBlockVar1) ifTrue:[stackDelta := 1. ^ 232].
    (aSymbol == #pushBlockVar2) ifTrue:[stackDelta := 1. ^ 233].
    (aSymbol == #pushBlockVar3) ifTrue:[stackDelta := 1. ^ 234].
    (aSymbol == #storeBlockVar1) ifTrue:[stackDelta := -1. ^ 235].
    (aSymbol == #storeBlockVar2) ifTrue:[stackDelta := -1. ^ 236].
    (aSymbol == #storeBlockVar3) ifTrue:[stackDelta := -1. ^ 237].

    (aSymbol == #falseJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 190].
    (aSymbol == #trueJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 191].
    (aSymbol == #nilJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 192].
    (aSymbol == #notNilJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 193].
    (aSymbol == #jumpabs) ifTrue:[extra := #absoffset. ^ 194].
    (aSymbol == #makeBlockabs) ifTrue:[stackDelta := 1. extra := #absoffsetNvarNarg. ^ 195].
    (aSymbol == #zeroJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 196].
    (aSymbol == #notZeroJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 197].
    (aSymbol == #eqJumpabs) ifTrue:[stackDelta := -2. extra := #absoffset. ^ 198].
    (aSymbol == #notEqJumpabs) ifTrue:[stackDelta := -2. extra := #absoffset. ^ 199].

    (aSymbol == #pushThisContext) ifTrue:[stackDelta := 1. ^ 144].

    (aSymbol == #isNil) ifTrue:["extraLiteral := aSymbol. -- could be synthetic" ^ 188].
    (aSymbol == #notNil) ifTrue:["extraLiteral := aSymbol. -- could be synthetic" ^ 189].
    (aSymbol == #not) ifTrue:[extraLiteral := aSymbol. lineno := true. ^ 179].
    (aSymbol == #&) ifTrue:[extraLiteral := aSymbol. lineno := true. ^ 216].
    (aSymbol == #|) ifTrue:[extraLiteral := aSymbol. lineno := true. ^ 217].

    (aSymbol == #pushClassVarL) ifTrue:[stackDelta := 1. extra := #speciallitL. ^ 218].
    (aSymbol == #pushGlobalL) ifTrue:[stackDelta := 1. extra := #speciallitL. ^ 218].
    (aSymbol == #storeClassVarL) ifTrue:[extra := #speciallitL.stackDelta := -1. ^ 219].
    (aSymbol == #storeGlobalL) ifTrue:[extra := #speciallitL. stackDelta := -1. ^ 219].
    (aSymbol == #pushLitL) ifTrue:[stackDelta := 1. extra := #unsigned16. ^ 201].

    (aSymbol == #sendL) ifTrue:[lineno := true. extra := #specialL. ^ 205].
    (aSymbol == #sendSelfL) ifTrue:[lineno := true. extra := #specialL. ^ 207].
    (aSymbol == #sendDropL) ifTrue:[lineno := true. extra := #specialL. ^ 204].
    (aSymbol == #superSendL) ifTrue:[lineno := true. extra := #specialL. ^ 206].

    (aSymbol == #top) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #bottom) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #left) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #right) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].

    (aSymbol == #x) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #y) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #width) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #height) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #origin) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #extent) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #next) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #peek) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #asInteger) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #rounded) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].

    (aSymbol == #blockRef) ifTrue:[stackDelta := 0. ^ 238].
    (aSymbol == #over) ifTrue:[stackDelta := 1. ^ 6].

    (aSymbol == #sendVL) ifTrue:[lineno := true. extra := #specialVL. extraOP := 0. ^ 204].
    (aSymbol == #superSendVL) ifTrue:[lineno := true. extra := #specialVL. extraOP := 1. ^ 204].
    (aSymbol == #pushLitVL) ifTrue:[stackDelta := 1. extra := #unsigned32. extraOP := 2. ^ 204].
    (aSymbol == #pushGlobalVL) ifTrue:[stackDelta := 1. extra := #speciallitVL. extraOP := 3. ^ 204].
    (aSymbol == #storeGlobalVL) ifTrue:[stackDelta := -1. extra := #speciallitVL. extraOP := 4. ^ 204].

    "/ the next 2 are to be obsoleted soon (renamed as MethodLocal)
    (aSymbol == #pushLocal) ifTrue:[ stackDelta := 1. extra := #index. ^ 239].
    (aSymbol == #storeLocal) ifTrue:[ stackDelta := -1. extra := #index. ^ 240].

    (aSymbol == #pushMethodLocal) ifTrue:[ stackDelta := 1. extra := #index. ^ 239].
    (aSymbol == #storeMethodLocal) ifTrue:[ stackDelta := -1. extra := #index. ^ 240].
    (aSymbol == #storeBlockLocal) ifTrue:[ stackDelta := -1. extra := #index. ^ 241].
    (aSymbol == #storeOuterBlockLocal) ifTrue:[ stackDelta := -1. extra := #indexLevel. ^ 242].
    (aSymbol == #swap) ifTrue:[stackDelta := 0. ^ 243].

    self codeGeneratorError:'invalid code symbol'.

    "Modified: / 03-09-1995 / 12:58:47 / claus"
    "Modified: / 25-10-2011 / 21:56:43 / cg"
    "Modified (comment): / 31-10-2011 / 11:34:37 / cg"
    "Modified (format): / 31-05-2015 / 03:55:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkForCommonCode:symbolicCodeArray
    "hook to return the code for common code sequences.
     This reduces the in-memory number of byteArrays somewhat.

     Not yet fully implemented - just an idea ... there is certainly more to do here
     (does it make sense to scan all methods, collect code in a set and unify things
      automatically in the background - or upon request ?)"

    |sz insn1|

    (sz := symbolicCodeArray size) == 2 ifTrue:[
	"/
	"/ a very common sequence: return the first literal
	"/
	(insn1 := symbolicCodeArray at:1) == #pushLit1 ifTrue:[
	    (symbolicCodeArray at:2) == #retTop ifTrue:[
		^ #[222 0]
	    ]
	]
    ].
    sz == 1 ifTrue:[
	"/
	"/ other common sequences: return the receiver, nil, true or false
	"/
	(insn1 := symbolicCodeArray at:1) == #retSelf ifTrue:[
	    ^ #[5]
	].
	insn1 == #retNil ifTrue:[
	    ^ #[1]
	].
	insn1 == #retTrue ifTrue:[
	    ^ #[2]
	].
	insn1 == #retFalse ifTrue:[
	    ^ #[3]
	].
    ].
    ^ nil
!

checkForPrimitiveCode:nr
    "return the code for an ST-80 primitive method.
     Since many primitives available on ST-80 should also be available
     somewhere in ST/X, this may work for many primitive numbers.
     However, more information is needed and more things to be added below.

     This was added to allow emulation of (some) ST-80
     primitives (to fileIn RemoteInvocation & Monitor41 packages)"

    |cls sel|

    (nr == 75)  ifTrue:[ cls := Object. sel := #identityHash ].
    (nr == 110) ifTrue:[ cls := Object. sel := #==           ].
    (nr == 111) ifTrue:[ cls := Object. sel := #class        ].

    "
     should add more here, to be able to fileIn ST-80 and Squeak methods
     containing primitive calls (who gives me the numbers ... ?)
     mhmh - got some ..."

     "/ ST80 and Squeak common:
     "/            18 Number @
     "/            41 Float +
     "/            42 Float -
     "/            49 Float *
     "/            50 Float /
     "/            52 Float fractionPart
     "/            54 Float timesTwoPower:

     "/ ST80:
     "/
     "/            18 Number @
     "/            21 LargePositiveInteger +
     "/            22 LargePositiveInteger -
     "/            29 LargePositiveInteger *
     "/            30 LargePositiveInteger /
     "/            31 LargePositiveInteger \\
     "/            32 LargePositiveInteger //
     "/            34 LargePositiveInteger bitAnd:
     "/            35 LargePositiveInteger bitOr:
     "/            36 LargePositiveInteger bitXor:
     "/            37 LargePositiveInteger bitShift:
     "/            40 SmallInteger asFloat
     "/            41 Float +
     "/            42 Float -
     "/            49 Float *
     "/            50 Float /
     "/            52 Float fractionPart
     "/            54 Float timesTwoPower:
     "/            70 Behavior basicNew
     "/            71 Behavior basicNew:
     "/            89 Behavior flushVMmethodCache
     "/            91 InputState primCursorLocPut:
     "/           105 ByteArray replaceElementsFrom:to:withByteArray:startingAt:
     "/           223 ByteString =
     "/           306 ObjectMemory class sizesAtStartup
     "/           307 ObjectMemory class defaultSizesAtStartup
     "/           309 ObjectMemory class defaultThresholds
     "/           326 ObjectMemory class getMemoryUsageAndZeroFragmentationStatisticsIf:
     "/           395 ExternalInterface ???
     "/           400 FormBitmap class newWidth:height:
     "/           414 TwoByteString replaceElementsFrom:to:withTwoByteString:startingAt:
     "/           415 TwoByteString =
     "/           417 String trueCompare:
     "/           418 ByteString nextIndexOf:from:to:
     "/           419 ByteString prevIndexOf:from:to:
     "/           422 WeakArray indexOf:replaceWith:startingAt:stoppingAt:
     "/           522 Behavior flushVMmethodCacheEntriesFor:
     "/           524 Context nFromVPC:
     "/           525 Context vFromNPC:
     "/           532 Object shallowCopy
     "/           536 Behavior atomicAllInstances
     "/           537 Object allOwners
     "/           538 ObjectMemory class allObjects
     "/           546 UninterpretedBytes longAt:
     "/           548 UninterpretedBytes floatAt:
     "/           550 UninterpretedBytes longFloatAt:
     "/           544 UninterpretedBytes unsignedLongAt:
     "/           559 ByteArray replaceBytesFrom:to:with:startingAt:
     "/           560 Double class fromNumber:
     "/           561 Double +
     "/           562 Double -
     "/           569 Double *
     "/           570 Double /
     "/           572 Double fractionPart
     "/           574 Double timesTwoPower:
     "/           576 Double sin
     "/           577 Double cos
     "/           578 Double tan
     "/           579 Double arcSin
     "/           580 Double arcCos
     "/           581 Double arcTan
     "/           582 Double sqrt
     "/           583 Double ln
     "/           584 Double exp
     "/           585 Double raisedTo:
     "/           587 Double floorLog10
     "/           588 Double asFloat
     "/           591 Float cos
     "/           592 Float arcSin
     "/           593 Float arcCos
     "/           600 Float sin
     "/           601 Float tan
     "/           602 Float arcTan
     "/           603 Float sqrt
     "/           604 Float ln
     "/           605 Float exp
     "/           606 Float raisedTo:
     "/           609 Float floorLog10
     "/           610 Filename getDatesErrInto:
     "/           614 DosFilename class getVolumes
     "/           615 UnixFilename primSetProtection:errInto:
     "/           616 UnixFilename class primSetCreationMask:errInto:
     "/           617 UnixFilename primGetProtectionErrInto:
     "/           620 Filename listDirectoryErrInto:
     "/           621 Filename deleteErrInto:
     "/           622 Filename isDirectoryErrInto:
     "/           623 Filename renameTo:errInto:
     "/           624 Filename makeDirectoryErrInto:
     "/           625 Filename class defaultDirectoryErrInto:
     "/           626 Filename fileSizeErrInto:
     "/           627 Filename isWritableErrInto:
     "/           628 Filename setWritable:errInto:
     "/           629 Filename existsErrInto:
     "/           630 SocketAccessor setOptionsLevel:name:value:
     "/           631 SocketAccessor getOptionsLevel:name:
     "/           632 SocketAccessor primGetName
     "/           633 SocketAccessor primGetPeer
     "/           634 SocketAccessor atMark
     "/           637 UnixTtyAccessor primGetOptions
     "/           638 UnixTtyAccessor setOptions:
     "/           639 UnixRealTtyAccessor modemBits:mask:sendBreak:
     "/           640 IPSocketAddress class primHostAddressByName:
     "/           641 IPSocketAddress class netAddressByName:
     "/           642 IPSocketAddress class protocolNumberByName:
     "/           643 IPSocketAddress class servicePortByName:
     "/           645 IPSocketAddress class primHostNameByAddress:
     "/           646 IPSocketAddress class netNameByAddress:
     "/           647 IPSocketAddress class protocolNameByNumber:
     "/           648 IPSocketAddress class serviceNameByPort:
     "/           649 SocketAccessor class getHostname
     "/           650 Filename primOpenFileNamed:direction:creation:errorInto:
     "/           651 IOAccessor primClose
     "/           652 UnixPipeAccessor class primPipeErrorInto:
     "/           653 UnixPseudoTtyAccessor class primPtyErrorInto:
     "/           654 SocketAccessor class primPairErrorInto:
     "/           655 UnixRealTtyAccessor class primOpen:errInto:
     "/           660 IOAccessor primReadInto:startingAt:for:
     "/           661 IOAccessor primWriteFrom:startingAt:for:
     "/           662 IOAccessor primSeekTo:
     "/           664 IOAccessor truncateTo:
     "/           665 DosDiskFileAccessor commit
     "/           666 IOAccessor primGetSize
     "/           667 MacDiskFileAccessor lock:for:
     "/           669 UnixIOAccessor bytesForRead
     "/           670 SocketAccessor class primFamily:type:protocol:errInto:
     "/           671 SocketAccessor primAccept
     "/           672 SocketAccessor bindTo:
     "/           673 SocketAccessor listenFor:
     "/           674 SocketAccessor primConnectTo:
     "/           675 SocketAccessor primReceiveFrom:buffer:start:for:flags:
     "/           676 SocketAccessor sendTo:buffer:start:for:flags:
     "/           677 SocketAccessor shutdown:
     "/           681 UnixProcess class primFork:arguments:environment:descriptors:errorTo:
     "/           682 UnixProcess class reapOne
     "/           683 UnixProcess kill:
     "/           690 CEnvironment class primEnvironment
     "/           697 OSErrorHolder class errorDescriptionFor:
     "/           697 ErrorHolder class errorDescriptionFor:
     "/           698 SocketAccessor class primInit:
     "/           700 ParagraphEditor class getExternalSelectionOrNil:
     "/           701 ParagraphEditor class putExternalSelection:with:
     "/           705 Screen ringBell
     "/           706 Cursor class primOpenImage:mask:hotSpotX:hotSpotY:background:foreground:
     "/           707 Cursor primBeCursor
     "/           708 Cursor primFreeCursor
     "/           772 SoundManager enumerateSoundsFrom:
     "/           773 SoundManager playSoundFrom:sound:
     "/           774 SoundManager simpleBeep:
     "/           775 Pixmap primFromClipboard
     "/           776 Pixmap toClipboard
     "/           808 Context findNextMarkedUpTo:
     "/           809 Context terminateTo:
     "/           710 DosTtyAccessor class primOpen:errInto:
     "/           711 DosTtyAccessor primClose
     "/           712 DosTtyAccessor primReadInto:startingAt:for:
     "/           713 DosTtyAccessor primWriteFrom:startingAt:for:
     "/           714 DosTtyAccessor primGetOptions
     "/           715 DosTtyAccessor primSetOptions:
     "/           716 DosTtyAccessor setSem:forWrite:
     "/           717 DosTtyAccessor modemBits:mask:sendBreak:
     "/           750 MacFilename class getVolumes
     "/           752 MacFilename primSetCreator:type:errInto:
     "/           754 MacIOAccessor class getAccessories
     "/           755 MacIOAccessor class runAccessory:
     "/           756 MacOSFilename class getFileTypes:errInto:
     "/           757 MacOSFilename putFileWithPrompt:errInto:
     "/           758 MacOSFilename getFileInfoErrInto:
     "/           759 MacOSFilename stringFromVRefErrInto:
     "/           761 MacOSFilename class getStartupFilesErrInto:
     "/           770 DosFilename printPSFileErrInto:
     "/           771 DosFilename printTextFileErrInto:
     "/           780 MacTtyAccessor class primOpen:errInto:
     "/           781 MacTtyAccessor primClose
     "/           782 MacTtyAccessor primReadInto:startingAt:for:
     "/           783 MacTtyAccessor primWriteFrom:startingAt:for:
     "/           786 MacTtyAccessor primGetOptions
     "/           787 MacTtyAccessor setOptions:
     "/           788 MacTtyAccessor primBreak:
     "/           790 MacTtyAccessor primGetStatus
     "/           792 MacTtyAccessor setSem:forWrite:
     "/           793 MacTtyAccessor primAssertDTR:
     "/           794 MacTtyAccessor primGetSize
     "/           933 ByteArray copyBitsClippedStride:...
     "/           934 ByteArray tileBits32By32Stride:...
     "/           935 Screen dragShape:...
     "/           936 Screen resizeRectangle...
     "/           937 Screen displayShape:...
     "/           938 Window resizeFromUserWithMinimum:maximum:
     "/           940 Window primClose
     "/           942 Window getDimensions
     "/           943 Window moveTo:resize:
     "/           944 Window primMap
     "/           945 Window class primNewAt:extent:min:max:windowType:
     "/           946 Screen flush
     "/           947 Screen getScreenDimensions
     "/           948 Window unmap
     "/           950 Screen sync
     "/           951 Window setIconMask:
     "/           952 Window label:iconLabel:
     "/           953 Window raise
     "/           954 Window lower
     "/           955 Screen queryStackingOrder
     "/           956 TextMeasurer primScanCharactersFrom:...
     "/           957 GraphicsContext displayMappedString:from:to:at:withMap:
     "/           959 Window setBackgroundPixel:
     "/           960 Screen class primOpen:
     "/           965 UnmappableSurface contentsOfAreaOriginX:y:width:height:
     "/           966 Window contentsOfAreaOriginX:y:width:height:
     "/           967 Screen contentsOfAreaOriginX:y:width:height:
     "/           970 Mask class primExtent:depth:
     "/           971 Mask privateClose
     "/           976 GraphicsContext displayCharacterOfIndex:at:
     "/           978 DeviceFont class listFonts
     "/           979 DeviceFont primLoadFont
     "/           980 DeviceFont primUnLoadFont
     "/           985 GraphicsContext displayLineFrom:to:
     "/           986 GraphicsContext displayPolyline:at:
     "/           987 GraphicsContext displayPolygon:at:
     "/           988 GraphicsContext primDisplayRectangleOrigin:extent:
     "/           989 GraphicsContext primDisplayRectangularBorderOrigin:extent:
     "/           990 GraphicsContext primDisplayArcBBoxOrigin:extent:startAngle:sweepAngle:
     "/           991 GraphicsContext primDisplayWedgeBBoxOrigin:extent:startAngle:sweepAngle:
     "/           992 GraphicsContext displayMask:at:"
     "/           993 GraphicsContext displayUninterpretedImageBits:at:
     "/           994 GraphicsContext primCopyRectangularAreaExtent:from:sourceOffset:destinationOffset:
     "/           995 GraphicsContext primCopyMaskedArea:from:sourceOffset:destinationOffset:
     "/           996 Screen deviceColormap
     "/           998 GraphicsContext displayUninterpretedMonoImageBits:foreground:background:at:

     "/ Squeak:
     "/
     "/             1 +
     "/             2 -
     "/             3 <
     "/             4 >
     "/             5 <=
     "/             6 >=
     "/             7 =
     "/             8 ~=
     "/             9 *
     "/            10 /
     "/            11 mod:
     "/            12 div:
     "/            13 quo:
     "/            14 bitAnd:
     "/            15 bitOr:
     "/            16 bitXor:
     "/            17 bitShift:
     "/            18 @
     "/            19
     "/            ...
     "/            39 fail - reserved/unimplemented
     "/            40 asFloat
     "/            41 Float +
     "/            42 Float -
     "/            43 Float <
     "/            44 Float >
     "/            45 Float <=
     "/            46 Float >=
     "/            47 Float =
     "/            48 Float ~=
     "/            49 Float *
     "/            50 Float /
     "/            51 Float truncated
     "/            52 Float fractionalPart
     "/            53 Float exponent
     "/            54 Float timeTwoPower
     "/            55 Float sqrt
     "/            56 Float sine
     "/            57 Float arcTan
     "/            58 Float logN
     "/            59 Float exp
     "/            60 at:
     "/            61 at:put:
     "/            62 size
     "/            63 stringAt:
     "/            64 stringAt:put:
     "/            65 next
     "/            66 nextPut:
     "/            67 atEnd
     "/            68 objectAt:
     "/            69 objectAt:put:
     "/            70 new
     "/            71 new:
     "/            72 becomeOneWay
     "/            73 instVarAt:
     "/            74 instVarAtPut:
     "/            75 asOop
     "/            76 storeStackP
     "/            77 someInstance
     "/            78 nextInstance
     "/            79 newMethod
     "/            80 blockCopy
     "/            81 value
     "/            82 valueWithArgs
     "/            83 perform
     "/            84 performWithArgs
     "/            85 signal
     "/            86 wait
     "/            87 resume
     "/            88 suspend
     "/            89 flushCache
     "/            90 mousePoint
     "/            91 fail/unimplemented/reserved
     "/            92 fail/unimplemented/reserved
     "/            93 inputSemaphore
     "/            94 fail/unimplemented/reserved
     "/            95 inputWord
     "/            96 copyBits
     "/            97 snapShot
     "/            98 fail/unimplemented/reserved
     "/            99 fail/unimplemented/reserved
     "/           100 fail/unimplemented/reserved
     "/           101 beCursor
     "/           102 beDisplay
     "/           103 scanCharacters
     "/           104 drawLoop
     "/           105 stringReplace
     "/           106 screenSize
     "/           107 mouseButtons
     "/           108 kbdNext
     "/           109 kbdPeek
     "/           110 equivalent
     "/           111 class
     "/           112 bytesLeft
     "/           113 quit
     "/           114 exitToDebugger
     "/           115 fail/unimplemented/reserved
     "/           116 flushCacheByMethod
     "/           117 externalCall
     "/           118 doPrimitiveWithArg
     "/           119 flushCacheSelective
     "/           120 fail/unimplemented/reserved
     "/           121 imageName
     "/           122 noop
     "/           123 fail/unimplemented/reserved
     "/           124 lowSpaceSemaphore
     "/           125 signalAtBytesLeft
     "/           126 deferDisplayUpdate
     "/           127 showDisplayRect
     "/           128 arrayBecome
     "/           129 specialObjectsOop
     "/           130 fullGC
     "/           131 incrementalGC
     "/           132 objectPointsTo
     "/           133 setInterruptKey
     "/           134 interruptSemaphore
     "/           135 millisecondClock
     "/           136 signalAtMilliseconds
     "/           137 secondsClock
     "/           138 someObject
     "/           139 nextObject
     "/           140 beep
     "/           141 clipboardText
     "/           142 vmPath
     "/           143 shortAt
     "/           144 shortAtPut
     "/           145 constantFill
     "/           146 readJoystick
     "/           147 warpBits
     "/           148 clone
     "/           149 getAttribute
     "/           150 fileAtEnd
     "/           151 fileClose
     "/           152 fileGetPosition
     "/           153 fileOpen
     "/           154 fileRead
     "/           155 fileSetPosition
     "/           156 fileDelete
     "/           157 fileSize
     "/           158 fileWrite
     "/           159 fileRename
     "/           160 directoryCreate
     "/           161 directoryDelimiter
     "/           162 directoryLookup
     "/           163 fail
     "/           164 fail
     "/           165 fail
     "/           166 fail
     "/           167 fail
     "/           168 fail
     "/           169 directorySetMacType
     "/           170 soundStart
     "/           171 soundStartWithSemaphore
     "/           172 soundStop
     "/           173 soundAvailableSpace
     "/           174 soundPlaySamples
     "/           175 soundPlaySilence
     "/           176 waveTableSoundmixSampleCountIntoStarrtingAtpan
     "/           177 fmSoundmixSampleCountintostartingAtpan
     "/           178 pluckedSoundmixSampleCountintostartingAtpan
     "/           179 sampledSoundmixSampleCountintostartingAtpan
     "/           180 fmSoundmixSampleCountintostartingAtleftVolrightVol
     "/           181 pluckedSoundmixSampleCountintostartingAtleftVolrightVol
     "/           182 sampledSoundmixSampleCountintostartingAtleftVolrightVol
     "/           183 reverbSoundapplyReverbTostartingAtcount
     "/           184 loopedSampledSoundmixSampleCountintostartingAtleftVolrightVol
     "/           185 fail
     "/           186 fail
     "/           187 fail
     "/           188 fail
     "/           189 soundInsertSamples
     "/           190 soundStartRecording
     "/           191 soundStopRecording
     "/           192 soundGetRecordingSampleRate
     "/           193 soundRecordSamples
     "/           194 soundSetRecordLevel
     "/           195 fail
     "/           196 fail
     "/           197 fail
     "/           198 fail
     "/           199 fail
     "/           200 initializeNetwork
     "/           201 resolverStartNameLookup
     "/           202 resolverNameLookupResult
     "/           203 resolverStartAddressLookup
     "/           204 resolverAddressLookupResult
     "/           205 resolverAbortLookup
     "/           206 resolverLocalAddress
     "/           207 resolverStatus
     "/           208 resolverError
     "/           209 socketCreate
     "/           210 socketDestroy
     "/           211 socketConnectionStatus
     "/           212 socketError
     "/           213 socketLocalAddress
     "/           214 socketLocalPort
     "/           215 socketRemoteAddress
     "/           216 socketRemotePort
     "/           217 socketConnectToPort
     "/           218 socketListenOnPort
     "/           219 socketCloseConnection
     "/           220 socketAbortConnection
     "/           221 socketReceiveDataBufCount
     "/           222 socketReceiveDataAvailable
     "/           223 socketSendDataBufCount
     "/           224 socketSendDone
     "/           225 fail
     "/           226 fail
     "/           227 fail
     "/           228 fail
     "/           229 fail
     "/           230 relinquishProcessor
     "/           231 forceDisplayUpdate
     "/           232 formPrint
     "/           233 setFullScreen
     "/           234 bitmapdecompressfromByteArrayat
     "/           235 stringcomparewithcollated
     "/           236 sampledSoundconvert8bitSignedFromto16Bit
     "/           237 bitmapcompresstoByteArray
     "/           238 serialPortOpen
     "/           239 serialPortClose
     "/           240 serialPortWrite
     "/           241 serialPortRead
     "/           242 fail
     "/           243 stringtranslatefromtotable
     "/           244 stringfindFirstInStringinSetstartingAt
     "/           245 stringindexOfAsciiinStringstartingAt
     "/           246 stringfindSubstringinstartingAtmatchTable
     "/           247 fail
     "/           248 fail
     "/           249 fail
     "/           250 clearProfile
     "/           251 dumpProfile
     "/           252 startProfiling
     "/           253 stopProfiling
     "/           254 vmParameter
     "/           255 instVarsPutFromStack
     "/           256 pushSelf
     "/           257 pushTrue
     "/           258 pushFalse
     "/           259 pushNil
     "/           260 pushMinusOne
     "/           261 pushZero
     "/           262 pushOne
     "/           263 pushTwo
     "/           264 loadInstVar
     "/           ..  loadInstVar
     "/           519 loadInstVar
     "/           520 fail
     "/           521 MIDIClosePort
     "/           522 MIDIGetClock
     "/           523 MIDIGetPortCount
     "/           524 MIDIGetPortDirectionality
     "/           525 MIDIGetPortName
     "/           526 MIDIOpenPort
     "/           527 MIDIParameterGetOrSet
     "/           528 MIDIRead
     "/           529 MIDIWrite
     "/           530 fail
     "/           ..  fail
     "/           539 fail
     "/           540 asyncFileClose
     "/           541 asyncFileOpen
     "/           542 asyncFileReadResult
     "/           543 asyncFileReadStart
     "/           544 asyncFileWriteResult
     "/           545 asyncFileWriteStart
     "/           546 fail
     "/           ..
     "/           700 fail

    cls notNil ifTrue:[
	^ (cls compiledMethodAt:sel) code
    ].
    ^ nil
!

codeLineNumber:nr on:codeStream
    "generate lineNumber information"

    "/ caveat: (currently) there is no separate lineNumber or symbol table;
    "/ the line numbers are coded right into the instruction stream.
    "/ This might change in the future.
    "/ (It is not a problem speed wise: the Jitter just skips them.)

    (currentLineNumber = nr or:[nr <= 0]) ifTrue:[
        ^ self
    ].

    "don't need line number information, if still on same line"
    currentLineNumber := nr.

    nr <= 255 ifTrue:[
        codeStream 
            nextPut:#lineno;
            nextPut:nr.
    ] ifFalse:[
        nr <= 16rFFFF ifTrue:[
            codeStream 
                nextPut:#lineno16;
                nextPutInt16MSB:nr.
        ]
    ].
!

codeSourcePosition:nr on:codeStream
    "generate source position information"

    "/ caveat: (currently) there is no separate line number, position or symbol table;
    "/ the source positions are coded right into the instruction stream.
    "/ This might change in the future.
    "/ (It is not a problem speed wise: the Jitter just skips them.)

    nr <= 255 ifTrue:[
        codeStream 
            nextPut:#sourcepos8;
            nextPut:nr.
    ] ifFalse:[
        nr <= 16rFFFF ifTrue:[
            codeStream 
                nextPut:#sourcepos16;
                nextPut:nr;
                nextPut:nil.

        ] ifFalse:[ 
            nr <= 16rFFFFFFFF ifTrue:[ 
                codeStream 
                    nextPut:#sourcepos32;
                    nextPut:nr;
                    nextPut:nil;
                    nextPut:nil;
                    nextPut:nil.
            ].
        ].
    ].

    "Created: / 31-05-2015 / 03:43:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createMethod
    |newMethod|

    newMethod := self methodClass new:(litArray size).
    litArray notNil ifTrue:[
        "/ fixup CheapBlocks method-field in literal array,
        litArray do:[:aLiteral |
            (aLiteral isBlock and:[aLiteral isCheapBlock]) ifTrue:[
                aLiteral setMethod:newMethod.
            ]
        ].
        newMethod literals:litArray
    ].

    newMethod numberOfVars:(self numberOfMethodVars + (maxNumTemp ? 0)).
    newMethod numberOfArgs:(self numberOfMethodArgs).
    newMethod stackSize:(self maxStackDepth).

    primitiveResource notNil ifTrue:[
        newMethod setResourceFlag
    ].

    annotations notEmptyOrNil ifTrue:[
        newMethod annotations: (self annotations copy).
        (Smalltalk at: #NamespaceAwareLookup) notNil ifTrue:[
            (annotations contains: [:annotation| (annotation key) == #namespace:])
                ifTrue:[newMethod lookupObject:NamespaceAwareLookup instance]
        ]
    ].

    ^ newMethod

    "Created: / 18-05-1996 / 16:33:17 / cg"
    "Modified: / 24-06-1996 / 12:32:50 / stefan"
    "Modified: / 10-07-2010 / 21:40:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:22:15 / cg"
!

genByteCodeFrom:symbolicCodeArray
    "convert symbolicCode into bytecodes"

    |symIndex    "{Class: SmallInteger }"
     codeSize    "{Class: SmallInteger }"
     symCodeSize "{Class: SmallInteger }"
     index nextSym addr
     codeSymbol nargs needRetry
     stackDepth relocInfo level nvars round|

    symbolicCodeArray isNil ifTrue:[^ self].

    round := 0.
    needRetry := true.
    symCodeSize := symbolicCodeArray size.
    ShareCode ifTrue:[
        codeBytes := self checkForCommonCode:symbolicCodeArray.
        codeBytes notNil ifTrue:[
            ^ self
        ].
    ].
    codeSize := symCodeSize.

    [needRetry] whileTrue:[
        stackDepth := 0.
        maxStackDepth := 0.

        codeBytes := ByteArray uninitializedNew:codeSize.
        relocInfo := Array basicNew:(codeSize + 1).
        symIndex := 1.
        codeIndex := 1.

        needRetry := false.
        round := round + 1.

        [symIndex <= symCodeSize] whileTrue:[
            relocInfo at:symIndex put:codeIndex.

            codeSymbol := symbolicCodeArray at:symIndex.
            symIndex := symIndex + 1.
            stackDelta := 0.
            extra := extraLiteral := extraOP := nil.
            lineno := false.

            self appendByteCodeFor:codeSymbol.
            extraOP notNil ifTrue:[
                self appendByte:extraOP.
                symIndex := symIndex + 1.
            ].

            extraLiteral notNil ifTrue:[
                self addLiteral:extraLiteral
            ].

            lineno ifTrue:[
                "the instruction requires a line number byte"
                self appendByte:((symbolicCodeArray at:symIndex) min:255).
                symIndex := symIndex + 1.
                codeSymbol == #lineno16 ifTrue:[
                    self appendByte:((symbolicCodeArray at:symIndex) min:255).
                    symIndex := symIndex + 1
                ]
            ].

            extra notNil ifTrue:[
                nextSym := symbolicCodeArray at:symIndex.

                (extra == #number) ifTrue:[
                    index := nextSym.
                    symIndex := symIndex + 1.
                    self appendSignedByte:index

                ] ifFalse:[ (extra == #number16) ifTrue:[
                    index := nextSym.
                    symIndex := symIndex + 2.
                    self appendSignedWord:index

                ] ifFalse:[ (extra == #unsigned16) ifTrue:[
                    index := nextSym.
                    symIndex := symIndex + 2.
                    self appendWord:index

                ] ifFalse:[ (extra == #unsigned32) ifTrue:[
                    index := nextSym.
                    symIndex := symIndex + 4.
                    self appendLongWord:index

                ] ifFalse:[ (extra == #index) ifTrue:[
                    index := nextSym.
                    symIndex := symIndex + 1.
                    self appendByte:index

                ] ifFalse:[ (extra == #lit) ifTrue:[
                    index := self addLiteral:nextSym.
                    symIndex := symIndex + 1.
                    self appendByte:index

                ] ifFalse:[ (extra == #speciallit) ifTrue:[
                    index := self addLiteral:nextSym.
                    index > 255 ifTrue:[
                        self codeGeneratorError:'too many globals (' ,
                                        (symbolicCodeArray at:symIndex) ,
                                        ' index=' , index printString ,
                                        ') in method - please simplify'.
                        ^ #Error
                    ].
                    symIndex := symIndex + 1.
                    self appendByte:index.

                ] ifFalse:[ (extra == #speciallitS) ifTrue:[
                    index := nextSym.
                    symIndex := symIndex + 1.
                    self appendByte:index.

                ] ifFalse:[ (extra == #speciallitL) ifTrue:[
                    index := nextSym.
                    symIndex := symIndex + 2.
                    self appendWord:index.

                ] ifFalse:[ (extra == #offset) ifTrue:[
                    relocInfo at:symIndex put:codeIndex.
                    self addReloc:symIndex.
                    symIndex := symIndex + 1.
                    self appendByte:0

                ] ifFalse:[ (extra == #indexLevel) ifTrue:[
                    index := nextSym.
                    symIndex := symIndex + 1.
                    self appendByte:index.
                    level := symbolicCodeArray at:symIndex.
                    symIndex := symIndex + 1.
                    self appendByte:level

                ] ifFalse:[ (extra == #offsetNvarNarg) ifTrue:[
                    relocInfo at:symIndex put:codeIndex.
                    self addReloc:symIndex.
                    symIndex := symIndex + 1.
                    self appendEmptyByte.
                    nvars := symbolicCodeArray at:symIndex.
                    symIndex := symIndex + 1.
                    self appendByte:nvars.
                    level := symbolicCodeArray at:symIndex.
                    symIndex := symIndex + 1.
                    self appendByte:level

                ] ifFalse:[ (extra == #absoffset) ifTrue:[
                    relocInfo at:symIndex put:codeIndex.
                    self addReloc:symIndex.
                    addr := symbolicCodeArray at:symIndex.
                    symIndex := symIndex + 1.
                    self appendWord:addr.

                ] ifFalse:[ (extra == #absoffsetNvarNarg) ifTrue:[
                    relocInfo at:symIndex put:codeIndex.
                    self addReloc:symIndex.
                    addr := symbolicCodeArray at:symIndex.
                    symIndex := symIndex + 1.
                    self appendWord:addr.
                    nvars := symbolicCodeArray at:symIndex.
                    symIndex := symIndex + 1.
                    self appendByte:nvars.
                    level := symbolicCodeArray at:symIndex.
                    symIndex := symIndex + 1.
                    self appendByte:level

                ] ifFalse:[ (extra == #special) ifTrue:[
                    ((codeSymbol == #send)
                     or:[codeSymbol == #sendSelf
                     or:[codeSymbol == #superSend]]) ifTrue:[
                        index := nextSym.
                        symIndex := symIndex + 1.
                        nargs := symbolicCodeArray at:symIndex.
                        symIndex := symIndex + 1.
                        self appendByte:nargs.
                        self appendByte:index.

                        (codeSymbol == #superSend) ifTrue:[
                            index := symbolicCodeArray at:symIndex.
                            symIndex := symIndex + 1.
                            self appendByte:index
                        ].
                        stackDelta := nargs negated.
                        codeSymbol == #sendSelf ifTrue:[
                            stackDelta := stackDelta + 1
                        ]
                    ] ifFalse:[ (codeSymbol == #sendDrop) ifTrue:[
                        index := nextSym.
                        symIndex := symIndex + 1.
                        nargs := symbolicCodeArray at:symIndex.
                        symIndex := symIndex + 1.
                        self appendByte:nargs.
                        self appendByte:index.
                        stackDelta := (nargs + 1) negated
                    ]]

                ] ifFalse:[ (extra == #specialL) ifTrue:[
                    ((codeSymbol == #sendL)
                     or:[codeSymbol == #sendDropL
                     or:[codeSymbol == #sendSelfL
                     or:[codeSymbol == #superSendL]]]) ifTrue:[
                        index := nextSym.
                        symIndex := symIndex + 2.
                        nargs := symbolicCodeArray at:symIndex.
                        symIndex := symIndex + 1.
                        self appendByte:nargs.
                        self appendWord:index.
                        (codeSymbol == #superSendL) ifTrue:[
                            index := symbolicCodeArray at:symIndex.
                            symIndex := symIndex + 2.
                            self appendWord:index.
                        ].
                        stackDelta := nargs negated.
                        codeSymbol == #sendSelfL ifTrue:[
                            stackDelta := stackDelta + 1
                        ]
                    ]
                ] ifFalse:[ (extra == #specialSend) ifTrue:[
                    index := nextSym.
                    symIndex := symIndex + 1.
                    self appendByte:index.

                ] ifFalse:[ (extra == #specialVL) ifTrue:[
                    ((codeSymbol == #sendVL)
                     or:[codeSymbol == #superSendVL]) ifTrue:[
                        index := nextSym.
                        symIndex := symIndex + 4.
                        nargs := symbolicCodeArray at:symIndex.
                        symIndex := symIndex + 1.
                        self appendByte:nargs.
                        self appendLongWord:index.
                        (codeSymbol == #superSendVL) ifTrue:[
                            index := symbolicCodeArray at:symIndex.
                            symIndex := symIndex + 4.
                            self appendLongWord:index.
                        ].
                        stackDelta := nargs negated.
                    ]
                ] ifFalse:[
                    "/ self halt:'internal error'

                ]]]]]]]]]]]]]]]]]]
            ].

            stackDepth := stackDepth + stackDelta.
            (stackDepth > maxStackDepth) ifTrue:[
                maxStackDepth := stackDepth
            ]
        ].
        relocInfo at:symIndex put:codeIndex.

        needRetry ifFalse:[
            "
             now relocate - returns true if ok, false if we have to do it again
             (when short jumps have been changed to long jumps)
            "
            relocList notNil ifTrue:[
                needRetry := (self relocateWith:symbolicCodeArray relocInfo:relocInfo) not.
                "
                 if returned with false, a relative jump was made into
                 an absolute jump - need to start over with one more byte space
                "
                needRetry ifTrue:[
                    relocList := nil.
                    codeSize := codeSize + 1.
                ]
            ]
        ] ifTrue:[
            'Compiler [info]: compiling again ...' infoPrintCR.
        ]
    ].
    "code printNL."
    ^ errorFlag

    "Modified: 3.9.1995 / 12:59:43 / claus"
    "Modified: 10.1.1997 / 15:17:51 / cg"
!

genSpecialStatement:selector on:codeStream
    "/ generate: thisContext selector (to force a context).

    (StatementNode
	expression:(UnaryNode receiver:(VariableNode type:#ThisContext context:contextToEvaluateIn)
			      selector:selector))
	    codeForSideEffectOn:codeStream inBlock:nil for:self.
!

genSymbolicCode
    "traverse the parse-tree producing symbolicCode - return the codeArray"

    |codeStream code thisStatement lastStatement|

    litArray := nil.
    codeStream := WriteStream on:(OrderedCollection new:100).

    primitiveContextInfo notNil ifTrue:[
        (primitiveContextInfo includes:('exception:' -> #unwind)) ifTrue:[
            self genSpecialStatement:#markForUnwind on:codeStream
        ].
        (primitiveContextInfo includes:('exception:' -> #handle)) ifTrue:[
            self genSpecialStatement:#markForHandle on:codeStream
        ].
        (primitiveContextInfo includes:('exception:' -> #raise)) ifTrue:[
            self genSpecialStatement:#markForRaise on:codeStream
        ].
    ].

    self startCodeGenerationHookOn:codeStream.
    self generateVariables:methodVars on:codeStream.

    (tree notNil and:[tree isMethodNode]) ifTrue:[
        "kludge for VW compat."
        tree codeForSideEffectOn:codeStream inBlock:nil for:self.
        lastStatement := tree statements last.
    ] ifFalse:[
        thisStatement := tree.
        [thisStatement notNil] whileTrue:[
            lastStatement := thisStatement.
            thisStatement codeForSideEffectOn:codeStream inBlock:nil for:self.
            thisStatement := thisStatement nextStatement
        ].
    ].

    (lastStatement isNil or:[lastStatement isReturnNode not])
    ifTrue:[
        "not a return - add retSelf"
        "
         if the last statement was a send for side-effect,
         replace the previous drop by a retSelf.
         In this case we have to keep an extra retSelf bacause
         it could be a jump target.
        "
        (lastStatement notNil
         and:[(code := codeStream contents) notNil
         and:[code size > 0
         and:[code last == #drop]]]) ifTrue:[
            codeStream backStep.
            codeStream nextPut:#retSelf
        ].
        codeStream nextPut:#retSelf
    ].
    ^ codeStream contents

    "Modified: / 15-08-1996 / 17:35:02 / stefan"
    "Modified: / 06-08-2006 / 15:03:14 / cg"
!

generateVariables:varCollection on:codeStream
    varCollection isNil ifTrue:[^ self].

    varCollection do:[:eachVar |
	eachVar type notNil ifTrue:[
	    "/ generate code to set it up.

	    (AssignmentNode
		variable:(self nodeForMethodVariable:eachVar name)
		expression:(eachVar expressionForSetup))
		    codeForSideEffectOn:codeStream inBlock:nil for:self.
	]
    ]
!

relocateWith:symbolicCodeArray relocInfo:relocInfo
    "helper for genByteCodeFrom - relocate code using relocInfo.
     if relocation fails badly (due to long relative jumps) patch
     symbolicCode to use absolute jumps instead and return false
     (genByteCodeFrom will then try again). Otherwise return true.
     Also, on the fly, jumps to jumps and jumps to return are handled."

    |delta       "{Class: SmallInteger }"
     codePos     "{Class: SmallInteger }"
     opCodePos   "{Class: SmallInteger }"
     codeOffset  "{Class: SmallInteger }"
     symOffset
     opcode      "{Class: SmallInteger }"
     dstOpcode jumpTarget
     jumpCode deleteSet|

    deleteSet := OrderedCollection new.
    relocList do:[:sIndex |
        "have to relocate symCode at sIndex ..."
        symOffset := symbolicCodeArray at:sIndex.   "the target in the symbolic code"
        codePos := relocInfo at:sIndex.             "position of the offet in byte code"
        codeOffset := relocInfo at:symOffset.       "position of the target in byte code"
        delta := codeOffset - codePos - 1.
        opCodePos := codePos - 1.
        opcode := codeBytes at:opCodePos.

        (opcode between:190 and:199) ifTrue:[
            "an absolute jump/makeBlock"

            codeBytes at:codePos put:(codeOffset bitAnd:16rFF).
            codeBytes at:(codePos + 1) put:(codeOffset bitShift:-8)
        ] ifFalse:[
            "get jump-code from long and vlong codes"
            (opcode between:50 and:59) ifFalse:[
                (opcode between:60 and:69) ifTrue:[
                    opcode := opcode - 10
                ] ifFalse:[
                    (opcode between:70 and:79) ifTrue:[
                        opcode := opcode - 20
                    ] ifFalse:[
                        self codeGeneratorError:'invalid code to relocate'
                    ]
                ].
            ].

            "optimize jump to return and jump to jump"

            (opcode == 54) ifTrue:[
                "a jump"
                dstOpcode := symbolicCodeArray at:symOffset.

                (#(retSelf retTop retNil retTrue retFalse ret0 "blockRetTop") includes:dstOpcode) ifTrue:[
                    "a jump to a return - put in the return instead jump"

                    symbolicCodeArray at:(sIndex - 1) put:dstOpcode.
                    symbolicCodeArray at:sIndex put:dstOpcode.
                    codeBytes at:opCodePos put:(self byteCodeFor:dstOpcode).
                    delta := 0.
                    deleteSet add:sIndex.

"
'jump to return at: ' print. (sIndex - 1) printNL.
"
                ] ifFalse:[
                    (dstOpcode == #jump) ifTrue:[
                        "jump to jump to be done soon"
                        jumpTarget := symbolicCodeArray at:(symOffset + 1).
"
'jump to jump at: ' print. (sIndex - 1) print.
'  newTarget:' print. jumpTarget printNL.
"

                        symbolicCodeArray at:sIndex put:jumpTarget.
                        symOffset := jumpTarget.
                        codeOffset := relocInfo at:symOffset.
                        delta := codeOffset - codePos - 1.

                        "continue with new delta"
                    ]
                ]
            ].
            (#[50 51 52 53 56 57 58 59] includes:opcode) ifTrue:[
                "a conditional jump"

                dstOpcode := symbolicCodeArray at:symOffset.
                (dstOpcode == #jump) ifTrue:[
                    "conditional jump to unconditional jump"
                    jumpTarget := symbolicCodeArray at:(symOffset + 1).
"
'cond jump to jump at: ' print. (sIndex - 1) print.
'  newTarget:' print. jumpTarget printNL.
"

                    symbolicCodeArray at:sIndex put:jumpTarget.
                    symOffset := jumpTarget.
                    codeOffset := relocInfo at:symOffset.
                    delta := codeOffset - codePos - 1.

                    "continue with new delta"
                ].
            ].

            (delta >= 0) ifTrue:[
                (delta > 127) ifTrue:[
                    (opcode between:50 and:59) ifFalse:[
                        self codeGeneratorError:'invalid code to relocate'
                    ] ifTrue:[
                        (delta > 255) ifTrue:[
                            "change jmp into vljmp ..."
                            codeBytes at:opCodePos put:(opcode + 20).
                            delta := delta - 256
                        ] ifFalse:[
                            "change jmp into ljmp ..."
                            codeBytes at:opCodePos put:(opcode + 10).
                            delta := delta - 128
                        ].
                        (delta > 127) ifTrue:[
                            "change symbolic into a jump absolute and fail"
                            jumpCode := symbolicCodeArray at:(sIndex - 1).
                            symbolicCodeArray at:(sIndex - 1) put:(self absJumpFromJump:jumpCode).
                            symbolicCodeArray at:sIndex put:symOffset.
"
'change short into abs jump' printNL.
"
                            deleteSet do:[:d | relocList remove:d].
                            ^ false
                        ]
                    ].
                ].
                codeBytes at:codePos put:delta
            ] ifFalse:[
                (delta < -128) ifTrue:[
                    (opcode between:50 and:59) ifFalse:[
                        self codeGeneratorError:'invalid code to relocate'
                    ] ifTrue:[
                        (delta < -256) ifTrue:[
                            "change jmp into vljmp ..."
                            codeBytes at:opCodePos put:(opcode + 20).
                            delta := delta + 256
                        ] ifFalse:[
                            "change jmp into ljmp ..."
                            codeBytes at:opCodePos put:(opcode + 10).
                            delta := delta + 128
                        ].
                        (delta < -128) ifTrue:[
                            "change symbolic into a jump absolute and fail"
                            jumpCode := symbolicCodeArray at:(sIndex - 1).
                            symbolicCodeArray at:(sIndex - 1) put:(self absJumpFromJump:jumpCode).
                            symbolicCodeArray at:sIndex put:symOffset.
"
'change short into abs jump' printNL.
"
                            deleteSet do:[:d | relocList remove:d].
                            ^ false
                        ]
                    ]
                ].
                codeBytes at:codePos put:(256 + delta)
            ]
        ]
    ].
    self errorFlag ifTrue:[
        self codeGeneratorError:'relocation range error'
    ].
    ^ true
! !

!ByteCodeCompiler methodsFor:'code generation helpers'!

absJumpFromJump:code
    "given a jump-symbolic code, return corresponding absolute jump"

    JumpToAbsJump isNil ifTrue:[
	JumpToAbsJump := IdentityDictionary new.
	JumpToAbsJump at:#jump put:#jumpabs.
	JumpToAbsJump at:#trueJump put:#trueJumpabs.
	JumpToAbsJump at:#falseJump put:#falseJumpabs.
	JumpToAbsJump at:#nilJump put:#nilJumpabs.
	JumpToAbsJump at:#notNilJump put:#notNilJumpabs.
	JumpToAbsJump at:#eqJump put:#eqJumpabs.
	JumpToAbsJump at:#notEqJump put:#notEqJumpabs.
	JumpToAbsJump at:#zeroJump put:#zeroJumpabs.
	JumpToAbsJump at:#notZeroJump put:#notZeroJumpabs.
	JumpToAbsJump at:#makeBlock put:#makeBlockabs.
    ].
    ^ JumpToAbsJump at:code
!

addLiteral:anObject
    "add a literal to the literalArray - watch for and eliminate
     duplicates. return the index of the literal in the Array"

    |index oldLit class sharable sharableValue|

    litArray isNil ifTrue:[
        litArray := OrderedCollection with:anObject.
        ^ 1
    ].

    sharable := sharableValue := false.
    class := anObject class.
    class == Symbol
        ifTrue:[ sharable := true ]
        ifFalse:[
            anObject isImmutable ifTrue:[
                sharable := true
            ] ifFalse:[    
                ((class == String) or:[class == Array or:[class == ByteArray]]) ifTrue:[
                    anObject isEmpty ifTrue:[
                        sharable := true
                    ]
                ] ifFalse:[
                    ((class == Float) or:[class == Fraction or:[class == LargeInteger]]) ifTrue:[
                        sharableValue := true
                    ]
                ]
            ].
        ].

    (sharable not and:[sharableValue not]) ifTrue:[
        litArray add:anObject.
        index := litArray size.
        ^ index.
    ].

    "/ searching a dictionary is *much* faster; the code below starts to
    "/ keep track of literals whenever we have collected more than a threshold
    allLiterals notNil ifTrue:[
        sharable ifTrue:[
            index := allLiterals at:anObject ifAbsent:nil.
            index isNil ifTrue:[
                litArray add:anObject.
                index := litArray size.
                allLiterals at:anObject put:index.
                ^ index.
            ].
            (litArray at:index) class ~~ anObject class ifTrue:[
                index := nil.
            ].
        ].
    ].
    index isNil ifTrue:[
        index := litArray identityIndexOf:anObject.
    ].
    (index == 0) ifTrue:[
        "
         reuse constants if same value and same class
        "
        ((class == Float)
        or:[class == Fraction
        or:[class == LargeInteger
        "or:[class == String] --only if literalString option has been added---" ]]) ifTrue:[
            index := litArray indexOf:anObject.
            index ~~ 0 ifTrue:[
                oldLit := litArray at:index.
                oldLit class == class ifFalse:[
                    index := 0.
                ] ifTrue:[
                    "/ don't mess up negative with positive zeros
                    anObject = 0.0 ifTrue:[
                        anObject isNegativeZero ~~ oldLit isNegativeZero ifTrue:[
                            index := 0
                        ]
                    ]
                ].
            ].
        ].

        "
         reuse empty collection literals
        "
        ((class == String) or:[class == Array or:[class == ByteArray]]) ifTrue:[
            anObject size == 0 ifTrue:[
                index := litArray indexOf:anObject.
                index ~~ 0 ifTrue:[
                    oldLit := litArray at:index.
                    oldLit class == class ifFalse:[
                        index := 0.
                    ]
                ]
            ]
        ].

        (index == 0) ifTrue:[
            litArray add:anObject.
            index := litArray size.
            index > 30 ifTrue:[
                allLiterals isNil ifTrue:[
                    allLiterals := Dictionary new.
                    litArray keysAndValuesDo:[:idx :lit | allLiterals at:lit put:idx].
                ].
                allLiterals at:anObject put:index.
            ].
        ].
    ].

    ^ index

    "Modified: / 12.11.1997 / 18:49:43 / cg"
!

addReloc:symIndex
    "remember to relocate offset at symIndex later ..."

    relocList isNil ifTrue:[
	relocList := OrderedCollection new.
    ].
    relocList add:symIndex
!

addTempVar
    "add a temporary variable; return its position (1-based).
     Used when a block with args/locals is inlined."

    numTemp isNil ifTrue:[numTemp := maxNumTemp := 0].
    numTemp := numTemp + 1.
    maxNumTemp := maxNumTemp max:numTemp.
    ^ numTemp + methodVars size

    "Modified: 26.6.1997 / 10:22:23 / cg"
!

appendByte:aByte
    "append a byte to the code-Array, checking for byte-range (debug-only)"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    (aByte between:0 and:255) ifTrue:[
        codeBytes at:idx put:aByte.
        codeIndex := idx + 1
    ] ifFalse:[
        self codeGeneratorError:'byte range error'.
    ]
!

appendByteCodeFor:codeSymbol
    "append the byteCode for an instructionSymbol to the code-Array"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    codeBytes at:idx put:(self byteCodeFor:codeSymbol).
    codeIndex := idx + 1
!

appendEmptyByte
    "append an empty byte to the code-Array"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    codeBytes at:idx put:0.
    codeIndex := idx + 1
!

appendEmptyLong
    "append an empty long (4 bytes) to the code-Array"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    codeBytes at:idx put:0.
    codeBytes at:idx+1 put:0.
    codeBytes at:idx+2 put:0.
    codeBytes at:idx+3 put:0.
    codeIndex := idx + 4
!

appendEmptyShort
    "append an empty short (2 bytes) to the code-Array"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    codeBytes at:idx put:0.
    codeBytes at:idx+1 put:0.
    codeIndex := idx + 2
!

appendLongWord:aWord
    "append an unsigned long word (low-high) to the code-Array,
     checking for long word-range (debug-only)"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    (aWord between:0 and:16rFFFFFFFF) ifTrue:[
        codeBytes at:idx put:(aWord bitAnd:16rFF).
        idx := idx + 1.
        codeBytes at:idx put:((aWord bitShift:-8) bitAnd:16rFF).
        idx := idx + 1.
        codeBytes at:idx put:((aWord bitShift:-16) bitAnd:16rFF).
        idx := idx + 1.
        codeBytes at:idx put:((aWord bitShift:-24) bitAnd:16rFF).
        codeIndex := idx + 1
    ] ifFalse:[
        self codeGeneratorError:'long word range error'.
    ]
!

appendSignedByte:aByte
    "append a signedbyte (as in jump-offsets) to the code-Array,
     check range and report an error if invalid"

    |b   "{Class: SmallInteger }"
     idx "{Class: SmallInteger }"|

    idx := codeIndex.
    b := aByte.
    (b >= 0) ifTrue:[
        (b > 127) ifTrue:[
            self codeGeneratorError:'jump-range error'.
        ].
        codeBytes at:idx put:b
    ] ifFalse:[
        (b < -128) ifTrue:[
            self codeGeneratorError:'jump-range error'.
        ].
        b := 256 + b
    ].
    codeBytes at:idx put:b.
    codeIndex := idx + 1
!

appendSignedWord:aWord
    "append a signed word to the code-Array,
     check range and report an error if invalid"

    |w   "{Class: SmallInteger }"|

    w := aWord.
    (w >= 0) ifTrue:[
        (w > 16r7FFFF) ifTrue:[
            self codeGeneratorError:'word-range error'.
        ].
    ] ifFalse:[
        (w < 16r-8000) ifTrue:[
            self codeGeneratorError:'word-range error'.
        ].
        w := (16r10000 + w).
    ].
    self appendWord:w
!

appendWord:aWord
    "append an unsigned word (low-high) to the code-Array,
     checking for word-range (debug-only)"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    (aWord between:0 and:16rFFFF) ifTrue:[
        codeBytes at:idx put:(aWord bitAnd:16rFF).
        idx := idx + 1.
        codeBytes at:idx put:(aWord bitShift:-8).
        codeIndex := idx + 1
    ] ifFalse:[
        self codeGeneratorError:'word range error'.
    ]
!

nameSpaceSelectorFor:aSymbol
    "Caring for the current namespace, return the real selector used for a send."

    |ns usedSym|

    usedSym := aSymbol.

    Smalltalk hasSelectorNameSpaces ifTrue:[
        ns := self currentNameSpace.
        (ns notNil and:[ns ~~ Smalltalk]) ifTrue:[
            usedSym := (':',ns name,'::',aSymbol) asSymbol.
            Transcript showCR:'compile ',aSymbol,' as ',usedSym.
        ].
    ].
    ^ usedSym.

    "Created: / 05-03-2007 / 13:28:59 / cg"
!

removeTempVar
    "remove a temporary variable"

    numTemp := numTemp - 1

    "Created: 25.6.1997 / 14:03:00 / cg"
    "Modified: 25.6.1997 / 15:06:10 / cg"
! !

!ByteCodeCompiler methodsFor:'code generation hooks'!

startCodeGenerationHookOn:codeStream
    "invoked before code is generated;
     gives subclasses a chance to prepare and to inject code to be
     executed on entry (instrumentation)"

    "intentionally left blank - hook for subclasses"

    "Modified (comment): / 30-09-2011 / 12:16:40 / cg"
! !

!ByteCodeCompiler methodsFor:'compilation'!

compile:aString forClass:aClass inCategory:cat
    "compile a source-string for a method in classToCompileFor.
     The method will get cat as category.
     Returns the new method, #Error or nil."

    ^ self
        compile:aString
        forClass:aClass
        inCategory:cat
        notifying:nil
        install:true
        skipIfSame:false
        silent:false
        foldConstants:true

    "Created: / 30-09-2011 / 12:44:50 / cg"
!

compile:aStringArg forClass:aClassArg inCategory:cat notifying:aRequestor
                 install:install skipIfSame:skipIfSame silent:silent foldConstants:fold

    aRequestor notNil ifTrue:[
        ^ self
            compile:aStringArg 
            forClass:aClassArg 
            inCategory:cat 
            notifying:aRequestor
            install:install 
            skipIfSame:skipIfSame 
            silent:silent 
            foldConstants:fold
            ifFail:nil
    ].

    ^ self
        compile:aStringArg 
        forClass:aClassArg 
        inCategory:cat 
        notifying:aRequestor
        install:install 
        skipIfSame:skipIfSame 
        silent:silent 
        foldConstants:fold
        ifFail:[:exOrNil |
                 exOrNil notNil ifTrue:[
                    ParseError new
                        errorMessage:(exOrNil errorMessage) startPosition:(exOrNil startPosition) endPosition:(exOrNil endPosition);
                        parameter:exOrNil parameter;
                        lineNumber:exOrNil lineNumber;
                        raiseRequest.
                 ] ifFalse:[
                     ParseError raiseRequestErrorString:'compilation failed'. #Error 
                 ].
                 (install and:[selector notNil]) ifTrue:[
                     |newMethod|

                      "/ if proceeded, install a trap method
                     newMethod := (Method trapMethodForNumArgs:selector numArgs) copy.
                     newMethod mclass:nil; setPackage:nil.
                     newMethod makeInvalid.
                     newMethod source:aStringArg.
                     aClassArg basicAddSelector:selector withMethod:newMethod
                 ].
        ]

    "Modified: / 18-01-2011 / 11:35:21 / cg"
!

compile:sourceCodeStringArg forClass:aClassArg inCategory:cat notifying:aRequestor
                install:install skipIfSame:skipIfSame silent:silent foldConstants:fold
                ifFail:failBlock

    "the basic workhorse method for compiling:
     compile a source-string for a method in classToCompileFor.
     errors are forwarded to requestor
     (report on Transcript and return the value of failBlock, if requestor is nil).

     The new method will get cat as category.
     If install is true, the method will go into the classes method-table,
     otherwise the method is simply returned (for anonymous methods).
     If skipIsSame is true, and the source is the same as an existing
     methods source, this is a noop (for fast fileIn).
     The argument, silent controls if errors are to be reported.
     Returns the method, #Error or nil."

    |newMethod tree symbolicCodeArray oldMethod silencio newSource primNr keptOldCode answer
     aClass sourceCodeString hasErrorInMethodHeader oldCategory newCategory oldPackage 
     newPackage installSelector ns dialogText failureReason annotationCategory|

    aClass := aClassArg.
    sourceCodeString := sourceCodeStringArg.

    sourceCodeString isNil ifTrue:[^ nil].
    silencio := silent
                or:[Smalltalk silentLoading
                or:[ListCompiledMethods not]].

    "/ when a correction has been made, this signal is raised to try again    
    self class restartCompilationSignal handle:[:ex |
        "/ class could have changed ...
        aClass := self classToCompileFor.
        sourceCodeString := self correctedSource ? sourceCodeStringArg.
        methodArgs := methodArgNames := methodVars := methodVarNames := nil.
        usedInstVars := usedClassVars := usedVars := nil.
        modifiedInstVars := modifiedClassVars := modifiedGlobals := nil.
        currentBlock := nil.
        ex restart
    ] do:[
        ParseError handle:[:ex |
            failBlock isNil ifTrue:[
                ex reject
            ].
            self showErrorMessageForClass:aClass.
            ^ failBlock valueWithOptionalArgument:ex.
        ] do:[
            "create a compiler, let it parse and create the parsetree"

            sourceCodeString isString ifTrue:[
                self source:(ReadStream on:sourceCodeString string).
            ] ifFalse:[
                self source:sourceCodeString readStream
            ].    
            self nextToken.

            self setClassToCompileFor:aClass.

            self parseForCode.
            fold ifFalse:[self foldConstants:nil].
            self notifying:aRequestor.
            silent ifTrue:[
                "/ self ignoreErrors:true.
                self ignoreWarnings:true.
                self warnUndeclared:false.
            ].

            hasErrorInMethodHeader := (self parseMethodSpec == #Error).
            hasErrorInMethodHeader ifTrue:[
                self parseError:'syntax error in method specification'.
                tree := #Error.
            ] ifFalse:[
                tree := self parseMethodBody.
                tree == #Error ifFalse:[
                    self checkForEndOfInput.
                    self tree:tree.
                ].
            ].
        ].
    ].

    hasErrorInMethodHeader ifTrue:[
        self showErrorMessageForClass:aClass.
        ^ failBlock value.
    ].

    (aClass notNil and:[selector notNil]) ifTrue:[
        oldMethod := aClass compiledMethodAt:selector.
        oldMethod notNil ifTrue:[
            oldCategory := oldMethod category.
            oldPackage  := oldMethod package.
        ].
    ].

    (aClass notNil and:[aClass owningClass notNil
     and:[parserFlags allowExtensionsToPrivateClasses not]]) ifTrue:[
        "inherit private classe's package from owning class"
        newPackage := aClass owningClass package
    ] ifFalse:[
        (aRequestor respondsTo:#packageToInstall) ifTrue:[
            "if there is an requestor who knows about the package, use it"
            newPackage := aRequestor packageToInstall
        ] ifFalse:[
            "if noone answers our package query, do not use the default
             but use an existing method's package instead"
            (oldPackage isNil or:[Class packageQuerySignal isHandled]) ifTrue:[
                newPackage := Class packageQuerySignal query.
            ] ifFalse:[
                newPackage := oldPackage.
            ].
        ].
    ].

    newCategory := cat.
    newCategory isNil ifTrue:[
        newCategory := oldCategory ? (self class asYetUncategorizedMethodCategory).
    ].

    "check if same source"
    (skipIfSame and:[oldMethod notNil and:[oldMethod source = sourceCodeString]]) ifTrue:[
        oldMethod isInvalid ifFalse:[
            silencio ifFalse:[
                Transcript showCR:('    unchanged: ',aClass name,' ',selector)
            ].
            "
             same. however, category may be different
            "
            (newCategory ~= oldCategory) ifTrue:[
                oldMethod category:newCategory.
"/                                aClass updateRevisionString.
                silencio ifFalse:[
                    Transcript showCR:('    (category change only)')
                ].
            ].
            "
             and package may be too.
            "
            (newPackage notNil and:[newPackage ~~ oldPackage]) ifTrue:[
                oldMethod package:newPackage.
                silencio ifFalse:[
                    Transcript showCR:('    (package-id change only)')
                ].
            ].
            ^ oldMethod
        ]
    ].

    (self errorFlag or:[tree == #Error]) ifTrue:[
        "error in method body"
        self showErrorMessageForClass:aClass.
        ^ failBlock value
    ].

    "if no error and also no selector ..."
    selector isNil ifTrue:[
        "... it was just a comment or other empty stuff"
        ^ nil
    ].

    "
     freak-out support for inline C-code...
    "
    NewPrimitives ifFalse:[
        ((self hasNonOptionalPrimitiveCode
          or:[(self hasPrimitiveCode and:[self class canCreateMachineCode])
          or:[ParserFlags stcCompilation == #always and:[selector ~~ #doIt]]])
         and:[(ParserFlags stcCompilation ~~ #never)]) ifTrue:[
            ParseError handle:[:ex |
                self parseError:(ex description) line:(ex lineNumber ? 1).
                newMethod := #Error.
            ] do:[
                newMethod :=
                    (STCCompilerInterface new
                            originator:self;
                            parserFlags:parserFlags)
                        compileToMachineCode:sourceCodeString
                        forClass:aClass
                        selector:selector
                        inCategory:cat
                        notifying:aRequestor
                        install:install
                        skipIfSame:skipIfSame
                        silent:silent.
            ].

            newMethod == #Error ifTrue:[
                self showErrorMessageForClass:aClass.
                "/^ failBlock value
            ].

            (newMethod == #CannotLoad or:[newMethod == #Error]) ifTrue:[
                failureReason := newMethod.
                newMethod := self trappingStubMethodFor:sourceCodeString inCategory:newCategory.
                newMethod setPackage:newPackage.
                keptOldCode := false.
                install ifTrue:[
                    "/
                    "/ be very careful with existing methods
                    "/ (otherwise, you could easily make your system unusable in systems which cannot load)
                    "/
                    (oldMethod notNil and:[oldMethod code ~= newMethod code]) ifTrue:[
                        failureReason == #Error ifTrue:[
                            dialogText :=     
'STC-compilation of ''%1>>%2''
to machine code failed .

Shall I use the old methods functionality
or instead create a dummy trap method for it ?

Hint:
  if that method is needed by the system, you better leave the
  original functionality in the system.

Close this warnBox to abort the compilation.
'
                        ] ifFalse:[
                            dialogText :=     
'installation of binary code for ''%1>>%2''
is not possible or disabled.

Shall I use the old method''s functionality
or instead create a dummy trap method for it ?

Hint:
  if that method is needed by the system, you better leave the
  original functionality in the system.

Close this warnBox to abort the compilation.
'
                        ].
                        answer := Dialog
                                     confirmWithCancel:(dialogText bindWith:aClass name allBold with:selector allBold)
                                     labels:#('Cancel' 'Keep Old' 'Trap Code')
                                     default:2.
                        answer isNil ifTrue:[
                            ^ failBlock value
                        ].
                        answer == false ifTrue:[
                            newMethod code:(oldMethod code).
                            keptOldCode := true.
                        ].
                    ].
                    aClass addSelector:selector withMethod:newMethod
                ].
                (install or:[failureReason ~~ #CannotLoad]) ifTrue:[
                    "when compiling with STC andn install is false, #CannotLoad is always returned"
                    self showErrorNotification:(keptOldCode
                                                    ifTrue:['not really compiled - method still shows previous behavior']
                                                    ifFalse:['not compiled to machine code - created a stub instead.'])
                ].
            ].
            ^ newMethod
        ].

        self hasNonOptionalPrimitiveCode ifTrue:[
            "/
            "/ generate a trapping method, if primitive code is present
            "/
            newMethod := self trappingStubMethodFor:sourceCodeString inCategory:newCategory.
            install ifTrue:[
                aClass addSelector:selector withMethod:newMethod.
            ].
            self showErrorNotification:'not compiled to machine code - installed a stub instead.'.
            ^ newMethod
        ].
    ].

    primNr := self primitiveNumber.
    (NewPrimitives or:[primNr isNil]) ifTrue:[
        "
         produce symbolic code first
        "
        symbolicCodeArray := self genSymbolicCode.
        (symbolicCodeArray == #Error) ifTrue:[
            self showErrorNotification:'translation error'.
            ^ failBlock value
        ].

        "
         take this, producing bytecode
         (machine code will be made by the VM when first called)
        "
        ((self genByteCodeFrom:symbolicCodeArray) == #Error) ifTrue:[
            self showErrorNotification:'relocation error - code must be simplified'.
            ^ failBlock value
        ].
    ].

    "
     finally create the new method-object
    "
    newMethod := self createMethod.
    NewPrimitives ifTrue:[
        newMethod byteCode:(self code).
        primNr isNil ifTrue:[
            self hasNonOptionalPrimitiveCode ifTrue:[
                primNr := 0.
            ]
        ].
        primNr notNil ifTrue:[
            newMethod setPrimitiveNumber:primNr
        ]
    ] ifFalse:[
        primNr notNil ifTrue:[
            newMethod code:(self checkForPrimitiveCode:primNr).
        ] ifFalse:[
            newMethod byteCode:(self code).
        ].
    ].

    "
     if there where any corrections, install the updated source
    "
    (newSource := self correctedSource) isNil ifTrue:[
        newSource := sourceCodeString string.
    ].
    (newSource includes:Character return) ifTrue:[
        "/ see if it contains crlf's or only cr's
        newSource := self class stringWithSimpleCRs:newSource
    ].
    newMethod source:newSource string.
    (newMethod hasAnnotation: #'category:') ifTrue:[
        annotationCategory := (newMethod annotationAt:#'category:') argumentAt:1.
        annotationCategory isString ifTrue:[
            newCategory := annotationCategory
        ].
    ].
    newMethod setCategory:newCategory.
    newMethod setPackage:newPackage.

    (self contextMustBeReturnable) ifTrue:[
        newMethod contextMustBeReturnable:true
    ].
    install ifTrue:[
        installSelector := selector.
        "/ when adding an extension, care for the current namespace
        ns := self currentNameSpace.
        (ns notNil and:[ns ~~ Smalltalk]) ifTrue:[
            ns ~~ aClass nameSpace ifTrue:[
                installSelector := self nameSpaceSelectorFor:(selector asSymbol).
            ]
        ].

        aClass addSelector:installSelector withMethod:newMethod
    ].

    silencio ifFalse:[
        Transcript showCR:('    compiled: ', aClass name,' ', selector)
    ].

    ^ newMethod

    "Created: / 29-10-1995 / 19:59:36 / cg"
    "Modified: / 19-03-1999 / 08:31:09 / stefan"
    "Modified: / 05-07-2011 / 22:50:36 / cg"
!

compile:methodText forClass:aBehavior install:doInstall
    "compile a source-string for a method in classToCompileFor.
     The install-argument controls if the method is to be installed into the
     classes method-dictionary, or just to be compiled and a method object to be returned.
     Returns the new method, #Error or nil."

    ^ self
        compile:methodText
        forClass:aBehavior
        inCategory:(self class defaultMethodCategory)
        notifying:nil
        install:doInstall
        skipIfSame:false
        silent:false
        foldConstants:true
        ifFail:[ #Error ]

    "Created: / 17-07-2006 / 18:44:53 / cg"
!

compileTree:aTree forClass:aClass
    "given an already parsed AST, generate code and return a method"

    |newMethod|

    self tree:aTree.

    newMethod := self createMethod.
    newMethod byteCode:(self code).

    (self contextMustBeReturnable) ifTrue:[
        newMethod contextMustBeReturnable:true
    ].

    ^ newMethod

    "Modified: / 19-03-1999 / 08:31:09 / stefan"
    "Created: / 06-08-2006 / 03:25:39 / cg"
!

compileTree:aMethodNode forClass:aClass ifFail:failBlock
    "given an already parsed AST, generate code and return a method"

    |newMethod symbolicCodeArray|

    self tree:aMethodNode.

    selector := aMethodNode selector.
    methodArgs := aMethodNode arguments ? #().
    methodArgNames := methodArgs collect:[:eachVar | eachVar name].
    methodVars := aMethodNode locals ? #().
    methodVarNames := methodVars collect:[:eachVar | eachVar name].

    "
     produce symbolic code first
    "
    symbolicCodeArray := self genSymbolicCode.
    (symbolicCodeArray == #Error) ifTrue:[      "/ no longer happens
        self showErrorNotification:'translation error'.
        ^ failBlock value
    ].

    "
     take this, producing bytecode
     (someone willin' to make machine code :-)
    "
    ((self genByteCodeFrom:symbolicCodeArray) == #Error) ifTrue:[
        self showErrorNotification:'relocation error - code must be simplified'.
        ^ failBlock value
    ].

    newMethod := self createMethod.
    newMethod byteCode:(self code).

    (self contextMustBeReturnable) ifTrue:[
        newMethod contextMustBeReturnable:true
    ].

    ^ newMethod

    "Modified: / 19-03-1999 / 08:31:09 / stefan"
    "Created: / 06-08-2006 / 03:26:27 / cg"
    "Modified: / 06-08-2006 / 15:14:26 / cg"
!

showErrorNotification:message
    |messageText|

    messageText := message.
    selector notNil ifTrue:[
        messageText := selector ,' ', messageText.
    ].

    self class parseWarningSignal isHandled ifTrue:[
        self class parseWarningSignal new
                errorMessage:messageText;
                parameter:self;
                raiseRequest.
    ] ifFalse:[
        Transcript show:'***'.
        Transcript showCR:messageText.
    ].
! !

!ByteCodeCompiler methodsFor:'error handling'!

codeGeneratorError:aMessage
    CompilationError raiseRequestWith:self errorString:aMessage.
    errorFlag := true.
    ^ #Error
! !

!ByteCodeCompiler methodsFor:'machine code generation'!

trappingStubMethodFor:aString inCategory:cat
    "return a stub method which traps and reports an error whenever
     called."

    |newMethod|

    newMethod := self methodClass new:(litArray size).
    litArray notNil ifTrue:[
	newMethod literals:litArray
    ].

    newMethod makeUncompiled.
    newMethod numberOfVars:(self numberOfMethodVars).
    newMethod numberOfArgs:(self numberOfMethodArgs).
    newMethod source:aString string.
    newMethod setCategory:cat.
    ^ newMethod

    "Modified: / 1.8.1997 / 00:27:32 / cg"
    "Modified: / 18.3.1999 / 18:12:33 / stefan"
! !

!ByteCodeCompiler methodsFor:'queries'!

hasLineNumber:sel
    "return true, if special send code needs lineNr"

    (sel == #==) ifTrue:[^ false].
    (sel == #~~) ifTrue:[^ false].
    (sel == #class) ifTrue:[^ false].
    (sel == #isNil) ifTrue:[^ false].
    (sel == #notNil) ifTrue:[^ false].
    ^ true
!

isBuiltInSelector:sel forReceiver:receiver
    "return true, if selector sel is built-in.
     (i.e. there is a single bytecode for it)"

    (sel == #value)  ifTrue:[^ true].
    (sel == #value:) ifTrue:[^ true].
    (sel == #class)  ifTrue:[^ true].
    (sel == #size)   ifTrue:[^ true].
    (sel == #isNil)  ifTrue:[^ true].
    (sel == #notNil) ifTrue:[^ true].
    (sel == #not)    ifTrue:[^ true].

    (sel == #new)    ifTrue:[^ true].
    (sel == #basicNew) ifTrue:[
	"/ this one is critical - some redefine it
	receiver isGlobal ifTrue:[
	    (#('String' 'ByteArray' 'Array'
	       'Point' 'Rectangle' 'Object')
	    includes:receiver name) ifTrue:[^ true].
	].
    ].
    (sel == #basicNew:) ifTrue:[
	"/ this one is critical - some redefine it
	receiver isGlobal ifTrue:[
	    (#('String' 'ByteArray' 'Array'
	      'Point' 'Rectangle' 'Object')
	    includes:receiver name) ifTrue:[^ true].
	].
    ].

    sel == #== ifTrue:[^ true].
    sel == #~~ ifTrue:[^ true].
    sel == #=  ifTrue:[^ true].
    sel == #~= ifTrue:[^ true].
    sel == #+  ifTrue:[^ true].
    sel == #-  ifTrue:[^ true].
    sel == #<  ifTrue:[^ true].
    sel == #<= ifTrue:[^ true].
    sel == #>  ifTrue:[^ true].
    sel == #>= ifTrue:[^ true].
    sel == #*  ifTrue:[^ true].
    sel == #&  ifTrue:[^ true].
    sel == #|  ifTrue:[^ true].

    (sel == #at:)     ifTrue:[^ true].
    (sel == #at:put:) ifTrue:[^ true].
    (sel == #bitAnd:) ifTrue:[^ true].
    (sel == #bitOr:)  ifTrue:[^ true].
    (sel == #new:)    ifTrue:[^ true].

    ^ false

    "Created: 17.4.1996 / 22:32:16 / cg"
    "Modified: 4.6.1997 / 12:23:30 / cg"
!

isCompiling
    "return true if compiling code as opposed to evaluating"

    ^ true 
!

numberOfTempVars
    "return the number of additional temporary variables which
     were created from inlined blocks (valid after parsing)"

    ^ maxNumTemp ? 0

    "Created: 25.6.1997 / 13:54:29 / cg"
    "Modified: 25.6.1997 / 15:21:34 / cg"
!

specialGlobalCodeFor:aSymbol
    "codeExtension for globals,
     which can be accessed by specialGlobal opCode"

    |idx|

    idx := self specialGlobals identityIndexOf:aSymbol ifAbsent:nil.
    idx isNil ifTrue:[^ idx].
    ^ idx - 1.

    "Modified: 4.6.1997 / 12:31:22 / cg"
!

specialGlobals
    "list of globals which can be accessed by specialGlobal opCode;
     adding any here requires a new VM (i.e. you cannot change it)"

    ^ #(
        #Array                  "/ 0
        #String                 "/ 1
        #FloatArray             "/ 2
        #DoubleArray            "/ 3
        #Point                  "/ 4
        #Symbol                 "/ 5
        #Smalltalk              "/ 6
        #Processor              "/ 7
        #SmallInteger           "/ 8
        #Character              "/ 9
        #Float                  "/ 10
        #Process                "/ 11
        #Set                    "/ 12
        #IdentitySet            "/ 13
        #Dictionary             "/ 14
        #IdentityDictionary     "/ 15
        #Semaphore              "/ 16
        #OrderedCollection      "/ 17
       )

    "Created: 4.6.1997 / 12:17:47 / cg"
    "Modified: 4.6.1997 / 12:31:35 / cg"
!

specialSendCodeFor:sel
    "return the codeExtension for sends,
     which can be performed by specialSend opCode"

    |idx|

    idx := self specialSends identityIndexOf:sel ifAbsent:nil.
    idx isNil ifTrue:[^ idx].
    ^ idx - 1.

    "Modified: 4.6.1997 / 12:31:08 / cg"
!

specialSends
    "list of selectors which can be sent by specialSend opCode;
     adding any here requires a new VM (i.e. you cannot change it)"

    ^ #(
	#top                    "/ 0
	#bottom                 "/ 1
	#left                   "/ 2
	#right                  "/ 3
	#x                      "/ 4
	#y                      "/ 5
	#width                  "/ 6
	#height                 "/ 7
	#origin                 "/ 8
	#extent                 "/ 9
	#asInteger              "/ 10
	#rounded                "/ 11
	#next                   "/ 12
	#peek                   "/ 13
       )

    "Created: 4.6.1997 / 12:20:28 / cg"
    "Modified: 4.6.1997 / 12:31:56 / cg"
! !

!ByteCodeCompiler class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id $'
! !


ByteCodeCompiler initialize!
