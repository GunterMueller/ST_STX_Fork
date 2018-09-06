"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015-2017 Jan Vrany
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

Scanner subclass:#Parser
	instanceVariableNames:'classToCompileFor selfValue contextToEvaluateIn selector
		methodArgs methodArgNames methodVars methodVarNames tree
		currentBlock parseForCode readInstVars readClassVars readGlobals
		usedInstVars usedClassVars usedVars modifiedInstVars
		modifiedClassVars modifiedGlobals usesSuper usedGlobals
		usedSymbols messagesSent messagesPossiblySent messagesSentToSelf
		messagesSentToSuper localVarDefPosition evalExitBlock selfNode
		superNode nilNode hasPrimitiveCode hasNonOptionalPrimitiveCode
		primitiveNr primitiveResource logged warnedUndefVars
		warnedUnknownNamespaces correctedSource foldConstants
		lineNumberInfo currentNamespace currentUsedNamespaces methodNode
		alreadyWarnedClassInstVarRefs localBlockVarDefPosition
		endOfSelectorPosition beginOfBodyPosition startOfBlockPosition
		primitiveContextInfo usedLocalVars modifiedLocalVars
		alreadyWarnedUninitializedVars
		alreadyWarnedUnimplementedSelectors returnedValues currentPackage
		doItTemporaries moreSharedPools inFunctionCallArgument
		didWarnAboutSTXNameSpaceUse didWarnAboutSTXHereExtensionUsed
		parenthesisLevel didWarnAboutBadSupersend
		didWarnAboutSqueakExtensions allowUndeclaredVariables
		interactiveMode variableCorrectActionForAll annotations
		variableTypeOfLastCorrectAction usedPoolVars readPoolVars
		modifiedPoolVars warnings didWarnAboutSTXExtensions
		annotationStartPosition annotationEndPosition autoDefineVariables'
	classVariableNames:'PrevClass PrevInstVarNames PrevClassVarNames
		PrevClassInstVarNames LazyCompilation FoldConstants
		LineNumberInfo SuppressDoItCompilation ParseErrorSignal
		AlreadyWarnedUnimplementedSelectorsPerReceiverClass'
	poolDictionaries:''
	category:'System-Compiler'
!

Query subclass:#AskForVariableTypeOfUndeclaredQuery
	instanceVariableNames:'parser nameOfUnknownVariable'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Object subclass:#Correction
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Parser::Correction subclass:#CorrectByDeclaringIdentifierAs
	instanceVariableNames:'lastType'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Parser::Correction subclass:#CorrectByDeletingLocalIdentifier
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Parser::Correction subclass:#CorrectByGeneratingMissingMethod
	instanceVariableNames:'receiverNode selector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Parser::Correction subclass:#CorrectByGroupingMessage
	instanceVariableNames:'possibleSplits receiverNode selectorPositions'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Parser::Correction subclass:#CorrectByInsertingPeriod
	instanceVariableNames:'positionOfPeriod'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Parser::Correction subclass:#CorrectByInteractiveCorrection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Parser::Correction subclass:#CorrectByInteractiveRename
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Parser::Correction subclass:#CorrectByMakingValidHexConstant
	instanceVariableNames:'receiverNode selector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Parser::Correction subclass:#CorrectByChangingSelector
	instanceVariableNames:'receiverNode receiverClass selector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Object subclass:#ParsedAnnotation
	instanceVariableNames:'key arguments startPosition endPosition'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Query subclass:#PossibleCorrectionsQuery
	instanceVariableNames:'parser message'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Parser subclass:#PrimitiveSpecParser
	instanceVariableNames:'masterParser'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

Notification subclass:#RestartCompilationSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Parser
!

!Parser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015-2017 Jan Vrany
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
    Parser is used for both parsing and evaluating smalltalk expressions;
    it first builds a parseTree which is then interpreted (evaluate) or
    compiled. Compilation is done in the subclass ByteCodeCompiler and/or
    the (planned) MachineCodeCompiler.

    methods of main interest are:
        Parser evaluateExpression:...

    and:
        Parser parseExpression:...
        Parser parseMethod:...

    there is protocol to parse complete methods, selector specs, body only etc.

    Parser is also used to find the referenced/modified inst/classvars of
    a method - this is done by sending parseXXX message to a parser and asking
    the parser for referencedXVars or modifiedXVars (see SystemBrowser).

    You can also use parsers for all kinds of other things (ChangesBrowser for
    example analyzes the expressions in the changelist ...) by looking at the
    parsers tree. (Although this is somewhat dangerous, since it exports the
    compilers internals ... better style is to add specialized query methods here)

    One instance of Parser is created to parse one method or expression - i.e.
    its not suggested to reuse parsers.


  Constant folding:

    The parser has various modes for constant folding; by default, only numeric
    expressions involving integers and floats are constant folded
    (i.e. something like 'Float pi sin' or '1.5 + 0.3' will be reduced to a constant).

    Constant folding can be turned off completely (setting FoldConstants to nil)
    to ``secure folding'', which only folds constant numbers (#level1) or to #full.
    In full mode, more constant expressions are folded (for example: '1.0 @ 1.0' is
    reduced to a constant point), but the resulting code may not be compatible with other
    smalltalk systems (consider the case, where the point is modified using #x: or #y: messages).
    Therefore, this mode is a bit dangerous and disabled by default.
    The current implementation, base upon a global constant-folding setting is somewhat stupid
    and intermediate - a better solution would be to allow the optimization to be controlled
    by a method-pragma, since it may make sense to disable optimization on a method level,
    if it's known that the used constant objects are subject of modifications as described above.


  Immutable arrays:

    Immutable arrays are experimental and being evaluated.
    Consider the case of a method returning '#(1 2 3 4)', and that array being modified
    by some other method (using #at:put:). Since the array-return is actually a return of
    a reference to the compiler created array, the next invokation of the method will
    return the modified array. These are hard to find bugs.
    By an option, the compiler can generate immutable arrays, which don't allow modification
    of its elements. For clean code, you should enable this option during development.

    As mentioned above, this is experimental. If it is reported to be a useful feature,
    the immutable feature will be extended to strings, point-literals etc. in a future version
    of st/x.



    [Instance variables:]

        classToCompileFor   <Class>             the class (or nil) we are compiling for

        selfValue           <any>               value to use as self when interpreting

        contextToEvaluateIn <Context>           the context (or nil) when interpreting

        selector            <Symbol>            the selector of the parsed method
                                                (valid after parseMethodSpecification)
        methodArgs                              internal

        methodArgNames      <Collection>        the names of the arguments
                                                (valid after parseMethodSpecification)

        methodVars                              internal

        methodVarNames      <Collection>        the names of the method locals
                                                (valid after parseMethodBodyVarSpec)

        tree                <ParseTree>         the parse tree - valid after parsing

        currentBlock                            if currently parsing for a block

        usedInstVars                            set of all accessed instances variables
                                                (valid after parsing)

        usedClassVars                           same for classVars

        usedVars                                all used variables (inst, class & globals)

        modifiedInstVars                        set of all modified instance variables

        modifiedClassVars                       same for clasVars

        localVarDefPosition <Integer>           the character offset of the local variable
                                                def. (i.e. the first '|' if any)
                                                Not yet used - prepared for automatic add of
                                                undefined variables

        evalExitBlock                           internal for interpretation

        selfNode            <Node>              cached one-and-only 'self' node
        superNode           <Node>              cached one-and-only 'super' node

        hasPrimitiveCode    <Boolean>           true, if it contains ST/X style primitive code
        hasNonOptionalPrimitiveCode
                            <Boolean>           true, if it contains ST/X style primitive code
                                                which is NOT flagged by the OPTIONAL directive.

        primitiveNr         <Integer>           the parsed ST-80 type primitive number (or nil)

        logged

        warnedUndefVars     <Set>               set of all variables which the parser has
                                                already output a warning (to avoid multiple
                                                warnings about the same variable)

    [Class variables:]

        PrevClass           <Class>             class, of which properties are
                                                cached in:

        PrevInstVarNames      <Collection>      instance variablenames of cached class
        PrevClassVarNames     <Collection>      class variablenames of cached class
        PrevClassInstVarNames <Collection>      class instance variablenames of cached class

        LazyCompilation       <Boolean>         EXPERIMENTAL: lazy compilation

        ArraysAreImmutable    <Boolean>         if true, create array literals
                                                as instances of ImmutableArray,
                                                which cannot be stored into.
                                                Default is false, for compatibility.
                                                Can be turned on while developing
                                                new code to make certain that side
                                                effects are avoided.

        StringsAreImmutable   <Boolean>         same as above for string literals

        WarnST80Directives    <Boolean>         if true, give warnings about
                                                ST-80 directives (resource defs)
                                                which are ignored in st/x.
                                                defaults to false.

        FoldConstants         <Symbol>          controls how constant folding should be
                                                done.
                                                Can be one of:
                                                        nil      - no constant folding
                                                        #level1  - numeric optimizations only
                                                        #level2  - secure optimizations only
                                                        #full    - full folding

                                                level1:   arithmetic on constant numbers

                                                level2:   above PLUS array conversions with #asFloatArray,
                                                          #asDoubleArray, string concatenation

                                                full:     constant points.

    [see also:]
        ByteCodeCompiler Scanner ObjectFileLoader
        Workspace
        SystemBrowser

    [author:]
        Claus Gittinger
"
!

examples
"
                                                                        [exBegin]
    Parser
        evaluate:'1+2*3'
        in:nil
        receiver:nil
        notifying:nil
        logged:false
        ifFail:nil
                                                                        [exEnd]
                                                                        [exBegin]
    Parser undefinedVariableNotification handle:[:ex |
        |badName|

        badName := ex variableName.
        ex proceedWith:(ConstantNode value:5).
    ] do:[
        ^ self compilerClass
            evaluate:'foo * 3'
            in:nil
            receiver:nil
            notifying:nil
            logged:false
            ifFail:nil
    ]
                                                                        [exEnd]

  the following are experimental...
                                                                        [exBegin]
    <pragma: +arrayIndexSyntaxExtension>
    |c|

    c := Array[7].
    c[4] := 4.
    c[6] := 6.
    c[7] := 7.
    c[7] := c[4] - c[6].
                                                                        [exEnd]
                                                                        [exBegin]
    <pragma: +arrayIndexSyntaxExtension>
    |d|

    d := Dictionary new.
    d['one'] := 'eins'.
    d['two'] := 'zwei'.
    d['three'] := 'drei'.

    d['two'] , d['three']
                                                                        [exEnd]


    Reparse whole image...
                                                                        [exBegin]
    Smalltalk allClassesDo:[:cls|
        cls isLoaded ifTrue:[
            Transcript show: cls name; show: '...'.
            cls methodsDo:[:mth|
                Parser parseMethod: mth source.
            ].
            Transcript showCR:'OK'.
        ]
    ]
                                                                        [exEnd]

"
! !

!Parser class methodsFor:'instance creation'!

for:aStringOrStream in:aClass
    "return a new parser, reading code for aClass from aStringOrStream"

    |parser|

    parser := self for:aStringOrStream.
    parser setClassToCompileFor:aClass.
    ^ parser
! !

!Parser class methodsFor:'Compatibility-ST80'!

parse:aString class:aClass
    "same as #parseMethod:in: for ST80 compatibility."

    |parser|

    parser := self parseMethod:aString in:aClass.
    parser notNil ifTrue:[^ parser tree].
    ^ nil

    "Modified: 19.6.1997 / 16:34:57 / cg"
! !

!Parser class methodsFor:'Compatibility-Squeak'!

evaluate:someString for:aReceiver logged:logged
    ^ self evaluate:someString receiver:aReceiver logged:logged



!

evaluate:aStringOrStream for:aReceiver notifying:someone logged:logged
    ^ self 
        evaluate:aStringOrStream
        in:nil
        receiver:aReceiver
        notifying:someone
        logged:logged
        ifFail:[ParseError raiseRequestWith:self]
        compile:true
! !

!Parser class methodsFor:'Signal constants'!

askForVariableTypeOfUndeclaredQuery
    ^ AskForVariableTypeOfUndeclaredQuery

    "Created: / 20-10-2010 / 18:23:12 / cg"
!

correctByDeclaringIdentifierAs
    ^ CorrectByDeclaringIdentifierAs
!

correctByInteractiveCorrection
    ^ CorrectByInteractiveCorrection
!

correctByInteractiveRename
    ^ CorrectByInteractiveRename
!

parseErrorSignal
    ^ ParseError
!

parseWarningSignal
    ^ ParseWarning

    "Created: / 05-07-2011 / 18:15:33 / cg"
!

possibleCorrectionsQuery
    ^ PossibleCorrectionsQuery
!

restartCompilationSignal
    ^ RestartCompilationSignal

    "Created: / 15.11.2001 / 22:57:05 / cg"
!

undefinedSuperclassError
    ^ UndefinedSuperclassError
!

undefinedVariableError
    ^ UndefinedVariableError
!

undefinedVariableNotification
    ^ UndefinedVariableNotification
! !

!Parser class methodsFor:'change & update'!

flushNameCache
    "unconditional flush name caches"

    [
        PrevClass notNil ifTrue:[
            PrevClass removeDependent:Parser
        ].
        PrevClass := nil.
        PrevInstVarNames := nil.
        PrevClassVarNames := nil.
        PrevClassInstVarNames := nil.
    ] valueUninterruptably

    "Parser flushNameCache"
!

update:something with:someArgument from:changedObject
    "aClass has changed its definition - flush name caches if we have to"

    (changedObject == PrevClass) ifTrue:[
        something == #definition ifTrue:[
            self flushNameCache
        ]
    ].
    (changedObject == Smalltalk) ifTrue:[
        something == #classDefinition ifTrue:[
            self flushNameCache
        ]
    ]
! !

!Parser class methodsFor:'class initialization'!

initialize
    LazyCompilation := false.      "/ usually set to true in your .rc file

    FoldConstants := #level1.
    LineNumberInfo := false.

    ParseErrorSignal isNil ifTrue:[
        ParseErrorSignal := ParseError.
        ParseErrorSignal notifierString:'Parse error:'.
    ].

    Smalltalk addDependent:self.

    "
     self initialize
    "

    "Modified: / 22-08-2006 / 13:41:51 / cg"
! !

!Parser class methodsFor:'controlling compilation'!

allowArrayIndexSyntaxExtension
    "experimental"

    ^ ParserFlags allowArrayIndexSyntaxExtension
!

allowArrayIndexSyntaxExtension:aBoolean
    "experimental"

    ParserFlags allowArrayIndexSyntaxExtension:aBoolean.

    "
     self allowArrayIndexSyntaxExtension:true
     self allowArrayIndexSyntaxExtension:false
    "
!

allowFunctionCallSyntaxForBlockEvaluation
    "experimental"

    ^ ParserFlags allowFunctionCallSyntaxForBlockEvaluation
!

allowFunctionCallSyntaxForBlockEvaluation:aBoolean
    "experimental"

    ParserFlags allowFunctionCallSyntaxForBlockEvaluation:aBoolean.

    "
     self allowFunctionCallSyntaxForBlockEvaluation:true
     self allowFunctionCallSyntaxForBlockEvaluation:false
    "
!

allowReservedWordsAsSelectors
    "return true, if self, super, thisContext, nil, true and false are to be allowed
     as unary message selectors."

    ^ ParserFlags allowReservedWordsAsSelectors
!

allowReservedWordsAsSelectors:aBoolean
    "enable/disable, if self, super, thisContext, nil, true and false are to be allowed
     as unary message selectors."

    ParserFlags allowReservedWordsAsSelectors:aBoolean.
    self setupActions

    "
     self allowReservedWordsAsSelectors:true
     self allowReservedWordsAsSelectors:false
    "
!

arraysAreImmutable
    "return true if arrays are immutable literals"

    ^ ParserFlags arraysAreImmutable
!

arraysAreImmutable:aBoolean
    "turn on/off immutable array literals - default is false for ST-80 compatibilty."

    ParserFlags arraysAreImmutable:aBoolean.

    "
     can be added to your private.rc file:

     Compiler arraysAreImmutable:true
     Compiler arraysAreImmutable:false
    "
!

compileLazy
    "return true if compiling lazy"

    ^ LazyCompilation.
!

compileLazy:aBoolean
    "turn on/off lazy compilation - return previous setting.
     Actually this flag belongs into the ByteCodeCompiler subclass,
     but it also controls the reporting of some errors here; therefore
     its located here"

    |oldLazy|

    oldLazy := LazyCompilation.
    LazyCompilation := aBoolean.
    ^ oldLazy

    "
     Compiler compileLazy:false
     Compiler compileLazy:true
    "
!

foldConstants
    "return a symbol describing how constants are to be folded"

    ^ FoldConstants

    "Created: 9.2.1996 / 17:40:13 / cg"
!

foldConstants:aSymbol
    "set the symbol describing how constants are to be folded.
     It can be:
        nil             - no constant folding
        #level1         - numeric constants only
        #level2         - level1 PLUS array conversions PLUS string concatenation
        #full           - level2 PLUS constant points, constant rectangles (dangerous)"

    FoldConstants := aSymbol

    "Created: 9.2.1996 / 17:40:34 / cg"
!

implicitSelfSends
    "return true if undefined variables with
     lowercase first character are to be turned
     into implicit self sends"

    ^ ParserFlags implicitSelfSends
!

implicitSelfSends:aBoolean
    "turn on/off implicit self sends"

    ParserFlags implicitSelfSends:aBoolean

    "
     ParserFlags implicitSelfSends:true
     ParserFlags implicitSelfSends:false
    "
!

lineNumberInfo
    ^ ParserFlags lineNumberInfo

    "Modified: / 26-09-2012 / 13:28:46 / cg"
!

lineNumberInfo:aBoolean
    ParserFlags lineNumberInfo:aBoolean

    "Modified: / 26-09-2012 / 13:28:56 / cg"
!

stringsAreImmutable
    "return true if strings are immutable literals"

    ^ ParserFlags stringsAreImmutable

    "Created: / 3.8.1998 / 14:53:25 / cg"
!

stringsAreImmutable:aBoolean
    "turn on/off immutable string literals - default is false for ST-80 compatibilty."

    ParserFlags stringsAreImmutable:aBoolean.

    "
     can be added to your private.rc file:

     ParserFlags stringsAreImmutable:true
     ParserFlags stringsAreImmutable:false
    "

    "Created: / 3.8.1998 / 14:53:28 / cg"
!

warnAboutBadComments:aBoolean
    "controls generation of warning messages about empty comments"

    ParserFlags warnAboutBadComments:aBoolean
!

warnAboutVariableNameConventions
    "controls generation of warning messages about wrong variable names"

    ^ ParserFlags warnAboutVariableNameConventions
!

warnAboutVariableNameConventions:aBoolean
    "controls generation of warning messages about wrong variable names"

    ParserFlags warnAboutVariableNameConventions:aBoolean
!

warnAboutWrongVariableNames
    "controls generation of warning messages about wrong variable names"

    ^ ParserFlags warnAboutWrongVariableNames
!

warnAboutWrongVariableNames:aBoolean
    "controls generation of warning messages about wrong variable names"

    ParserFlags warnAboutWrongVariableNames:aBoolean
!

warnUnusedVars
    "controls generation of warning messages about unued method variables"

    ^ ParserFlags warnUnusedVars
!

warnUnusedVars:aBoolean
    "controls generation of warning messages about unued method variables"

    ParserFlags warnUnusedVars:aBoolean
! !

!Parser class methodsFor:'defaults'!

maxLineNumber
    "return the maximum lineNumber that is possibly
     encoded in a methods byteCode debugging information.
     Since lineNumber entries only have 1 byte available,
     this is 255 for byteCode methods."

    ^ 255

    "Created: 14.2.1997 / 16:52:54 / cg"
! !

!Parser class methodsFor:'error correction'!

findBest:nMax selectorsFor:aString in:aClassOrNil
    "collect known selectors with their spelling distances to aString;
     return the nMax best suggestions. If the argument, aClassOrNil is not nil,
     the message is assumed to be sent to instances of that class (i.e. offer
     corrections from that hierarchy only).
     soon OBSOLETE: to be moved to DWIM"

    ^ self findBest:nMax selectorsFor:aString in:aClassOrNil forCompletion:false
!

findBest:nMax selectorsFor:aString in:aClassOrNil forCompletion:forCompletion
    "soon OBSOLETE and moved to DWIM.
     Collect known selectors with their spelling distances to aString;
     return the nMax best suggestions. If the argument, aClassOrNil is not nil,
     the message is assumed to be sent to instances of that class
     (i.e. offer corrections from that hierarchy only).
     If forCompletion isTrue, prefix sequences are preferred.
     The way spelling distance is computed is a heuristic which works
     well in real life (i.e. offer USEFUL suggestions)"

    |info selectorsAlready block lcSelector excludedClasses minNumArgs|

    excludedClasses := { ProtoObject . Structure . InlineObjectPrototype }.

    minNumArgs := aString argumentCount.

    info := SortedCollection new.
    info sortBlock:[:a :b | a value > b value].
    selectorsAlready := Set new.

    lcSelector := aString asLowercase.

    block := [:sym :mthd|
        |similarity lcSym keepThis nCommon fractionCommon similarityRest|

        (forCompletion and:[sym = aString or:[sym argumentCount < minNumArgs]]) ifFalse:[
            lcSym := sym asLowercase.
            (selectorsAlready includes:sym) ifFalse:[
                "/ (info contains:[:i | i key == sym]) ifFalse:[

                forCompletion ifTrue:[
                    "/ OLD: similarity := 100 * (1 + (lcSelector size / lcSym size)).

                    nCommon := (lcSelector commonPrefixWith:lcSym) size.
                    nCommon > 0 ifTrue:[
                        "/ the longer the common prefix...
                        fractionCommon := (nCommon / lcSym size).
                        "/ bump it to 100+x if lc-prefix; to 200+x if real prefix
                        (sym startsWith:aString) ifTrue:[
                            similarity := 200 * (1 + fractionCommon).
                        ] ifFalse:[
                            similarity := 100 * (1 + fractionCommon).
                        ].
                        similarityRest := (lcSelector copyFrom:nCommon+1) spellAgainst:(lcSym copyFrom:nCommon+1).
                        similarity := similarity + similarityRest.

                        "/ higher similarity for my own messages
                        ((lcSym startsWith:lcSelector) and:[ aClassOrNil == mthd mclass ]) ifTrue:[
                            similarity := similarity * 1.2.
                        ].
                    ] ifFalse:[
                        similarity := lcSelector spellAgainst:lcSym.   "/ 0..100
                    ]
                ] ifFalse:[
                    similarity := lcSelector spellAgainst:lcSym.   "/ 0..100
                ].

                ((similarity > 30 "40") or:[ (lcSelector size>1) and:[(lcSym startsWith:lcSelector)] ]) ifTrue:[
                    (selectorsAlready includes:sym) ifFalse:[
                    "/ (info contains:[:entry | entry key = sym]) ifFalse:[
                        keepThis := true.
                        info size >= nMax ifTrue:[
                            "will remove last entry anyway - so check if this one will remain..."
                            similarity < info last value ifTrue:[
                                keepThis := false.
                            ]
                        ].
                        keepThis ifTrue:[
                            "expensive - therefore do this check at last"
                            mthd isObsolete ifFalse:[
                                info add:(sym -> similarity).
                                info size > nMax ifTrue:[
                                    |droppedSelector|

                                    droppedSelector := info last key.
                                    selectorsAlready remove:droppedSelector.
                                    info removeLast.
                                ].
                                selectorsAlready add:sym.
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].

    (aClassOrNil isNil or:[aClassOrNil == Object]) ifTrue:[
        Smalltalk allClassesDo:[:cls |
            (excludedClasses includes:cls) ifFalse:[
                cls methodDictionary keysAndValuesDo:block.
                cls class methodDictionary keysAndValuesDo:block.
           ]
        ]
    ] ifFalse:[
        aClassOrNil autoload.
        aClassOrNil withAllSuperclassesDo:[:cls |
            "/ Transcript showCR:'try ',cls name.
            cls methodDictionary keysAndValuesDo:block.
            "/ cls class methodDictionary keysAndValuesDo:block.
        ].
        aClassOrNil withAllSubclassesDo:[:cls |
            cls methodDictionary keysAndValuesDo:block.
            "/ cls class methodDictionary keysAndValuesDo:block.
        ].
    ].

    ^ info collect:[:a | a key] as:OrderedCollection.

    "
     'select:' spellAgainst:'collect'    57
     'collectWithIndex:' spellAgainst:'collect' 41

     self findBest:20 selectorsFor:'i' in:nil forCompletion:true

     self findBest:20 selectorsFor:'collect' in:Collection forCompletion:true
     self findBest:100 selectorsFor:'collect' in:Collection forCompletion:true

     self findBest:20 selectorsFor:'collect:' in:SequenceableCollection forCompletion:true
     self findBest:100 selectorsFor:'collect:' in:SequenceableCollection forCompletion:true
    "

    "Modified (comment): / 01-05-2016 / 17:20:37 / cg"
!

findBestSelectorsFor:aString
    "collect known selectors with their spelling distances to aString;
     return the 10 best suggestions.
     soon OBSOLETE: to be moved to DWIM"

    ^ self findBestSelectorsFor:aString in:nil

    "
     Parser findBestSelectorsFor:'at'
     Parser findBestSelectorsFor:'at:pu'
    "
!

findBestSelectorsFor:aString in:aClassOrNil
    "collect known selectors with their spelling distances to aString;
     return the N best suggestions. If the argument, aClassOrNil is not nil,
     the message is assumed to be sent to instances of that class (i.e. offer
     corrections from that hierarchy only).
     soon OBSOLETE: to be moved to DWIM"

    ^ self findBest:30 selectorsFor:aString in:aClassOrNil

    "Modified: / 15-05-2007 / 12:39:28 / cg"
! !

!Parser class methodsFor:'evaluating expressions'!

evaluate:aStringOrStream
    "return the result of evaluating an expression in aStringOrStream.
     No doit-entry is added to the changeLog."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:nil
        logged:false
        ifFail:nil
        compile:true

    "
     Compiler evaluate:'1 + 2'
     Compiler evaluate:'''hello world'' asSortedCollection displayString printNL'
     Compiler evaluate:'''hello world'' asSortedCollection printNL'
    "
!

evaluate:aStringOrStream compile:compile
    "return the result of evaluating aString,
     The compile argument specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:nil
        logged:false
        ifFail:nil
        compile:compile
!

evaluate:aStringOrStream ifFail:failBlock
    "return the result of evaluating an expression in aStringOrStream.
     In case of any syntax errors, return the value of failBlock.
     No doit-entry is added to the changeLog."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:nil
        logged:false
        ifFail:failBlock
        compile:true
    "
     Compiler evaluate:'1 +' ifFail:['oops']
    "
!

evaluate:aStringOrStream in:aContext receiver:anObject notifying:requestor ifFail:failBlock
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     No doIt entry is added to the change-file.
     If the failBlock argument is non-nil, it is evaluated if an error occurs."

    ^ self
        evaluate:aStringOrStream
        in:aContext
        receiver:anObject
        notifying:requestor
        logged:false
        ifFail:nil
        compile:true

    "Modified: / 17.1.1998 / 02:54:07 / cg"
!

evaluate:aStringOrStream in:aContext receiver:anObject notifying:requestor logged:logged ifFail:failBlock
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs."

    ^ self
        evaluate:aStringOrStream
        in:aContext
        receiver:anObject
        notifying:requestor
        logged:logged
        ifFail:failBlock
        compile:true
!

evaluate:aStringOrStream in:aContext receiver:anObject notifying:requestor logged:logged ifFail:failBlock compile:compile
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self new
        allowUndeclaredVariables:false;

        evaluate:aStringOrStream
        in:aContext
        receiver:anObject
        notifying:requestor
        logged:logged
        ifFail:failBlock
        compile:compile
        checkForEndOfInput:(aStringOrStream isStream not)
!

evaluate:aStringOrStream logged:logged
    "return the result of evaluating an expression in aStringOrStream.
     The argument log controls if an entry is added to the changeLog."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:nil
        logged:logged
        ifFail:nil
        compile:true
    "
     Compiler evaluate:'''some string''' logged:false
     Compiler evaluate:'''some string''' logged:true
    "
!

evaluate:aStringOrStream notifying:requestor
    "return the result of evaluating aString,
     errors are reported to requestor"

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:requestor
        logged:false
        ifFail:nil
        compile:true
!

evaluate:aStringOrStream notifying:requestor compile:compile
    "return the result of evaluating aString,
     errors are reported to requestor.
     The compile argument specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:requestor
        logged:false
        ifFail:nil
        compile:compile
!

evaluate:aStringOrStream notifying:requestor logged:logged
    "return the result of evaluating aString,
     errors are reported to requestor"

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:requestor
        logged:logged
        ifFail:nil
        compile:true
!

evaluate:aStringOrStream receiver:anObject
    "return the result of evaluating aString,
     errors are reported to requestor. Allow access to
     anObject as self and to its instVars "

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:anObject
        notifying:nil
        logged:false
        ifFail:nil
        compile:true

    "
     Compiler evaluate:'self x' receiver:(1 @ 2)
    "

    "Created: 1.7.1997 / 19:02:24 / cg"
    "Modified: 1.7.1997 / 19:02:33 / cg"
!

evaluate:aStringOrStream receiver:someOne logged:logged
    "return the result of evaluating an expression in aStringOrStream.
     The argument log controls if an entry is added to the changeLog."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:someOne
        notifying:nil
        logged:logged
        ifFail:nil
        compile:true
    "
     Compiler evaluate:'''some string''' logged:false
     Compiler evaluate:'''some string''' logged:true
     Compiler evaluate:'self class' receiver:nil logged:false
     Compiler evaluate:'self class' receiver:1 logged:false
    "
!

evaluate:aStringOrStream receiver:anObject notifying:requestor
    "return the result of evaluating aString,
     errors are reported to requestor. Allow access to
     anObject as self and to its instVars (used in the inspector)"

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:anObject
        notifying:requestor
        logged:false
        ifFail:nil
        compile:true

    "
     Compiler evaluate:'self x' receiver:(1 @ 2) notifying:nil
    "
!

evaluate:aStringOrStream receiver:anObject notifying:requestor compile:compile
    "return the result of evaluating aString,
     errors are reported to requestor. Allow access to
     anObject as self and to its instVars (used in the inspector).
     The compile argument specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:anObject
        notifying:requestor
        logged:false
        ifFail:nil
        compile:compile
!

evaluateFrom:aStringOrStream ifFail:failBlock
    "return the result of evaluating an expression from aStringOrStream.
     In case of any syntax errors, return the value of failBlock.
     No doit-entry is added to the changeLog."

    ^ self
        evaluateFrom:aStringOrStream
        in:nil
        receiver:nil
        notifying:nil
        logged:false
        ifFail:failBlock
        compile:true
    "
     Compiler evaluate:'1 + 2' ifFail:['oops']
    "
!

evaluateFrom:aStringOrStream in:aContext receiver:anObject notifying:requestor logged:logged ifFail:failBlock compile:compile
    "return the result of evaluating the next expression from aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self new
        evaluate:aStringOrStream
        in:aContext
        receiver:anObject
        notifying:requestor
        logged:logged
        ifFail:failBlock
        compile:compile
        checkForEndOfInput:false
! !

!Parser class methodsFor:'general helpers'!

argAndVarNamesForContext:aContext
    <resource:#obsolete>
    self obsoleteMethodWarning.
    ^ aContext argAndVarNames.
!

methodCommentFromSource:aString
    "return the method's comment.
     This is done by searching for and returning the first comment
     from the method's source (excluding any double-quotes).
     Returns nil if there is no comment."

    |comment comments|

    comments := self methodCommentsFromSource:aString.
    comments size ~~ 0 ifTrue:[
        comment := comments first asString.
        (comment withoutSpaces endsWith:'}') ifTrue:[
            "if first comment is a pragma, take next comment"
            comment := comments at:2 ifAbsent:nil.
            comment notNil ifTrue:[
                comment := comment string.
            ].
        ].
    ].
    ^ comment.

    "
     (Method compiledMethodAt:#comment) comment
     (Object class compiledMethodAt:#infoPrinting:) comment
    "

    "Created: / 17-07-2010 / 14:21:29 / cg"
!

methodCommentsFromSource:aString
    "return all of the method's comments.
     Returns an empty collection if there is no comment."

    |comments parser|

    parser := self for:aString in:nil.
    parser ignoreErrors:true; ignoreWarnings:true; saveComments:true.
    parser parseMethod.

    comments := parser comments.
    ^ (comments ? #()) collect:[:each| each commentString].

    "
     Parser methodCommentsFromSource:(Method compiledMethodAt:#comment) source
     Parser methodCommentsFromSource:(Object class compiledMethodAt:#infoPrinting:) source
    "

    "Modified (comment): / 21-11-2017 / 13:07:31 / cg"
! !

!Parser class methodsFor:'parsing'!

blockAtLine:line in:aMethod orSource:aString numArgs:nA numVars:nV
    "given a lineNr in some method, return the containing BlockNode or nil.
     The given lineNr must be within a block for this to work.
     This is used by the debugger, to guess reverse from a lineNumber,
     to the corresponding block, in order to find out the block's
     variable names
     (mhmh - all of this wasnt't needed, if blocks stored their characterPosition internally).
     WARNING: sometimes, the block is not correctly identified, if multiple blocks
     are in one line."

    |compiler tree mSource who mClass blocks
     maxSoFar innerBlock m|

    (line isNil or:[line == self maxLineNumber]) ifTrue:[
        ^ nil
    ].

    aMethod notNil ifTrue:[
        m := aMethod.
        who := m who.
        who isNil ifTrue:[
            m isWrapped ifTrue:[
                m := m wrapper.
                m notNil ifTrue:[
                    who := m who.
                ]
            ]
        ].
        who notNil ifTrue:[
            mClass := who methodClass.
            mClass isNil ifTrue:[ ^ nil].
        ].
        m isNil ifTrue:[^ nil].
        mSource := m source.
        mSource isNil ifTrue:[^ nil].
    ] ifFalse:[
        aString notNil ifTrue:[
            mSource := aString.
            mClass := UndefinedObject
        ] ifFalse:[
            ^ nil
        ]
    ].

    "create a compiler, let it parse and create the parsetree"

    compiler := self for:(ReadStream on:mSource) in:mClass.
    compiler parseForCode.
    compiler notifying:nil.
    compiler ignoreWarnings:true.
    compiler ignoreErrors:true.
    compiler lineNumberInfo:#full.

    Notification
        handle:
            [:ex |
                ex proceed
            ]
        do:[
            aMethod notNil ifTrue:[
                (compiler parseMethodSpec == #Error) ifTrue:[
                    ^ nil.
                ].

                who notNil ifTrue:[
                    compiler selector ~~ (who methodSelector) ifTrue:[
                        ^ nil
                    ]
                ].
            ] ifFalse:[
                compiler nextToken.
            ].

            tree := compiler parseMethodBody.
        ].

    (compiler errorFlag
    or:[tree == #Error
    or:[tree isNil]]) ifTrue:[
        ^ nil
    ].

    blocks := OrderedCollection new.
    tree collectBlocksInto:blocks.

    blocks := blocks select:[:aBlock |
                                line between: aBlock lineNumber and:aBlock endLineNumber
                            ].
    blocks size == 1 ifTrue:[
        ^ blocks at:1
    ].

    nA notNil ifTrue:[
        blocks := blocks select:[:aBlock | aBlock numArgs == nA ].
        blocks size == 1 ifTrue:[
            ^ blocks at:1
        ].
    ].
    nV notNil ifTrue:[
        blocks := blocks select:[:aBlock | 
            (aBlock numVarsIncludingInlined: (m notNil and:[m hasCode and:[m bytecodes isNil]])) == nV 
        ].
        blocks size == 1 ifTrue:[
            ^ blocks at:1
        ].
    ].

    "/ still more than one possible block;
    "/ look for the one which has a statement in that line
    blocks := blocks select:[:aBlock | aBlock firstStatement notNil
                                       and:[ aBlock firstStatement lineNumber <= line]].
    blocks size == 1 ifTrue:[
        ^ blocks at:1
    ].

    "/ look for the inner one

    maxSoFar := 0.
    blocks do:[:aBlock |
        aBlock lineNumber > maxSoFar ifTrue:[
            innerBlock := aBlock.
            maxSoFar := aBlock lineNumber
        ]
    ].
    ^ innerBlock.

    "Created: / 11-01-1997 / 23:29:13 / cg"
    "Modified: / 14-02-1997 / 16:51:25 / cg"
    "Modified (format): / 23-12-2015 / 17:33:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseExpression:aString
    "parse aString as an expression;
     Return the parseTree (if ok), nil (for an empty string
     or comment only) or #Error (syntactic error).
     Error and warning messages are suppressed."

    ^ self
        withSelf:nil
        parseExpression:aString
        onError:#Error
        notifying:nil
        ignoreErrors:true       "silence on Transcript"
        ignoreWarnings:true
        inNameSpace:nil

    "
     Parser parseExpression:''
     Parser parseExpression:'self foo'
     Parser parseExpression:'^ self foo'
     Parser parseExpression:'self:123'
     Parser parseExpression:'self:123' onError:nil
    "
!

parseExpression:aString inNameSpace:aNameSpaceOrNil
    "parse aString as an expression;
     Return the parseTree (if ok), nil (for an empty string
     or comment only) or #Error (syntactic error).
     Error and warning messages are suppressed."

    ^ self
        withSelf:nil
        parseExpression:aString
        onError:#Error
        notifying:nil
        ignoreErrors:true       "silence on Transcript"
        ignoreWarnings:true
        inNameSpace:aNameSpaceOrNil

    "Modified: 24.6.1997 / 16:44:00 / cg"
    "Created: 24.6.1997 / 16:44:26 / cg"
!

parseExpression:aString inNameSpace:aNameSpaceOrNil onError:errorValue
    "parse aString as an expression;
     Return the parseTree (if ok), nil (for an empty string
     or comment only) or errorValue (syntactic error).
     Error and warning messages are suppressed."

    ^ self
        withSelf:nil
        parseExpression:aString
        onError:errorValue
        notifying:nil
        ignoreErrors:true       "silence on Transcript"
        ignoreWarnings:true
        inNameSpace:aNameSpaceOrNil

    "Modified: 24.6.1997 / 16:44:00 / cg"
    "Created: 24.6.1997 / 16:44:26 / cg"
!

parseExpression:aString onError:errorValue
    "parse aString as an expression;
     Return the parseTree (if ok), nil (for an empty string
     or comment only) or errorValue (syntactic error).
     Error and warning messages are suppressed."

    ^ self
        withSelf:nil
        parseExpression:aString
        onError:errorValue
        notifying:nil
        ignoreErrors:true       "silence on Transcript"
        ignoreWarnings:true
        inNameSpace:nil

    "Modified: 24.6.1997 / 16:44:00 / cg"
!

parseLiteralArray: aStringOrStream
    "Parser literal array in given String or Stream.
     Returns that array"

    ^(self for: aStringOrStream) parseLiteralArray: aStringOrStream.

    "Created: / 06-11-2012 / 12:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMethod:aString
    "parse a method.
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args, locals,
     used selectors etc.
     Error and warning messages are sent to the Transcript."

    ^ self parseMethod:aString in:nil

    "
     |p|

     p := Parser
             parseMethod:'
                 foo:arg1 bar:arg2 baz:arg3
                     |l1 l2|
                     l1 := 0.
                     l2 := arg1.
                     ^ self'.

     'nArgs:  ' print. p numberOfMethodArgs printNL.
     'args:   ' print. p methodArgs printNL.
     'sel:    ' print. p selector printNL.
     'nLocal: ' print. p numberOfMethodVars printNL.
     'locals: ' print. p methodVars printNL.
     'tree:   ' printNL. p tree printAllOn:Stdout. Stdout cr.
    "

    "Modified: 24.4.1996 / 13:18:02 / cg"
!

parseMethod:aString in:aClass
    "parse a method in a given class.
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args, locals,
     used selectors, modified instvars, referenced classvars etc.
     Error and warning messages are sent to the Transcript."

    ParseError handle:[:ex |
        Transcript showCR:ex description.
        ex proceed.
    ] do:[
        ^ self
            parseMethod:aString
            in:aClass
            ignoreErrors:false
            ignoreWarnings:false
    ].

    "Modified: 24.4.1996 / 13:18:34 / cg"
!

parseMethod:aString in:aClass ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings
    "parse a method in a given class.
     Return a parser (if ok) or #Error (syntax).
     The parser can be queried for selector, receiver, args, locals,
     used selectors, modified instvars, referenced classvars etc.
     The noErrors and noWarnings arguments specify if error and warning
     messages should be sent to the Transcript or suppressed."

    |parser|

    parser := self new.
    parser parseMethod:aString in:aClass ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings.
    ^ parser

    "Modified: / 06-03-2007 / 18:33:39 / cg"
!

parseMethod:aString in:aClass warnings:warnBoolean
    <resource: #obsolete>
    "parse a method in a given class.
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args, locals,
     used selectors, modified instvars, referenced classvars etc.
     The warnBoolean arguments specifies if warning
     messages should be sent to the Transcript or suppressed.

     This method is OBSOLETE, and left in for backward compatibility."

    self obsoleteMethodWarning.
    ^ self
        parseMethod:aString
        in:aClass
        ignoreErrors:false
        ignoreWarnings:warnBoolean not

    "Modified: 24.4.1996 / 13:28:05 / cg"
!

parseMethodArgAndVarSpecification:aString
    <resource: #obsolete>
    "parse a methods selector, arg and var spec (i.e. locals);
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver etc.
     Error and warning messages are sent to the Transcript.
     This method is OBSOLETE."

    self obsoleteMethodWarning.
    ^ self parseMethodArgAndVarSpecification:aString in:nil

    "
     |p|

     p := Parser
             parseMethodArgAndVarSpecification:'
                      foo:arg1 bar:arg2 baz:arg3
                      |l1 l2|'.

     'nArgs:  ' print. p numberOfMethodArgs printNL.
     'args:   ' print. p methodArgs printNL.
     'sel:    ' print. p selector printNL.
     'nLocal: ' print. p numberOfMethodVars printNL.
     'locals: ' print. p methodVars printNL.
    "

    "Modified: 24.4.1996 / 13:29:43 / cg"
!

parseMethodArgAndVarSpecification:aString in:aClass
    <resource: #obsolete>
    "parse a methods selector, arg and var spec in a given class;
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args and locals.
     Error and warning messages are sent to the Transcript.
     This method is OBSOLETE."

    self obsoleteMethodWarning.
    ^ self parseMethodArgAndVarSpecification:aString
           in:aClass
           ignoreErrors:false
           ignoreWarnings:false
           parseBody:false

    "Modified: 24.4.1996 / 13:30:03 / cg"
!

parseMethodArgAndVarSpecification:aString in:aClass ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings parseBody:body
    "parse a methods selector, arg and var spec in a given class;
     If parseBody is true, also parse the statements
     (for primitives & resourceSpecs).
     The noErrors and noWarnings arguments specify if error and warning
     messages should be sent to the Transcript or suppressed.

     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args and locals"

    |parser|

    aString isNil ifTrue:[^ nil].
    parser := self for:(ReadStream on:aString) in:aClass.
    parser ignoreErrors:ignoreErrors.
    parser ignoreWarnings:ignoreWarnings.
"/    parser nextToken.
    (parser parseMethodSpec == #Error) ifTrue:[^ nil].
    "/
    "/ used to be #parseMethodBodyVarSpec
    "/ - now, alternatively parse body for resource & primitive specs ..
    "/
    body ifTrue:[
        parser parseMethodBodyOrEmpty
    ] ifFalse:[
        parser parseMethodBodyVarSpec
    ].
    "/ parser errorFlag ifTrue:[^ nil].
    ^ parser

    "Created: 24.4.1996 / 13:13:06 / cg"
    "Modified: 27.4.1996 / 16:58:02 / cg"
!

parseMethodArgAndVarSpecificationSilent:aString
    "parse a methods selector, arg and var spec (i.e. locals);
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver etc.
     Like #parseMethodArgAndVarSpecification:, but does NOT
     display error/warning messages on the transcript."

    ^ self parseMethodArgAndVarSpecificationSilent:aString in:nil

    "Modified: 24.4.1996 / 13:30:54 / cg"
!

parseMethodArgAndVarSpecificationSilent:aString in:aClass
    "parse a methods selector, arg and var spec in a given class;
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args and locals.
     Like #parseMethodArgAndVarSpecification:in:, but does not
     display error/warning messages on the transcript."

    ^ self parseMethodArgAndVarSpecification:aString
           in:aClass
           ignoreErrors:true
           ignoreWarnings:true
           parseBody:false

    "Modified: 24.4.1996 / 13:14:27 / cg"
!

parseMethodSilent:aString
    "parse a method.
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args, locals,
     used selectors etc.
     Like #parseMethod:, but warning/error messages are suppressed."

    ^ self parseMethodSilent:aString in:nil

    "Modified: 24.4.1996 / 13:32:44 / cg"
!

parseMethodSilent:aString in:aClass
    "parse a method in a given class.
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args, locals,
     used selectors, modified instvars, referenced classvars etc.
     Like #parseMethod:in:, but warning/error messages are suppressed."

    ^ self
        parseMethod:aString
        in:aClass
        ignoreErrors:true
        ignoreWarnings:true

    "Modified: 24.4.1996 / 13:32:57 / cg"
!

parseMethodSpecification:aString
    "parse a methods selector & arg specification;
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver etc."

    ^ self parseMethodSpecification:aString in:nil

    "
     |p|

     p := Parser parseMethodSpecification:'foo:arg1 bar:arg2 baz:arg3'.
     'nArgs: ' print. p numberOfMethodArgs printNL.
     'args:  ' print. p methodArgs printNL.
     'sel:   ' print. p selector printNL
    "
!

parseMethodSpecification:aString in:aClass
    "parse a methods selector & arg spec for a given class;
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver etc."

    ^ self parseMethodSpecification:aString
           in:aClass
           ignoreErrors:false
           ignoreWarnings:false
!

parseMethodSpecification:aString in:aClass ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings
    "parse a methods selector & arg spec for a given class;
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver etc.
     noErrors and noWarnings specify if error- and warningMessages are
     to be output onto the Transcript."

    |parser tree|

    aString isNil ifTrue:[^ nil].
    parser := self for:(ReadStream on:aString) in:aClass.
    parser ignoreErrors:ignoreErrors.
    parser ignoreWarnings:ignoreWarnings.
"/    parser nextToken.
    tree := parser parseMethodSpec.
"/    (parser errorFlag or:[tree == #Error]) ifTrue:[^ #Error].
    ^ parser

    "Modified: 20.4.1996 / 20:09:48 / cg"
!

parseMethodSpecificationSilent:aString
    "parse a methods selector & arg specification;
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver etc.
     Like #parseMethodSpecification:, but does not display any error/warning Messages on the transcript."

    ^ self parseMethodSpecificationSilent:aString in:nil
!

parseMethodSpecificationSilent:aString in:aClass
    "parse a methods selector & arg spec for a given class;
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver etc.
     Like #parseMethodSpecification:in:, but does not display any error/warning Messages on the transcript."

    ^ self parseMethodSpecification:aString
           in:aClass
           ignoreErrors:true
           ignoreWarnings:true

    "Created: 31.10.1995 / 14:37:49 / cg"
!

selectorInExpression:aString
    "parse an expression - return the selector. 
     Even malformed expressions
     (such as missing receiver or missing arg) are parsed.
     Used for the SystemBrowser's implementors/senders query-box initial text.
     Returns nil if unparsable."

    |stringParsed tree expression parser sel|

    stringParsed := aString withoutSeparators.
    stringParsed isEmpty ifTrue:[^ nil].
    (stringParsed startsWith:'^') ifTrue:[
        stringParsed := stringParsed copyFrom:2.
    ].

    Error
        handle:[:ex | ]
        do:[
            tree := self withSelf:nil
                         parseExpression:stringParsed
                         notifying:nil
                         ignoreErrors:true
                         ignoreWarnings:true.
        ].

    "
     special: take the expression of the right side, if it's an
     assignment or return
    "
    (tree notNil and:[tree ~~ #Error]) ifTrue:[
        (tree isAssignment or:[tree isReturnNode]) ifTrue:[
            (expression := tree expression) isNil ifTrue:[^ nil].
            expression isMessage ifTrue:[
                tree := expression
            ]
        ].
        tree isMessage ifTrue:[
            ^ tree selector
        ].
    ].

    "
     mhmh, try expression without receiver
    "
    parser := self for:(ReadStream on:stringParsed).
    parser ignoreErrors:true.
    Error
        handle:[:ex | ]
        do:[
            parser nextToken.
            sel := parser degeneratedKeywordExpressionForSelector
        ].
    ^ sel

"
    Parser selectorInExpression:'foo at:1 put:(5 * bar)'
    Parser selectorInExpression:'(foo at:1) at:1'
    Parser selectorInExpression:'a + 4'
    Parser selectorInExpression:'a negated'
    Parser selectorInExpression:'at:1 put:5'
    Parser selectorInExpression:'at:1 put:'
    Parser selectorInExpression:'a at:1 put:5'
    Parser selectorInExpression:'a at:1 put:'
    Parser selectorInExpression:'a := foo at:1 put:5'
"

    "Modified (comment): / 28-02-2012 / 10:11:15 / cg"
!

withSelf:anObject parseExpression:aString notifying:someOne
    "parse aString as an expression with self set to anObject;
     Return the parseTree (if ok), nil (for an empty string
     or comment only ) or #Error (syntactic error).

     Errors and warnings are forwarded to someOne (usually some
     codeView) which can highlight it and show a popup box."

    ^ self
        withSelf:anObject
        parseExpression:aString
        onError:#Error
        notifying:someOne
        ignoreErrors:false
        ignoreWarnings:false
        inNameSpace:nil

    "Modified: 24.6.1997 / 16:43:37 / cg"
!

withSelf:anObject parseExpression:aString notifying:someOne ignoreErrors:ignore
    "parse aString as an expression with self set to anObject;
     Return the parseTree (if ok), nil (for an empty string
     or comment only ) or #Error (syntactic error).

     Errors and warnings are forwarded to someOne (usually some
     codeView) which can highlight it and show a popup box."

    ^ self
        withSelf:anObject
        parseExpression:aString
        onError:#Error
        notifying:someOne
        ignoreErrors:ignore
        ignoreWarnings:ignore
        inNameSpace:nil

    "Modified: 24.6.1997 / 16:43:26 / cg"
!

withSelf:anObject parseExpression:aString notifying:someOne ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings
    "parse aString as an expression with self set to anObject;
     Return the parseTree (if ok), nil (for an empty string
     or comment only ) or #Error (syntactic error).

     Errors and warnings are forwarded to someOne (usually some
     codeView) which can highlight it and show a popup box,
     iff ignoreErrors/ignoreWarnings is true respectively."

    ^ self
        withSelf:anObject
        parseExpression:aString
        onError:#Error
        notifying:someOne
        ignoreErrors:ignoreErrors
        ignoreWarnings:ignoreWarnings
        inNameSpace:nil

    "Modified: 24.6.1997 / 16:43:12 / cg"
!

withSelf:anObject parseExpression:aString notifying:someOne ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings inNameSpace:aNameSpaceOrNil
    "parse aString as an expression with self set to anObject;
     Return the parseTree (if ok), nil (for an empty string
     or comment only ) or #Error (syntactic error).

     Errors and warnings are forwarded to someOne (usually some
     codeView) which can highlight it and show a popup box,
     iff ignoreErrors/ignoreWarnings is true respectively."

    ^ self
        withSelf:anObject
        parseExpression:aString
        onError:#Error
        notifying:someOne
        ignoreErrors:ignoreErrors
        ignoreWarnings:ignoreWarnings
        inNameSpace:aNameSpaceOrNil
!

withSelf:anObject parseExpression:aStringOrStream onError:errorValue notifying:someOne ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings inNameSpace:aNameSpaceOrNil
    "parse aString as an expression with self set to anObject;
     Return the parseTree (if ok), nil (for an empty string
     or comment only ) or errorValue (syntactic error).

     Errors and warnings are forwarded to someOne (usually some
     codeView) which can highlight it and show a popup box,
     iff ignoreErrors/ignoreWarnings is true respectively."

    |parser tree|

    aStringOrStream isNil ifTrue:[^ nil].

    parser := self for:(aStringOrStream readStream).
    ParseErrorSignal handle:[:ex |
        ^ errorValue value
    ] do:[
        tree := parser
            parseExpressionWithSelf:anObject
            notifying:someOne
            ignoreErrors:ignoreErrors
            ignoreWarnings:ignoreWarnings
            inNameSpace:aNameSpaceOrNil.
    ].
    "/ #Error returnValue will vanish
    tree == #Error ifTrue:[
        ^ errorValue value
    ].
    ^ tree

    "Modified: / 14.12.1999 / 15:12:16 / cg"
! !

!Parser class methodsFor:'private'!

genMakeArrayWith:elementExpressions
    "return a node to generate an array at runtime.
     Will generate:
        Array with:el1 ... with:elN                             (if N <= 5)
     or:
        (Array new at:1 put:el1; ... at:N put:elN; yourself)    (otherwise)
    "

    |numEl arrRec sel expr|

    arrRec := VariableNode globalNamed:#Array.
    arrRec startPosition: -1 endPosition: -1. "/ -1 means artifitial node

    numEl := elementExpressions size.

    (numEl between:1 and:8) ifTrue:[
        sel := #(
                  #'with:'
                  #'with:with:'
                  #'with:with:with:'
                  #'with:with:with:with:'
                  #'with:with:with:with:with:'
                  #'with:with:with:with:with:with:'
                  #'with:with:with:with:with:with:with:'
                  #'with:with:with:with:with:with:with:with:'
                ) at:numEl.

        ^ MessageNode
                    receiver:arrRec
                    selector:sel
                    args:elementExpressions.
    ].

    "/ array creation expression ...
    expr := MessageNode
                receiver:arrRec
                selector:#new:
                arg:(ConstantNode type:#Integer value:numEl from: -1 to: -1). "/ -1 means artifitial node

    numEl == 0 ifTrue:[
        ^ expr.
    ].
    "/ followed by a bunch of #at:put: messages...
    elementExpressions keysAndValuesDo:[:idx :e |
        expr := (idx == 1 ifTrue:[MessageNode] ifFalse:[CascadeNode])
                    receiver:expr
                    selector:#at:put:
                    arg1:(ConstantNode type:#Integer value:idx from: -1 to:-1)"/ -1 means artifitial node
                    arg2:e
                    fold:false.
    ].
    "/ followed by a #yourself: message...
    expr := CascadeNode
                receiver:expr
                selector:#yourself.
    ^ expr

    "Modified: / 01-08-2011 / 12:38:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

implementedInAnyClass:aSelectorStringOrSymbol
    |selectorSymbol|

    selectorSymbol := aSelectorStringOrSymbol asSymbolIfInterned.
    selectorSymbol isNil ifTrue:[^ false].

    Smalltalk allClassesAndMetaclassesDo:[:cls |
        (cls includesSelector:selectorSymbol) ifTrue:[^ true].
    ].
    ^ false

    "Modified: / 22-10-2006 / 02:25:37 / cg"
!

make:anObject immutable:whichImmutableClass
    "helper to optionally make Arrays, ByteArrays and Strings immutable."

    |newObject|

    newObject := anObject copy.
    whichImmutableClass notNil ifTrue:[
        newObject changeClassTo:whichImmutableClass.
    ].
    newObject beImmutable.
    ^ newObject
!

makeImmutableArray:anArray
    "helper to optionally make an array immutable."

    ^ self make:anArray immutable:ImmutableArray
!

makeImmutableByteArray:aByteArray
    "helper to optionally make a byte array immutable."

    ^ self make:aByteArray immutable:ImmutableByteArray
!

makeImmutableString:aString
    "helper to optionally make a string immutable."

    |width immutableStringClass|

    (width := aString bitsPerCharacter) > 8 ifTrue:[
        width > 16 ifTrue:[
            immutableStringClass := (Smalltalk at:#ImmutableUnicode32String)
        ] ifFalse:[
            immutableStringClass := (Smalltalk at:#ImmutableUnicode16String)
        ].
    ] ifFalse:[
        immutableStringClass := ImmutableString
    ].

    "/ a temporary hack, which will still work, 
    "/ when the new immutable string classes are present.
    immutableStringClass isNil ifTrue:[
        "/ not yet avail: leave it as a regular, mutable string
        ^ aString
    ].
    ^ self make:aString immutable:immutableStringClass
! !

!Parser class methodsFor:'unparsing'!

methodSpecificationForSelector:aSelector
    "given a selector such as #foo:bar:, return a string that could
     serve as a methods specification source code.
     To be used for code generators"

    |argNames n|

    n := aSelector numArgs.
    n == 1 ifTrue:[
        argNames := #('arg')
    ] ifFalse:[
        n <= 15 ifTrue:[
            argNames := #('arg1' 'arg2' 'arg3' 'arg4' 'arg5' 'arg6'
                          'arg7' 'arg8' 'arg9' 'arg10' 'arg11' 'arg12'
                          'arg13' 'arg14' 'arg15')
        ] ifFalse:[
            argNames := (1 to:aSelector numArgs) collect:[:i | 'arg' , i printString].
        ].
    ].
    ^ self methodSpecificationForSelector:aSelector argNames:argNames

    "
     Parser methodSpecificationForSelector:#foo:
     Parser methodSpecificationForSelector:#foo:bar:
     Parser methodSpecificationForSelector:#foo:bar:baz:
     Parser methodSpecificationForSelector:#+
     Parser methodSpecificationForSelector:#negated
    "

    "Modified: / 12.2.1999 / 13:12:44 / cg"
!

methodSpecificationForSelector:aSelector argNames:argNames
    "given a selector such as #foo:bar:, return a string that could
     serve as a methods specification source code.
     To be used for code generators"

    |s nargs parts part|

    s := WriteStream on:''.
    nargs := aSelector numArgs.
    nargs == 0 ifTrue:[
        s nextPutAll:aSelector
    ] ifFalse:[
        parts := aSelector partsIfSelector.
        1 to:nargs do:[:i |
            part := parts at:i.
            s nextPutAll:part.
            (part endsWith:$:) ifFalse:[
                s space.
            ].
            s nextPutAll:(argNames at:i).
            i ~~ nargs ifTrue:[s space].
        ]
    ].
    ^ s contents

    "
     Parser methodSpecificationForSelector:#foo:bar: argNames:#('one' 'two' 'three')
     Parser methodSpecificationForSelector:#+ argNames:#('one')
     Parser methodSpecificationForSelector:#negated
    "

    "Modified: / 12.2.1999 / 12:33:50 / cg"
! !

!Parser methodsFor:'Compatibility-ST80'!

evaluate:aStringOrStream in:aContextOrNil to:whatIsThis
    ^ self evaluate:aStringOrStream in:aContextOrNil to:whatIsThis notifying:nil ifFail:[self error]
!

evaluate:aString in:aClassOrContext to:to notifying:aRequestor ifFail:failBlock
    |parseTree value|

    aString isNil ifTrue:[^ nil].
    self initializeFor:(ReadStream on:aString).

    "/ stupid - there seem to be differences among the various
    "/ ST dialects ...
    aClassOrContext isBehavior ifTrue:[
        self setClassToCompileFor:aClassOrContext.
        selfValue := nil.
    ] ifFalse:[
        self setContext:aClassOrContext.
        aClassOrContext notNil ifTrue:[
            self setSelf:(aClassOrContext receiver)
        ].
    ].
    requestor := aRequestor.

    self nextToken.
    parseTree := self parseMethodBody.
    (errorFlag or:[tree == #Error]) ifTrue:[^ #Error].
    parseTree notNil ifTrue:[
        self evalExitBlock:[:value | ^ failBlock value].
        value := parseTree evaluate
    ].
    self release.
    ^ value
!

parse:methodSource in:aClass notifying:aRequestor
    "parse a methods source.
     Return the method's parseTree"

    self initializeFor:methodSource.
    classToCompileFor := aClass.
    requestor := aRequestor.
    self parseMethod.

    ^ (MethodNode new
            selector:selector
            arguments:methodArgs
            locals:methodVars
            statements:(tree isNil ifTrue:[#()] ifFalse:[tree asCollectionOfStatements]))
        encoder:self

    "Created: / 17-10-1997 / 12:35:01 / cg"
    "Modified: / 12-09-2011 / 09:48:00 / cg"
!

parseSelector:aStringOrStream
    "parse a method's source for its selector.
     Return the selector"

    self initializeFor:aStringOrStream.
    self parseMethodSpec.
    ^ selector.

    "
     Parser new
        parseSelector:'
parseSelector:aStringOrStream
    self initializeFor:aStringOrStream.
    self parseMethodSpec.
    ^ selector.
'
    "

    "Modified: / 17-10-1997 / 12:35:46 / cg"
    "Modified (comment): / 21-11-2017 / 13:07:22 / cg"
! !

!Parser methodsFor:'Compatibility-Squeak'!

parse:methodSource class:aClass
    "parse a methods source.
     Return the method's parseTree"

    ^ self parse:methodSource in:aClass notifying:nil
! !

!Parser methodsFor:'accessing'!

allowUndeclaredVariables:aBoolean
    allowUndeclaredVariables := aBoolean.

    "Modified: / 05-02-2011 / 10:04:41 / cg"
!

correctedSource
    ^ correctedSource
!

currentSource
    "return either the corrected or the requestors original source"

    correctedSource notNil ifTrue:[
        ^ correctedSource
    ].
    ^ requestor currentSourceCode
!

doItTemporaries
    ^ doItTemporaries
!

endOfLastToken
    ^ tokenPosition
!

endOfSelectorPosition
    "return the sourcePosition of the last character of the method's selector spec"

    ^ endOfSelectorPosition

    "Modified (comment): / 21-11-2017 / 13:07:08 / cg"
!

errorFlag
    "return true if there where any errors (valid after parsing)"

    ^ errorFlag
!

evalExitBlock:aBlock
    "when evaluating a return expression, this block is evaluated"

    evalExitBlock := aBlock
!

getNameSpace
    "retrieve the nameSpace, as found in a Namespace directive"

    ^ currentNamespace

    "Modified: 8.11.1996 / 13:45:35 / cg"
!

implicitSelfSends
    ^ parserFlags implicitSelfSends
!

implicitSelfSends:aBoolean
    "turn on/off implicit self sends"

    parserFlags implicitSelfSends:aBoolean
!

interactiveMode:aBoolean
    "support for stx-scripting service"

    interactiveMode := aBoolean.

    "Modified: / 04-08-2010 / 11:16:20 / cg"
!

lineNumberInfo
    <resource: #obsolete>

    ^ parserFlags lineNumberInfo

    "Created: / 21-10-1996 / 17:06:16 / cg"
!

lineNumberInfo:how
    <resource: #obsolete>

    parserFlags lineNumberInfo: how

    "Created: / 23-10-1996 / 15:39:43 / cg"
!

moreSharedPools
    ^ moreSharedPools
!

moreSharedPools:aCollection
    moreSharedPools := aCollection
!

primitiveNumber
    "return the ST-80 style primitiveNumber or nil (valid after parsing)"

    ^ primitiveNr
!

primitiveResources
    "return the ST-80 style resource info or nil (valid after parsing)."

    ^ primitiveResource

    "Created: 29.5.1996 / 17:28:00 / cg"
!

release
    methodArgs := methodVars := tree := selfNode := superNode := nilNode := nil.
    super release.

    "Modified: / 31.3.1998 / 19:45:58 / cg"
!

setNameSpace:aNameSpaceOrNameSpaceName
    "sent from a namespace directive, if there is no requestor.
     Sets the current namespace."

    aNameSpaceOrNameSpaceName isString ifFalse:[
        currentNamespace := aNameSpaceOrNameSpaceName.
        ^ self
    ].

    currentNamespace := NameSpace fullName:aNameSpaceOrNameSpaceName createIfAbsent:(self isSyntaxHighlighter not).

    "Modified: 8.11.1996 / 13:43:14 / cg"
!

setPackage:aPackageID
    currentPackage := aPackageID
!

targetClass
    ^ classToCompileFor
!

targetClass:aClass
    classToCompileFor := aClass
!

tree
    "return the parsetree"

    ^tree
!

tree:aTree
    "private: set the tree - for internal use only"

    tree := aTree
!

warnSTXHereExtensionUsed
    ^ parserFlags warnSTXHereExtensionUsed
!

warnSTXHereExtensionUsed:aBoolean
    parserFlags warnSTXHereExtensionUsed:aBoolean
!

wasParsedForCode
    ^ parseForCode
! !

!Parser methodsFor:'code generation hooks'!

assignmentRewriteHookFor:anAssignmentNode
    "invoked whenever an assignment node has been generated;
     gives subclasses a chance to rewrite (instrument) it"

    ^ anAssignmentNode

    "Created: / 30-09-2011 / 12:12:13 / cg"
!

blockNodeRewriteHookFor:aBlockNode
    "invoked whenever a block node has been generated;
     gives subclasses a chance to rewrite (instrument) it"

    ^ aBlockNode

    "Created: / 28-04-2010 / 14:18:30 / cg"
!

messageNodeRewriteHookFor:aMessageNode
    "invoked whenever a message send node has been generated;
     gives subclasses a chance to rewrite (instrument) it"

    ^ aMessageNode

    "Created: / 27-04-2010 / 11:35:31 / cg"
!

statementListRewriteHookFor:aStatementNode
    "invoked whenever a statement list node has been generated;
     gives subclasses a chance to rewrite (instrument) it"

    ^ aStatementNode

    "Created: / 28-04-2010 / 14:18:30 / cg"
!

variableReadRewriteHookFor:aVariableNode
    "invoked whenever a variable node has been generated;
     gives subclasses a chance to rewrite (instrument) it"

    ^ aVariableNode

    "Created: / 30-09-2011 / 12:17:48 / cg"
! !

!Parser methodsFor:'coding style checks'!

checkBlockArgumentNameConventionsFor:aVariableName
    self checkLocalVariableNameConventionsFor:aVariableName.

    "Modified: / 16-03-2012 / 18:40:55 / cg"
!

checkBlockVariableNameConventionsFor:aVariableName
    self checkLocalVariableNameConventionsFor:aVariableName.

    "Modified: / 16-03-2012 / 18:40:48 / cg"
!

checkBracketParenthesisMistakeInIfOrWhile:aNode from:startPosition to:endPosition
    |sel receiver|

    aNode isMessage ifTrue:[
        sel := aNode selector.
        receiver := aNode receiver.

        (sel = #and: or:[sel = #or:]) ifTrue:[
            aNode arg1 realNode isBlockNode ifFalse:[
                (aNode arg1 isVariable
                and:[ (aNode arg1 name asLowercase includesString:'block')]) ifFalse:[
                    self warnCommonMistake:'(possible common mistake) missing block brackets ?'
                              position:endPosition+1 to:tokenPosition-1
                ]
            ].
        ].

        (sel = #whileTrue: or:[sel = #whileFalse:]) ifTrue:[
            receiver realNode isBlockNode ifFalse:[
                (receiver isVariable
                and:[ (receiver name asLowercase includesString:'block')]) ifFalse:[
                    self warnCommonMistake:'(possible common mistake) missing block brackets ?'
                              position:startPosition to:endPosition
                ]
            ].
        ].

        (sel = #ifTrue: or:[sel = #ifFalse:]) ifTrue:[
            receiver isMessage ifTrue:[
                (receiver selector = #whileTrue or:[receiver selector = #whileFalse]) ifTrue:[
                    self warnCommonMistake:'strange receiver expression'
                              position:startPosition to:endPosition
                ].
            ].
        ].
    ].

    "Created: / 19-01-2012 / 10:44:05 / cg"
!

checkForLowercaseVariableName:aVariableName
    |msg|

    self shouldPerformCodingStyleChecks ifFalse:[^ self ].

    aVariableName isUppercaseFirst ifTrue:[
        msg := ('variable "' , aVariableName , '" should be lowercase (by convention)').
        self
            warning:msg
            doNotShowAgainAction:[ ParserFlags warnAboutNonLowercaseLocalVariableNames:false.
                                   parserFlags warnAboutNonLowercaseLocalVariableNames:false.]
            position:tokenPosition to:source position.

        Tools::ToDoListBrowser notNil ifTrue:[
            self
                notifyTodo:msg position:tokenPosition
                className:(self classToCompileFor name) selector:selector
                severity:#warning priority:#medium
                equalityParameter:nil
                checkAction:nil.
        ].
    ].

    "Modified: / 18-10-2006 / 19:38:20 / cg"
!

checkForProperUseOfArticleInVariableName:aVariableName
    "heuristic - and wrong !!
     The problem is that a simple rule like anyVowel is not sufficient.
     I'd be happy to get some help on that."

    |soundsLikeVowel firstCharacterAfterArticle rest whatShouldItBeNamed msg|

    self shouldPerformCodingStyleChecks ifFalse:[^ self ].

    soundsLikeVowel := [:word |
        |soundsLikeVowel firstCharacter|

        soundsLikeVowel := false.
        firstCharacter := word first.
        ('AEIX' includes:firstCharacter) ifTrue:[
            soundsLikeVowel := true.
        ] ifFalse:[
            firstCharacter := word first.
            "/ U and H sound like a vowel, if followed by two more non-vowels

            ('UH' includes:firstCharacter) ifTrue:[
                word size > 2 ifTrue:[
                    (word at:2) isVowel ifFalse:[
                        (word at:3) isVowel ifFalse:[
                            soundsLikeVowel := true.
                        ].
                    ].
                ].
            ].
            "/ R sound like a vowel, if followed by a consonant
            ('R' includes:firstCharacter) ifTrue:[
                word size > 2 ifTrue:[
                    (word at:2) isVowel ifFalse:[
                        soundsLikeVowel := true.
                    ].
                ].
            ].
            "/ O sound like a vowel, if not followed by 'ne'
            ('O' includes:firstCharacter) ifTrue:[
                word size > 2 ifTrue:[
                    (word copyTo:3) asLowercase = 'one' ifFalse:[
                        soundsLikeVowel := true.
                    ].
                ].
            ].
            "/ S sounds like a vowel, if followed by UC-consonant followed by vocal
            "/ aSBrowser -> anSBrowser
            ('S' includes:firstCharacter) ifTrue:[
                word size > 3 ifTrue:[
                    ((word at:2) isVowel not
                    and:[ (word at:2) isUppercase
                    and:[ (word at:3) isVowel]]) ifTrue:[
                        soundsLikeVowel := true.
                    ].
                ].
            ].
            "/ M sounds like a vowel, if followed by UC-consonant followed by consonant
            "/ anMC  aMA
            ('MN' includes:firstCharacter) ifTrue:[
                word size > 2 ifTrue:[
                    ((word at:2) isVowel not
                    and:[ (word at:2) isUppercase
                    and:[ (word at:3) isVowel not]]) ifTrue:[
                        soundsLikeVowel := true.
                    ].
                ].
            ].
        ].
        soundsLikeVowel.
    ].

    aVariableName size > 4 ifTrue:[
        (aVariableName startsWith:'an') ifTrue:[
            firstCharacterAfterArticle := aVariableName at:3.
            firstCharacterAfterArticle isUppercase ifTrue:[
                rest := aVariableName copyFrom:3.
                (soundsLikeVowel value:rest) ifFalse:[
                    whatShouldItBeNamed := 'a' , rest.
                ]
            ].
        ] ifFalse:[
            (aVariableName startsWith:'a') ifTrue:[
                firstCharacterAfterArticle := aVariableName at:2.
                firstCharacterAfterArticle isUppercase ifTrue:[
                    rest := aVariableName copyFrom:2.
                    (soundsLikeVowel value:rest) ifTrue:[
                        whatShouldItBeNamed := 'an' , rest.
                    ].
                ].
            ].
        ].
        whatShouldItBeNamed notNil ifTrue:[
"/            self
"/                warnCommonMistake:('variable "',aVariableName,'" should be named "',whatShouldItBeNamed,'" (by english language rules)')
"/                position:tokenPosition to:source position1Based - 1.
            msg := ('variable "%1" should be named "%2" (by english language rules)\But please check - I don''t know all exceptions and may be wrong ;-(') withCRs
                    bindWith:aVariableName with:whatShouldItBeNamed.
            self
                warning:msg
                doNotShowAgainAction:[ parserFlags warnAboutWrongVariableNames:false. ParserFlags warnAboutWrongVariableNames:false ]
                doNotShowAgainForThisMethodAction: [ self disableWarningsOnCurrentMethodFor: #warnAboutWrongVariableNames ]
                position:tokenPosition to:source position.

            Tools::ToDoListBrowser notNil ifTrue:[
                self
                    notifyTodo:msg position:tokenPosition
                    className:(self classToCompileFor name) selector:selector
                    severity:#warning priority:#low
                    equalityParameter:nil
                    checkAction:nil.
            ].
        ].
    ].

    "Modified: / 16-03-2012 / 18:36:43 / cg"
!

checkLocalVariableNameConventionsFor:aVariableName
    |msg|

    self shouldPerformCodingStyleChecks ifFalse:[^ self ].

    parserFlags warnAboutVariableNameConventions == true ifTrue:[
        parserFlags warnAboutNonLowercaseLocalVariableNames == true ifTrue:[
            self checkForLowercaseVariableName:aVariableName.
        ].
        parserFlags warnAboutShortLocalVariableNames == true ifTrue:[
            aVariableName size <= 2 ifTrue:[
                (#(
                    'x' 'y' 'ex'
                ) includes:aVariableName)
                ifFalse:[
                    msg := ('short variable name: "' , aVariableName , '"').
                    self
                        warning:('short variable name: "' , aVariableName , '"')
                        doNotShowAgainAction:[ ParserFlags warnAboutShortLocalVariableNames:false]
                        position:tokenPosition to:source position.

                    Tools::ToDoListBrowser notNil ifTrue:[
                        self
                            notifyTodo:msg position:tokenPosition
                            className:(self classToCompileFor name) selector:selector
                            severity:#warning priority:#medium
                            equalityParameter:nil
                            checkAction:nil.
                    ].
                ].
            ].
        ].
    ].
    parserFlags warnAboutWrongVariableNames == true ifTrue:[
        (ParserFlags isFlag:#warnAboutWrongVariableNames enabledForClass:classToCompileFor selector:selector) ifTrue:[
            self checkForProperUseOfArticleInVariableName:aVariableName.
        ].
    ].

    "Modified: / 16-03-2012 / 18:42:56 / cg"
!

checkMethodArgumentNameConventionsFor:aVariableName
    self checkLocalVariableNameConventionsFor:aVariableName.

    "Modified: / 16-03-2012 / 18:40:43 / cg"
!

checkMethodVariableNameConventionsFor:aVariableName
    self checkLocalVariableNameConventionsFor:aVariableName.

    "Modified: / 16-03-2012 / 18:40:37 / cg"
!

checkPlausibilityOf:aNode from:startPosition to:endPosition
    |note fixes|
    
    (ignoreErrors or:[ignoreWarnings]) ifTrue:[^ self].
    parserFlags warnPlausibilityChecks ifFalse:[^ self].
    (ParserFlags isFlag:#warnPlausibilityChecks enabledForClass:classToCompileFor selector:selector) ifFalse:[^ self].

    note := self plausibilityCheck:aNode.
    note notNil ifTrue:[
        "/ this is a hack (which I don't like)
        (note includesString:'missing ''.''') ifTrue:[
            fixes := { CorrectByInsertingPeriod }
        ] ifFalse:[
            fixes := Parser possibleCorrectionsQuery basicNew defaultResumeValue
        ].
        PossibleCorrectionsQuery answer:fixes
        do:[
            |fix|

            fix:= self
                correctableWarning:('Plausibility Check\' withCRs, note)
                doNotShowAgainAction:[ parserFlags warnPlausibilityChecks:false. ParserFlags warnPlausibilityChecks:false ]
                doNotShowAgainForThisMethodAction: [ self disableWarningsOnCurrentMethodFor: #warnPlausibilityChecks ]
                position:startPosition to:endPosition.
            fix isBehavior ifTrue:[
                self correctWith:(fix new positionOfPeriod:aNode receiver endPosition) from:startPosition to:endPosition.
            ].
        ].
    ].

    aNode isMessage ifTrue:[
        self checkBracketParenthesisMistakeInIfOrWhile:aNode from:startPosition to:endPosition
    ].

    "Created: / 19-01-2012 / 10:44:05 / cg"
!

checkReturnedValues
    | returnsSelf returnsBoolean returnsNonBooleanLiteral|

    self shouldPerformCodingStyleChecks ifFalse:[^ self ].
    parserFlags warnInconsistentReturnValues ifFalse:[^ self].
    returnedValues isNil ifTrue:[^ self].

    returnsBoolean := returnedValues contains:[:node | node isConstant and:[node value isBoolean]].
    returnsNonBooleanLiteral := returnedValues contains:[:node | node isConstant and:[node value isBoolean not]].
    returnsSelf := returnedValues contains:[:node | node isSelf].

    returnsBoolean ifTrue:[
        (returnsNonBooleanLiteral or:[returnsSelf]) ifTrue:[
            self
                warning:'Possible Error Warning:\\Method possibly returns both boolean and non-boolean values.' withCRs
                doNotShowAgainAction:[ ParserFlags warnInconsistentReturnValues:false ]
                position:1 to:tokenPosition
        ]
    ].

    "Created: / 17.11.2001 / 10:31:03 / cg"
    "Modified: / 17.11.2001 / 10:34:16 / cg"
!

checkSelector:selector for:receiver inClass:cls
    "check whether a method with selector exists in class cls and
     that the method is not obsolete.
     If cls is nil, check all classes for the selector.
     Return an error string on error or nil on success"

    |err mthd implementor implementors allowed|

"/    self shouldPerformCodingStyleChecks ifFalse:[
"/        ^ nil 
"/    ].

    cls isNil ifTrue:[
        SystemBrowser isNil ifTrue:[
            ^ nil
        ].
        "beware, this is sort of slow, especially for the SyntaxHighlighter"
        implementors := SystemBrowser
                         findImplementorsOf:selector
                         in:(Smalltalk allClasses)
                         ignoreCase:false.
        implementors isEmpty ifTrue:[
            ^ 'is nowhere implemented'
        ].

        (implementors conform:[:eachMethod| eachMethod isObsolete]) ifTrue:[
            ^ 'every implementation of this selector in the system is deprecated'
        ].
        ^ nil
    ].

    mthd := cls lookupMethodFor:selector.
    mthd isNil ifTrue:[
        cls isMeta ifTrue:[
            mthd := Metaclass lookupMethodFor:selector.
        ].
    ].

    mthd isNil ifTrue:[
        cls == Boolean ifTrue:[
            mthd := True compiledMethodAt:selector.
            mthd isNil ifTrue:[
                mthd := False compiledMethodAt:selector.
            ].
        ]
    ].
    mthd isNil ifTrue:[
        implementor := cls whichClassIncludesSelector:#doesNotUnderstand:.
        "if it implements #doesNotUnderstand somewhere, assume it is ok"
        (implementor isNil 
            or:[implementor == Object
            or:[implementor == SequenceableCollection]]
        ) ifTrue:[
            err := 'is not implemented in ' , cls name allBold
        ].
    ] ifFalse:[
        (mthd sendsSelector:#shouldNotImplement) ifTrue:[
            mthd messagesSent size == 1 ifTrue:[
                allowed := (cls == classToCompileFor).      "methods in abstract classes may send messages to abstract methods in the same class"
                allowed ifFalse:[
                    err := 'is not (should not be) implemented'
                ]
            ]
        ] ifFalse:[
            (mthd isSubclassResponsibility) ifTrue:[
                "methods in abstract classes may send messages to abstract methods in the same class or its instances"
                allowed := (cls == classToCompileFor or:[cls class == classToCompileFor]).      
                allowed ifFalse:[
                    "methods in abstract classes may send messages to abstract methods in meta class"
                    (cls == classToCompileFor class) ifTrue:[
                        allowed := receiver isMessage and:[receiver selector = 'class']
                    ].
                ].
                allowed ifTrue:[
                    "/ cg: this is something that lint must report - not the compiler.
                    "/ if not implemented in all subclasses, it's a bug of the subclass;
                    "/ not a bug here - that message sent here is perfectly correct. 
                    "/ (it is very annoying for a framework developer to get
                    "/  error messages for bugs which are not his)
"/                    (self checkIfAllSubclassesOf:cls implement:selector) ifFalse:[
"/                        "if not all subclasses implement the selector - this is a possible bug"
"/                        allowed := false
"/                    ].
                ].
                allowed ifFalse:[
                    mthd messagesSent size == 1 ifTrue:[
                        err := 'is subclassResponsibility'
                    ] ifFalse:[
                        "/ the subclassResponsibility is probably conditional;
                        "/ we need more advanced analysis, if it is sent at all.
                    ].    
                ].
            ] ifFalse:[mthd isObsolete ifTrue:[
                err := 'is deprecated'.
            ]]
        ].
    ].
    ^ err.

    "Modified: / 16-07-2017 / 11:28:48 / cg"
    "Modified: / 09-10-2017 / 16:17:33 / stefan"
!

checkUnusedMethodVars
    | unused|

    self shouldPerformCodingStyleChecks ifFalse:[^ self ].
    parserFlags warnUnusedVars ifFalse:[^ self].

    methodVars notNil ifTrue:[
        unused := methodVars select:[:var| var used ~~ true] thenCollect:[:var| var name].
    ].
    unused size > 0 ifTrue:[
        self warnUnused:unused.
    ].

    "Created: / 17-11-2001 / 10:23:47 / cg"
    "Modified: / 07-07-2010 / 15:48:24 / cg"
!

isPossiblyUninitializedLocal:aNode
    |varName|

    aNode isLocalVariable ifFalse:[^ false].
    hasPrimitiveCode ifTrue:[^ false]. "/ because I do not look into it, yet

    varName := aNode name.
    (alreadyWarnedUninitializedVars notNil
      and:[(alreadyWarnedUninitializedVars includes:varName)]) ifTrue:[^ false].

    aNode isMethodVariable ifTrue:[
        currentBlock notNil ifTrue:[^ false].
        (modifiedLocalVars notNil and:[(modifiedLocalVars includes:varName)]) ifTrue:[^ false].
    ] ifFalse:[
        aNode isBlockVariable ifTrue:[
            aNode block == currentBlock ifFalse:[^ false].
            (currentBlock modifiedLocalVars notNil and:[(currentBlock modifiedLocalVars includes:varName)]) ifTrue:[^ false].
        ].
    ].
    ^ true.
! !

!Parser methodsFor:'dummy-syntax detection'!

markArgumentIdentifierFrom:pos1 to:pos2
    "intentionally left empty"
!

markAssignedVariable:v from:pos1 to:pos2
    "intentionally left empty"

    "Created: / 13-02-2012 / 11:40:36 / cg"
!

markBadIdentifierFrom:pos1 to:pos2
    "intentionally left empty"
!

markBlockArgumentIdentifierFrom:pos1 to:pos2
    self markArgumentIdentifierFrom:pos1 to:pos2
!

markBlockFrom:startPos to:endPos
    "intentionally left empty"

    "Created: / 15-01-2008 / 11:51:35 / cg"
!

markBooleanConstantFrom:pos1 to:pos2
    "intentionally left empty"
!

markBracketAt:pos
    "intentionally left empty"
!

markConstantFrom:pos1 to:pos2
    "intentionally left empty"
!

markGlobalClassIdentifierFrom:pos1 to:pos2
    "intentionally left empty"
!

markGlobalIdentifierFrom:pos1 to:pos2
    "intentionally left empty"
!

markHereFrom:pos1 to:pos2
    "intentionally left empty"
!

markIdentifierFrom:pos1 to:pos2
    "intentionally left empty"
!

markInstVarIdentifierFrom:pos1 to:pos2
    "intentionally left empty"
!

markLocalIdentifierFrom:pos1 to:pos2
    "intentionally left empty"
!

markLocalVariableDeclaration: variableName from:pos1 to:pos2
    self markLocalIdentifierFrom: pos1 to: pos2

    "Created: / 25-02-2014 / 20:20:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markMethodArgumentIdentifierFrom:pos1 to:pos2
    self markArgumentIdentifierFrom:pos1 to:pos2

    "Created: / 21-08-2011 / 08:11:46 / cg"
!

markMethodSelectorFrom:pos1 to:pos2
    "intentionally left empty"
!

markParenthesisAt:pos
    "intentionally left empty"
!

markReturnAt:pos
    "intentionally left empty"
!

markSelector:sel from:pos1 to:pos2 receiverNode:aNode
    "intentionally left empty"
!

markSelfFrom:pos1 to:pos2
    "intentionally left empty"
!

markSuperFrom:pos1 to:pos2
    "intentionally left empty"
!

markThisContextFrom:pos1 to:pos2  
    "intentionally left empty"

    "Created: / 20-12-2017 / 21:58:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markUnknownIdentifierFrom:pos1 to:pos2
    "intentionally left empty"
!

markVariable:v
    "intentionally left empty"
!

markVariable:v from:pos to:endPos
    "intentionally left empty"
!

markVariable:v from:pos to:endPos assigned:assigned
    "intentionally left empty"
! !

!Parser methodsFor:'error correction'!

addDoItTemporary:varName
    |holder|

    doItTemporaries isNil ifTrue:[
        doItTemporaries := IdentityDictionary new.
    ].
    doItTemporaries at:varName asSymbol put:(holder := ValueHolder new).
    ^ holder
!

alreadyWarnedUnimplementedSelectors
    alreadyWarnedUnimplementedSelectors isNil ifTrue:[
        alreadyWarnedUnimplementedSelectors := Set new
    ].
    ^ alreadyWarnedUnimplementedSelectors
!

alreadyWarnedUnimplementedSelectorsPerReceiverClass
    AlreadyWarnedUnimplementedSelectorsPerReceiverClass isNil ifTrue:[
        AlreadyWarnedUnimplementedSelectorsPerReceiverClass := Dictionary new
    ].
    ^ AlreadyWarnedUnimplementedSelectorsPerReceiverClass
!

askForCorrection:aString fromList:aList
    "launch a selection box, which allows user to enter correction.
     return newString or nil (for abort)"

    |box rslt|

    "in systems without widgets ..."
    ListSelectionBox isNil ifTrue:[
        ^ self confirm:aString
    ].
    box := ListSelectionBox title:aString.
    box initialText:(aList at:1).
    box list:aList.
    box okText:'Correct'.
    box action:[:aString | rslt := aString].
    box showAtPointer.
    box destroy.
    ^ rslt
!

askForCorrection:aString fromList:aList for:originalSelector
    "launch a selection box, which allows user to enter correction.
     return newString or nil (for abort)"

    |box rslt|

    "in systems without widgets ..."
    ListSelectionBox isNil ifTrue:[
        ^ self confirm:aString
    ].
    box := ListSelectionBox title:aString.
    box initialText:(aList firstIfEmpty:originalSelector).
    box list:aList.
    box okText:'Correct'.
    box action:[:aString | rslt := aString].
    box addButton:(Button label:'Keep Selector' action:[rslt := originalSelector. box hide]) after:(box okButton).
    box showAtPointer.
    box destroy.
    ^ rslt
!

askForVariableTypeWhenDeclaringUndefined:varName
    |typeChoice|

    typeChoice := (AskForVariableTypeOfUndeclaredQuery new
        parser:self nameOfUnknownVariable:varName) query.

"/
"/    l := OrderedCollection new.
"/    how := OrderedCollection new.
"/
"/    varNameIsLowercase := (varName at:1) isLowercase.
"/
"/    "/ BlockVar, InstVar and classInstVar not yet implemented
"/    varNameIsLowercase ifTrue:[
"/"/            currentBlock notNil ifTrue:[
"/"/                l add: 'Block local'.
"/"/                how add: #BlockVariable.
"/"/            ].
"/        selector notNil ifTrue:[
"/            l add: 'Method Local Variable'.
"/            how add: #MethodVariable.
"/        ].
"/        (classToCompileFor notNil
"/        and:[classToCompileFor isMeta not
"/        and:[classToCompileFor isBuiltInClass not
"/        and:[(self isDoIt not)]]]) ifTrue:[
"/            l add:'Instance Variable'.
"/            how add: #InstanceVariable.
"/        ].
"/    ] ifFalse:[
"/        l addAll: #( 'New Class' 'Global' 'NameSpace' ).
"/        how addAll: #( NewClass GlobalVariable NameSpace ).
"/
"/        (classToCompileFor notNil
"/        and:[classToCompileFor isBuiltInClass not
"/        and:[self isDoIt not]]) ifTrue:[
"/            classToCompileFor isMeta ifTrue:[
"/                l add: 'Class Instance Variable'.
"/                how add: #ClassInstanceVariable.
"/            ].
"/            l add: 'Class Variable'.
"/            how add: #ClassVariable.
"/            l add: 'Private Class'.
"/            how add: #PrivateClass.
"/        ]
"/    ].
"/    self isDoIt ifTrue:[
"/        l size > 0 ifTrue:[
"/            l := l ,  #( '-' ).
"/            how := how , #( nil ).
"/        ].
"/        l addAll: #('Workspace Variable' 'DoIt Temporary').
"/        how addAll: #( WorkspaceVariable DoItTemporary ).
"/    ].
"/
"/    l size > 0 ifTrue:[
"/        l := (Array with:('Declare ' , varName allBold , ' as:')
"/                    with:'-'
"/             ) , l.
"/        how := #(nil nil) , how.
"/        popupMenu := PopUpMenu labels:l.
"/
"/        choiceIndex := popupMenu startUp.
"/        (choiceIndex notNil and:[choiceIndex > 0]) ifTrue:[
"/            typeChoice := how at:choiceIndex.
"/        ].
"/    ].

    typeChoice notNil ifTrue:[
        ^ self declareUndefinedVariable:varName as:typeChoice
    ].
    ^ nil.

    "Modified: / 20-10-2010 / 18:30:27 / cg"
!

checkIfAllSubclassesOf:aClass implement:aSelector
    ^ aClass subclasses conform:[:cls | (cls includesSelector:aSelector)]

    "Modified: / 13-09-2006 / 11:40:52 / cg"
!

correctSelector:aSelectorString message:msg positions:posVector in:aClassOrNil for:receiverNode
    "notify error and correct if user wants to;
     return #Error if there was no correction
     or a ParseNode as returned by variable"

    |correctIt suggestedNames newSelector pos1 pos2 fixes
     positionOfPeriod alreadyPerClass|

    (self alreadyWarnedUnimplementedSelectors includes:aSelectorString) ifTrue:[
        ^ aSelectorString
    ].
    aClassOrNil notNil ifTrue:[
        alreadyPerClass := self alreadyWarnedUnimplementedSelectorsPerReceiverClass at:aClassOrNil ifAbsent:nil.
        alreadyPerClass notNil ifTrue:[
            (alreadyPerClass includes:aSelectorString) ifTrue:[
                ^ aSelectorString
            ].
        ].
    ].

    pos1 := posVector first start.
    pos2 := posVector last stop.

    "/ also highlight the receiver; looks better in browser
    receiverNode startPosition notNil ifTrue:[
        pos1 := pos1 min:(receiverNode startPosition).
    ].

    (msg includesString:'deprecated') ifTrue:[
        fixes := { CorrectByChangingSelector }.
    ] ifFalse:[
        "
         sorry, but I cannot handle keywords with more than one-part
         currently (too much work - maybe I'll do it later when everything else works :-)
        "
        false "(aSelectorString occurrencesOf:$:) > 1" ifTrue:[
            fixes := { CorrectByGeneratingMissingMethod }.
        ] ifFalse:[
            fixes := { CorrectByChangingSelector . CorrectByGeneratingMissingMethod }.
        ].

        aSelectorString isKeywordSelector ifTrue:[
            |parts possibleSplits|

            possibleSplits := OrderedCollection new.
            parts := aSelectorString partsIfSelector.
            1 to:parts size-1 do:[:sepIdx |
                |msg1 msg2 msg1Ok msg2Ok|

                msg1 := (parts copyTo:sepIdx) asStringWith:''.
                msg2 := (parts copyFrom:sepIdx+1) asStringWith:''.
                (msg1 := msg1 asSymbolIfInterned) notNil ifTrue:[
                    (msg2 := msg2 asSymbolIfInterned) notNil ifTrue:[
                        aClassOrNil notNil ifTrue:[
                            msg1Ok := aClassOrNil canUnderstand:msg1
                        ] ifFalse:[
                            msg1Ok := (SystemBrowser
                                    findImplementorsOf: msg1
                                    in: Smalltalk allClasses
                                    ignoreCase: false) notEmpty.
                        ].
                        msg2Ok := (SystemBrowser
                                    findImplementorsOf: msg2
                                    in: Smalltalk allClasses
                                    ignoreCase: false) notEmpty.

                        (msg1Ok and:[msg2Ok]) ifTrue:[
                            possibleSplits add:{ msg1 . msg2 }
                        ] ifFalse:[
    self breakPoint:#cg.
                        ]
                    ] ifFalse:[
    "/ self breakPoint:#cg.
                    ]
                ].
            ].
            possibleSplits notEmpty ifTrue:[
                fixes := fixes copyWith: (CorrectByGroupingMessage new
                                            possibleSplits:possibleSplits;
                                            selectorPositions:posVector).
            ].
        ].
    ].

    "/ a hack - don't like looking into string; needs fix (caller must pass in possible corrections)
    (msg includesString:'issing ''.''') ifTrue:[
        receiverNode notNil ifTrue:[
            positionOfPeriod := receiverNode endPosition.
            fixes := fixes copyWith: CorrectByInsertingPeriod.
        ].
    ].
    (msg includesString:'hex integer') ifTrue:[
        (receiverNode notNil
        and:[ receiverNode isConstant
        and:[ receiverNode value == 0
        and:[ (aSelectorString asLowercase startsWith:'x')
        and:[ aSelectorString from:2 conform:[:ch | ch isDigitRadix:16]
        ]]]]) ifTrue:[
            fixes := fixes copyWith:CorrectByMakingValidHexConstant
        ].
    ].

    PossibleCorrectionsQuery answer:fixes do:[
        correctIt := self correctableWarning:msg position:pos1 to:pos2.
    ].
    (correctIt isBehavior or:[correctIt isKindOf:Correction]) ifTrue:[
        self
            correctWith:(correctIt instance
                            positionOfPeriod:positionOfPeriod;
                            receiverNode:receiverNode;
                            receiverClass:aClassOrNil;
                            selector:aSelectorString)
            from:pos1 to:pos2.
        "/ normally not reached (unless, the corrector did something somewhere else,
        "/ and no change is needed here)
        correctIt := false.
    ].

"/ code moved to CorrectByGeneratingMissing
"/    correctIt == #generate ifTrue:[
"/        receiverNode isSelf ifTrue:[
"/            classToGenerateCode := classToCompileFor
"/        ] ifFalse:[
"/            receiverNode isVariable ifTrue:[
"/                receiverNode isGlobal ifTrue:[
"/                    classToGenerateCode := receiverNode evaluate.
"/                    classToGenerateCode isBehavior ifTrue:[
"/                        classToGenerateCode :=  classToGenerateCode theMetaclass.
"/                    ] ifFalse:[
"/                        classToGenerateCode := nil
"/                    ].
"/                ].
"/            ]
"/        ].
"/        classToGenerateCode isNil ifTrue:[
"/            className := Dialog request:'Generate code in class:' initialAnswer:classToCompileFor name.
"/            className size == 0 ifTrue:[
"/                ^ aSelectorString
"/            ].
"/            classToGenerateCode := Smalltalk at:className asSymbol.
"/            classToGenerateCode isNil ifTrue:[
"/                self warn:'No such class.'.
"/                ^ aSelectorString
"/            ].
"/        ].
"/        (classToGenerateCode includesSelector:aSelectorString asSymbol) ifFalse:[
"/            |code category wantSetter wantGetter|
"/
"/            wantSetter := wantGetter := false.
"/
"/            (aSelectorString isKeywordSelector
"/            and:[aSelectorString numArgs == 1
"/            and:[classToGenerateCode instVarNames includes:(aSelectorString copyButLast:1)]]) ifTrue:[
"/                "/ want a setter ?
"/                wantSetter := Dialog confirmWithCancel:('Create a setter for %1 ?' bindWith:(aSelectorString copyButLast:1) allBold).
"/                wantSetter isNil ifTrue:[^ aSelectorString].
"/            ] ifFalse:[
"/                (aSelectorString isUnarySelector
"/                and:[classToGenerateCode instVarNames includes:aSelectorString]) ifTrue:[
"/                    "/ want a getter ?
"/                    wantGetter := Dialog confirmWithCancel:('Create a getter for %1 ?' bindWith:aSelectorString allBold).
"/                    wantGetter isNil ifTrue:[^ aSelectorString].
"/                ]
"/            ].
"/            wantSetter ifTrue:[
"/                code := ('%1:something\    %1 := something.' bindWith:(aSelectorString copyButLast:1)) withCRs.
"/                category := 'accessing'.
"/            ] ifFalse:[
"/                wantGetter ifTrue:[
"/                    code := ('%1\    ^ %1.' bindWith:aSelectorString) withCRs.
"/                    category := 'accessing'.
"/                ] ifFalse:[
"/                    code := (self class methodSpecificationForSelector:aSelectorString) , '\    self shouldImplement' withCRs.
"/                    category := Compiler defaultMethodCategory.
"/                ].
"/            ].
"/
"/            "do not overwrite an already existing (deprecated) method"
"/            classToGenerateCode
"/                compile:code
"/                classified:category.
"/        ].
"/        correctIt := false.
"/    ].
    (correctIt == false or:[correctIt == #continue]) ifTrue:[
        alreadyWarnedUnimplementedSelectors add:aSelectorString.
        ^ aSelectorString
    ].

    suggestedNames := self findBestSelectorsFor:aSelectorString in:aClassOrNil.
    suggestedNames notEmptyOrNil ifTrue:[
        newSelector := self askForCorrection:'Correct Selector to: ' fromList:suggestedNames for:aSelectorString.
        newSelector isNil ifTrue:[AbortOperationRequest raise "^ aSelectorString"].
    ] ifFalse:[
        self information:'no good correction found'.
        ^ aSelectorString
    ].

    "
     tell requestor (i.e. CodeView) about the change
     this will update what the requestor shows.
    "
    requestor replaceSelectionBy:newSelector keepCursor:false.
    "
     get the updated source-string
     which is needed, when we eventually install the new method
    "
    correctedSource := requestor currentSourceCode.
    source := (ReadStream on:correctedSource)
                  position:(source position + (newSelector size - aSelectorString size)).
    ^ newSelector

    "Created: / 19-01-2000 / 16:34:01 / cg"
    "Modified: / 28-08-2013 / 22:32:57 / cg"
    "Modified: / 19-01-2017 / 13:21:53 / stefan"
!

correctSourceByDeletingFrom:start to:stop
    "correct (by deleting token) if user wants to;
     return #Error if there was no correction;
     nil if there was one."

    |deleteSize localDefsStart localDefsStop newPos|

    "
     tell requestor (i.e. CodeView) about the change
     this will update what the requestor shows.
    "
    deleteSize := stop - start + 1.
    requestor deleteFromCharacterPosition:start to:stop.

    "
     get the updated source-string
     which is needed, when we eventually install the new method
    "
    correctedSource := requestor currentSourceCode.

    "/ update the current source position
    source atEnd ifTrue:[
        newPos := correctedSource size.
    ] ifFalse:[
        source position + 1 >= stop ifTrue:[
            newPos := source position - deleteSize.
        ] ifFalse:[
            source position + 1 < start ifTrue:[
                newPos := source position.
            ] ifFalse:[
                newPos := start-1.
            ].
        ]
    ].
    source := (ReadStream on:correctedSource) position:newPos.

    localDefsStart := localVarDefPosition at:1.
    localDefsStop := localVarDefPosition at:2.

    localDefsStop isNil ifTrue:[^ self].    "/ we have not yet parsed the locals def
    localDefsStop <= start ifTrue:[^ self].
    localDefsStart >= stop ifTrue:[^ self].

    (localDefsStart >= start and:[localDefsStop <= stop]) ifTrue:[
        localVarDefPosition := nil.
        ^ self
    ].

    "/ must update
    (start > localDefsStart and:[stop < localDefsStop]) ifTrue:[
        localVarDefPosition at:2 put:(localDefsStop - (stop-start+1)).
        ^ self.
    ].
    ^ self
!

correctVariable:varName atPosition:pos1 to:pos2
    "notify error and correct if user wants to;
     return #Error if there was no correction
     or a ParseNode as returned by variable"

    |correctIt suggestedNames newName rslt
     varNameIsLowercase undeclared boldName sameForAll|

    "/ do not change to isLowercase because of $_ 
    varNameIsLowercase := varName isUppercaseFirst not.

    sameForAll := false.
    (correctIt := variableCorrectActionForAll) isNil ifTrue:[
        SameForAllNotification handle:[:ex |
            sameForAll := true.
            ex proceed.
        ] do:[
            correctIt := self undefError:varName position:pos1 to:pos2.
        ].
    ].

    correctIt == #Error ifTrue:[
        ^ #Error
    ].

    sameForAll == true ifTrue:[
        variableCorrectActionForAll := correctIt.
        variableTypeOfLastCorrectAction := nil.
        correctIt == false ifTrue:[
            parserFlags warnUndeclared:false.
        ].
    ].
    "/ backward compatibility (symbols) will vanish...
    ((correctIt == #declare)
    or:[correctIt == CorrectByDeclaringIdentifierAs
    or:[correctIt isKindOf: Correction]]) ifTrue:[
        "/ declare it
        (((variableCorrectActionForAll == #declare)
         or:[ correctIt isKindOf: CorrectByDeclaringIdentifierAs ])
        and:[ variableTypeOfLastCorrectAction notNil ]) ifTrue:[
            rslt := self declareUndefinedVariable:varName as:variableTypeOfLastCorrectAction.
            ^ rslt
        ].
        rslt := self askForVariableTypeWhenDeclaringUndefined:varName.
        rslt notNil ifTrue:[
            variableTypeOfLastCorrectAction := rslt type.
            ^ rslt
        ].
        correctIt := #continue.
    ].
    (correctIt == false or:[correctIt == #continue]) ifTrue:[
        "/ no correction wanted.

        "/ lowerCase vars are added to the Undeclared dictionary,
        "/ allowing easy search for bad-spots later.
        boldName := varName allBold.

        varNameIsLowercase ifTrue:[
            undeclared := Smalltalk at:#Undeclared.
            ((undeclared notNil)
            and:[(undeclared includes:varName asSymbol)]) ifFalse:[
                self warning:('Adding ''' , boldName , ''' as Undeclared.\\Remember to fix that later.') withCRs position:pos1 to:pos2.
            ].
            rslt := self defineAsUndeclaredVariable:varName.
            rslt startPosition: pos1 endPosition: pos2.
            ^ rslt
        ].

        "/ upperCase vars are declared as global
"/        parserFlags warnings ifTrue:[
"/            parserFlags warnUndeclared ifTrue:[
"/                (warnedUndefVars isNil or:[(warnedUndefVars includes:varName) not]) ifTrue:[
"/                    (warnedUnknownNamespaces isNil or:[(warnedUnknownNamespaces includes:varName) not]) ifTrue:[
"/                        self warning:('adding ''' , boldName , ''' as Global.') withCRs position:pos1 to:pos2.
"/                    ]
"/                ].
"/            ].
"/        ].
        ^ (VariableNode globalNamed:varName) startPosition: pos1 endPosition: pos2.
    ].

    (correctIt isKindOf:ParseNode) ifTrue:[
        ^ correctIt
    ].

    suggestedNames := self findBestVariablesFor:varName.
    suggestedNames isNil ifTrue:[
        self information:'No good correction found'.
        ^ #Error
    ].

    newName := self askForCorrection:'Correct Variable to: ' fromList:suggestedNames.
    newName isNil ifTrue:[^ #Error].
"
        newName := suggestedNames at:1.
        (self confirm:('confirm correction to: ' , newName)) ifFalse:[^ #Error].
"

    "
     tell requestor (i.e. CodeView) about the change
     this will update what the requestor shows.
    "
    requestor replaceSelectionBy:newName.
    "
     get the updated source-string
     which is needed, when we eventually install the new method
    "
    correctedSource := self currentSource.
    source := (ReadStream on:correctedSource)
                  position:(source position + 1 + newName size - tokenName size).

    "redo parse with new value"
    token := tokenName := newName.
    rslt := self variableOrError:tokenName.

    "/ failed again ?
    rslt == #Error ifTrue:[
        "/ install as Undeclared:<name>, remember in #undeclared

       rslt := self defineAsUndeclaredVariable:varName.
       rslt startPosition: pos1 endPosition: pos2.
    ].
    ^ rslt

    "Modified: / 22-01-1998 / 16:34:01 / stefan"
    "Modified: / 29-07-2013 / 23:11:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2017 / 22:08:36 / cg"
!

correctWith:correctionOperation from:pos1 to:pos2
    |newSource|

    newSource := correctionOperation fixFrom:pos1 to:pos2 for:self.
    newSource notNil ifTrue:[
        correctedSource := newSource.
        requestor contents:newSource keepUndoHistory:true.
        RestartCompilationSignal raiseRequest.
    ].
    ^ #Error
!

declareUndefinedVariable:varName as:variableType
    |holder newClass owningClass|

    variableType == #WorkspaceVariable ifTrue:[
        holder := Workspace addWorkspaceVariable:varName.
        ^ VariableNode type:#WorkspaceVariable holder:holder name:varName
    ].
    variableType == #DoItTemporary ifTrue:[
        holder := self addDoItTemporary:varName.
        ^ VariableNode type:#DoItTemporary holder:holder name:varName
    ].
    variableType == #GlobalVariable ifTrue:[
        Smalltalk at:varName asSymbol put:nil.
        ^ VariableNode globalNamed:varName
    ].

    variableType == #NewClass ifTrue:[
        newClass := Object subclass:varName asSymbol
               instanceVariableNames:''
               classVariableNames:''
               poolDictionaries:''
               category:'* As yet uncategorized *'.
        ^ VariableNode globalNamed:newClass name
    ].

    variableType == #PrivateClass ifTrue:[
        owningClass := classToCompileFor theNonMetaclass.
        newClass := Object subclass:varName asSymbol
               instanceVariableNames:''
               classVariableNames:''
               poolDictionaries:''
               privateIn:owningClass.
        ^ VariableNode type:#PrivateClass class:owningClass name:newClass name
    ].

    variableType == #NameSpace ifTrue:[
        NameSpace name:varName.
        ^ VariableNode globalNamed:varName
    ].

    variableType == #ClassVariable ifTrue:[
        classToCompileFor theNonMetaclass addClassVarName:varName.
        ^ VariableNode type:#ClassVariable class:classToCompileFor theNonMetaclass name:varName
    ].

    variableType == #InstanceVariable ifTrue:[
        classToCompileFor theNonMetaclass addInstVarName:varName.
        "/ ST/X special - old classToCompileFor is obsoleted - refetch
        classToCompileFor := Smalltalk classNamed:(classToCompileFor name).
        RestartCompilationSignal raiseRequest.
        "/ not reached - restarted compile will not arrive here again
        self error:'restart compile failed'.
    ].

    variableType == #ClassInstanceVariable ifTrue:[
        classToCompileFor theMetaclass addInstVarName:varName.
        "/ ST/X special - old classToCompileFor is obsoleted - refetch
        classToCompileFor := Smalltalk classNamed:(classToCompileFor name).
        RestartCompilationSignal raiseRequest.
        "/ not reached - restarted compile will not arrive here again
        self error:'restart compile failed'.
    ].

    variableType == #MethodVariable ifTrue:[
        |varIndex var endLocalsPos posToInsert ins space spaceString |

        "JV@2012-07-02: Changed to respect formatting settings"
        space := UserPreferences current at:#'formatter.spaceAroundTemporaries' ifAbsent:[false].
        spaceString := space ifTrue:[' '] ifFalse:[''].

        localVarDefPosition size == 2 ifTrue:[
            endLocalsPos := posToInsert := localVarDefPosition at:2.
            space ifTrue:[
                "/ Is there already a space after last temporary?
                ((requestor contents at: posToInsert - 1 ) isSeparator) ifTrue:[
                    ins := varName , spaceString
                ] ifFalse:[
                    ins := ' ' , varName , spaceString
                ]
            ] ifFalse:[
                ins := ' ' , varName.
            ].
        ] ifFalse:[
            endOfSelectorPosition notNil ifTrue:[
                 posToInsert := beginOfBodyPosition.
                 ins := '|' , spaceString, varName , spaceString , '|' , Character cr asString , Character cr asString.
                 ins := ins , (String new:(requestor colOfCharacterPosition:posToInsert)-1).
            ]
        ].
        posToInsert notNil ifTrue:[
            requestor
                insertString:ins
                atCharacterPosition:posToInsert.
            correctedSource := requestor currentSourceCode asString string.

            endLocalsPos notNil ifTrue:[
                localVarDefPosition at:2 put:(endLocalsPos + varName size + 1).
                "/ sigh - methodVarNames is nil if decl is empty
                methodVarNames := (methodVarNames ? #()) copyWith:varName.
                methodVars := (methodVars ? #()) copyWith:(var := Variable new name:varName).
            ] ifFalse:[
                localVarDefPosition := Array with:posToInsert with:posToInsert+varName size+1+(space ifTrue:[2] ifFalse:[0]).

                methodVarNames := Array with:varName.
                methodVars := Array with:(var := Variable new name:varName).
            ].
            source := (ReadStream on:correctedSource)
                          position:(source position + 1 + ins size).

            varIndex := methodVarNames size.
            var used:true.
            ^ VariableNode type:#MethodVariable
                           name:varName
                           token:var
                           index:varIndex
        ].
    ].
    self warning:'sorry - unimplemented (adding ' , variableType , ')'.

    "Created: / 14-10-2010 / 11:04:27 / cg"
    "Modified: / 20-10-2010 / 18:36:32 / cg"
    "Modified (comment): / 04-07-2012 / 13:05:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defineAsUndeclaredVariable:aName
    "define varName as undeclared variable
     (actually, it will be installed as a funny global named 'Undeclared:::<name>').
     You can browse for methods with undeclareds by searching for global accesses
     to 'Undeclared:::*' (or use the search-undeclared item in the launchers menu)."

    |varName undeclared|

    varName := aName.

    "/ install as Undeclared:<name>, remember in Undeclared

    undeclared := Smalltalk at:#Undeclared.
    undeclared isNil ifTrue:[
        Smalltalk at:#Undeclared put:(undeclared := IdentitySet new).
    ].
    undeclared add:tokenName asSymbol.
    varName := (Smalltalk undeclaredPrefix) , tokenName.
    varName := varName asSymbol.
    Smalltalk at:varName put:nil.

    parseForCode ifFalse:[self rememberGlobalUsed:aName].

    ^ VariableNode globalNamed:varName

    "Modified: / 31.10.1997 / 01:16:03 / cg"
!

deleteDefinitionOf:varName in:defStartPosArg to:defEndPosArg
    "this removes the definition of varName from the declaration part i.e.
     if the source was '... | foo bar baz |...'
     deleting the var 'bar' changes the source to '... | foo baz |...'.
     The code below tries to be somewhat smart w.r.t. spaces by
     trying to remove the whiteSpace around the removed variable also.
     However, this seems to not always work correctly"

    |source startSearch pos pos2 nextChar varSlot p p2
     defStartPos defEndPos|

    varSlot := methodVars detect:[:var | var name = varName].
    methodVars removeIdentical:varSlot.

    source := self currentSource.

    defStartPos := defStartPosArg.
    defEndPos := defEndPosArg.

    "/ in case not the position of the var-decl bars, but of the varName is passed in
    (source at:defStartPos) == $| ifFalse:[
        defStartPos := source lastIndexOf:$| startingAt:defStartPos+1.
    ].
    (source at:defEndPos) == $| ifFalse:[
        defEndPos := source indexOf:$| startingAt:defEndPos+1.
    ].
    startSearch := defStartPos+1.

    [
        |prevChar isFirstVar didPassEndOfLine|

        "/ search this name's position in the declaration part ...
        pos := source indexOfSubCollection:varName startingAt:startSearch ifAbsent:[0].
        (pos == 0 or:[pos >= defEndPos]) ifTrue:[
            self error:'should not happen' mayProceed:true.
            ^ self.
        ].

        pos2 := pos + varName size - 1.
        pos > 1 ifTrue:[
            prevChar := source at:pos-1.
        ].
        (prevChar isNil or:[prevChar isLetterOrDigit not]) ifTrue:[
            nextChar := source at:pos2+1.
            nextChar isLetterOrDigit ifFalse:[
                "/ halfway intuitive space-removal behavior;
                "/ if there was a space after/before the |-char,
                "/ leave it; otherwise remove it.
                isFirstVar := pos == (defStartPos+1).
                (source at:pos-1) isSeparator ifTrue:[
                    pos := pos - 1.
                    [ (source at:pos-1) isSeparator] whileTrue:[
                        pos := pos - 1.
                    ].
                    (source at:pos-1) == $| ifTrue:[
                        "/ there was a space before - leave it
                        pos := pos + 1.
                        isFirstVar := true.
                    ]
                ].

                (source at:pos2+1) isSeparator ifTrue:[
                    didPassEndOfLine := (source at:pos2+1) == Character cr.
                    pos2 := pos2 + 1.
                    [ (source at:pos2+1) isSeparator] whileTrue:[
                        (source at:pos2+1) == Character cr ifTrue:[ didPassEndOfLine := true ].
                        pos2 := pos2 + 1.
                    ].

                    didPassEndOfLine ifFalse:[
                        (source at:pos2+1) == $" ifTrue:[
                            "/ comment follows - assume it belongs to the removed variable
                            pos2 := pos2 + 1.
                            (source at:pos2+1) == $/ ifTrue:[
                                "/ EOL comment
                                [ (source at:pos2+1) == Character cr ] whileFalse:[
                                    pos2 := pos2 + 1.
                                ].
                                pos2 := pos2 + 1.
                            ] ifFalse:[
                                "/ regular comment
                                [ (source at:pos2+1) == $" ] whileFalse:[
                                    pos2 := pos2 + 1.
                                ].
                                pos2 := pos2 + 1.
                            ].
                            [ (source at:pos2+1) isSeparator] whileTrue:[
                                (source at:pos2+1) == Character cr ifTrue:[ didPassEndOfLine := true ].
                                pos2 := pos2 + 1.
                            ].
                        ]
                    ].

                    (source at:pos2+1) == $| ifTrue:[
                        "/ there was a space after - leave it
                        pos2 := pos2 - 1.
                    ] ifFalse:[
                        isFirstVar ifFalse:[
                            pos2 := pos2 - 1.
                        ]
                    ].
                ].

                "/ if this was the last, remove empty var-declaration completely
                ((source at:pos-1) == $|
                and:[ (source at:pos2+1) == $| ]) ifTrue:[
                    pos := pos - 1.
                    pos2 := pos2 + 1.
                    "/ see if that gives us an empty line
                    p := pos.
                    p2 := pos2.

                    [(source at:p-1) == Character space] whileTrue:[ p := p - 1 ].
                    [(source at:p2+1) == Character space] whileTrue:[ p2 := p2 + 1 ].
                    ((source at:p-1) == Character cr and:[ (source at:p2+1) == Character cr]) ifTrue:[
                        pos := p-1.
                        pos2 := p2.
                        (((source at:pos-1) == Character cr) and:[((source at:pos-2) == Character cr)])
                            ifTrue:[ pos := pos - 1 ]
                            ifFalse:[
                                (((source at:pos2+1) == Character cr) and:[((source at:pos2+2) == Character cr)]) ifTrue:[
                                    pos2 := pos2 + 1 ]].
                    ].
                ].

                self correctSourceByDeletingFrom:pos to:pos2.
                ^ self.
            ].
        ].
        startSearch := pos2 + 1.
    ] loop.

    "Modified: / 18-07-2006 / 08:56:25 / cg"
!

findBestSelectorsFor:aString
    "collect known selectors with their spelling distances to aString;
     return the 10 best suggestions"

    ^ self class findBestSelectorsFor:aString

    "Time millisecondsToRun:[Parser new findBestSelectorsFor:'foo']"
    "Parser new findBestSelectorsFor:'findBestSel'"
    "Parser new findBestSelectorsFor:'fildBestSelectrFr'"
!

findBestSelectorsFor:aString in:aClassOrNil
    "collect known selectors with their spelling distances to aString;
     return the N best suggestions. If the argument, aClassOrNil is not nil,
     the message is assumed to be sent to instances of that class (i.e. offer
     corrections from that hierarchy only)"

    ^ self class findBestSelectorsFor:aString in:aClassOrNil
!

findBestVariablesFor:aString
    "collect known variables with their spelling distances to aString;
     return the 10 best suggestions"

    |names dists searchBlock args vars "aClass className baseClass"
     n instVarNames classVarNames spellAgainstNodeAction spellAgainstAction|

    names := OrderedCollection new.
    dists := OrderedCollection new.

    spellAgainstAction :=
        [:givenName |
            |dist|

            names add:givenName.
            dist := aString spellAgainst:givenName.
            (aString startsWith:givenName) ifTrue:[
                dist := dist + (givenName size * 10).
            ].
            dists add:dist
        ].

    spellAgainstNodeAction :=
            [:aVarNode |
                spellAgainstAction value:(aVarNode name).
            ].

    "block arguments"
    searchBlock := currentBlock.
    [searchBlock notNil] whileTrue:[
        args := searchBlock arguments.
        args notNil ifTrue:[
            args do:spellAgainstNodeAction
        ].

        vars := searchBlock variables.
        vars notNil ifTrue:[
            vars do:spellAgainstNodeAction
        ].
        searchBlock := searchBlock home
    ].

    "method-variables"
    methodVars notNil ifTrue:[
        methodVarNames do:spellAgainstAction
    ].

    "method-arguments"
    methodArgs notNil ifTrue:[
        methodArgNames do:spellAgainstAction
    ].

    classToCompileFor notNil ifTrue:[
        "instance-variables"
        self classesInstVarNames do:spellAgainstAction.

        "all class-variables"
        self classesClassVarNames do:spellAgainstAction.

        "private classes"
        (classToCompileFor privateClasses collect:[:each | each nameWithoutPrefix]) do:spellAgainstAction.

        "pools"
        classToCompileFor sharedPools do:[:eachPool |
            eachPool classVarNames do:spellAgainstAction.
        ].
    ].

    "globals"
    Smalltalk keysDo:[:aKey |
        |globalVarName parts|

        globalVarName := aKey asString.

        "only compare strings where length is about right"
        ((globalVarName size - aString size) abs < 3) ifTrue:[
            spellAgainstAction value:globalVarName.
        ].
        (globalVarName includes:$:) ifTrue:[
            parts := globalVarName asCollectionOfSubCollectionsSeparatedByAll:'::'.
            parts size > 1 ifTrue:[
                parts do:[:eachPart |
                    |dist|
                    ((eachPart size - aString size) abs < 3) ifTrue:[
                        names add:globalVarName.
                        dist := aString spellAgainst:eachPart.
                        (aString startsWith:eachPart) ifTrue:[
                            dist := dist + (eachPart size * 10).
                        ].
                        dists add:dist
                    ].
                ].
            ].
        ].
    ].

    "misc"
    #('self' 'super' 'nil' 'thisContext') do:spellAgainstAction.

    (dists size ~~ 0) ifTrue:[
        dists sortWith:names.
        dists := dists reversed.
        names := names reversed.
        n := names size min:10.
        names := names copyTo:n.

        "if it starts with a lower case character, add all local & instvar names"
        "/ do not change to isLowercase because of $_
        aString isUppercaseFirst ifFalse:[
            methodVarNames size > 0 ifTrue:[
                names add:'---- method locals ----'.
                methodVarNames asSortedCollection do:[:methodVarName |
                    names add:methodVarName.
                ].
            ].


            methodArgs size > 0 ifTrue:[
                names add:'---- method arguments ----'.
                methodArgNames asSortedCollection do:[:methodArgName |
                    names add:methodArgName.
                ]
            ].
            classToCompileFor notNil ifTrue:[
                instVarNames := OrderedCollection new.
                self classesInstVarNames asSortedCollection do:[:instVarName |
                    (names includes:instVarName) ifFalse:[
                        instVarNames add:instVarName.
                    ]
                ].

                instVarNames size > 0 ifTrue:[
                    (classToCompileFor notNil and:[classToCompileFor isMeta]) ifTrue:[
                        names add:'---- class instance variables ----'.
                    ] ifFalse:[
                        names add:'---- instance variables ----'.
                    ].
                    instVarNames do:[:instVarName |
                        (names includes:instVarName) ifFalse:[
                            names add:instVarName.
                        ]
                    ]
                ].

                classVarNames := OrderedCollection new.
                self classesClassVarNames asSortedCollection do:[:classVarName |
                    (names includes:classVarName) ifFalse:[
                        classVarNames add:classVarName.
                    ]
                ].

                classVarNames size > 0 ifTrue:[
                    names add:'---- class variables ----'.
                    classVarNames do:[:classVarName |
                        (names includes:classVarName) ifFalse:[
                            names add:classVarName.
                        ]
                    ]
                ].
            ].
        ].

        ^ names
    ].
    ^ nil

    "Modified: / 21-06-2017 / 22:09:22 / cg"
!

selectorCheck:aSelectorString for:receiver position:pos1 to:pos2
    ^ self selectorCheck:aSelectorString for:receiver positions:(Array with:(pos1 to:pos2)).
!

selectorCheck:aSelectorString for:receiver positions:posVector
    "just a quick check: if a selector is totally unknown as a symbol,
     has the same name as a variable, cannot be understood or is obsolete.
     Simple, but catches many typos"

    |isSyntaxHighlighter err selectorSymbol rec names recType selClass newSelector nm nowhereImplemented
     pos1 pos2|

    isSyntaxHighlighter := self isSyntaxHighlighter.
    "
     if compiling lazy, or errors are to be ignored, or there
     is no requestor, do not check
    "
    isSyntaxHighlighter ifFalse:[
        (LazyCompilation == true) ifTrue:[^ aSelectorString].
        (ignoreErrors or:[ignoreWarnings]) ifTrue:[^ aSelectorString].
        (requestor isNil or:[requestor isStream]) ifTrue:[^ aSelectorString].
        parserFlags warnings ifFalse:[^ aSelectorString].
    ].
    "/ do not check messages to undefined variables...
    (receiver isVariable and:[receiver isUndeclared]) ifTrue:[
        ^ aSelectorString
    ].
    self isDoIt ifTrue:[
        ^ aSelectorString
    ].

    pos1 := posVector first start.
    pos2 := posVector last stop.

    (#('#' '|' '^') includes:aSelectorString) ifTrue:[
        self
            warnPossibleIncompatibility:('''',aSelectorString,''' might not be a valid selector in other Smalltalk systems')
            position:pos1 to:pos2.
    ].

    requestor isStream ifTrue:[
        ^ aSelectorString
    ].
    parserFlags warnAboutPossiblyUnimplementedSelectors ifFalse:[
        ^ aSelectorString
    ].

    nowhereImplemented := false.
    "
     quick check if the selector is known at all
     - if not, it cannot be understood
    "
    selectorSymbol := aSelectorString asSymbolIfInterned.
    selectorSymbol isNil ifTrue:[
        nowhereImplemented := true.
    ] ifFalse:[
"/        "/ temporarily disabled - too slow.
"/        (isSyntaxHighlighter 
"/        or:[(requestor notNil and:[requestor isStream not])]) "self isSyntaxHighlighter" ifTrue:[
"/            nowhereImplemented := (self class implementedInAnyClass:selectorSymbol) not.
"/        ]
    ].
    receiver notNil ifTrue:[
        selClass := self typeOfNode:receiver.
    ].
    
    nowhereImplemented ifTrue:[
        isSyntaxHighlighter ifFalse:[
            self classToCompileFor notNil ifTrue:[
                Tools::ToDoListBrowser notNil ifTrue:[
                    "/ experimental
                    self
                        notifyTodo:('"%1" is nowhere implemented' bindWith:aSelectorString) position:posVector first
                        className:(self classToCompileFor name) selector:selector
                        severity:#warning priority:#high
                        equalityParameter:aSelectorString
                        checkAction:[:e |
                            |m|
                            (m := e problemMethod) notNil
                            and:[(m sendsSelector:aSelectorString asSymbolIfInterned)
                            and:[self class implementedInAnyClass:aSelectorString]] ]
                ].
            ].
        ].
        err := ' is currently nowhere implemented'.
    ] ifFalse:[
        selClass notNil ifTrue:[
            "class is known; can limit the search"
            err := self checkSelector:selectorSymbol for:receiver inClass:selClass.
        ] ifFalse:[
            "class not known; this is slow"
            (self class implementedInAnyClass:selectorSymbol) ifFalse:[
                err := ' is currently nowhere implemented'.
            ].    
        ].
    ].
    err notNil ifTrue:[
        isSyntaxHighlighter ifTrue:[
            posVector do:[:p |
                self markSelector:aSelectorString from:p start to:p stop receiverNode:receiver.
            ].
        ] ifFalse:[
            self classToCompileFor notNil ifTrue:[
                Tools::ToDoListBrowser notNil ifTrue:[
                    "/ experimental
                    self
                        notifyTodo:(aSelectorString ,' ',err) position:posVector first
                        className:(self classToCompileFor name) selector:selector
                        severity:#warning priority:#high
                        equalityParameter:aSelectorString
                        checkAction:[:e |
                            |selClass m|

                            selClass := self typeOfNode:receiver.
                            (m := e problemMethod) notNil
                            and:[(m sendsSelector:aSelectorString asSymbolIfInterned)
                            and:[(self checkSelector:aSelectorString for:receiver inClass:selClass) notNil]]].
                ].
            ].
        ].

        nowhereImplemented ifFalse:[
            (receiver isConstant or:[receiver isBlock]) ifTrue:[
                err := err, ' in ' , selClass name , ' or any of its superclasses'.
            ] ifFalse:[(((recType := receiver type) == #GlobalVariable)
                        or:[recType == #PrivateClass]) ifTrue:[
                rec := receiver evaluate.
                "/ don't check autoloaded classes - it may work after loading
                (rec isNil
                 or:[rec isBehavior and:[rec isLoaded not]]) ifTrue:[
                    ^ aSelectorString
                ].

                (rec isBehavior
                 and:[rec theNonMetaclass name = receiver name]) ifTrue:[
                    err := err, ' in ' , rec theNonMetaclass name.
                ] ifFalse:[
                    err := err, ' in currently assigned value (is currently ' , rec classNameWithArticle , ')'.
                ].
            ] ifFalse:[receiver isSuper ifTrue:[
                receiver isHere ifFalse:[
                    err := err, ' in superclass chain'.
                ] ifTrue:[
                    err := err, ' in this class or superclass chain'.
                ]
            ] ifFalse:[receiver isSelf ifTrue:[
                err notNil ifTrue:[
                    |subErr nOther|

                    classToCompileFor notNil ifTrue:[
                        "/ understood by all subclasses ?
                        nOther := 0.
                        classToCompileFor allSubclassesDo:[:eachSubclass |
                            subErr isNil ifTrue:[
                                selClass := eachSubclass.
                                subErr := self checkSelector:selectorSymbol for:receiver inClass:selClass.
                            ] ifFalse:[
                                (self checkSelector:selectorSymbol for:receiver inClass:selClass) notNil ifTrue:[ nOther := nOther + 1 ].
                            ]
                        ].
                        subErr notNil ifTrue:[
                            nOther > 0 ifTrue:[
                                err := subErr, (' in %1 other subclass(es), this class or superclass chain' bindWith:nOther)
                            ] ifFalse:[
                                err := subErr, ', in this class or superclass chain'
                            ].
                        ] ifFalse:[
                            err := err, ', in this class or superclass chain'.
                        ].
                    ].
                ].
            ] ifFalse:[(receiver isUnaryMessage
                        and:[receiver selector == #class
                        and:[receiver receiver isSelf]]) ifTrue:[
                "it's a message to self class - can check this too ..."
                classToCompileFor isMeta ifTrue:[
                    err := err, ' for the classes class'.
                    (self checkSelector:selectorSymbol for:receiver inClass:classToCompileFor) isNil ifTrue:[
                        err := err, '...\\...but its implemented for the class itself. You probably do not want the #class message here.'.
                        err := err withCRs.
                    ].
                ] ifFalse:[
                    err := err, ' for my class'.
                    (self checkSelector:selectorSymbol for:receiver inClass:classToCompileFor) isNil ifTrue:[
                        err := err, '...\\...but its implemented for instances. You may want to remove the #class message.'.
                        err := err withCRs.
                    ].
                ].
            ] ifFalse:[
                (self isPossiblyUninitializedLocal:receiver) ifTrue:[
    "/ (receiver isLocal and:[receiver token type isNil]) ifTrue:[
                    "if it is an uninitialized variable ..."

    "/                ((modifiedLocalVars isNil or:[(modifiedLocalVars includes:receiver name) not])
    "/                 and:[hasPrimitiveCode not
    "/                 and:[((receiver isMethodVariable and:[currentBlock isNil])
    "/                      or:[ receiver isBlockVariable and:[receiver block == currentBlock]])
    "/                 and:[alreadyWarnedUninitializedVars isNil
    "/                      or:[(alreadyWarnedUninitializedVars includes:receiver name) not]]]])
    "/                ifTrue:[
                    ((#(at: at:put: basicAt: basicAt:put:) includes:selectorSymbol)
                     or:[(nil respondsTo:selectorSymbol) not]) ifTrue:[
                        "/ avoid trouble in miniTalk
                        "/ during bootstrap
                        nm := receiver name.
                        Text notNil ifTrue:[
                            nm := nm allItalic
                        ].
                        err := 'sent to possibly uninitialized variable ''' , nm , ''' here (?)'.
                        alreadyWarnedUninitializedVars isNil ifTrue:[
                            alreadyWarnedUninitializedVars := Set new
                        ].
                        alreadyWarnedUninitializedVars add:receiver name
                    ]
    "/                ]
            ] ifFalse:[
                selClass notNil ifTrue:[
                    ((selClass == Boolean)
                      and:[receiver isMessage
                      and:[receiver selector == #=]])
                    ifTrue:[
                        err := err, ' (message to Boolean; did you mean ":=" instead of "=" in the receiver?)'
                    ] ifFalse:[
                        err := err, ' (message to ' , selClass nameWithArticle , ')'.
                    ]
                ].
            ]]]]]].
        ].
    ].

    err notNil ifTrue:[
        "
         if the selector has the name of a variable, use another message
        "
        ((methodVarNames notNil and:[methodVarNames includes:aSelectorString])
          or:[(methodArgNames notNil and:[methodArgNames includes:aSelectorString])
          or:[classToCompileFor notNil
              and:[((names := self classesInstVarNames) notNil and:[names includes:aSelectorString])
                   or:[((names := self classesClassInstVarNames) notNil and:[names includes:aSelectorString])
                   or:[(names := self classesClassVarNames) notNil and:[names includes:aSelectorString]
        ]]]]]) ifTrue:[
            err := err , '
    .. but a variable with that name is defined.

    Missing ''.'' after the previous expression
    or missing keyword/receiver before that word ?'.
        ].

        ((aSelectorString startsWith:'x') or:[aSelectorString startsWith:'X']) and:[
            (aSelectorString from:2 conform:[:ch | ch isDigitRadix:16]) ifTrue:[
                (receiver isConstant
                and:[ receiver value == 0
                and:[ receiver startPosition == receiver endPosition "/ single digit
                ]]) ifTrue:[
                    err := err, ('\\or did you mean a C/Java hex integer (which should be 16r',(aSelectorString from:2),' in Smalltalk)')
                ].
            ].
        ].

        (receiver notNil
        and:[((recType := receiver type) == #GlobalVariable)
             or:[recType == #PrivateClass]]) ifTrue:[
            "/ don't check autoloaded classes
            "/ - it may work after loading

            rec := receiver evaluate.
            (rec notNil
             and:[rec isBehavior
             and:[rec isLoaded not]]) ifTrue:[
                ^ aSelectorString
            ].
            rec class == UndefinedVariable ifTrue:[
                "/ don't check undefined vars;
                "/ it may work after loading/defining
                ^ aSelectorString
            ].
        ].
        Text notNil ifTrue:[
            err := '"' , aSelectorString allBold, '" ', err
        ] ifFalse:[
            err := aSelectorString , ' ', err
        ].
        "/ if it's a recursive invocation of just that selector, do not complain
        (selector = aSelectorString "and:[ receiver isSelf]") ifTrue:[
            receiver isSuper ifFalse:[
                ^ aSelectorString
            ].
        ].
        isSyntaxHighlighter ifTrue:[
            posVector do:[:p |
                self markSelector:aSelectorString from:p start to:p stop receiverNode:receiver.  
            ].
        ] ifFalse:[
            self isDoIt ifTrue:[
                err := err , '\\This is a warning from the compiler - the code has not yet been executed/compiled.'.
            ].
            DoNotShowCompilerWarningAgainActionQuery handle:[:ex |
                parserFlags warnAboutPossiblyUnimplementedSelectors:false.
                ParserFlags warnAboutPossiblyUnimplementedSelectors:false.
                ex proceed.
            ] do:[
                newSelector := self correctSelector:aSelectorString
                                message:err withCRs
                                positions:posVector in:selClass for:receiver.
"/            self warning:('#' , aSelectorString , '\\' , err) withCRs position:pos1 to:pos2.
            ].
            ^ newSelector.
        ].
    ].
    ^ aSelectorString

    "Modified: / 05-09-1995 / 17:02:11 / claus"
    "Modified: / 16-03-2017 / 11:36:48 / cg"
    "Modified: / 20-12-2017 / 22:39:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

typeOfNode:aNode
    |nodeVal nodeType classHint rClass sel|

    aNode isConstant ifTrue:[
        "if the receiver is a constant, we know its class..."
        nodeVal := aNode evaluate.
        ^ nodeVal class.
    ].

    aNode isBlock ifTrue:[
        "/ this should help with typos, sending #ifTrue to blocks ...
        ^ Block
    ].

    aNode isVariable ifTrue:[
        nodeType := aNode type.
        (nodeType == #GlobalVariable or:[nodeType == #PrivateClass]) ifTrue:[
            "if the receiver is a global, we check it too ..."

            Error handle:[:ex | ] do:[ nodeVal := aNode evaluate ].
            "/ don't check autoloaded classes
            "/ - it may work after loading
            (nodeVal isNil
             or:[nodeVal isBehavior and:[nodeVal isLoaded not]]) ifTrue:[
                ^ nil
            ].

            ^ nodeVal class.
        ].

        (aNode isLocal) ifTrue:[
            classHint := aNode token classHint.
            classHint notNil ifTrue:[
                ^ Smalltalk classNamed:classHint
            ].
        ].
    ].

    aNode isSuper ifTrue:[
        classToCompileFor isNil ifTrue:[^ nil].
        
        "if it's a super- or here-send, we can do more checking"
        aNode isHere ifFalse:[
            ^ classToCompileFor superclass ? UndefinedObject.
        ].
        ^ classToCompileFor.
    ].
    aNode isSelf ifTrue:[
        ^ classToCompileFor.
    ].

    (aNode isMessage) ifTrue:[
        sel := aNode selector.
        (sel == #class) ifTrue:[
            rClass := self typeOfNode:aNode receiver.
            rClass notNil ifTrue:[
                ^ rClass class.
            ].
        ].
        (#(new new: basicNew basicNew:) includes:sel) ifTrue:[
            aNode receiver isSuper ifTrue:[
                "super new answers the instance and not the super instance"
                ^ aNode receiver definingClass theNonMetaclass.
            ].
            rClass := self typeOfNode:aNode receiver.
            (rClass isBehavior and:[rClass isMeta]) ifTrue:[
                ^ rClass theNonMetaclass.
            ].
        ].    
        ( #(isNil notNil isEmpty notEmpty isEmptyOrNil notEmptyOrNil
            < > >= <= = == ~= ~~
          ) includes:sel
        ) ifTrue:[
            ^ Boolean.
        ].
    ].

    ^ nil

    "Modified (comment): / 13-02-2017 / 20:28:34 / cg"
! !

!Parser methodsFor:'error handling'!

blockArgRedefined:tokenName from:pos1 to:pos2
    "argname reuse"

    self isSyntaxHighlighter ifTrue:[
        self markBadIdentifierFrom:pos1 to:pos2.
    ] ifFalse:[
        self
            syntaxError:'redefinition of ''' , tokenName , ''' in argument list.'
            position:pos1 to:pos2
    ].
!

disableWarningsOnCurrentMethodFor:flagName
    ParserFlags disableFlag:flagName forClass:classToCompileFor selector:selector

    "Created: / 28-02-2012 / 14:44:31 / cg"
!

errorMessageForUndefined:variableName
    "Return a proper method for undefined variable named `variableName`"

    |idx implementors spaces nameBold variableNameAsSymbol |

    nameBold := variableName allBold.
    classToCompileFor notNil ifTrue:[
        "/ is it an instance-variable marked inaccessible?

        idx := (self classesInstVarNames) indexOf:(variableName , '*') startingAt:1.
        idx ~~ 0 ifTrue:[
            ^ '''%1'' is a hidden instvar (not accessible from ST-code)' bindWith:nameBold.
        ].

        "/ is it an instance variable, while evaluating for the class ?
        classToCompileFor isMeta ifTrue:[
            (classToCompileFor soleInstance allInstVarNames includes:variableName) ifTrue:[
                ^ '''%1'' is an instvar\(hint: you are evaluating/compiling in the classes context)' bindWith:nameBold.
            ]
        ]
    ].
    variableNameAsSymbol := variableName asSymbolIfInterned.

    (variableNameAsSymbol notNil and:[self isDoIt]) ifTrue:[
        SystemBrowser notNil ifTrue:[
            implementors := SystemBrowser
                findImplementorsOf:variableName
                in:(Smalltalk allClasses)
                ignoreCase:false.
            implementors size > 0 ifTrue:[
                implementors size == 1 ifTrue:[
                    ^ '''%1'' is undefined but known as a message selector in %2.\(hint: did you forget to specify or select the receiver ?)'
                        bindWith:nameBold
                        with:implementors first mclass name allBold
                ].
                ^ '''%1'' is undefined but known as a message selector.\(hint: did you forget to specify or select the receiver ?)' bindWith:variableName allBold.
            ].
        ].
    ].
    peekChar == $: ifTrue:[
        ^ 'NameSpace "%1" is undefined' bindWith:nameBold.
    ].
    variableNameAsSymbol notNil ifTrue:[
        spaces := NameSpace allNameSpaces select:[:ns |ns includesKey:variableNameAsSymbol].
        spaces notEmpty ifTrue:[
            spaces size == 1 ifTrue:[
                ^ '"%1" is undefined\(but found in namespace "%2")'
                    bindWith:nameBold with:spaces first name.
            ].
            ^ '"%1" is undefined\(but found in "%2" and %3 other namespaces)'
                bindWith:nameBold with:spaces first name with:spaces size-1.
        ].
    ].
    ^ '"%1" is undefined' bindWith:nameBold.

    "Modified: / 28-10-2014 / 12:45:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exitWith:something
    "this is the longjump out of evaluation via a return expression"

    evalExitBlock value:something
!

identifierExpectedIn:what
    |msg|

    (#(True False Self Nil Super ThisContext) includes:tokenType) ifTrue:[
        msg := 'Reserved keyword in '
    ] ifFalse:[
        msg := 'Identifier expected in '
    ].
    self syntaxError:(msg , what , ' (got ''' , tokenType printString, ''')')
         position:tokenPosition to:source position.
    ^ #Error
!

isFirstWarning:something
    "answer true, if a warning about something has not been shown yet.
     Remember, that the warning has been shown"

    (warnings notNil and:[warnings includes:something]) ifTrue:[
        ^ false.
    ].
    self rememberWarning:something.
    ^ true
!

methodArgRedefined:tokenName from:pos1 to:pos2
    "argname reuse"

    self isSyntaxHighlighter ifTrue:[
        self markBadIdentifierFrom:pos1 to:pos2.
    ] ifFalse:[
        self
            syntaxError:'redefinition of ''' , tokenName , ''' in argument list.'
            position:pos1 to:pos2
    ].
!

rememberWarning:something
    "remember, that a warning for something has been shown."

    warnings isNil ifTrue:[
        warnings := Set new.
    ].
    warnings add:something.
!

showErrorMessage:aMessage position:pos
    "redefined since parser can give more detailed info about
     the class & selector where the error occurred."

    |msg|

    ignoreErrors ifFalse:[
        Smalltalk silentLoading ifFalse:[
            msg := ''.
            pos notNil ifTrue:[
                msg := msg , (pos printString).
                msg := msg , ' '.
            ].
            msg := msg , aMessage.
            selector notNil ifTrue:[
                msg := msg , ' in '.
                classToCompileFor notNil ifTrue:[
                    msg := msg , classToCompileFor name , '>>'
                ].
                msg := msg , selector.
            ] ifFalse:[
                classToCompileFor notNil ifTrue:[
                    msg := msg , ' (' , classToCompileFor name , ')'
                ]
            ].

            UserInformation isHandled ifTrue:[
                UserInformation raiseRequestErrorString:msg
            ] ifFalse:[
                Transcript showCR:msg.
            ]
        ]
    ]

    "Modified: 18.5.1996 / 15:44:15 / cg"
!

showErrorMessageForClass:aClass
"/        compiler parseError:'syntax error'.
    Transcript show:'    '.
    aClass notNil ifTrue:[
        Transcript show:aClass name , '>>'
    ].
    selector notNil ifTrue:[
        Transcript show:(selector)
    ].
    Transcript showCR:' -> Error'.

    "Created: 13.12.1995 / 20:24:34 / cg"
    "Modified: 18.5.1996 / 15:44:17 / cg"
!

undefError:aName position:pos1 to:pos2
    "report an undefined variable error - return true, if it should be
     corrected. If not corrected, only one warning is made per undefined
     variable."

    |ex doCorrect boldName errMsg|

    UndefinedVariableNotification isHandled ifTrue:[
        ex := UndefinedVariableNotification newException.
        ex parser:self.
        ex parameter:aName.
        ex suspendedContext:thisContext.
        doCorrect := ex raiseRequest.
        doCorrect notNil ifTrue:[
            ^ doCorrect
        ].
    ].

    "
     already warned about this one ?
    "
    warnedUndefVars notNil ifTrue:[
        (warnedUndefVars includes:aName) ifTrue:[
            "already warned about this one"
            ^ false
        ].
    ].

"/    ignoreWarnings ifTrue:[^ false].
    parserFlags warnUndeclared ifFalse:[^ false].

"/    (classToCompileFor notNil
"/    and:[classToCompileFor superclass notNil
"/    and:[classToCompileFor superclass instanceVariableString isNil]]) ifTrue:[
"/      self showErrorMessage:'Error: no source information (instvar names)' position:pos1.
"/      ^ false
"/    ].

    boldName := aName allBold.

    (requestor isNil or:[requestor isStream]) ifTrue:[
        requestor := CompilationErrorHandlerQuery query.
    ].    
    (requestor isNil or:[requestor isStream]) ifTrue:[
        errMsg := 'Error: "%1" is undefined' bindWith:boldName.
        aName isUppercaseFirst ifFalse:[
            self showErrorMessage:errMsg position:pos1.
        ].
        doCorrect := false.
    ] ifFalse:[
        "
         ask requestor for correct/continue/abort ...
         it is supposed to raise abort or return true/false.
         True return means that correction is wanted.
        "
        errMsg := self errorMessageForUndefined:aName.
        aName isUppercaseFirst ifTrue:[
            doCorrect := self
                        correctableWarning:errMsg withCRs
                        position:pos1 to:pos2
        ] ifFalse:[
            doCorrect := self
                        correctableError:errMsg withCRs
                        position:pos1 to:pos2
        ].
    ].
    "/ notice: doCorrect may be a non-boolean
    doCorrect == false ifTrue:[
        warnedUndefVars isNil ifTrue:[
            warnedUndefVars := Set new.
        ].
        warnedUndefVars add:aName.
        self classToCompileFor notNil ifTrue:[
            Tools::ToDoListBrowser notNil ifTrue:[
                "/ experimental
                self
                    notifyTodo:errMsg position:pos1
                    className:(self classToCompileFor name) selector:selector
                    severity:#error priority:#high
                    equalityParameter:aName
                    checkAction:[:e |
                        e problemMethod notNil
                        and:[(e problemMethod usedGlobals includes:aName)
                        and:[(Smalltalk includesKey:aName asSymbol) not]] ].
            ].
        ].
    ].

    ^ doCorrect

    "Modified: / 02-11-2010 / 13:32:21 / cg"
!

warnSTXHereExtensionUsedAt:position
    ignoreWarnings ifFalse:[
        didWarnAboutSTXHereExtensionUsed ifFalse:[
            parserFlags warnSTXHereExtensionUsed ifTrue:[
                self warning:'here-sends are a nonstandard feature of ST/X'
                     position:position to:position+3.
                "
                 only warn once
                "
                didWarnAboutSTXHereExtensionUsed := true
            ].
        ].
    ].
!

warnSTXNameSpaceUseAt:position
    ignoreWarnings ifFalse:[
        didWarnAboutSTXNameSpaceUse ifFalse:[
            parserFlags warnSTXNameSpaceUse ifTrue:[
                self warning:'NameSpaces are a nonstandard feature of ST/X'
                     doNotShowAgainAction:[ ParserFlags warnSTXSpecials:false ]
                     position:position to:(source position + 1).
                "
                 only warn once
                "
                didWarnAboutSTXNameSpaceUse := false
            ]
        ]
    ].
!

warnSTXSpecialCommentAt:position to:endPosition
    (ParserFlags isFlag:#warnSTXSpecials enabledForClass:classToCompileFor selector:selector) ifFalse:[^ self].
    super warnSTXSpecialCommentAt:position to:endPosition

    "Created: / 28-02-2012 / 14:55:36 / cg"
!

warnUnused:aNameCollection
    "report an unused method variable"

    |msg answer lineLength first queries|

    ignoreErrors ifTrue:[^ self].
    ignoreWarnings ifTrue:[^ self].
    parserFlags warnUnusedVars ifFalse:[^ self].

    (ParserFlags isFlag:#warnUnusedVars enabledForClass:classToCompileFor selector:selector)
        ifFalse:[^ self].

    msg := 'Unused method variable(s): '.
    lineLength := msg size.
    first := true.
    aNameCollection asSortedCollection do:[:name|
        first ifTrue:[ first := false ] ifFalse:[msg := msg , ', '].
        msg := msg , ('"',name allBold,'"').
        lineLength := lineLength + 2 + name size + 1.
        lineLength > 60 ifTrue:[
            msg := msg , '\' withCRs.
            lineLength := 0.
        ].
    ].

    (requestor isNil or:[requestor isStream]) ifTrue:[
        self showErrorMessage:('Warning: ', msg) position:nil.
    ] ifFalse:[
        queries := DoNotShowCompilerWarningAgainActionQuery.
        (self isDoIt not
         and:[ classToCompileFor notNil
         and:[ selector notNil ]]) ifTrue:[
            queries := queries , DoNotShowCompilerWarningAgainForThisMethodActionQuery.
        ].
        queries handle:[:ex |
            ex creator == DoNotShowCompilerWarningAgainActionQuery ifTrue:[
                parserFlags warnUnusedVars:false.
                ParserFlags warnUnusedVars:false.
            ] ifFalse:[
                self disableWarningsOnCurrentMethodFor: #warnUnusedVars
            ].
            ex proceed.
        ] do:[
            answer := requestor
                unusedVariableWarning:msg
                position:(localVarDefPosition first) to:(localVarDefPosition last) from:self.
        ].
        answer == true ifTrue:[
            "/ delete the definitions ...
            aNameCollection do:[:eachName |
                self deleteDefinitionOf:eachName in:(localVarDefPosition first) to:(localVarDefPosition last).
            ].
            RestartCompilationSignal raiseRequest
        ].
    ].

    Tools::ToDoListBrowser notNil ifTrue:[
        "/ experimental
        self
            notifyTodo:msg position:(localVarDefPosition first)
            className:(self classToCompileFor name) selector:selector
            severity:#warning priority:#low
            equalityParameter:nil
            checkAction:nil.
    ].

    "Modified: / 28-02-2012 / 14:55:07 / cg"
! !

!Parser methodsFor:'evaluating expressions'!

defaultFailBlock
    ^ nil. "/ [:msg | self error:(msg ? 'error in eval') ]
!

evaluate:aStringOrStream
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:requestor
        logged:logged
        ifFail:(self defaultFailBlock)
        compile:false
        checkForEndOfInput:true
!

evaluate:aStringOrStream compile:compile
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:requestor
        logged:logged
        ifFail:(self defaultFailBlock)
        compile:compile
        checkForEndOfInput:true

    "Created: / 07-12-2006 / 19:30:04 / cg"
!

evaluate:aStringOrStream ifFail:failBlock
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:requestor
        logged:logged
        ifFail:failBlock
        compile:false
        checkForEndOfInput:true
!

evaluate:aStringOrStream in:aContext receiver:anObject
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:aContext
        receiver:anObject
        notifying:requestor
        logged:logged
        ifFail:(self defaultFailBlock)
        compile:false
        checkForEndOfInput:true
!

evaluate:aStringOrStream in:aContext receiver:anObject ifFail:failBlock
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:aContext
        receiver:anObject
        notifying:requestor
        logged:logged
        ifFail:failBlock
        compile:false
        checkForEndOfInput:true
!

evaluate:aStringOrStream in:aContext receiver:anObject notifying:requestor logged:logged ifFail:failBlock
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:aContext
        receiver:anObject
        notifying:requestor
        logged:logged
        ifFail:failBlock
        compile:true
!

evaluate:aStringOrStream in:aContext receiver:anObject notifying:requestor logged:logged ifFail:failBlock compile:compile
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:aContext
        receiver:anObject
        notifying:requestor
        logged:logged
        ifFail:failBlock
        compile:compile
        checkForEndOfInput:true
!

evaluate:aStringOrStream in:aContext receiver:anObject notifying:requestor logged:logged ifFail:failBlock compile:compile checkForEndOfInput:checkForEndOfInput
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead.

     If checkForEndOfInput is set, generate an error if EOF has not been reached
     at the end of the expression."

    |tree mustBackup loggedString chgStream value s sReal spc
     nameSpaceQuerySignal compiler cls|

    aStringOrStream isNil ifTrue:[
        EmptySourceNotificationSignal raiseRequest.
        ^ nil
    ].
    (mustBackup := aStringOrStream isStream) ifTrue:[
        s := aStringOrStream.
    ] ifFalse:[
        loggedString := aStringOrStream.
        s := ReadStream on:aStringOrStream.
    ].

    self source:s.
    selector := self doItSelector.  "/ so isDoit returns the correct answer!!

    self parseForCode.
    self foldConstants:nil.
    self setSelf:anObject.
    self setContext:aContext.
    aContext notNil ifTrue:[
        self setSelf:(aContext receiver).
        aContext method notNil ifTrue:[
            cls := aContext method mclass
        ].
        self setClassToCompileFor:(cls ? aContext receiver class).
        "/ self setClassToCompileFor:(aContext receiver class).
    ].
    self notifying:requestor.
    self nextToken.
    self evalExitBlock:[:value | self release. ^ value].

    failBlock isNil ifTrue:[
        tree := self parseMethodBodyOrEmpty.
    ] ifFalse:[
        ParseError handle:[:ex |
            ^ failBlock valueWithOptionalArgument:ex description
        ] do:[
            tree := self parseMethodBodyOrEmpty.
        ].
    ].
    checkForEndOfInput ifTrue:[self checkForEndOfInput].

    "if reading from a stream, backup for next expression"
    mustBackup ifTrue:[
        self backupPosition
    ].

    (self errorFlag or:[tree == #Error]) ifTrue:[
        requestor notNil ifTrue:[
            requestor error:'parse error' position:1 to:(source position) from:self.
        ].
        failBlock notNil ifTrue:[
            ^ failBlock valueWithOptionalArgument:'parse error'
        ].
        ^ #Error
    ].

    tree isNil ifTrue:[
        EmptySourceNotificationSignal raiseRequest.
        ^ nil
    ].

    (logged
    and:[loggedString notNil
    and:[Smalltalk logDoits]]) ifTrue:[
        Class updateChangeFileQuerySignal query ifTrue:[
            chgStream := Class changesStream.
            chgStream notNil ifTrue:[
                chgStream nextChunkPut:loggedString.
                chgStream cr.
                chgStream close
            ]
        ].
        Project notNil ifTrue:[
            Class updateChangeListQuerySignal query ifTrue:[
                Project addDoIt:loggedString
            ]
        ]
    ].

    "
     during the evaluation, handle nameSpace queries
     from the value as defined by any namespace directive.
     This, if it's a class definition expression, the class will
     be installed there.
    "
    nameSpaceQuerySignal := Class nameSpaceQuerySignal.

    spc := self getNameSpace.
    spc isNil ifTrue:[
        (requestor respondsTo:#currentNameSpace) ifTrue:[
            spc := requestor currentNameSpace
        ] ifFalse:[
            spc := nameSpaceQuerySignal query.
        ]
    ].

    Parser undefinedVariableError handle:[:ex |
        failBlock isNil ifTrue:[
            ex reject.
        ] ifFalse:[
            ^ failBlock valueWithOptionalArgument:ex description.
        ].
    ] do:[
        nameSpaceQuerySignal answer:spc
        do:[
            |method|

            "
             if compile is false, or the parse tree is that of a constant,
             or a variable, quickly return its value.
             This is used for example, when reading simple objects
             via #readFrom:.
             The overhead of compiling a method is avoided in this case.
            "
            ((SuppressDoItCompilation == true)
             or:[compile not
             or:[tree isSimpleConstant
             or:[tree isSimpleVariable
             or:[aStringOrStream isStream
             or:[aContext notNil "also, if we evaluate inside a context (cannot generate code for context access, yet)"
            ]]]]]) ifTrue:[
                ^ tree evaluate
            ].

            "
             if I am the ByteCodeCompiler,
             generate a dummy method, execute it and return the value.
             otherwise, just evaluate the tree; slower, but not too bad ...

             This allows systems to be delivered without the ByteCodeCompiler,
             and still evaluate expressions
             (needed to read resource files or to process .rc files).
            "
            self == Parser ifTrue:[
                self evalExitBlock:[:value | self release. ^ value].
                value := tree evaluate.
                self evalExitBlock:nil.
            ] ifFalse:[
                s := self correctedSource.
                s isNil ifTrue:[
                    aStringOrStream isStream ifTrue:[
                        s := self collectedSource.  "/ does not work yet ...
                    ] ifFalse:[
                        s := aStringOrStream
                    ].
                ].

                "/ actually, its a block, to allow
                "/ easy return ...

                sReal := (self doItSelector),' ^[ ' , s , '\] value' withCRs.

                compiler := ByteCodeCompiler new.
                compiler initializeFlagsFrom:self.
                method := compiler
                        compile:sReal
                        forClass:anObject class
                        inCategory:'_temporary_'
                        notifying:requestor
                        install:false
                        skipIfSame:false
                        silent:true
                        foldConstants:false.

                method notNil ifTrue:[
                    method ~~ #Error ifTrue:[
                        "
                         fake: patch the source string, to what the user expects
                         in the browser
                        "
                        method source:"'        ' , "s string.
                        "
                         don't do any just-in-time compilation on it (pretend that it was already checked).
                        "
                        method checked:true.

                        value := method
                                    valueWithReceiver:anObject
                                    arguments:nil
                                    selector:(self doItSelector) "/ #__doIt__
                                    search:nil
                                    sender:nil.
                    ] ifFalse:[
                        self evalExitBlock:[:value | self release. ^ value].
                        value := tree evaluate.
                        self evalExitBlock:nil.
                    ]
                ].
            ]
        ].
    ].
    self release.
    ^ value

    "Created: / 08-02-1997 / 19:34:44 / cg"
    "Modified: / 18-03-1999 / 18:25:40 / stefan"
    "Modified: / 22-11-2016 / 00:08:52 / cg"
    "Modified (comment): / 13-02-2017 / 20:28:23 / cg"
    "Modified (comment): / 19-02-2018 / 14:31:59 / mawalch"
!

evaluate:aStringOrStream logged:logged
    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:nil
        logged:logged
        ifFail:(self defaultFailBlock)
        compile:true
!

evaluate:aStringOrStream notifying:someRequestor
    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:someRequestor
        logged:false
        ifFail:nil
        compile:true
        checkForEndOfInput:(aStringOrStream isStream not)
!

evaluate:aStringOrStream notifying:someRequestor compile:compileBoolean
    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:someRequestor
        logged:false
        ifFail:nil
        compile:compileBoolean
        checkForEndOfInput:(aStringOrStream isStream not)
!

evaluate:aStringOrStream receiver:anObject
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:anObject
        notifying:requestor
        logged:logged
        ifFail:(self defaultFailBlock)
        compile:false
        checkForEndOfInput:true
!

evaluate:aStringOrStream receiver:anObject ifFail:failBlock
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:anObject
        notifying:requestor
        logged:logged
        ifFail:failBlock
        compile:false
        checkForEndOfInput:true
!

evaluate:aStringOrStream receiver:receiver notifying:someRequestor compile:compileBoolean
    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:receiver
        notifying:someRequestor
        logged:false
        ifFail:nil
        compile:compileBoolean
        checkForEndOfInput:(aStringOrStream isStream not)
!

evaluateDeclarationFor:anEnvironment
    ^ self
        evaluate:source
        in:nil
        receiver:selfValue
        notifying:requestor
        logged:logged
        ifFail:nil
        compile:false
        checkForEndOfInput:false.

    "Created: / 04-08-2010 / 11:42:42 / cg"
! !

!Parser methodsFor:'initialization'!

initializeFlagsFrom:aParser
    "initialize flags from another scanner"

    super initializeFlagsFrom:aParser.

    moreSharedPools := aParser moreSharedPools.
    doItTemporaries := aParser doItTemporaries.
    selector := aParser selector.
! !

!Parser methodsFor:'obsolete'!

correctByDeleting
    "correct (by deleting token) if user wants to;
     return #Error if there was no correction;
     nil if there was one."

    |selectionSize|

    (self confirm:'confirm deleting') ifFalse:[^ #Error].

    "
     tell requestor (i.e. CodeView) about the change
     this will update what the requestor shows.
    "
    selectionSize := requestor selection size.
    requestor deleteSelection.

    "
     get the updated source-string
     which is needed, when we eventually install the new method
    "
    correctedSource := requestor currentSourceCode.
    "/ update the current source position
    source := (ReadStream on:correctedSource)
                  position:(source position + 1 - selectionSize).

    ^ nil

    "Modified: / 22.1.1998 / 16:39:11 / stefan"
! !

!Parser methodsFor:'parsing'!

block
    "parse a block; return a node-tree, nil or #Error"

    |startPos endPos blockNode blockBodyResult args argNames arg pos pos2 lno|

    startPos := tokenPosition.

    lno := tokenLineNr.
    self nextToken.

    blockNode := BlockNode home:currentBlock.
    blockNode lineNumber:lno.
    currentBlock := blockNode.

    (tokenType == $: ) ifTrue:[
        [tokenType == $:] whileTrue:[
            pos := tokenPosition.
            self nextToken.

            (pos == (tokenPosition - 1)) ifFalse:[
                self warnPossibleIncompatibility:'space(s) between colon and identifier may be non-portable' position:pos to:tokenPosition.
            ].
            (tokenType ~~ #Identifier) ifTrue:[
                ^ self identifierExpectedIn:'block-arg declaration'
            ].

            pos2 := tokenPosition + tokenName size - 1.
            self markBlockArgumentIdentifierFrom:tokenPosition to:pos2.
            self checkBlockArgumentNameConventionsFor:tokenName.
            arg := Variable name:tokenName.
            args isNil ifTrue:[
                args := Array with:arg.
                argNames := Array with:tokenName.
            ] ifFalse:[
                (argNames includes:tokenName) ifTrue:[
                    self blockArgRedefined:tokenName from:tokenPosition to:pos2
                ].
                args := args copyWith:arg.
                argNames := argNames copyWith:tokenName.
            ].
            self nextToken.
        ].
        (tokenType ~~ $| ) ifTrue:[
            "ST-80 allows [:arg ]"
            (tokenType == $] ) ifTrue:[
                blockNode arguments:args.
                blockNode startPosition: startPos endPosition: tokenPosition.
                self markBlockFrom:startPos to:tokenPosition.
                "/ self nextToken. -- should be done & removed in caller
                ^ self blockNodeRewriteHookFor:blockNode
            ].
            self syntaxError:'| expected after block-arg declaration'.
            ^ #Error
        ].
        self nextToken
    ].
    blockNode arguments:args.
    blockBodyResult := self blockBody.

    (blockBodyResult isNil or:[blockBodyResult == #Error]) ifTrue:[
        ^ blockBodyResult
    ].

    endPos := tokenPosition.
    "/ blockNode lineNumber:lno.
    blockNode startPosition:startPos; endPosition:endPos.

    self markBlockFrom:startPos to:endPos.
    currentBlock := blockNode home.

    "/ self nextToken. -- should be done & removed in caller
    ^ self blockNodeRewriteHookFor:blockNode

    "Modified (comment): / 05-07-2011 / 23:23:08 / cg"
    "Modified: / 01-08-2011 / 12:34:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

blockBody
    "parse a currentBlock's block-body; return a node-tree, nil or #Error"

    |prevFlags stats var vars lno pos2 barPos1|

    lno := tokenLineNr.

    ((tokenType == #BinaryOperator) and:[tokenName = '<']) ifTrue:[
        prevFlags := parserFlags copy.
        self parsePrimitiveOrResourceSpecOrEmpty.
    ].

    (tokenType == $| ) ifTrue:[        
        barPos1 := tokenPosition.
        self nextToken.
        [tokenType == $|] whileFalse:[
            (tokenType == #Identifier) ifFalse:[
                ^ self identifierExpectedIn:'block-var declaration'
            ].
            pos2 := tokenPosition + tokenName size - 1.
            self markLocalVariableDeclaration: tokenName from: tokenPosition to:pos2.
            self checkBlockVariableNameConventionsFor:tokenName.
            var := Variable name:tokenName.
            vars isNil ifTrue:[
                vars := Array with:var.
            ] ifFalse:[
                (vars contains:[:var | var name = tokenName]) ifTrue:[
                    "/ varname reuse
                    self isSyntaxHighlighter ifTrue:[
                        self markBadIdentifierFrom:tokenPosition to:pos2.
                    ] ifFalse:[
                        self
                            parseError:'redefinition of ''' , tokenName , ''' in local variables'
                            position:tokenPosition to:pos2.
                    ]
                ] ifFalse:[
                    vars := vars copyWith:var.
                ]
            ].
            self nextToken.

            parserFlags allowLocalVariableDeclarationWithInitializerExpression == true ifTrue:[
                ((tokenType == $_) or:[tokenType == #':=']) ifTrue:[
                    self nextToken.
                    "/ Q: should we allow literals only, or arbitrary expressions ?
                    self shouldImplement.
                ]
            ].
            parserFlags allowDomainVariables == true ifTrue:[
                (tokenType == $() ifTrue:[
                    self variableTypeDeclarationFor:var.
                ].
            ].
        ].
        vars isEmptyOrNil ifTrue:[
            parserFlags warnPossibleIncompatibilities == true ifTrue:[
                self
                    warning:('empty local variable list (possible incompatibility)')
                    doNotShowAgainAction:[ parserFlags warnPossibleIncompatibilities:false.
                                           ParserFlags warnPossibleIncompatibilities:false]
                    position:barPos1 to:source position.
            ]    
        ].    
        self nextToken.
    ].
    currentBlock variables:vars.

    stats := self blockStatementList.
    (stats == #Error) ifTrue:[^ #Error].

    parserFlags fullLineNumberInfo ifTrue:[
        currentBlock endLineNumber:tokenLineNr
    ].
    currentBlock statements:stats.

    prevFlags notNil ifTrue:[
        parserFlags := prevFlags.
    ].
    ^ currentBlock

    "Modified: / 26-09-2012 / 14:15:41 / cg"
    "Modified: / 25-02-2014 / 20:20:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

blockExpression
    "parse a blockExpression; return a node-tree, nil or #Error.
     Not used by ST/X's parser, but added for ST-80 compatibility."

    tokenType ~~ $[ ifTrue:[
        self syntaxError:'[ expected'.
        ^ #Error.
    ].
    ^ self block
!

blockStatementList
    "parse a blocks statementlist; return a node-tree, nil or #Error"

    |thisStatement prevStatement firstStatement eMsg blockStart|

    blockStart := tokenPosition.

    (tokenType == $] ) ifTrue:[^ nil].

    thisStatement := self statement.
    (thisStatement == #Error) ifTrue:[^ #Error].
    firstStatement := thisStatement.
    [tokenType == $] ] whileFalse:[
        (tokenType == $.) ifFalse:[
            (tokenType == #EOF) ifTrue:[
                self syntaxError:'missing '']'' in block' position:blockStart to:(source position + 1).
                ^ #Error.
            ].

            (tokenType == $) ) ifTrue:[
                eMsg := 'missing '']'' or bad '')'' in block'
            ] ifFalse:[
                eMsg := 'missing ''.'' between statements (i.e. ''' , tokenType printString , '''-token unexpected)'
            ].

            self syntaxError:eMsg position:thisStatement startPosition to:tokenPosition.
            "/ ^ #Error --- can proceed
        ] ifTrue:[
            self nextToken.
        ].

        prevStatement := thisStatement.

        tokenType == $] ifTrue:[
            "
            *** I had a warning here (since it was not defined
            *** in the blue-book; but PD-code contains a lot of
            *** code with periods at the end so that the warnings
            *** became annoying

            self warning:'period after last statement in block'.
            "
            self markBracketAt:tokenPosition.
            ^ self statementListRewriteHookFor:firstStatement
        ].
        thisStatement := self statement.
        (thisStatement == #Error) ifTrue:[^ #Error].
        prevStatement nextStatement:thisStatement
    ].
    self markBracketAt:tokenPosition.
    ^ self statementListRewriteHookFor:firstStatement

    "Modified: / 30-06-2011 / 19:45:49 / cg"
    "Modified: / 28-07-2013 / 23:04:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkForEndOfInput
    "check, that we have reached the end of input.
     Error, if not"

    |what msg endPos|

    (tokenType ~~ #EOF) ifTrue:[
        "/ just for the nicer error message
        (#(Self Nil True False Super Here) includes:tokenType) ifTrue:[
            msg := 'Nothing more expected (i.e. "',tokenName allBold,'" unexpected)'.
            endPos := tokenPosition + tokenName size - 1.
        ] ifFalse:[
            tokenType isCharacter ifTrue:[
                what := '"' , tokenType asString allBold, '"'.
            ] ifFalse:[
                what := tokenType printString allBold.
            ].
            msg := 'Nothing more expected (i.e. ',what, ' unexpected.'.
            endPos := source position.
        ].
        self parseError:msg position:tokenPosition to:endPos.
        ^#Error
    ]

    "Modified: / 22-08-2006 / 14:22:45 / cg"
!

emptyStatement
    (parserFlags allowEmptyStatements
    or:[parserFlags allowSqueakExtensions == true]) ifTrue:[
        self warnAboutEmptyStatement.
        self nextToken.
    ] ifFalse:[
        self parseError:'empty statement - please enable in the settings' position:tokenPosition to:tokenPosition
    ].

    "Created: / 20-11-2006 / 14:04:14 / cg"
    "Modified: / 05-07-2010 / 17:15:34 / cg"
!

makeSelector:rawSelector
    "/ cg: how about (to prevent creation of new symbols):
    self isSyntaxHighlighter ifTrue:[
        ^ rawSelector
    ].
false ifTrue:[
    currentNamespace notNil ifTrue:[
        (classToCompileFor notNil
        and:[ classToCompileFor nameSpace ~~ (currentNamespace ? Smalltalk) ]) ifTrue:[
            ^ (':',currentNamespace name,'::',rawSelector) asSymbol
        ].
    ].
].

    "/ cg: thought this was a good idea to prevent creation of new symbols;
    "/ but currently breaks changesBrowser.
    "/ parseForCode ifFalse:[^ rawSelector].   "/syntaxhighlighting or analyzing

    ^ rawSelector asSymbol.
!

parseExpressionWithSelf:anObject notifying:someOne ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings inNameSpace:aNameSpaceOrNil
    "parse aString as an expression with self set to anObject;
     Return the parseTree (if ok), nil (for an empty string
     or comment only ) or #Error (syntactic error).

     Errors and warnings are forwarded to someOne (usually some
     codeView) which can highlight it and show a popup box,
     iff ignoreErrors/ignoreWarnings is true respectively."

    |tree|

    aNameSpaceOrNil notNil ifTrue:[
        self currentNameSpace:aNameSpaceOrNil
    ].
    self setSelf:anObject.
    self notifying:someOne.
    self ignoreErrors:ignoreErrors.
    self ignoreWarnings:ignoreWarnings.
    tokenType isNil  ifTrue:[
        self nextToken.
    ].
    (tokenType == $^) ifTrue:[
        self nextToken.
    ].
    (tokenType == #EOF) ifTrue:[
        ^ nil
    ].
    tree := self expression.
"/    (self errorFlag or:[tree == #Error]) ifTrue:[^ #Error].
"/    tokenType ~~ #EOF ifTrue:[
"/        self parseError:'nothing more expected' position:tokenPosition
"/    ].
    ^ tree

    "Created: / 14-12-1999 / 15:11:37 / cg"
!

parseLiteralArray: aStringOrStream
    "Parser literal array in given String or Stream.
     Returns that array"

    self nextToken ~~ #HashLeftParen ifTrue:[
        self syntaxError: '# expected, ', token printString ,'found.'.
        ^ ParseError raiseRequest.
    ].
    self nextToken.
    ^self array.

    "Created: / 06-11-2012 / 12:51:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2013 / 11:05:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMethod
    "parse a method.
     Return the parseTree or #Error.

     method ::= methodSpec methodBody
    "

    |parseTree|

"/    self nextToken.
    (self parseMethodSpec == #Error) ifTrue:[^ #Error].
    parseTree := self parseMethodBody.
    (parseTree == #Error) ifFalse:[
        self tree:parseTree
    ].
    self checkForEndOfInput.
    ^ parseTree

    "Modified: / 20-04-1996 / 20:09:26 / cg"
    "Modified: / 12-07-2010 / 10:08:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMethod:aString in:aClass
    "parse a method in a given class.
     Return a parser (if ok) or #Error (syntax).
     The parser can be queried for selector, receiver, args, locals,
     used selectors, modified instvars, referenced classvars etc.
     The noErrors and noWarnings arguments specify if error and warning
     messages should be sent to the Transcript or suppressed."

    ^ self
        parseMethod:aString
        in:aClass
        ignoreErrors:false
        ignoreWarnings:false

    "Modified: / 06-03-2007 / 18:33:39 / cg"
    "Created: / 04-10-2011 / 15:35:15 / cg"
!

parseMethod:aString in:aClass ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings
    "parse a method in a given class.
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args, locals,
     used selectors, modified instvars, referenced classvars etc.
     The noErrors and noWarnings arguments specify if error and warning
     messages should be sent to the Transcript or suppressed."

    |tree|

    aString isNil ifTrue:[^ nil].

    self initializeFor:(ReadStream on:aString).
    self setClassToCompileFor:aClass.
    self ignoreErrors:ignoreErrors.
    self ignoreWarnings:ignoreWarnings.
    tree := self parseMethod.
"/    (self errorFlag or:[tree == #Error]) ifTrue:[^ nil].
    ^ tree

    "Created: / 21-08-2006 / 18:26:36 / cg"
!

parseMethodBody
    "parse a methods body (locals & statements).
     No more tokens may follow.
     Return a node-tree, or #Error

     methodBody ::= '<' st80Primitive '>' #EOF
                    | '<' st80Primitive '>' methodBodyVarSpec statementList #EOF

    "
    |stats|

    tokenType isNil ifTrue:[
        self nextToken.
    ].

    tokenType == $. ifTrue:[
        self emptyStatement.
    ].
    stats := self parseMethodBodyOrEmpty.
    (stats == #Error) ifFalse:[
        self checkForEndOfInput.
    ].
    (requestor notNil and:[ignoreWarnings not]) ifTrue:[
        parserFlags warnings ifTrue:[
            self hasPrimitiveCode ifFalse:[
                self checkUnusedMethodVars.
            ].
            (LintRuleIgnoreAnnotation isNil 
             or:[(annotations ? #()) noneSatisfy:[:a | a key == LintRuleIgnoreAnnotation key]]) ifTrue:[
                self checkReturnedValues.
            ]
        ]
    ].
    ^ stats

    "Modified: / 16-07-2017 / 13:38:37 / cg"
    "Modified: / 25-07-2017 / 17:09:54 / stefan"
!

parseMethodBodyOrEmpty
    "parse a methods body (locals & statements);
     return  a node-tree, nil or #Error.
     empty (or comment only) input is accepted and returns nil.

     methodBodyOrNil ::= '<' st80Primitive '>'
                         | '<' st80Primitive '>' methodBodyVarSpec statementList
                         | <empty>
    "

    |stats|

    (self parseMethodBodyVarSpec == #Error) ifTrue:[^ #Error].

    tokenType == $. ifTrue:[
        self emptyStatement.
    ].
    (tokenType ~~ #EOF) ifTrue:[
        stats := self statementList
    ].
"/    (tokenType ~~ #EOF) ifTrue:[
"/        self parseError:'nothing more expected here' position:tokenPosition to:tokenPosition.
"/        ^ #Error
"/    ].
    (stats notNil
    and:[stats ~~ #Error]) ifTrue:[
        (self isStatementListAnUnconditionalReturn:stats) ifFalse:[
            "/ remember a returned self here.
            self rememberReturnedValue:(self selfNode)
        ].
    ].
    tree notNil ifTrue:[
        tree last nextStatement:stats.
        ^ tree.
    ].
    ^ stats

    "Modified: / 24-09-2010 / 18:03:59 / cg"
!

parseMethodBodyVarSpec
    "parse a methods local variable specification, handling
     possible primitive or resourceSpecs.
     .
     Leave spec of locals in methodLocals as a side effect.
     Return #Error or self.

     methodBodyVarSpec ::= '|' { IDENTIFIER } '|'
                            | <empty>
    "

    |var pos pos2 msg classHint whatIsHidden|

    ((tokenType == #BinaryOperator) and:[tokenName = '<']) ifTrue:[
        self parsePrimitiveOrResourceSpecOrEmpty.
    ].

    (tokenType == $|) ifTrue:[
        "memorize position for declaration in correction"

        localVarDefPosition := Array with:tokenPosition with:nil.
        self nextToken.
        pos := tokenPosition.
        [tokenType == #Identifier] whileTrue:[
            pos2 := tokenPosition + tokenName size - 1.
            self markLocalVariableDeclaration: tokenName from: tokenPosition to:pos2.
            self checkMethodVariableNameConventionsFor:tokenName.
            var := Variable name:tokenName.

            methodVars isNil ifTrue:[
                methodVars := OrderedCollection with:var.
                methodVarNames := OrderedCollection with:tokenName
            ] ifFalse:[
                (methodVarNames includes:tokenName) ifTrue:[
                    "/ redefinition
                    self isSyntaxHighlighter ifTrue:[
                        self markBadIdentifierFrom:tokenPosition to:pos2.
                    ] ifFalse:[
                        self
                            parseError:'redefinition of ''' , tokenName , ''' in local variables.'
                            position:tokenPosition to:pos2.
                    ]
                ] ifFalse:[
                    methodVars add:var.
                    methodVarNames add:tokenName
                ]
            ].

            (self isDoIt not
                    and:[ parserFlags warnHiddenVariables
                    and:[ ignoreWarnings not
                    and:[(ParserFlags isFlag:#warnHiddenVariables enabledForClass:classToCompileFor selector:selector)
            ]]]) ifTrue:[
                whatIsHidden := nil.
                methodArgNames notNil ifTrue:[
                    (methodArgNames includes:tokenName) ifTrue:[
                        whatIsHidden := 'method argument'
                    ]
                ].
                classToCompileFor notNil ifTrue:[
                    (self classesInstVarNames includes:tokenName) ifTrue:[
                        classToCompileFor isMeta ifTrue:[
                            whatIsHidden := 'class instance variable'.
                        ] ifFalse:[
                            whatIsHidden := 'instance variable'.
                        ]
                    ]
                ].
                whatIsHidden notNil ifTrue:[
                    PossibleCorrectionsQuery answer:{ CorrectByInteractiveRename . CorrectByDeletingLocalIdentifier } do:[
                        |fix|

                        fix := self
                            correctableWarning:(('local variable "%1" hides ',whatIsHidden,'.') bindWith:tokenName allBold)
                            doNotShowAgainAction:[ parserFlags warnHiddenVariables:false. ParserFlags warnHiddenVariables:false ]
                            doNotShowAgainForThisMethodAction: [ self disableWarningsOnCurrentMethodFor: #warnHiddenVariables ]
                            position:tokenPosition to:pos2.
                        fix isBehavior ifTrue:[
                            self correctWith:(fix new) from:pos to:pos2.
                        ].
                        "/ self breakPoint:#cg.
                        fix == #Error ifTrue:[
                            ^ #Error
                        ]
                    ]
                ]
            ].

            self nextToken.

            classHint := nil.
            lastDirective notNil ifTrue:[
                lastDirective isClassHintDirective ifTrue:[
                    var classHint:lastDirective className.
                ].
                lastDirective := nil.
            ].

            parserFlags allowLocalVariableDeclarationWithInitializerExpression == true ifTrue:[
                ((tokenType == $_) or:[tokenType == #':=']) ifTrue:[
                    self nextToken.
                    "/ Q: should we allow literals only, or arbitrary expressions ?
                    self shouldImplement.
                ]
            ].
            parserFlags allowDomainVariables == true ifTrue:[
                (tokenType == $() ifTrue:[
                    self variableTypeDeclarationFor:var.
                ].
            ].
            pos := tokenPosition
        ].

        (tokenType ~~ $|) ifTrue:[
            (#(True False Self Nil Super ThisContext) includes:tokenType) ifTrue:[
                msg := 'reserved keyword "',tokenName allBold,'" in local var declaration'.
                pos2 := tokenPosition + tokenName size - 1.
                self markBadIdentifierFrom:tokenPosition to:pos2.
            ] ifFalse:[
                pos2 := source position.
                msg := 'Identifier or | expected in local var declaration'
            ].
            self syntaxError:msg position:tokenPosition to:pos2.
            ^ #Error
        ].
        localVarDefPosition at:2 put:tokenPosition.
        
        methodVars isEmptyOrNil ifTrue:[
            parserFlags warnPossibleIncompatibilities == true ifTrue:[
                self
                    warning:('empty local variable list (possible incompatibility)')
                    doNotShowAgainAction:[ parserFlags warnPossibleIncompatibilities:false.
                                           ParserFlags warnPossibleIncompatibilities:false]
                    position:(localVarDefPosition first) to:source position.
            ]    
        ].    
        self nextToken
    ].

    (parserFlags allowSqueakPrimitives
    or:[ parserFlags allowSqueakExtensions
    or:[ parserFlags allowVisualAgePrimitives
    or:[ parserFlags allowSTVPrimitives ]]]) ifTrue:[
        "/ allow for primitiveSpec after local-var decl.

        ((tokenType == #BinaryOperator) and:[tokenName = '<']) ifTrue:[
            self parsePrimitiveOrResourceSpecOrEmpty.
        ]
    ].

    ^ self

    "Modified: / 25-02-2014 / 20:20:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-10-2017 / 16:58:13 / cg"
!

parseMethodSpec
    "parse a methods selector & arg specification;
     Set selector and methodArgs in the receiver as a side effect.
     Return the receiver or #Error.

     methodSpec ::= { KEYWORD IDENTIFIER }
                    | binaryOperator IDENTIFIER
                    | IDENTIFIER
    "

    |arg pos1 pos2 argPos1 argPos2 rawSelector|

    tokenType isNil ifTrue:[
        self nextToken.
    ].

    pos1 := tokenPosition.

    "/ selectorPositions := OrderedCollection new.

    (tokenType == #Keyword) ifTrue:[
        rawSelector := ''.
        [tokenType == #Keyword] whileTrue:[
            "/ selectorPositions add:(tokenPosition to:(tokenPosition+tokenName size - 1)).
            self markMethodSelectorFrom:tokenPosition to:(tokenPosition+tokenName size - 1).
            rawSelector := rawSelector , tokenName.
            self nextToken.

            (tokenType ~~ #Identifier) ifTrue:[
                "/ ^ #Error].
                ^ self identifierExpectedIn:'method-arg declaration'
            ].
            argPos1 := tokenPosition.
            argPos2 := argPos1+tokenName size - 1.
            pos2 := argPos2.
            self markMethodArgumentIdentifierFrom:argPos1 to:argPos2.
            self checkMethodArgumentNameConventionsFor:tokenName.
            arg := Variable name:tokenName.
            methodArgs isNil ifTrue:[
                methodArgs := Array with:arg.
                methodArgNames := Array with:tokenName
            ] ifFalse:[
                (methodArgNames includes:tokenName) ifTrue:[
                    self methodArgRedefined:tokenName from:argPos1 to:argPos2
                ].
                methodArgs := methodArgs copyWith:arg.
                methodArgNames := methodArgNames copyWith:tokenName
            ].
            self isSyntaxHighlighter ifFalse:[
                (ignoreWarnings not and:[parserFlags warnHiddenVariables]) ifTrue:[
                    classToCompileFor isClass ifTrue:[
                        (self classesInstVarNames includes:tokenName) ifTrue:[
                            PossibleCorrectionsQuery answer:{ CorrectByInteractiveRename } do:[
                                |fix|

                                fix := self
                                    correctableWarning:('Argument "' , tokenName allBold , '" hides instance variable.')
                                    position:argPos1 to:argPos2.
                                "/ migrating to the new scheme...
                                fix isBehavior ifTrue:[
                                    self correctWith:(fix new) from:argPos1 to:argPos2.
                                ].
                            ].
                        ]
                    ].
                ].
            ].
            self nextToken.
"/            ((tokenType == #BinaryOperator) and:[token = '#']) ifTrue:[
"/                self nextToken.
"/                arg domain:nil.
"/            ].
        ].

        selector := self makeSelector:rawSelector.
        endOfSelectorPosition := pos2.
        beginOfBodyPosition := tokenPosition.
        ^ self
    ].

    (self isValidUnarySelector:tokenType) ifTrue:[
        pos2 := pos1+tokenName size - 1.
        self markMethodSelectorFrom:pos1 to:pos2.
        rawSelector := tokenName.
        self nextToken.

        selector := self makeSelector:rawSelector.
        endOfSelectorPosition := pos2.
        beginOfBodyPosition := tokenPosition.
        ^ self
    ].

    "/ special handling for | and ^, which are also lexical tokens
    (tokenType == $|
    or:[(tokenType == $^) and:[parserFlags allowCaretAsBinop]]) ifTrue:[
        pos2 := pos1+token size - 1.
        token := tokenName := (String with:tokenType).
        tokenType := #BinaryOperator.
        self
            warnPossibleIncompatibility:('''',token,''' might not be a valid selector in other smalltalk systems')
            position:pos1 to:pos2.
    ].


    (tokenType == #BinaryOperator) ifTrue:[
        self markMethodSelectorFrom:pos1 to:(pos1+tokenName size - 1).
        rawSelector := tokenName.
        self nextToken.
        (tokenType ~~ #Identifier) ifTrue:[
            "/ ^ #Error
            ^ self identifierExpectedIn:'method-arg declaration'.
        ].
        argPos1 := tokenPosition.
        pos2 := argPos2 := argPos1+tokenName size - 1.
        self markMethodArgumentIdentifierFrom:argPos1 to:argPos2.
        self checkMethodArgumentNameConventionsFor:tokenName.
        arg := Variable name:tokenName.

        methodArgs := Array with:arg.
        methodArgNames := Array with:tokenName.

        endOfSelectorPosition := pos2.
        self nextToken.
        selector := self makeSelector:rawSelector.
        beginOfBodyPosition := tokenPosition.
"/            ((tokenType == #BinaryOperator) and:[token = '#']) ifTrue:[
"/                self nextToken.
"/                arg domain:nil.
"/            ].
        ^ self
    ].
    self parseError:'invalid method specification'.
    ^ #Error

    "Modified: / 12-07-2010 / 09:57:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 08:12:20 / cg"
!

returnStatement
    "parse a return statement;

     statement ::= '^' expression
    "

    |expr node lnr pos|

    pos := tokenPosition.

    self markReturnAt:tokenPosition.
    lnr := tokenLineNr.
    self nextToken.
    expr := self expression.
    (expr == #Error) ifTrue:[^ #Error].

    node := ReturnNode expression:expr.
    node startPosition:pos.
    node endPosition: expr endPosition.
    node home:self blockHome:currentBlock.
    true "(lineNumberInfo == #full)" ifTrue:[node lineNumber:lnr].
    self checkPlausibilityOf:node from:pos to:node endPosition.

    "/ already in expression
    "/ self checkPlausibilityOf:expr from:pos to:tokenPosition.
    self rememberReturnedValue:expr.
    ^ node

    "Created: / 05-07-2011 / 21:22:05 / cg"
    "Modified: / 27-07-2011 / 13:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2012 / 01:03:36 / cg"
!

statement
    "parse a statement; return a node-tree or #Error.

     statement ::= '^' expression
                   | PRIMITIVECODE
                   | expression
    "

    |expr node lnr code pos|

    pos := tokenPosition.

    (tokenType == $^) ifTrue:[
        ^ self returnStatement
    ].

    (tokenType == #Primitive) ifTrue:[
        code := tokenValue.
        node := PrimitiveNode code:code.
        node startPosition: tokenPosition endPosition: source position + 1.
        self nextToken.
        node isOptional ifFalse:[
            hasNonOptionalPrimitiveCode := true
        ].
        hasPrimitiveCode := true.
        ^ node
    ].

    (tokenType == #EOF) ifTrue:[
        currentBlock notNil ifTrue:[
            self syntaxError:'missing '']'' at end of block'.
        ] ifFalse:[
            self syntaxError:'period after last statement'.
        ].
        ^ #Error
    ].

    (tokenType == $.) ifTrue:[
        (parserFlags allowEmptyStatements
        or:[parserFlags allowSqueakExtensions == true]) ifTrue:[
            "/ allow empty statement
            self warnAboutEmptyStatement.
            node := StatementNode expression:nil.
            node startPosition:pos.
            ^ node
        ].
    ].

    lnr := tokenLineNr.

    expr := self expression.
    (expr == #Error) ifTrue:[^ #Error].

"/    classToCompileFor notNil ifTrue:[
"/        currentBlock isNil ifTrue:[
"/            expr isPrimary ifTrue:[
"/                self warning:'useless computation - missing ^ ?'
"/            ]
"/        ]
"/    ].

    node := StatementNode expression:expr.
    parserFlags fullLineNumberInfo ifTrue:[node lineNumber:lnr].
    node startPosition:pos.
    ^ node

    "Modified: / 01-08-2011 / 12:03:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2012 / 14:15:10 / cg"
!

statementList
    "parse a statementlist; return a node-tree, nil or #Error.
     Statements must be separated by periods.

     statementList ::= <statement>
                       | <statementList> . <statement>
    "

    |thisStatement prevStatement firstStatement periodPos prevExpr|

    thisStatement := self statement.
    (thisStatement == #Error) ifTrue:[^ #Error].
    firstStatement := thisStatement.
    [tokenType == $.] whileTrue:[
        prevExpr := thisStatement expression.
        (prevExpr notNil
        and:[prevExpr isMessage
        and:[thisStatement isReturnNode not]]) ifTrue:[
            (#(#'=' #'==') includes:prevExpr selector) ifTrue:[
                self warning:'useless computation - mistyped assignment (i.e. did you mean '':='') ?' position:prevExpr selectorPosition
            ].
        ].

        periodPos := tokenPosition.
        self nextToken.
        tokenType == $. ifTrue:[
            self emptyStatement.
        ].
        (tokenType == $]) ifTrue:[
            currentBlock isNil ifTrue:[
                self parseError:''']'' unexpected (block nesting error)'.
            ].
            ^ self statementListRewriteHookFor:firstStatement
        ].
        (tokenType == #EOF) ifTrue:[
            currentBlock notNil ifTrue:[
                self parseError:''']'' expected (block nesting error)'.
            ].
            ^ self statementListRewriteHookFor:firstStatement
        ].

        prevStatement := thisStatement.
        prevStatement isReturnNode ifTrue:[
            parserFlags warnPossibleIncompatibilities ifTrue:[
                self warning:'Statements after return.\\Some other Smalltalk systems will not allow this (Squeak, for example)' withCRs position:tokenPosition
            ].
        ].

        thisStatement := self statement.
        (thisStatement == #Error) ifTrue:[^ #Error].
        prevStatement nextStatement:thisStatement
    ].
    ^ self statementListRewriteHookFor:firstStatement

    "Modified: / 20-03-2012 / 12:44:12 / cg"
!

variableTypeDeclarationFor:aVariable
    "experimental support for Domain variables (constraint programming support):
     a variable-declaration of the form
        |var (domain) ... |
     declares var as a domainVariable.
     Valid domains are:
        min %% max      - integer range domain
        Bool            - boolean domain
        Nat             - positive integer domain
        Int             - integer domain
        #sym1 ... #sym2 - enumerated symbolic domain
    "

    |min max domain enumValues|

    (tokenType == $() ifFalse:[
        self syntaxError:'''('' expected' position:tokenPosition.
        ^ #Error
    ].
    self nextToken.

    (tokenType == #Integer) ifTrue:[
        min := token.
        self nextToken.
        ((tokenType == #BinaryOperator) and:[token = '%%']) ifFalse:[
            self syntaxError:'''%%'' expected' position:tokenPosition.
        ].
        self nextToken.
        (tokenType == #Integer) ifFalse:[
            self syntaxError:'Integer (upper bound) expected' position:tokenPosition.
        ].
        max := token.
        self nextToken.
        domain := IntegerDomain min:min max:max.
    ] ifFalse:[
        ((tokenType == #Identifier) and:[token isUppercaseFirst]) ifTrue:[
            token = 'Bool' ifTrue:[
                self nextToken.
                domain := BooleanDomain singleton.
            ].
            token = 'Nat' ifTrue:[
                self nextToken.
                domain := IntegerDomain min:0 max:(SmallInteger maxVal).
            ].
            token = 'Int' ifTrue:[
                self nextToken.
                domain := IntegerDomain min:(SmallInteger minVal) max:(SmallInteger maxVal).
            ].
        ] ifFalse:[
            ((tokenType == #Symbol) or:[(tokenType == #Identifier)]) ifTrue:[
                enumValues := OrderedCollection new.
                [((tokenType == #Symbol) or:[(tokenType == #Identifier)])] whileTrue:[
                    enumValues add:token.
                    self nextToken.
                ].
                domain := EnumeratedDomain new values:enumValues.
            ].
        ].
    ].
    domain isNil ifTrue:[
        self syntaxError:'invalid domain' position:tokenPosition.
    ].
    aVariable domain:domain.

    (tokenType == $)) ifFalse:[
        self syntaxError:''')'' expected' position:tokenPosition.
        ^ #Error
    ].
    self nextToken.

    "Modified: / 09-08-2010 / 00:27:16 / cg"
!

warnAboutEmptyStatement
    parserFlags warnAboutPossibleSTCCompilationProblems ifTrue:[
        self
            warning:'stc will not compile empty statements'
            line:lineNr.

        (Tools::ToDoListBrowser notNil and:[self classToCompileFor notNil]) ifTrue:[
            self
                notifyTodo:'stc will not compile empty statements' position:tokenPosition
                className:(self classToCompileFor name) selector:selector
                severity:#warning priority:#medium
                equalityParameter:nil
                checkAction:nil.
        ].
    ].
! !

!Parser methodsFor:'parsing-expressions'!

array
    "parse a literal array's elements"
    
    |arr elements elem pos1|

    pos1 := tokenPosition.
    elements := OrderedCollection new.
    [tokenType ~~ $) ] whileTrue:[
        elem := self arrayConstant.

"/        (elem == #Error) ifTrue:[
"/            (tokenType == #EOF) ifTrue:[
"/                self syntaxError:'unterminated array-constant; '')'' expected'
"/                        position:pos1 to:tokenPosition
"/            ].
"/            ^ #Error
"/        ].
        elem isSymbol ifTrue:[
            self markSymbolFrom:tokenPosition to:(source position).
        ].
        elements add:elem.
        self nextToken.
"/        tokenType == $. ifTrue:[
"/            self emptyStatement.
"/        ].
    ].

    elements size == 0 ifTrue:[
        "always return the same object for an empty array,
         which is also immutable by definition"
        ^ #().
    ].

    arr := elements asArray.

    parserFlags arraysAreImmutable ifTrue:[
        ^ self makeImmutableArray:arr
    ].
    ^ arr

    "Modified: / 30-07-2013 / 19:33:43 / cg"
!

arrayConstant
    |val|

    (tokenType == #Nil) ifTrue:[
        self warnPossibleIncompatibility:'nil in array constant is interpreted as #nil (symbol) in some other (older) Smalltalks' position:tokenPosition to:tokenPosition+token size - 1.
        ^ tokenValue
    ].
    (tokenType == #True) ifTrue:[
        self warnPossibleIncompatibility:'true in array constant is interpreted as #true (symbol) in some other (older) Smalltalks' position:tokenPosition to:tokenPosition+token size - 1.
        ^ tokenValue
    ].
    (tokenType == #False) ifTrue:[
        self warnPossibleIncompatibility:'false in array constant is interpreted as #false (symbol) in some other (older) Smalltalks' position:tokenPosition to:tokenPosition+token size - 1.
        ^ tokenValue
    ].
    ((tokenType == #Integer)
    or:[tokenType == #Float]) ifTrue:[
        ^ tokenValue
    ].
    (tokenType == #String) ifTrue:[
        parserFlags stringsAreImmutable ifTrue:[^ self makeImmutableString:tokenValue].
        ^ tokenValue
    ].
    (tokenType == #Character) ifTrue:[
        ^ tokenValue
    ].
    (tokenType == #Error) ifTrue:[
        ^ ParseError raiseRequest.
    ].
    (tokenType == #BinaryOperator) ifTrue:[
        val := tokenName asSymbol.
        parseForCode ifFalse:[
            self rememberSymbolUsed:val.
        ].
        ^ val
    ].

    "/ some more special symbol consts ...
    (tokenType == $| ) ifTrue:[
        ^ #|
    ].
    (tokenType == #Self ) ifTrue:[
        ^ #'self'
    ].
    (tokenType == #Super ) ifTrue:[
        ^ #'super'
    ].
    (tokenType == #Here ) ifTrue:[
        ^ #'here'
    ].
    (tokenType == #ThisContext ) ifTrue:[
        ^ #'thisContext'
    ].

    ((tokenType == #Keyword)
    or:[tokenType == #Identifier]) ifTrue:[
        val := tokenName asSymbol.
        parseForCode ifFalse:[
            self rememberSymbolUsed:val.
        ].
        ^ val
    ].
    ((tokenType == $()
    or:[tokenType == #HashLeftParen]) ifTrue:[
        self nextToken.
        ^ self array
    ].
    ((tokenType == $[)
    or:[tokenType == #HashLeftBrack]) ifTrue:[
        self nextToken.
        ^ self byteArray
    ].
    (tokenType == #HashLeftBrace) ifTrue:[
        parserFlags allowQualifiedNames == true ifFalse:[
            self parseError:'non-Standard VisualWorks extension: #{..}. Please enable in settings.' position:tokenPosition to:tokenPosition+1.
        ].
        val := self qualifiedNameOrInlineObject .
        "/ val := QualifiedName for:val name.
        val := val value.
        ^ val
    ].
    (tokenType == #Symbol) ifTrue:[
        parseForCode ifFalse:[
            self rememberSymbolUsed:tokenValue.
        ].
        ^ tokenValue
    ].
    (tokenType == #EOF) ifTrue:[
        "just for the better error-hilight; let caller handle error"
        self syntaxError:'EOF unexpected in array-constant'.
        ^ ParseError raiseRequest.
    ].
    self syntaxError:('"'
                      , tokenType printString
                      , '" unexpected in array-constant').
    ^ ParseError raiseRequest.

    "Modified: / 22-08-2006 / 14:21:16 / cg"
!

arrayIndexingExpression
    "parse an array index expression; this is a squeak/stx extension.
     foo[x] is syntactic sugar for 'foo at:x'
     and foo[x] := expr is syntactic sugar for 'foo at:x put:expr';
     with commas, foo[x , y] generates foo at:x at:y.
     This syntax extension must be enabled in the parserFlags as
     allowArrayIndexSyntaxExtension (disabled by default)"

    |receiver argList selectorStream valNode|

    parserFlags allowFunctionCallSyntaxForBlockEvaluation ifTrue:[
        receiver := self functionCallExpression.
    ] ifFalse:[
        receiver := self primary.
    ].
    tokenType == $[ ifFalse:[^ receiver].
    parserFlags allowArrayIndexSyntaxExtension == true ifFalse:[^ receiver.].
    (receiver == #Error) ifTrue:[^ #Error].

    selectorStream := WriteStream on: (String new: 32).
    argList := OrderedCollection new.

    [
        [
            |indexNode|

            self nextToken.
            indexNode := self expression.
            argList isEmpty ifTrue:[selectorStream nextPutAll:'_'].
            selectorStream nextPutAll:'at:'.
            argList add: indexNode.
            (tokenType == #BinaryOperator ) and:[ token = ',']
        ] whileTrue.

        tokenType == $] ifFalse:[
            self parseError:''']'' expected'.
            ^ #Error
        ].
        self nextToken.

        tokenType == $[ ifTrue:[
            receiver := MessageNode
                    receiver:receiver
                    selector:(selectorStream contents)
                    args:argList.
            selectorStream := WriteStream on: (String new: 32).
        ].
        tokenType == $[
    ] whileTrue.

    tokenType == #':=' ifTrue:[
        self nextToken.
        selectorStream nextPutAll:'put:'.
        valNode := self expression.
        valNode == #Error ifTrue:[
            ^ valNode
        ].
"/ this was found in squeak - why make it a block ?
"/        (valNode isKindOf: BlockNode) ifFalse:[
"/                valNode _ BlockNode new
"/                                        arguments: #()
"/                                        statements: (OrderedCollection with: valNode)
"/                                        returns: false
"/                                        from: encoder.
"/        ].
        argList add: valNode
    ].

    ^ MessageNode
            receiver:receiver
            selector:selectorStream contents
            args:argList.

    "
     AllowArrayIndexSyntaxExtension := true.
     AllowArrayIndexSyntaxExtension := false.
    "

    "
     |foo|

     foo := Array new:10 withAll:2.
     1 + foo[1].
    "
    "
     |foo|

     foo := Array new:10.
     foo[1] := 'hello'.
     foo[2].
     foo[1].
    "

    "Modified: / 08-08-2017 / 16:56:33 / cg"
!

binaryExpression
    "parse a binary-expression; return a node-tree, nil or #Error"

    |receiver|

    receiver := self unaryExpression.
    (receiver == #Error) ifTrue:[^ #Error].
    tokenType == #EOF ifTrue:[^ receiver].
    tokenType == $] ifTrue:[^ receiver].
    tokenType == $) ifTrue:[^ receiver].

    ^ self binaryExpressionFor:receiver
!

binaryExpressionFor:receiverArg
    "parse a binary-expression; return a node-tree, nil or #Error"

    |receiver expr arg sel pos1 pos2 lno|

    receiver := receiverArg.
    (receiver == #Error) ifTrue:[^ #Error].

    "special kludge: since Scanner cannot know if -digit is a binary
     expression or a negative constant, handle cases here"

    [(tokenType == #BinaryOperator)
     or:[(tokenType == $|)
     or:[(tokenType == $^ and:[parserFlags allowCaretAsBinop or:[parserFlags allowExtendedBinarySelectors]])
         or:[((tokenType == #Integer) or:[tokenType == #Float])
             and:[tokenValue < 0]]]]
    ] whileTrue:[
        "/ kludge alarm: in a function-call argList, #, is not a binarySelector
        inFunctionCallArgument == true ifTrue:[
            ((tokenType == #BinaryOperator) and:[tokenName = ',']) ifTrue:[
                ^ receiver
            ].
        ].

        pos1 := tokenPosition.
        lno := tokenLineNr.

        "/ kludge alarm: bar, caret and minus are not scanned as binop
        (tokenType == $|) ifTrue:[
            sel := '|'.
            sel := self selectorCheck:sel for:receiver position:tokenPosition to:tokenPosition.
            self nextToken.
        ] ifFalse:[
            (tokenType == $^) ifTrue:[
                sel := '^'.
                sel := self selectorCheck:sel for:receiver position:tokenPosition to:tokenPosition.
                self nextToken.
            ] ifFalse:[
                (tokenType == #BinaryOperator) ifTrue:[
                    sel := tokenName.
                    sel := self selectorCheck:sel for:receiver position:tokenPosition to:(tokenPosition + tokenName size - 1).
                    self nextToken
                ] ifFalse:[
                    sel := '-'.
                    token := tokenValue := tokenValue negated.
                    tokenPosition := tokenPosition + 1. "/ to skip the sign
                ]
            ].
        ].

        pos2 := pos1 + sel size - 1.
        self markSelector:sel from:pos1 to:pos2 receiverNode:receiver.

        arg := self unaryExpression.
        (arg == #Error) ifTrue:[^ #Error].

        expr := BinaryNode receiver:receiver selector:sel arg:arg fold:foldConstants.
        expr isErrorNode ifTrue:[
            self parseError:(expr errorString) position:pos1 to:tokenPosition.
            self clearErrorFlag. "ok, user wants it - so he'll get it"
            expr := BinaryNode receiver:receiver selector:sel arg:arg fold:nil.
        ].
        expr lineNumber:lno.
        expr selectorPosition:pos1.

        (self isPossiblyUninitializedLocal:arg) ifTrue:[
            self
                warning:'"',arg name,'" is uninitialized here (always nil)'
                position:(arg startPosition) to:(arg endPosition).
        ].

        self checkPlausibilityOf:expr from:pos1 to:pos2.
        parseForCode ifFalse:[
            self rememberSelectorUsed:sel receiver:receiver
        ].
        expr := self messageNodeRewriteHookFor:expr.
        receiver := expr.   "/ for next message
    ].
    ^ receiver

    "Modified: / 09-01-1998 / 19:05:18 / stefan"
    "Modified: / 19-01-2012 / 10:44:22 / cg"
!

byteArray
    "parse a literal byteArray's elements"

    "literal bytearrays started with ST-80 R4 - byteArray constants are written as #[ ... ]"

    |bytes index limit newArray elem pos1 pos2|

    pos1 := tokenPosition.
    index := 0. limit := 5000.
    bytes := ByteArray uninitializedNew:limit.
    [tokenType ~~ $] ] whileTrue:[
        pos2 := tokenPosition.
        "
         this is not good programming style, but speeds up
         reading of huge byte arrays (i.e. stored Images ...)
        "
        (tokenType == #Integer) ifTrue:[
            elem := tokenValue
        ] ifFalse:[
            elem := self arrayConstant.
            (elem == #Error) ifTrue:[
                (tokenType == #EOF) ifTrue:[
                    self syntaxError:'unterminated bytearray-constant; '']'' expected'
                            position:pos1 to:tokenPosition
                ].
                ^ #Error
            ].
        ].
        ((elem isMemberOf:SmallInteger) and:[elem between:-128 and:-1]) ifTrue:[
            parserFlags allowSignedByteArrayElements ifTrue:[
                elem := elem bitAnd:16rFF.
            ].    
        ].    
        ((elem isMemberOf:SmallInteger) and:[elem between:0 and:255]) ifTrue:[
            index := index + 1.
            bytes at:index put:elem.
            index == limit ifTrue:[
                newArray := ByteArray uninitializedNew:(limit * 2).
                newArray replaceFrom:1 to:limit with:bytes startingAt:1.
                limit := limit * 2.
                bytes := newArray
            ].
        ] ifFalse:[
            self parseError:'invalid ByteArray element:',elem printString position:pos2 to:tokenPosition - 1
        ].
        self nextToken.
    ].

    index == 0 ifTrue:[
        "always return the same object for an empty byte array,
         which is also immutable by definition"
        ^ #[].
    ].

    newArray := ByteArray uninitializedNew:index.
    newArray replaceFrom:1 to:index with:bytes startingAt:1.
    parserFlags arraysAreImmutable ifTrue:[
        ^ self class makeImmutableByteArray:newArray
    ].
    ^ newArray
!

degeneratedKeywordExpressionForSelector
    "parse a keyword-expression without receiver - for the selector only.
     Return the selector or nil (if it cannot be determined).
     This is not used in normal parsing, but instead to extract the selector from a code fragment.
     (for example, the system browsers 'implementors'-function uses this to extract a selector from
      the selection)"

    |sel arg rec|

    (tokenType == #Keyword) ifTrue:[
        sel := tokenName.
        self nextToken.
        arg := self binaryExpression.
        (arg == #Error) ifTrue:[^ sel].
        [tokenType == #Keyword] whileTrue:[
            sel := sel , tokenName.
            self nextToken.
            arg := self binaryExpression.
            (arg == #Error) ifTrue:[^ sel].
        ].
        ^ sel
    ].

    (rec := self arrayIndexingExpression) == #Error ifTrue:[ ^ nil].
    sel := self degeneratedKeywordExpressionForSelector.
    sel notNil ifTrue:[ ^ sel].

    rec isAssignment ifTrue:[
        rec := rec expression
    ].
    rec isMessage ifTrue:[
        ^ rec selector
    ].
    ^ nil

    "
     (self new source:'hello:world:') nextToken; degeneratedKeywordExpressionForSelector
     (self new source:'hello:world') nextToken; degeneratedKeywordExpressionForSelector
     (self new source:'hello:') nextToken; degeneratedKeywordExpressionForSelector
    "
!

expression
    "parse a cascade-expression; return a node-tree, nil or #Error.

     expression ::= keywordExpression
                    | keywordExpression cascade

     cascade ::= ';' expressionSendPart
                 | cascade ';' expressionSendPart

     expressionSendPart ::= { KEYWORD binaryExpression }
                            | BINARYOPERATOR unaryExpression
                            | IDENTIFIER
    "

    |receiver arg sel args pos pos2 lno tokenStart tokenEnd realReceiver positions
     lastSemiPosition|

    pos := tokenPosition.
    receiver := self keywordExpression.
    (receiver == #Error) ifTrue:[^ #Error].
    (tokenType == $;) ifTrue:[
        receiver isMessage ifFalse:[
            self syntaxError:'left side of cascade must be a message expression'
                    position:pos to:tokenPosition.
            realReceiver := receiver. "/ only to allow continuing.
        ] ifTrue:[
            realReceiver := receiver receiver.
        ].
        [tokenType == $;] whileTrue:[
            lastSemiPosition := tokenPosition.
            self nextToken.

            (tokenType == #Identifier) ifTrue:[
                tokenStart := tokenPosition.
                tokenEnd := tokenPosition + tokenName size - 1.
                self markSelector:tokenName from:tokenPosition to:tokenEnd receiverNode:realReceiver.
                sel := tokenName.
                sel := self selectorCheck:tokenName for:realReceiver position:tokenPosition to:tokenEnd.
                receiver := CascadeNode receiver:receiver selector:sel.
                receiver startPosition: tokenStart endPosition: tokenEnd.
                receiver selectorPartPositions: (Array with: (tokenStart to: tokenEnd)).
                receiver lineNumber:tokenLineNr.
                receiver := self messageNodeRewriteHookFor:receiver.
                parseForCode ifFalse:[
                    self rememberSelectorUsed:sel receiver:realReceiver
                ].
                self nextToken.
            ] ifFalse:[
                (tokenType == #BinaryOperator) ifTrue:[
                    tokenStart := tokenPosition.
                    tokenEnd := tokenPosition + tokenName size - 1.
                    self markSelector:tokenName from:tokenPosition to:tokenEnd receiverNode:realReceiver.
                    sel := tokenName.
                    sel := self selectorCheck:tokenName for:realReceiver position:tokenPosition to:tokenEnd.
                    lno := tokenLineNr.
                    self nextToken.
                    arg := self unaryExpression.
                    (arg == #Error) ifTrue:[^ #Error].
                    receiver := CascadeNode receiver:receiver selector:sel arg:arg.
                    receiver startPosition: tokenStart endPosition: arg endPosition.
                    receiver selectorPartPositions: (Array with: (tokenStart to: tokenEnd)).
                    receiver lineNumber:lno.
                    receiver := self messageNodeRewriteHookFor:receiver.
                    receiver lineNumber:lno.
                    parseForCode ifFalse:[
                        self rememberSelectorUsed:sel receiver:realReceiver
                    ].
                ] ifFalse:[
                    (tokenType == #Keyword) ifTrue:[
                        tokenStart := tokenPosition.
                        tokenEnd := tokenPosition + tokenName size - 1.
                        positions := OrderedCollection with:(tokenPosition to:tokenEnd).
                        pos := tokenPosition.
                        pos2 := tokenEnd.
                        lno := tokenLineNr.
                        sel := tokenName.
                        self nextToken.
                        arg := self binaryExpression.
                        (arg == #Error) ifTrue:[^ #Error].
                        args := Array with:arg.
                        [tokenType == #Keyword] whileTrue:[
                            tokenEnd := tokenPosition + tokenName size - 1.
                            positions add:(tokenPosition to:tokenEnd).
                            sel := sel , tokenName.
                            self nextToken.
                            arg := self binaryExpression.
                            (arg == #Error) ifTrue:[^ #Error].
                            args := args copyWith:arg.
                            pos2 := tokenEnd
                        ].

                        self isSyntaxHighlighter ifTrue:[
                            positions do:[:p |
                                self markSelector:sel from:p start to:p stop receiverNode:realReceiver.
                            ].
                        ].

                        sel := self selectorCheck:sel for:realReceiver position:pos to:pos2.

                        receiver := CascadeNode receiver:receiver selector:sel args:args.
                        receiver lineNumber:lno.
                        receiver startPosition: tokenStart endPosition: args last endPosition.
                        receiver := self messageNodeRewriteHookFor:receiver.
                        receiver lineNumber:lno.
                        receiver selectorPartPositions: positions.
                        parseForCode ifFalse:[
                            self rememberSelectorUsed:sel receiver:realReceiver args:args
                        ].
                    ] ifFalse:[
                        (tokenType == #Error) ifTrue:[^ #Error].
                        self syntaxError:('invalid cascade; ' , tokenType printString , ' unexpected')
                                position:lastSemiPosition to:source position.
                        ^ #Error
                    ]
                ]
            ]
        ].

        "obscure (unspecified ?) if selector follows; Question:

        is
                'expr sel1; sel2 sel3'

        to be parsed as:
                (t := expr.
                 t sel1.
                 t sel2) sel3

         or:
                (t := expr.
                 t sel1.
                 t sel2 sel3)
        "
        ((tokenType == #Identifier)
         or:[(tokenType == #BinaryOperator)
             or:[tokenType == #Keyword]]) ifTrue:[
            self syntaxError:'ambiguous cascade - please group using (...)'
                    position:tokenPosition to:source position.
            ^ #Error
"/            self warning: "syntaxError:" 'possibly ambiguous cascade - please group using (...)'
"/                    position:tokenPosition to:source position - 1.
"/            tokenType == #Identifier ifTrue:[
"/                ^ self unaryExpressionFor:receiver
"/            ].
"/            tokenType == #BinaryOperator ifTrue:[
"/                ^ self binaryExpressionFor:receiver
"/            ].
"/            ^ self keywordExpressionFor:receiver
        ]
    ].
    ^ receiver

    "Modified: / 01-10-2013 / 20:54:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-08-2017 / 17:06:12 / cg"
    "Modified: / 09-08-2017 / 14:46:56 / mawalch"
!

functionCallArgList
    |argList arg prevInFunctionCallArgument|

    self nextToken.
    tokenType == $) ifTrue:[ self nextToken. ^ #() ].

    argList := OrderedCollection new.
    [
        prevInFunctionCallArgument := inFunctionCallArgument.
        inFunctionCallArgument := true.

        arg := self expression.
        arg == #Error ifTrue:[^ #Error].
        argList add:arg.

        inFunctionCallArgument := prevInFunctionCallArgument.

        tokenType == $) ifTrue:[
            self nextToken.
            ^ argList
        ].
        ((tokenType == #BinaryOperator) and:[tokenName = ',']) ifFalse:[
            self parseError:'"," or ")" expected'.
            ^ argList
        ].
        self nextToken.
    ] loop.
!

functionCallExpression
    "parse a functionCall;
     this is an st/x extension.
        foo(x)
     is syntactic sugar for
        foo value:x
     This syntax extension must be enabled in the parserFlags as
     allowFunctionCallSyntaxForBlockEvaluation (disabled by default)
    "

    |receiver numArgs argList evalSelectors evalSelector|

    receiver := self primary.
    tokenType == $( ifFalse:[^ receiver].
    parserFlags allowFunctionCallSyntaxForBlockEvaluation ifFalse:[^ receiver.].

    (receiver == #Error) ifTrue:[^ #Error].

    receiver isVariable ifFalse:[
        ((receiver isMessage or:[receiver isAssignment]) and:[receiver parenthesized]) ifFalse:[
            receiver isBlock ifFalse:[
                ^ receiver
            ]
        ].
    ].

    argList := self functionCallArgList.

    "/ make it a block evaluation
    numArgs := argList size.
    numArgs == 0 ifTrue:[
        ^ UnaryNode receiver:receiver selector:#value
    ].
    evalSelectors := #(#'value:'
                       #'value:value:'
                       #'value:value:value:'
                       #'value:value:value:value:'
                       #'value:value:value:value:value:'
                       #'value:value:value:value:value:value:'
                       #'value:value:value:value:value:value:value:'
                       #'value:value:value:value:value:value:value:value:'
                     ).

    numArgs <= evalSelectors size ifTrue:[
        evalSelector := evalSelectors at:numArgs.
        ^ (MessageNode
                receiver:receiver
                selector:evalSelector
                args:argList)
                startPosition: receiver startPosition
                endPosition: tokenLastEndPosition.
    ].
    "/ gen argument vector
    ^ (MessageNode
            receiver:receiver
            selector:#valueWithArguments:
            args:(self genMakeArrayWith:argList))
            startPosition: receiver startPosition
            endPosition: tokenLastEndPosition.
    "
     Parser allowFunctionCallSyntaxForBlockEvaluation:true.
    "

    "
     |foo|

     foo := [:x | x + 1].
     1 + foo(1).
     foo(1).
    "
    "
     |addN add1|

     addN := [:n | [:x | x + n]].
     add1 := addN(1).
     add1(10).
    "
    "AllowFunctionCallSyntaxForBlockEvaluation := false."
    "
     |addN add1|

     addN := [:n | [:x | x + n]].
     add1 := addN value:1.
     add1 value:10
    "

    "Modified: / 27-07-2011 / 15:39:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inlineObjectFrom:pos1
    "an experimental ST/X feature.
     InlineObject as #{ name1: value1. ... nameN: valueN }
     creates a literal object with an anon class which provides getter/setters on all
     names and is preinitialized with valueI.
     The initial #{ is supposed to be skipped and its position passed in as pos1."

    |namesAndValues name value|

    namesAndValues := OrderedCollection new.
    [ tokenType ~~ $} ] whileTrue:[
        (tokenType == #Keyword) ifFalse:[
            self syntaxError:'Bad inlineObject; Keyword expected'
                    position:pos1 to:tokenPosition
        ].
        name := tokenName copyButLast:1.
        self nextToken.
        value := self arrayConstant.
        self nextToken.
        namesAndValues add:(name -> value).

        tokenType == $. ifTrue:[
            self nextToken.
        ].
    ].

    didWarnAboutSTXExtensions~~ true ifTrue:[
        didWarnAboutSTXExtensions := true.
        self
            warning:'InlineObjects are an experimental feature which is not yet supported by stc'
            position:pos1 to:tokenPosition.
    ].
    self nextToken.
    ^ ConstantNode type:#Object value:(self literalInlineObjectFor:namesAndValues).
!

keywordExpression
    "parse a keyword-expression; return a node-tree, nil or #Error.

     keywordExpression ::= binaryexpression
                           | { KEYWORD-PART binaryExpression }
    "

    |receiver expr|

    receiver := self binaryExpression.
    (receiver == #Error) ifTrue:[^ #Error].
    (tokenType == #EOF) ifTrue:[^ receiver].
    tokenType == $] ifTrue:[^ receiver].
    tokenType == $) ifTrue:[^ receiver].
    expr := self keywordExpressionFor:receiver.

    expr == #Error ifTrue:[ "/ should no longer happen
        "/ self breakPoint:#cg.
        ^ #Error
    ].

    "/ expr could be an assignment as well, here
    (ignoreWarnings or:[ignoreErrors]) ifFalse:[
        "/ for a better error message, in case of a missing period in the previous message,
        "/    <expr> <missing period> foo := ...
        "/ would be parsed as unary message foo; detect this here, instead of high up in the calling hierarchy,
        "/ where it is difficult to provide a reasonable error message
        tokenType == #':=' ifTrue:[
            |positionOfPeriod|

            expr isMessage ifTrue:[
                expr isUnaryMessage ifTrue:[
                    positionOfPeriod := expr receiver positionToInsertPeriodForStatementSeparation
                ] ifFalse:[
                    |lastArg|

                    (lastArg := expr args last) isUnaryMessage ifTrue:[
                        positionOfPeriod := lastArg receiver positionToInsertPeriodForStatementSeparation
                    ].
                ].
            ].
            positionOfPeriod notNil ifTrue:[
                PossibleCorrectionsQuery answer:{ CorrectByInsertingPeriod new positionOfPeriod:positionOfPeriod} do:[
                    |fix|

                    fix := self
                        correctableWarning:('":=" unexpected. Probably missing "." in previous expression.')
                        position:tokenPosition to:tokenPosition+token size-1.

                    (fix isBehavior or:[fix isKindOf:Correction]) ifTrue:[
                        self correctWith:fix from:tokenPosition to:tokenPosition+token size-1.
                    ].
self breakPoint:#cg.
                    fix == #Error ifTrue:[
                        ^ #Error
                    ]
                ]
            ]
        ].
    ].

    ^ expr
!

keywordExpressionFor:receiverArg
    "parse a keyword-expression; return a node-tree, nil or #Error.

     keywordExpression ::= binaryexpression
                           | { KEYWORD-PART binaryExpression }
    "

    |expr receiver sel selChecked arg args posR1 posR2 pos1 pos2 lno selectorPartPositions|

    receiver := receiverArg.
    posR1 := tokenPosition.
    (tokenType == #Keyword) ifFalse:[^ receiver].

    pos1 := posR2 := tokenPosition.
    pos2 := tokenPosition + tokenName size - 1.
    selectorPartPositions := OrderedCollection with:(pos1 to:pos2).
    sel := tokenName.
    lno := tokenLineNr.
    self nextToken.
    arg := self binaryExpression.
    (arg == #Error) ifTrue:[^ #Error].
    args := Array with:arg.
    [tokenType == #Keyword] whileTrue:[
        sel := sel , tokenName.
        pos2 := tokenPosition + tokenName size - 1.
        selectorPartPositions add:(tokenPosition to:pos2).
        self nextToken.
        arg := self binaryExpression.
        (arg == #Error) ifTrue:[^ #Error].
        args := args copyWith:arg.
    ].

    args do:[:eachArg |
        (self isPossiblyUninitializedLocal:eachArg) ifTrue:[
            self
                warning:'"',eachArg name,'" is uninitialized here (always nil)'
                position:(eachArg startPosition) to:(eachArg endPosition).
        ].
    ].

    selectorPartPositions do:[:p |
        self markSelector:sel from:p start to:p stop receiverNode:receiver.
    ].

    "/ need this before, so receiver has a parent (needed by correction)
    expr := MessageNode receiver:receiver selector:sel args:args fold:foldConstants.
    expr selectorPartPositions:selectorPartPositions.

    selChecked := self selectorCheck:sel for:receiver positions:selectorPartPositions.

    ignoreWarnings ifFalse:[
        (Class definitionSelectors includes:sel) ifTrue:[
            (receiver isVariable and:[receiver isUndeclared]) ifTrue:[
                "this is not an error - the undefined class may be loaded after this code!!"
                self warning:('as yet undefined superclass: ' , receiver name) position:pos1 to:pos2.
            ].
        ].
    ].

    expr isErrorNode ifTrue:[
        self parseError:(expr errorString) position:pos1 to:pos2.
        self clearErrorFlag. "ok, user wants it - so he'll get it"
        expr := MessageNode receiver:receiver selector:sel args:args fold:nil.
    ].

    sel ~~ selChecked ifTrue:[
        expr args size ~~ args size ifTrue:[
            self parseError:'Parser: selector botch (message folded?'.
        ].
        expr selector:sel. "/ in case it was changed in the selectorCheck.
    ].
    expr lineNumber:lno.
    self checkPlausibilityOf:expr from:pos1 to:pos2.

    "/ parseForCode ifFalse:[
        self rememberSelectorUsed:sel receiver:receiver args:args.
    "/ ].

"/        (contextToEvaluateIn isNil and:[selfValue isNil]) ifTrue:[    "/ do not check this for doits
"/            receiver isSuper ifTrue:[
"/                sel ~= selector ifTrue:[
"/                    self warnCommonMistake:'possible bad super message (selector should be same as in current method) ?'
"/                                  position:posR1 to:posR2-1
"/                ].
"/            ].
"/        ].
"/

    self isSyntaxHighlighter ifTrue:[
        "/ look for true ifTrue / false ifFalse and mark as comment
        self markUnreachableCodeAsCommentIn:expr.
    ].

    ^ self messageNodeRewriteHookFor:expr.

    "Modified: / 19-01-2012 / 10:44:42 / cg"
    "Modified: / 27-08-2013 / 10:43:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

literalInlineObjectFor:namesAndValues
    |class instance names values inlineObjectsAreReadonly|

    inlineObjectsAreReadonly := true.

    names := namesAndValues collect:[:each | each key].
    values := namesAndValues collect:[:each | each value].

    class := InlineObjectClassDescription new.
    class setSuperclass: InlineObject.
    class setInstanceVariableString:(names asStringWith:Character space).
    class instSize: names size.

    names keysAndValuesDo:[:idx :instVarName |
        |m|

        idx <= InlineObjectPrototype instSize ifTrue:[
            class basicAddSelector:(instVarName asSymbol) withMethod:(m := InlineObjectPrototype compiledMethodAt:('i%1' bindWith:idx) asSymbol).
            inlineObjectsAreReadonly ifFalse:[
                class basicAddSelector:(instVarName asMutator) withMethod:(m := InlineObjectPrototype compiledMethodAt:('i%1:' bindWith:idx) asSymbol).
            ].
        ] ifFalse:[
            Class withoutUpdatingChangesDo:[
                Compiler compile:('%1 ^%1' bindWith:instVarName) forClass:class.
                inlineObjectsAreReadonly ifFalse:[
                    Compiler compile:('%1:something %1 := something' bindWith:instVarName) forClass:class.
                ].
            ].
        ].
    ].

    instance := class new.
    1 to:names size do:[:idx | instance instVarAt:idx put:(values at:idx) ].
    ^ instance
!

primary
    "parse a primary-expression; return a node-tree, nil or #Error.
     This also cares for namespace-access-paths."

    |val pos node eMsg endPos|

    (tokenType == #Self) ifTrue:[
        ^ self primary_self.
    ].

    pos := tokenPosition.
    (tokenType == #Identifier) ifTrue:[
        "
         must check for variable first, to be backward compatible
         with other smalltalks.
        "
        tokenName = 'here' ifTrue:[
            (self variableOrError:tokenName) == #Error ifTrue:[
                self warnSTXHereExtensionUsedAt:pos.
                tokenType := #Here.
                ^ self primary_here.
            ]
        ].
        node := self primary_identifier.
        node isVariable ifTrue:[
            ^ self variableReadRewriteHookFor:node
        ].
        ^ node.
    ].

    ((tokenType == #Integer)
     or:[(tokenType == #String)
     or:[(tokenType == #Character)
     or:[(tokenType == #Float)
     or:[(tokenType == #Symbol)
     or:[(tokenType == #ESSymbol)]]]]]) ifTrue:[
        ^ self primary_simpleLiteral.
    ].

    (tokenType == #FixedPoint) ifTrue:[
        parserFlags allowFixedPointLiterals == true ifFalse:[
            self isSyntaxHighlighter ifFalse:[
                self parseError:'non-Standard literal: FixedPoint. Please enable in settings.' position:pos to:pos+2.
                ^ #Error
            ].
            self warning:'non-Standard literal: FixedPoint.'
        ].
        ^ self primary_simpleLiteral.
    ].
    (tokenType == #Nil) ifTrue:[
        ^ self primary_nil.
    ].
    (tokenType == #True) ifTrue:[
        ^ self primary_true
    ].
    (tokenType == #False) ifTrue:[
        ^ self primary_false
    ].
    (tokenType  == #Super) ifTrue:[
        ^ self primary_super.
    ].

    (tokenType == #ThisContext) ifTrue:[
        ^ self primary_thisContext
    ].

    (tokenType == #HashLeftParen) ifTrue:[
        self inArrayLiteral:true.
        self nextToken.
        [
            val := self array.
        ] ensure:[
            self inArrayLiteral:false.
        ].
        self nextToken.
        (self noAssignmentAllowed:'Assignment to a constant' at:pos) ifFalse:[
            ^ #Error
        ].
        ^ ConstantNode type:#Array value:val from: pos to: tokenLastEndPosition.
    ].

    (tokenType == #HashLeftBrack) ifTrue:[
        self nextToken.
        val := self byteArray.
        self nextToken.
        (self noAssignmentAllowed:'Assignment to a constant' at:pos) ifFalse:[
            ^ #Error
        ].
        ^ ConstantNode type:#ByteArray value:val from: pos to: tokenLastEndPosition.
    ].

    parserFlags allowSTXExtendedArrayLiterals ifTrue:[
        (tokenType == #HashTypedArrayParen) ifTrue:[
            |arrayType|
            
            arrayType := tokenValue.
            self inArrayLiteral:true.
            self nextToken.
            [
                val := self typedArray:arrayType.
            ] ensure:[
                self inArrayLiteral:false.
            ].
            self nextToken.
            (self noAssignmentAllowed:'Assignment to a constant' at:pos) ifFalse:[
                ^ #Error
            ].
            ^ ConstantNode type:#Array value:val from: pos to: tokenLastEndPosition.
        ].
    ].

    (tokenType == #HashLeftBrace) ifTrue:[
        val := self qualifiedNameOrInlineObject.
        ^ val.
    ].

    (tokenType == $() ifTrue:[
        parenthesisLevel := parenthesisLevel + 1.
        self markParenthesisAt:tokenPosition.
        ^ self primary_expression.
    ].

    (tokenType == $[ ) ifTrue:[
        self markBracketAt:tokenPosition.
        val := self block.
        self nextToken.
        (self noAssignmentAllowed:'invalid assignment' at:pos) ifFalse:[
            ^ #Error
        ].
        ^ val
    ].

    "/ EXPERIMENTAL - may be in next release
    parserFlags allowVariableReferences == true ifTrue:[
        ((tokenType == #BinaryOperator) and:[token = '&']) ifTrue:[
            self nextToken.
            node := self primary_identifier.
            "/ generate a Reference
            ^ self makeReferenceFor:node
        ].
    ].

    (tokenType == ${ ) ifTrue:[
        parserFlags allowSqueakExtensions == true ifFalse:[
            didWarnAboutSqueakExtensions ~~ true ifTrue:[
                didWarnAboutSqueakExtensions := true.
                "/ self parseError:'non-Standard Squeak extension: Brace Computed Array. Enable in settings.' position:pos to:tokenPosition.
                self
                    warning:('non-Standard Squeak extension: Brace Computed Array. Enable in settings.')
                    doNotShowAgainAction:[ ParserFlags allowSqueakExtensions:true ]
                    position:pos to:tokenPosition.

                "/ errorFlag := false.
            ].
        ].
        ^ self primary_squeakComputedArray.
    ].

    (tokenType == #Primitive) ifTrue:[
        node := PrimitiveNode code:tokenValue.
        node startPosition: tokenPosition endPosition: source position + 1.
        self nextToken.
        hasNonOptionalPrimitiveCode := true.
        hasPrimitiveCode := true.
        ^ node
    ].

    tokenType == #HashHashLeftParen ifTrue:[
        self nextToken.
        parserFlags allowDolphinExtensions == true ifFalse:[
            self parseError:'non-Standard Dolphin extension: ##(..). Enable in settings.' position:pos to:tokenPosition.
            ^ #Error
        ].
        ^ self primary_dolphinComputedLiteral.
    ].
    tokenType == #ExclaLeftBrack ifTrue:[
        self nextToken.
        parserFlags allowLazyValueExtension == true ifFalse:[
            self parseError:'non-Standard LazyValue extension. Enable in classVariable.' position:pos to:tokenPosition.
            ^ #Error
        ].
        ^ self primary_lazyValue.
    ].
    tokenType == #HashHash ifTrue:[
        self warnPossibleIncompatibility:'''##'' might be interpreted differently in other smalltalk systems' position:pos to:tokenPosition.
        tokenType := #Symbol.
        token := tokenValue := tokenName := '#'.
        ^ self primary_simpleLiteral.
    ].

    parserFlags allowSqueakExtensions == true ifTrue:[
        "allow # (element...) - i.e. with a separator inbetween"
        ((tokenType == #BinaryOperator) and:[token = '#']) ifTrue:[
            self nextToken.
            (tokenType == $( ) ifFalse:[
                self parseError:'''('' expected after #.' position:pos to:tokenPosition.
                ^ #Error.
            ].
            self nextToken.
            self inArrayLiteral:true.
            "/ old
"/            ParseError handle:[:ex |
"/                self inArrayLiteral:false.
"/                ^ #Error
"/            ] do:[
"/                val := self array.
"/            ].
"/            self inArrayLiteral:false.
            "/ new
            [
                val := self array.
            ] ensure:[
                self inArrayLiteral:false.
            ].

            self nextToken.
            (self noAssignmentAllowed:'Assignment to a constant' at:pos) ifFalse:[
                ^ #Error
            ].
            ^ ConstantNode type:#Array value:val from: pos to: tokenLastEndPosition.
        ].
    ].

    ((tokenType == #BinaryOperator) and:[token = '-']) ifTrue:[
        "/ this is a bad hack, because the scanner does not know
        "/ if -1 is to be scanned as a negative number
        "/ (for example, in: 'a-1' it has to be scanned as a binop)
        "/ So the scanner always gives us a binop-"-".
        "/ The hack code below deals with that.

        "/ But make sure, there is no whitespace in between, so we do not scan "foo := - 2"
        "/ as a negative 2.
        |endPos1|

        endPos1 := source position.
        self nextToken.
        ((tokenType == #Integer) or:[(tokenType == #Float)]) ifFalse:[
            self parseError:'number expected after sign.' position:pos to:tokenPosition.
            ^ #Error.
        ].
        tokenPosition = (endPos1+1) ifFalse:[
            self isSyntaxHighlighter ifFalse:[
                parserFlags allowPossibleSTCCompilationProblems ifFalse:[
                    self parseError:'Space between sign and number; this will not compile with stc' position:pos to:tokenPosition.
                    "/ errorFlag := false.
                ].
                ((parserFlags allowSqueakExtensions not)
                    and:[parserFlags allowSTVExtensions not]) ifTrue:[
                    self parseError:'non-Standard Squeak (or ST/V) extension: space between sign and number. Enable in Settings' position:pos to:tokenPosition.
                    "/ errorFlag := false.
                ].
            ].
            self warning:'Space between sign and number is not allowed in stc (and some other smalltalk systems)' position:endPos1 to:tokenPosition.
        ].

        node := self primary_simpleLiteral.
        node isConstant ifFalse:[
            self parseError:'number expected after sign.' position:pos to:tokenPosition.
            ^ #Error.
        ].
        ^ ConstantNode type:(node type) value:(node value negated) from: node startPosition to: node endPosition.
    ].

    (tokenType == #Error) ifTrue:[^ #Error].
    tokenType isCharacter ifTrue:[
        eMsg := '"',tokenType printString,'" unexpected in primary.'.
        endPos := tokenPosition.
    ] ifFalse:[
        (#(BinaryOperator Keyword) includes:tokenType) ifTrue:[
            eMsg := tokenType printString,' ("' , tokenName , '") ',' unexpected in primary. (missing receiver ?)'
        ] ifFalse:[
            (#(Integer Float) includes:tokenType) ifTrue:[
                eMsg := tokenType printString,' (' , tokenValue , ') ',' unexpected in primary. (missing receiver ?)'
            ] ifFalse:[
                eMsg := '"',(token ? ''),'" (',tokenType printString,') unexpected in primary.'
            ]
        ].
        endPos :=source position.
    ].
    self syntaxError:eMsg position:tokenPosition to:endPos.
    ^ #Error

    "Created: / 13-09-1995 / 12:50:50 / claus"
    "Modified: / 01-08-2011 / 12:04:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 11:35:46 / cg"
!

primary_dolphinComputedLiteral
    "parse a dolphin computed literal; return a node-tree, or raise an Error.
     In dolphin, these are written as: ##( expression )
     and create a literal constant for the expressions value.
     Right now, only a subset is supported - Strings, ByteArrays and Characters.
     WARNING: this is only supported to allow file-in of dolphin code.
     Since stc cannot handle this (at the moment), you should rewrite the code
     if you ever plan to stc-compile it into a shared library.
     The question is still: how should stc ever be able to do this, as it cannot execute
     smalltalk code; it could generate code to execute it at initialization time of the
     generated code, but then, it is no longer a compile-time constant
     (for example, generating a compilation-Date constant is then not possible...)"

    |pos pos2 expr val|

    pos := tokenPosition.

    expr := self expression.

    tokenType ~~ $) ifTrue:[
        self parseError:''')'' expected' position:tokenPosition.
        ^ #Error
    ].
    pos2 := tokenPosition.
    self nextToken.

    (self noAssignmentAllowed:'Invalid assignment to a computed constant' at:pos) ifFalse:[
        ^ #Error
    ].

    val := expr evaluate.

    val isLiteral ifTrue:[
        val isString ifTrue:[
            ^ ConstantNode type:#String value:val from: pos to: pos2
        ].
        val isByteArray ifTrue:[
            ^ ConstantNode type:#ByteArray value:val from: pos to: pos2
        ].
        val isCharacter ifTrue:[
            ^ ConstantNode type:#Character value:val from: pos to: pos2
        ].
        val isInteger ifTrue:[
            ^ ConstantNode type:#Integer value:val from: pos to: pos2
        ].
        val isLimitedPrecisionReal ifTrue:[
            ^ ConstantNode type:#Float value:val from: pos to: pos2
        ].
        val isArray ifTrue:[
            ^ ConstantNode type:#Array value:val from: pos to: pos2
        ].
    ] ifFalse:[
        self parseError:'must be representable as a literal (for now)' position:pos.
        ^ #Error
    ].

    self shouldImplement.

    "
     ParserFlags allowDolphinExtensions:true.
     Parser evaluate:' ##( 5 * 7) '.x
     ParserFlags allowDolphinExtensions:false.
    "

"/    "/ make it an array creation expression ...
"/    expr := MessageNode
"/            receiver:(VariableNode globalNamed:#Array)
"/            selector:#new:
"/            arg:(ConstantNode type:#Integer value:(exprList size)).
"/
"/    exprList size == 0 ifTrue:[
"/        ^ expr.
"/    ].
"/    exprList keysAndValuesDo:[:idx :e |
"/        expr := (idx == 1 ifTrue:[MessageNode] ifFalse:[CascadeNode])
"/                    receiver:expr
"/                    selector:#at:put:
"/                    arg1:(ConstantNode type:#Integer value:idx)
"/                    arg2:e
"/                    fold:false.
"/    ].
"/    expr := CascadeNode
"/                receiver:expr
"/                selector:#yourself.
"/    ^ expr

    "Modified: / 27-07-2011 / 15:50:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 11:36:07 / cg"
!

primary_expression
    "parse a parentized expression primary; return a node-tree, or raise an Error."

    |pos val eMsg|

    pos := tokenPosition.

    self nextToken.
    val := self expression.
    (val == #Error) ifTrue:[^ #Error].
    (tokenType == $) ) ifFalse:[
        tokenType isCharacter ifTrue:[
            eMsg := 'missing '')'' (i.e. ''' , tokenType asString , ''' unexpected)'.
        ] ifFalse:[
            eMsg := 'missing '')'''.
        ].
        self syntaxError:eMsg withCRs position:pos to:tokenPosition.
        ^ #Error
    ].
    self markParenthesisAt:tokenPosition.
    parenthesisLevel := parenthesisLevel - 1.
    self nextToken.
    (self noAssignmentAllowed:'Invalid assignment to an expression' at:pos) ifFalse:[
        ^ #Error
    ].
    val parenthesized:true.
    ^ val

    "Modified: / 26-07-2012 / 11:36:42 / cg"
!

primary_false
    "parse a false primary; return a node-tree, or raise an Error."

    |pos|

    pos := tokenPosition.

    self nextToken.
    (self noAssignmentAllowed:'Assignment to ''false'' would break Smalltalk' at:pos) ifFalse:[
        ^ #Error
    ].
    self markBooleanConstantFrom:pos to:pos+4.
    ^ ConstantNode type:#False value:false from: pos to: pos + 4

    "Modified: / 19-07-2011 / 17:50:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 11:37:22 / cg"
!

primary_here
    "parse a here primary; return a node-tree, nil or #Error."

    |pos|

    pos := tokenPosition.

    self nextToken.
    (self noAssignmentAllowed:'Assignment to pseudo variable ''here''' at:pos) ifFalse:[
        ^ #Error
    ].
    classToCompileFor isNil ifTrue:[
        self warning:'in which class are you ?' position:pos to:(pos + 3).
    ].
    self markSelfFrom:pos to:pos+3.
    ^ (SuperNode value:selfValue inClass:classToCompileFor here:true)
        startPosition: pos endPosition: pos + 3;
        yourself

    "Modified: / 19-07-2011 / 17:51:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 11:36:53 / cg"
!

primary_identifier
    "parse a primary starting with an identifier: either a variable or an assignment.
     return a node-tree, or raise an Error."

    |pos1 pos2 expr varName rawName var globlName nameSpace nameSpaceGlobal
     t cls lnr node holder assignmentAllowed|

    pos1 := tokenPosition.
    pos2 := tokenPosition + tokenName size - 1.

    varName := tokenName.

    autoDefineVariables isNil ifTrue:[
        autoDefineVariables := false.
        requestor notNil ifTrue:[
            autoDefineVariables := (requestor perform:#autoDefineVariables ifNotUnderstood:false) ? false.
        ]
    ].
    autoDefineVariables ~~ false ifTrue:[
        var := self variableOrError:varName.
        self nextToken.

        (var == #Error) ifTrue:[
            ((tokenType == $_) or:[tokenType == #':=']) ifTrue:[
                autoDefineVariables == #doIt ifTrue:[
                    "/ as doIt var (only within this expression)
                    holder := self addDoItTemporary:varName.
                    var := VariableNode type:#DoItTemporary holder:holder name:varName.
                ] ifFalse:[
                    autoDefineVariables == #workspace ifTrue:[
                        "/ as workspace var (only within doIts)
                        holder := Workspace addWorkspaceVariable:varName.
                        var := VariableNode type:#WorkspaceVariable holder:holder name:varName.
                    ].
                ].
            ] ifFalse:[
                var := self correctVariable:varName atPosition:pos1 to:pos2.
            ].
            var startPosition: pos1 endPosition: pos2.
        ]
    ] ifFalse:[
        var := self variable.
        self nextToken.
    ].

"/    "/ errorFlag == true ifTrue:[self halt].
"/    (var == #Error) ifTrue:[
"/        errorFlag := true
"/    ].

    (tokenType == #'::') ifTrue:[
        globlName := rawName := varName.

        "is it in a namespace ?"
        nameSpace := self findNameSpaceWith:globlName.
        nameSpace notNil ifTrue:[
            globlName := nameSpace name , '::' , globlName
        ].

        [tokenType == #'::'] whileTrue:[
            nameSpace := globlName.

            self nextToken.
            (tokenType == #Identifier) ifTrue:[
                self warnSTXNameSpaceUseAt:pos1.
                varName := tokenName.

                globlName := (nameSpace , '::' , varName).
                rawName := (rawName , '::' , varName).

                nameSpaceGlobal := Smalltalk at:nameSpace asSymbol ifAbsent:nil.
                nameSpaceGlobal isNil ifTrue:[
                    warnedUnknownNamespaces isNil ifTrue:[
                        warnedUnknownNamespaces := Set new.
                    ].
                    (warnedUnknownNamespaces includes:nameSpace) ifFalse:[
"/ not needed; already warned.
"/                        "correctIt :=" requestor
"/                                        correctableError:('Unknown nameSpace: "', nameSpace,'"')
"/                                        position:pos1 to:tokenPosition-1 from:self.

"/                        self warning:('unknown nameSpace: ', nameSpace)
"/                             position:pos1 to:tokenPosition-1.
"/                            self parseError:('unknown nameSpace: ', nameSpace) position:pos to:tokenPosition-1.
                        warnedUnknownNamespaces add:nameSpace.
                    ]
                ] ifFalse:[
                    nameSpaceGlobal isNameSpace ifTrue:[
                        "/ for now: only Smalltalk is allowed
                        nameSpaceGlobal ~~ Smalltalk ifTrue:[
"/                                self parseError:('(currently) the only valid nameSpace is `Smalltalk''') position:pos to:tokenPosition-1.
                        ] ifFalse:[
                            globlName := varName
                        ].
                    ] ifFalse:[
                        nameSpaceGlobal isBehavior ifFalse:[
                            self parseError:('invalid nameSpace: ' , nameSpace)  position:pos1 to:tokenPosition-1.
                        ] ifTrue:[
                            nameSpaceGlobal isLoaded ifFalse:[
                                "/ check, if the namespace is something autoloaded.
                                "/ because then, the private name may appear
                                nameSpaceGlobal autoload.
                            ].
                            nameSpaceGlobal isLoaded ifTrue:[
                                (nameSpaceGlobal privateClassesAt:varName asSymbol) isNil ifTrue:[
                                    rawName := rawName asSymbol.
                                    (Smalltalk at:rawName) notNil ifTrue:[
                                        (self isFirstWarning:(#globalVsPrivateClass -> rawName)) ifTrue:[
                                            self warning:('Possible name clash (global: ' , rawName , ' vs. private: ' , (nameSpace , '::', varName) , ') - assume global.')
                                                 position:pos1 to:source position "tokenPosition-1".
                                        ].
                                        globlName := rawName.
                                    ] ifFalse:[
                                        (self isFirstWarning:(#noPrivateClass -> (nameSpace , '::', varName))) ifTrue:[
                                            self warning:('no private class: ' , varName allBold , ' in class: ' , nameSpace)
                                                 position:pos1 to:source position "tokenPosition-1".
                                        ]
"/                                        self parseError:('no private class: ' , name , ' in class: ' , nameSpace)  position:pos to:tokenPosition-1.
                                    ]
                                ] ifFalse:[
                                    "/ reference to a private class
                                    (classToCompileFor notNil and:[nameSpaceGlobal ~~ classToCompileFor theNonMetaclass]) ifTrue:[
                                        self classToCompileFor notNil ifTrue:[
                                            self isDoIt ifFalse:[
                                                (parserFlags warnAboutReferenceToPrivateClass
                                                 and:[self isFirstWarning:(#noPrivateClass -> (nameSpace , '::', varName))]) ifTrue:[
                                                    self warning:('Referring to private class ''' , varName allBold , ''' here.')
                                                         doNotShowAgainAction:[ ParserFlags warnAboutReferenceToPrivateClass:false.
                                                                                parserFlags warnAboutReferenceToPrivateClass:false. ]
                                                         position:pos1 to:source position " tokenPosition-1".
                                                ].
                                                Tools::ToDoListBrowser notNil ifTrue:[
                                                    self
                                                        notifyTodo:('Referring to private class ''' , varName allBold , ''' here.') position:pos1
                                                        className:(self classToCompileFor name) selector:selector
                                                        severity:#warning priority:#medium
                                                        equalityParameter:nil
                                                        checkAction:nil.
                                                ].
                                            ].
                                        ].
                                    ]
                                ].
                            ]
                        ]
                    ].
                ].
                pos2 := source position.
                self nextToken.
            ].
            var := VariableNode globalNamed:globlName.
            var startPosition: pos1 endPosition: pos2.
            parseForCode ifFalse:[self rememberGlobalUsed:globlName].
        ].
        self markVariable:var from:pos1 to:pos1 + rawName size - 1 assigned:false.
    ].

    var == #Error ifTrue:[
        ^ #Error
    ].

"/    errorFlag ~~ true ifTrue:[
"/        self markVariable:var from:pos1 to:pos1 + varName size - 1.
"/    ].
"/    (ignoreErrors or:[parseForCode not and:[ignoreWarnings]]) ifTrue:[
"/        errorFlag := false.
"/    ].

    ((tokenType ~~ $_) and:[tokenType ~~ #':=']) ifTrue:[
        parseForCode ifFalse:[
            var isInstanceVariable ifTrue:[ self rememberInstVarRead:var name].
            var isClassVariable ifTrue:[ self rememberClassVarRead:var name].
            var isPoolVariable ifTrue:[ self rememberPoolVarRead:var name].
            var isGlobalVariable ifTrue:[ self rememberGlobalRead:var name].
        ].
        ^ var
    ].

    "/ assignment...

    (usedGlobals notNil and:[usedGlobals includes:(Smalltalk undeclaredPrefix,var name)]) ifFalse:[
        self markAssignedVariable:var from:pos1 to:pos1 + var name size - 1.
    ].

    "/ careful: it could already be an implicit self send
    parserFlags implicitSelfSends ifTrue:[
        var isMessage ifTrue:[
            self nextToken.
            expr := self expression.
"/            self isSyntaxHighlighter ifFalse:[
"/                (errorFlag or:[expr == #Error]) ifTrue:[^ #Error].
"/            ].
            ^ MessageNode receiver:(self selfNode) selector:('__' , varName) asMutator arg:expr.
        ].
    ].

    assignmentAllowed := true.

    (var ~~ #Error) ifTrue:[
        t := var type.
        t == #MethodVariable ifTrue:[
            self rememberLocalModified:var name.
        ] ifFalse:[ t == #BlockVariable ifTrue:[
            var block rememberLocalModified:var name.
        ] ifFalse:[ (t == #InstanceVariable) ifTrue:[
            varName := self classesInstVarNames at:(var index).

            classToCompileFor isMeta ifTrue:[
                "/ ca once assigned to "name" on the class side and wondered what happened to his class ...
                "/ (not really a beginners bug, but may happen as a typo or missing local variable;
                "/  and is hard to track down later)
                ignoreWarnings ifFalse:[
                    parserFlags warnings ifTrue:[
                        parserFlags warnCommonMistakes ifTrue:[
                            (classToCompileFor isSubclassOf:Class) ifTrue:[
                                (Class allInstVarNames includes:(var name)) ifTrue:[
                                    self warning:'assignment to a classInstanceVariable\(see hierarchy of "Class")' withCRs position:pos1 to:pos2.
                                ]
                            ]
                        ]
                    ].
                ].
            ].

            parseForCode ifFalse:[
                self rememberInstVarModified:varName
            ]
        ] ifFalse:[ (t == #ClassVariable) ifTrue:[
            varName := var name.
            varName := varName copyFrom:((varName indexOf:$:) + 1).
            parseForCode ifFalse:[
                self rememberClassVarModified:varName
            ]
        ] ifFalse:[ (t == #GlobalVariable) ifTrue:[
            (cls := Smalltalk classNamed:var name) notNil ifTrue:[
                cls name = var name ifTrue:[
                    self warning:'assignment to global which refers to a class' position:pos1 to:pos2.
                ]
            ].
            parseForCode ifFalse:[
                self rememberGlobalModified:var name
            ]
        ] ifFalse:[ (t == #PrivateClass) ifTrue:[
            assignmentAllowed := false.
            self parseError:'assignment to private class' position:pos1 to:pos2.
        ] ifFalse:[ (t == #MethodArg) ifTrue:[
            (assignmentAllowed := parserFlags allowAssignmentToMethodArgument) ifTrue:[
                parserFlags warnAssignmentToMethodArgument ifTrue:[
                    DoNotShowCompilerWarningAgainActionQuery handle:[:ex |
                        parserFlags warnAssignmentToMethodArgument:false.
                        parserFlags warnAssignmentToMethodArgument:false.
                        ex proceed.
                    ] do:[
                        self warning:'assignment to method argument.\\Not all Smalltalk dialects allow this.' withCRs position:pos1 to:pos2.
                    ]
                ]
            ] ifFalse:[
                DoNotShowCompilerWarningAgainActionQuery handle:[:ex |
                    parserFlags allowAssignmentToMethodArgument:true.
                    ParserFlags allowAssignmentToMethodArgument:true.
                    ex proceed.
                ] do:[
                    self parseError:'assignment to method argument.' withCRs position:pos1 to:pos2.
                    self clearErrorFlag. "ok, user wants it - so he'll get it"
                    assignmentAllowed := true.  "/ if proceeded
                ].
            ]
        ] ifFalse:[ (t == #BlockArg) ifTrue:[
            (assignmentAllowed := parserFlags allowAssignmentToBlockArgument) ifTrue:[
                parserFlags warnAssignmentToBlockArgument ifTrue:[
                    DoNotShowCompilerWarningAgainActionQuery handle:[:ex |
                        parserFlags warnAssignmentToBlockArgument:false.
                        parserFlags warnAssignmentToBlockArgument:false.
                        ex proceed.
                    ] do:[
                        self warning:'assignment to block argument.\\Not all Smalltalk dialects allow this.' withCRs position:pos1 to:pos2.
                    ]
                ].
            ] ifFalse:[
                DoNotShowCompilerWarningAgainActionQuery handle:[:ex |
                    parserFlags allowAssignmentToBlockArgument:true.
                    ParserFlags allowAssignmentToBlockArgument:true.
                    ex proceed.
                ] do:[
                    self parseError:'assignment to block argument.' position:pos1 to:pos2.
                ]
            ].
            self clearErrorFlag. "ok, user wants it - so he'll get it"
            assignmentAllowed := true.  "/ if proceeded
        ] ifFalse:[ (t == #PoolVariable) ifTrue:[
            self isDoIt ifTrue:[
                self warning:'assignment to pool variable.\\Not all Smalltalk dialects allow this.' withCRs position:pos1 to:pos2.
                assignmentAllowed := true.
            ] ifFalse:[
                (assignmentAllowed := parserFlags allowAssignmentToPoolVariable) ifTrue:[
                    parserFlags warnAssignmentToPoolVariable ifTrue:[
                        DoNotShowCompilerWarningAgainActionQuery handle:[:ex |
                            parserFlags warnAssignmentToPoolVariable:false.
                            ParserFlags warnAssignmentToPoolVariable:false.
                            ex proceed.
                        ] do:[
                            self warning:'assignment to pool variable.\\Not all Smalltalk dialects allow this.' withCRs position:pos1 to:pos2.
                        ]
                    ]
                ] ifFalse:[
                    DoNotShowCompilerWarningAgainActionQuery handle:[:ex |
                        parserFlags allowAssignmentToPoolVariable:true.
                        ParserFlags allowAssignmentToPoolVariable:true.
                        ex proceed.
                    ] do:[
                        self parseError:'assignment to pool variable' position:pos1 to:pos2.
                    ].
                    self clearErrorFlag. "ok, user wants it - so he'll get it"
                    assignmentAllowed := true. "/ if proceeded
                    parseForCode ifFalse:[
                        self rememberPoolVarModified:var name
                    ]
                ].
            ]]]]]]]]]
        ].
    ].

    lnr := tokenLineNr.

    self nextToken.
    pos2 := tokenPosition.
    expr := self expression.

    "/ a typical beginner error:
    "/   expr ifTrue:[
    "/      var := super
    "/   ] ifFalse:[
    "/      var := something-else
    "/   ].
    "/   var messageSend
    "/
    "/   does not what a beginner might think.

    self isSyntaxHighlighter ifTrue:[
"/        (expr == #Error) ifTrue:[^ #Error].
    ] ifFalse:[
"/        (errorFlag or:[expr == #Error]) ifTrue:[^ #Error].

        (ignoreWarnings not and:[ parserFlags warnings ]) ifTrue:[
            parserFlags warnCommonMistakes ifTrue:[
                (expr ~~ #Error and:[expr isSuper]) ifTrue:[
                    self warning:'followup messageSends to "' , var name , '" will have normal send semantics\(i.e. NO super- or here-sends). Use self to avoid confusion.' withCRs position:pos1 to:pos2.
                ].
            ].
            (expr ~~ #Error) ifTrue:[
                expr isVariable ifTrue:[
                    expr name = var name ifTrue:[
                        self warning:('useless assignment to "' , var name, '"' ) position:pos1 to:pos2-1.
                    ].
                ].
            ].
        ].
    ].
    assignmentAllowed ifTrue:[
        node := AssignmentNode variable:var expression:expr.
        parserFlags fullLineNumberInfo ifTrue:[node lineNumber:lnr].
        node := self assignmentRewriteHookFor:node.
    ] ifFalse:[
        self parseError:('assignment to "' , var name, '" suppressed' ) position:pos1 to:pos2-1.
        node := expr.
    ].
    ^ node

    "Modified: / 20-08-2011 / 23:32:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-10-2011 / 15:36:55 / az"
    "Modified: / 26-09-2012 / 14:15:23 / cg"
    "Modified: / 04-07-2017 / 10:21:06 / mawalch"
!

primary_lazyValue
    |pos blockNode expr|

    pos := tokenPosition.

    (tokenType == $: ) ifTrue:[
        self parseError:'lazyValues have no arguments' position:tokenPosition.
        ^ #Error
    ].

    blockNode := BlockNode home:currentBlock.
    blockNode lineNumber:tokenLineNr.
    currentBlock := blockNode.

    self blockBody.
    self nextToken.

    currentBlock := blockNode home.

    expr := MessageNode
                receiver:(VariableNode globalNamed:#LazyValue)
                selector:#'block:'
                arg:blockNode.
    ^ expr
!

primary_nil
    "parse a nil primary; return a node-tree, nil or #Error."

    |pos|

    pos := tokenPosition.

    self nextToken.
    (self noAssignmentAllowed:'Assignment to ''nil'' would break Smalltalk' at:pos) ifFalse:[
        ^ #Error
    ].
"/        self markConstantFrom:pos to:pos+2.
"/  JV@2011-07-19: Changed not to share the nodes

    ^ConstantNode type:#Nil value:nil from: pos to: pos + 2

"/  Old code
"/  nilNode isNil ifTrue:[
"/      nilNode := ConstantNode type:#Nil value:nil
"/  ].
"/  ^ nilNode

    "Modified: / 19-07-2011 / 18:06:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 11:37:32 / cg"
!

primary_self
    "parse a self primary; return a node-tree, nil or #Error."

    |pos|

    pos := tokenPosition.

    self nextToken.
    (self noAssignmentAllowed:'Assignment to pseudo variable ''self''' at:pos) ifFalse:[
        ^ #Error
    ].
    self markSelfFrom:pos to:pos+3.
    ^ self selfNode startPosition: pos endPosition: pos + 3

    "Modified (format): / 19-07-2011 / 18:09:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 11:37:40 / cg"
!

primary_simpleLiteral
    "parse a simple literal primary; return a node-tree, or raise an Error."

    |pos pos2 val|

    pos := tokenPosition.
    pos2 := source position.

    tokenType == #String ifTrue:[
        tokenValue = '' ifTrue:[
            "use only a single instance of an empty string,
             which is always immutable (per definition)"
            token := tokenValue := ''.
        ] ifFalse:[
            "/
            "/ ImmutableStrings are experimental
            "/
            parserFlags stringsAreImmutable ifTrue:[
                token := tokenValue := self makeImmutableString:tokenValue.
            ].
        ].
    ].

    ((tokenType == #Symbol) or:[tokenType == #ESSymbol]) ifTrue:[
        parseForCode ifFalse:[
            self rememberSymbolUsed:tokenValue
        ].
    ].
    val := ConstantNode type: tokenType value:tokenValue
                        from: pos to: pos2.

    ((tokenType == #Symbol) or:[tokenType == #ESSymbol]) ifTrue:[
        self markSymbolFrom:tokenPosition to:tokenPosition+tokenValue size-1.
    ] ifFalse:[
        tokenType == #String ifTrue:[
            self markStringFrom:pos to:source position.
        ] ifFalse:[
            self markConstantFrom:pos to:source position.
        ].
    ].

    self nextToken.
    (self noAssignmentAllowed:'Assignment to a constant' at:pos) ifFalse:[
        ^ #Error
    ].
    ^ val

    "Modified: / 21-08-2011 / 08:10:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 11:37:44 / cg"
!

primary_squeakComputedArray
    "parse a squeak computed array literal; return a node-tree, or raise an Error.
     In squeak, these are written as: { expr1 . expr2 . ... exprN )
     and create a message to construct an Array containing the exprI values"

    |pos pos2 exprList|

    pos := tokenPosition.

    self nextToken.
    exprList := self squeakComputedArray.
    (exprList == #Error) ifTrue:[ ^ #Error ].

    tokenType ~~ $} ifTrue:[
        self parseError:'"." or "}" expected in computed array expression' position:tokenPosition.
        ^ #Error
    ].
    pos2 := tokenPosition.
    self nextToken.
    (self noAssignmentAllowed:'Invalid assignment' at:pos) ifFalse:[
        ^ #Error
    ].

    "/ make it an array creation expression ...
    ^ (self genMakeArrayWith:exprList)
        startPosition: pos
          endPosition: pos2

    "
     Compiler allowSqueakExtensions:true.
    "

    "
     { 1@2. 10 factorial. Date today }.
    "

    "
     Compiler allowSqueakExtensions:false.
    "

    "Modified: / 27-07-2011 / 15:56:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-08-2012 / 13:20:58 / cg"
!

primary_super
    "parse a super primary; return a node-tree, nil or #Error."

    |pos|

    pos := tokenPosition.

    usesSuper := true.
    self nextToken.
    (self noAssignmentAllowed:'Assignment to pseudo variable ''super''' at:pos) ifFalse:[
        ^ #Error
    ].
    (classToCompileFor isNil or:[classToCompileFor superclass isNil]) ifTrue:[
        self warning:'superclass is (currently ?) nil' position:pos to:(pos + 4).
    ].
"/  JV@2011-07-19: Changed not to share the nodes
"/    superNode isNil ifTrue:[
"/        superNode := SuperNode value:selfValue inClass:classToCompileFor
"/    ].
    self markSuperFrom:pos to:pos+4.

"/  JV@2011-07-19: Changed not to share the nodes
"/    ^ superNode
    ^ (SuperNode value:selfValue inClass:classToCompileFor)
            startPosition: pos endPosition: pos + 4

    "Modified: / 26-07-2012 / 11:37:58 / cg"
    "Modified: / 25-02-2014 / 22:00:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primary_thisContext
    "parse a thisContext primary; return a node-tree, or raise an Error."

    |pos|

    pos := tokenPosition.

    self nextToken.
    (self noAssignmentAllowed:'Assignment to pseudo variable ''thisContext''' at:pos) ifFalse:[
        ^ #Error
    ].
    self markThisContextFrom:pos to:pos+10.
    ^ (VariableNode type:#ThisContext context:contextToEvaluateIn "often nil")
        startPosition: pos endPosition: pos + 10

    "Modified: / 26-07-2012 / 11:38:01 / cg"
    "Modified: / 20-12-2017 / 21:58:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primary_true
    "parse a true primary; return a node-tree, or raise an Error."

    |pos|

    pos := tokenPosition.

    self nextToken.
    (self noAssignmentAllowed:'Assignment to ''true'' would break Smalltalk' at:pos) ifFalse:[
        ^ #Error
    ].
    self markBooleanConstantFrom:pos to:pos+3.
    ^ ConstantNode type:#True value:true from:pos to:pos+3

    "Modified: / 19-07-2011 / 18:14:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 11:38:11 / cg"
!

qualifiedNameFrom:pos1
    "a vw3.x (and later) feature: QualifiedName is #{ id ... id }
     and mapped to a global variable here.
     The initial #{ is supposed to be skipped and its position passed in as pos1."

    |elements elem nm|

    elements := OrderedCollection new.
    [ tokenType ~~ $} ] whileTrue:[
        (tokenType == #EOF) ifTrue:[
            self syntaxError:'Bad qualifiedName; Identifier expected'
                    position:pos1 to:tokenPosition
        ].
        (tokenType == #Identifier) ifFalse:[
            self syntaxError:'Bad qualifiedName; Identifier expected'
                    position:pos1 to:tokenPosition
        ].
        elem := tokenName.
        elements add:elem.

        self nextToken.
        tokenType == $} ifTrue:[
        ] ifFalse:[
            tokenType == #'::' ifTrue:[
                "/ notice that Foo.Bar has already been scanned as Foo::Bar
                "/ (which is a kludge)
                self nextToken.
            ] ifFalse:[
                self syntaxError:'bad qualifiedName syntax; ''.'' or ''}'' expected (got ',tokenType,')'
                        position:pos1 to:tokenPosition.
            ].
        ].

"/        elem := self variable.
"/        (elem == #Error) ifTrue:[
"/            (tokenType == #EOF) ifTrue:[
"/                self syntaxError:'unterminated qualifiedName; ''}'' expected'
"/                        position:pos1 to:tokenPosition
"/            ].
"/            ^ #Error
"/        ].
"/        errorFlag := false.
"/        (elem isVariable and:[elem isGlobal]) ifFalse:[
"/            self warning:'elements of a qualifiedName should be globalIdentifiers'
"/                    position:pos1 to:tokenPosition
"/        ].
"/        elements add:elem.
"/
"/        self nextToken.
"/        tokenType == #'::' ifTrue:[
"/            "/ notice that Foo.Bar has already been scanned as Foo::Bar
"/            "/(which is a kludge)
"/            self nextToken.
"/        ] ifFalse:[
"/            tokenType ~~ $} ifTrue:[
"/                self syntaxError:'bad qualifiedName syntax; ''.'' or ''}'' expected'
"/                        position:pos1 to:tokenPosition.
"/                ^ #Error
"/            ].
"/        ].
    ].

    self nextToken.

    parserFlags flattenVisualWorksNamespaces ifTrue:[
        elements size > 1 ifTrue:[
            "/ temporary kludge when loading VW UIBuilder code...
            ( #('UI' 'Core' 'Graphics') includes:elements first) ifTrue:[
                elements := elements copyFrom:2.
            ]
        ].
    ].

    nm := (elements asStringWith:'::') asSymbol.
    ^ ConstantNode type:#Symbol value:nm

"/    elements size > 1 ifTrue:[
"/        self syntaxError:'Sorry: qualified names are not yet implemented.'.
"/    ].
"/    ^ elements first.

    "Modified: / 14.4.1998 / 17:03:29 / cg"
!

qualifiedNameOrInlineObject
    "either a vw3.x (and later) QualifiedName #{ id ... id }
     or an ST/X experimental inline object #{ name: value. ... name: value }
     The initial #{ is skipped here, but the position passed down."

    |pos1|

    pos1 := tokenPosition.
    self nextToken.

    (tokenType == #Keyword) ifTrue:[
        ^ self inlineObjectFrom:pos1.
    ].
    parserFlags allowQualifiedNames == true ifFalse:[
        self parseError:'non-Standard VisualWorks extension: #{..}. Please enable in settings.' position:pos1 to:tokenPosition.
    ].
    ^ self qualifiedNameFrom:pos1
!

squeakComputedArray
    |expressions elem pos1|

    tokenType == $} ifTrue:[
        ^ #()
    ].

    pos1 := tokenPosition.
    expressions := OrderedCollection new:20.
    [
        elem := self expression.
        (elem == #Error) ifTrue:[
            (tokenType == #EOF) ifTrue:[
                self syntaxError:'unterminated computed-array-element; ''}'' expected'
                        position:pos1 to:tokenPosition
            ].
            ^ #Error
        ].
        expressions add:elem.
        tokenType == $. ifFalse:[
            ^ expressions
        ].
        self nextToken.
        tokenType == $} ifTrue:[
            ^ expressions
        ].
    ] loop.
    "/ not reached
!

typedArray:typeSymbol
    "parse a typed array's elements.
     This is an ST/X extension, which is not supported by other Smalltalk implementations.
     For now, the support is disabled; enable with:
        ParserFlags allowSTXExtendedArrayLiterals:true
     Typed literal arrays are written in scheme-style as:
        #u8( element... )   - unsigned 8-bit bytes (i.e. a regular ByteArray)
        #u16( element... )  - unsigned 16-bit shorts (i.e. a WordArray)
        #u32( element... )  - unsigned 32-bit ints (i.e. an IntegerArray)
        #u64( element... )  - unsigned 64-bit ints (i.e. a LongIntegerArray)
        #s8( element... )   - signed bytes (i.e. a SignedByteArray)
        #u16( element... )  - signed 16-bit shorts (i.e. a SignedWordArray)
        #u32( element... )  - signed 32-bit ints (i.e. a SignedIntegerArray)
        #u64( element... )  - signed 64-bit ints (i.e. a SignedLongIntegerArray)
        #f16( element... )  - tiny 16-bit floats (i.e. a HalfFloatArray)
        #f32( element... )  - short 32-bit floats (i.e. a FloatArray)
        #f64( element... )  - 64-bit doubles (i.e. a DoubleArray)

        #f( element... )    - same as f32(...)
        #d( element... )    - same as f64(...)
    "

    "literal bytearrays started with ST-80 R4 - byteArray constants are written as #[ ... ]"

    |idx containerType container elStream newArray elem pos1 pos2|

    idx := #( #u1 #u8 #u16 #u32 #u64
              #s8 #s16 #s32 #s64
              #f16 #f32 #f64
              #f #d #b
              #B) indexOf:typeSymbol.
    idx == 0 ifTrue:[
        self parseError:'unsupported array type:',typeSymbol.
    ].
    containerType := #(
                            BitArray ByteArray WordArray IntegerArray LongIntegerArray
                            SignedByteArray SignedWordArray SignedIntegerArray SignedLongIntegerArray
                            HalfFloatArray FloatArray DoubleArray
                            FloatArray DoubleArray BitArray
                            BooleanArray
                     ) at:idx.
    pos1 := tokenPosition.
    container := (Smalltalk at:containerType) uninitializedNew:50.
    elStream := WriteStream on:container.
    [tokenType ~~ $) ] whileTrue:[
        pos2 := tokenPosition.
        "
         this is not good programming style, but speeds up
         reading of huge byte arrays (i.e. stored Images ...)
        "
        (tokenType == #Integer) ifTrue:[
            elem := tokenValue
        ] ifFalse:[
            (tokenType == #Float) ifTrue:[
                elem := tokenValue
            ] ifFalse:[
                elem := self arrayConstant.
                (elem == #Error) ifTrue:[
                    (tokenType == #EOF) ifTrue:[
                        self syntaxError:'unterminated ',typeSymbol,'-array (',containerType,') constant; '']'' expected'
                                position:pos1 to:tokenPosition
                    ].
                    ^ #Error
                ].
            ].
        ].
        (container isValidElement:elem) ifFalse:[
            self parseError:'element is not appropriate for #',typeSymbol,'-array (',containerType,')' position:pos2 to:tokenPosition.
            elem := container defaultElement.
        ] ifTrue:[
            (typeSymbol == #u8 and:[elem < 0]) ifTrue:[
                self parseError:'element is not appropriate for #',typeSymbol,'-array (',containerType,')' position:pos2 to:tokenPosition.
                elem := container defaultElement.
            ].
        ].
        elStream nextPut:elem.
        self nextToken.
    ].
    newArray := elStream contents.
"/    parserFlags arraysAreImmutable ifTrue:[
"/        ^ self class makeImmutable:newArray
"/    ].
    ^ newArray
!

unaryExpression
    "parse a unary-expression; return a node-tree, nil or #Error"

    |receiver|

    (parserFlags allowArrayIndexSyntaxExtension 
    or:[ parserFlags allowFunctionCallSyntaxForBlockEvaluation ]) ifFalse:[
        receiver := self primary
    ] ifTrue:[    
        receiver := self arrayIndexingExpression.
    ].
    (receiver == #Error) ifTrue:[^ #Error].
"/    (tokenType == #EOF) ifTrue:[^ receiver].
"/    tokenType == $] ifTrue:[^ receiver].
"/    tokenType == $) ifTrue:[^ receiver].
    (self isValidUnarySelector:tokenType) ifFalse:[
        ^ receiver
    ].    
    ^ self unaryExpressionFor:receiver

    "Modified: / 08-08-2017 / 17:02:26 / cg"
!

unaryExpressionFor:receiverArg
    "parse a unary-expression; return a node-tree, nil or #Error"

    |receiver expr sel pos pos2 lNr arguments|

    receiver := receiverArg.
    (receiver == #Error) ifTrue:[^ #Error].

    [ self isValidUnarySelector:tokenType ] whileTrue:[
        pos := tokenPosition.
        pos2 := pos + tokenName size - 1.
        lNr := tokenLineNr.
        sel := tokenName.

        self markSelector:sel from:pos to:pos2 receiverNode:receiver.

        self nextToken.
        tokenType == $( ifTrue:[
            parserFlags allowSqueakExtensions == true ifTrue:[
                "/ croquet/squeak extension - c/java-style arguments
                arguments := self functionCallArgList.
                (arguments == #Error) ifTrue:[^ #Error].
                "/ synthetic selector: foo[:[with:[with:[...]]]]
                arguments notEmpty ifTrue:[
                    sel := sel , ':'.
                    arguments size - 1 timesRepeat:[ sel := sel , 'with:' ].
                ].
                sel := self selectorCheck:sel for:receiver position:pos to:pos2.
                expr := MessageNode receiver:receiver selector:sel args:arguments fold:foldConstants.
                expr isErrorNode ifTrue:[
                    self parseError:(expr errorString) position:pos to:pos2.
                    self clearErrorFlag. "ok, user wants it - so he'll get it"
                    expr := MessageNode receiver:receiver selector:sel args:arguments fold:nil.
                ].
                expr lineNumber:lNr.

                self checkPlausibilityOf:expr from:pos to:pos2.
                parseForCode ifFalse:[
                    self rememberSelectorUsed:sel receiver:receiver
                ].
                ^ expr.
            ].
        ].

        "/ create the expression before (corrector may need it)
        expr := UnaryNode receiver:receiver selector:sel fold:foldConstants.
        expr startPosition: receiver startPosition endPosition: pos2.

        "/ attention: may have been optimized (Character return -> const!!
        expr isMessage ifTrue:[
            expr selectorPosition:pos.
            sel := self selectorCheck:sel for:receiver position:pos to:pos2.
            expr selector:sel.  "/ update possibly changed selector.
        ].

        expr isErrorNode ifTrue:[
            self warning:(expr errorString , '.\\If you proceed, that error may be raised at runtime.') withCRs position:pos to:pos2.
            self clearErrorFlag. "ok, user wants it - so he'll get it"
            expr := UnaryNode receiver:receiver selector:sel fold:nil.
            expr startPosition: receiver startPosition endPosition: pos2.
        ].
        expr lineNumber:lNr.

        self checkPlausibilityOf:expr from:pos to:pos2.
        parseForCode ifFalse:[
            self rememberSelectorUsed:sel receiver:receiver
        ].

        expr := self messageNodeRewriteHookFor:expr.
        receiver := expr.   "/ for next message
    ].
    ^ receiver

    "Modified: / 30-08-2013 / 13:02:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2017 / 13:57:55 / cg"
!

variable
    "parse a simple (i.e. non-namespace-access path) variable;
     return a node-tree, nil or #Error.
     Does not advance to next token.
     If undefined, notify error and correct if user wants to"

    |v pos1 pos2|

    v := self variableOrError:tokenName.
    (v ~~ #Error) ifTrue:[
        (v isMemberOf:VariableNode) ifTrue:[
            self markVariable:v.
        ].
        ^ v
    ].

    "/ hack: if we are in a doIt of a debugger's context,
    "/ AND the variable is an inlined block variable,
    "/ it will not be found in the context.
"/    self isDoIt ifTrue:[
"/        contextToEvaluateIn notNil ifTrue:[
"/            |mthd source parseTree|
"/
"/            "/ we need a parse tree to find the temporary var's slot
"/            mthd := contextToEvaluateIn method.
"/            (source := mthd source) notNil ifTrue:[
"/self halt.
"/                parseTree := Parser parseMethod:source.
"/                (parseTree notNil and:[parseTree ~~ #Error]) ifTrue:[
"/self halt.
"/                ].
"/            ].
"/        ].
"/    ].

    pos1 := tokenPosition.
    pos2 := pos1+tokenName size-1.
    self markUnknownIdentifierFrom:pos1 to:pos2.

    parseForCode ifTrue:[
        allowUndeclaredVariables ifFalse:[
            |msg|

            msg := 'Undeclared variable: %1'.
            "/ for a better error message only
            (self isDoIt
            and:[classToCompileFor notNil
            and:[classToCompileFor theNonMetaclass instanceVariableNames includes:tokenName]])
            ifTrue:[
                msg := 'Instance variable %1 not in scope (in a DoIt evaluation)'.
                self
                    parseError:(msg bindWith:tokenName)
                    position:pos1 to:pos2.
            ].
        ].
        v := self correctVariable:tokenName atPosition:pos1 to:pos2.
        (v ~~ #Error) ifTrue:[^ v].

"/        self errorFlag:true.

        tokenName isLowercaseFirst ifTrue:[
            parserFlags implicitSelfSends ifTrue:[
                ^ UnaryNode receiver:(self selfNode) selector:('__' , tokenName) asSymbol.
            ].
        ].
        self parseError:'undeclared variable: ',tokenName.
    ] ifFalse:[
        self rememberGlobalUsed:(Smalltalk undeclaredPrefix) , tokenName.
        self rememberGlobalUsed:tokenName.
    ].

"/    self markGlobalIdentifierFrom:pos1 to:pos2.
    ^ (VariableNode globalNamed:tokenName)
        startPosition: pos1 endPosition: (pos1 + tokenName size - 1)

    "Modified: / 25-08-2011 / 11:57:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-06-2017 / 06:57:11 / cg"
!

variableOrError
    "parse a simple (i.e. non-namespace-access path) variable;
     return a node-tree, nil or #Error.
     Does not advance to next token."

    ^ self variableOrError:tokenName
!

variableOrError:varName
    "parse a simple (i.e. non-namespace-access path) variable;
     return a node-tree, nil or #Error.
     Does not advance to next token."

    |varIndex aClass searchBlock args vars
     tokenSymbol space classVarIndex holder node
     checkSharedPoolAction|

    "is it a block-arg or block-var ?"
    searchBlock := currentBlock.
    [searchBlock notNil] whileTrue:[
        vars := searchBlock variables.
        vars notNil ifTrue:[
            varIndex := vars findFirst:[:aBlockVar | aBlockVar name = varName].
            varIndex ~~ 0 ifTrue:[
                ^ (VariableNode type:#BlockVariable name:varName 
                        token:(vars at:varIndex) index:varIndex 
                        block:searchBlock from:currentBlock)
                    startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
            ].
        ].

        args := searchBlock arguments.
        args notNil ifTrue:[
            varIndex := args findFirst:[:aBlockArg | aBlockArg name = varName].
            varIndex ~~ 0 ifTrue:[
                ^ (VariableNode type:#BlockArg name:varName
                        token:(args at:varIndex) index:varIndex
                        block:searchBlock from:currentBlock)
                    startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
            ].

        ].
        searchBlock := searchBlock home
    ].

    "is it a method-variable ?"
    (node := self nodeForMethodVariable:varName) notNil ifTrue:[
        ^ node
    ].

    "is it a method-argument ?"
    (node := self nodeForMethodArg:varName) notNil ifTrue:[
        ^ node
    ].

    contextToEvaluateIn notNil ifTrue:[
        |con varNames|

        "/
        "/ search names of the context.
        "/
        con := contextToEvaluateIn.
        [con notNil] whileTrue:[
            varNames := con argAndVarNames.
            varNames size > 0 ifTrue:[
                varIndex := varNames lastIndexOf:varName.
                varIndex ~~ 0 ifTrue:[
                    ^ (VariableNode type:#ContextVariable name:varName
                            context:con index:varIndex)
                        startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
                ].
            ].
            con := con home.
        ].
    ].

    checkSharedPoolAction :=
        [:eachPoolName |
            |sharedPool|

            sharedPool := Smalltalk classNamed:eachPoolName.
            sharedPool isNil ifTrue:[
                Transcript showCR:'Parser: No such pool: ' , eachPoolName.
                "/ self warning:('No such pool: ' , eachPoolName).
            ] ifFalse:[
                (sharedPool includesKey:varName) ifTrue:[
                    parseForCode ifFalse:[self rememberGlobalUsed:(sharedPool name , ':' , varName)].
                    ^ (VariableNode type:#PoolVariable class:sharedPool name:varName)
                        startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
                ].
            ].
        ].

    classToCompileFor notNil ifTrue:[
        "is it an instance-variable ?"

        varIndex := (self classesInstVarNames) lastIndexOf:varName.
        varIndex ~~ 0 ifTrue:[
            classToCompileFor isMeta ifTrue:[
                classVarIndex := (self classesClassVarNames) lastIndexOf:varName.
                classVarIndex ~~ 0 ifTrue:[

                    "/ give a warning - that maybe a common error
                    alreadyWarnedClassInstVarRefs isNil ifTrue:[
                        alreadyWarnedClassInstVarRefs := Set new
                    ].
                    (alreadyWarnedClassInstVarRefs includes:varName) ifFalse:[
                        self
                            warning:('there is both a class variable and a class-instance variable named "%1" (in %2).\\Refering to the class-instance variable here.' withCRs
                                        bindWith:varName with:(self whichClassIncludesClassVar:varName) name)
                            position:tokenPosition to:tokenPosition+varName size-1.
                        alreadyWarnedClassInstVarRefs add:varName.
                    ].
                ].
            ].
            parseForCode ifFalse:[self rememberInstVarUsed:varName].
            ^ (VariableNode type:#InstanceVariable name:varName
                    index:varIndex selfValue:selfValue)
                    startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
        ].

        "/ see if there is a corresponding classVar (for the warning)
        classVarIndex := (self classesClassVarNames) lastIndexOf:varName.

        "/      "is it a class-instance-variable ?"
        "/
        "/ Notice:
        "/ it is no longer allowed to fetch class-instance variables
        "/ from instance methods ...
        "/ (used to be in previous ST/X versions)
        "/
        varIndex := (self classesClassInstVarNames) lastIndexOf:varName.
        varIndex ~~ 0 ifTrue:[
            aClass := self inWhichClassIsClassInstVar:varName.
            aClass notNil ifTrue:[
                classToCompileFor isMeta ifFalse:[
                    classVarIndex == 0 ifTrue:[
                        "/ there is no corresponding classVar;
                        "/ wants to access classInstVar ?
                        contextToEvaluateIn notNil ifTrue:[
                            "/ allow it in a doIt ...

                            ^ (VariableNode type:#ClassInstanceVariable name:varName
                                    index:varIndex selfClass:aClass)
                                startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
                        ].
                        self parseError:'access to class-inst-var from inst method is not allowed'.
                        ^ #Error.
                    ] ifFalse:[
                        "/ give a warning - that maybe a common error
                        self warning:('there is both a class variable and a class-instance variable named ''' , varName , '''.\\Refering to the class variable here (instMethods don''t see classInstVars).') withCRs.
                    ]
                ].

"/ OLD CODE:
"/ self warning:'access to class-inst-var from inst method will soon be no longer supported'.
"/
"/                    parseForCode ifFalse:[self rememberClassVarUsed:varName].
"/                    ^ VariableNode type:#ClassInstanceVariable
"/                                   name:varName
"/                                  index:varIndex
"/                              selfClass:aClass
"/                ].
            ] ifFalse:[
                "/ self halt:'oops - should not happen'.
            ]
        ].

        "is it a class-variable ?"

        varIndex := classVarIndex.
        varIndex ~~ 0 ifTrue:[
            aClass := self inWhichClassIsClassVar:varName.
            aClass notNil ifTrue:[
                parseForCode ifFalse:[self rememberClassVarUsed:varName].
                ^ (VariableNode type:#ClassVariable class:aClass name:varName)
                        startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
            ].
            "/ self halt:'oops - should not happen'.
        ].

        "is it a private-class ?"

        aClass := self classToLookForClassVars theNonMetaclass.
        aClass isLoaded ifTrue:[
            (aClass privateClassesAt:varName) notNil ifTrue:[
                parseForCode ifFalse:[self rememberGlobalUsed:(aClass name , '::' , varName)].
                ^ (VariableNode type:#PrivateClass class:aClass name:varName)
                    startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
            ].
        ].

        " is it a pool-variable ?"
        classToCompileFor theNonMetaclass realSharedPoolNames do:checkSharedPoolAction.
    ].

    (self isDoIt) ifTrue:[
        moreSharedPools notNil ifTrue:[
            moreSharedPools do:checkSharedPoolAction.
        ].
        "is it a thread local variable ?"
        (Processor activeProcess environmentIncludesKey:varName asSymbol) ifTrue:[
            ^ (VariableNode type:#ThreadLocal name:varName)
                startPosition: tokenPosition endPosition: tokenPosition + varName size -1
        ].    
    ].

    "is it in a namespace ?"
    space := self findNameSpaceWith:varName.
    space notNil ifTrue:[
        space ~~ Smalltalk ifTrue:[
            parseForCode ifFalse:[self rememberGlobalUsed:(space name , '::' , varName)].
            space isNameSpace ifTrue:[
                ^ (VariableNode globalNamed:(space name , '::' , varName))
                        startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
            ].
            ^ (VariableNode type:#PrivateClass class:space name:varName)
                startPosition: tokenPosition endPosition: tokenPosition + varName size -1
        ].
        parseForCode ifFalse:[self rememberGlobalUsed:varName].
        ^ (VariableNode globalNamed:varName) startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
    ].

    "is it a global-variable ?"
    tokenSymbol := varName asSymbolIfInterned.
    tokenSymbol notNil ifTrue:[
        (Smalltalk includesKey:tokenSymbol) ifTrue:[
            parseForCode ifFalse:[self rememberGlobalUsed:varName].
            ^ (VariableNode globalNamed:tokenSymbol) startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
        ]
    ].

    autoDefineVariables isNil ifTrue:[
        autoDefineVariables := false.    
        (requestor notNil and:[requestor isStream not]) ifTrue:[
            autoDefineVariables := (requestor perform:#autoDefineVariables ifNotUnderstood:false) ? false.
        ]
    ]. 

    "/ attention: in scripting mode (stx --script),
    "/ workspace variables must be found!!
    
    "/ (autoDefineVariables ~~ false) 
    self isDoIt 
    ifTrue:[
        "is it a workspace variable ?"

        (Workspace notNil
        and:[(holder := Workspace workspaceVariableHolderAt:varName) notNil])
        ifTrue:[
            ^ (VariableNode type:#WorkspaceVariable holder:holder name:varName)
                startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
        ].
        "/ self isDoIt 
        (autoDefineVariables ~~ false) 
        ifTrue:[
            "is it a doIt variable ?"

            (doItTemporaries notNil
            and:[(holder := doItTemporaries at:varName asSymbol ifAbsent:nil) notNil])
            ifTrue:[
                ^ (VariableNode type:#DoItTemporary holder:holder name:varName)
                    startPosition: tokenPosition endPosition: tokenPosition + varName size - 1
            ].
        ].
    ].
    
    "/ do not raise parseError here, but instead report it a the old stupid #Error token.
    "/ this is required here so that the caller can check for an assignment,
    "/ and autodefine workspace- and doIt variables.
    "/ self parseError:'undeclared variable: ',tokenName.
    ^ #Error

    "Modified: / 25-08-2011 / 13:53:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-10-2011 / 15:25:20 / az"
    "Modified (comment): / 14-06-2017 / 15:11:42 / cg"
! !

!Parser methodsFor:'parsing-primitives & pragmas'!

addAnnotationWithKey:key andArguments:arguments
    |annot|

    "/ was: annot := { key . arguments}.
    annot := ParsedAnnotation key:key arguments:arguments.
    annot startPosition:annotationStartPosition endPosition:(annotationEndPosition ifNil:[ source position ]).
    annotations := annotations copyWith:annot.
!

checkForClosingAngle
    "verify a closing angle and skip over it"

    ((tokenType == #BinaryOperator) and:[tokenName = '>']) ifTrue:[
        annotationEndPosition := tokenPosition.
        self nextToken.
    ] ifFalse:[
        self parseError:'bad primitive definition (''>'' expected)'.
        self skipForClosingAngle.
    ]
!

defineWellknownCTypesIn:aDictionary
    "/ a few wellknown types

    aDictionary at:#'BOOL' put:(CType typedef:CType bool name:'BOOL').
    aDictionary at:#'UINT' put:(CType typedef:CType unsignedInt name:'UINT').
    aDictionary at:#'LONG' put:(CType typedef:CType long name:'LONG').
    aDictionary at:#'DWORD' put:(CType typedef:CType int name:'DWORD').
    aDictionary at:#'HANDLE' put:(CType typedef:CType voidPointer name:'HANDLE').
    aDictionary at:#'HWND'   put:(CType typedef:CType voidPointer name:'HWND') .
    "/ aDictionary at:#'HPALETTE' put:(CType typedef:CType voidPointer name:'HPALETTE') .
!

generateCallToExternalFunction:fn lineNr:lineNr
    |args sel node|

    fn argumentTypes size ~~ (methodArgNames size
                            "the following stuff was commented (2007-07-30), to make ole: work.
                             Ask felix or stefan"
                            " + (fn isCPPFunction ifTrue:1 ifFalse:0)") ifTrue:[
        self
            ignorableParseError:('Number of method args (%1) does not match function arg list (api call)'
                                bindWith: methodArgNames size).
    ].

    args := (methodArgNames ? #()) collect:[:eachArgName | self nodeForMethodArg:eachArgName].
    fn isVirtualCPP ifTrue:[
        sel := #(
              invokeCPPVirtualOn:
              invokeCPPVirtualOn:with:
              invokeCPPVirtualOn:with:with:
              invokeCPPVirtualOn:with:with:with:
            ) at:args size+1 ifAbsent:nil.
        sel isNil ifTrue:[
            args := Array with:(self selfNode) with:(self genMakeArrayWith:args).
            sel := #invokeCPPVirtualOn:withArguments:.
        ] ifFalse:[
            args := (Array with:(self selfNode)) , args.
        ].
    ] ifFalse:[
        fn isNonVirtualCPP ifTrue:[
            args := (Array with:(self selfNode)) , args
        ].
        sel := #(
              invoke
              invokeWith:
              invokeWith:with:
              invokeWith:with:with:
            ) at:args size+1 ifAbsent:nil.
        sel isNil ifTrue:[
            args := Array with:(self genMakeArrayWith:args).
            sel := #invokeWithArguments:.
        ].
    ].

    node := MessageNode
                receiver:(ConstantNode type:nil value:fn)
                selector:sel
                args:args
                fold:false.
    node lineNumber:lineNr.
    tree := ReturnNode expression:node.
    tree lineNumber:lineNr.

    "Created: / 01-08-2006 / 13:47:44 / cg"
    "Modified: / 04-08-2017 / 10:08:11 / cg"
!

generateReturnOfValue:aValue
    |node|

    node := ConstantNode type:nil value:aValue.
    node lineNumber:tokenLineNr.
    tree := ReturnNode expression:node.
    tree lineNumber:tokenLineNr.
    tree startPosition:tokenPosition.

    "Modified: / 16-11-2006 / 14:36:35 / cg"
!

generateTrapCodeForUnavailableCParser
    |args node|

    self ignorableParseError:'CParser Missing'.

    args := Array with:(ConstantNode type:nil value:'External function call error - CParser missing.').
    node := MessageNode receiver:(self selfNode) selector:#error: args:args fold:false.
    node lineNumber:lineNr.
    tree := ReturnNode expression:node.
    tree lineNumber:lineNr.
    ^ -1

    "Created: / 21-06-2006 / 09:58:43 / cg"
!

parseAnotationLiteral
    |value|

    ((tokenType == #String) 
    or: [(tokenType == #Integer) 
    or: [(tokenType == #True) 
    or: [(tokenType == #False) 
    or: [(tokenType == #Nil)
    or: [(tokenType == #Symbol) 
    or: [(tokenType == #Character)
    ]]]]]]) ifTrue: [
        value := tokenValue.
        self nextToken.
        ^ value.
    ].

    (tokenType == #Identifier) ifTrue:[
        value := tokenName asSymbol.
        self nextToken.
        ^ value.
    ].

    "
    (tokenType == #Keyword) ifTrue: [
        value := '#', tokenName.
        self nextToken.
        ^ value.
    ].
    "

    ((tokenType == $() or:[tokenType == #HashLeftParen]) ifTrue:[
        self nextToken.
        value := self array.
        self nextToken.
        ^ value.
    ].

    ((tokenType == $[) or:[tokenType == #HashLeftBrack]) ifTrue:[
        self nextToken.
        value := self byteArray.
        self nextToken.
        ^value.
    ].
    ((tokenType == ${) or:[tokenType == #HashLeftBrace]) ifTrue:[
        self nextToken.
        value := self qualifiedNameFrom:tokenPosition.
        ^value.
    ].
    self parseError:tokenType,' unexpected in annotation'.
    ^ #Error

    "Created: / 12-11-2009 / 14:08:29 / Jan Travnicek <travnja3@fel.cvut.cz>"
    "Modified: / 15-12-2009 / 14:01:42 / Jan Travnicek <travnja3@fel.cvut.cz>"
    "Modified: / 12-07-2010 / 10:07:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseExceptionOrContextPragma
    "parse
        <exception: #handle|raise|unwind>,
        <context: #return>
     context flagging pragmas."

    |pragmaType pragmaValue|

    "/ notice: '<' has already been parsed.
    pragmaType := tokenName.
    self nextToken.

    (pragmaType = 'context:') ifTrue:[
        ((tokenType == #Symbol) and:[tokenValue == #return]) ifTrue:[
            self rememberContextReturnablePragma
        ] ifFalse:[
            self parseError:'invalid context pragma: ' , (tokenValue ? tokenName).
        ].
    ].

    (pragmaType = 'exception:') ifTrue:[
        ((tokenType == #Symbol)
        and:[
            tokenValue == #handle
            or:[ tokenValue == #raise
            or:[ tokenValue == #unwind ]]]
        ) ifTrue:[
            self rememberContextPragma:pragmaType value:tokenValue
        ] ifFalse:[
            self parseError:'invalid exception pragma: ' , (tokenValue ? tokenName).
        ].
    ].
    pragmaValue := tokenValue.

    self nextToken.
    self checkForClosingAngle.

    self addAnnotationWithKey:pragmaType asSymbol andArguments:{ pragmaValue }.

    "Modified: / 19-11-2009 / 11:10:04 / Jan Travnicek <travnja3@fel.cvut.cz>"
    "Modified: / 01-07-2010 / 12:33:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-07-2011 / 08:16:03 / cg"
!

parseExternalFunctionCallDeclaration
    |callType cString cStream dictionaryOfKnownTypes lineNr|

    "callType is one of c: / cdecl: / api: / apicall: ..."
    callType := tokenName asLowercase.
    lineNr := tokenLineNr.
    cString := source upTo:$>.
    annotationEndPosition := tokenPosition.
    self nextToken.
    parseForCode ifFalse:[
        ^ -1
    ].
    CParser notNil ifTrue:[
        dictionaryOfKnownTypes := Dictionary new.

        "/ a few wellknown types

        self defineWellknownCTypesIn:dictionaryOfKnownTypes.

        "/ collect existing types...

        classToCompileFor
            methodsDo:[:m |
                m
                    literalsDo:[:lit |
                        (lit isKindOf:CType) ifTrue:[
                            self assert:lit name notNil.
                            dictionaryOfKnownTypes at:lit name put:lit.
                        ].
                    ].
            ].
    ].
    cStream := cString readStream.
    (#( 'apicall:' 'cdecl:' 'stdcall:' 'virtual' ) includes:callType) ifTrue:[
        "/ squeak/dolphin/stx external function definition
        self addAnnotationWithKey:callType asSymbol andArguments:cString.
        self
            parseSTXOrSqueakOrDolphinExternalFunctionDeclarationFrom:cStream
            definitionType:callType
            knownDefinitions:dictionaryOfKnownTypes
            lineNr:lineNr.
        ^ -1
    ].
    callType = 'c:' ifTrue:[
        "/ VW external function definition
        self addAnnotationWithKey:callType asSymbol andArguments:cString.
        self
            parseVWTypeOrExternalFunctionDeclarationFrom:cStream
            definitionType:callType
            knownDefinitions:dictionaryOfKnownTypes
            lineNr:lineNr.
        ^ -1
    ].
    (callType = 'api:' or:[ callType = 'ole:' ]) ifTrue:[
        "/ ST/V external function definition
        self addAnnotationWithKey:callType asSymbol andArguments:cString.
        self
            parseSTVExternalFunctionDeclarationFrom:cStream
            definitionType:callType
            knownDefinitions:dictionaryOfKnownTypes
            lineNr:lineNr.
        ^ -1
    ].
    self ignorableParseError:'unsupported external function call type: ' , callType.
    ^ -1

    "
     (Parser for:'foo <cdecl: void ''glFlush'' (void) module: ''GL''>')
        nextToken;
        parseMethod
    "

    "Modified: / 25-10-2006 / 12:03:33 / cg"
    "Modified: / 19-11-2009 / 11:09:51 / Jan Travnicek <travnja3@fel.cvut.cz>"
    "Modified: / 01-07-2010 / 12:05:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 12-02-2017 / 23:45:49 / cg"
!

parseGSTExternalFunctionDeclaration: argArray
    "Handles GNU Smalltalk-style exteranl function declarations.
     Example:
         <cCall: 'cairo_close_path' returning: #void args: #(#cObject )>
    "
    | function |

    function := ExternalLibraryFunction
                    name:argArray first
                    module:nil
                    returnType:argArray second
                    argumentTypes:argArray third asArray.
    function beCallTypeC.
    function owningClass:classToCompileFor.
    self generateCallToExternalFunction:function lineNr:lineNr.

    "Created: / 09-04-2012 / 19:52:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOtherPrimitives
    |key value values|

    key := tokenName.
    value := true.
    self nextToken.
    ((tokenType == #BinaryOperator) and:[ tokenName = '>' ]) ifTrue:[
        self checkForClosingAngle. "/ not really a check, but remembers endPos
        self addAnnotationWithKey:key asSymbol andArguments:value.
        ^ nil.
    ].
    value := self parseAnotationLiteral.
    (value == #Error) ifTrue:[
        ^ #Error.
    ].
    ((tokenType == #BinaryOperator) and:[ tokenName = '>' ]) ifTrue:[
        self checkForClosingAngle. "/ not really a check, but remembers endPos
        self addAnnotationWithKey:key asSymbol andArguments:{ value }.
        ^ nil.
    ].
    values := OrderedCollection new:4.
    values add:value.
    [
        (tokenType == #Keyword or:[ tokenType == #Identifier ])
    ] whileTrue:[
        key := key , tokenName.
        self nextToken.
        value := self parseAnotationLiteral.
        (value == #Error) ifTrue:[
            ^ #Error.
        ].
        values add:value.
    ].
    self checkForClosingAngle.
    self addAnnotationWithKey:key asSymbol andArguments:values asArray.

    "JV@2012-04-09: Check for GNU Smalltalk-style external function declaration"
    key = #'cCall:returning:args:' ifTrue:[
        self parseGSTExternalFunctionDeclaration: values.
    ].
    ^ nil.

    "Created: / 04-11-2009 / 08:51:48 / Jan Travnicek <travnja3@fel.cvut.cz>"
    "Modified: / 19-11-2009 / 11:48:24 / Jan Travnicek <travnja3@fel.cvut.cz>"
    "Modified: / 13-02-2015 / 15:46:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePragma
    " '<' has already been parsed.
      <pragma: +arrayIndexSyntaxExtension>
    "

    |type flagValue|

    type := token.
    type ~= 'pragma:' ifTrue:[
        self parseError:'pragma expected'.
        ^ #self
    ].

    self nextToken.
    ((token = '+') or:[token = '-']) ifTrue:[
        flagValue := (token = '+').
        self nextToken.
        (tokenType == #Identifier) ifTrue:[
            ( #(
                    'arrayIndexSyntaxExtension'
                    "possibly add more here"
               ) includes:token
            ) ifTrue:[
                parserFlags perform:('allow',token asUppercaseFirst) asMutator with:flagValue.
                self nextToken.
                self checkForClosingAngle.
                ^ self.
            ].
        ].
        self breakPoint:#cg.
        self parseError:'unknown pragma'.
        ^  self
    ].

    self parseError:'+/- expected'.
    ^ self
!

parsePrimitive
    "parse an ST-80 type primitive as '< primitive: nr >';
        (return primitive number or #Error)
     or a Squeak-style primitive, as '< primitive: string >';
        (return primitive name or #Error)
     or a V'Age-style primitive, as '< primitive: identifier >';
        (return primitive name or #Error)

     Also, resource specs are parsed; the result is left (as side effect) in primitiveResource.
     It is used to flag methods, for faster finding of used keyboard accelerators,
     and to mark resource methods (image, menu or canvas resources).

     prim ::= st80Primitive | st80Pragma | stxPragma
              | squeakPrimitive | vAgePrimitive | newSTXPrimitive
              | externalFuncDecl
              | resourceDecl

     st80Primitive ::= 'primitive:' INTEGER
     st80Pragma    ::= 'exception:' ( 'handle | 'raise' | 'unwind' )
     stxPragma     ::= 'context:' 'return'

     squeakPrimitive ::= 'primitive:' STRING

     newSTXPrimitive ::= 'primitive'

     vAgePrimitive ::= 'primitive:' IDENTIFIER
                       | 'sysprim:' IDENTIFIER

     externalFuncDecl ::= vwExternalFuncDecl
                          | stvExternalFuncDecl
                          | squeakExternalFuncDecl
                          | dolphinExternalFuncDecl

     vwExternalFuncDecl ::= 'c:' vwFuncDecl

     stvExternalFuncDecl ::= 'api:' stvFuncDecl
                             |  'ole:' stvFuncDecl

     squeakExternalFuncDecl ::= 'apicall:' stvFuncDecl
                                |  'cdecl:' stvFuncDecl

     dolphinExternalFuncDecl ::= 'stdcall:' stvFuncDecl

     resourceDecl ::= 'resource:'  SYMBOL       - leave SYMBOL in primitiveResource
                    | 'resource:'  SYMBOL (...) - leave (SYMBOL (...)) in primitiveResource
                    | 'pragma:'    SYMBOL       - same as resource; alternative syntax
                    | 'pragma:'    SYMBOL (...) - same as resource; alternative syntax
                    | 'attribute:' SYMBOL       - same as resource; alternative syntax
                    | 'attribute:' SYMBOL (...) - same as resource; alternative syntax"

    |lcTokenName tmp|

    (tokenType == #Keyword or:[ tokenType == #Identifier ]) ifFalse:[
        self parseError:'bad primitive definition (keyword expected)'.
        ^ #Error
    ].
    (tokenName = 'primitive:') ifTrue:[
        tmp := self parseTraditionalPrimitive.
        self addAnnotationWithKey:#'primitive:' andArguments:tmp.
        ^ tmp.
    ].
    (tokenName = 'sysprim:') ifTrue:[
        parserFlags allowVisualAgePrimitives ifTrue:[
            tmp := self parseTraditionalPrimitive.
            self addAnnotationWithKey:#'sysprim:' andArguments:tmp.
            ^ tmp.
        ].
    ].
    (tokenName = 'primitive') ifTrue:[
        self nextToken.
        self checkForClosingAngle.
        self addAnnotationWithKey:#'primitive' andArguments:0.
        ^ 0
        "/ no primitive number
        .
    ].
    (tokenName = 'resource:') ifTrue:[
        self parseResourcePragma.
        ^ nil
        "/ no primitive number
        .
    ].
    (tokenName = 'pragma:') ifTrue:[
        self parsePragma.
        ^ nil
        "/ no primitive number
        .
    ].
    (tokenName = 'exception:' or:[ tokenName = 'context:' ]) ifTrue:[
        (self parseExceptionOrContextPragma) == #Error ifTrue:[
            ^ #Error
        ].
        ^ nil
        "/ no primitive number
    ].
    lcTokenName := tokenName asLowercase.
    ((lcTokenName = 'c:' "/ vw external function definition
    ) or:[ lcTokenName = 'api:' "/ st/v external function definition
      or:[ lcTokenName = 'ole:' "/ st/v external function definition
      or:[ lcTokenName = 'apicall:' "/ squeak external function definition
      or:[ lcTokenName = 'cdecl:' "/ squeak external function definition
      or:[ lcTokenName = 'stdcall:' "/ dolphin external function definition
    ]]]]]) ifTrue:[
        self parseExternalFunctionCallDeclaration.
        ^ nil
        "/ no primitive number
    ].
    ^ self parseOtherPrimitives.

    "Modified: / 10-01-2010 / 17:10:11 / Jan Travnicek <travnja3@fel.cvut.cz>"
    "Modified: / 01-07-2010 / 18:12:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePrimitiveOrResourceSpecOrEmpty
    "parse a methods primitive or resource spec"

    |pos wmsg primNr primNrOrString|

    [(tokenType == #BinaryOperator) and:[tokenName = '<']] whileTrue:[
        pos := annotationStartPosition := tokenPosition.
        self nextToken.
        primNrOrString := self parsePrimitive.

        (primNrOrString == #Error) ifTrue:[^ #Error].
        wmsg := nil.

        primNrOrString isString ifTrue:[
            primNr := self primitiveNumberFromName:primNrOrString
        ] ifFalse:[
            primNr := primNrOrString
        ].

        primNr notNil ifTrue:[
            primNr < 0 ifTrue:[
                parserFlags warnST80Directives == true ifTrue:[
                    wmsg := 'ST-80/Squeak directive ignored'.
                ].
            ] ifFalse:[
                primNr > 0 ifTrue:[
                    primitiveNr := primNr.
                    wmsg := 'ST-80 primitive may not work'
                ] ifFalse:[
                    primitiveNr := primNr.
                    wmsg := 'ST/X primitives only work in rel5 and newer'
                ]
            ].
            wmsg notNil ifTrue:[self warning:wmsg position:pos]
        ].
    ].

    "Created: 27.4.1996 / 16:55:55 / cg"
    "Modified: 29.5.1996 / 17:25:52 / cg"
!

parseResourcePragma
    " '<' has already been parsed."

    |type keys resource resourceValue|

    type := token.
    self nextToken.
    (tokenType ~~ #Symbol) ifTrue:[
        self parseError:'symbol expected in resource spec'.
        ^ #Error
    ].
    resource := tokenValue.
    resourceValue := true.
    self nextToken.
    tokenType == $( ifTrue:[
        self nextToken.
        keys := OrderedCollection new.
        [
            tokenType == $) or:[ tokenType == #EOF ]
        ] whileFalse:[
            tokenType ~~ #Symbol ifTrue:[
                self parseError:'symbol expected in resource spec'.
                ^ #Error
            ].
            keys add:tokenValue.
            self nextToken.
        ].
        resourceValue := keys asArray.
        tokenType == $) ifFalse:[
            self parseError:'unterminated resource spec (missing '')'')'.
        ].
        self nextToken.
    ].
    primitiveResource isNil ifTrue:[
        primitiveResource := IdentityDictionary new.
    ].
    primitiveResource at:resource put:resourceValue.
    self checkForClosingAngle.
    (resourceValue == true) ifTrue:[
        self addAnnotationWithKey:#'resource:' andArguments:{ resource }.
    ] ifFalse:[
        self addAnnotationWithKey:#'resource:values:' andArguments:{resource . resourceValue}.
    ]

    "Modified: / 19-11-2009 / 11:11:26 / Jan Travnicek <travnja3@fel.cvut.cz>"
    "Modified: / 01-07-2010 / 12:23:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseSTVExternalFunctionDeclarationFrom:aStream definitionType:definitionType knownDefinitions:dictionaryOfTypesOrNil lineNr:lineNr
    "parses ST/V function declarations of the forms
        '<api: functionName argType1 .. argTypeN returnType>'
        '<ole: vFunctionIndex argType1 .. argTypeN returnType>'
    "

    |primParser function|

    primParser := PrimitiveSpecParser new.
    function := primParser
        parseSTVExternalFunctionDeclarationFrom:aStream
        definitionType:definitionType
        lineNr:lineNr
        for:self.
    function notNil ifTrue:[
        function owningClass:classToCompileFor.
        self generateCallToExternalFunction:function lineNr:lineNr.
    ].

    "Modified: / 07-09-2011 / 22:07:36 / cg"
!

parseSTXOrSqueakOrDolphinExternalFunctionDeclarationFrom:aStream definitionType:definitionType
    knownDefinitions:dictionaryOfTypesOrNil lineNr:lineNr

    "parses squeak/dolphin/stx function declarations of the forms
        '<stdcall: [virtual|nonVirtual][const][mustFree] returnType functionNameOrIndex argType1..argTypeN>'
        '<cdecl:   [virtual|nonVirtual][const][mustFree] returnType functionNameOrIndex argType1..argTypeN>'

        '<cdecl:   [async] [virtual|nonVirtual][const][mustFree] returnType functionNameOrIndex ( argType1..argTypeN ) module: moduleName >'
        '<apicall: [async] [virtual|nonVirtual][const][mustFree] returnType functionNameOrIndex ( argType1..argTypeN ) module: moduleName >'
    "

    |primParser function|

    primParser := PrimitiveSpecParser new setClassToCompileFor:classToCompileFor.
    primParser notifying:requestor.
    function := primParser
        parseSTXOrSqueakOrDolphinExternalFunctionDeclarationFrom:aStream
        definitionType:definitionType
        lineNr:lineNr
        for:self.

    function notNil ifTrue:[
        function owningClass:classToCompileFor.
        self generateCallToExternalFunction:function lineNr:lineNr.
    ].

    "Created: / 25-10-2006 / 12:03:24 / cg"
    "Modified (comment): / 12-02-2017 / 23:45:27 / cg"
!

parseTraditionalPrimitive
    "parse everything after the initial '<primitive:'"

    |primNumber|

    self nextToken.
    (tokenType == #Integer) ifFalse:[
        (tokenType == #String) ifTrue:[
            (parserFlags allowSqueakExtensions
            or:[ parserFlags allowSqueakPrimitives
            or:[ parserFlags allowVisualAgePrimitives ]]) ifFalse:[
                self parseError:'primitive name as string expected (Squeak/V''Age primitives not allowed - see settings)'.
            ].
        ] ifFalse:[
            (tokenType == #Identifier) ifTrue:[
                (false "parserFlags allowVisualAgeExtensions"
                or:[ parserFlags allowVisualAgePrimitives ]) ifFalse:[
                    self parseError:'primitive number expected (V''Age-primitives not allowed - see settings)'.
                ]
            ] ifFalse:[
                self parseError:'primitive number expected'.
            ].
        ].
"/        (parserFlags allowSqueakExtensions
"/        or:[ parserFlags allowSqueakPrimitives ]) ifTrue:[
"/            (tokenType == #String) ifFalse:[
"/                self parseError:'primitive name as string expected (Squeak primitives not allowed - see settings)'.
"/                ^ #Error
"/            ]
"/        ] ifFalse:[
"/            parserFlags allowVisualAgePrimitives ifTrue:[
"/                (tokenType == #Identifier) ifFalse:[
"/                    self parseError:'primitive name expected'.
"/                    ^ #Error
"/                ]
"/            ] ifFalse:[
"/                self parseError:'primitive number expected (VA-primitives not allowed - see settings)'.
"/                ^ #Error
"/            ].
"/        ]
    ].
    primitiveNr notNil ifTrue:[
        self parseError:'only one primitive spec allowed'.
        primNumber := -1.
    ] ifFalse:[
        primNumber := tokenValue.
    ].
    self nextToken.

    (tokenType == #Keyword) ifTrue:[
        (tokenName = 'errorCode:') ifTrue:[
            self nextToken.
            (tokenType == #Identifier) ifTrue:[
                self nextToken.
            ] ifFalse:[
                self error:'not yet implemented'.
            ]
        ].
        (tokenName = 'module:') ifTrue:[
            self nextToken.
            (tokenType == #String) ifTrue:[
                self nextToken.
            ] ifFalse:[
                self error:'not yet implemented'.
            ]
        ].
    ].

    tokenType == $: ifTrue:[
        "/ va-style:
        "/  <primitive: 'PACKAGER_PRIMITIVES':EsMakeAssociationGlobal>
        primNumber isString ifFalse:[
            self error:'unknown V''Age primitive spec format'.
        ].
        self nextToken.
        tokenType == #Identifier ifFalse:[
            self parseError:'unknown V''Age primitive spec format'.
        ].
        primNumber := primNumber,':',tokenName.
        self nextToken.
    ].

    self checkForClosingAngle.
    ^ primNumber

    "Modified: / 03-11-2009 / 17:14:48 / Jan Travnicek <travnja3@fel.cvut.cz>"
    "Modified: / 07-02-2012 / 17:22:52 / cg"
!

parseVWTypeOrExternalFunctionDeclarationFrom:aStream definitionType:definitionType knownDefinitions:dictionaryOfTypesOrNil lineNr:lineNr
    "parses visualWorks type/function declarations of the form:
        '<c: ...>'"

    |primParser functionOrTypeOrValue|

    primParser := PrimitiveSpecParser new setClassToCompileFor:classToCompileFor.
    functionOrTypeOrValue := primParser
        parseVWTypeOrExternalFunctionDeclarationFrom:aStream
        definitionType:definitionType
        knownDefinitions:dictionaryOfTypesOrNil
        lineNr:lineNr
        for: self.

    functionOrTypeOrValue isNil ifTrue:[^ self].

    (functionOrTypeOrValue isExternalLibraryFunction) ifFalse:[
        self generateReturnOfValue:functionOrTypeOrValue.
        ^ self
    ].

    functionOrTypeOrValue owningClass:classToCompileFor.
    self generateCallToExternalFunction:functionOrTypeOrValue lineNr:lineNr.

    "Modified: / 01-08-2006 / 16:21:36 / cg"
!

primitiveNumberFromName:aPrimitiveName
    "for future compatibility with Squeak ..."

    ^ nil
!

rememberContextPragma:pragmaType value:pragmaValue
    primitiveContextInfo isNil ifTrue:[
        primitiveContextInfo := Set new.
    ].
    primitiveContextInfo add:(pragmaType -> pragmaValue).

    "Created: / 15-07-2011 / 08:15:08 / cg"
!

rememberContextReturnablePragma
    self rememberContextPragma:#'context:' value:#'return'

    "Created: / 15-07-2011 / 08:11:08 / cg"
!

skipForClosingAngle
    "/ skip
    [tokenType ~~ #EOF] whileTrue:[
        ((tokenType == #BinaryOperator) and:[tokenName = '>']) ifTrue:[
            self nextToken.
            ^ nil "/ no primitive number
        ].
        self nextToken.
    ].
! !

!Parser methodsFor:'private'!

currentNameSpace
    |spc|

    spc := currentNamespace.
    spc isNil ifTrue:[
        (requestor respondsTo:#currentNameSpace) ifTrue:[
            spc := requestor currentNameSpace
        ] ifFalse:[
            spc := Class nameSpaceQuerySignal query.
        ].
        currentNamespace := spc.
    ].
    ^ spc

    "Created: / 19.12.1996 / 23:47:58 / cg"
    "Modified: / 14.10.1997 / 20:56:06 / cg"
    "Modified: / 18.3.1999 / 18:25:50 / stefan"
!

currentNameSpace:aNameSpace
    currentNamespace := aNameSpace.

    "Created: / 08-02-1997 / 19:37:03 / cg"
!

currentNamespace:aNameSpace
    <resource: #obsolete>
    self obsoleteMethodWarning:'use currentNameSpace:'.
    currentNamespace := aNameSpace.

    "Created: / 04-03-2012 / 13:36:07 / cg"
!

currentPackage
    |pkg|

    pkg := currentPackage.
    pkg isNil ifTrue:[
        (requestor respondsTo:#currentPackage) ifTrue:[
            pkg := requestor currentPackage
        ] ifFalse:[
            pkg := Class packageQuerySignal query.
        ].
        currentPackage := pkg.
    ].
    ^ pkg
!

currentUsedNameSpaces
    |spaces|

    spaces := currentUsedNamespaces.
    spaces isNil ifTrue:[
        (requestor respondsTo:#usedNameSpaces) ifTrue:[
            spaces := requestor usedNameSpaces
        ] ifFalse:[
            spaces := Class usedNameSpaceQuerySignal query.
        ].
        spaces isNil ifTrue:[
            spaces := #()
        ].
        currentUsedNamespaces := spaces.
    ].
    ^ spaces

    "Created: / 19.12.1996 / 23:49:10 / cg"
    "Modified: / 7.4.1998 / 08:59:28 / cg"
    "Modified: / 18.3.1999 / 18:25:57 / stefan"
!

findNameSpaceWith:aVariableName
    |ns currentSpace usedSpaces|

    "/ private names have already been searched for.

    classToCompileFor notNil ifTrue:[
        "/ Q:
        "/ consider private classes of superclasses.
        "/ or search in the top owing classes namespace only ?

        "/ for now, ignore other private classes - they are only
        "/ known to the corresponding ownerClass.

        "is it in the classes namespace ?"

        ns := classToCompileFor topNameSpace.
        (ns notNil
        and:[ns ~~ Smalltalk]) ifTrue:[
            ns isNameSpace ifTrue:[
                (ns at:aVariableName) notNil ifTrue:[
                    ^ ns
                ]
            ]
        ].

"/        ns := classToCompileFor nameSpace.
"/        ns notNil ifTrue:[
"/            "is it in the current classes namespace ?"
"/            (ns at:aVariableName asSymbol) notNil ifTrue:[
"/                ^ ns
"/            ]
"/        ].
    ].

    "is it in the current namespace ?"
    currentSpace := self currentNameSpace.
    (currentSpace notNil
    and:[currentSpace ~~ Smalltalk]) ifTrue:[
        currentSpace isNameSpace ifTrue:[
            (currentSpace at:aVariableName) notNil ifTrue:[
                ^ currentSpace
            ]
        ] ifFalse:[
            (currentSpace privateClassesAt:aVariableName) notNil ifTrue:[
                ^ currentSpace
            ]
        ]
    ].

    "is it in one of the used namespaces ?"
    usedSpaces := self currentUsedNameSpaces.
    usedSpaces notNil ifTrue:[
        ^ usedSpaces detect:[:aNameSpace | (aNameSpace at:aVariableName) notNil] ifNone:nil.
    ].
    ^ nil

    "Created: 19.12.1996 / 23:51:02 / cg"
    "Modified: 14.10.1997 / 20:56:35 / cg"
!

genMakeArrayWith:elementExpressions
    "return a node to generate an array at runtime.
     Will generate:
        Array with:el1 ... with:elN                             (if N <= 5)
     or:
        (Array new at:1 put:el1; ... at:N put:elN; yourself)    (otherwise)
    "

    ^ self class genMakeArrayWith:elementExpressions

    "Modified: / 01-08-2011 / 12:38:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inWhichClassIsClassInstVar:aString
    "search class-chain for the class-instance variable named aString
     - return the class or nil if not found"

    |aClass|

    aClass := self classToLookForClassVars.

    [aClass notNil] whileTrue:[
        (aClass class instVarNames includes:aString) ifTrue:[ ^ aClass].
        aClass := aClass superclass
    ].
    ^ nil

    "Modified: / 18.6.1998 / 15:45:34 / cg"
!

inWhichClassIsClassVar:aString
    "search class-chain for the classvariable named aString
     - return the class or nil if not found"

    |aClass className baseClass|

    aClass := self classToLookForClassVars.

    aClass isMeta ifTrue:[
        className := aClass name copyButLast:6.
        baseClass := Smalltalk at:(className asSymbol).
        baseClass notNil ifTrue:[
            aClass := baseClass
        ]
    ].
    ^ aClass whichClassDefinesClassVar:aString

"/    [aClass notNil] whileTrue:[
"/        (aClass classVarNames includes:aString) ifTrue:[ ^ aClass].
"/        aClass := aClass superclass
"/    ].
"/    ^ nil

    "Modified: / 17.6.1996 / 17:18:41 / stefan"
    "Modified: / 18.6.1998 / 15:45:29 / cg"
!

isStatementAnUnconditionalReturn:aStatementNode
    "used on the last statement, to see if this is doing a return already
     (i.e. its own return value is to be ignored."

    |expr checkBlock check2Blocks selector block1 block2|

    checkBlock :=
        [:block |
            |stats|

            stats := block statements.
            stats notEmptyOrNil and:[ self isStatementListAnUnconditionalReturn:stats ]
        ].

    check2Blocks :=
        [:block1 :block2 |
            block1 isBlockNode
            and:[ block2 isBlockNode
            and:[ (checkBlock value:block1)
            and:[ (checkBlock value:block2) ]]]
        ].

    aStatementNode isReturnNode ifTrue:[^ true ].

    ((expr := aStatementNode expression) notNil
    and:[expr isMessage]) ifTrue:[
        selector := expr selector.

        "/ if both paths of an if end in return...
        "/ or both the handler and the block of a handle:do: end in a return...
        (selector == #'ifTrue:ifFalse:'
        or:[ selector == #'ifFalse:ifTrue:'
        or:[ selector == #'handle:do:' ]]) ifTrue:[
            block1 := expr arg1.
            block2 := expr arguments at:2.
            ^ check2Blocks value:block1 value:block2
        ].
        (selector == #'on:do:') ifTrue:[
            block1 := expr receiver.
            block2 := expr arguments at:2.
            ^ check2Blocks value:block1 value:block2
        ].
    ].
    ^ false.

    "Modified: / 24-09-2010 / 18:10:20 / cg"
!

isStatementListAnUnconditionalReturn:aStatementNode
    "used on a statement-list, to see if this is doing an unconditional return"

    |stat|

    stat := aStatementNode.
    [stat notNil] whileTrue:[
        (self isStatementAnUnconditionalReturn:stat) ifTrue:[^ true].
        stat := stat nextStatement
    ].
    ^ false.

    "Created: / 24-09-2010 / 18:02:08 / cg"
!

isValidUnarySelector:tokenType
    tokenType == #Identifier ifTrue:[^true].
    tokenType == #Here ifTrue:[^true].

    parserFlags allowReservedWordsAsSelectors == true ifTrue:[
        tokenType == #Self ifTrue:[^true].
        tokenType == #Nil ifTrue:[^true].
        tokenType == #True ifTrue:[^true].
        tokenType == #False ifTrue:[^true].
        tokenType == #Super ifTrue:[^true].
        tokenType == #ThisContext ifTrue:[^true].
    ].
    ^ false

    "
     ParserFlags allowReservedWordsAsSelectors:true.
     1234 self.

     ParserFlags allowReservedWordsAsSelectors:false
     1234 self.
    "

    "
     1234 self
     1234 nil
     1234 true
     1234 false
     1234 here
     1234 super
     1234 thisContext
    "
!

makeImmutableArray:anArray
    ^ self class makeImmutableArray:anArray
!

makeImmutableString:aString
    ^ self class makeImmutableString:aString
!

makeReferenceFor:aNode
    "/ variable references (&var)
    "/ EXPERIMENTAL - may be in next release

    |rec sel indexNode contextNode arg1 arg2|

    contextNode := VariableNode type:#ThisContext context:contextToEvaluateIn.
    indexNode := ConstantNode type:#Integer value:aNode index.

    aNode isArgument ifTrue:[
        sel := #forArgument:in:.
        arg1 := indexNode.
        arg2 := contextNode.
    ] ifFalse:[
        aNode isLocal ifTrue:[
            sel := #forLocal:in:.
            arg1 := indexNode.
            arg2 := contextNode.
        ] ifFalse:[
            self parseError:'unsupported variable reference (must be local or argument)'.
            ^ aNode
        ]
    ].

    parseForCode ifFalse:[self rememberGlobalUsed:'Reference'].
    rec := VariableNode globalNamed:'Reference'.

    ^ MessageNode receiver:rec selector:sel arg1:arg1 arg2:arg2.

    "Modified (comment): / 30-09-2011 / 12:20:08 / cg"
!

markUnreachableCodeAsCommentIn:expr
    |sel constVal receiver args|

    expr isMessage ifFalse:[
        "take care (ignore) for unreachable constants which do not have a selector"
        ^ self
    ].

    sel := expr selector.
    receiver := expr receiver.
    args:= expr args.

    "/ look for true ifTrue / false ifFalse and mark as comment
    (sel = #ifTrue:
    or:[sel = #ifFalse:
    or:[sel = #ifTrue:ifFalse:
    or:[sel = #ifFalse:ifTrue:]]]) ifTrue:[
        (receiver withConstantValueDo:[:val | constVal := val]) ifTrue:[
            |indexOfArgNotExecuted|

            "/ receiver evaluates to a constant
            constVal == true ifTrue:[
                indexOfArgNotExecuted := (sel startsWith: #ifFalse:) ifTrue:[1] ifFalse:[2]
            ].
            constVal == false ifTrue:[
                indexOfArgNotExecuted := (sel startsWith: #ifTrue:) ifTrue:[1] ifFalse:[2]
            ].
            indexOfArgNotExecuted == 2 ifTrue:[
                args size == 1 ifTrue:[ indexOfArgNotExecuted := nil]
            ].

            indexOfArgNotExecuted notNil ifTrue:[
                |argIsNotExecuted|

                "/ self warning:'receiver is constant; arg',indexOfArgNotExecuted printString,' is never executed' position:pos1 to:tokenPosition.
                argIsNotExecuted := expr args at:indexOfArgNotExecuted.
                argIsNotExecuted realNode isBlockNode ifTrue:[
                    self markCommentFrom:argIsNotExecuted startPosition to:argIsNotExecuted endPosition.
                ].
            ].
        ].
    ].
!

noAssignmentAllowed:eMsg at:pos
    ((tokenType == $_) or:[tokenType == #':=']) ifTrue:[
        self parseError:eMsg position:pos to:tokenPosition + tokenType size - 1.
        self isSyntaxHighlighter ifFalse:[
            ^ false
        ].
        self nextToken. "/ eat the assign when doing highlighting only
    ].
    ^ true
!

nodeForMethodArg:varName
    |varIndex var|

    methodArgNames isNil ifTrue:[^ nil].
    varIndex := methodArgNames indexOf:varName.
    varIndex == 0 ifTrue:[^ nil].

    var := methodArgs at:varIndex.
"/    var used:true.
    ^ (VariableNode type:#MethodArg
                   name:varName
                  token:var
                  index:varIndex)
        startPosition: tokenPosition endPosition: tokenPosition + varName size - 1

    "Modified: / 21-08-2011 / 07:58:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nodeForMethodVariable:varName
    |varIndex var|

    methodVarNames isNil ifTrue:[^ nil].
    varIndex := methodVarNames indexOf:varName.
    varIndex == 0 ifTrue:[^ nil].

    var := methodVars at:varIndex.
    var used:true.
    parseForCode ifFalse:[self rememberLocalUsed:varName].
    ^ (VariableNode type:#MethodVariable
                   name:varName
                  token:var
                  index:varIndex)
        startPosition: tokenPosition endPosition: tokenPosition + varName size - 1

    "Modified: / 25-08-2011 / 11:42:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

plausibilityCheck:aNode
    |note rcvr|

    note := aNode plausibilityCheckIn:self.
    note isNil ifTrue:[
        aNode isMessage ifTrue:[
            (contextToEvaluateIn isNil and:[selfValue isNil]) ifTrue:[    "/ do not check this for doits
                rcvr := aNode receiver.
                (rcvr isSuper and:[rcvr isHere not]) ifTrue:[
                    aNode selector ~= selector ifTrue:[
                        didWarnAboutBadSupersend ifFalse:[
                            didWarnAboutBadSupersend := true.
                            note := 'possible bad super message ? (selector should usually be the same as in current method)'.
                        ]
                    ].
                ].
            ].
        ].
    ].
    note isNil ifTrue:[ ^ nil].
    ^ note withCRs

    "Modified: / 26-10-2010 / 10:21:18 / cg"
!

selfNode

    "/JV@2011-07-19: Changed not to share the nodes

    ^ SelfNode value:selfValue

"/    Old code
"/    selfNode isNil ifTrue:[
"/        selfNode := SelfNode value:selfValue
"/    ].
"/    ^ selfNode

    "Modified: / 19-07-2011 / 17:22:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Parser methodsFor:'queries'!

annotationInfo
    "return the annotations - if any - in a format usable for source analysis
     (i.e. with start and stop positions)
     valid only after parsing"

    ^ annotations
!

annotations
    "return the annotations - if any - in the format stored in a method
     (i.e. as an array or 2-element key-argument arrays).
     valid only after parsing"

    annotations isNil ifTrue:[^ nil].
    "/ present them in the old format (arrays)
    ^ annotations collect:[:each | Array with:each key with:each arguments ].
!

argumentCount
    "return the number of methodargs (valid after parsing spec)"

    ^ methodArgs size

    "Created: / 09-06-2015 / 21:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classToLookForClassVars
    "helper - return the class to look for classVars.
     If there is a context in which we evaluate, the
     methods implementing class is used instead of the
     class of the receiver."

    |m who|

    contextToEvaluateIn notNil ifTrue:[
        m := contextToEvaluateIn method.
        m notNil ifTrue:[
            who := contextToEvaluateIn method who.
            who notNil ifTrue:[
                ^ who methodClass.
            ]
        ].
        "/ mhmh - might be a doIt ...
    ].
    ^ classToCompileFor

    "Created: / 18.6.1998 / 15:43:42 / cg"
    "Modified: / 21.7.1998 / 18:19:52 / cg"
!

classesClassInstVarNames
    "caching allInstVarNames for next compilation saves time ..."

    |names|

    [
        |cls|

        cls := self classToLookForClassVars.
        (PrevClassInstVarNames isNil or:[PrevClass ~~ cls]) ifTrue:[
            PrevClass notNil ifTrue:[
                PrevClass removeDependent:Parser
            ].
            PrevClass := cls.

            PrevClassInstVarNames := cls class allInstVarNames.
            PrevClass addDependent:Parser.
        ].
        names := PrevClassInstVarNames.
    ] valueUninterruptably.
    ^ names

    "Created: / 14.10.1996 / 18:03:35 / cg"
    "Modified: / 18.6.1998 / 15:44:41 / cg"
!

classesClassVarNames
    "caching allClassVarNames for next compilation saves time ..."

    |names|

    [
        |cls aClass|

        cls := self classToLookForClassVars.

        (PrevClassVarNames isNil or:[PrevClass ~~ cls]) ifTrue:[
            PrevClass notNil ifTrue:[
                PrevClass removeDependent:Parser
            ].
            aClass := PrevClass := cls.
            aClass isMeta ifTrue:[
                aClass := aClass soleInstance.
                aClass isNil ifTrue:[
                    aClass := classToCompileFor
                ]
            ].
            PrevClassVarNames := aClass allClassVarNames.
            PrevClass addDependent:Parser.
        ].
        names := PrevClassVarNames.
    ] valueUninterruptably.
    ^ names

    "Modified: / 17.6.1996 / 17:15:53 / stefan"
    "Created: / 14.10.1996 / 18:02:41 / cg"
    "Modified: / 18.6.1998 / 15:44:30 / cg"
!

classesInstVarNames
    "caching allInstVarNames for next compilation saves time ..."

    |names|

    [
        (PrevInstVarNames isNil or:[PrevClass ~~ classToCompileFor]) ifTrue:[
            PrevClass notNil ifTrue:[
                PrevClass removeDependent:Parser
            ].
            PrevClass := classToCompileFor.
            PrevInstVarNames := classToCompileFor allInstVarNames.
            PrevClassInstVarNames := nil.
            PrevClassVarNames := nil.
            PrevClass addDependent:Parser
        ].
        names := PrevInstVarNames
    ] valueUninterruptably.

    ^ names

    "Created: 14.10.1996 / 18:00:26 / cg"
!

contextMustBeReturnable
    "/ misusing/misinterpreting the lineNumberInfo flag is a q&d hack; there should be an extra flag
    ^ (parserFlags fullLineNumberInfo)
    or:[ primitiveContextInfo notNil
         and:[ primitiveContextInfo includes:('context:' -> #return) ]]

    "Modified: / 26-09-2012 / 14:15:33 / cg"
!

didWarnAboutSqueakExtensions
    ^ didWarnAboutSqueakExtensions ? false
!

doItSelector
    "the name of the method used for doit's.
     The method will not be installed, but called directly,
     so the name is more or less arbitrary."

    ^ #'doIt'

    "Created: / 21-11-2016 / 23:58:43 / cg"
!

hasNonOptionalPrimitiveCode
    "return true if there was any ST/X style primitive code (valid after parsing)"

    ^ hasNonOptionalPrimitiveCode
!

hasPrimitiveCode
    "return true if there was any ST/X style primitive code (valid after parsing)"

    ^ hasPrimitiveCode
!

isCompiling
    "return true if compiling code as opposed to evaluating"

    ^ false
!

isDoIt
    ^ selector == self doItSelector

    "Modified: / 22-11-2016 / 00:00:10 / cg"
!

isEmptyMethod
    "return true (after a parse) if this is an empty (documentation) method"

    ^ tree isNil
!

isSyntaxHighlighter
    ^ false
!

methodArgs
    "return an array with methodarg names (valid after parsing spec)"

    ^ methodArgNames
!

methodVars
    "return a collection with method variablenames (valid after parsing)"

    ^ methodVarNames
!

numberOfMethodArgs
    "return the number of methodargs (valid after parsing spec)"

    ^ methodArgs size
!

numberOfMethodVars
    "return the number of method variables (valid after parsing)"

    ^ methodVars size
!

selector
    "return the selector (valid after parsing spec)"

    ^ selector
!

shouldPerformCodingStyleChecks
    ^ ignoreWarnings not and:[ self isCompiling ]
!

whichClassIncludesClassVar:aVariableName
    "helper: find the class in which a class variable is defined"

    |cls|

    cls := self classToLookForClassVars.
    cls isMeta ifTrue:[
        cls := cls soleInstance.
        cls isNil ifTrue:[
            cls := classToCompileFor
        ]
    ].
    ^ cls whichClassDefinesClassVar:aVariableName

    "Created: / 05-10-2011 / 15:23:24 / az"
! !

!Parser methodsFor:'queries-statistic'!

messagesPossiblySent
    "return a collection with possible message selectors (valid after parsing).
     Includes things known or possibly used with #perform: or in specs.
     The returned collection is filled by heuristics, not sharp, exact"

    |msgs|

    msgs := Set withAll:((messagesPossiblySent ? #()) collect:[:each | each asSymbol]).

    usedSymbols notEmptyOrNil ifTrue:[
        "/ add the ones we know have implementations
        "/ (the above have been added unconditionally)

        Smalltalk allClassesDo:[:cls |
            cls instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                (usedSymbols includes:sel) ifTrue:[
                    msgs add:sel.
                ].
            ]
        ].
    ].
    ^ msgs
!

messagesSent
    "return a collection with sent message selectors (valid after parsing).
     Includes all sent messages (i.e. also sent super messages)"

    ^ (messagesSent ? #()) collect:[:each | each asSymbol]
!

messagesSentToSelf
    "return a collection with message selectors sent to self only (valid after parsing)"

    ^ (messagesSentToSelf ? #()) collect:[:each | each asSymbol]
!

messagesSentToSuper
    "return a collection with message selectors sent to super only (valid after parsing)"

    ^ (messagesSentToSuper ? #()) collect:[:each | each asSymbol]
!

modifiedClassVars
    "return a collection with classvariablenames modified by method (valid after parsing)"

    ^ modifiedClassVars ? #()

    "Modified: 19.6.1997 / 17:54:48 / cg"
!

modifiedGlobals
    "return a collection with globalnames modified by method (valid after parsing)"

    ^ modifiedGlobals ? #()

    "Modified: 19.6.1997 / 17:54:51 / cg"
!

modifiedInstVars
    "return a collection with instvariablenames modified by method (valid after parsing)"

    ^ modifiedInstVars ? #()

    "Modified: 19.6.1997 / 17:54:27 / cg"
!

modifiedPoolVars
    "return a collection with pool variable names modified by method (valid after parsing)"

    ^ modifiedPoolVars ? #()

    "Modified: 19.6.1997 / 17:54:48 / cg"
!

readClassVars
    "return a collection with classvariablenames read by method (valid after parsing)"

    ^ readClassVars ? #()

    "Modified: 19.6.1997 / 17:54:38 / cg"
!

readGlobals
    "return a collection with global varNames read by method (valid after parsing)"

    ^ readGlobals ? #()

    "Modified: 19.6.1997 / 17:54:38 / cg"
!

readInstVars
    "return a collection with instvariablenames read by method (valid after parsing)"

    ^ readInstVars ? #()

    "Modified: 19.6.1997 / 17:54:38 / cg"
!

readPoolVars
    "return a collection with pool var names read by method (valid after parsing)"

    ^ readPoolVars ? #()

    "Modified: 19.6.1997 / 17:54:38 / cg"
!

sendsSelector:selectorString
    ^ (messagesSent ? #()) includes:selectorString

    "Created: / 30-08-2017 / 16:01:03 / cg"
!

usedClassVars
    "return a collection with classvariablenames refd by method (valid after parsing)"

    ^ usedClassVars ? #()

    "Modified: 19.6.1997 / 17:54:56 / cg"
!

usedGlobals
    "return a collection with globalnames refd by method (valid after parsing)"

    ^ usedGlobals ? #()

    "Modified: 19.6.1997 / 17:55:00 / cg"
!

usedInstVars
    "return a collection with instvariablenames refd by method (valid after parsing)"

    ^ usedInstVars ? #()

    "Modified: 19.6.1997 / 17:54:38 / cg"
!

usedPoolVars
    "return a collection with pool variable names refd by method (valid after parsing)"

    ^ usedPoolVars ? #()

    "Modified: 19.6.1997 / 17:54:56 / cg"
!

usedSymbols
    "return a collection with used symbols (except for sent messages) (valid after parsing)"

    ^ (usedSymbols ? #())
!

usedVars
    "return a collection with variablenames refd by method (valid after parsing)"

    ^ usedVars ? #()

    "Modified: 19.6.1997 / 17:55:04 / cg"
!

usesSuper
    "return true if the parsed method uses super (valid after parsing)"

    ^ usesSuper
! !

!Parser methodsFor:'setup'!

arraysAreImmutable
    ^ parserFlags arraysAreImmutable
!

arraysAreImmutable:aBoolean
    parserFlags arraysAreImmutable:aBoolean.
!

classToCompileFor
    ^ classToCompileFor

    "Created: / 15.11.2001 / 17:21:10 / cg"
!

foldConstants:aSymbolOrNil
    "change the constant folding level. See the classMethod for a description."

    foldConstants := aSymbolOrNil

    "Created: 21.3.1996 / 16:03:22 / cg"
    "Modified: 21.3.1996 / 16:05:04 / cg"
!

initialize
    "/ <modifier: #super> "must be called if redefined"

    super initialize.

    hasPrimitiveCode := hasNonOptionalPrimitiveCode := false.
    usesSuper := false.
    parseForCode := false.
    allowUndeclaredVariables := true.
    foldConstants := FoldConstants.
    parenthesisLevel := 0.

    didWarnAboutSTXNameSpaceUse := false.
    didWarnAboutSTXHereExtensionUsed := false.
    didWarnAboutBadSupersend := false.

    annotations := #().

    "Modified: / 01-07-2010 / 12:03:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2017 / 15:03:29 / cg"
!

parseForCode
    "turns off certain statistics (keeping referenced variables, modified vars etc.)
     Use this when parsing for compilation or evaluation"

    parseForCode := true
!

setClassToCompileFor:aClass
    "set the class to be used for parsing/evaluating"

    classToCompileFor := aClass.
    (classToCompileFor ~~ PrevClass) ifTrue:[
        PrevClass notNil ifTrue:[
            Parser update:PrevClass
        ]
    ]
!

setContext:aContext
    "set the context used while evaluating"

    contextToEvaluateIn := aContext
!

setSelf:anObject
    "set the value to be used for self while evaluating"

    selfValue := anObject.
    classToCompileFor := anObject class.
    (classToCompileFor ~~ PrevClass) ifTrue:[
        PrevClass notNil ifTrue:[
            Parser update:PrevClass
        ]
    ]
!

stringsAreImmutable
    ^ parserFlags stringsAreImmutable.
!

stringsAreImmutable:aBoolean
    parserFlags stringsAreImmutable:aBoolean.
!

warnAboutMissingMethodComment
    ^ parserFlags warnAboutMissingMethodComment

    "Created: / 17-07-2010 / 14:39:46 / cg"
!

warnUndeclared
    ^ parserFlags warnUndeclared

    "Created: 7.9.1997 / 02:05:00 / cg"
!

warnUndeclared:aBoolean
    parserFlags warnUndeclared:aBoolean.

    "Created: 7.9.1997 / 02:05:00 / cg"
!

warnUnusedVars
    ^ parserFlags warnUnusedVars
!

warnUnusedVars:aBoolean
    parserFlags warnUnusedVars:aBoolean.
! !

!Parser methodsFor:'statistic'!

rememberClassVarModified:name
    modifiedClassVars isNil ifTrue:[
        modifiedClassVars := Set new
    ].
    modifiedClassVars add:name.
    self rememberClassVarUsed:name
!

rememberClassVarRead:name
    readClassVars isNil ifTrue:[
        readClassVars := Set new
    ].
    readClassVars add:name.
    self rememberClassVarUsed:name
!

rememberClassVarUsed:name
    usedClassVars isNil ifTrue:[
        usedClassVars := Set new
    ].
    usedClassVars add:name.
    self rememberVariableUsed:name
!

rememberGlobalModified:name
    modifiedGlobals isNil ifTrue:[
        modifiedGlobals := Set new
    ].
    modifiedGlobals add:name.
    self rememberGlobalUsed:name.
!

rememberGlobalRead:name
    readGlobals isNil ifTrue:[
        readGlobals := Set new
    ].
    readGlobals add:name.
    self rememberGlobalUsed:name
!

rememberGlobalUsed:name
    usedGlobals isNil ifTrue:[
        usedGlobals := Set new
    ].
    usedGlobals add:name.
    self rememberVariableUsed:name
!

rememberInstVarModified:name
    modifiedInstVars isNil ifTrue:[
        modifiedInstVars := Set new
    ].
    modifiedInstVars add:name.
    self rememberInstVarUsed:name.
!

rememberInstVarRead:name
    readInstVars isNil ifTrue:[
        readInstVars := Set new
    ].
    readInstVars add:name.
    self rememberVariableUsed:name
!

rememberInstVarUsed:name
    usedInstVars isNil ifTrue:[
        usedInstVars := Set new
    ].
    usedInstVars add:name.
    self rememberVariableUsed:name
!

rememberLocalModified:name
    modifiedLocalVars isNil ifTrue:[
        modifiedLocalVars := Set new.
    ].
    modifiedLocalVars add:name.
    self rememberLocalUsed:name
!

rememberLocalUsed:name
    usedLocalVars isNil ifTrue:[
        usedLocalVars := Set new
    ].
    usedLocalVars add:name.

!

rememberPoolVarModified:name
    modifiedPoolVars isNil ifTrue:[
        modifiedPoolVars := Set new
    ].
    modifiedPoolVars add:name.
    self rememberPoolVarUsed:name.
!

rememberPoolVarRead:name
    readPoolVars isNil ifTrue:[
        readPoolVars := Set new
    ].
    readPoolVars add:name.
    self rememberPoolVarUsed:name
!

rememberPoolVarUsed:name
    usedPoolVars isNil ifTrue:[
        usedPoolVars := Set new
    ].
    usedPoolVars add:name.
    self rememberVariableUsed:name
!

rememberReturnedValue:anExpressionNode
    |expr|

    returnedValues isNil ifTrue:[returnedValues := Set new].

    expr := anExpressionNode.
    expr isAssignment ifTrue:[
        expr := expr expression.
    ].
    (expr notNil and:[expr isConstant or:[expr isSelf]]) ifTrue:[
        returnedValues add:expr
    ].

    "Modified: / 14-07-2017 / 10:43:43 / cg"
!

rememberSelectorPossiblyUsed:sel
    messagesPossiblySent isNil ifTrue:[
        messagesPossiblySent := IdentitySet new.
    ].
    messagesPossiblySent add:sel
!

rememberSelectorUsed:sel
    messagesSent isNil ifTrue:[
        messagesSent := Set new.
    ].
    messagesSent add:sel
!

rememberSelectorUsed:selectorArg receiver:receiverNode
    |sel|

    self isSyntaxHighlighter ifTrue:[
        sel := selectorArg asSymbolIfInterned ? selectorArg.
    ] ifFalse:[    
        "/ cg: thought this was a good idea;
        "/ but currently breaks changesBrowser.
        "/ sel := selectorArg asSymbolIfInterned ? selectorArg.
        
        "/ mhm - need to fix changesBrowser,
        "/ because otherwise, the selectorcheck fails.
        sel := selectorArg "asSymbol".
    ].
    self rememberSelectorUsed:sel.

    receiverNode isSuper ifTrue:[
        self rememberSelectorUsedInSuperSend:sel
    ] ifFalse:[
        receiverNode isSelf ifTrue:[
            self rememberSelectorUsedInSelfSend:sel
        ].
    ].

    "Modified: / 30-08-2017 / 15:54:26 / cg"
!

rememberSelectorUsed:selectorArg receiver:receiverNode args:args
    "TODO: the heuristics below could be made more
     flexible by annotating methods which do a perform somehow,
     and then asking implementors of selectorArg..."

    |selPerformed sel arg1|

    sel := selectorArg asSymbol.
    self rememberSelectorUsed:sel receiver:receiverNode.

    parseForCode ifFalse:[
        (arg1 := args first) isConstant ifTrue:[
            (selPerformed := arg1 value) isSymbol ifTrue:[
                "/ for messages we know will do a perform, also remember in
                "/ the possiblySent messages.
                (
                    #( 'perform:'
                       'askFor:'
                    ) contains:[:prefix | sel startsWith:prefix]
                ) ifTrue:[
                    self rememberSelectorUsed:selPerformed
                ] ifFalse:[
                    (
                        #(
                           'pushEvent:'
                           'pushUserEvent:'
                           'enqueueMessage:'
                           "/ new: knowing that symbol responds to value:
                           'do:'
                           'select:'
                           'collect:'
                           'reject:'
                           'detect:'
                           'map:'
                           'findFirst:'
                           'contains:'
                           'flatDo:'
                           'flatDetect:'
                        ) contains:[:prefix | sel startsWith:prefix]
                    ) ifTrue:[
                        self rememberSelectorPossiblyUsed:selPerformed
                    ]
                ]
            ]
        ].
    ].

    "Modified (format): / 30-07-2013 / 15:48:37 / cg"
!

rememberSelectorUsedInSelfSend:sel
    messagesSentToSelf isNil ifTrue:[
        messagesSentToSelf := Set new.
    ].
    messagesSentToSelf add:sel

    "Modified: / 30-08-2017 / 15:51:35 / cg"
!

rememberSelectorUsedInSuperSend:sel
    messagesSentToSuper isNil ifTrue:[
        messagesSentToSuper := Set new.
    ].
    messagesSentToSuper add:sel

    "Modified: / 30-08-2017 / 15:51:19 / cg"
!

rememberSymbolUsed:aSymbol
    usedSymbols isNil ifTrue:[
        usedSymbols := IdentitySet new.
    ].
    usedSymbols add:aSymbol.
!

rememberVariableUsed:name
    usedVars isNil ifTrue:[
        usedVars := Set new
    ].
    usedVars add:name
! !

!Parser::AskForVariableTypeOfUndeclaredQuery class methodsFor:'documentation'!

documentation
"
    can be used to redefine the list of offered veriable types in a correct-variable
    operation (for now, this is only done in expecco).
"
! !

!Parser::AskForVariableTypeOfUndeclaredQuery methodsFor:'accessing'!

classToCompileFor
    ^ parser classToCompileFor

    "Modified: / 20-10-2010 / 18:27:29 / cg"
!

nameOfUnknownVariable
    ^ nameOfUnknownVariable
!

parser
    ^ parser

    "Created: / 20-10-2010 / 18:27:24 / cg"
!

parser:parserArg nameOfUnknownVariable:nameOfUnknownVariableArg
    parser := parserArg.
    nameOfUnknownVariable := nameOfUnknownVariableArg.

    "Created: / 20-10-2010 / 18:27:40 / cg"
! !

!Parser::AskForVariableTypeOfUndeclaredQuery methodsFor:'default action'!

defaultAction
    "the default action is to open a popupmenu asking for the variable type"

    |list|

    list := self listOfPossibleVariableTypes.
    ^ self startUpMenuAskingForVariableTypeFromList:list.

    "Modified: / 20-10-2010 / 18:52:30 / cg"
!

listOfPossibleVariableTypes
    "the default action is to open a popupmenu asking for the variable type"

    |list varNameIsLowercase classToCompileFor|

    list := OrderedCollection new.

    classToCompileFor := self classToCompileFor.
    "/ do not change to isLowercase because of $_ as first char!!
    varNameIsLowercase := nameOfUnknownVariable isUppercaseFirst not.

    "/ BlockVar, InstVar and classInstVar not yet implemented
    varNameIsLowercase ifTrue:[
"/            currentBlock notNil ifTrue:[
"/                list add: #BlockVariable.
"/            ].
        parser selector notNil ifTrue:[
            list add: #MethodVariable.
        ].
        (classToCompileFor notNil
        and:[classToCompileFor isMeta not
        and:[classToCompileFor isBuiltInClass not
        and:[classToCompileFor theNonMetaclass isSharedPool not
        and:[(parser isDoIt not)]]]]) ifTrue:[
            list add: #InstanceVariable.
        ].
    ] ifFalse:[
        list addAll: #( NewClass GlobalVariable NameSpace ).

        (classToCompileFor notNil
        and:[parser isDoIt not]) ifTrue:[
            classToCompileFor isBuiltInClass ifFalse:[
                classToCompileFor isMeta ifTrue:[
                    list add: #ClassInstanceVariable.
                ].
            ].
            (classToCompileFor notNil and:[ classToCompileFor theNonMetaclass isSharedPool]) ifTrue:[
                list addAllFirst: #( #ClassVariable nil ).
            ] ifFalse:[   
                list addAll: #( #ClassVariable #PrivateClass ).
            ]
        ]
    ].

    parser isDoIt ifTrue:[
        list notEmpty ifTrue:[
            list add: nil.
        ].
        list addAll: #( WorkspaceVariable DoItTemporary ).
    ].

    ^ list

    "Modified (comment): / 21-06-2017 / 22:08:06 / cg"
!

startUpMenuAskingForVariableTypeFromList:list
    "start the popup menu; return the chosen type-symbol or nil"

    |valueList menuLabels popupMenu choiceIndex typeChoice|

    list notEmptyOrNil ifTrue:[
        menuLabels := self userfriendlyMenuItemNameListFor:list.

        menuLabels := (Array
                        with:('Declare %1 as:' bindWith: nameOfUnknownVariable allBold)
                        with:'-'
                      ) , menuLabels.
        valueList := #(nil nil) , list.
        popupMenu := PopUpMenu labels:menuLabels.

        choiceIndex := popupMenu startUp.
        (choiceIndex notNil and:[choiceIndex > 0]) ifTrue:[
            typeChoice := valueList at:choiceIndex.
        ].
    ].

    ^ typeChoice

    "Created: / 20-10-2010 / 18:52:10 / cg"
!

userfriendlyMenuItemNameFor:varType
    varType = #BlockVariable ifTrue:[
        ^ 'Block Local'
    ].
    varType = #MethodVariable ifTrue:[
        ^ 'Method Local Variable'
    ].
    varType = #InstanceVariable ifTrue:[
        ^ 'Instance Variable'
    ].
    varType = #NewClass ifTrue:[
        ^ 'New Class'
    ].
    varType = #GlobalVariable ifTrue:[
        ^ 'Global'
    ].
    varType = #NameSpace ifTrue:[
        ^ 'NameSpace'
    ].
    varType = #ClassInstanceVariable ifTrue:[
        ^ 'Class Instance Variable'
    ].
    varType = #ClassVariable ifTrue:[
        (self classToCompileFor notNil and:[self classToCompileFor theNonMetaclass isSharedPool]) ifTrue:[
            ^ 'Class Variable (= Pool Constant)'
        ].
        ^ 'Class Variable'
    ].
    varType = #PrivateClass ifTrue:[
        ^ 'Private Class'
    ].
    varType = #WorkspaceVariable ifTrue:[
        ^ 'Workspace Variable'
    ].
    varType = #DoItTemporary ifTrue:[
        ^ 'DoIt Temporary'
    ].
    varType isNil ifTrue:[
        ^ '-'
    ].
    ^ varType

    "Created: / 20-10-2010 / 18:46:17 / cg"
    "Modified: / 29-01-2011 / 11:13:11 / cg"
!

userfriendlyMenuItemNameListFor:listOfPossibleVariableTypes
    |list stx_libtool resources|

    list := listOfPossibleVariableTypes
                                collect:[:varType | self userfriendlyMenuItemNameFor:varType].

        stx_libtool := Smalltalk at:#stx_libtool.
        stx_libtool notNil ifTrue:[
            resources := stx_libtool classResources.
                resources notNil ifTrue:[
                        list := list collect:[:s | resources string:s]
                ]
        ].
    ^ list

    "Created: / 20-10-2010 / 18:42:13 / cg"
    "Modified (format): / 30-03-2016 / 02:54:30 / cg"
! !

!Parser::Correction class methodsFor:'documentation'!

documentation
"
    a new correction scheme.

    Previously, there were only 2 hardcoded interactive corrections possible when
    the compiler had a correctbleError to report (declare as and correct).
    The use was asked via the correctableError: message (to the requestor),
    which had to return a symbol.

    Now, we move to a more flexible correction scheme, where the parser provides a list
    of plausible corrections as a collection of operations (actually class instances),
    which provide button labels (and possibly addition information in the future).

    Also, the correction object is supposed (in the future) to do the correction, so those
    operations are to be moved out of the compiler.
"
! !

!Parser::Correction class methodsFor:'instance creation'!

instance
    ^ self new
! !

!Parser::Correction class methodsFor:'queries'!

buttonLabel
    self subclassResponsibility
! !

!Parser::Correction methodsFor:'accessing'!

buttonLabel
    ^ self class buttonLabel
! !

!Parser::Correction methodsFor:'correcting'!

fixFrom:position1 to:position2 for:aCompiler
    "to be redefined by subclasses.
     should return corrected source or nil"

    self breakPoint:#cg.
    Dialog warn:'Sorry - no correction possible/implemented in ',self class nameWithoutPrefix.
    ^ nil
! !

!Parser::Correction methodsFor:'ignored accessing'!

positionOfPeriod:ignored
!

receiverClass:ignoredClass
!

receiverNode:ignoredNode
!

selector:ignoredSelector
! !

!Parser::Correction methodsFor:'instance creation'!

instance
    ^ self
! !

!Parser::CorrectByDeclaringIdentifierAs class methodsFor:'documentation'!

documentation
"
    a new correction scheme
"
! !

!Parser::CorrectByDeclaringIdentifierAs class methodsFor:'queries'!

buttonLabel
    ^ 'Declare As...'
! !

!Parser::CorrectByDeclaringIdentifierAs methodsFor:'fixing'!

fixFrom:pos1 to:pos2 for:aCompiler

self halt.
! !

!Parser::CorrectByDeclaringIdentifierAs methodsFor:'queries'!

buttonLabel
    lastType isNil ifTrue:[
        ^ self class buttonLabel
    ].
    ^ 'Declare as ',lastType.
! !

!Parser::CorrectByDeletingLocalIdentifier class methodsFor:'queries'!

buttonLabel
    ^ 'Remove Local'
! !

!Parser::CorrectByDeletingLocalIdentifier methodsFor:'fixing'!

fixFrom:pos1 to:pos2 for:aCompiler
    |source varName|

    source := aCompiler currentSource.
    varName := source copyFrom:pos1 to:pos2.
    aCompiler deleteDefinitionOf:varName in:pos1 to:pos2.
"/ self halt.
    aCompiler class restartCompilationSignal raiseRequest.
! !

!Parser::CorrectByGeneratingMissingMethod class methodsFor:'queries'!

buttonLabel
    ^ 'Generate...'
! !

!Parser::CorrectByGeneratingMissingMethod methodsFor:'accessing'!

receiverNode:something
    receiverNode := something.
!

selector:something
    selector := something.
! !

!Parser::CorrectByGeneratingMissingMethod methodsFor:'correcting'!

fixFrom:pos1 to:pos2 for:aCompiler
    "an method needs to be defined"

    |classToGenerateCode suggestedClassToCompileFor privateClass
     className varName codeGeneratorClass codeGenerator|

    "/ todo: look for variables first and ask if setter/getter first,
    "/ so we can reduce the set of offered classes. Left as an excercise...

    suggestedClassToCompileFor := aCompiler classToCompileFor.

    receiverNode isSelf ifTrue:[
        classToGenerateCode := aCompiler classToCompileFor
    ] ifFalse:[
        receiverNode isSuper ifTrue:[
            classToGenerateCode := aCompiler classToCompileFor superclass
        ] ifFalse:[
            receiverNode isVariable ifTrue:[
                receiverNode name isUppercaseFirst ifTrue:[
                    receiverNode isGlobal ifTrue:[
                        classToGenerateCode := receiverNode evaluate.
                        classToGenerateCode isBehavior ifTrue:[
                            classToGenerateCode := classToGenerateCode theMetaclass.
                        ] ifFalse:[
                            classToGenerateCode := nil
                        ].
                    ] ifFalse:[
                        (privateClass := aCompiler classToCompileFor privateClassesAt:receiverNode name) notNil ifTrue:[
                            classToGenerateCode := privateClass theMetaclass.
                        ].
                    ]
                ]
            ] ifFalse:[
                (receiverNode isMessage
                and:[ receiverNode receiver isSelf
                and:[ receiverNode selector == #class]]) ifTrue:[
                    suggestedClassToCompileFor := aCompiler classToCompileFor theMetaclass
                ].
            ]
        ]
    ].

    true
    "/ (classToGenerateCode isNil
    "/     or:[ (classToGenerateCode superclass notNil
    "/          and:[ classToGenerateCode superclass ~~ Object
    "/          and:[ classToGenerateCode superclass isAbstract not]]) ])
    ifTrue:[
        className := Dialog
                        request:'Generate code in class:'
                        initialAnswer:(suggestedClassToCompileFor name)
                        okLabel:'OK'
                        title:('Generate code in class:')
                        onCancel:nil
                        list:(suggestedClassToCompileFor withAllSuperclasses collect:[:cls | cls name])
                        entryCompletionBlock:(DoWhatIMeanSupport classNameEntryCompletionBlock).

        className size == 0 ifTrue:[ ^ nil ].
        classToGenerateCode := Smalltalk classNamed:className.
        classToGenerateCode isNil ifTrue:[
            self warn:'Oops: No such class: ',className.
            ^ nil
        ].
    ].

    codeGeneratorClass := classToGenerateCode programmingLanguage codeGeneratorClass.
    codeGeneratorClass isNil ifTrue:[
        Dialog information:'sorry - no codegeneration facility for this class'.
        ^ nil.
    ].

    "do not overwrite an already existing method"
    (classToGenerateCode includesSelector:selector asSymbol) ifFalse:[
        |code wantInstCreator wantSetter wantGetter varNames lcVarNames|

        wantSetter := wantGetter := wantInstCreator := false.
        varNames := classToGenerateCode isMeta
                        ifTrue:[ classToGenerateCode theNonMetaclass classVarNames , classToGenerateCode instVarNames ]
                        ifFalse:[ classToGenerateCode instVarNames ].
        lcVarNames := varNames collect:[:nm | nm asLowercaseFirst].

        (selector isKeywordSelector
        and:[selector numArgs == 1
        and:[lcVarNames includes:(selector copyButLast:1)]]) ifTrue:[
            "/ want a setter ?
            varName := varNames at:(lcVarNames indexOf:(selector copyButLast:1)).
            wantSetter := Dialog confirmWithCancel:('Generate as setter for %1 ?' bindWith:varName allBold) default:true.
            wantSetter isNil ifTrue:[ AbortOperationRequest raise. "^ selector"].
        ] ifFalse:[
            (selector isUnarySelector
            and:[lcVarNames includes:selector]) ifTrue:[
                "/ want a getter ?
                varName := varNames at:(lcVarNames indexOf:selector).
                wantGetter := Dialog confirmWithCancel:('Generate as getter for %1 ?' bindWith:varName allBold) default:true.
                wantGetter isNil ifTrue:[AbortOperationRequest raise "^ selector"].
            ] ifFalse:[
                (selector isKeywordSelector
                    and:[ selector numArgs == 1
                    and:[ classToGenerateCode isMeta
                    and:[ classToGenerateCode theNonMetaclass instVarNames includes:(varName := selector copyButLast:1) ]]]
                ) ifTrue:[
                    wantInstCreator := Dialog confirmWithCancel:('Generate as initialized instance creator for %1?' bindWith:varName).
                    wantInstCreator isNil ifTrue:[AbortOperationRequest raise "^ selector"].
                ].
            ].
        ].

        "/ get the real name (UC if classvar)
        codeGenerator := codeGeneratorClass new.

        wantSetter ifTrue:[
            codeGenerator createSetterFor:varName in:classToGenerateCode.
        ] ifFalse:[
            wantGetter ifTrue:[
                codeGenerator createGetterFor:varName in:classToGenerateCode.
            ] ifFalse:[
                wantInstCreator ifTrue:[
                    codeGenerator createInstanceCreationMethodWithSetupFor:selector category:('instance creation') in:classToGenerateCode
                ] ifFalse:[
                    codeGenerator createShouldImplementMethodFor:selector category:nil in:classToGenerateCode.
                ].
            ]
        ]
    ].

    "/ return nil, so nothing is done in the compiler
    ^ nil
! !

!Parser::CorrectByGroupingMessage methodsFor:'accessing'!

buttonLabel
    possibleSplits size > 1 ifTrue:[
        ^ 'Correct by Grouping...'
    ].
    ^ 'Correct by Grouping (%1)' bindWith:possibleSplits first first
!

possibleSplits:something
    possibleSplits := something.
!

receiverNode:something
    receiverNode := something.
!

selectorPositions:something
    selectorPositions := something.
! !

!Parser::CorrectByGroupingMessage methodsFor:'correction'!

fixFrom:position1 to:position2 for:aCompiler
    "regroup a keyword message from:
        rcvr foo:a1 bar:a2 baz: a3
     into:
        rcvr foo:(a1 bar:a2 baz:a3)
    "

    |split source numParts1 source1 source2 newSource source3|

    possibleSplits size > 1 ifTrue:[
        split := Dialog
            choose:'Choose grouping:'
            fromList:(possibleSplits collect:[:split | split first,'(',split second,')'])
            values:possibleSplits
            lines:5.
        split isNil ifTrue:[^ nil].


    ] ifFalse:[
        split := possibleSplits first.
    ].

    source := aCompiler currentSource.
    numParts1 := split first partsIfSelector size.
    source := source string.
    source1 := source copyTo:(selectorPositions at:numParts1) stop.
    source2 := source copyFrom:(selectorPositions at:numParts1) stop+1 to:(receiverNode parent endPosition).
    source3 := source copyFrom:(receiverNode parent endPosition + 1).
    newSource := source1,'(',source2,')',source3.

    ^ newSource
! !

!Parser::CorrectByInsertingPeriod class methodsFor:'queries'!

buttonLabel
    ^ 'Insert "."'
! !

!Parser::CorrectByInsertingPeriod methodsFor:'accessing'!

positionOfPeriod:something
    positionOfPeriod := something.
! !

!Parser::CorrectByInsertingPeriod methodsFor:'fixing'!

fixFrom:pos1 to:pos2 for:aCompiler
    "a period (full stop) needs to be inserted"

    |source newSource|

    source := aCompiler currentSource.
    newSource := source copyWithAll:'.' insertedAfterIndex:positionOfPeriod.
    ^ newSource
! !

!Parser::CorrectByInteractiveCorrection class methodsFor:'documentation'!

documentation
"
    a new correction scheme
"
! !

!Parser::CorrectByInteractiveCorrection class methodsFor:'queries'!

buttonLabel
    ^ 'Correct...'
! !

!Parser::CorrectByInteractiveRename class methodsFor:'queries'!

buttonLabel
    ^ 'Rename...'
! !

!Parser::CorrectByInteractiveRename methodsFor:'correcting'!

fixFrom:pos1 to:pos2 for:aCompiler
    "an identifier needs to be renamed"

    |badName source newName node definingNode refactoring|

    source := aCompiler currentSource.
    badName := source copyFrom:pos1 to:pos2.

    (Smalltalk at:#RenameTemporaryRefactoring) isNil ifTrue:[
        [
            Smalltalk loadPackage: #'stx:goodies/refactoryBrowser/refactoring'
        ] on: PackageLoadError do:[:err |  
            Dialog warn:'Sorry - no refactoring support available'.
            ^ self
        ]
    ].

    node := DoWhatIMeanSupport
                findNodeForInterval:(pos1 to:pos2)
                in:source.
    node isNil ifTrue:[
        Dialog information:'Sorry - could not extract identifier node from the source'.
        ^ nil.
    ].
    node isVariable ifFalse:[
        Dialog information:'Huh - node is not a variable'.
        ^ nil.
    ].
    definingNode := node whoDefines: badName.
    definingNode isNil ifTrue: [
        Dialog information: badName , ' is not a temporary variable in the method'.
        ^ nil.
    ].

    newName := Dialog request:(Dialog resources string:'Rename "%1" to:' with:badName) initialAnswer:badName.
    newName isNil ifTrue:[
        AbortOperationRequest raise.
    ].
    (newName isEmpty or:[newName = badName]) ifTrue:[
        ^ nil
    ].

    refactoring := (Smalltalk at:#RenameTemporaryRefactoring)
                        renameTemporaryFrom:node sourceInterval
                        to:newName
                        in:nil
                        selector:nil.

    "/ refactoring oldName:badName.
    refactoring source:source.
    refactoring okToRenameAsKnownVariable:true.

    refactoring checkPreconditions.
    refactoring transform.
    ^ refactoring newSource

    "Modified: / 05-05-2016 / 00:23:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Parser::CorrectByMakingValidHexConstant class methodsFor:'queries'!

buttonLabel
    ^ 'Correct Hex Constant'
! !

!Parser::CorrectByMakingValidHexConstant methodsFor:'accessing'!

receiverNode:something
    receiverNode := something.
!

selector:something
    selector := something.
! !

!Parser::CorrectByMakingValidHexConstant methodsFor:'correcting'!

fixFrom:pos1 to:pos2 for:aCompiler
    "a selector needs to be changed in a message send"

    |source newSource|

    source := aCompiler currentSource string.

    newSource := (source copyTo:receiverNode startPosition - 1),'16r',(selector copyFrom:2),(source copyFrom:receiverNode parent selectorPosition + selector size).
    ^ newSource.
! !

!Parser::CorrectByChangingSelector class methodsFor:'queries'!

buttonLabel
    ^ 'Correct...'
! !

!Parser::CorrectByChangingSelector methodsFor:'accessing'!

receiverClass:something
    receiverClass := something.
!

receiverNode:something
    receiverNode := something.
!

selector:something
    selector := something.
! !

!Parser::CorrectByChangingSelector methodsFor:'correcting'!

fixFrom:pos1 to:pos2 for:aCompiler
    "a selector needs to be changed in a message send"

    |suggestedNames newSelector|

    suggestedNames := aCompiler findBestSelectorsFor:selector in:receiverClass.
    suggestedNames isEmptyOrNil ifTrue:[
        self information:'no good correction found'.
        ^ nil
    ].
    newSelector := aCompiler askForCorrection:'Correct Selector to: ' fromList:suggestedNames for:selector.
    newSelector isNil ifTrue:[AbortOperationRequest raise "^ aSelectorString"].

    newSelector = selector ifTrue:[^ nil].

    "
     tell requestor (i.e. CodeView) about the change
     this will update what the requestor shows.
    "
    aCompiler requestor textView undoableDo:[
        (aCompiler requestor selectionAsString startsWith:selector) ifFalse:[
            "/ must find out the selector position!!
            (receiverNode notNil
                and:[receiverNode parent notNil
                and:[receiverNode parent isMessage
                and:[receiverNode parent selector = selector ]]])
            ifTrue:[
                |positions endPos offset|

                aCompiler requestor unselect.

                offset := 0.
                positions := OrderedCollection withAll:receiverNode parent selectorPartPositions.
                endPos := positions last stop.
                newSelector partsIfSelector doWithIndex:[:part :index |
                    |oldPos2 startPos2 endPos2 oldLen newLen|

                    oldPos2 := positions firstIfEmpty:nil.
                    oldPos2 isNil ifTrue:[
                        "/ new selector has more parts
                        aCompiler requestor insertString:(' ',part,'arg') atCharacterPosition:receiverNode parent endPosition+offset+1.
                    ] ifFalse:[
                        "/ replace a selector part
                        startPos2 := oldPos2 start + offset.
                        endPos2 := oldPos2 stop + offset.
                        positions removeFirst.
                        oldLen := endPos2 - startPos2 + 1.
                        newLen := part size.
                        aCompiler requestor replaceFromCharacterPosition:startPos2 to:endPos2 with:part.
                        offset := offset + (newLen - oldLen).
                    ].
                ].
                positions notEmpty ifTrue:[
                    |indexOfArgToRemove|

                    indexOfArgToRemove := receiverNode parent arguments size - positions size + 1.
                    [positions notEmpty] whileTrue:[
                        |oldPos3 startPos3 endPos3 argExpr|

                        "/ any remaining (new selector has less parts than old)
                        oldPos3 := positions removeFirst.
                        "/ remove the selector
                        startPos3 := oldPos3 start + offset.
                        endPos3 := oldPos3 stop + offset.
                        aCompiler requestor deleteFromCharacterPosition:startPos3 to:endPos3.
                        offset := offset - (endPos3 - startPos3 + 1).
                        "/ remove the arg expression
                        argExpr := receiverNode parent arguments at:indexOfArgToRemove.
                        startPos3 := argExpr startPosition + offset.
                        endPos3 := argExpr endPosition + offset.
                        aCompiler requestor deleteFromCharacterPosition:startPos3 to:endPos3.
                        offset := offset - (endPos3 - startPos3 + 1).
                    ].
                ].
                aCompiler requestor cursorToCharacterPosition:endPos.
            ].
        ] ifTrue:[
            aCompiler requestor replaceSelectionBy:newSelector keepCursor:false.
        ].
    ] info:'correct selector'.

    "
     get the updated source-string
     which is needed, when we finally install the new method
    "
    ^ aCompiler requestor currentSourceCode.
! !

!Parser::ParsedAnnotation class methodsFor:'instance creation'!

key:key arguments:arguments
    ^ self new key:key arguments:arguments
! !

!Parser::ParsedAnnotation methodsFor:'accessing'!

arguments
    ^ arguments
!

arguments:something
    arguments := something.
!

endPosition
    ^ endPosition
!

key
    ^ key
!

key:something
    key := something.
!

key:keyArg arguments:argumentsArg
    key := keyArg.
    arguments := argumentsArg.
!

startPosition
    ^ startPosition
!

startPosition:startPostionArg endPosition:endPositionArg
    self assert: startPostionArg notNil.
    self assert: endPositionArg notNil.

    startPosition := startPostionArg.
    endPosition := endPositionArg.
! !

!Parser::ParsedAnnotation methodsFor:'backward compatibility'!

at:index
    "in older parser, annotations where kept as little 2-element arrays,
     holding the key at slot 1 and the arguments at slot 2.
     For backward compatibility, still provide this interface,
     but spit out a warning on the transcript.
     Users should rewrite their code."

    index == 1 ifTrue:[
        Transcript showCR:'Parser: old style use of parsed annotations. Please rewrite to use #key'.
        ^ key.
    ].
    index == 2 ifTrue:[
        Transcript showCR:'Parser: old style use of parsed annotations. Please rewrite to use #arguments'.
        ^ arguments.
    ].
    self error:'invalid index.'.
! !

!Parser::PossibleCorrectionsQuery class methodsFor:'documentation'!

documentation
"
    answered by the compile when a correctable error/warning is reported.
    Can be used by caller of the compiler to ask what type of correction is possible.
"
! !

!Parser::PossibleCorrectionsQuery methodsFor:'queries'!

defaultResumeValue
    "/ returning an instance here, so it can keep some state in case it is
    "/ reused (same for all)
    ^ { Parser correctByDeclaringIdentifierAs new . Parser correctByInteractiveCorrection }

    "
     Parser possibleCorrectionsQuery query
     Parser possibleCorrectionsQuery defaultResumeValue
    "
! !

!Parser::PrimitiveSpecParser methodsFor:'initialization'!

initialize
    super initialize.

    actionArray := actionArray copy.
    actionArray at:$" codePoint put:(actionArray at:$' codePoint).

    "Created: / 01-08-2006 / 14:39:24 / cg"
! !

!Parser::PrimitiveSpecParser methodsFor:'parsing'!

parseSTVExternalFunctionDeclarationFrom:aStream definitionType:definitionType lineNr:lineNr for:aParserOrNil
    "parses ST/V function declarations of the forms
        '<api: functionName argType1 .. argTypeN returnType>'
        '<ccall: functionName argType1 .. argTypeN returnType>'
        '<ole: [async] vFunctionIndex argType1 .. argTypeN returnType>'
    "

    |returnType functionName argTypes function virtualFunctionIndex isAsync|

    masterParser := aParserOrNil.

    self source:aStream.
    self nextToken.

    ((tokenType == #Identifier) and:[ token = 'async' ]) ifTrue:[
        self nextToken.
        isAsync := true
    ] ifFalse:[
        isAsync := false
    ].

    (definitionType = 'ole:') ifTrue:[
        (tokenType == #Integer) ifFalse:[
            self parseError:'virtual function number expected (got ' , token printString , ')'.
        ].
        virtualFunctionIndex := token.
        self nextToken.
    ] ifFalse:[
        (tokenType == #String) ifTrue:[
            functionName := tokenValue.
        ] ifFalse:[
            (tokenType == #Identifier) ifTrue:[
                functionName := token.
            ] ifFalse:[
                self parseError:'function identifier expected (got ' , token printString , ')'.
            ].
        ].
        self nextToken.

        functionName isValidSmalltalkIdentifier "isAlphaNumeric" ifFalse:[
            "/ mhm a newer squeak definition in the form 'extern void warning(char *s)'
            self parseError:'cannot (yet) parse new style squeak external functions'.
            ^ nil
        ].
    ].

    argTypes := OrderedCollection new.
    [ token notNil and:[ (token ~= '>') and:[ (tokenType ~~ #BinaryOperator) or:[tokenName ~= '>']]]] whileTrue:[
        argTypes add:(self typeMappingFor:token).
        self nextToken.
    ].
    returnType := argTypes last.
    argTypes := argTypes copyButLast:1.

    function := ExternalLibraryFunction
            name:(functionName ? virtualFunctionIndex)
            module:nil
            returnType:returnType
            argumentTypes:argTypes asArray.

    (definitionType = 'api:') ifTrue:[
        function beCallTypeAPI
    ] ifFalse:[
        (definitionType = 'ole:') ifTrue:[
            function beCallTypeOLE
        ] ifFalse:[
            function beCallTypeC
        ].
    ].
    isAsync ifTrue:[
        function beAsync
    ].
    ^ function

    "Created: / 01-08-2006 / 16:11:24 / cg"
    "Modified: / 25-09-2012 / 09:45:46 / cg"
!

parseSTXOrSqueakOrDolphinExternalFunctionDeclarationFrom:aStream definitionType:definitionType lineNr:lineNrArg for: aParserOrNil
    "parses squeak/dolphin function declarations of the forms
        '<stdcall: [virtual|nonVirtual][const][mustFree] returnType functionNameStringOrIndex argType1..argTypeN>'
        '<cdecl:   [virtual|nonVirtual][const][mustFree] returnType functionNameStringOrIndex argType1..argTypeN>'

        '<cdecl:   [async] [virtual|nonVirtual][const][mustFree] returnType functionNameStringOrIndex ( argType1..argTypeN ) module: moduleName >'
        '<apicall: [async] [virtual|nonVirtual][const][mustFree] returnType functionNameStringOrIndex ( argType1..argTypeN ) module: moduleName >'
    "

    |isVirtualCall isNonVirtualCall isAsyncCall isUnlimitedStack isConst mustFree scanningCallModifiers
    returnType functionName virtualFunctionIndex argTypes moduleName argType function
    parentized thisType|

    masterParser := aParserOrNil.
    isVirtualCall := isNonVirtualCall := isAsyncCall := isUnlimitedStack := isConst := mustFree := false.

    "/ self knownDefinitions:dictionaryOfTypesOrNil.
    self source:aStream.
    lineNr := lineNrArg.

    self nextToken.

    scanningCallModifiers := true.
    [scanningCallModifiers] whileTrue:[
        scanningCallModifiers := false.
        (tokenType == #Identifier) ifTrue:[
            (token = 'async') ifTrue:[
                self nextToken.
                isAsyncCall := true.
                scanningCallModifiers := true.
            ] ifFalse:[ (token = 'virtual') ifTrue:[
                self nextToken.
                isVirtualCall := true.
                scanningCallModifiers := true.
            ] ifFalse:[  (token = 'nonVirtual') ifTrue:[
                self nextToken.
                isNonVirtualCall := true.
                scanningCallModifiers := true.
            ] ifFalse:[  (token = 'unlimitedStack') ifTrue:[
                self nextToken.
                isUnlimitedStack := true.
                scanningCallModifiers := true.
            ] ifFalse:[  (token = 'const') ifTrue:[
                self nextToken.
                isConst := true.
                scanningCallModifiers := true.
            ] ifFalse:[  (token = 'mustFree') ifTrue:[
                self nextToken.
                mustFree := true.
                scanningCallModifiers := true.
            ]]]]]]
        ]
    ].

    returnType := self parseTypeSpec.

    isVirtualCall ifTrue:[
        tokenType ~~ #Integer ifTrue:[
            (masterParser ? self) ignorableParseError:'invalid cdecl - virtual function index expected'.
            ^ nil
        ].
        virtualFunctionIndex := token.
        self nextToken.
    ] ifFalse:[
        tokenType ~~ #String ifTrue:[
            (masterParser ? self) ignorableParseError:'invalid cdecl - functionName expected (as string)'.
            ^ nil
        ].
        functionName := token asSymbol.
        self nextToken.
    ].

    tokenType == $( ifTrue:[
        parentized := true.
        self nextToken.
    ] ifFalse:[
        parentized := false.
    ].

    argTypes := OrderedCollection new.
    [ tokenType == #EOF
      or:[ parentized and:[tokenType == $) ]] ] whileFalse:[
        argType := self parseTypeSpec.
        argTypes add:argType.
        (tokenType == $,
        or:[ tokenType == #BinaryOperator and:[token = ','] ]) ifTrue:[
            self nextToken
        ]
    ].
    tokenType == $) ifTrue:[
        self nextToken.
    ].

    ((tokenType == #Identifier and:[token = 'module'])
    or:[tokenType == #Keyword and:[ token = 'module:']]) ifTrue:[
        self nextToken.
        tokenType == $: ifTrue:[
            self nextToken.
        ].

        tokenType ~~ #String ifTrue:[
            (masterParser ? self) ignorableParseError:'Invalid declaration - moduleName expected'.
            ^ nil
        ].
        moduleName := token asSymbol.
    ].
    (argTypes size == 1 and:[argTypes first == #void "isCVoid"]) ifTrue:[
        argTypes := #()
    ].

    isNonVirtualCall ifTrue:[
        (classToCompileFor isSubclassOf:ExternalStructure) ifTrue:[
            thisType := classToCompileFor name.
"/            (thisType := classToCompileFor cType) isNil ifTrue:[
"/                "/ self warning:'missing CType definition in ' , tok printString.
"/                thisType := CType newStructType.
"/                thisType name:(classToCompileFor nameWithoutPrefix).
"/                thisType := CType pointerTypeClass new baseType:thisType.
"/            ].
        ].
        thisType := thisType ? #pointer.
        argTypes := (Array with:thisType) , argTypes.
    ].

    function := ExternalLibraryFunction
            name:(functionName ? virtualFunctionIndex)
            module:moduleName
            returnType:returnType
            argumentTypes:argTypes asArray.

    (definitionType = 'apicall:') ifTrue:[
        function beCallTypeAPI
    ] ifFalse:[
        (definitionType = 'olecall:') ifTrue:[
            function beCallTypeOLE
        ] ifFalse:[
            function beCallTypeC
        ].
    ].
    isNonVirtualCall ifTrue:[
        function beNonVirtualCPP
    ].
    isAsyncCall ifTrue:[
        function beAsync
    ].
    isUnlimitedStack ifTrue:[
        function beUnlimitedStack
    ].
    isConst ifTrue:[
        function beConstReturnValue
    ].
    mustFree ifTrue:[
        function beMustFreeReturnValue
    ].
    ^ function

    "Created: / 25-10-2006 / 12:03:59 / cg"
    "Modified: / 12-02-2017 / 23:44:44 / cg"
!

parseTypeSpec
    |type typeName cls targetNamespace|

    typeName := token.
    self nextToken.

    ((tokenType == #'::') or:[(tokenType == #'.')]) ifTrue:[
        "/ namespace...
        [(tokenType == #'::')  or:[(tokenType == #'.')]] whileTrue:[
            typeName := typeName , '::'.
            self nextToken.
            tokenType ~~ #Identifier ifTrue:[
                (masterParser ? self) parseError:'invalid type identifier'.
            ].
            typeName := typeName , token.
            self nextToken.
         ]
    ].

    (tokenType == #Identifier and:[tokenName = 'long']) ifTrue:[
        "/ long long
        (type = 'long') ifTrue:[
            "/ long long
            typeName := 'longLong'.
            self nextToken.
        ].
        "/ unsigned long
        (type = 'unsigned') ifTrue:[
            "/ unsigned long
            typeName := 'ulong'.
            self nextToken.
        ].
    ].
    (tokenType == #Identifier and:[tokenName = 'int']) ifTrue:[
        "/ long long int
        "/ unsigned int
        "/ long int
        ( #('longLong' 'unsigned' 'long') includes: typeName) ifTrue:[
            self nextToken.
        ].
    ].
    (tokenType == #Identifier and:[tokenName = 'unsigned']) ifTrue:[
        "/ long long unsigned
        "/ int unsigned
        "/ long unsigned
        ( #('longLong' 'int' 'long') includes: typeName) ifTrue:[
            typeName := 'u',typeName.
            self nextToken.
        ].
    ].

    targetNamespace := classToCompileFor nameSpace.

    type := self typeMappingFor:typeName.

    [
        (tokenType == $*)
        or:[((tokenType == #BinaryOperator) and:[tokenName conform:[:ch | ch == $*]])]
    ] whileTrue:[
        "/ that many indirections added
        tokenName size timesRepeat:[
            type := self pointerTypeMappingFor:type inEnvironment:targetNamespace.
        ].
        self nextToken.
    ].

    type isUppercaseFirst ifTrue:[
        (targetNamespace notNil and:[targetNamespace ~~ Smalltalk]) ifTrue:[
            cls := targetNamespace at:type.
        ].
        cls isNil ifTrue:[
            cls := Smalltalk at:type.
        ].
        cls isNil ifTrue:[
            (masterParser ? self) ignorableParseError:'possibly unknown type: ', type allBold.
        ] ifFalse:[
            cls autoload.
            ((cls isSubclassOf:ExternalBytes) or:[(cls isSubclassOf:ExternalAddress)]) ifFalse:[
                (masterParser ? self) ignorableParseError:'possibly wrong type: ', type allBold.
            ].
            type := cls name.
        ].
    ].

    ^ type

    "Modified: / 07-06-2007 / 13:14:59 / cg"
    "Modified: / 06-07-2015 / 23:14:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseVWTypeOrExternalFunctionDeclarationFrom:aStream definitionType:definitionType knownDefinitions:dictionaryOfTypesOrNil lineNr:lineNr for:aParserOrNil
    "parses visualWorks type/function declarations of the form:
        '<c: ...>'
        '<c: #define NAME value>'"

    |cParser moduleName type name val
     nameAndFunctionOrType functionOrType function libName|

    masterParser := aParserOrNil.

    self source:aStream.
    self nextToken.
    ((tokenType == #Symbol) and:[token = #define]) ifTrue:[
        self nextToken.
        (tokenType == #Identifier) ifFalse:[
            (masterParser ? self) ignorableParseError:'invalid cdecl - identifier expected'.
            self generateTrapCodeForUnavailableCParser.
            ^ nil.
        ].
        name := token.
        self nextToken.
        "/ for now, only allow integer, string or floats.
        (#(Integer String Float) includes:tokenType) ifTrue:[
            ^ token
        ].
        tokenType == $( ifTrue:[
            self nextToken.
            (#(Integer String Float) includes:tokenType) ifTrue:[
                val := token.
                self nextToken.
                tokenType == $) ifTrue:[ ^ val ].
            ].
        ].

        (masterParser ? self) ignorableParseError:'invalid cdecl - integer, float or string expected'.
        self generateTrapCodeForUnavailableCParser.
        ^ nil.
    ].

    aStream reset.

    CParser isNil ifTrue:[
        self generateTrapCodeForUnavailableCParser.
        ^ nil.
    ].

    cParser := CParser new.
    cParser knownDefinitions:dictionaryOfTypesOrNil.
    cParser allowRedefinitions:true.
    cParser source:aStream scannerClass:CDeclScanner.
    cParser nextToken.

    cParser tokenType == #struct ifTrue:[
        type := cParser type.
    ] ifFalse:[
        cParser tokenType == #typedef ifTrue:[
            type := cParser typedef.
        ] ifFalse:[
            nameAndFunctionOrType := cParser typeOrFunctionDeclaration.
            functionOrType := nameAndFunctionOrType second.
            functionOrType isCFunction ifFalse:[
                type := functionOrType.
                function := nil.
            ] ifTrue:[
                function := functionOrType.
                type := nil.
            ].
        ]
    ].
    cParser token notNil ifTrue:[
        (masterParser ? self) ignorableParseError:'invalid cdecl - nothing more expected'.
        ^ nil.
    ].
    type notNil ifTrue:[
        ^ type.
    ].

    moduleName isNil ifTrue:[
        self breakPoint:#cg.
        libName := classToCompileFor theNonMetaclass perform:#libraryName ifNotUnderstood:'unknown'.
        moduleName := libName asSymbol.
    ].

    function := ExternalLibraryFunction
            name:function name
            module:moduleName
            returnType:function returnType
            argumentTypes:function argumentTypes asArray.

    function beCallTypeC.
    ^ function

    "Created: / 01-08-2006 / 16:18:05 / cg"
    "Modified: / 07-06-2007 / 13:14:06 / cg"
! !

!Parser::PrimitiveSpecParser methodsFor:'parsing-primitives & pragmas'!

pointerTypeMappingFor: aTypeSymbol
    "given a type, make it a 'pointer to that-type'"

    ^ self pointerTypeMappingFor:aTypeSymbol inEnvironment:Smalltalk

    "Created: / 01-08-2006 / 15:33:53 / cg"
    "Modified: / 11-06-2007 / 01:51:26 / cg"
!

pointerTypeMappingFor: aTypeSymbol inEnvironment:nameSpaceOrNil
    "given a type, make it a 'pointer to that-type'.
     aTypeSymbol must be one of the well-knon builtin types (i.e. int, float,...)
     or the name of a class, which must be an ExternalStructure subclass"

    |e cls|

    e := #(
        (void            voidPointer    )
        (char            charPointer    )
        (byte            bytePointer    )
        (uchar           ucharPointer    )
        (schar           scharPointer    )
        (uint8           uint8Pointer   )
        (uint16          uint16Pointer  )
        (uint32          uint32Pointer  )
        (uint64          uint64Pointer  )
        (int8            int8Pointer   )
        (int16           int16Pointer   )
        (int32           int32Pointer   )
        (int64           int64Pointer   )
        (int             intPointer     )
        (short           shortPointer   )
        (ushort          ushortPointer  )
        (long            longPointer    )
        (longlong        longlongPointer   )
        (uint            uintPointer    )
        (ulong           ulongPointer   )
        (ulonglong       ulonglongPointer   )
        (float           floatPointer   )
        (double          doublePointer  )
    ) detect:[:p | p first = aTypeSymbol] ifNone:nil.
    e notNil ifTrue:[
        ^ e second
    ].

    "/ if a nameSpace is given, try both the namespace and Smalltalk
    (nameSpaceOrNil notNil and:[nameSpaceOrNil ~~ Smalltalk]) ifTrue:[
        cls := nameSpaceOrNil classNamed:aTypeSymbol.
    ].
    cls isNil ifTrue:[
        cls := Smalltalk classNamed:aTypeSymbol.
    ].
    cls notNil ifTrue:[
        (cls isSubclassOf:ExternalStructure) ifTrue:[
            ^ #pointer
        ].
    ].

    (aTypeSymbol endsWith:'Pointer') ifTrue:[
        ^ aTypeSymbol , 'Pointer'
    ].

    (masterParser ? self) ignorableParseError:'missing pointer type mapping for type: ', aTypeSymbol allBold.
    ^ #pointer "/ aTypeSymbol asSymbol

    "Created: / 01-08-2006 / 15:33:53 / cg"
    "Modified: / 18-06-2017 / 22:21:20 / cg"
!

typeMappingFor:aTypeSymbol
    "map some common types; this is needed because there are so many synonyms
     used in the various Smalltalk dialects.."

    |e|

    e := #(
        (short           int16          )
        (long            int32          )
        (int             int32          )
        (ushort          uint16         )
        (ulong           uint32         )
        (unsignedByte    uint8          )
        (unsignedChar    uint8          )
        (unsignedShort   uint16         )
        (unsignedLong    uint32         )
        (double          double         )
        (float           float          )
        (char            char           )
        (uchar           uint8          )
        (byte            uint8          )
        (void            void           )
        (bool            bool           )
        (boolean         bool           )
        (dword           uint32         )
        (sdword          int32          )
        (word            uint16         )
        (sword           int16          )
        (handle          voidPointer    )
        (lpstr           charPointer    )
        (hresult         hresult        )   "/ preserved !!
        (ulongReturn     ulongReturn    )
        (none            void           )
        (struct          voidPointer    )
        (structIn        voidPointer    )
        (structOut       voidPointer    )
        (Win32Handle     voidPointer    )

        (DWORD           uint32         )
        (SDWORD          int32          )
        (WORD            uint16         )
        (SWORD           int16          )
        (LPSTR           charPointer    )
        (HANDLE          voidPointer    )
        (HRESULT         hresult        )
        (CALLBACK        voidFunctionPointer )
        (voidFunc        voidFunctionPointer )
        (funcPtr         voidFunctionPointer )
        (functionPtr     voidFunctionPointer )
    ) detect:[:p | p first = aTypeSymbol] ifNone:nil.

    e notNil ifTrue:[ ^ e second ].

"/ the following is now done in ExternalFunction (if at all), as the ctype is not required to
"/ be present right now, and also to allow for stc-compilation, where no
"/ ctypes are available at all.

"/            e isNil ifTrue:[
"/                cls := classToCompileFor nameSpace classNamed:tok.
"/                cls isNil ifTrue:[
"/                    cls := Smalltalk classNamed:tok.
"/                ].
"/                cls notNil ifTrue:[
"/                    (cls isSubclassOf:ExternalStructure) ifTrue:[
"/                        (cType := cls cType) isNil ifTrue:[
"/                            "/ self warning:'missing CType definition in ' , tok printString.
"/                            cType := CType newStructType.
"/                            cType name:cls name.
"/                        ].
"/                        cType
"/                    ] ifFalse:[
"/                        cls
"/                    ].
"/                ] ifFalse:[
"/                    self parseError:'ulong, ushort, or another valid Squeak type identifier expected (got ' , tok printString , ')'.
"/                    nil
"/                ]
"/            ] ifFalse:[
"/                e second
"/            ].

    ^ aTypeSymbol asSymbol

    "Created: / 01-08-2006 / 15:35:52 / cg"
    "Modified (comment): / 30-03-2016 / 13:49:33 / cg"
    "Modified (comment): / 17-05-2017 / 16:57:11 / mawalch"
! !

!Parser::PrimitiveSpecParser methodsFor:'reading next token'!

isCommentCharacter:ch
    "no comments"

    ^ false

    "Created: / 01-08-2006 / 14:54:48 / cg"
! !

!Parser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$ Id $'
! !


Parser initialize!
