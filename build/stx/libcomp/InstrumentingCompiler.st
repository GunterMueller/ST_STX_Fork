"
 COPYRIGHT (c) 2010 by Claus Gittinger
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

ByteCodeCompiler subclass:#InstrumentingCompiler
	instanceVariableNames:'method methodEntryInfo blockInvocationInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Instrumentation'
!

InstrumentationInfo subclass:#StatementExecutionInfo
	instanceVariableNames:'startPosition endPosition count'
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler
!

InstrumentingCompiler::StatementExecutionInfo subclass:#StatementExecutionInfoForCoverageInAlreadyEnteredState
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler::StatementExecutionInfo
!

InstrumentingCompiler::StatementExecutionInfo subclass:#StatementExecutionInfoInAlreadyEnteredState
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler::StatementExecutionInfo
!

InstrumentationInfo subclass:#MethodInvocationInfo
	instanceVariableNames:'count recursiveEntry infoPerReceiverClass'
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler
!

Object subclass:#MethodInvocationInfoPerReceiverClass
	instanceVariableNames:'infoPerSendingMethod'
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler::MethodInvocationInfo
!

Object subclass:#MethodInvocationInfoPerSendingMethod
	instanceVariableNames:'countPerSendersClass invokedViaPerform'
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler::MethodInvocationInfo::MethodInvocationInfoPerReceiverClass
!

InstrumentingCompiler::MethodInvocationInfo subclass:#MethodInvocationInfoForCoverageInAlreadyEnteredState
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler
!

InstrumentingCompiler::MethodInvocationInfo subclass:#MethodInvocationInfoInAlreadyEnteredState
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler
!

InstrumentingCompiler::StatementExecutionInfo subclass:#VariableAccessExecutionInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler
!

InstrumentingCompiler::StatementExecutionInfo subclass:#BlockExecutionInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler
!

InstrumentingCompiler::BlockExecutionInfo subclass:#BlockExecutionInfoForCoverageInAlreadyEnteredState
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler::BlockExecutionInfo
!

InstrumentingCompiler::BlockExecutionInfo subclass:#BlockExecutionInfoInAlreadyEnteredState
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler::BlockExecutionInfo
!

InstrumentingCompiler::VariableAccessExecutionInfo subclass:#ReadAccessExecutionInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler
!

InstrumentingCompiler::VariableAccessExecutionInfo subclass:#WriteAccessExecutionInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:InstrumentingCompiler
!

!InstrumentingCompiler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Claus Gittinger
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
    an experiment - recompile classes using this compiler adds instrumentation code.
    This remembers who calls a method from where (methodInvocationInfo) what the receiver's types are
    (inherited classes) and how often basic blocks (blockExecutionInfo) and statements 
    (statementExecutionInfo) are invoked .

    The who-calls and receiver type info may produce some overhead, which can be avoided by 
    using the somewhat more naive InstrumentingForSimpleCoverageCompiler (that is what people are
    used to from the C/Java world, anyway).

    From the first bulk, we can compute the inheritanceCoverage info (which methods have been called for which
    subclass) in addition to the known line and block coverages.
"
! !

!InstrumentingCompiler class methodsFor:'compilation-public'!

compileClass:aClass
    "compile all methods of aClass with instrumentation"

    aClass instAndClassMethodsDo:[:eachMethod |
        self compileMethod:eachMethod
    ].
!

compileMethod:aMethod
    "compile a single method with instrumentation"

    Class withoutUpdatingChangesDo:[
        Class packageQuerySignal answer: aMethod package do:[
            self 
                compile:(aMethod source)
                forClass:(aMethod mclass) 
                inCategory:(aMethod category)
        ]
    ]

    "Modified: / 28-07-2013 / 16:59:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compilePackage:aPackageID
    "compile all classes of a package instrumentation"

    Smalltalk allClassesInPackage:aPackageID do:[:eachClass |
        self compileClass:eachClass
    ].

    "
     InstrumentingCompiler compilePackage:'exept:workflow'.
     InstrumentingCompiler compilePackage:'exept:expecco'.
    "
!

compilePackages:aCollectionOfPackageIDs
    "compile all classes of some packages with instrumentation"

    aCollectionOfPackageIDs do:[:eachPackage |
        self compilePackage:eachPackage
    ].

    "
     InstrumentingCompiler compilePackages:#( 'exept:workflow' 'exept:expecco' ).
    "
! !

!InstrumentingCompiler class methodsFor:'special'!

allInstrumentedMethods
    ^ InstrumentedMethod allInstances 

    "
     self allInstrumentedMethods
    "

    "Modified: / 27-04-2010 / 13:37:51 / cg"
!

callersOf:aMethod do:aBlock
    "enumerate all callers of aMethod into a block"

    |info|

    info := aMethod methodInvocationInfo.
    info notNil ifTrue:[
        info callingMethodsDo:[:callingMethod |
            aBlock value:callingMethod
        ]
    ]

    "Modified: / 27-04-2010 / 13:35:00 / cg"
    "Modified (comment): / 07-08-2011 / 15:08:33 / cg"
!

isInstrumented:aMethod
    ^ aMethod isInstrumented

    "
     self methodInfoOf:aMethod
    "

    "Modified: / 27-04-2010 / 13:35:21 / cg"
!

methodInfoOf:aMethod
    <resource: #obsolete>

    self obsoleteMethodWarning:'please use Method >> methodInvocationInfo'.
    ^ aMethod methodInvocationInfo

    "
     self methodInfoOf:aMethod
    "

    "Modified: / 27-04-2010 / 13:37:31 / cg"
!

methodInvocationInfoOf:aMethod
    <resource: #obsolete>
    self obsoleteMethodWarning:'please use method>>methodInvocationInfo'.
    ^ aMethod methodInvocationInfo

    "
     self methodInfoOf:aMethod
    "

    "Created: / 27-04-2010 / 12:28:56 / cg"
    "Modified: / 27-04-2010 / 13:34:36 / cg"
! !

!InstrumentingCompiler methodsFor:'code generation helpers'!

addBlockCounterTo:aBlockNode
    "called by the compiler to instrument a block node"

    |countCode blockEntryInfo|

    blockInvocationInfo isNil ifTrue:[
        blockInvocationInfo := OrderedCollection new.
    ].
    blockEntryInfo := self blockExecutionInfoInstance.
    blockEntryInfo startPosition:aBlockNode startPosition endPosition:aBlockNode endPosition.
"/    Transcript show:aBlockNode startPosition;
"/     show:' -> ';
"/     showCR: aBlockNode endPosition.
    blockInvocationInfo add:blockEntryInfo.

    countCode := 
        StatementNode 
            expression:(MessageNode 
                            receiver:(ConstantNode value:blockEntryInfo)
                            selector:#entry:
                            arg:(VariableNode type:#ThisContext context:contextToEvaluateIn)).

    aBlockNode isEmptyBlock ifTrue:[
        "/ q: are we interested in empty blocks ?
        countCode nextStatement:(StatementNode expression:(ConstantNode value:nil)).
        aBlockNode statements:countCode.
    ] ifFalse:[
        countCode nextStatement:aBlockNode statements.
        aBlockNode statements:countCode.
    ].

    "Modified: / 21-08-2011 / 16:02:52 / cg"
!

addBlockCountersToEachBlockIn:aCollection
    "called by the compiler to instrument a collection of block nodes"

    aCollection do:[:eachNode |
        eachNode isBlockNode ifTrue:[
            self addBlockCounterTo:eachNode
        ]
    ].

    "Created: / 27-04-2010 / 11:47:56 / cg"
!

createMethod
    "called by the compiler to instatiate a new method instance"

    method := super createMethod.

    methodEntryInfo notNil ifTrue:[
        methodEntryInfo owningMethod:method    
    ].
    blockInvocationInfo notNil ifTrue:[
        blockInvocationInfo do:[:eachInfo | eachInfo owningMethod:method]
    ].

    ^ method

    "Modified: / 27-04-2010 / 14:04:50 / cg"
!

methodClass
    "called by the compiler to ask for the method instance's class"

    ^ InstrumentedMethod

    "Created: / 27-04-2010 / 12:17:22 / cg"
!

statementCounterBefore:aStatementNode
    "called by the compiler to instrument a statement node (head of a basic block)"

    |countCode statementEntryInfo|

    blockInvocationInfo isNil ifTrue:[
        blockInvocationInfo := OrderedCollection new.
    ].
    statementEntryInfo := self statementExecutionInfoInstance.
    statementEntryInfo startPosition:aStatementNode startPosition.
    blockInvocationInfo add:statementEntryInfo.

    countCode := 
        StatementNode 
            expression:(MessageNode 
                            receiver:(ConstantNode value:statementEntryInfo)
                            selector:#entry:
                            arg:(VariableNode type:#ThisContext context:contextToEvaluateIn)).

    countCode nextStatement:aStatementNode.
    ^ countCode

    "Modified: / 07-08-2011 / 15:32:45 / cg"
! !

!InstrumentingCompiler methodsFor:'code generation hooks'!

assignmentRewriteHookFor:anAssignmentNode
    "invoked whenever an assignment node has been generated"

    ^ anAssignmentNode

    "Created: / 30-09-2011 / 12:28:09 / cg"
!

blockNodeRewriteHookFor:aBlockNode
    "invoked whenever a block node has been generated"

    "/ add a counter for the block
    self addBlockCounterTo:aBlockNode.
    ^ aBlockNode

    "Created: / 28-04-2010 / 14:21:27 / cg"
!

messageNodeRewriteHookFor:aMessageNode
    "invoked whenever a message send node has been generated"

"/ see blockNodeRewriter...

"/    "/ argument could be a constantNode (due to contant-folding optimization)
"/    aMessageNode isConstant ifTrue:[^ aMessageNode].
"/    (
"/        #( 
"/            ifTrue: 
"/            ifFalse:
"/            ifTrue:ifFalse: 
"/            ifFalse:ifTrue: 
"/        )
"/        includes:aMessageNode selector
"/    ) ifTrue:[
"/        "/ add a counter for the block
"/        self addBlockCountersToEachBlockIn:(aMessageNode arguments)
"/    ].
    ^ aMessageNode

    "Created: / 27-04-2010 / 11:43:22 / cg"
    "Modified: / 28-04-2010 / 14:22:05 / cg"
    "Modified (comment): / 30-09-2011 / 12:16:56 / cg"
!

startCodeGenerationHookOn:codeStream
    "invoked before code is generated"

    methodEntryInfo := self methodInvocationInfoInstance.

    (StatementNode 
        expression:(MessageNode 
                        receiver:(ConstantNode value:methodEntryInfo)
                        selector:#entry:
                        arg:(VariableNode type:#ThisContext context:contextToEvaluateIn)))
            codeForSideEffectOn:codeStream inBlock:nil for:self.

    "Modified: / 07-08-2011 / 15:34:09 / cg"
    "Modified (comment): / 30-09-2011 / 12:16:05 / cg"
!

statementListRewriteHookFor:firstStatementArg
    "invoked whenever a statement list node has been generated"

    "/ care for blocks which return...
    |thisStatement prevStatement countStatement mustInsertExecutionInfo statementInfo firstStatement |

    mustInsertExecutionInfo := false.
    prevStatement := nil.

    thisStatement := firstStatementArg.
    thisStatement isNil ifTrue:[^ firstStatementArg].
    firstStatement := self statementCounterBefore:thisStatement.
    statementInfo := firstStatement expression receiver value. 
    statementInfo endPosition: thisStatement endPosition.


    [true] whileTrue:[
        mustInsertExecutionInfo ifTrue:[
            "/ prev-stat had a return in it (a block with a return);
            "/ insert a statement-entry here.
            thisStatement notNil ifTrue:[
                countStatement := self statementCounterBefore:thisStatement.
                statementInfo := countStatement expression receiver value.
                statementInfo endPosition: thisStatement endPosition.
                prevStatement nextStatement:countStatement.
                mustInsertExecutionInfo := false.
                prevStatement := countStatement.
            ]
        ].
        thisStatement isNil ifTrue:[ ^ firstStatement ].

        thisStatement isReturnNode ifFalse:[
            thisStatement containsReturn ifTrue:[
                mustInsertExecutionInfo := true    
            ]
        ].
        prevStatement := thisStatement.
        statementInfo notNil ifTrue:[
            statementInfo endPosition: prevStatement endPosition.
        ].
        thisStatement := thisStatement nextStatement.
    ].

    "Modified (comment): / 30-09-2011 / 12:15:52 / cg"
    "Modified: / 29-07-2013 / 00:11:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variableReadRewriteHookFor:aVariableNode
    "invoked whenever a variable access node has been generated"

    ^ aVariableNode

    "Created: / 30-09-2011 / 12:27:47 / cg"
! !

!InstrumentingCompiler methodsFor:'redefinable'!

blockExecutionInfoInstance
    "one instance is generated for every block,
     and called at execution time with entry:"

    ^ BlockExecutionInfo new cleanInfoWithChange:false.

    "Created: / 07-08-2011 / 15:13:42 / cg"
!

methodInvocationInfoInstance
    "one instance is generated for every method,
     and called at execution time with entry:"

    ^ MethodInvocationInfo new.

    "Created: / 07-08-2011 / 15:33:57 / cg"
!

statementExecutionInfoInstance
    "one instance is generated for every statement,
     and called at execution time with entry:"

    ^ StatementExecutionInfo new cleanInfoWithChange:false.

    "Created: / 07-08-2011 / 15:32:36 / cg"
! !

!InstrumentingCompiler::StatementExecutionInfo class methodsFor:'documentation'!

documentation
"
    (sub)instances of me are updated by instrumented code when statements are executed.
"
! !

!InstrumentingCompiler::StatementExecutionInfo methodsFor:'accessing'!

callCount
    ^ count

    "Created: / 27-04-2010 / 13:45:15 / cg"
!

characterPosition
    ^ startPosition

    "Created: / 23-06-2006 / 13:31:19 / cg"
    "Modified: / 28-04-2010 / 15:54:24 / cg"
!

characterPosition:something
    startPosition := something.

    "Created: / 23-06-2006 / 13:31:19 / cg"
    "Modified: / 28-04-2010 / 15:54:30 / cg"
!

count
    "how often have I been called"

    ^ count ? 0

    "Created: / 23-06-2006 / 13:31:28 / cg"
!

endPosition
    ^ endPosition

    "Created: / 28-04-2010 / 15:57:14 / cg"
!

endPosition:anInteger
    endPosition := anInteger.
!

startPosition
    ^ startPosition

    "Created: / 28-04-2010 / 15:54:26 / cg"
!

startPosition:anInteger
    startPosition := anInteger.
!

startPosition:startArg endPosition:endArg
    startPosition := startArg.
    endPosition := endArg.

    "Created: / 28-04-2010 / 15:54:47 / cg"
! !

!InstrumentingCompiler::StatementExecutionInfo methodsFor:'cleanup'!

cleanInfoWithChange:withChange
    count := 0.
    withChange ifTrue:[
        Smalltalk changed:#methodCoverageInfo with:owningMethod.
    ].

    "Modified: / 20-07-2011 / 17:55:49 / cg"
    "Created: / 20-07-2011 / 18:59:01 / cg"
! !

!InstrumentingCompiler::StatementExecutionInfo methodsFor:'debugging'!

inspector2TabSource

    | source |

    source := owningMethod source asText.
    startPosition isNil ifTrue:[
        source withColor: Color red.
    ] ifFalse:[
        endPosition isNil ifTrue:[
            source emphasizeFrom:startPosition to:source string size with: #bold.
            source emphasizeFrom:startPosition to:source string size with: #color -> Color red.
        ] ifFalse:[
            source emphasizeFrom:startPosition to: endPosition with: #bold.
            source emphasizeFrom:startPosition to: endPosition with: #color -> Color blue.
        ].
    ].

    ^self newInspector2Tab
        label: 'Source';
        priority: 50;
        view: ((ScrollableView for:EditTextView) contents: source; yourself)

    "Created: / 28-07-2013 / 23:16:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspector2Tabs
    ^ super inspector2Tabs , #( inspector2TabSource )

    "Created: / 28-07-2013 / 23:18:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2015 / 21:03:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InstrumentingCompiler::StatementExecutionInfo methodsFor:'instrumentation calls'!

entry:callingContext
    "invoked by instrumented code;
     called whenever the block/statment is entered"

    |context|

    context := InstrumentationContext current.
    context isNil ifTrue:[^ self].
    context inInstrumentedCode ifTrue:[^ self].
    context coverageOnly ifTrue:[
        self hasBeenExecuted ifTrue:[^ self].
    ].
    context enabledAndNotInInstrumentedCode ifFalse:[^ self].

    count := count + 1.
    count == 1 ifTrue:[
        "/ the very first time, send a change notification, so the browsers update the coloring

        [
            context inInstrumentedCode:true.
            Smalltalk changed:#methodCoverageInfo with:owningMethod.
            context coverageOnly ifTrue:[
                self changeClassToCoverageAndAlreadyEntered.
            ] ifFalse:[
                self changeClassToAlreadyEntered.
            ].
            "/ attention: no self sends here - class has changed!!
        ] ensure:[
            context inInstrumentedCode:false.
        ]
    ].

    "Created: / 23-06-2006 / 13:31:16 / cg"
    "Modified: / 23-08-2011 / 21:29:39 / cg"
! !

!InstrumentingCompiler::StatementExecutionInfo methodsFor:'private'!

changeClassToAlreadyEntered
    self class == InstrumentingCompiler::StatementExecutionInfo ifTrue:[
        self changeClassTo: StatementExecutionInfoInAlreadyEnteredState
    ].
!

changeClassToCoverageAndAlreadyEntered
    self class == InstrumentingCompiler::StatementExecutionInfo ifTrue:[
        self changeClassTo: StatementExecutionInfoForCoverageInAlreadyEnteredState
    ].
! !

!InstrumentingCompiler::StatementExecutionInfo methodsFor:'queries'!

hasBeenExecuted
    ^ count > 0

    "Created: / 28-04-2010 / 14:39:46 / cg"
! !

!InstrumentingCompiler::StatementExecutionInfo methodsFor:'testing'!

isStatementExecutionInfo
    ^ true

    "Created: / 08-08-2011 / 14:40:51 / cg"
! !

!InstrumentingCompiler::StatementExecutionInfo::StatementExecutionInfoForCoverageInAlreadyEnteredState methodsFor:'cleanup'!

cleanInfoWithChange:withChange
    super cleanInfoWithChange:withChange.
    self changeClassTo:InstrumentingCompiler::StatementExecutionInfo.
! !

!InstrumentingCompiler::StatementExecutionInfo::StatementExecutionInfoForCoverageInAlreadyEnteredState methodsFor:'instrumentation calls'!

entry:callingContext
    "already been invoked - nothing to record"

    ^ self
! !

!InstrumentingCompiler::StatementExecutionInfo::StatementExecutionInfoForCoverageInAlreadyEnteredState methodsFor:'queries'!

hasBeenExecuted
    ^ true
! !

!InstrumentingCompiler::StatementExecutionInfo::StatementExecutionInfoInAlreadyEnteredState methodsFor:'cleanup'!

cleanInfoWithChange:withChange
    super cleanInfoWithChange:withChange.
    self changeClassTo:InstrumentingCompiler::StatementExecutionInfo.
! !

!InstrumentingCompiler::StatementExecutionInfo::StatementExecutionInfoInAlreadyEnteredState methodsFor:'instrumentation calls'!

entry:callingContext
    "already been invoked - no update notifications to browsers"

    count := count + 1.
! !

!InstrumentingCompiler::MethodInvocationInfo methodsFor:'accessing'!

callingMethodsDo:aBlock
    infoPerReceiverClass notNil ifTrue:[
        infoPerReceiverClass ~~ true ifTrue:[
            infoPerReceiverClass do:[:each |
                each callingMethodsDo:aBlock
            ]
        ]
    ]
!

count
    "how often have I been called"

    ^ count ? 0
!

hasBeenCalled
    ^ infoPerReceiverClass notEmptyOrNil

    "Created: / 27-04-2010 / 13:43:15 / cg"
!

invokedViaPerform
    ^ infoPerReceiverClass contains:[:someInfo | someInfo invokedViaPerform].

    "Created: / 27-04-2010 / 18:21:56 / cg"
!

invokingMethods
    |setOfMethods|

    setOfMethods := IdentitySet new.
    self invokingMethodsDo:[:m | setOfMethods add:m].
    ^ setOfMethods.
!

invokingMethodsDo:aBlock
    infoPerReceiverClass isNil ifTrue:[ ^ self].
    ^ infoPerReceiverClass do:[:eachInfo | eachInfo invokingMethodsDo:aBlock].
!

numberOfInvocations
    infoPerReceiverClass isNil ifTrue:[ ^ 0].
    infoPerReceiverClass == true ifTrue:[ ^ 0].
    ^ infoPerReceiverClass inject:0 into:[:sumSoFar :info | sumSoFar + info numberOfInvocations] 
!

numberOfInvocationsFromExternalOf:aClass
    |sum|

    infoPerReceiverClass isNil ifTrue:[ ^ 0].

    sum := 0.
    infoPerReceiverClass keysAndValuesDo:[:recClass :info |
        sum := sum + (info numberOfInvocationsFromExternalOf:aClass)
    ]. 
    ^ sum
!

numberOfInvocationsFromInternalOf:aClass
    |sum|

    infoPerReceiverClass isNil ifTrue:[ ^ 0].

    sum := 0.
    infoPerReceiverClass keysAndValuesDo:[:recClass :info |
        sum := sum + (info numberOfInvocationsFromInternalOf:aClass)
    ]. 
    ^ sum
! !

!InstrumentingCompiler::MethodInvocationInfo methodsFor:'cleanup'!

cleanInfoWithChange:withChange
    infoPerReceiverClass := nil.
    withChange ifTrue:[
        Smalltalk changed:#methodCoverageInfo with:owningMethod.
    ]

    "Modified: / 20-07-2011 / 17:55:35 / cg"
    "Created: / 20-07-2011 / 18:59:22 / cg"
! !

!InstrumentingCompiler::MethodInvocationInfo methodsFor:'instrumentation calls'!

entry:aContext
    "invoked by instrumented compiled code, upon method entry"

    |context receiversClass infoPerReceiver firstEntry coverageOnly|

    recursiveEntry == true ifTrue:[
        "/ hurry, get out of here
    ].

    "/ this is a hack - we have to be very careful to avoid recursive
    "/ instrumentation entries when instrumenting collection classes!!
    "/ Do not change without extensive testing.
    recursiveEntry := true.
    context := InstrumentationContext current.
    context isNil ifTrue:[recursiveEntry := false. ^ self].
    context enabledAndNotInInstrumentedCode ifFalse:[recursiveEntry := false. ^ self].

    count := (count ? 0) + 1.
    [
        context inInstrumentedCode:true.

        firstEntry := false.

        (coverageOnly := context coverageOnly) ifTrue:[
            "/ only interested in entry, but not in a per-receiver statistics
            "/ that is the normal coverage usage
            infoPerReceiverClass isNil ifTrue:[
                infoPerReceiverClass := true.
                firstEntry := true.
            ].
        ] ifFalse:[
            "/ interested in a per-receiver statistics (remembering with which receiver-class a method has been invoked).
            "/ that is used by the OOM package
            infoPerReceiverClass isNil ifTrue:[
                infoPerReceiverClass := IdentityDictionary new.
                firstEntry := true.
            ].
            receiversClass := aContext receiver class.
            infoPerReceiver := infoPerReceiverClass 
                                        at:receiversClass 
                                        ifAbsentPut:[MethodInvocationInfoPerReceiverClass new].
            infoPerReceiver entry:aContext.
        ].

        "/ the very first time, send a change notification, so the browsers update the coloring
        firstEntry ifTrue:[
            Smalltalk changed:#methodCoverageInfo with:owningMethod.
        ].
        coverageOnly ifTrue:[
            self changeClassToCoverageAndAlreadyEntered.
        ] ifFalse:[
            self changeClassToAlreadyEntered.
        ].
        "/ attention: no self sends here - class has changed!!
    ] ensure:[
        context inInstrumentedCode:false.
        recursiveEntry := false.
    ].

    "Modified (comment): / 26-10-2012 / 12:59:44 / cg"
! !

!InstrumentingCompiler::MethodInvocationInfo methodsFor:'private'!

changeClassToAlreadyEntered
    self class == InstrumentingCompiler::MethodInvocationInfo ifTrue:[
        self changeClassTo: InstrumentingCompiler::MethodInvocationInfoInAlreadyEnteredState
    ].
!

changeClassToCoverageAndAlreadyEntered
    self class == InstrumentingCompiler::MethodInvocationInfo ifTrue:[
        self changeClassTo: InstrumentingCompiler::MethodInvocationInfoForCoverageInAlreadyEnteredState
    ].
! !

!InstrumentingCompiler::MethodInvocationInfo methodsFor:'testing'!

isMethodInvocationInfo
    ^ true

    "Created: / 08-08-2011 / 14:37:58 / cg"
! !

!InstrumentingCompiler::MethodInvocationInfo::MethodInvocationInfoPerReceiverClass methodsFor:'accessing'!

callingMethodsDo:aBlock
    infoPerSendingMethod keysAndValuesDo:[:m :eachInfo |
        aBlock value:m
    ]
!

invokedViaPerform
    ^ infoPerSendingMethod contains:[:someInfo | someInfo invokedViaPerform].

    "Created: / 27-04-2010 / 18:21:36 / cg"
!

invokingMethodsDo:aBlock
    infoPerSendingMethod isNil ifTrue:[ ^ self].
    infoPerSendingMethod keysDo:aBlock.
!

numberOfInvocations
    infoPerSendingMethod isNil ifTrue:[ ^ 0].
    ^ infoPerSendingMethod inject:0 into:[:sumSoFar :info | sumSoFar + info numberOfInvocations] 
!

numberOfInvocationsFromExternalOf:aClass
    |sum|

    infoPerSendingMethod isNil ifTrue:[ ^ 0].

    sum := 0.
    infoPerSendingMethod keysAndValuesDo:[:sendingMethod :info |
        |sendingMethodsClass|

        sendingMethodsClass := sendingMethod mclass.
        sendingMethodsClass notNil ifTrue:[
            ((sendingMethodsClass isSubclassOf:aClass) 
            or:[(aClass isSubclassOf:sendingMethodsClass )]) ifFalse:[
                sum := sum + (info numberOfInvocations)
            ]
        ]
    ]. 
    ^ sum
!

numberOfInvocationsFromInternalOf:aClass
    |sum|

    infoPerSendingMethod isNil ifTrue:[ ^ 0].

    sum := 0.
    infoPerSendingMethod keysAndValuesDo:[:sendingMethod :info |
        |sendingMethodsClass|

        sendingMethodsClass := sendingMethod mclass.
        sendingMethodsClass notNil ifTrue:[
            ((sendingMethodsClass isSubclassOf:aClass) 
            or:[(aClass isSubclassOf:sendingMethodsClass)]) ifTrue:[
                sum := sum + (info numberOfInvocations)
            ]
        ]
    ]. 
    ^ sum
! !

!InstrumentingCompiler::MethodInvocationInfo::MethodInvocationInfoPerReceiverClass methodsFor:'instrumentation calls'!

entry:aContext
    "invoked by instrumented compiled code, upon method entry"

    |sender sendingMethod infoPerMethod viaPerform|

    aContext selector == #doesNotUnderstand: ifTrue:[
        sender := aContext sender sender methodHome.
    ] ifFalse:[
        sender := aContext sender methodHome.
    ].
    sender isNil ifTrue:[
        ^ self.
    ].
    sendingMethod := sender method.
    sendingMethod isNil ifTrue:[^ self].

    viaPerform := false.
    (sendingMethod mclass == Object 
    and:[ sendingMethod selector startsWith:'perform:'] ) ifTrue:[
        "/ Transcript showCR:('%1 [info]: skipping #perform' bindWith:self class nameWithoutPrefix).
        sender := sender sender methodHome.
        sendingMethod := sender method.
        viaPerform := true.
    ].

    infoPerSendingMethod isNil ifTrue:[
        infoPerSendingMethod := IdentityDictionary new.
    ].
    infoPerMethod := infoPerSendingMethod 
                        at:sendingMethod 
                        ifAbsentPut:[ MethodInvocationInfoPerSendingMethod new ].

    infoPerMethod entry:aContext viaPerform:viaPerform

    "Modified: / 20-07-2011 / 17:26:31 / cg"
! !

!InstrumentingCompiler::MethodInvocationInfo::MethodInvocationInfoPerReceiverClass::MethodInvocationInfoPerSendingMethod methodsFor:'accessing'!

invokedViaPerform
    ^ invokedViaPerform ? false

    "Created: / 27-04-2010 / 18:20:05 / cg"
!

numberOfInvocations
    countPerSendersClass isNil ifTrue:[ ^ 0].
    ^ countPerSendersClass inject:0 into:[:sumSoFar :count | sumSoFar + count] 
! !

!InstrumentingCompiler::MethodInvocationInfo::MethodInvocationInfoPerReceiverClass::MethodInvocationInfoPerSendingMethod methodsFor:'instrumentation calls'!

entry:aContext viaPerform:viaPerformBoolean
    "invoked by instrumented compiled code, upon method entry"

    |sendersClass count|

    sendersClass := aContext sender receiver class.

    countPerSendersClass isNil ifTrue:[
        countPerSendersClass := IdentityDictionary new.
    ].
    count := countPerSendersClass at:sendersClass ifAbsentPut:0.
    countPerSendersClass at:sendersClass put:(count + 1).
    viaPerformBoolean ifTrue:[ invokedViaPerform := true ].

    "Created: / 27-04-2010 / 18:17:27 / cg"
! !

!InstrumentingCompiler::MethodInvocationInfoForCoverageInAlreadyEnteredState methodsFor:'cleanup'!

cleanInfoWithChange:withChange
    super cleanInfoWithChange:withChange.
    self changeClassTo:InstrumentingCompiler::MethodInvocationInfo.
! !

!InstrumentingCompiler::MethodInvocationInfoForCoverageInAlreadyEnteredState methodsFor:'instrumentation calls'!

entry:aContext
    "already been invoked - nothing to record"

    ^ self
! !

!InstrumentingCompiler::MethodInvocationInfoInAlreadyEnteredState methodsFor:'cleanup'!

cleanInfoWithChange:withChange
    super cleanInfoWithChange:withChange.
    self changeClassTo:InstrumentingCompiler::MethodInvocationInfo.

    "Modified: / 20-07-2011 / 17:55:35 / cg"
    "Created: / 24-08-2011 / 11:10:29 / cg"
! !

!InstrumentingCompiler::MethodInvocationInfoInAlreadyEnteredState methodsFor:'instrumentation calls'!

entry:aContext
    "already been invoked - no notifications to send"

    count := count + 1
! !

!InstrumentingCompiler::VariableAccessExecutionInfo class methodsFor:'documentation'!

documentation
"
    (sub)instances of me are updated by instrumented code when a variable is accessed
"
! !

!InstrumentingCompiler::VariableAccessExecutionInfo methodsFor:'testing'!

isVariableAccessExecutionInfo
    ^ true
! !

!InstrumentingCompiler::BlockExecutionInfo class methodsFor:'documentation'!

documentation
"
    (sub)instances of me are updated by instrumented code when a block is executed.
"
! !

!InstrumentingCompiler::BlockExecutionInfo methodsFor:'entry'!

changeClassToAlreadyEntered
    self class == InstrumentingCompiler::BlockExecutionInfo ifTrue:[
        self changeClassTo: BlockExecutionInfoInAlreadyEnteredState
    ].
!

changeClassToCoverageAndAlreadyEntered
    self class == InstrumentingCompiler::BlockExecutionInfo ifTrue:[
        self changeClassTo: BlockExecutionInfoForCoverageInAlreadyEnteredState
    ].
! !

!InstrumentingCompiler::BlockExecutionInfo methodsFor:'printing'!

printOn:aStream 
    aStream nextPutAll:'['.
    startPosition printOn:aStream.
    aStream nextPutAll:'...'.
    endPosition printOn:aStream.
    aStream nextPutAll:']'.

    "Created: / 21-08-2011 / 14:02:01 / cg"
! !

!InstrumentingCompiler::BlockExecutionInfo methodsFor:'testing'!

isBlockExecutionInfo
    ^ true

    "Created: / 07-08-2011 / 17:06:39 / cg"
! !

!InstrumentingCompiler::BlockExecutionInfo::BlockExecutionInfoForCoverageInAlreadyEnteredState methodsFor:'cleanup'!

cleanInfoWithChange:withChange
    super cleanInfoWithChange:withChange.
    self changeClassTo:InstrumentingCompiler::BlockExecutionInfo.
! !

!InstrumentingCompiler::BlockExecutionInfo::BlockExecutionInfoForCoverageInAlreadyEnteredState methodsFor:'instrumentation probe calls'!

entry:callingContext
    "already been invoked - nothing to do"

    ^ self
! !

!InstrumentingCompiler::BlockExecutionInfo::BlockExecutionInfoForCoverageInAlreadyEnteredState methodsFor:'queries'!

hasBeenExecuted
    ^ true
! !

!InstrumentingCompiler::BlockExecutionInfo::BlockExecutionInfoInAlreadyEnteredState methodsFor:'cleanup'!

cleanInfoWithChange:withChange
    super cleanInfoWithChange:withChange.
    self changeClassTo:InstrumentingCompiler::BlockExecutionInfo.
! !

!InstrumentingCompiler::BlockExecutionInfo::BlockExecutionInfoInAlreadyEnteredState methodsFor:'instrumentation probe calls'!

entry:callingContext
    "already been invoked - no update notification for browsers"

    count := count + 1.
! !

!InstrumentingCompiler::BlockExecutionInfo::BlockExecutionInfoInAlreadyEnteredState methodsFor:'queries'!

hasBeenExecuted
    ^ true
! !

!InstrumentingCompiler::ReadAccessExecutionInfo class methodsFor:'documentation'!

documentation
"
    (sub)instances of me are updated by instrumented code when a variable is read
"
! !

!InstrumentingCompiler::WriteAccessExecutionInfo class methodsFor:'documentation'!

documentation
"
    (sub)instances of me are updated by instrumented code when a variable is written
"
! !

!InstrumentingCompiler class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

