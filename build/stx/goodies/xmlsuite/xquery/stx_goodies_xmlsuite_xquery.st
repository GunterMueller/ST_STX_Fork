'From Smalltalk/X, Version:6.2.1 on 01-05-2012 at 08:55:02 PM'                  !

"{ Package: 'stx:goodies/xmlsuite/xquery' }"

LibraryDefinition subclass:#stx_goodies_xmlsuite_xquery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_xmlsuite_xquery class methodsFor:'accessing - tests'!

testSuite


    | suite tests |
    suite := super testSuite.
    "Reject all XQTS tests - we don't need them to be run automatically"
   tests := suite tests.
   tests copy do:
      [:each|
      (each class nameWithoutPrefix startsWith:'XQTS') ifTrue:
          [tests remove: each
          ]].
   ^suite

! !

!stx_goodies_xmlsuite_xquery class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

preRequisites
    "list all required packages.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies and looking for
     global variable accesses. (the browser has a menu function for that)
     Howevery, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPrerequisites method."

    ^ #(
        #'cvut:fel/libutilui'    "AboutBoxUI - referenced by XQuery::WorkspaceApplication>>openAboutThisApplication "
        #'cvut:fel/perseus/core'    "Perseus::DebuggerService - superclass of XQuery::DebuggerService "
        #'cvut:fel/perseus/core_ui'    "Perseus::Workspace - superclass of XQuery::Workspace "
        #'cvut:fel/perseus/smallscript'    "SmallScript::Interpreter - referenced by XQuery::SmallScriptLibrary>>initialize "
        #'stx:goodies/smaCC'    "SmaCC::SmaCCScanner - superclass of XQuery::XQueryScanner "
        #'stx:goodies/sunit'    "TestAsserter - superclass of XQuery::XQueryInterpreterTests "
        #'stx:goodies/xmlsuite/core'    "XMLv2::XMLReader - superclass of XQuery::XDMXMLReader "
        #'stx:libbasic'    "Magnitude - superclass of extended LimitedPrecisionReal "
        #'stx:libbasic2'    "FileURI - referenced by XQuery::FnLibrary>>putInContext:withParameters:forInterpreter: "
        #'stx:libcomp'    "Parser - referenced by XQuery::WorkspaceApplication>>askForFilterBlock:template:rememberIn: "
        #'stx:libjavascript'    "JavaScriptCompiler - referenced by XQuery::WorkspaceApplication>>compilerClassForSyntaxName: "
        #'stx:libtool'    "MultiViewToolApplication - superclass of XQuery::WorkspaceApplication "
        #'stx:libui'    "DataSetColumnSpec - referenced by XQuery::NodeItem>>inspector2TabXDMProperties "
        #'stx:libview'    "DisplaySurface - superclass of XQuery::Workspace "
        #'stx:libview2'    "ApplicationModel - superclass of XQuery::WorkspaceUI "
        #'stx:libwidg'    "TextView - superclass of XQuery::Workspace "
        #'stx:libwidg2'    "HierarchicalItem - superclass of XQuery::VariableProxy "
    )
! !

!stx_goodies_xmlsuite_xquery class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'XQuery::AnyAtomicTypeToAnyAtomicTypeCast'
        #'XQuery::AstNode'
        #'XQuery::AstNodeVisitor'
        #'XQuery::AtomicItem'
        #'XQuery::CanonicalLexicalFormConverter'
        #'XQuery::CastingRules'
        #'XQuery::ContextProxy'
        #'XQuery::CrossTypeHierarchyCasting'
        #'XQuery::Debugger'
        #'XQuery::DebuggerService'
        #'XQuery::DerivedAtomicType'
        #'XQuery::DerivedToParentCasting'
        #'XQuery::DocumentNotFoundError'
        #'XQuery::Function'
        #'XQuery::FunctionLibrary'
        #'XQuery::FunctionParam'
        #'XQuery::InvalidNodeIdError'
        #'XQuery::LexicalFormChecker'
        #'XQuery::NodeItem'
        #'XQuery::NodeKind'
        #'XQuery::ParentToDerivedCasting'
        #'XQuery::PrimitiveToPrimitiveCasting'
        #'XQuery::QName'
        #'XQuery::TypeFactory'
        #'XQuery::TypeFactoryQuery'
        #'XQuery::TypeHierarchy'
        #'XQuery::TypeHierarchyNode'
        #'XQuery::TypeItem'
        #'XQuery::UpdateCommand'
        #'XQuery::VariableProxy'
        #'XQuery::WithinBranchCasting'
        #'XQuery::Workspace'
        #'XQuery::WorkspaceApplication'
        #'XQuery::WorkspaceUI'
        #'XQuery::XDMAccessors'
        #'XQuery::XDMAdaptor'
        #'XQuery::XDMAdaptorFactory'
        #'XQuery::XDMAdaptorProvider'
        #'XQuery::XDMXMLReader'
        #'XQuery::XPathExpression'
        #'XQuery::XPathExpressionOptimizer'
        (#'XQuery::XPathExpressionOptimizerTests' autoload)
        #'XQuery::XPathLocationStep'
        (#'XQuery::XQTSAbbrAxesTests' autoload)
        (#'XQuery::XQTSBooleanEqualTests' autoload)
        (#'XQuery::XQTSComputeConAttrTests' autoload)
        (#'XQuery::XQTSComputeConElemTests' autoload)
        (#'XQuery::XQTSConDocNodeTests' autoload)
        (#'XQuery::XQTSConTextTests' autoload)
        (#'XQuery::XQTSCondExprTests' autoload)
        (#'XQuery::XQTSDirectConElemAttrTests' autoload)
        (#'XQuery::XQTSDirectConElemContentTests' autoload)
        (#'XQuery::XQTSDirectConElemTests' autoload)
        (#'XQuery::XQTSForExprPositionalVarTests' autoload)
        (#'XQuery::XQTSForExprWithTests' autoload)
        (#'XQuery::XQTSForExprWithoutTests' autoload)
        (#'XQuery::XQTSGenCompEqTests' autoload)
        (#'XQuery::XQTSGenCompGTEQTests' autoload)
        (#'XQuery::XQTSGenCompGTTests' autoload)
        (#'XQuery::XQTSGenCompLTEQTests' autoload)
        (#'XQuery::XQTSGenCompLTTests' autoload)
        (#'XQuery::XQTSGenCompNETests' autoload)
        (#'XQuery::XQTSLetExprWithTests' autoload)
        (#'XQuery::XQTSLetExprWithoutTests' autoload)
        (#'XQuery::XQTSLogicExprTests' autoload)
        (#'XQuery::XQTSNumericAddTests' autoload)
        (#'XQuery::XQTSNumericDivideTests' autoload)
        (#'XQuery::XQTSNumericIntegerDivideTests' autoload)
        (#'XQuery::XQTSNumericModTests' autoload)
        (#'XQuery::XQTSNumericSubtractTests' autoload)
        (#'XQuery::XQTSNumericUnaryMinusTests' autoload)
        (#'XQuery::XQTSNumericUnaryPlusTests' autoload)
        (#'XQuery::XQTSOrderbyExprWithTests' autoload)
        (#'XQuery::XQTSOrderbyExprWithoutTests' autoload)
        (#'XQuery::XQTSParenExprTests' autoload)
        (#'XQuery::XQTSReturnExprTests' autoload)
        (#'XQuery::XQTSSeqExprCastNoDateSupportedTests' autoload)
        (#'XQuery::XQTSSeqExprCastSupportedTests' autoload)
        (#'XQuery::XQTSSeqExprCastTests' autoload)
        (#'XQuery::XQTSSeqExprCastToDerivedParentsTests' autoload)
        (#'XQuery::XQTSSeqExprCastWithinBranchTests' autoload)
        (#'XQuery::XQTSSeqExprCastableTests' autoload)
        (#'XQuery::XQTSSeqExprInstanceOfTests' autoload)
        (#'XQuery::XQTSSeqUnionTests' autoload)
        (#'XQuery::XQTSSequenceTypeSyntaxTests' autoload)
        (#'XQuery::XQTSStaticContextTests' autoload)
        (#'XQuery::XQTSTestCase' autoload)
        (#'XQuery::XQTSTestResource' autoload)
        (#'XQuery::XQTSUnabbrAxesTests' autoload)
        (#'XQuery::XQTSWhereExprTests' autoload)
        (#'XQuery::XQTScommaOpTests' autoload)
        #'XQuery::XQueryCompiler'
        #'XQuery::XQueryConstructedItem'
        #'XQuery::XQueryContext'
        (#'XQuery::XQueryDocumentProviderTestResource' autoload)
        #'XQuery::XQueryExecutor'
        #'XQuery::XQueryFocus'
        #'XQuery::XQueryFuncTable'
        #'XQuery::XQueryInterpreter'
        #'XQuery::XQueryInterpreterError'
        (#'XQuery::XQueryInterpreterTests' autoload)
        #'XQuery::XQueryNumberFormatter'
        #'XQuery::XQueryOrderByItem'
        #'XQuery::XQueryOrderSpecItem'
        #'XQuery::XQueryParser'
        #'XQuery::XQueryParserError'
        #'XQuery::XQueryParserState'
        #'XQuery::XQueryQuery'
        #'XQuery::XQueryResult'
        #'XQuery::XQueryResultItem'
        #'XQuery::XQueryScanner'
        #'XQuery::XQueryScannerState'
        #'XQuery::XQuerySequence'
        #'XQuery::XQuerySequenceError'
        #'XQuery::XQueryTupleItem'
        (#'XQuery::XQueryTypeTests' autoload)
        (#'XQuery::XQueryUpdateFacilityTests' autoload)
        #'stx_goodies_xmlsuite_xquery'
        #'XQuery::AccessedNodeKind'
        #'XQuery::AnyAtomicTypeToDecimalCast'
        #'XQuery::AnyAtomicTypeToDoubleCast'
        #'XQuery::AnyAtomicTypeToFloatCast'
        #'XQuery::AnyAtomicTypeToStringCast'
        #'XQuery::AnyAtomicTypeToUntypedAtomicCast'
        #'XQuery::AstAbbrevForwardStep'
        #'XQuery::AstAdditiveExpr'
        #'XQuery::AstAfterTriggerExpr'
        #'XQuery::AstAndExpr'
        #'XQuery::AstAnyKindTest'
        #'XQuery::AstAtomicType'
        #'XQuery::AstAttribNameOrWildcard'
        #'XQuery::AstAttributeTest'
        #'XQuery::AstAxisStep'
        #'XQuery::AstBaseUriDecl'
        #'XQuery::AstBeforeTriggerExpr'
        #'XQuery::AstBooleanLiteral'
        #'XQuery::AstCastExpr'
        #'XQuery::AstCastableExpr'
        #'XQuery::AstCompAttrConstructor'
        #'XQuery::AstCompDocConstructor'
        #'XQuery::AstCompElemConstructor'
        #'XQuery::AstCompTextConstructor'
        #'XQuery::AstComparisonExpr'
        #'XQuery::AstConnectTriggerExpr'
        #'XQuery::AstContextItemExpr'
        #'XQuery::AstDecimalLiteral'
        #'XQuery::AstDefaultNamespaceDecl'
        #'XQuery::AstDeleteExpr'
        #'XQuery::AstDeleteTriggerExpr'
        #'XQuery::AstDirAttributeList'
        #'XQuery::AstDirAttributeListElem'
        #'XQuery::AstDirElemConstructor'
        #'XQuery::AstDirElemContent'
        #'XQuery::AstDisconnectTriggerExpr'
        #'XQuery::AstDocumentTest'
        #'XQuery::AstDoubleLiteral'
        #'XQuery::AstDropTriggerExpr'
        #'XQuery::AstDummyNode'
        #'XQuery::AstElementContentChar'
        #'XQuery::AstElementNameOrWildcard'
        #'XQuery::AstElementTest'
        #'XQuery::AstEnclosedExpr'
        #'XQuery::AstExpr'
        #'XQuery::AstFLWORExpr'
        #'XQuery::AstFLWORExpr_ForLet'
        #'XQuery::AstFilterExpr'
        #'XQuery::AstForClause'
        #'XQuery::AstForwardStep'
        #'XQuery::AstFunctionCall'
        #'XQuery::AstFunctionDecl'
        #'XQuery::AstFunctionParametersList'
        #'XQuery::AstIfExpr'
        #'XQuery::AstInsertExpr'
        #'XQuery::AstInsertTriggerExpr'
        #'XQuery::AstInstanceOfExpr'
        #'XQuery::AstIntegerLiteral'
        #'XQuery::AstIntersectExceptExpr'
        #'XQuery::AstItemType'
        #'XQuery::AstItemTypeItem'
        #'XQuery::AstLetClause'
        #'XQuery::AstMainModule'
        #'XQuery::AstModuleImport'
        #'XQuery::AstMultiplicativeExpr'
        #'XQuery::AstNCName'
        #'XQuery::AstNameTest'
        #'XQuery::AstNamespaceDecl'
        #'XQuery::AstNodeTriggerExpr'
        #'XQuery::AstOneOccurrenceIndicator'
        #'XQuery::AstOneOrMultipleOccurrenceIndicator'
        #'XQuery::AstOrExpr'
        #'XQuery::AstOrderByClause'
        #'XQuery::AstOrderModifier'
        #'XQuery::AstOrderSpec'
        #'XQuery::AstOrderSpecList'
        #'XQuery::AstParam'
        #'XQuery::AstParenthesizedExpr'
        #'XQuery::AstPathExpr'
        #'XQuery::AstPredefinedEntityRef'
        #'XQuery::AstPredicate'
        #'XQuery::AstPredicateList'
        #'XQuery::AstProlog'
        #'XQuery::AstQName'
        #'XQuery::AstQuantifiedExpr'
        #'XQuery::AstQuantifiedExpr_Impl'
        #'XQuery::AstRangeExpr'
        #'XQuery::AstRelativePathExpr'
        #'XQuery::AstRenameExpr'
        #'XQuery::AstRenameTriggerExpr'
        #'XQuery::AstReplaceExpr'
        #'XQuery::AstReplaceTriggerExpr'
        #'XQuery::AstReplaceValueOfExpr'
        #'XQuery::AstReverseStep'
        #'XQuery::AstSequenceType'
        #'XQuery::AstSingleType'
        #'XQuery::AstStatementTriggerExpr'
        #'XQuery::AstStringLiteral'
        #'XQuery::AstTextTest'
        #'XQuery::AstTransformCopyClause'
        #'XQuery::AstTransformExpr'
        #'XQuery::AstTriggerBodyExpr'
        #'XQuery::AstTriggerNameAndTargetExpr'
        #'XQuery::AstUnaryExpr'
        #'XQuery::AstUnionExpr'
        #'XQuery::AstVarDecl'
        #'XQuery::AstVarRef'
        #'XQuery::AstWhereClause'
        #'XQuery::AstWildcard'
        #'XQuery::AstZeroOrMultipleOccurrenceIndicator'
        #'XQuery::AstZeroOrOneOccurrenceIndicator'
        #'XQuery::AtomicItemError'
        #'XQuery::AttributeAccessor'
        #'XQuery::BooleanToDecimalCast'
        #'XQuery::BooleanToDoubleCast'
        #'XQuery::BooleanToFloatCast'
        #'XQuery::BooleanToIntegerCast'
        #'XQuery::CastException'
        #'XQuery::CompositeCommand'
        #'XQuery::ConstructedNodeKind'
        #'XQuery::ConstructedNodeXDMAdaptor'
        #'XQuery::ContentAccessors'
        #'XQuery::CreateCommand'
        #'XQuery::DOM3XDMAdaptor'
        #'XQuery::DateToDateTimeCast'
        #'XQuery::DecimalFormatter'
        #'XQuery::DecimalToBooleanCast'
        #'XQuery::DecimalToDoubleCast'
        #'XQuery::DecimalToFloatCast'
        #'XQuery::DecimalToIntegerCast'
        #'XQuery::DefaultXDMAdaptorProvider'
        #'XQuery::DeleteCommand'
        #'XQuery::DocumentAccessor'
        #'XQuery::DoubleToBooleanCast'
        #'XQuery::DoubleToDecimalCast'
        #'XQuery::DoubleToFloatCast'
        #'XQuery::DoubleToIntegerCast'
        #'XQuery::ElementAccessor'
        #'XQuery::EmptyCommand'
        #'XQuery::ExternalFunction'
        #'XQuery::FloatFormatter'
        #'XQuery::FloatToBooleanCast'
        #'XQuery::FloatToDecimalCast'
        #'XQuery::FloatToDoubleCast'
        #'XQuery::FloatToIntegerCast'
        #'XQuery::FunctionError'
        #'XQuery::HybridNodeKind'
        #'XQuery::InsertCommand'
        #'XQuery::IntegerFormatter'
        #'XQuery::IntegerToDecimalCast'
        #'XQuery::IntegerToDoubleCast'
        #'XQuery::IntegerToFloatCast'
        #'XQuery::NamespaceAccessor'
        #'XQuery::ProcessingInstructionAccessor'
        #'XQuery::RenameCommand'
        #'XQuery::ReplaceCommand'
        #'XQuery::ReplaceElementContentCommand'
        #'XQuery::ReplaceValueOfCommand'
        #'XQuery::SmallScriptFunctionLibrary'
        #'XQuery::SmallScriptLibrary'
        #'XQuery::SmalltalkFunctionLibrary'
        #'XQuery::StringToAnyAtomicTypeCast'
        #'XQuery::TextAccessor'
        #'XQuery::TriggerCommand'
        #'XQuery::TypeError'
        #'XQuery::TypeNode'
        #'XQuery::TypeXSAnyAtomicType'
        #'XQuery::UntypedAtomicToAnyAtomicTypeCast'
        #'XQuery::UserDefinedFunction'
        #'XQuery::XPathAxis'
        #'XQuery::XPathNodeTest'
        #'XQuery::XPathPredicate'
        (#'XQuery::XQTSNumericMultiplyTests' autoload)
        #'XQuery::XQueryResultXMLReader'
        #'XQuery::AstInsertAfterExpr'
        #'XQuery::AstInsertAsFirstIntoExpr'
        #'XQuery::AstInsertAsLastIntoExpr'
        #'XQuery::AstInsertBeforeExpr'
        #'XQuery::AstInsertIntoExpr'
        #'XQuery::ConnectCommand'
        #'XQuery::DisConnectCommand'
        #'XQuery::DmLibrary'
        #'XQuery::DropCommand'
        #'XQuery::FnLibrary'
        #'XQuery::InsertAfterCommand'
        #'XQuery::InsertAsFirstIntoCommand'
        #'XQuery::InsertAsLastIntoCommand'
        #'XQuery::InsertBeforeCommand'
        #'XQuery::InsertIntoCommand'
        #'XQuery::OpLibrary'
        #'XQuery::StringToAnyURICast'
        #'XQuery::StringToBooleanCast'
        #'XQuery::StringToDateCast'
        #'XQuery::StringToDecimalCast'
        #'XQuery::StringToDoubleCast'
        #'XQuery::StringToFloatCast'
        #'XQuery::StringToIntegerCast'
        #'XQuery::StringToQNameCast'
        #'XQuery::StringToTimeCast'
        #'XQuery::StringToUntypedAtomicCast'
        #'XQuery::TypeAttribute'
        #'XQuery::TypeComment'
        #'XQuery::TypeDocument'
        #'XQuery::TypeElement'
        #'XQuery::TypeProcessingInstruction'
        #'XQuery::TypeText'
        #'XQuery::TypeXSAnyURI'
        #'XQuery::TypeXSBoolean'
        #'XQuery::TypeXSDate'
        #'XQuery::TypeXSDateTime'
        #'XQuery::TypeXSDecimal'
        #'XQuery::TypeXSDouble'
        #'XQuery::TypeXSDuration'
        #'XQuery::TypeXSFloat'
        #'XQuery::TypeXSQName'
        #'XQuery::TypeXSString'
        #'XQuery::TypeXSTime'
        #'XQuery::TypeXSUntypedAtomic'
        #'XQuery::UntypedAtomicToAnyURICast'
        #'XQuery::UntypedAtomicToBooleanCast'
        #'XQuery::UntypedAtomicToDecimalCast'
        #'XQuery::UntypedAtomicToDoubleCast'
        #'XQuery::UntypedAtomicToFloatCast'
        #'XQuery::UntypedAtomicToIntegerCast'
        #'XQuery::XPathAxisAncestor'
        #'XQuery::XPathAxisAncestorOrSelf'
        #'XQuery::XPathAxisAttribute'
        #'XQuery::XPathAxisChild'
        #'XQuery::XPathAxisDescendant'
        #'XQuery::XPathAxisDescendantOrSelf'
        #'XQuery::XPathAxisFollowing'
        #'XQuery::XPathAxisFollowingSibling'
        #'XQuery::XPathAxisParent'
        #'XQuery::XPathAxisPreceding'
        #'XQuery::XPathAxisPrecedingSibling'
        #'XQuery::XPathAxisSelf'
        #'XQuery::XPathKindTest'
        #'XQuery::XPathNameTest'
        #'XQuery::XSLibrary'
        #'XQuery::XPathAnyKindTest'
        #'XQuery::XPathAttributeTest'
        #'XQuery::XPathCommentTest'
        #'XQuery::XPathDocumentTest'
        #'XQuery::XPathElementTest'
        #'XQuery::XPathProcessingInstructionTest'
        #'XQuery::XPathTextTest'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
        Boolean xqueryValueType
        Float asString
        Float xqueryValueType
        Integer xqueryValueType
        String xqueryValueType
    )
! !

!stx_goodies_xmlsuite_xquery class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2009\nCopyright eXept Software AG 1998-2009'
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_xmlsuite_xquery class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
    "        

    ^ '$URL$'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'285'"$"
! !

!stx_goodies_xmlsuite_xquery class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
