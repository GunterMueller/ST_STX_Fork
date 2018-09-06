"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser_compiler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_compiler class methodsFor:'accessing - monticello'!

monticelloLastMergedVersionInfo
    "The last merged version is: "

    ^ '
    Name: PetitCompiler-JanVrany.170
    Author: JanVrany
    Time: 24-08-2015, 03:19:51.340 PM
    UUID: c20a744f-3b41-4aaa-bb8a-71ce74a2a952       
    Repository: http://smalltalkhub.com/mc/JanKurs/PetitParser/main
    '

    "Created: / 03-10-2014 / 02:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-08-2015 / 15:23:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitCompiler'

    "Created: / 03-10-2014 / 01:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2014 / 01:27:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloSplicemap
    "Return a splicemap for this package. This is used to forge a 
     'fake' ancestor when generating ancestry information out of 
     Mercurial (or anyt other) history. This should make merging 
     back into Squeak/Pharo a little easier as Monticello can (in theory)
     find a proper ancestor. 

     All this requires monticelloSplicemap being updated each time a code
     is merged from Monticello.

     The format of splicemap is a flat array of pairs 
     (commit id, MCVersionInfo to splice) as literal encoding.
    "

    ^ #(
        #(HGChangesetId 'f6f68d32de73') #(MCVersionInfo name: 'PetitCompiler-JanVrany.170' id: 'c20a744f-3b41-4aaa-bb8a-71ce74a2a952' date: '2015-08-24' time: '15:19:51.340' author: 'JanVrany' message: 'Removed CompiledMethod>>source

Use #sourceCode which is defined in Smalltalk/X for Squeak/Pharo
compatibility. This makes merging easier as merging as this 
version  #source have disastrous effects on running Smalltalk/X
system  - #source is the main source acessing method there. 
')

    )
! !

!stx_goodies_petitparser_compiler class methodsFor:'description'!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:goodies/petitparser'    "PPActionParser - extended"
        #'stx:goodies/petitparser/parsers/smalltalk'    "PPSmalltalkGrammar - extended"
        #'stx:goodies/refactoryBrowser/parser'    "RBLiteralNode - extended"
        #'stx:libbasic'    "Character - extended"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
        #'stx:goodies/petitparser/analyzer'    "PPSentinel - referenced by PPCompiledParser class>>referringParser"
        #'stx:goodies/petitparser/parsers/java'    "PPJavaToken - referenced by PPParser>>javaToken"
        #'stx:libbasic2'    "IdentityBag - referenced by PEGFsa>>checkTransitionsIdentity"
        #'stx:libwidg'    "ScrollableView - referenced by PPCNode>>inspector2TabTree"
        #'stx:libwidg2'    "HierarchicalListView - referenced by PPCNode>>inspector2TabTree"
    )
!

stcOptimizationOptions
    "do not inline the not operation here - it is overwritten"

    ^ super stcOptimizationOptions , ' -inlinenot'

    "Created: / 13-04-2015 / 14:18:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_goodies_petitparser_compiler class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        PEGFsa
        PEGFsaAbstractDeterminizator
        PEGFsaFailure
        PEGFsaInterpret
        PEGFsaInterpretRecord
        PEGFsaMinimizator
        PEGFsaPair
        PEGFsaState
        PEGFsaStateInfo
        PEGFsaTransition
        PPCASTUtilities
        PPCBridge
        PPCClass
        PPCClassBuilder
        PPCCodeBlock
        PPCCodeGen
        PPCCompilationContext
        PPCCompilationError
        PPCCompilationOptions
        PPCCompilationWarning
        PPCCompiler
        PPCContext
        PPCContextMemento
        PPCDistinctScanner
        PPCGuard
        PPCIdGenerator
        PPCMethod
        PPCNode
        PPCNodeVisitor
        PPCPass
        PPCScanner
        PPCScannerError
        PPCScannerResultStrategy
        PPCTokenGuard
        PPCompiledParser
        PPMappedActionParser
        #'stx_goodies_petitparser_compiler'
        FooScanner
        PEGFsaCharacterTransition
        PEGFsaChoiceDeterminizator
        PEGFsaDeterminizator
        PEGFsaEpsilonTransition
        PEGFsaParserState
        PEGFsaPredicateTransition
        PEGFsaSequenceDeterminizator
        PEGFsaUncopiableState
        PPCAbstractLiteralNode
        PPCAbstractPredicateNode
        PPCAnyNode
        PPCCacheFirstFollowPass
        PPCCharacterNode
        PPCDelegateNode
        PPCDistinctResultStrategy
        PPCEndOfFileNode
        PPCFSACodeGen
        PPCInlinedMethod
        PPCListNode
        PPCNilNode
        PPCNoResultStrategy
        PPCPassVisitor
        PPCPluggableNode
        PPCProfilingContext
        PPCScannerCodeGenerator
        PPCTokenizingCodeGen
        PPCUniversalCodeGen
        PPCUniversalResultStrategy
        PPCUnknownNode
        PPTokenizingCompiledParser
        PEGFsaEOFTransition
        PEGFsaGenerator
        PEGFsaParserTransition
        PPCAbstractActionNode
        PPCAndNode
        PPCCharSetPredicateNode
        PPCCheckingVisitor
        PPCChoiceNode
        PPCCodeGenerator
        PPCEndOfInputNode
        PPCFSAVisitor
        PPCForwardNode
        PPCInliningVisitor
        PPCLiteralNode
        PPCMessagePredicateNode
        PPCNegateNode
        PPCNotCharSetPredicateNode
        PPCNotCharacterNode
        PPCNotLiteralNode
        PPCNotMessagePredicateNode
        PPCNotNode
        PPCOptionalNode
        PPCPlusNode
        PPCPredicateNode
        PPCRewritingVisitor
        PPCSentinelNode
        PPCSequenceNode
        PPCStarNode
        PPCTokenCodeGenerator
        PPCTokenConsumeNode
        PPCTokenNode
        PPCTokenWhitespaceNode
        PPCTokenizingParserNode
        PPCTrimmingTokenNode
        PPCActionNode
        PPCCopyVisitor
        PPCDeterministicChoiceNode
        PPCLL1Visitor
        PPCMergingVisitor
        PPCOptimizeChoices
        PPCRecognizerComponentDetector
        PPCRecognizerComponentVisitor
        PPCRecognizingSequenceNode
        PPCSpecializingVisitor
        PPCStarAnyNode
        PPCStarCharSetPredicateNode
        PPCStarMessagePredicateNode
        PPCSymbolActionNode
        PPCTokenChoiceNode
        PPCTokenDetector
        PPCTokenVisitor
        PPCTokenizingCodeGenerator
        PPCTokenizingVisitor
        PPCTrimNode
        PPCTrimmingCharacterTokenNode
        PPCUniversalCodeGenerator
        PPCMappedActionNode
        PPCTokenStarMessagePredicateNode
        PPCTokenStarSeparatorNode
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        Character ppcPrintable
        Object isInlinedMethod
        PPActionParser asCompilerNode
        PPActionParser compileWith:
        PPAndParser asCompilerNode
        PPCharSetPredicate block
        PPCharSetPredicate classification
        PPCharSetPredicate equals:
        PPChoiceParser asCompilerNode
        PPChoiceParser compileWith:
        PPContext asCompiledParserContext
        PPContext comment
        PPContext comment:
        PPContext compiledParser
        PPContext compiledParser:
        PPContext lwRemember
        PPContext lwRestore:
        PPContext peek:
        PPContext whitespace
        PPContext whitespace:
        PPDelegateParser asCompilerNode
        PPDelegateParser compileWith:
        PPEpsilonParser asCompilerNode
        PPEpsilonParser compileWith:
        PPFailure context:
        PPFailure message:
        PPFailure position:
        PPLiteralObjectParser asCompilerNode
        PPLiteralObjectParser compileWith:
        PPLiteralParser id
        PPLiteralSequenceParser asCompilerNode
        PPLiteralSequenceParser compileWith:
        PPNotParser asCompilerNode
        PPNotParser compileWith:
        PPOptionalParser asCompilerNode
        PPOptionalParser compileWith:
        PPParser asCompilerNode
        PPParser asCompilerTree
        PPParser bridge
        PPParser compile
        PPParser firstSetSuchThat:
        PPParser firstSetSuchThat:into:openSet:
        PPParser id
        PPParser isCompiled
        PPParser isContextFree
        PPParser isContextFreePrim
        PPParser isToken
        PPParser isTokenParser
        PPParser optimize
        PPParser optimized
        PPParser trimmingToken
        PPPluggableParser acceptsEpsilon
        PPPluggableParser asCompilerNode
        PPPossessiveRepeatingParser asCompilerNode
        PPPossessiveRepeatingParser compileWith:
        PPPredicateObjectParser asCompilerNode
        PPPredicateObjectParser compileWith:
        PPPredicateObjectParser firstCharSet
        PPPredicateObjectParser firstCharSetCached
        PPSequenceParser asCompilerNode
        PPSequenceParser compileWith:
        PPSequenceParser firstSetSuchThat:into:openSet:
        PPSmalltalkGrammar comment
        PPSmalltalkGrammar whitespace
        PPSmalltalkTokenParser compileWith:
        PPSmalltalkTokenParser parseOnX:
        PPSmalltalkTokenParser whitespace
        PPSmalltalkWhitespaceParser #'='
        PPSmalltalkWhitespaceParser acceptsEpsilon
        PPSmalltalkWhitespaceParser acceptsEpsilonOpenSet:
        PPSmalltalkWhitespaceParser firstCharSet
        PPStream peek:
        PPToken #'='
        PPToken hash
        PPToken isToken
        PPTokenParser asCompilerNode
        PPTokenParser displayName
        PPTokenParser isFirstSetTerminal
        PPTokenParser isTokenParser
        PPTokenParser optimize
        PPTokenParser parser
        PPTokenParser startsWith:
        PPTokenParser whitespace
        PPTrimmingParser asCompilerNode
        UndefinedObject asInteger
        UndefinedObject isAlphaNumeric
        UndefinedObject isDigit
        UndefinedObject isLetter
        UndefinedObject isSeparator
        PPCharSetPredicate #'='
        PPCharSetPredicate hash
        PPContext atWs
        PPContext methodInvoked:
        PPContext setWs
        PPParser javaToken
        PPContext skipSeparators
        PPEndOfInputParser asCompilerNode
        PPParser allNodesDo:seen:
        PPSmalltalkWhitespaceParser hash
        PPCompositeParser asCompilerNode
        PPSequenceParser map:
        Object canHavePPCId
        PPCompositeParser asCompilerNode
        PPSequenceParser map:
        Object isFsaFailure
        PPContext methodFinished:
        PPContext tokenRead:
        PPEndOfFileParser asCompilerNode
        PPSmalltalkGrammar number
        PPSmalltalkWhitespaceParser parseOn:
        RBLiteralValueNode isLiteralNumber
        RBProgramNode isLiteralNumber
        UndefinedObject codePoint
        PPParser compileWithOptions:
    )
! !

!stx_goodies_petitparser_compiler class methodsFor:'description - project information'!

companyName
    "Returns a company string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'eXept Software AG'
!

description
    "Returns a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Returns a copyright string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'Copyright Claus Gittinger 1988-2014\nCopyright eXept Software AG 1998-2014'
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info.
     This method is usually redefined in a concrete application definition"

    ^ 'Smalltalk/X'
! !

!stx_goodies_petitparser_compiler class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

