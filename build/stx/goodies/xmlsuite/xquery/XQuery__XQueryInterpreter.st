"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::AstInterpreter subclass:#XQueryInterpreter
	instanceVariableNames:'documentProvider documentAdaptorsPool funcTable
		defaultElementNamespaceURI defaultFunctionNamespaceURI
		prefixToNamespaceURIMapping currentFocus pendingUpdateList
		externalContext baseUri typeFactory'
	classVariableNames:'Verbose'
	poolDictionaries:''
	category:'XQuery-Core'
!


!XQueryInterpreter class methodsFor:'instance creation'!

new
    Verbose := false.
    ^ self basicNew initialize.

    "Created: / 24-12-2006 / 15:42:05 / janfrog"
    "Modified: / 21-11-2009 / 20:16:11 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreter class methodsFor:'accessing'!

examples

    ^#(
        ('1+1'
         '1+1')
    )

    "Created: / 04-05-2010 / 12:41:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isVerbose

    ^Verbose == true

    "Created: / 12-04-2007 / 11:14:25 / janfrog"
!

verbose: aBoolean

    Verbose := aBoolean

    "Created: / 12-04-2007 / 11:14:09 / janfrog"
! !

!XQueryInterpreter class methodsFor:'defaults'!

defaultBaseUri
    ^ ''.

    "Created: / 25-07-2009 / 15:08:55 / Jan Kurs <kursj1@fel.cvut.cz>"
!

defaultDocumentProvider
    "default value for the 'documentProvider' instance variable (automatically generated)"

    ^XQuery::XDMAdaptorProvider default.

    "Modified: / 02-12-2006 / 12:00:09 / ked"
    "Modified: / 05-12-2006 / 14:59:22 / janfrog"
    "Created: / 18-09-2008 / 16:38:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-01-2010 / 11:19:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFuncTable
    "default value for the 'funcTable' instance variable (automatically generated)"

    ^XQueryFuncTable new.

    "Created: / 09-09-2006 / 09:53:19 / ked"
! !

!XQueryInterpreter methodsFor:'accessing'!

baseUri
    baseUri isNil ifTrue: [ self baseUri: self class defaultBaseUri].
    ^ baseUri.

    "Modified: / 15-09-2009 / 21:42:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

baseUri: value
    baseUri := value.

    "Created: / 25-07-2009 / 15:07:10 / Jan Kurs <kursj1@fel.cvut.cz>"
!

currentNodeSet

    ^context nodeSet

    "Created: / 05-12-2007 / 10:37:08 / janfrog"
    "Modified: / 18-09-2008 / 16:13:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

currentNodeSet:anObject 
    self assert:(anObject isNil or:[ anObject class == XQuerySequence ]).
    ^context nodeSet: anObject

    "Created: / 18-11-2007 / 08:11:01 / janfrog"
    "Modified: / 05-12-2007 / 10:39:38 / janfrog"
    "Modified: / 18-09-2008 / 16:41:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultFunctionNamespaceURI
    ^ defaultFunctionNamespaceURI

    "Created: / 28-12-2006 / 12:38:13 / janfrog"
!

documentProvider
    documentProvider isNil ifTrue:[documentProvider := self class defaultDocumentProvider].
    ^ documentProvider

    "Modified: / 10-12-2006 / 13:30:28 / janfrog"
    "Created: / 18-09-2008 / 16:36:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

externalContext
    "return context which could be changed from external environment"

    externalContext isNil ifTrue:[
        externalContext := self newContext: 0.
    ].
    ^ externalContext

    "Modified: / 18-04-2009 / 12:43:15 / Jan Kurs <kursj1@fel.cvut.cz>"
!

externalContext: aContext

    externalContext := aContext

    "Modified: / 18-04-2009 / 12:43:15 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Created: / 04-05-2010 / 18:56:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

focus

    ^currentFocus

    "Created: / 01-07-2009 / 15:01:51 / Jan Kurs <kursj1@fel.cvut.cz>"
!

funcTable
    funcTable isNil ifTrue:[
        funcTable := self class defaultFuncTable.
    ].
    ^ funcTable

    "Created: / 09-09-2006 / 09:53:19 / ked"
!

funcTable:something
    funcTable := something.

    "Created: / 09-09-2006 / 09:53:19 / ked"
!

languageName

    ^'XQuery'

    "Created: / 18-04-2010 / 22:23:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prefixToNamespaceURIMapping
    ^ prefixToNamespaceURIMapping

    "Created: / 28-12-2006 / 12:34:19 / janfrog"
!

subInterpreter

    ^self class new
        externalContext: self context flatten

    "Created: / 04-05-2010 / 18:51:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

typeFactory
    typeFactory ifNil:
    [   
        typeFactory := TypeFactory new.
    ].
    ^ typeFactory

    "Modified: / 01-11-2009 / 19:11:12 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'accessing - classes'!

compilerClass
    "Superclass Perseus::Interpreter says that I am responsible to implement this method"

    ^XQueryCompiler

    "Created: / 18-09-2008 / 17:04:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

contextClass
    ^ XQueryContext

    "Created: / 18-09-2008 / 17:11:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-04-2010 / 19:43:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contextProxyClass

    ^ContextProxy

    "Created: / 18-09-2008 / 18:25:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

debuggerClass

    ^XQuery::Debugger

    "Created: / 20-04-2010 / 20:38:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debuggerServiceClass

    ^XQuery::DebuggerService

    "Created: / 20-04-2010 / 19:44:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserClass
    "Superclass Perseus::Interpreter says that I am responsible to implement this method"

    ^XQueryParser

    "Created: / 18-09-2008 / 16:58:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'accessing - document'!

documentAdaptorsFor: aURI

    documentAdaptorsPool ifNil:[
        documentAdaptorsPool := Dictionary new.
    ].

    ^documentAdaptorsPool at: aURI ifAbsentPut:[
        
        (self documentProvider documentAdaptorsFor: aURI)
    ].

    "Modified: / 02-12-2006 / 11:59:45 / ked"
    "Created: / 20-09-2007 / 10:34:10 / janfrog"
    "Modified: / 18-09-2008 / 16:36:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

releaseDocumentAdaptors
    documentAdaptorsPool ifNotNil:
        [documentAdaptorsPool do:
            [:documentAdaptors |
            documentAdaptors do:
                [:documentAdaptor|
                documentAdaptor releaseResources]].
        documentAdaptorsPool := nil].

    "Modified: / 02-11-2006 / 10:28:44 / ked"
    "Created: / 18-09-2008 / 16:36:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'accessing - vars'!

bindExternalVar:aName to:aValue
    "bind variable to external context - this could be done before XQuery execution"

    ^self bindVar:aName to:aValue inContext: self externalContext

    "Created: / 18-04-2009 / 12:40:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

bindVar:aName to:aValue

    ^self bindVar:aName to:aValue inContext: context

    "Modified: / 02-11-2006 / 10:29:47 / ked"
    "Created: / 28-03-2007 / 17:28:05 / janfrog"
    "Modified: / 18-09-2008 / 15:40:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

bindVar:aName to:aValue inContext:aContext 
    self assert: (aName class = XQuerySequence).
    self assert: (aName containsSingleAtomicValue).

    TypeFactory current: self typeFactory do:
    [
        aContext variableAt: aName first stringValue put: aValue
    ].

    "Modified: / 02-11-2006 / 10:29:47 / ked"
    "Created: / 20-03-2007 / 23:01:25 / janfrog"
    "Modified: / 05-11-2009 / 23:02:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

bindVar:aName toInteger:anInteger 
    ^self bindVar:aName
        to:(AtomicItem withNumber:anInteger)

    "Modified: / 02-11-2006 / 10:29:47 / ked"
    "Created: / 28-03-2007 / 20:19:43 / janfrog"
    "Modified: / 07-10-2009 / 11:54:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

bindVarIfNotNil:aName to:aValue

    ^self bindVarIfNotNil:aName to:aValue inContext: context

    "Modified: / 02-11-2006 / 10:29:47 / ked"
    "Created: / 28-03-2007 / 21:24:49 / janfrog"
    "Modified: / 18-09-2008 / 15:40:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

bindVarIfNotNil:aName to:aValue inContext:aContext 

    aName ifNotNil:[self bindVar: aName to: aValue inContext: aContext]

    "Modified: / 02-11-2006 / 10:29:47 / ked"
    "Created: / 28-03-2007 / 21:24:40 / janfrog"
!

unbindVar:aName 

    ^self unbindVar:aName inContext: context

    "Modified: / 02-11-2006 / 10:30:18 / ked"
    "Created: / 28-03-2007 / 17:29:05 / janfrog"
    "Modified: / 18-09-2008 / 15:40:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

unbindVar:aName inContext:aContext 
    aContext variables removeKey:aName ifAbsent:[]

    "Modified: / 02-11-2006 / 10:30:18 / ked"
    "Created: / 28-03-2007 / 17:28:42 / janfrog"
    "Modified: / 28-03-2007 / 21:24:04 / janfrog"
!

valueOfVar:aName inContext:aContext
    self assert: (aName isAtomicValue).
    ^(aContext variableAt: aName stringValue) clone.

    "Created: / 03-09-2006 / 13:41:51 / ked"
    "Modified: / 14-12-2006 / 23:29:54 / ked"
    "Modified: / 20-03-2007 / 23:05:35 / janfrog"
    "Modified: / 05-10-2009 / 16:01:22 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 09:59:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'comparison expr'!

generalComparison:generalComp leftSeq:leftSeq rightSeq:rightSeq 
    |comparisonOperations lSeq rSeq |

    "
    3.5.2 General Comparisons

    The general comparison operators are =, !!=, <, <=, >, and >=. General comparisons are existentially 
    quantified comparisons that may be applied to operand sequences of any length. The result of a 
    general comparison that does not raise an error is always true or false.

    A general comparison is evaluated by applying the following rules, in order:

       1.Atomization is applied to each operand. After atomization, each operand is a sequence of atomic values.
       2.The result of the comparison is true if and only if there is a pair of atomic values, one in the first 
            operand sequence and the other in the second operand sequence, that have the required magnitude 
            relationship. Otherwise the result of the comparison is false. The magnitude relationship between two 
            atomic values is determined by applying the following rules. If a cast operation called for by these 
            rules is not successful, a dynamic error is raised. [err:FORG0001]
     "
    lSeq := leftSeq asAtomizedSequence.
    rSeq := rightSeq asAtomizedSequence.

    comparisonOperations := self generalComparisonOperations.

    ^ XQuerySequence withBoolean:
    (lSeq anySatisfy: [:itemLeft | rSeq anySatisfy:[:itemRight | 
        | left right |
        left := nil.
        right := nil.
    "
    a.If one of the atomic values is an instance of xs:untypedAtomic and the other is an instance of a 
       numeric type, then the xs:untypedAtomic value is cast to the type xs:double.
    "
            (((itemLeft isType: 'xs:untypedAtomic') and: [itemRight isSubtypeOf: 'xs:decimal']) 
            or: [
            ((itemRight isType: 'xs:untypedAtomic') and: [itemLeft isSubtypeOf: 'xs:decimal'])]) ifTrue: [
                left := itemLeft castAs: 'xs:decimal'.
                right := itemRight castAs: 'xs:decimal'.
            ].
    "
    b.If one of the atomic values is an instance of xs:untypedAtomic and the other is an instance of 
       xs:untypedAtomic or xs:string, then the xs:untypedAtomic value (or values) is (are) cast to the 
       type xs:string.
    "
            (((itemRight isType: 'xs:untypedAtomic') and: [itemLeft isSubtypeOf: 'xs:untypedAtomic']) 
            or: [
            ((itemRight isType: 'xs:untypedAtomic') and: [itemLeft isSubtypeOf: 'xs:string'])
            or: [
            ((itemRight isType: 'xs:string') and: [itemLeft isSubtypeOf: 'xs:untypedAtomic']) ] ])
            ifTrue: [ 
                left := itemLeft castAs: 'xs:string'.
                right := itemRight castAs: 'xs:string'.
            ].

    "
    c.If one of the atomic values is an instance of xs:untypedAtomic and the other is not an instance 
       of xs:string, xs:untypedAtomic, or any numeric type, then the xs:untypedAtomic value is cast to 
       the dynamic type of the other value.
    "
            ((itemRight isType: 'xs:untypedAtomic') and: [left isNil]) 
            ifTrue: [ 
                left := itemLeft.
                right := itemRight castAs: left type.
            ].

            ((itemLeft isType: 'xs:untypedAtomic') and: [right isNil]) 
            ifTrue: [ 
                right := itemRight.
                left := itemLeft castAs: right type.
            ].

            (left isNil and: [right isNil]) ifTrue: [
                right := itemRight.
                left := itemLeft.
            ].

            self assert: (left isSubtypeOf: 'xs:untypedAtomic') not.
            self assert: (right isSubtypeOf: 'xs:untypedAtomic') not.

            (comparisonOperations at:generalComp) 
                value:(left)
                value:(right) 

        ]]).

    "Created: / 04-10-2009 / 18:39:54 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 19:10:01 / Jan Kurs <kursj1@fel.cvut.cz>"
!

generalComparisonOperations
    |comparisonOperations|

    comparisonOperations := Dictionary new.
    comparisonOperations
        at:#eqGeneral
            put:[:left :right |
                left = right.
            ];
        at:#neGeneral
            put:[:left :right | 
                left ~= right.
            ];
        at:#ltGeneral
            put:[:left :right | 
                left < right.
            ];
        at:#leGeneral
            put:[:left :right | 
                left <= right.
            ];
        at:#gtGeneral
            put:[:left :right | 
                left > right.
            ];
        at:#geGeneral
            put:[:left :right | 
                left >= right.
            ].
    ^ comparisonOperations.

    "Created: / 04-10-2009 / 18:42:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 18:12:56 / Jan Kurs <kursj1@fel.cvut.cz>"
!

nodeComparison:nodeComp leftSeq:leftSeq rightSeq:rightSeq 
    "If either operand is an empty sequence, the result of the comparison is an empty sequence"
    
    |comparisonOperations|

    (leftSeq size = 0) ifTrue:[
        ^ XQuerySequence new:0
    ].
    (rightSeq size = 0) ifTrue:[
        ^ XQuerySequence new:0
    ].
     "Each operand must be either a single node or an empty sequence; otherwise a type error is raised"
    self assert:(leftSeq size = 1).
    self assert:(rightSeq size = 1).
    self assert:(leftSeq first isSubtypeOf:'node').
    self assert:(rightSeq first isSubtypeOf:'node').
    comparisonOperations := self nodeComparisonOperations.
    ^ XQuerySequence 
        withBoolean:((comparisonOperations at:nodeComp) value:(leftSeq first)
                value:(rightSeq first))

    "Modified: / 06-10-2009 / 16:17:06 / Jan Kurs <kursj1@fel.cvut.cz>"
!

nodeComparisonOperations
    ^ (Dictionary new)
        at:#is put:[:left :right | left = right ];
        at:#isLess put:[:left :right | self error:'not yet implemented' ];
        at:#isMore put:[:left :right | self error:'not yet implemented' ];
        yourself.

    "Created: / 06-10-2009 / 16:16:15 / Jan Kurs <kursj1@fel.cvut.cz>"
!

valueComparison:valueComp leftSeq:leftSeq rightSeq:rightSeq 
    |comparisonOperations left right|
    left := leftSeq asAtomizedSequence.
    right := rightSeq asAtomizedSequence.
    "If the atomized operand is an empty sequence, the result of the value comparison is an empty sequence"
    (left size = 0) ifTrue:[
        ^ XQuerySequence new:0
    ].
    (right size = 0) ifTrue:[
        ^ XQuerySequence new:0
    ].
     "If the atomized operand is a sequence of length greater than one, a type error is raised"
    (left size = 1) ifFalse: [ self raiseError: '[err:XPTY0004]'.].
    (right size = 1) ifFalse: [ self raiseError: '[err:XPTY0004]'.].

    comparisonOperations := self valueComparisonOperations.
    ^ XQuerySequence 
        withBoolean:((comparisonOperations at:valueComp) value:(left first)
                value:(right first))

    "Created: / 05-10-2009 / 15:42:09 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 14:18:53 / Jan Kurs <kursj1@fel.cvut.cz>"
!

valueComparisonOperations
    ^ (Dictionary new)
        at:#eqValue put:[:left :right | left value = right value];
        at:#neValue put:[:left :right | left value ~= right value ];
        at:#ltValue put:[:left :right | left value < right value ];
        at:#leValue put:[:left :right | left <= right ];
        at:#gtValue put:[:left :right | left value > right value ];
        at:#geValue put:[:left :right | left >= right ];
        yourself.

    "Created: / 05-10-2009 / 15:43:27 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 14:47:09 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'context operations'!

newInitialContext: size
    "create context from external context"
    ^self externalContext copyContext grow: (externalContext size + size)

    "Modified: / 18-04-2009 / 20:32:35 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'error reporting'!

raiseError: errorType
    XQueryInterpreterError raiseErrorString: 'Error no.: ', errorType.

    "Created: / 05-10-2009 / 17:20:46 / Jan Kurs <kursj1@fel.cvut.cz>"
!

raiseError: errorType withMessage: message
    XQueryInterpreterError raiseErrorString: message, ' Error no.: ', errorType.

    "Created: / 05-10-2009 / 17:21:52 / Jan Kurs <kursj1@fel.cvut.cz>"
!

raiseErrorWithMessage: message
    XQueryInterpreterError raiseErrorString: message.

    "Created: / 06-10-2009 / 11:53:05 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'evaluation'!

evaluate:aStringOrCompiledCode on:anExceptionClassOrExceptionSet do:aBlock

    |millisecondsToRun resultSequence|

    millisecondsToRun := Time millisecondsToRun:
                            [resultSequence := self basicEvaluate:aStringOrCompiledCode on:anExceptionClassOrExceptionSet do:aBlock].

    ^(XQueryResult withAll:resultSequence ? #())       
        setQueryString: aStringOrCompiledCode;
        setQueryTime: 
            (millisecondsToRun > 0
                ifTrue:[TimeDuration new setMilliseconds: millisecondsToRun]
                ifFalse:[nil]);
        yourself.

    "Created: / 18-09-2008 / 16:55:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-11-2008 / 19:48:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'evaluation - private'!

basicEvaluate:aStringOrCompiledCode
    "TODO: this is ugly hot fix - should be repaired as quick as possible"
    HybridNodeKind instance clearHybrids.
    ^self 
        basicEvaluate: aStringOrCompiledCode 
        on: Error 
        do: [:ex|self handleRuntimeError: ex].

    "Created: / 18-09-2008 / 16:53:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-12-2008 / 12:51:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-11-2009 / 23:04:11 / Jan Kurs <kursj1@fel.cvut.cz>"
!

basicEvaluate:aStringOrCompiledCode on:anExceptionClassOrExceptionSet do:aBlock 
    | retval |

    TypeFactory current: self typeFactory do:
    [

        retval := super evaluate:aStringOrCompiledCode on:anExceptionClassOrExceptionSet do:aBlock.

        pendingUpdateList isEmptyCommand ifFalse:[
                (self isCellstore) ifTrue:[
                    pendingUpdateList setXQIinAdaptor:self.
                 ].
                pendingUpdateList execute]. 
        "Only for testing purpose - delete it easily"
        "/NodeKind printCnt.

        ^retval.
    ].

    "Created: / 18-09-2008 / 16:52:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-11-2009 / 23:07:55 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2010 / 12:01:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-04-2012 / 17:10:30 / Adam Senk <senkadam@gmail.com>"
! !

!XQueryInterpreter methodsFor:'informing'!

informAboutNodeEvaluation: aString

    (Smalltalk isStandAloneApp or:[self class isVerbose]) ifTrue:
        [Transcript show: '[XQuery::Interpreter] evaluating node '; showCR: aString]

    "Created: / 10-02-2007 / 13:03:53 / janfrog"
    "Modified: / 12-04-2007 / 11:16:18 / janfrog"
! !

!XQueryInterpreter methodsFor:'initialization'!

initialize
    super initialize.
    TypeFactory 
        current: self typeFactory
        do:[
            self initializeDefaultNamespaces.
            self initializeNamespaces.
            self initializeFunctionTable.
            self initializePendingUpdateList.
        ].

    "Created: / 24-12-2006 / 15:42:00 / janfrog"
    "Modified: / 28-12-2006 / 12:39:29 / janfrog"
    "Modified: / 01-11-2009 / 19:10:49 / Jan Kurs <kursj1@fel.cvut.cz>"
!

initializeDefaultNamespaces

    defaultElementNamespaceURI := ''.
    defaultFunctionNamespaceURI := 'http://www.w3.org/2005/xpath-functions'.

    "Created: / 24-12-2006 / 17:21:00 / janfrog"
!

initializeFunctionTable

    funcTable := XQueryFuncTable new.
    "NativeFunctionFn allSubclasses do:[:cls|funcTable defineFunction: cls new]."
    self loadFunctionLibrary: XQuery::DmLibrary new.
    self loadFunctionLibrary: XQuery::FnLibrary new.
    self loadFunctionLibrary: XQuery::XSLibrary new.
    self loadFunctionLibrary: XQuery::OpLibrary new.

    "Created: / 28-12-2006 / 12:40:25 / janfrog"
    "Modified: / 28-08-2007 / 23:04:47 / janfrog"
    "Modified: / 15-10-2009 / 23:26:12 / Jan Kurs <kursj1@fel.cvut.cz>"
!

initializeNamespaces

    prefixToNamespaceURIMapping := Dictionary new
        "Taken from XQuery specification section 4.12"
        at:'xml'   put:'http://www.w3.org/XML/1998/namespace';
        at:'xmlns' put:'http://www.w3.org/2000/xmlns/';
        at:'xs'    put:'http://www.w3.org/2001/XMLSchema';
        at:'xsi'   put:'http://www.w3.org/2001/XMLSchema-instance';
"/        at:'fn'    put:'http://www.w3.org/2005/xpath-functions';
"/        at:'dm'    put:'http://www.w3.org/TR/xpath-datamodel';
        at:'local' put:'http://www.w3.org/2005/xquery-local-functions';
        yourself

    "Created: / 24-12-2006 / 15:41:17 / janfrog"
    "Modified: / 24-12-2006 / 17:16:56 / janfrog"
    "Modified: / 15-10-2009 / 23:27:07 / Jan Kurs <kursj1@fel.cvut.cz>"
!

initializePendingUpdateList

    pendingUpdateList := EmptyCommand new.
!

initializeTypeSystem
    typeFactory := TypeFactory new.

    "Created: / 01-11-2009 / 18:08:36 / Jan Kurs <kursj1@fel.cvut.cz>"
!

setDocumentProvider: aDocumentProvider

    documentProvider := aDocumentProvider

    "Created: / 18-09-2008 / 16:36:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'libraries'!

loadFunctionLibrary: aFunctionLibrary

    aFunctionLibrary functions do:
        [:f|funcTable defineFunction:f].

    prefixToNamespaceURIMapping
        at: aFunctionLibrary defaultPrefix
        put: aFunctionLibrary namespaceURI.

    "Created: / 28-08-2007 / 23:05:52 / janfrog"
    "Modified: / 29-08-2007 / 09:42:19 / janfrog"
    "Modified: / 15-10-2009 / 23:28:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

loadFunctionLibraryWithURI: uriString

    ^self loadFunctionLibrary: (FunctionLibrary forURI: uriString).

    "Created: / 01-12-2008 / 10:06:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'private'!

addUri: nsUri toNamespacePrefix: prefix

    prefix = 'xml' ifTrue:[self error:'Cannot redefine ''xml'' namespace prefix.'].
    prefix = 'xmlns' ifTrue:[self error:'Cannot bind ''xmlns'' prefix to namespace uri'].

    prefixToNamespaceURIMapping 
        at: prefix
        put: nsUri

    "Created: / 18-09-2009 / 15:19:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendSequence:sequence toConstructedElement:parent whichIsDocument:isDocument 
    | wasNonAttributeNode |
" Processing of the computed element constructor proceeds as follows:
   3. If the content sequence contains an attribute node following a node that is not an attribute node, a type error 
        is raised [err:XQTY0024].
"
    wasNonAttributeNode := false.

    sequence do:
        [:item|
            (item isSubtypeOf: 'attribute') ifTrue:
            [ 
                wasNonAttributeNode ifTrue: [
                    "TODO: add error number and error message"
                    XQueryInterpreterError raiseErrorString: 'Attribute node cannot follow non-attribute node'.
                ].
            ]
            ifFalse:
            [
                wasNonAttributeNode := true.
            ].
            item appendInto: parent.
        ]

    "Modified: / 02-12-2006 / 12:20:21 / ked"
    "Created: / 21-03-2007 / 15:54:45 / janfrog"
    "Modified: / 29-03-2007 / 13:34:55 / janfrog"
    "Modified: / 05-10-2009 / 16:07:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendSequence:sequence toConstructedTextOrAttribute:textOrAttr 
    |textNodeContentAccum|

    "spojeni atomizovanych hodnot"
    textNodeContentAccum := ''.

    (sequence size > 0) ifTrue: [
        sequence first isAtomicValue ifTrue: [ textNodeContentAccum := sequence first stringValue].
    ].
    sequence from: 2 to: (sequence size) do:[:sequenceItem | 
        textNodeContentAccum := textNodeContentAccum, ' '.
        sequenceItem isAtomicValue ifTrue:
        [ 
            textNodeContentAccum := textNodeContentAccum, sequenceItem dmStringValue.
        ].
    ].
    textOrAttr dmTypedValue: (AtomicItem withValue: textNodeContentAccum).
    textOrAttr dmStringValue:textNodeContentAccum.

    "Modified: / 09-11-2006 / 23:51:06 / ked"
    "Created: / 21-03-2007 / 16:05:22 / janfrog"
    "Modified: / 05-10-2009 / 17:09:08 / Jan Kurs <kursj1@fel.cvut.cz>"
!

orderCriterionFor: left and: right

    | leftValue rightValue ascDesc emptyGreatestLeast ascTrue ascFalse |

    self assert: left orderSpecItems size = right orderSpecItems size.

    (1 to: left orderSpecItems size) do:[:pos |
        ascDesc := (left orderSpecItems at:pos) ascDesc.
        emptyGreatestLeast := (left orderSpecItems at:pos) emptyGreatestLeast.

        ascDesc ifNil:[
            ascDesc := #asc.
        ].
        emptyGreatestLeast ifNil:[
            emptyGreatestLeast := #greatest.
        ].

        ascDesc = #asc ifTrue:[
            ascTrue := true.
            ascFalse := false.
        ] ifFalse:[
            ascTrue := false.
            ascFalse := true.
        ].

        (left orderSpecItems at:pos) orderValue size = 0 ifTrue:[
            leftValue := nil.
        ] ifFalse:[
            self assert: (left orderSpecItems at:pos) orderValue size = 1.
            leftValue := (left orderSpecItems at:pos) orderValue first value.
        ].

        (right orderSpecItems at:pos) orderValue size = 0 ifTrue:[
            rightValue := nil.
        ] ifFalse:[
            self assert: (right orderSpecItems at:pos) orderValue size = 1.
            rightValue := (right orderSpecItems at:pos) orderValue first value.
        ].

        (leftValue isNil not or:[rightValue isNil not]) ifTrue:[

            leftValue isNil ifTrue:[
                emptyGreatestLeast = #greatest ifTrue:[
                    ^ascFalse.
                ] ifFalse:[
                    ^ascTrue.
                ]
            ].

            rightValue isNil ifTrue:[
                emptyGreatestLeast = #greatest ifTrue:[
                    ^ascTrue.
                ] ifFalse:[
                    ^ascFalse.
                ]
            ].    

            leftValue > rightValue ifTrue:[
                ^ascFalse.
            ].

            leftValue < rightValue ifTrue:[
                ^ascTrue.
            ].

        ].
    ].

    ^true. "stable ordering"

    "Created: / 30-11-2006 / 15:45:05 / ked"
    "Modified: / 30-11-2006 / 23:58:05 / ked"
!

reduceCurrentNodeSetUsing:aBlock 
    ^ self currentNodeSet:(self currentNodeSet 
                inject:(XQuerySequence new:self currentNodeSet size * 2)
                into:[:seq :node |
                    | value |
                    value := aBlock value:node.
                    value ifNotNil: [
                        seq
                            addAll:value.
                    ].
                    seq.
                ])

    "Created: / 17-11-2007 / 15:51:19 / janfrog"
    "Modified: / 05-12-2007 / 10:37:08 / janfrog"
    "Modified: / 22-09-2009 / 20:00:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

uniqueAddNodeSequence:anInsertedDataContext to:aTargetDataContext 
    anInsertedDataContext do:[:insertedDataContextItem | 
        self assert:(insertedDataContextItem type 
                    isSubtypeOf:(TypeFactory getType: 'node')).
        (aTargetDataContext 
            anySatisfy:[:targetDataContextItem | 
                self assert:(targetDataContextItem type 
                            isSubtypeOf: (TypeFactory getType: 'node')).
                insertedDataContextItem item = targetDataContextItem item
            ]) 
                ifFalse:[ aTargetDataContext add:insertedDataContextItem. ].
    ].

    "Created: / 01-12-2006 / 15:40:36 / ked"
    "Modified: / 05-12-2007 / 21:21:33 / janfrog"
    "Modified: / 09-05-2009 / 12:16:06 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitCollection:aCollection 
    | resultSequence |

    self assert: (aCollection class isSubclassOf: Collection) message: 'collection expected'.

    resultSequence := XQuerySequence new.
    aCollection
        do:[:item | resultSequence addAll: (self visit: item) ].

    ^ resultSequence.

    "Created: / 15-07-2009 / 20:57:13 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 25-07-2009 / 23:36:06 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withCurrentNodeSetDo:aBlock 
    |oldNodeSet retval|

    oldNodeSet := self currentNodeSet.
    self currentNodeSet:self currentNodeSet copy.
    retval := aBlock value.
    self currentNodeSet:oldNodeSet.
    ^ retval

    "Created: / 21-03-2007 / 23:17:34 / janfrog"
    "Modified: / 05-12-2007 / 10:37:08 / janfrog"
!

withFocusDo:aBlock 
    |oldFocus retval|

    oldFocus := currentFocus.
    currentFocus := XQueryFocus new contextSize:self currentNodeSet size.
    retval := aBlock value.
    currentFocus := oldFocus.
    ^ retval

    "Created: / 21-03-2007 / 20:31:59 / janfrog"
    "Modified: / 05-12-2007 / 10:37:08 / janfrog"
! !

!XQueryInterpreter methodsFor:'private - FLWOR'!

bloomForClauses:forClauses by:forClauseIndex using:bloomingBlock 
    |forClause valueVarName positionVarName valueSeq|
    forClause := forClauses at:forClauseIndex.
    valueVarName := self visit:forClause varName.
    positionVarName := self visit:forClause positionalVar.
    valueSeq := self visit:forClause exprSingle.
    valueSeq keysAndValuesDo:
            [:position :value | 
            "3.8.1 For and Let Clauses ... The positional variable always has an implied type of xs:integer."
            self
                bindVar:valueVarName to:value;
                bindVarIfNotNil:positionVarName to:(AtomicItem withValue:position asType: 'xs:integer').
            forClauses size = forClauseIndex "is last for clause?" 
                ifTrue:[bloomingBlock value]
                ifFalse:
                    [self 
                        bloomForClauses:forClauses
                        by:forClauseIndex + 1
                        using:bloomingBlock]]

    "Created: / 28-03-2007 / 21:26:54 / janfrog"
    "Modified: / 24-10-2009 / 14:51:22 / Jan Kurs <kursj1@fel.cvut.cz>"
!

bloomForClauses: forClauses using: bloomingBlock

    forClauses isEmpty
        ifTrue:
            [bloomingBlock value]
        ifFalse:
            [self
                bloomForClauses: forClauses 
                by: 1
                using: bloomingBlock]

    "Created: / 28-03-2007 / 21:02:21 / janfrog"
!

bloomForLetClauses: forLetClauses by: forLetClauseIndex using: primaryBloomingBlock

    | forLetClause forClauses |

    forLetClause := forLetClauses at: forLetClauseIndex.
    forClauses := forLetClause asCollectionOfForClauses.


    self 
        bloomForClauses: forClauses
        using:
            [self visitAll: forLetClause asCollectionOfLetClauses.
            forLetClauses size = forLetClauseIndex"is last for-let clause?"
                ifTrue:
                    [primaryBloomingBlock value]
                ifFalse:
                    [self
                        bloomForLetClauses: forLetClauses
                        by: forLetClauseIndex + 1
                        using: primaryBloomingBlock]]

    "Created: / 28-03-2007 / 20:48:07 / janfrog"
!

bloomForLetClauses: forLetClauses using: primaryBloomingBlock

    ^self 
        bloomForLetClauses: forLetClauses
        by: 1
        using: primaryBloomingBlock

    "Created: / 28-03-2007 / 20:42:51 / janfrog"
!

bloomQuantifiedExprImpls: quantifiedExprImpls by: quantifiedExprImplIndex using: bloomingBlock

    | quantifiedExprImpl valueVarName valueSeq |

    quantifiedExprImpl := quantifiedExprImpls at: quantifiedExprImplIndex.
    valueVarName := self visit:  quantifiedExprImpl varName.
    valueSeq := self visit: quantifiedExprImpl exprSingle.

    valueSeq do:
        [:value|
        self bindVar: valueVarName to: value.
        quantifiedExprImpls size = quantifiedExprImplIndex"is last?"
            ifTrue:
                [bloomingBlock value]
            ifFalse:
                [self
                    bloomQuantifiedExprImpls: quantifiedExprImpls 
                    by: quantifiedExprImplIndex + 1
                    using: bloomingBlock]]

    "Created: / 28-03-2007 / 22:16:08 / janfrog"
    "Modified: / 19-09-2009 / 15:10:02 / Jan Kurs <kursj1@fel.cvut.cz>"
!

bloomQuantifiedExprImpls: quantifiedExprImpls using: bloomingBlock

    self
        bloomQuantifiedExprImpls: quantifiedExprImpls 
        by: 1
        using: bloomingBlock

    "Created: / 28-03-2007 / 22:06:54 / janfrog"
! !

!XQueryInterpreter methodsFor:'private - QNames'!

isNamespaceDeclaration:qname
    self assert: (qname isSubtypeOf: 'xs:QName').
    ^ qname prefix = 'xmlns'.

    "Created: / 18-09-2009 / 15:41:58 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 19:21:25 / Jan Kurs <kursj1@fel.cvut.cz>"
!

qNameFromAtomic:atomicValue 
    " returns the xs:QName atomic value"
    | validType qName |

    self assert: atomicValue isAtomicValue.

    validType := false.
    (atomicValue isSubtypeOf: 'xs:string') ifTrue: [validType := true].
    (atomicValue isSubtypeOf: 'xs:untypedAtomic') ifTrue: [validType := true].
    (atomicValue isSubtypeOf: 'xs:QName') ifTrue: [validType := true].

    validType ifFalse: 
    [
        XQueryParserError raiseErrorString: 'Name of computed element must be either an xs:string, xs:untypedAtomic or xs:QName'.
    ].

    Exception handle: [:ex |
        self raiseErrorWithMessage: ex asString.
    ] do: [
        qName := (QName withQNameString: atomicValue stringValue).
        qName hasPrefix ifTrue:
        [
            qName namespaceURI: 
                (self prefixToNamespaceURIMapping at: qName prefix ifAbsent: [
                    self raiseErrorWithMessage: 'unknown namespace'.
                ])
        ] ifFalse: [
            qName namespaceURI: defaultElementNamespaceURI.
        ].
    ].

    ^ AtomicItem withValue: qName asType: 'xs:QName'.

    "Created: / 06-10-2009 / 14:29:08 / Jan Kurs <kursj1@fel.cvut.cz>"
!

qNameFromString: string
    " returns the xs:QName atomic value"
    ^ self qNameFromAtomic: (AtomicItem withString: string).

    "Created: / 06-10-2009 / 14:36:28 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xmlNodeNameFromQName:qname 
    | validType |
    self halt: 'deprecated - shuold be replaced with qNameFromAtomic'.

    self assert: qname isAtomicValue.

    validType := false.
    (qname isSubtypeOf: 'xs:string') ifTrue: [validType := true].
    (qname isSubtypeOf: 'xs:untypedAtomic') ifTrue: [validType := true].
    (qname isSubtypeOf: 'xs:QName') ifTrue: [validType := true].

    validType ifFalse: 
    [
        XQueryParserError raiseErrorString: 'Name of computed element must be either an xs:string, xs:untypedAtomic or xs:QName'.
    ].

    Exception handle: [:ex |
        XQueryInterpreterError raiseErrorString: ex asString.
    ] do: [
        ^ XMLv2::NodeName 
            fromString:qname dmStringValue
            andPrefixToNamespaceURIMapping:prefixToNamespaceURIMapping
            defaultNS:defaultElementNamespaceURI
    ].

    "Created: / 20-03-2007 / 23:19:29 / janfrog"
    "Modified: / 15-10-2009 / 23:24:35 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'queries'!

shouldTryToUseIndex
    "If you want to try to experiment with indexes, change it to return true"
    ^false.

    "Created: / 05-11-2007 / 17:52:05 / beyboy"
    "Modified: / 05-11-2007 / 22:36:21 / beyboy"
! !

!XQueryInterpreter methodsFor:'testing'!

isCellstore
     ^false.

    "Created: / 06-03-2012 / 23:15:03 / Adam Senk <senkadam@gmail.com>"
! !

!XQueryInterpreter methodsFor:'visiting'!

visit:anObject 

    self informAboutNodeEvaluation: anObject class name.
    ^super visit:anObject

    "Modified: / 08-10-2006 / 14:17:01 / ked"
    "Modified: / 10-02-2007 / 13:04:10 / janfrog"
    "Modified: / 18-09-2008 / 15:50:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 19:27:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstAbbrevForwardStep:anObject 
    "dispatched back from the visited astAbbrevForwardStep-object (visitor pattern)"
    
    |expandedStepNode|

    expandedStepNode := (AstForwardStep new)
                forwardAxis:anObject stepType;
                nodeTest:anObject nodeTest.
    ^ self currentNodeSet:(self visit:expandedStepNode).

    "Created: / 08-10-2006 / 17:03:54 / ked"
    "Modified: / 12-10-2006 / 23:08:51 / ked"
    "Modified: / 18-11-2007 / 08:11:01 / janfrog"
!

visitAstAdditiveExpr:anObject 
    "dispatched back from the visited astAdditiveExpr-object (visitor pattern)"
    
    |leftSequence rightSequence funcName|

    leftSequence := (self visit:anObject multiplicativeExpr) asAtomizedSequence.
    rightSequence := (self visit:anObject additiveExpr) asAtomizedSequence.
    self announceTracepointInterrupt.
     "If the atomized operand is an empty sequence, the result of the value comparison is an empty sequence"
    (leftSequence size = 0) ifTrue:[
        ^ XQuerySequence new:0
    ].
    (rightSequence size = 0) ifTrue:[
        ^ XQuerySequence new:0
    ].
     "If the atomized operand is a sequence of length greater than one, a type error is raised"
    (leftSequence size = 1) ifFalse: [ self raiseError: '[err:XPTY0004]'.].
    (rightSequence size = 1) ifFalse: [ self raiseError: '[err:XPTY0004]'.].

    "If the atomized operand is of type xs:untypedAtomic, it is cast to xs:double. If the cast 
        fails, a dynamic error is raised. [err:FORG0001]"
    (leftSequence first typeName = 'xs:untypedAtomic') ifTrue: 
        [leftSequence := XQuerySequence with: ((leftSequence first) castAs: 'xs:double')].
    (rightSequence first typeName = 'xs:untypedAtomic') ifTrue: 
        [rightSequence := XQuerySequence with: ((rightSequence first) castAs: 'xs:double')].

     "evaluate operation"
    (anObject operand == #plus) 
                ifTrue:[ funcName := 'op:numeric-add' ]
                ifFalse:[ funcName := 'op:numeric-substract' ].

    ^ self funcTable 
        evaluate:funcName
        inContext:context
        withParameters: (XQuerySequence with: leftSequence first with: rightSequence first)
        forInterpreter:self.

    "Created: / 06-07-2006 / 19:12:08 / ked"
    "Modified: / 08-10-2006 / 20:15:15 / ked"
    "Modified: / 21-03-2007 / 14:08:39 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 14:31:55 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstAfterTriggerExpr:anObject
  |createCmd|

    createCmd := self visit:anObject eventTriggerExpr.
    self announceTracepointInterrupt.
    createCmd time:'after'.
    ^createCmd.

    "Created: / 10-04-2012 / 20:29:29 / Adam Senk <senkadam@gmail.com>"
!

visitAstAndExpr:anObject 
    "dispatched back from the visited astAdditiveExpr-object (visitor pattern)"
    
    |leftSequence rightSequence|

    leftSequence := self visit:anObject comparisonExpr.
    rightSequence := self visit:anObject andExpr.
    self announceTracepointInterrupt.
     "evaluate operation"
    ^ XQuerySequence withBoolean:(leftSequence effectiveBooleanValue 
                and:[ rightSequence effectiveBooleanValue ])

    "Created: / 06-07-2006 / 19:12:08 / ked"
    "Modified: / 08-10-2006 / 20:15:15 / ked"
    "Modified: / 21-03-2007 / 15:08:08 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-05-2009 / 15:21:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstAnyKindTest:anObject 
    "dispatched back from the visited astAnyKindTest-object (visitor pattern)"
    
    ^ self currentNodeSet:(self currentNodeSet 
                select:[:nodeSetItem | nodeSetItem type isSubtypeOf: (TypeFactory getType: 'node') ]).

    "Created: / 21-11-2006 / 21:54:14 / ked"
    "Modified: / 23-11-2006 / 12:24:11 / ked"
    "Modified: / 05-12-2007 / 21:21:33 / janfrog"
    "Modified: / 09-05-2009 / 12:16:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstAtomicType:atomicType
    ^ self visit: atomicType qName.
"/    | qName |
"/    qName := (self visit: atomicType qName) first.
"/
"/    ^self currentNodeSet 
"/                select:[:item | item isSubtypeOf: (qName qName)]

    "Modified: / 14-10-2009 / 23:10:38 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstAttribNameOrWildcard:anObject 
    "dispatched back from the visited astAttribNameOrWildcard-object (visitor pattern)"
    
    |givenContext resultDataContext|

    self 
        halt:'Not yet ported. Ask Jan Vrany <vranyj1@fel.cvut.cz> for further explanation'.
    resultDataContext := OrderedCollection new.
    givenContext dataContext do:[:dataContextItem | 
        (dataContextItem type isSubtypeOf:NodeItem typeNode) ifTrue:[
            dataContextItem item xpathIsAttribute ifTrue:[
                anObject attributeName 
                    ifNil:[ resultDataContext add:dataContextItem. ]
                    ifNotNil:[
                        self visit:(anObject attributeName).
                        context dataContext first value = dataContextItem item xpathName ifTrue:[
                            resultDataContext add:dataContextItem.
                        ].
                        context := givenContext.
                    ].
            ].
        ].
    ].
    context := givenContext copyContext dataContext:resultDataContext.

    "Created: / 21-11-2006 / 21:58:27 / ked"
    "Modified: / 23-11-2006 / 13:27:56 / ked"
    "Modified: / 05-12-2007 / 21:21:33 / janfrog"
    "Modified: / 18-09-2008 / 17:47:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 12:13:49 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstAttributeTest:anObject 
    "dispatched back from the visited astAttributeTest-object (visitor pattern)"
    
    |givenContext attribNameNode|

    self 
        halt:'Not yet ported. Ask Jan Vrany <vranyj1@fel.cvut.cz> for further explanation'.
    anObject attribName 
        ifNil:[
            attribNameNode := AstAttribNameOrWildcard new.
            self visit:attribNameNode.
        ]
        ifNotNil:[ self visit:(anObject attribName). ].

    "Created: / 21-11-2006 / 21:57:25 / ked"
    "Modified: / 23-11-2006 / 13:06:49 / ked"
    "Modified: / 18-09-2008 / 17:47:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstAxisStep:anObject 
    "dispatched back from the visited astAxisStep-object (visitor pattern)"
    
    self currentNodeSet:(anObject forwardStep 
                ifNil:[ self visit:anObject reverseStep ]
                ifNotNil:[ self visit:anObject forwardStep ]).
    ^ self currentNodeSet:(self visit:(anObject predicateList)).

    "Created: / 06-07-2006 / 19:12:08 / ked"
    "Modified: / 02-11-2006 / 10:30:45 / ked"
    "Modified: / 18-11-2007 / 08:11:01 / janfrog"
!

visitAstBaseUriDecl: baseUriDecl

    self baseUri: (self visit: baseUriDecl value) first.

    "Created: / 25-07-2009 / 15:04:05 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 14:13:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstBeforeTriggerExpr:anObject
  |createCmd|

    createCmd := self visit:anObject eventTriggerExpr.
    self announceTracepointInterrupt.
    createCmd time:'before'.
    ^createCmd.

    "Created: / 10-04-2012 / 20:20:13 / Adam Senk <senkadam@gmail.com>"
!

visitAstBooleanLiteral:anObject 

    ^XQuerySequence withBoolean: anObject content

    "Created: / 28-03-2007 / 17:35:35 / janfrog"
!

visitAstCastExpr:castExpr 
    | unarySeq atomizedSeq atomicType |
    unarySeq:= (self visit: castExpr unaryExpr).

    castExpr singleType ifNil: [ ^ unarySeq ].

    atomizedSeq := unarySeq asAtomizedSequence.
    (atomizedSeq size > 1) ifTrue: [
        self raiseError: '[err:XPTY0004]' withMessage: 'Only empty sequence or single atomic value expected'.
    ].

    (atomizedSeq size = 0) ifTrue: [
        castExpr singleType occurenceIndicator = '?' ifTrue: [
            ^ XQuerySequence new.
        ] ifFalse: [
            self raiseError: '[err:XPTY0004]' withMessage: 'Empty sequence could not be casted to required type'.
        ].
    ].

    atomicType := (self visit: castExpr singleType atomicType) first.
    ^ XQuerySequence with: (atomizedSeq first castAs: atomicType qName).

    "Created: / 14-10-2009 / 22:05:40 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 19:55:58 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstCastableExpr:castableExpr 
    | castSeq atomicType |
    castSeq:= (self visit: castableExpr castExpr).

    castableExpr singleType ifNil: [ ^ castSeq ].

    "empty sequence with ? occurence indicator"
    ((castSeq size = 0) and:[ (castableExpr singleType isWithEmptySequence) ]) ifTrue:[ 
        ^ XQuerySequence withBoolean:true. 
    ].

     "sequence with one item"
    (castSeq size = 1) ifTrue:[
        atomicType := (self visit: castableExpr singleType atomicType) first.
        [
            castSeq first castAs: atomicType qName.
            ^ XQuerySequence withBoolean: true.
        ] on: AtomicItemError do: [
            ^ XQuerySequence withBoolean: false.
        ].
    ].

    ^ XQuerySequence withBoolean:false.

    "Created: / 05-07-2009 / 16:19:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 01-11-2009 / 13:21:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstCompAttrConstructor:anObject 
    "dispatched back from the visited astCompAttrConstructor-object (visitor pattern)"
    
    |qName contentSeq expr seqItem|

    seqItem := NodeItem withNode: 'attribute'.

    qName := anObject qname 
                ifNotNil:[ (self visit:anObject qname) first]
                ifNil:[ expr := self visit:anObject expr.
                        (expr size = 1) ifTrue: [
                            expr first.
                        ] ifFalse: [
                            XQueryInterpreterError raiseErrorString: 'Name of computed attribute must be exactly one element'.
                        ]
                      ].
    self announceTracepointInterrupt.
    seqItem dmNodeName: qName.
    contentSeq := anObject contentExpr 
                ifNil:[ XQuerySequence new:0 ]
                ifNotNil:[ self visit:(anObject contentExpr) ].

    self appendSequence:contentSeq toConstructedTextOrAttribute:seqItem.
    ^ XQuerySequence with: seqItem.

    "Created: / 06-07-2006 / 19:12:08 / ked"
    "Modified: / 09-11-2006 / 23:45:28 / ked"
    "Modified: / 21-03-2007 / 16:05:22 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 17:06:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstCompDocConstructor:anObject 
    "dispatched back from the visited astCompElemConstructor-object (visitor pattern)"
    
    |seqItem|

    seqItem := NodeItem withNode: 'document'.

    anObject expr 
        ifNil:[
            self 
                appendSequence:(OrderedCollection new)
                toConstructedElement:seqItem
                whichIsDocument:false.
        ]
        ifNotNil:[
            |documentChildrenSeq|

            documentChildrenSeq := self visit:anObject expr.
            self announceTracepointInterrupt.
            self 
                appendSequence:documentChildrenSeq
                toConstructedElement:seqItem
                whichIsDocument:false.
        ].
    ^ XQuerySequence with: seqItem.

    "Created: / 06-07-2006 / 19:12:09 / ked"
    "Modified: / 09-11-2006 / 23:53:01 / ked"
    "Modified: / 29-03-2007 / 11:29:20 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 16:06:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstCompElemConstructor:anObject 
    "dispatched back from the visited astCompElemConstructor-object (visitor pattern)"
    
    |qName seqItem expr|

    seqItem := NodeItem withNode: 'element'.
    seqItem dmBaseUri: self baseUri.
    qName := anObject qname 
                ifNotNil:[ (self visit:anObject qname) first ]
                ifNil:[ expr := self visit:anObject expr.
                        (expr size = 1) ifTrue: [
                            self qNameFromAtomic: expr asAtomizedSequence first.
                        ] ifFalse: [
                            self raiseError: '[err:XPTY0004]' withMessage: 'element name must be only one value'.
                        ]
                      ].
    self announceTracepointInterrupt.
    seqItem dmNodeName: qName.

    anObject contentExpr 
        ifNil:[
            self 
                appendSequence:(OrderedCollection new)
                toConstructedElement:seqItem
                whichIsDocument:false.
        ]
        ifNotNil:[
            self 
                appendSequence: (self visit:anObject contentExpr)
                toConstructedElement:seqItem
                whichIsDocument:false.
        ].
    ^ XQuerySequence with:(seqItem).

    "Created: / 06-07-2006 / 19:12:09 / ked"
    "Modified: / 09-11-2006 / 23:53:01 / ked"
    "Modified: / 29-03-2007 / 11:27:01 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 14:44:55 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstCompTextConstructor:anObject 
    "dispatched back from the visited astCompTextConstructor-object (visitor pattern)"
    
    |textSeq seqItem|

    textSeq := self visit:(anObject expr).

    "2.
        If the result of atomization is an empty sequence, no text node is constructed. 
        Otherwise, each atomic value in the atomized sequence is cast into a string."
    textSeq isEmpty ifTrue:[
        ^ XQuerySequence new.
    ].

    self announceTracepointInterrupt.
    seqItem := NodeItem withNode: 'text'.
    self appendSequence:textSeq toConstructedTextOrAttribute:seqItem.
    ^ XQuerySequence with: seqItem.

    "Created: / 06-07-2006 / 19:12:09 / ked"
    "Modified: / 06-11-2006 / 22:53:07 / ked"
    "Modified: / 29-03-2007 / 13:43:21 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 17:09:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstComparisonExpr:anObject 
    "dispatched back from the visited astComparisonExpr-object (visitor pattern)"
    
    |leftSeq rightSeq|

    leftSeq := self visit:anObject rangeExprLeft.
    rightSeq := self visit:anObject rangeExprRight.
    self announceTracepointInterrupt.
    anObject valueComp 
        ifNotNil:[
            ^ self valueComparison:anObject valueComp leftSeq: leftSeq rightSeq: rightSeq.
        ].
    anObject generalComp 
        ifNotNil:[
            ^ self generalComparison: anObject generalComp leftSeq: leftSeq rightSeq: rightSeq.
        ].
    anObject nodeComp 
        ifNotNil:[
            ^ self nodeComparison: anObject nodeComp leftSeq: leftSeq rightSeq: rightSeq.
        ].

    "Created: / 06-07-2006 / 19:12:09 / ked"
    "Modified: / 02-12-2006 / 12:20:34 / ked"
    "Modified: / 05-12-2007 / 21:21:33 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 10:11:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstConnectTriggerExpr:anObject
   |targetSeq triggerDefSeq connectCmd|

    triggerDefSeq := self visit:anObject triggerDefExpr.
    targetSeq := self visit:anObject targetExpr.
    self announceTracepointInterrupt.
    connectCmd := (ConnectCommand new)
                targetSequence:targetSeq;
                triggerDefSequence:triggerDefSeq.

    pendingUpdateList := pendingUpdateList mergeWith:connectCmd.
    ^ (XQuerySequence new)

    "Created: / 25-03-2012 / 12:23:35 / Adam Senk <senkadam@gmail.com>"
!

visitAstContextItemExpr:anObject 

    "TODO - toto rozhodne neni spravne. Je treba promyslet,
        jak spravne nastavovat currentFocus"
    currentFocus isNil ifTrue: [
        ^ self currentNodeSet.
    ] ifFalse: [
        ^XQuerySequence with: currentFocus contextItem
    ].

    "Created: / 07-11-2006 / 22:04:03 / ked"
    "Modified: / 21-03-2007 / 23:01:12 / janfrog"
    "Modified: / 19-07-2009 / 17:56:43 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstDecimalLiteral:anObject 
    "dispatched back from the visited astDecimalLiteral-object (visitor pattern)"
    
    ^XQuerySequence with: ((AtomicItem withValue: anObject content) castAs: 'xs:decimal').

    "Created: / 06-07-2006 / 19:12:09 / ked"
    "Modified: / 08-10-2006 / 13:35:40 / ked"
    "Modified: / 21-03-2007 / 13:54:01 / janfrog"
    "Modified: / 15-10-2009 / 20:21:56 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstDefaultNamespaceDecl: anObject

    | nsUri |
    nsUri := anObject uri content. "because it is instance of AstStringLiteral"
    nsUri := nsUri copyFrom:2 to: nsUri size - 1.

    anObject type == #element
        ifTrue:[defaultElementNamespaceURI := nsUri]
        ifFalse:[defaultFunctionNamespaceURI := nsUri]

    "Created: / 24-12-2006 / 15:12:53 / janfrog"
    "Modified: / 24-12-2006 / 17:18:40 / janfrog"
!

visitAstDeleteExpr:anObject 
    |targetSeq deleteCmd|

    targetSeq := self visit:anObject targetExpr.
    self announceTracepointInterrupt.
    deleteCmd := DeleteCommand new targetSequence:targetSeq.
    pendingUpdateList := pendingUpdateList mergeWith:deleteCmd.
    ^ (XQuerySequence new)

    "Modified: / 08-11-2007 / 00:25:34 / beyboy"
    "Modified: / 14-11-2007 / 11:31:24 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstDeleteTriggerExpr:anObject
  |createCmd|

    createCmd := self visit:anObject triggerBodyExpr.
    self announceTracepointInterrupt.
    createCmd event:'delete'.
    ^createCmd.

    "Created: / 10-04-2012 / 20:30:10 / Adam Senk <senkadam@gmail.com>"
!

visitAstDirAttributeList:anObject 
    "dispatched back from the visited astDirAttributeList-object (visitor pattern)"

    ^ self shouldNeverBeSent.

    "Modified: / 25-07-2009 / 23:32:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstDirAttributeListElem:anObject
    "dispatched back from the visited astCompAttrConstructor-object (visitor pattern)"

    | seqItem valueSeq qName|

    seqItem := NodeItem withNode: 'attribute'.
    valueSeq := (self visit: anObject dirAttributeValue).
    self assert: valueSeq size = 1.
    seqItem dmTypedValue: (valueSeq first).


    qName := (self visit: anObject qName) first.
    (self isNamespaceDeclaration: qName) ifTrue: [
        self addUri: (seqItem dmTypedValue stringValue) toNamespacePrefix: (qName localName).
    ].
    seqItem dmNodeName: qName.

    ^ XQuerySequence with:seqItem.

    "Modified: / 09-11-2006 / 23:45:28 / ked"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-03-2007 / 23:01:12 / janfrog"
    "Created: / 25-07-2009 / 23:30:02 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 14:21:17 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstDirElemConstructor:anObject 
    "dispatched back from the visited astCompElemConstructor-object (visitor pattern)"
    
    |qName seqItem value|

    seqItem := NodeItem withNode: 'element'.
    qName := (self visit: anObject qName) first.
    self announceTracepointInterrupt.
    seqItem dmNodeName: qName.

    self 
        appendSequence:(self visitCollection:anObject dirAttributeList)
        toConstructedElement:seqItem
        whichIsDocument:false.



    " 3. Adjacent text nodes in the content sequence are merged into a single text 
        node by concatenating their contents, with no intervening blanks. After concatenation, 
        any text node whose content is a zero-length string is deleted from the content sequence."

    value := ''.
    (self visitCollection:anObject dirElemContent) do:
    [ :item |
        item isAtomicValue ifTrue: [
            value := value, item stringValue.
        ]
        ifFalse:
        [
            (value size ~= 0) ifTrue: [(NodeItem withText: value) appendInto: seqItem.].
            item appendInto: seqItem.
        ].
    ].
    (value size ~= 0) ifTrue: [(NodeItem withText: value) appendInto: seqItem.].


    ^ XQuerySequence with:(seqItem).

    "Created: / 06-07-2006 / 19:12:09 / ked"
    "Modified: / 09-11-2006 / 23:53:01 / ked"
    "Modified: / 28-03-2007 / 22:40:16 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 17:46:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstDirElemContent:anObject 
    | contentSeq item |
    self announceTracepointInterrupt.
    ^ contentSeq := self visit:anObject content.

"/    item := NodeItem withNode: 'element'.
"/    item dmBaseUri: self baseUri.

"/    contentSeq do: [ : cItem |
"/        cItem appendInto: item.
"/    ].

"/    ^ (XQuerySequence withAll: item xpathChild) 
"/        addAll: item xpathAttribute;
"/        yourself

    "Modified: / 28-03-2007 / 23:11:41 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 17:11:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstDisconnectTriggerExpr: anObject
  |targetSeq disconnectCmd|

    targetSeq := self visit:anObject targetExpr.
    self announceTracepointInterrupt.
    disconnectCmd := (DisConnectCommand new)
                targetSequence:targetSeq.

        self halt.
    pendingUpdateList := pendingUpdateList mergeWith:disconnectCmd.
    ^ (XQuerySequence new)

    "Created: / 10-04-2012 / 19:14:00 / Adam Senk <senkadam@gmail.com>"
!

visitAstDocumentTest:anObject 
    "dispatched back from the visited astDocumentTest-object (visitor pattern)"
    
    |givenContext resultDataContext childrenDataContext|

    self 
        halt:'Not yet ported. Ask Jan Vrany <vranyj1@fel.cvut.cz> for further explanation'.
    resultDataContext := OrderedCollection new.
    givenContext dataContext do:[:dataContextItem | 
        (dataContextItem type isSubtypeOf:XQuerySequenceItem typeNode) ifTrue:[
            dataContextItem item xpathIsDocument ifTrue:[
                anObject elementTest 
                    ifNil:[ resultDataContext add:dataContextItem. ]
                    ifNotNil:[
                        childrenDataContext := dataContextItem item xpathChild.
                        childrenDataContext size = 1 ifTrue:[
                            context := givenContext copyContext dataContext:childrenDataContext.
                            self visit:(anObject elementTest).
                            context dataContext size = 1 ifTrue:[
                                resultDataContext add:dataContextItem.
                            ].
                        ].
                    ].
            ].
        ].
    ].
    context := givenContext copyContext dataContext:resultDataContext.

    "Created: / 21-11-2006 / 21:55:21 / ked"
    "Modified: / 23-11-2006 / 12:23:53 / ked"
    "Modified: / 05-12-2007 / 21:21:33 / janfrog"
    "Modified: / 18-09-2008 / 17:47:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstDoubleLiteral:anObject 
    "dispatched back from the visited astDoubleLiteral-object (visitor pattern)"

    ^XQuerySequence with: ((AtomicItem withValue: anObject content) castAs: 'xs:double').
    
"/    context := context copyContext
"/                dataContextSingle:(XQueryConstructedItem new
"/                        item:(anObject content))

    "Created: / 06-07-2006 / 19:12:10 / ked"
    "Modified: / 08-10-2006 / 13:35:49 / ked"
    "Modified: / 05-12-2007 / 15:21:44 / janfrog"
    "Modified: / 18-09-2008 / 15:40:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-10-2009 / 22:01:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstDropTriggerExpr: anObject
  |name dropCmd|

    name := self visit:anObject name.
    self announceTracepointInterrupt.
    dropCmd := (DropCommand new)
                name: name.

        self halt.
    pendingUpdateList := pendingUpdateList mergeWith:dropCmd.
    ^ (XQuerySequence new)

    "Created: / 10-04-2012 / 19:48:19 / Adam Senk <senkadam@gmail.com>"
!

visitAstDummyNode: anObject

    ^self visit: anObject dummyNode

    "Created: / 28-03-2007 / 20:25:32 / janfrog"
!

visitAstElementContentChar: elementContentChar
    ^ XQuerySequence withString: elementContentChar content.

    "Created: / 19-07-2009 / 14:49:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstElementNameOrWildcard:anObject 
    "dispatched back from the visited astElementNameOrWildcard-object (visitor pattern)"

    |name|
    "TODO: this code needs revision - written without proper knowledge of the
        whole xquery exectuion process"
    name := (self visit:(anObject elementName)) first.
    ^ self currentNodeSet:(self currentNodeSet 
                select:[:item | item dmNodeName = name ]).

    "Created: / 21-11-2006 / 22:00:20 / ked"
    "Modified: / 23-11-2006 / 13:33:54 / ked"
    "Modified: / 05-12-2007 / 21:21:33 / janfrog"
    "Modified: / 18-09-2008 / 17:47:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 12:35:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstElementTest:anObject 
    "dispatched back from the visited astElementTest-object (visitor pattern)"
    
    |givenContext elementNameNode|

    self 
        halt:'Not yet ported. Ask Jan Vrany <vranyj1@fel.cvut.cz> for further explanation'.
    anObject elementName 
        ifNil:[
            elementNameNode := AstElementNameOrWildcard new.
            self visit:elementNameNode.
        ]
        ifNotNil:[ self visit:(anObject elementName). ].
    self announceTracepointInterrupt.

    "Created: / 21-11-2006 / 21:59:28 / ked"
    "Modified: / 23-11-2006 / 13:07:57 / ked"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstEnclosedExpr:anObject 

    ^self visit:(anObject expr).

    "Created: / 06-11-2006 / 22:40:40 / ked"
    "Modified: / 09-11-2006 / 18:45:20 / ked"
    "Modified: / 28-03-2007 / 23:05:47 / janfrog"
!

visitAstExpr:anObject 

    ^(self visit:anObject exprSingle)
        addAll:(self visit:anObject expr);
        yourself.

    "Created: / 06-07-2006 / 19:12:10 / ked"
    "Modified: / 08-10-2006 / 13:36:20 / ked"
    "Modified: / 21-03-2007 / 14:20:09 / janfrog"
!

visitAstFLWORExpr:anObject 
    |forLetClauses result|

    "/self visit:anObject flworExpr_ForLet.
    forLetClauses := anObject flworExpr_ForLet asCollectionOfForLetClauses.
    result := XQuerySequence new:16.

    self 
        bloomForLetClauses: forLetClauses
        using:
            [(self visit: anObject whereClause) effectiveBooleanValue
                ifTrue:[result addAll: (self visit: anObject exprSingle)]].

    ^result

    "Modified: / 30-11-2006 / 23:49:28 / ked"
    "Created: / 26-03-2007 / 23:22:18 / janfrog"
    "Modified: / 28-03-2007 / 21:28:14 / janfrog"
!

visitAstFLWORExpr_ForLet:anObject 
    "dispatched back from the visited astFLWORExpr_ForLet-object (visitor pattern)"
    
    anObject letClause 
        ifNotNil:[
            self visit:(anObject letClause).
            self announceTracepointInterrupt
        ].
    anObject forClause 
        ifNotNil:[
            self visit:(anObject forClause).
            self announceTracepointInterrupt.
        ].
    anObject flworExpr_ForLet 
        ifNotNil:[ self visit:(anObject flworExpr_ForLet) ].

    "Created: / 06-07-2006 / 19:12:10 / ked"
    "Modified: / 02-11-2006 / 10:33:16 / ked"
    "Modified: / 28-03-2007 / 16:52:22 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstFilterExpr:anObject 
    "dispatched back from the visited astFilterExpr-object (visitor pattern)"
    
    self currentNodeSet:(self visit:(anObject primaryExpr)).
    self announceTracepointInterrupt.
    anObject predicateList do:[:xpathPredicate | 
        self currentNodeSet:(self visit:xpathPredicate).
        self announceTracepointInterrupt.
    ].
    ^ self currentNodeSet

    "Created: / 06-07-2006 / 19:12:10 / ked"
    "Modified: / 13-10-2006 / 14:37:06 / ked"
    "Modified: / 05-12-2007 / 10:37:08 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstForClause:anObject 

    "there is no so much work to do - see visitFLWORExpr:"
    anObject forClause ifNotNil:
        [self visit:(anObject forClause)].

    "Created: / 06-07-2006 / 19:12:10 / ked"
    "Modified: / 02-11-2006 / 10:33:38 / ked"
    "Modified: / 28-03-2007 / 16:54:14 / janfrog"
    "Modified: / 24-09-2008 / 07:49:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstForwardStep:anObject 
    "dispatched back from the visited astForwardStep-object (visitor pattern)"
    
    anObject abbrevForwardStep 
        ifNil:[
            "evaluate axis"
            self currentNodeSet:(self currentNodeSet 
                        inject:(XQuerySequence new:(self currentNodeSet size * 2))
                        into:[:newNodeSet :nodeSetItem | 
                            newNodeSet
                                addAll:(nodeSetItem item perform:anObject forwardAxis);
                                yourself
                        ]).
            self currentNodeSet:(self visit:anObject nodeTest).
        ]
        ifNotNil:[ self currentNodeSet:(self visit:anObject abbrevForwardStep) ].
    ^ self currentNodeSet

    "Created: / 06-07-2006 / 19:12:10 / ked"
    "Modified: / 02-12-2006 / 11:05:30 / ked"
    "Modified: / 08-11-2007 / 00:25:01 / beyboy"
    "Modified: / 05-12-2007 / 10:37:09 / janfrog"
!

visitAstFunctionCall:anObject 
    "dispatched back from the visited astFunctionCall-object (visitor pattern)"
    
    |functionQName retval  |

    functionQName := (self visit:anObject qname) first asString.
    anObject functionParametersList 
        ifNil:[
            retval := self funcTable 
                        evaluate:functionQName
                        inContext:context
                        withParameters:(OrderedCollection new)
                        forInterpreter:self.
        ]
        ifNotNil:[
            |params|

            params := self visit:anObject functionParametersList.
            retval := self funcTable 
                        evaluate:functionQName
                        inContext:context
                        withParameters:params
                        forInterpreter:self.
        ].
    ^ retval

    "Created: / 06-07-2006 / 19:12:11 / ked"
    "Modified: / 23-11-2006 / 19:12:01 / ked"
    "Modified: / 28-08-2007 / 22:48:21 / janfrog"
    "Modified: / 18-09-2008 / 15:40:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:29:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstFunctionDecl:anObject

    | function |
    function := UserDefinedFunction new
                    name: (XMLv2::NodeName
                        fromString: anObject name content
                        andPrefixToNamespaceURIMapping: prefixToNamespaceURIMapping
                        defaultNS: defaultFunctionNamespaceURI );

                    params: (anObject paramList collect:[:e|FunctionParam new name: (self visit: e name)]);

                    body: anObject body.

    funcTable defineFunction: function

    "Modified: / 28-12-2006 / 16:34:12 / janfrog"
    "Modified: / 19-09-2009 / 15:25:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstFunctionParametersList:anObject 

    | params |
    params := anObject functionParametersList
                    ifNil:[OrderedCollection new: 4]
                    ifNotNil:[self visit: anObject functionParametersList].

    params addFirst: (self visit:anObject exprSingle).

    ^params

    "Created: / 11-11-2006 / 18:51:30 / ked"
    "Modified: / 23-11-2006 / 18:54:41 / ked"
    "Modified: / 28-03-2007 / 23:00:55 / janfrog"
!

visitAstIfExpr:anObject 
    |conditionValue|

    XQuerySequenceError handle: [ :ex |
        XQueryInterpreterError raiseErrorString: ex asString.
    ] do: [
        conditionValue := (self visit:anObject expr) effectiveBooleanValue.
    ].
    self announceTracepointInterrupt.
    ^ conditionValue 
        ifTrue:[ self visit:anObject trueExprSingle ]
        ifFalse:[ self visit:anObject falseExprSingle ]

    "Modified: / 21-03-2007 / 14:57:38 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-09-2009 / 15:15:18 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstInsertAfterExpr:anObject 
    |sourceSeq targetSeq insertCmd|

    targetSeq := self visit:anObject targetExpr.
    sourceSeq := self visit:anObject sourceExpr.
    self announceTracepointInterrupt.
    insertCmd := (InsertAfterCommand new)
                targetSequence:targetSeq;
                sourceSequence:sourceSeq.
    pendingUpdateList := pendingUpdateList mergeWith:insertCmd.
    ^ (XQuerySequence new)

    "Modified: / 21-11-2007 / 09:04:57 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstInsertAsFirstIntoExpr:anObject 
    |sourceSeq targetSeq insertCmd|

    targetSeq := self visit:anObject targetExpr.
    sourceSeq := self visit:anObject sourceExpr.
    self announceTracepointInterrupt.
    insertCmd := (InsertAsFirstIntoCommand new)
                targetSequence:targetSeq;
                sourceSequence:sourceSeq.
    pendingUpdateList := pendingUpdateList mergeWith:insertCmd.
    ^ (XQuerySequence new)

    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstInsertAsLastIntoExpr:anObject 
    |sourceSeq targetSeq insertCmd|

    targetSeq := self visit:anObject targetExpr.
    sourceSeq := self visit:anObject sourceExpr.
    self announceTracepointInterrupt.
    insertCmd := (InsertAsLastIntoCommand new)
                targetSequence:targetSeq;
                sourceSequence:sourceSeq.
    pendingUpdateList := pendingUpdateList mergeWith:insertCmd.
    ^ (XQuerySequence new)

    "Modified: / 21-11-2007 / 12:46:18 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstInsertBeforeExpr:anObject 
    |sourceSeq targetSeq insertCmd|

    targetSeq := self visit:anObject targetExpr.
    sourceSeq := self visit:anObject sourceExpr.
    self announceTracepointInterrupt.
    insertCmd := (InsertBeforeCommand new)
                targetSequence:targetSeq;
                sourceSequence:sourceSeq.
    pendingUpdateList := pendingUpdateList mergeWith:insertCmd.
    ^ (XQuerySequence new)

    "Modified: / 21-11-2007 / 12:46:32 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstInsertIntoExpr:anObject 
    |sourceSeq targetSeq insertCmd|

    targetSeq := self visit:anObject targetExpr.
    sourceSeq := self visit:anObject sourceExpr.
    self announceTracepointInterrupt.
    insertCmd := (InsertIntoCommand new)
                targetSequence:targetSeq;
                sourceSequence:sourceSeq.
    pendingUpdateList := pendingUpdateList mergeWith:insertCmd.
    ^ (XQuerySequence new)

    "Modified: / 21-11-2007 / 12:46:40 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstInstanceOfExpr:instanceOfExpr 
    | treatSeq |
    treatSeq := (self visit: instanceOfExpr treatExpr).

    
    instanceOfExpr sequenceType ifNil: [ ^ treatSeq ].

    self currentNodeSet: treatSeq.
    ^ self visit: instanceOfExpr sequenceType.

    "Modified: / 15-10-2009 / 00:00:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstIntegerLiteral:anObject 
    "dispatched back from the visited astIntegerLiteral-object (visitor pattern)"
    
    self announceTracepointInterrupt.
    ^ XQuerySequence with: ((AtomicItem withValue: anObject content) castAs: 'xs:integer').

    "Created: / 06-07-2006 / 19:12:11 / ked"
    "Modified: / 08-10-2006 / 13:40:04 / ked"
    "Modified: / 21-03-2007 / 13:53:11 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-10-2009 / 20:19:55 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstIntersectExceptExpr:anObject 
    "dispatched back from the visited astIntersectExceptExpr-object (visitor pattern)"
    
    |givenContext unaryContext intersectExceptContext nonuniqueDataContext resultDataContext|

    self 
        halt:'Not yet ported. Ask Jan Vrany <vranyj1@fel.cvut.cz> for further explanation'.
    self visit:(anObject unaryExpr).
    unaryContext := context.
    context := givenContext.
    self visit:(anObject intersectExceptExpr).
    intersectExceptContext := context.
    context := givenContext copyContext.
    nonuniqueDataContext := OrderedCollection new.
    anObject operand = #intersect ifTrue:[
        "The intersect operator takes two node sequences as operands and returns a sequence
         containing all the nodes that occur in both operands."
        unaryContext dataContext do:[:unaryDataContextItem | 
            self 
                assert:(unaryDataContextItem type isSubtypeOf:XQuerySequenceItem typeNode).
            (intersectExceptContext dataContext 
                anySatisfy:[:intersectExceptDataContextItem | 
                    self assert:(intersectExceptDataContextItem type 
                                isSubtypeOf:XQuerySequenceItem typeNode).
                    intersectExceptDataContextItem item = unaryDataContextItem item.
                ]) 
                    ifTrue:[ nonuniqueDataContext add:unaryDataContextItem. ].
        ].
    ] ifFalse:[
        "The except operator takes two node sequences as operands and returns a sequence
         containing all the nodes that occur in the first operand but not in the second operand."
        unaryContext dataContext do:[:unaryDataContextItem | 
            self 
                assert:(unaryDataContextItem type isSubtypeOf:XQuerySequenceItem typeNode).
            (intersectExceptContext dataContext 
                anySatisfy:[:intersectExceptDataContextItem | 
                    self assert:(intersectExceptDataContextItem type 
                                isSubtypeOf:XQuerySequenceItem typeNode).
                    intersectExceptDataContextItem item = unaryDataContextItem item.
                ]) 
                    ifFalse:[ nonuniqueDataContext add:unaryDataContextItem. ].
        ].
    ].
    resultDataContext := OrderedCollection new.
    self uniqueAddNodeSequence:nonuniqueDataContext to:resultDataContext.
    context dataContext:resultDataContext.

    "Created: / 06-07-2006 / 19:12:11 / ked"
    "Modified: / 01-12-2006 / 16:48:18 / ked"
    "Modified: / 05-12-2007 / 21:21:33 / janfrog"
    "Modified: / 18-09-2008 / 17:47:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstItemType: itemType 
    "dispatched back from the visited astItemType-object (visitor pattern)"

    itemType itemTest ifNotNil: [
        ^ self visit: itemType itemTest.
    ].

    itemType kindTest ifNotNil: [
        ^ self visit: itemType kindTest.
    ].

    itemType atomicType ifNotNil: [
        | type |
        type := (self visit: itemType atomicType) first.
        ^ self currentNodeSet select: [: item | item isSubtypeOf: type qName ].
    ].

    ^ self shouldNeverBeReached.

    "Modified: / 15-10-2009 / 13:30:15 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstItemTypeItem:anObject 
    "every data type is item"
    ^ self currentNodeSet.

    "Created: / 10-05-2009 / 14:33:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstLetClause:anObject 
    |name value|

    name := self visit:anObject varName.
    value := self visit:anObject exprSingle.
    self announceTracepointInterrupt.
    self bindVar:name to:value.
    self visit:anObject letClause.

    "Created: / 06-07-2006 / 19:12:11 / ked"
    "Modified: / 03-12-2006 / 17:06:43 / ked"
    "Modified: / 28-03-2007 / 18:10:35 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-09-2009 / 15:10:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstMainModule:anObject 

    ^self 
        visit: anObject prolog;
        visit: anObject queryBody

    "Modified: / 12-10-2006 / 23:08:51 / ked"
    "Created: / 24-12-2006 / 14:57:06 / janfrog"
    "Modified: / 24-12-2006 / 16:19:06 / janfrog"
!

visitAstModuleImport: anObject

    | prefix uri |
    uri := anObject uri content. "because it is instance of AstStringLiteral"
    uri := uri copyFrom:2 to: uri size - 1.

    anObject prefix ifNotNil: 
        [prefix := anObject prefix content.
        prefix = 'xml' ifTrue:[self error:'Cannot redefine ''xml'' namespace prefix.'].
        prefix = 'xmlns' ifTrue:[self error:'Cannot bind ''xmlns'' prefix to namespace uri'].
        prefixToNamespaceURIMapping 
            at: prefix
            put: uri].

    self loadFunctionLibraryWithURI: uri

    "Modified: / 24-12-2006 / 17:16:56 / janfrog"
    "Created: / 01-12-2008 / 09:54:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstMultiplicativeExpr:anObject 
    |leftSequence rightSequence left right multiplicativeOperations |

    self announceTracepointInterrupt.
    "  Each operand is evaluated by applying the following steps, in order:

        1.Atomization is applied to the operand. The result of this operation is called the atomized operand.
    "
    leftSequence := (self visit:anObject unionExpr) asAtomizedSequence .
    rightSequence := (self visit:anObject multiplicativeExpr) asAtomizedSequence.
    "   2.If the atomized operand is an empty sequence, the result of the arithmetic expression is an empty sequence, 
        and the implementation need not evaluate the other operand or apply the operator. However, an implementation 
        may choose to evaluate the other operand in order to determine whether it raises an error."
    (leftSequence size = 0) ifTrue:[
        ^ XQuerySequence new:0
    ].
    (rightSequence size = 0) ifTrue:[
        ^ XQuerySequence new:0
    ].

    
    "   3.If the atomized operand is a sequence of length greater than one, a type error is raised [err:XPTY0004]."
    (leftSequence size > 1) ifTrue: [ self raiseError: 'err:XPTY0004'].
    (rightSequence size > 1) ifTrue: [ self raiseError: 'err:XPTY0004'].
        
    "   4.If the atomized operand is of type xs:untypedAtomic, it is cast to xs:double. If the cast fails, a dynamic 
        error is raised. [err:FORG0001]"
    left := leftSequence first.
    right := rightSequence first.

    (left isType: 'xs:untypedAtomic') ifTrue: [
        left := left castAs: 'xs:double'.
    ].

    (right isType: 'xs:untypedAtomic') ifTrue: [
        right := right castAs: 'xs:double'.
    ].

     "evaluate operation"
    multiplicativeOperations := (Dictionary new)
                at:#krat put:[ 'op:numeric-multiply' ];
                at:#div put:[ 'op:numeric-divide' ];
                at:#idiv put:[ 'op:numeric-integer-divide' ];
                at:#mod put:[ 'op:numeric-mod' ];
                yourself.

    ^ self funcTable 
        evaluate:((multiplicativeOperations at:anObject operand) value)
        inContext:context
        withParameters: (OrderedCollection with: left with: right)
        forInterpreter:self.



"/    result := ((multiplicativeOperations at:anObject operand) 
"/                 value:left
"/                 value:right).
"/
"/    ^ XQuerySequence with: ((AtomicItem withValue: result) asGuessedType).

    "Created: / 06-07-2006 / 19:12:11 / ked"
    "Modified: / 08-10-2006 / 20:15:22 / ked"
    "Modified: / 21-03-2007 / 15:46:55 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-11-2009 / 16:38:25 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstNCName:anObject 
    "dispatched back from the visited astNCName-object (visitor pattern)"

    ^ XQuerySequence with: (AtomicItem withValue: (anObject content) asType: 'xs:NCName').

    "Created: / 06-07-2006 / 19:12:11 / ked"
    "Modified: / 18-11-2006 / 16:26:33 / ked"
    "Modified: / 28-03-2007 / 23:12:55 / janfrog"
    "Modified: / 07-10-2009 / 11:40:54 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstNameTest:anObject 
    "dispatched back from the visited astNameTest-object (visitor pattern)"
    
    anObject qname 
        ifNotNil:[
            |nodename|

            nodename := self xmlNodeNameFromQName:(self visit:anObject qname).
            ^ self currentNodeSet:(self currentNodeSet 
                        select:[:nodeSetItem | 
                            (nodeSetItem type isSubtypeOf: (TypeFactory getType: 'node')) 
                                and:[
                                    nodeSetItem item isElementOrAttributeNode 
                                        and:[
                                            nodeSetItem item xpathNamespace = nodename ns 
                                                and:[ nodeSetItem item xpathLocalName = nodename localName ]
                                        ]
                                ]
                        ])
        ].
    anObject wildcard 
        ifNotNil:[
            |wildcard|

            wildcard := self visit:anObject wildcard.
            ^ self currentNodeSet:(self currentNodeSet select:[:nodeSetItem | true ])
        ].
    self shouldNeverBeReached

    "Created: / 12-10-2006 / 21:58:21 / ked"
    "Modified: / 02-12-2006 / 12:20:41 / ked"
    "Modified: / 05-12-2007 / 21:21:33 / janfrog"
    "Modified: / 09-05-2009 / 12:19:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstNamespaceDecl: anObject

    | prefix nsUri |
    prefix := anObject prefix content. "because it is instance of AstNCName"
    nsUri := anObject nsuri content. "because it is instance of AstStringLiteral"
    nsUri := nsUri copyFrom:2 to: nsUri size - 1.


    ^ self addUri: nsUri toNamespacePrefix: prefix.

    "Created: / 24-12-2006 / 15:12:58 / janfrog"
    "Modified: / 24-12-2006 / 17:16:56 / janfrog"
    "Modified: / 18-09-2009 / 15:19:11 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstNodeTriggerExpr:anObject
  |createCmd|

    createCmd := self visit:anObject triggerNameAndTargetExpr.
    self announceTracepointInterrupt.
    createCmd type:'node'.
      self halt.
    pendingUpdateList := pendingUpdateList mergeWith:createCmd.
    ^ (XQuerySequence new)

    "Created: / 10-04-2012 / 20:26:10 / Adam Senk <senkadam@gmail.com>"
!

visitAstOneOccurrenceIndicator:anObject 
    ^XQuerySequence withBoolean:(self currentNodeSet size = 1).

    "Created: / 10-05-2009 / 15:26:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstOneOrMultipleOccurrenceIndicator:anObject 
    ^XQuerySequence withBoolean:(self currentNodeSet size >= 1).

    "Modified: / 10-05-2009 / 15:34:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstOrExpr:anObject 
    "dispatched back from the visited astAdditiveExpr-object (visitor pattern)"
    
    |leftSequence rightSequence|

    leftSequence := self visit:anObject andExpr.
    rightSequence := self visit:anObject orExpr.
    self announceTracepointInterrupt.
     "evaluate operation"
    ^ XQuerySequence withBoolean:(leftSequence effectiveBooleanValue 
                or:[ rightSequence effectiveBooleanValue ])

    "Created: / 06-07-2006 / 19:12:08 / ked"
    "Modified: / 08-10-2006 / 20:15:15 / ked"
    "Modified: / 21-03-2007 / 15:09:13 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 10:21:25 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstOrderByClause:anObject 
    "dispatched back from the visited astOrderByClause-object (visitor pattern)"
    
    |givenContext|

    self 
        halt:'Not yet ported. Ask Jan Vrany <vranyj1@fel.cvut.cz> for further explanation'.
    context := givenContext copyContext optContextEmpty.
    context optContext at:#orderSpecList put:(OrderedCollection new).
    self visit:(anObject orderSpecList).

    "Created: / 06-07-2006 / 19:12:12 / ked"
    "Modified: / 26-11-2006 / 20:06:09 / ked"
    "Modified: / 18-09-2008 / 17:47:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstOrderModifier:anObject 
    "dispatched back from the visited astOrderModifier-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 06-07-2006 / 19:12:12 / ked"
!

visitAstOrderSpec:anObject 
    "dispatched back from the visited astOrderSpec-object (visitor pattern)"
    
    |givenContext orderSpecItem|

    self 
        halt:'Not yet ported. Ask Jan Vrany <vranyj1@fel.cvut.cz> for further explanation'.
    self visit:(anObject exprSingle).
    orderSpecItem := XQueryOrderSpecItem new orderValue:context dataContext.
    context := givenContext copyContext.
    anObject orderModifier 
        ifNotNil:[
            anObject orderModifier ascDesc 
                ifNotNil:[ orderSpecItem ascDesc:anObject orderModifier ascDesc. ].
            anObject orderModifier greatestLeast 
                ifNotNil:[
                    orderSpecItem emptyGreatestLeast:anObject orderModifier greatestLeast.
                ].
        ].
    (context optContext at:#orderSpecList) addFirst:orderSpecItem.

    "Created: / 06-07-2006 / 19:12:12 / ked"
    "Modified: / 30-11-2006 / 15:18:28 / ked"
    "Modified: / 18-09-2008 / 17:47:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstOrderSpecList:anObject 
    "dispatched back from the visited astOrderSpecList-object (visitor pattern)"
    
    |givenContext orderSpecContext orderSpecItem|

    self 
        halt:'Not yet ported. Ask Jan Vrany <vranyj1@fel.cvut.cz> for further explanation'.
    context := givenContext copyContext optContextEmpty.
    context optContext at:#orderSpecList put:(OrderedCollection new).
    self visit:(anObject orderSpec).
    orderSpecContext := context.
    context := givenContext.
    orderSpecItem := (orderSpecContext optContext at:#orderSpecList) first.
    anObject orderSpecList ifNotNil:[ self visit:(anObject orderSpecList). ].
    (context optContext at:#orderSpecList) addFirst:orderSpecItem.

    "Created: / 06-07-2006 / 19:12:12 / ked"
    "Modified: / 30-11-2006 / 15:21:31 / ked"
    "Modified: / 18-09-2008 / 17:47:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstParenthesizedExpr:anObject 
    "dispatched back from the visited astParenthesizedExpr-object (visitor pattern)"

    ^anObject expr 
        ifNotNil:[self visit:anObject expr]
        ifNil:[XQuerySequence new]

    "Created: / 08-07-2006 / 18:40:13 / ked"
    "Modified: / 02-11-2006 / 10:42:34 / ked"
    "Modified: / 29-03-2007 / 10:06:39 / janfrog"
!

visitAstPathExpr:anObject 
    "dispatched back from the visited astPathExpr-object (visitor pattern)"
    
    |givenContext expandedDataContext resultDataContext|

    self 
        halt:'Not yet ported. Ask Jan Vrany <vranyj1@fel.cvut.cz> for further explanation'.
    context := givenContext copyContext.
    anObject startSign = #slash ifTrue:[
        resultDataContext := OrderedCollection new.
        self 
            innerFocusIn:context
            do:[:dataContextItem :innerFocusItem | 
                self 
                    assert:(dataContextItem type isSubtypeOf:XQuerySequenceItem typeNode).
                expandedDataContext := OrderedCollection new.
                expandedDataContext addAll:(dataContextItem item xpathDocument).
            ]
            withResultDo:[:dataContextItem :innerFocusItem :exprContext | 
                self uniqueAddNodeSequence:expandedDataContext to:resultDataContext.
            ].
        context := givenContext dataContext:resultDataContext.
    ].
    anObject startSign = #slashSlash ifTrue:[
        resultDataContext := OrderedCollection new.
        self 
            innerFocusIn:context
            do:[:dataContextItem :innerFocusItem | 
                self 
                    assert:(dataContextItem type isSubtypeOf:XQuerySequenceItem typeNode).
                expandedDataContext := OrderedCollection new.
                expandedDataContext 
                    addAll:(dataContextItem item xpathDocument first item 
                            xpathDescendantOrSelf).
            ]
            withResultDo:[:dataContextItem :innerFocusItem :exprContext | 
                self uniqueAddNodeSequence:expandedDataContext to:resultDataContext.
            ].
        context := givenContext dataContext:resultDataContext.
    ].
    resultDataContext := OrderedCollection new.
    self 
        innerFocusIn:context
        do:[:dataContextItem :innerFocusItem | self visit:(anObject relativePathExpr). ]
        withResultDo:[:dataContextItem :innerFocusItem :exprContext | 
            self uniqueAddNodeSequence:exprContext dataContext to:resultDataContext.
        ].
    context dataContext:resultDataContext.

    "Created: / 06-07-2006 / 19:12:12 / ked"
    "Modified: / 02-12-2006 / 11:25:43 / ked"
    "Modified: / 05-12-2007 / 21:03:38 / janfrog"
    "Modified: / 18-09-2008 / 17:47:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstPredefinedEntityRef:anObject 
    "dispatched back from the visited astPredefinedEntityRef-object (visitor pattern)"

    | predefinedEntities |

    predefinedEntities := Dictionary new
                            at: '&lt;' put: '<';
                            at: '&gt;' put: '>';
                            at: '&amp;' put: '&';
                            at: '&apos;' put: '''';
                            yourself.

    self error: 'TODO TODO TODO'.
"/    context := context copyContext
"/                dataContextSingle:(XQueryConstructedItem new
"/                        item:(predefinedEntities at:(anObject content));
"/                        type: (TypeFactory getType: 'xs:string')).

    "Created: / 06-07-2006 / 19:12:12 / ked"
    "Modified: / 03-12-2006 / 16:53:19 / ked"
    "Modified: / 21-03-2007 / 13:16:53 / janfrog"
    "Modified: / 18-09-2008 / 15:40:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-06-2009 / 19:55:50 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 28-01-2010 / 10:52:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitAstPredicate:anObject 
    "dispatched back from the visited astPredicate-object (visitor pattern)"
    
    ^ self 
        withFocusDo:[
            self currentNodeSet:(self currentNodeSet 
                        select:[:nodeSetItem | 
                            |exprSeq|

                            currentFocus
                                contextItem:nodeSetItem;
                                contextPositionAdvance.
                            self currentNodeSet:(XQuerySequence with:currentFocus contextItem).
                            exprSeq := self visit:anObject expr.
                            exprSeq containsSingleNumber ifTrue:[
                                currentFocus contextPosition = exprSeq asNumber
                            ] ifFalse:[
                                exprSeq effectiveBooleanValue
                            ]
                        ])
        ]

    "Created: / 06-07-2006 / 19:12:13 / ked"
    "Modified: / 01-12-2006 / 23:38:55 / ked"
    "Modified: / 05-12-2007 / 10:37:08 / janfrog"
    "Modified: / 04-10-2009 / 18:02:10 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 09:59:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitAstProlog: anObject

    anObject declarations do:[:e|self visit:e]

    "Created: / 24-12-2006 / 15:12:37 / janfrog"
!

visitAstQName:anObject 
    "dispatched back from the visited astQName-object (visitor pattern)"
    | qName |

    qName := self qNameFromAtomic: (AtomicItem withValue: anObject content).
    ^ XQuerySequence with: qName.

    "Created: / 06-07-2006 / 19:12:13 / ked"
    "Modified: / 08-10-2006 / 13:22:15 / ked"
    "Modified: / 20-03-2007 / 23:13:15 / janfrog"
    "Modified: / 06-10-2009 / 14:34:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstQuantifiedExpr:anObject 
    |quantifiedExprImpls bloomingBlock|

    quantifiedExprImpls := anObject quantifiedExpr_Impl 
                asCollectionOfQuantifiedExprImpls.
    bloomingBlock := anObject someEvery = #some ifTrue:[
                [
                |exprValue|

                exprValue := (self visit:anObject exprSingle) effectiveBooleanValue.
                self announceTracepointInterrupt.
                exprValue ifTrue:[
                    ^ XQuerySequence withBoolean:true
                ]
            ]
            ] ifFalse:[
                [
                |exprValue|

                exprValue := (self visit:anObject exprSingle) effectiveBooleanValue.
                self announceTracepointInterrupt.
                exprValue ifTrue:[
                    ^ XQuerySequence withBoolean:false
                ]
            ]
            ].
    self bloomQuantifiedExprImpls:quantifiedExprImpls using:bloomingBlock.
    ^ anObject someEvery = #some 
        ifTrue:[ XQuerySequence withBoolean:false ]
        ifFalse:[ XQuerySequence withBoolean:true ]

    "Modified: / 28-03-2007 / 22:30:30 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstQuantifiedExpr_Impl:anObject 
    "dispatched back from the visited astQuantifiedExpr_Impl-object (visitor pattern)"
    
    |givenContext quantifiedTuple|

    self 
        halt:'Not yet ported. Ask Jan Vrany <vranyj1@fel.cvut.cz> for further explanation'.
    quantifiedTuple := XQueryTupleItem new.
    quantifiedTuple forLet:#for.
    quantifiedTuple varExpr:(anObject exprSingle).
    quantifiedTuple varName:(self visit:anObject varName).
    context := givenContext copyContext.
    (context optContext at:#quantifiedTuple) add:quantifiedTuple.
    anObject quantifiedExpr_Impl 
        ifNotNil:[ self visit:(anObject quantifiedExpr_Impl). ].

    "Created: / 06-07-2006 / 19:12:13 / ked"
    "Modified: / 02-11-2006 / 11:21:32 / ked"
    "Modified: / 20-03-2007 / 23:36:54 / janfrog"
    "Modified: / 18-09-2008 / 17:47:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstRangeExpr:anObject 
    "dispatched back from the visited astRangeExpr-object (visitor pattern)"
    
    |fromSequence toSequence|

    fromSequence := self visit:(anObject additiveExprFrom).
    toSequence := self visit:(anObject additiveExprTo).
    self announceTracepointInterrupt.
    self assert:(fromSequence containsSingleNumber).
    self assert:(toSequence containsSingleNumber).

    ^ XQuerySequence withAll: 
        ((fromSequence first value to: toSequence first value) collect: [ : number |
            (AtomicItem withValue: number asType: 'xs:decimal') castAs: 'xs:integer'
        ])
"/    ^ XQuerySequence withNumbers:((fromSequence first asNumber) 
"/                to:(toSequence first asNumber))

    "Created: / 06-07-2006 / 19:12:13 / ked"
    "Modified: / 08-10-2006 / 13:25:33 / ked"
    "Modified: / 21-03-2007 / 14:28:03 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-11-2009 / 12:19:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstRelativePathExpr:anObject 
    "dispatched back from the visited astRelativePathExpr-object (visitor pattern)"
    
    self currentNodeSet:(self visit:anObject relativePathExpr).
    self announceTracepointInterrupt.
    anObject divSign = #slashSlash ifTrue:[
        |"descendant-or-self" abbrevExpandedNode|

        abbrevExpandedNode := (AstForwardStep new)
                    forwardAxis:#xpathDescendantOrSelf;
                    nodeTest:(AstAnyKindTest new).
        self currentNodeSet:(self visit:abbrevExpandedNode).
    ].
    anObject stepExpr 
        ifNotNil:[ self currentNodeSet:(self visit:anObject stepExpr) ].
    self currentNodeSet class == self class ifTrue:[
        self halt
    ].
    ^ self currentNodeSet

    "Created: / 06-07-2006 / 19:12:13 / ked"
    "Modified: / 01-12-2006 / 23:36:32 / ked"
    "Modified: / 08-11-2007 / 00:25:54 / beyboy"
    "Modified: / 05-12-2007 / 10:37:08 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstRenameExpr:anObject 
    |targetNode newName renameCmd|

    targetNode := self visit:anObject targetExpr.
    newName := self visit:anObject newNameExpr.
    self announceTracepointInterrupt.
    renameCmd := (RenameCommand new)
                targetSequence:targetNode;
                sourceSequence:newName.
    renameCmd execute.
   " pendingUpdateList := pendingUpdateList mergeWith:renameCmd. "
    ^ (XQuerySequence new)

    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 31-01-2012 / 22:36:07 / Adam Senk <senkadam@gmail.com>"
!

visitAstRenameTriggerExpr:anObject
  |createCmd|

    createCmd := self visit:anObject triggerBodyExpr.
    self announceTracepointInterrupt.
    createCmd event:'rename'.
    ^createCmd.

    "Created: / 10-04-2012 / 20:14:37 / Adam Senk <senkadam@gmail.com>"
!

visitAstReplaceExpr:anObject 
    |targetNode sourceNodes replaceCmd|

    targetNode := self visit:anObject targetExpr.
    sourceNodes := self visit:anObject sourceExpr.
    self announceTracepointInterrupt.
    replaceCmd := (ReplaceCommand new)
                targetSequence:targetNode;
                sourceSequence:sourceNodes.
    pendingUpdateList := pendingUpdateList mergeWith:replaceCmd.
    ^ (XQuerySequence new)

    "Modified: / 21-11-2007 / 12:00:06 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstReplaceTriggerExpr:anObject
  |createCmd|

    createCmd := self visit:anObject triggerBodyExpr.
    self announceTracepointInterrupt.
    createCmd event:'replace'.
    ^createCmd.

    "Created: / 10-04-2012 / 20:29:55 / Adam Senk <senkadam@gmail.com>"
!

visitAstReplaceValueOfExpr:anObject 
    |targetSequence newValue replaceValueOfCmd|

    targetSequence := self visit:anObject targetExpr.
    newValue := self visit:anObject sourceExpr.
    self announceTracepointInterrupt.
    targetSequence containsSingleElement ifFalse:[
        replaceValueOfCmd := (ReplaceValueOfCommand new)
                    targetSequence:targetSequence;
                    sourceSequence:newValue.
    ] ifTrue:[
        replaceValueOfCmd := (ReplaceElementContentCommand new)
                    targetSequence:targetSequence;
                    sourceSequence:newValue.
    ].
    pendingUpdateList := pendingUpdateList mergeWith:replaceValueOfCmd.
    ^ (XQuerySequence new)

    "Modified: / 14-11-2007 / 14:51:16 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstReverseStep:anObject 
    anObject abbrevReverseStep 
        ifNil:[
            "evaluate axis"
            self currentNodeSet:(self currentNodeSet 
                        inject:(XQuerySequence new:(self currentNodeSet size * 2))
                        into:[:newNodeSet :nodeSetItem | 
                            newNodeSet
                                addAll:(nodeSetItem item perform:anObject reverseAxis);
                                yourself
                        ]).
            self currentNodeSet:(self visit:anObject nodeTest)
        ]
        ifNotNil:[
            |expandedNode|

            expandedNode := (AstReverseStep new)
                        reverseAxis:#xpathParent;
                        nodeTest:(AstAnyKindTest new).
            self currentNodeSet:(self visit:expandedNode)
        ].
    ^ self currentNodeSet

    "Created: / 06-07-2006 / 19:12:14 / ked"
    "Modified: / 02-12-2006 / 11:07:04 / ked"
    "Modified: / 05-12-2007 / 10:37:08 / janfrog"
!

visitAstSequenceType:sequenceType 
    "2.5.4.1 Matching a SequenceType and a Value
        * The sequence type empty-sequence() matches a value that is the empty sequence.
        * An ItemType with no OccurrenceIndicator matches any value that contains exactly one item
            if the ItemType matches that item (see 2.5.4.2 Matching an ItemType and an Item).
        * An ItemType with an OccurrenceIndicator matches a value if the number of items in the value
            matches the OccurrenceIndicator and the ItemType matches each of the items in the value.

     An OccurrenceIndicator specifies the number of items in a sequence, as follows:
        * ? matches zero or one items
        * * matches zero or more items
        * + matches one or more items

     As a consequence of these rules, any sequence type whose OccurrenceIndicator is * or ? matches
        a value that is an empty sequence."

    "test empty sequence"
    sequenceType isWithEmptySequence ifTrue:[
        ^ XQuerySequence withBoolean:(self currentNodeSet size = 0).
    ].

    (self currentNodeSet size = (self visit:sequenceType itemType) size) ifTrue:[
        "every item is of the required type - test the occurrence"
        ^ self visit:sequenceType occurrenceIndicator.
    ].

    "every item is not of the required type"
    ^XQuerySequence withBoolean: false.

    "Modified: / 15-10-2009 / 14:04:53 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstSingleType:singleType 
    | atomicType |

    "empty sequence with ? occurence indicator"
    ((self currentNodeSet size = 0)
        and:[ (singleType occurenceIndicator notNil) ])
            ifTrue:[ ^ XQuerySequence withBoolean:true. ].

     "sequence with one item"
    (self currentNodeSet size = 1) ifTrue:[
        atomicType := singleType atomicType qName content.
        (self currentNodeSet first isSubtypeOf: atomicType) ifTrue:[
            ^ XQuerySequence withBoolean:true.
        ].
    ].

    ^ XQuerySequence withBoolean:false.

    "Created: / 05-07-2009 / 16:39:26 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 15-10-2009 / 12:42:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstStatementTriggerExpr:anObject
  |createCmd|

    createCmd := self visit:anObject triggerNameAndTargetExpr.
    self announceTracepointInterrupt.
    createCmd type:'statement'.
      self halt.
    pendingUpdateList := pendingUpdateList mergeWith:createCmd.
    ^ (XQuerySequence new)

    "Created: / 10-04-2012 / 20:28:33 / Adam Senk <senkadam@gmail.com>"
!

visitAstStringLiteral:anObject 
    "dispatched back from the visited astStringLiteral-object (visitor pattern)"
    
    self announceTracepointInterrupt.
    ^ XQuerySequence 
        withAtomicValue:((anObject content) copyFrom:2 to:(anObject content) size - 1)
        asType: 'xs:string'.

    "Created: / 06-07-2006 / 19:12:14 / ked"
    "Modified: / 13-10-2006 / 16:34:02 / ked"
    "Modified: / 21-03-2007 / 15:46:13 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-10-2009 / 21:06:40 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstTextTest:anObject 
    "dispatched back from the visited astNameTest-object (visitor pattern)"
    
    ^ self currentNodeSet:(self currentNodeSet 
                select:[:item | (item type isSubtypeOf: (TypeFactory getType: 'node')) and:[ item item isTextNode ] ]).

    "Created: / 12-10-2006 / 21:58:21 / ked"
    "Modified: / 02-12-2006 / 12:20:41 / ked"
    "Modified: / 05-12-2007 / 21:04:05 / janfrog"
    "Modified: / 09-05-2009 / 12:20:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstTransformCopyClause:anObject 
    |name value valueCopy|
    name := self visit:anObject varName.
    value := self visit:anObject exprSingle.
    self announceTracepointInterrupt.
    self assert:value containsSingleNode
        message:'Only singleton sequences with node can be copied (now)'.
    valueCopy := XQuerySequence with:(value first deepCopy).
    self bindVar:name to:valueCopy.
    anObject transformCopyClause 
        ifNotNil:[ self visit:anObject transformCopyClause ].

    "Modified: / 05-12-2007 / 14:28:25 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-02-2012 / 19:19:33 / Adam Senk <senkadam@gmail.com>"
!

visitAstTransformExpr:anObject 
    |pul|

    self visit:anObject transformCopyClause.
    self announceTracepointInterrupt.
    pul := pendingUpdateList.
    pendingUpdateList := EmptyCommand new.
    self visit:anObject modifyExpr.
    pendingUpdateList execute.
    pendingUpdateList := pul.
    ^ XQuerySequence withAll:(self visit:anObject returnExpr).

    "Modified: / 05-12-2007 / 14:05:02 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitAstTriggerBodyExpr:anObject
  |body createCmd|

    body := self visit:anObject triggerBodyString.
    self announceTracepointInterrupt.
    ^createCmd := (CreateCommand new)
                  body:body.

    "Created: / 10-04-2012 / 20:00:07 / Adam Senk <senkadam@gmail.com>"
!

visitAstTriggerNameAndTargetExpr:anObject
  |name targetExpr createCmd|

    createCmd := self visit:anObject beforeAfterExpr.
    name := self visit:anObject name.
    targetExpr := self visit:anObject targetExpr.
    self announceTracepointInterrupt.
    createCmd targetSequence:targetExpr;
              name: name.
    ^createCmd.

    "Created: / 10-04-2012 / 20:21:11 / Adam Senk <senkadam@gmail.com>"
!

visitAstUnaryExpr:anObject 
    "dispatched back from the visited astUnaryExpr-object (visitor pattern)"
    
    |valueSeq funcName |

    valueSeq := self visit:(anObject unaryExpr).
    self announceTracepointInterrupt.
    (valueSeq size = 0) ifTrue:[
        ^ XQuerySequence new:0
    ].
    (valueSeq size = 1) ifFalse: [ self raiseError: '[err:XPTY0004]'.].

     "evaluate operation"
    (anObject operand == #plus) 
                ifTrue:[ funcName := 'op:numeric-add' ]
                ifFalse:[ funcName := 'op:numeric-substract' ].

    ^ self funcTable 
        evaluate:funcName
        inContext:context
        withParameters: (XQuerySequence with: (AtomicItem withValue: 0 asType: 'xs:integer') 
                                        with: valueSeq first)
        forInterpreter:self.

"/    unaryOperations
"/        at:#plus put:[:val | val ];
"/        at:#minus put:[:val | 0 - val ].
"/    ^ XQuerySequence withNumber:((unaryOperations at:anObject operand) 
"/                value:valueSeq first value)

    "Created: / 06-07-2006 / 19:12:14 / ked"
    "Modified: / 08-10-2006 / 13:26:15 / ked"
    "Modified: / 21-03-2007 / 15:40:22 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 15:05:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstUnionExpr:anObject 
    "dispatched back from the visited astUnionExpr-object (visitor pattern)"
    
    | intersectSequence unionSequence |

    intersectSequence := self visit:(anObject intersectExceptExpr).
    unionSequence := self visit:(anObject unionExpr).

    ^ intersectSequence 
        addAll: (unionSequence);
        yourself.

    "Created: / 06-07-2006 / 19:12:14 / ked"
    "Modified: / 01-12-2006 / 16:15:05 / ked"
    "Modified: / 18-09-2008 / 17:47:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-06-2009 / 23:29:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstVarDecl:varDecl 
    (varDecl expression = varDecl class externalDeclarationExpression) ifTrue: [
        "nothing to do... variable should be declared from external environment"
    ]
    ifFalse: [
        "TODO: set variable with expression"
    ]

    "Created: / 18-04-2009 / 12:05:14 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstVarRef:anObject 
    "dispatched back from the visited astVarRef-object (visitor pattern)"
    
    |qName value|

    qName := (self visit:anObject varName) first.
    value := self valueOfVar:qName inContext:context.
    self announceTracepointInterrupt.
    ^ (value isKindOf:XQuerySequence) 
        ifTrue:[ value ]
        ifFalse:[ XQuerySequence with:value ]

    "Created: / 06-07-2006 / 19:12:14 / ked"
    "Modified: / 08-10-2006 / 13:26:44 / ked"
    "Modified: / 28-03-2007 / 17:04:40 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:59:00 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstWhereClause:anObject 
    "dispatched back from the visited astWhereClause-object (visitor pattern)"

    ^self visit:(anObject exprSingle).

    "Created: / 06-07-2006 / 19:12:14 / ked"
    "Modified: / 08-10-2006 / 13:27:03 / ked"
    "Modified: / 28-03-2007 / 21:29:32 / janfrog"
!

visitAstWildcard:anObject 
    "dispatched back from the visited astWildcard-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ anObject ncName ? '*'

    "Created: / 06-07-2006 / 19:12:14 / ked"
    "Modified: / 21-03-2007 / 20:37:22 / janfrog"
!

visitAstZeroOrMultipleOccurrenceIndicator:anObject 
    ^XQuerySequence withBoolean:(self currentNodeSet size >= 0).

    "Modified: / 10-05-2009 / 15:34:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAstZeroOrOneOccurrenceIndicator:anObject 
    ^XQuerySequence 
        withBoolean:(self currentNodeSet size = 0 or:[self currentNodeSet size = 1]).

    "Modified: / 10-05-2009 / 16:59:07 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitNilWith: ignored

    ^nil

    "Created: / 28-03-2007 / 17:41:58 / janfrog"
!

visitObject:anObject 
    "dispatched back from the visited objects (visitor pattern)"

    "general fallBack - please change as required"

    self error:'not yet implemented'

    "Modified: / 06-07-2006 / 19:12:14 / ked"
    "Modified: / 21-11-2007 / 12:19:57 / janfrog"
!

visitXPathAnyKindTest:anObject
"/    ^ self currentNodeSet.

    ^ self currentNodeSet:(self currentNodeSet 
                select:[:item | item isNode ])

    "Created: / 17-11-2007 / 15:31:51 / janfrog"
    "Modified: / 05-12-2007 / 10:37:08 / janfrog"
    "Modified: / 05-10-2009 / 19:32:31 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitXPathAttributeTest:anObject 
    "dispatched back from the visited xPathAttributeTest-object (visitor pattern)"

    "TODO: needs revision - written without proper knowledge of the xquery exectuion process"
    ^ self currentNodeSet:(self currentNodeSet 
                select:[:item | item xpathIsAttribute ]).

    "Created: / 17-11-2007 / 15:31:51 / janfrog"
    "Modified: / 03-05-2009 / 15:12:28 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitXPathAxisAncestor:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathAncestor]

    "Modified: / 17-11-2007 / 19:49:19 / janfrog"
!

visitXPathAxisAncestorOrSelf:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathAncestorOrSelf]

    "Modified: / 17-11-2007 / 19:49:30 / janfrog"
!

visitXPathAxisAttribute:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathAttribute]

    "Modified: / 17-11-2007 / 19:50:01 / janfrog"
!

visitXPathAxisChild:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathChild]

    "Modified: / 17-11-2007 / 19:50:10 / janfrog"
!

visitXPathAxisDescendant:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathDescendant]

    "Modified: / 17-11-2007 / 19:50:20 / janfrog"
!

visitXPathAxisDescendantOrSelf:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathDescendantOrSelf]

    "Modified: / 17-11-2007 / 19:50:32 / janfrog"
!

visitXPathAxisFollowing:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathFollowing]

    "Modified: / 17-11-2007 / 19:50:44 / janfrog"
!

visitXPathAxisFollowingSibling:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathFollowingSibling]

    "Modified: / 17-11-2007 / 19:52:09 / janfrog"
!

visitXPathAxisParent:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathParent]

    "Modified: / 17-11-2007 / 19:52:17 / janfrog"
!

visitXPathAxisPreceding:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathPreceding]

    "Modified: / 17-11-2007 / 19:52:44 / janfrog"
!

visitXPathAxisPrecedingSibling:anObject 

    ^self reduceCurrentNodeSetUsing:
            [:node|node xpathPrecedingSibling]

    "Modified: / 17-11-2007 / 19:52:40 / janfrog"
!

visitXPathAxisSelf:anObject 
    ^ self currentNodeSet

    "Modified: / 05-12-2007 / 10:37:09 / janfrog"
!

visitXPathCommentTest:anObject 
    "dispatched back from the visited xPathCommentTest-object (visitor pattern)"

    "TODO: needs revision - written withou proper knowledge of the xquery exectuion process"
    ^ self currentNodeSet:(self currentNodeSet 
                select:[:item | item containsNode and:[ item item xpathIsComment ] ]).

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
    "Modified: / 13-04-2009 / 11:37:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitXPathDocumentTest:anObject 
    "dispatched back from the visited xPathDocumentTest-object (visitor pattern)"

    "TODO: needs revision - written withou proper knowledge of the xquery exectuion process"
    ^ self currentNodeSet:(self currentNodeSet 
                select:[:item | item containsNode and:[ item item xpathIsDocument ] ]).

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
    "Modified: / 13-04-2009 / 11:37:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitXPathElementTest:anObject 
    "dispatched back from the visited xPathElementTest-object (visitor pattern)"

    "TODO: needs revision - written withou proper knowledge of the xquery exectuion process"
    self currentNodeSet:(self currentNodeSet 
                select:[:item | item xpathIsElement ]).
    
    anObject elementName 
        ifNil:[ ^ self currentNodeSet ]
        ifNotNil:[ ^ self visit:(anObject elementName). ].

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
    "Modified: / 03-05-2009 / 13:56:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitXPathExpression:xpathExpression 
    ^ self 
        withCurrentNodeSetDo:[
            xpathExpression do:[:xpathLocationStepOrFilter | 
                self currentNodeSet:(self visit:xpathLocationStepOrFilter).
                self announceTracepointInterrupt.
            ].
            self currentNodeSet
        ]

    "Created: / 17-11-2007 / 15:12:54 / janfrog"
    "Modified: / 05-12-2007 / 10:37:08 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitXPathLocationStep:xpathLocationStep 
    self currentNodeSet:(self visit:xpathLocationStep axis).
    self currentNodeSet:(self visit:xpathLocationStep nodeTest).
    xpathLocationStep predicates do:[:xpathPredicate | 
        self currentNodeSet:(self visit:xpathPredicate).

    ].
    ^ self currentNodeSet

    "Created: / 17-11-2007 / 15:13:07 / janfrog"
    "Modified: / 05-12-2007 / 10:37:47 / janfrog"
    "Modified: / 24-09-2008 / 07:57:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

visitXPathNameTest:anObject 
    |ns localName|

    ns := anObject prefix = '*' ifTrue:[
                '*'
            ] ifFalse:[
                anObject prefix isNil ifTrue:[
                    ''
                ] ifFalse:[
                    prefixToNamespaceURIMapping at:anObject prefix
                        ifAbsent:[ self errorNamespacePrefixNotDeclared:anObject prefix ]
                ]
            ].
    localName := anObject localName.
    ^ self currentNodeSet:(self currentNodeSet 
                select:[:nodeSetItem | 
                         nodeSetItem isElementOrAttributeNode 
                         and:[
                            (ns = '*' or: [ nodeSetItem xpathNamespace = ns ]) 
                            and:
                            [ localName = '*' or:[ nodeSetItem xpathLocalName = localName ] ]
                          ]
                ]).

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
    "Modified: / 05-12-2007 / 15:55:13 / janfrog"
    "Modified: / 04-10-2009 / 16:56:19 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitXPathPredicate:xpathPredicate 
    ^ self 
        withFocusDo:[
            self currentNodeSet:(self currentNodeSet 
                        select:[:nodeSetItem | 
                            |exprSeq|

                            currentFocus
                                contextItem:nodeSetItem;
                                contextPositionAdvance.
                            self currentNodeSet:(XQuerySequence with:currentFocus contextItem).
                            exprSeq := self visit:xpathPredicate expr.
                            self announceTracepointInterrupt.
                            exprSeq containsSingleNumber ifTrue:[
                                currentFocus contextPosition = exprSeq asNumber
                            ] ifFalse:[
                                exprSeq effectiveBooleanValue
                            ]
                        ])
        ]

    "Created: / 17-11-2007 / 15:23:51 / janfrog"
    "Modified: / 05-12-2007 / 10:37:44 / janfrog"
    "Modified: / 13-12-2008 / 10:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 18:01:27 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 09:59:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitXPathProcessingInstructionTest:anObject 
    "dispatched back from the visited xPathProcessingInstructionTest-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
!

visitXPathTextTest:anObject 
    ^ self currentNodeSet:(self currentNodeSet 
                select:[:item | item xpathIsText ])

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
    "Modified: / 05-12-2007 / 10:37:39 / janfrog"
    "Modified: / 03-05-2009 / 11:04:05 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreter methodsFor:'workspace support'!

inspectIt: anObject

    anObject asDocumentFragment inspect

    "Created: / 04-05-2010 / 18:25:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printIt: anObject

    ^anObject asDocumentFragment asColorXMLString

    "Created: / 04-05-2010 / 18:25:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XQueryInterpreter class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
