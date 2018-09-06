"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::Parser subclass:#XQueryParser
	instanceVariableNames:'lastValidState'
	classVariableNames:'Verbose'
	poolDictionaries:''
	category:'XQuery-Core'
!


!XQueryParser class methodsFor:'instance creation'!

new
    Verbose := false.
    ^ self basicNew initialize.

    "Created: / 08-03-2009 / 21:22:46 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 18:15:04 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryParser class methodsFor:'accessing'!

isVerbose

    ^Verbose == true

    "Created: / 12-04-2007 / 11:15:13 / janfrog"
    "Modified: / 21-11-2009 / 18:14:47 / Jan Kurs <kursj1@fel.cvut.cz>"
!

parseQuery: aString
        ^self parse: aString startingAt: self startingStateForQueryBody

    "Created: / 17-03-2006 / 15:00:57 / ked"
    "Modified: / 02-06-2006 / 12:26:34 / ked"
!

verbose: aBoolean

    "
        self verbose: true  

        self verbose: false
    "

    Verbose := aBoolean

    "Created: / 12-04-2007 / 11:15:13 / janfrog"
    "Modified: / 17-11-2007 / 14:37:07 / janfrog"
! !

!XQueryParser class methodsFor:'generated-accessing'!

scannerClass
	^XQuery::XQueryScanner
! !

!XQueryParser class methodsFor:'generated-comments'!

parserDefinitionComment

	"Stripped"

!

symbolComment

	"Stripped"

    "Modified: / 08-03-2009 / 22:33:48 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryParser class methodsFor:'generated-starting states'!

startingStateForMainModule
	^1
!

startingStateForQueryBody
	^1

    "Modified: / 03-12-2006 / 19:46:11 / ked"
! !

!XQueryParser methodsFor:'accessing'!

lastValidState
    lastValidState isNil ifTrue: [
        lastValidState := XQueryParserState new.
    ].
    ^ lastValidState.

    "Modified: / 13-07-2009 / 23:04:18 / Jan Kurs <kursj1@fel.cvut.cz>"
!

syntaxError: messageText line: line source: sourceId

    <context: #return>

    XQueryParserError new
        messageText: messageText;
        line: line;
        source: sourceId;
        raiseSignal

    "Created: / 22-09-2009 / 14:28:28 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryParser methodsFor:'generated-reduction actions'!

reduceActionForAbbrevForwardStep1:nodes 
    self informAboutRuleReduction:'AbbrevForwardStep1'.
    ^(XPathLocationStep new)
        axis:XPathAxisAttribute new;
        nodeTest:(nodes at:2);
        yourself
!

reduceActionForAbbrevForwardStep2:nodes 
    self informAboutRuleReduction:'AbbrevForwardStep2'.
    ^(XPathLocationStep new)
        setDefaultAxisFor:(nodes at:1);
        nodeTest:(nodes at:1);
        yourself
!

reduceActionForAbbrevReverseStep1:nodes 
    ^(XPathLocationStep new)
        axis:XPathAxisParent new;
        nodeTest:XPathAnyKindTest new;
        yourself
!

reduceActionForAdditiveExpr1:nodes 
    self informAboutRuleReduction:'AdditiveExpr1'.
    ^nodes at:1.
!

reduceActionForAdditiveExpr2:nodes 
    self informAboutRuleReduction:'AdditiveExpr2'.
    ^(AstAdditiveExpr new)
        multiplicativeExpr:(nodes at:1);
        operand:#plus;
        additiveExpr:(nodes at:3).
!

reduceActionForAdditiveExpr3:nodes 
    self informAboutRuleReduction:'AdditiveExpr3'.
    ^(AstAdditiveExpr new)
        multiplicativeExpr:(nodes at:1);
        operand:#minus;
        additiveExpr:(nodes at:3).
!

reduceActionForAfterTriggerExpr1:nodes 
    self informAboutRuleReduction:'AfterTriggerExpr'.
    ^(AstAfterTriggerExpr new) eventTriggerExpr:(nodes at:2).
!

reduceActionForAndExpr1:nodes 
    self informAboutRuleReduction:'AndExpr1'.
    ^nodes at:1.
!

reduceActionForAndExpr2:nodes 
    self informAboutRuleReduction:'AndExpr2'.
    ^(AstAndExpr new)
        comparisonExpr:(nodes at:1);
        andExpr:(nodes at:3).
!

reduceActionForAnyKindTest1:nodes 
    self informAboutRuleReduction:'AnyKindTest1'.
    ^XPathAnyKindTest new
!

reduceActionForAtomicType1:nodes 
    self informAboutRuleReduction:'AtomicType1'.
    ^AstAtomicType new qName:(nodes at:1).
!

reduceActionForAttribNameOrWildcard1:nodes 
    self informAboutRuleReduction:'AttributeNameOrWildcard1'.
    ^AstAttribNameOrWildcard new attributeName:(nodes at:1).
!

reduceActionForAttribNameOrWildcard2:nodes 
    self informAboutRuleReduction:'AttributeNameOrWildcard2'.
    ^AstAttribNameOrWildcard new.
!

reduceActionForAttributeName1:nodes 
    self informAboutRuleReduction:'AttributeName1'.
    ^nodes at:1.
!

reduceActionForAttributeTest1:nodes 
    self informAboutRuleReduction:'AttributeTest1'.
    ^XPathAttributeTest new
!

reduceActionForAttributeTest2:nodes 
    self informAboutRuleReduction:'AttributeTest2'.
    ^XPathAttributeTest halt:'Not yet implemented. See grammar'
!

reduceActionForAxisStep1:nodes 
    self informAboutRuleReduction:'AxisStep2'.
    ^(nodes at:1)
        predicates:(nodes at:2);
        yourself
!

reduceActionForAxisStep2:nodes 
    self informAboutRuleReduction:'AxisStep4'.
    ^(nodes at:1)
        predicates:(nodes at:2);
        yourself
!

reduceActionForAxisStep3:nodes 
    self informAboutRuleReduction:'AxisStep3'.
    ^ nodes at:1.

    "Modified: / 17-11-2007 / 13:50:27 / janfrog"
!

reduceActionForAxisStep4:nodes 
    self informAboutRuleReduction:'AxisStep4'.
    ^ (nodes at:1)
        predicates:(nodes at:2);
        yourself

    "Modified: / 17-11-2007 / 13:50:27 / janfrog"
!

reduceActionForBaseUriDecl1:nodes 
    ^AstBaseUriDecl new value:(nodes at:3)
!

reduceActionForBaseUriDecl21:nodes 
    ^AstBaseUriDecl new value:(nodes at:3)
!

reduceActionForBeforeAfterTriggerExpr1:nodes 
    self informAboutRuleReduction:'BeforeAfterTriggerExpr1'.
    ^nodes at:1.
!

reduceActionForBeforeAfterTriggerExpr2:nodes 
    self informAboutRuleReduction:'BeforeAfterTriggerExpr2'.
    ^nodes at:1.
!

reduceActionForBeforeTriggerExpr1:nodes 
    self informAboutRuleReduction:'BeforeTriggerExpr'.
    ^(AstBeforeTriggerExpr new) eventTriggerExpr:(nodes at:2).
!

reduceActionForCastExpr1:nodes 
    self informAboutRuleReduction:'CastExpr1'.
    ^nodes at:1.
!

reduceActionForCastExpr2:nodes 
    self informAboutRuleReduction:'CastExpr2'.
    ^(AstCastExpr new)
        unaryExpr:(nodes at:1);
        singleType:(nodes at:4).
!

reduceActionForCastableExpr1:nodes 
    self informAboutRuleReduction:'CastableExpr1'.
    ^nodes at:1.
!

reduceActionForCastableExpr2:nodes 
    self informAboutRuleReduction:'CastableExpr2'.
    ^(AstCastableExpr new)
        castExpr:(nodes at:1);
        singleType:(nodes at:4).
!

reduceActionForCharRef1:nodes 
    self informAboutRuleReduction:'CharRef1 -' , (nodes at:1).
    ^AstCharRef new content:((nodes at:1) value).
!

reduceActionForCommonContent1:nodes 
    self informAboutRuleReduction:'CommonContent1'.
    ^nodes at:1.
!

reduceActionForCommonContent21:nodes 
    self informAboutRuleReduction:'CommonContent1'.
    ^nodes at:1.
!

reduceActionForCommonContent22:nodes 
    self informAboutRuleReduction:'CommonContent2'.
    ^nodes at:1.
!

reduceActionForCommonContent23:nodes 
    self informAboutRuleReduction:'CommonContent3'.
    ^nodes at:1.
!

reduceActionForCommonContent24:nodes 
    self informAboutRuleReduction:'CommonContent7'.
    ^nodes at:1.
!

reduceActionForCommonContent25:nodes 
    self informAboutRuleReduction:'CommonContent8'.
    ^nodes at:1.
!

reduceActionForCommonContent2:nodes 
    self informAboutRuleReduction:'CommonContent2'.
    ^nodes at:1.
!

reduceActionForCommonContent3:nodes 
    self informAboutRuleReduction:'CommonContent7'.
    ^nodes at:1.
!

reduceActionForCommonContent4:nodes 
    self informAboutRuleReduction:'CommonContent7'.
    ^ nodes at:1.
!

reduceActionForCommonContent5:nodes 
    self informAboutRuleReduction:'CommonContent8'.
    ^ nodes at:1.
!

reduceActionForCommonContent6:nodes 
    Transcript showCR:'[PARSER] CommonContent6'.
    ^ nodes at:1.

    "Created: / 17-11-2006 / 22:20:50 / ked"
!

reduceActionForCommonContent7:nodes 
    Transcript showCR:'[PARSER] CommonContent7'.
    ^ nodes at:1.

    "Created: / 17-11-2006 / 22:20:50 / ked"
!

reduceActionForCommonContent8:nodes 
    Transcript showCR:'[PARSER] CommonContent8'.
    ^ nodes at:1.

    "Created: / 17-11-2006 / 22:20:50 / ked"
!

reduceActionForCompAttrConstructor1:nodes 
    self informAboutRuleReduction:'CompAttrConstructor1'.
    ^AstCompAttrConstructor new qname:(nodes at:2).
!

reduceActionForCompAttrConstructor2:nodes 
    self informAboutRuleReduction:'CompAttrConstructor2'.
    ^(AstCompAttrConstructor new)
        qname:(nodes at:2);
        contentExpr:(nodes at:4).
!

reduceActionForCompAttrConstructor3:nodes 
    self informAboutRuleReduction:'CompAttrConstructor3'.
    ^AstCompAttrConstructor new expr:(nodes at:3).
!

reduceActionForCompAttrConstructor4:nodes 
    self informAboutRuleReduction:'CompAttrConstructor4'.
    ^(AstCompAttrConstructor new)
        expr:(nodes at:3);
        contentExpr:(nodes at:6).
!

reduceActionForCompDocConstructor1:nodes 
    self informAboutRuleReduction:'CompDocConstructor1'.
    ^AstCompDocConstructor new expr:(nodes at:3).
!

reduceActionForCompElemConstructor1:nodes 
    self informAboutRuleReduction:'CompElemConstructor1'.
    ^AstCompElemConstructor new qname:(nodes at:2).
!

reduceActionForCompElemConstructor2:nodes 
    self informAboutRuleReduction:'CompElemConstructor2'.
    ^(AstCompElemConstructor new)
        qname:(nodes at:2);
        contentExpr:(nodes at:4).
!

reduceActionForCompElemConstructor3:nodes 
    self informAboutRuleReduction:'CompElemConstructor3'.
    ^AstCompElemConstructor new expr:(nodes at:3).
!

reduceActionForCompElemConstructor4:nodes 
    self informAboutRuleReduction:'CompElemConstructor4'.
    ^(AstCompElemConstructor new)
        expr:(nodes at:3);
        contentExpr:(nodes at:6).
!

reduceActionForCompTextConstructor1:nodes 
    self informAboutRuleReduction:'CompTextConstructor1'.
    ^AstCompTextConstructor new expr:(nodes at:3).
!

reduceActionForComparisonExpr1:nodes 
    self informAboutRuleReduction:'ComparisonExpr1'.
    ^nodes at:1.
!

reduceActionForComparisonExpr2:nodes 
    self informAboutRuleReduction:'ComparisonExpr2'.
    ^(AstComparisonExpr new)
        rangeExprLeft:(nodes at:1);
        valueComp:(nodes at:2);
        rangeExprRight:(nodes at:3).
!

reduceActionForComparisonExpr3:nodes 
    self informAboutRuleReduction:'ComparisonExpr3'.
    ^(AstComparisonExpr new)
        rangeExprLeft:(nodes at:1);
        generalComp:(nodes at:2);
        rangeExprRight:(nodes at:3).
!

reduceActionForComparisonExpr4:nodes 
    self informAboutRuleReduction:'ComparisonExpr4'.
    ^(AstComparisonExpr new)
        rangeExprLeft:(nodes at:1);
        nodeComp:(nodes at:2);
        rangeExprRight:(nodes at:3).
!

reduceActionForComputedConstructor1:nodes 
    self informAboutRuleReduction:'ComputedConstructor1'.
    ^nodes at:1.
!

reduceActionForComputedConstructor2:nodes 
    self informAboutRuleReduction:'ComputedConstructor2'.
    ^nodes at:1.
!

reduceActionForComputedConstructor3:nodes 
    self informAboutRuleReduction:'ComputedConstructor3'.
    ^nodes at:1.
!

reduceActionForComputedConstructor4:nodes 
    self informAboutRuleReduction:'ComputedConstructor4'.
    ^nodes at:1.
!

reduceActionForConnectTriggerExpr1:nodes 
    self informAboutRuleReduction:'ConnectTriggerExpr'.
    ^(AstConnectTriggerExpr new)
        triggerDefExpr:(nodes at:3);
        targetExpr:(nodes at:5).
!

reduceActionForConstructor1:nodes 
    self informAboutRuleReduction:'Constructor1'.
    ^nodes at:1.
!

reduceActionForConstructor2:nodes 
    self informAboutRuleReduction:'Constructor2'.
    ^nodes at:1.
!

reduceActionForContentExpr1:nodes 
    self informAboutRuleReduction:'ContentExpr'.
    ^nodes at:1.
!

reduceActionForContextItemExpr1:nodes 
    self informAboutRuleReduction:'ContextItemExpr1'.
    ^AstContextItemExpr new.
!

reduceActionForCreateTriggerExpr1:nodes 
    self informAboutRuleReduction:'CreateTriggerExpr'.
    ^nodes at:4.
!

reduceActionForDecimalLiteral1:nodes 
    self 
        informAboutRuleReduction:'DecimalLiteral1 -' , ((nodes at:1) asString).
    ^AstDecimalLiteral new content:((nodes at:1) value).
!

reduceActionForDefaultNamespaceDecl1:nodes 
    ^(AstDefaultNamespaceDecl new)
        uri:(nodes at:5);
        type:#element
!

reduceActionForDefaultNamespaceDecl2:nodes 
    ^(AstDefaultNamespaceDecl new)
        uri:(nodes at:5);
        type:#function
!

reduceActionForDeleteExpr1:nodes 
    self informAboutRuleReduction:'DeleteExpr'.
    ^(AstDeleteExpr new) targetExpr:(nodes at:3)
!

reduceActionForDeleteTriggerExpr1:nodes 
    self informAboutRuleReduction:'DeleteTriggerExpr'.
    ^(AstDeleteTriggerExpr new) triggerBodyExpr:(nodes at:2).
!

reduceActionForDirAttributeList1:nodes 
    self informAboutRuleReduction:'DirAttributeList1'.
    ^nodes at:1
!

reduceActionForDirAttributeList2:nodes 
    self informAboutRuleReduction:'DirAttributeList2'.
    ^ (AstDirAttributeList new)
        qname:(nodes at:1);
        dirAttributeValue:(nodes at:3);
        dirAttributeList:(nodes at:4).
!

reduceActionForDirAttributeListElem1:nodes 
    self informAboutRuleReduction:'DirAttributeListElem1'.
    ^(AstDirAttributeListElem new)
        qName:(nodes at:1);
        dirAttributeValue:(nodes at:3).
!

reduceActionForDirAttributeValue1:nodes 
    self informAboutRuleReduction:'DirAttributeValue1'.
    ^nodes at:1.
!

reduceActionForDirAttributeValue2:nodes 
    self informAboutRuleReduction:'DirAttributeValue2'.
    ^nodes at:1.
!

reduceActionForDirElemConstructor1:nodes 
    self informAboutRuleReduction:'DirElemConstructor1'.
    ^(AstDirElemConstructor new)
        qName:(nodes at:2);
        dirAttributeList:(nodes at:3).
!

reduceActionForDirElemConstructor2:nodes 
    self informAboutRuleReduction:'DirElemConstructor2'.
    ^(AstDirElemConstructor new)
        qName:(nodes at:2);
        dirAttributeList:(nodes at:3);
        dirElemContent:(nodes at:5).
!

reduceActionForDirElemConstructor3:nodes 
    self informAboutRuleReduction:'DirElemConstructor3'.
    ^ (AstDirElemConstructor new)
        qname:(nodes at:2);
        dirElemContent:(nodes at:4).
!

reduceActionForDirElemConstructor4:nodes 
    self informAboutRuleReduction:'DirElemConstructor4'.
    ^ (AstDirElemConstructor new)
        qname:(nodes at:2);
        dirAttributeList:(nodes at:3);
        dirElemContent:(nodes at:5).
!

reduceActionForDirElemContent1:nodes 
    self informAboutRuleReduction:'DirElemContent1'.
    ^AstDirElemContent new content:(nodes at:1).
!

reduceActionForDirElemContent21:nodes 
    self informAboutRuleReduction:'DirElemContent1'.
    ^AstDirElemContent new content:(nodes at:1).
!

reduceActionForDirElemContent22:nodes 
    self informAboutRuleReduction:'DirElemContent2'.
    ^(AstDirElemContent new)
        content:(nodes at:1);
        dirElemContent:(nodes at:2).
!

reduceActionForDirElemContent23:nodes 
    self informAboutRuleReduction:'DirElemContent3'.
    ^AstDirElemContent new content:(nodes at:1).
!

reduceActionForDirElemContent24:nodes 
    self informAboutRuleReduction:'DirElemContent4'.
    ^(AstDirElemContent new)
        content:(nodes at:1);
        dirElemContent:(nodes at:2).
!

reduceActionForDirElemContent2:nodes 
    self informAboutRuleReduction:'DirElemContent3'.
    ^AstDirElemContent new content:(nodes at:1).
!

reduceActionForDirElemContent3:nodes 
    self informAboutRuleReduction:'DirElemContent4'.
    ^AstDirElemContent new content:(nodes at:1).
!

reduceActionForDirElemContent4:nodes 
    self informAboutRuleReduction:'DirElemContent4'.
    ^ (AstDirElemContent new)
        content:(nodes at:1);
        dirElemContent:(nodes at:2).
!

reduceActionForDirectConstructor1:nodes 
    self informAboutRuleReduction:'DirectConstructor1'.
    ^nodes at:1.
!

reduceActionForDisconnectTriggerExpr1:nodes 
    self informAboutRuleReduction:'DisconnectTriggerExpr'.
    ^(AstDisconnectTriggerExpr new) targetExpr:(nodes at:4).
!

reduceActionForDocumentTest1:nodes 
    self informAboutRuleReduction:'DocumentTest1'.
    ^XPathDocumentTest new.
!

reduceActionForDocumentTest2:nodes 
    self informAboutRuleReduction:'DocumentTest2'.
    ^XPathDocumentTest new elementTest:(nodes at:3).
!

reduceActionForDoubleLiteral1:nodes 
    self 
        informAboutRuleReduction:'DoubleLiteral1 -' , ((nodes at:1) asString).
    ^AstDoubleLiteral new content:((nodes at:1) value).
!

reduceActionForDropTriggerExpr1:nodes 
    self informAboutRuleReduction:'DropTriggerExpr'.
    ^(AstDropTriggerExpr new) name:(nodes at:3).
!

reduceActionForElementContentChar1:nodes 
    self 
        informAboutRuleReduction:'ElementContentChar1 -' , ((nodes at:1) asString).
    ^AstElementContentChar new content:((nodes at:1) value).
!

reduceActionForElementName1:nodes 
    self informAboutRuleReduction:'ElementName1'.
    ^nodes at:1.
!

reduceActionForElementNameOrWildcard1:nodes 
    self informAboutRuleReduction:'ElementNameOrWildcard1'.
    ^AstElementNameOrWildcard new elementName:(nodes at:1).
!

reduceActionForElementNameOrWildcard2:nodes 
    self informAboutRuleReduction:'ElementNameOrWildcard2'.
    ^AstElementNameOrWildcard new.
!

reduceActionForElementTest1:nodes 
    self informAboutRuleReduction:'ElementTest1'.
    ^XPathElementTest new.
!

reduceActionForElementTest2:nodes 
    self informAboutRuleReduction:'ElementTest2'.
    ^XPathElementTest new elementName:(nodes at:3).
!

reduceActionForEmptyParamList1:nodes 
    ^#()
!

reduceActionForEnclosedExpr1:nodes 
    self informAboutRuleReduction:'EnclosedExpr1'.
    ^AstEnclosedExpr new expr:(nodes at:2).
!

reduceActionForEventTriggerExpr1:nodes 
    self informAboutRuleReduction:'EventTriggerExpr1'.
    ^nodes at:1.
!

reduceActionForEventTriggerExpr2:nodes 
    self informAboutRuleReduction:'EventTriggerExpr2'.
    ^nodes at:1.
!

reduceActionForEventTriggerExpr3:nodes 
    self informAboutRuleReduction:'EventTriggerExpr3'.
    ^nodes at:1.
!

reduceActionForEventTriggerExpr4:nodes 
    self informAboutRuleReduction:'EventTriggerExpr4'.
    ^nodes at:1.
!

reduceActionForExpr1:nodes 
    self informAboutRuleReduction:'Expr1'.
    ^nodes at:1.
!

reduceActionForExpr2:nodes 
    self informAboutRuleReduction:'Expr2'.
    ^(AstExpr new)
        exprSingle:(nodes at:1);
        expr:(nodes at:3).
!

reduceActionForExprSingle10:nodes 
    self informAboutRuleReduction:'ExprSingle10'.
    ^nodes at:1.
!

reduceActionForExprSingle11:nodes 
    self informAboutRuleReduction:'ExprSingle11'.
    ^nodes at:1.
!

reduceActionForExprSingle12:nodes 
    self informAboutRuleReduction:'ExprSingle12'.
    ^nodes at:1.
!

reduceActionForExprSingle13:nodes 
    self informAboutRuleReduction:'ExprSingle13'.
    ^nodes at:1.
!

reduceActionForExprSingle1:nodes 
    self informAboutRuleReduction:'ExprSingle1'.
    ^nodes at:1.
!

reduceActionForExprSingle2:nodes 
    self informAboutRuleReduction:'ExprSingle2'.
    ^nodes at:1.
!

reduceActionForExprSingle3:nodes 
    self informAboutRuleReduction:'ExprSingle3'.
    ^nodes at:1.
!

reduceActionForExprSingle4:nodes 
    self informAboutRuleReduction:'ExprSingle4'.
    ^nodes at:1.
!

reduceActionForExprSingle5:nodes 
    self informAboutRuleReduction:'ExprSingle5'.
    ^nodes at:1.
!

reduceActionForExprSingle6:nodes 
    self informAboutRuleReduction:'ExprSingle6'.
    ^nodes at:1.
!

reduceActionForExprSingle7:nodes 
    self informAboutRuleReduction:'ExprSingle7'.
    ^nodes at:1.
!

reduceActionForExprSingle8:nodes 
    self informAboutRuleReduction:'ExprSingle8'.
    ^nodes at:1.
!

reduceActionForExprSingle9:nodes 
    self informAboutRuleReduction:'ExprSingle9'.
    ^nodes at:1.
!

reduceActionForFLWORExpr1:nodes 
    self informAboutRuleReduction:'FLWORExpr1'.
    ^(AstFLWORExpr new)
        flworExpr_ForLet:(nodes at:1);
        exprSingle:(nodes at:3).
!

reduceActionForFLWORExpr2:nodes 
    self informAboutRuleReduction:'FLWORExpr2'.
    ^(AstFLWORExpr new)
        flworExpr_ForLet:(nodes at:1);
        whereClause:(nodes at:2);
        exprSingle:(nodes at:4).
!

reduceActionForFLWORExpr3:nodes 
    self informAboutRuleReduction:'FLWORExpr3'.
    ^(AstFLWORExpr new)
        flworExpr_ForLet:(nodes at:1);
        orderByClause:(nodes at:2);
        exprSingle:(nodes at:4).
!

reduceActionForFLWORExpr4:nodes 
    self informAboutRuleReduction:'FLWORExpr4'.
    ^(AstFLWORExpr new)
        flworExpr_ForLet:(nodes at:1);
        whereClause:(nodes at:2);
        orderByClause:(nodes at:3);
        exprSingle:(nodes at:5).
!

reduceActionForFLWORExpr_ForLet1:nodes 
    self informAboutRuleReduction:'FLWORExpr_ForLet1'.
    ^nodes at:1.
!

reduceActionForFLWORExpr_ForLet2:nodes 
    self informAboutRuleReduction:'FLWORExpr_ForLet2'.
    ^nodes at:1.
!

reduceActionForFLWORExpr_ForLet3:nodes 
    self informAboutRuleReduction:'FLWORExpr_ForLet3'.
    ^(AstFLWORExpr_ForLet new)
        forClause:(nodes at:1);
        flworExpr_ForLet:(nodes at:2).
!

reduceActionForFLWORExpr_ForLet4:nodes 
    self informAboutRuleReduction:'FLWORExpr_ForLet4'.
    ^(AstFLWORExpr_ForLet new)
        letClause:(nodes at:1);
        flworExpr_ForLet:(nodes at:2).
!

reduceActionForFilterExpr1:nodes 
    self informAboutRuleReduction:'FilterExpr2'.
    ^(AstFilterExpr new)
        primaryExpr:(nodes at:1);
        predicateList:(nodes at:2).
!

reduceActionForFilterExpr2:nodes 
    self informAboutRuleReduction:'FilterExpr2'.
    ^ (AstFilterExpr new)
        primaryExpr:(nodes at:1);
        predicateList:(nodes at:2).

    "Modified: / 17-11-2007 / 14:03:09 / janfrog"
!

reduceActionForForClause1:nodes 
    self informAboutRuleReduction:'ForClause1'.
    ^nodes at:2.
!

reduceActionForForClause_Impl1:nodes 
    self informAboutRuleReduction:'ForClause_Impl1'.
    ^(AstForClause new)
        varName:(nodes at:2);
        exprSingle:(nodes at:4).
!

reduceActionForForClause_Impl2:nodes 
    self informAboutRuleReduction:'ForClause_Impl2'.
    ^(AstForClause new)
        varName:(nodes at:2);
        exprSingle:(nodes at:4);
        forClause:(nodes at:6).
!

reduceActionForForClause_Impl3:nodes 
    self informAboutRuleReduction:'ForClause_Impl3'.
    ^(AstForClause new)
        varName:(nodes at:2);
        positionalVar:(nodes at:3);
        exprSingle:(nodes at:5).
!

reduceActionForForClause_Impl4:nodes 
    self informAboutRuleReduction:'ForClause_Impl4'.
    ^(AstForClause new)
        varName:(nodes at:2);
        positionalVar:(nodes at:3);
        exprSingle:(nodes at:5);
        forClause:(nodes at:7).
!

reduceActionForForwardAxis1:nodes 
    self informAboutRuleReduction:'ForwardAxis1'.
    ^XPathAxisChild new
!

reduceActionForForwardAxis2:nodes 
    self informAboutRuleReduction:'ForwardAxis2'.
    ^XPathAxisDescendant new
!

reduceActionForForwardAxis3:nodes 
    self informAboutRuleReduction:'ForwardAxis3'.
    ^XPathAxisAttribute new
!

reduceActionForForwardAxis4:nodes 
    self informAboutRuleReduction:'ForwardAxis4'.
    ^XPathAxisSelf new
!

reduceActionForForwardAxis5:nodes 
    self informAboutRuleReduction:'ForwardAxis5'.
    ^XPathAxisDescendantOrSelf new
!

reduceActionForForwardAxis6:nodes 
    self informAboutRuleReduction:'ForwardAxis6'.
    ^XPathAxisFollowingSibling new
!

reduceActionForForwardAxis7:nodes 
    self informAboutRuleReduction:'ForwardAxis7'.
    ^XPathAxisFollowing new
!

reduceActionForForwardStep1:nodes 
    self informAboutRuleReduction:'ForwardStep1'.
    ^(XPathLocationStep new)
        axis:(nodes at:1);
        nodeTest:(nodes at:2);
        yourself
!

reduceActionForForwardStep2:nodes 
    self informAboutRuleReduction:'ForwardStep2'.
    ^nodes at:1
!

reduceActionForFunctionCall1:nodes 
    self informAboutRuleReduction:'FunctionCall1'.
    ^AstFunctionCall new qname:(nodes at:1).
!

reduceActionForFunctionCall2:nodes 
    self informAboutRuleReduction:'FunctionCall2'.
    ^(AstFunctionCall new)
        qname:(nodes at:1);
        functionParametersList:(nodes at:3).
!

reduceActionForFunctionDecl11:nodes 
    ^ (AstFunctionDecl new)
        name:(nodes at:3);
        paramList:(nodes at:5);
        body:(nodes at:7)
!

reduceActionForFunctionDecl1:nodes 
    ^(AstFunctionDecl new)
        name:(nodes at:3);
        paramList:(nodes at:5);
        body:(nodes at:7)
!

reduceActionForFunctionDecl21:nodes 
    ^ (AstFunctionDecl new)
        name:(nodes at:3);
        paramList:(nodes at:5);
        body:(nodes at:7)
!

reduceActionForFunctionParametersList1:nodes 
    self informAboutRuleReduction:'FunctionParametersList1'.
    ^AstFunctionParametersList new exprSingle:(nodes at:1).
!

reduceActionForFunctionParametersList2:nodes 
    self informAboutRuleReduction:'FunctionParametersList2'.
    ^(AstFunctionParametersList new)
        exprSingle:(nodes at:1);
        functionParametersList:(nodes at:3).
!

reduceActionForGeneralComp1:nodes 
    self informAboutRuleReduction:'GeneralComp1'.
    ^#eqGeneral.
!

reduceActionForGeneralComp2:nodes 
    self informAboutRuleReduction:'GeneralComp2'.
    ^#neGeneral.
!

reduceActionForGeneralComp3:nodes 
    self informAboutRuleReduction:'GeneralComp3'.
    ^#ltGeneral.
!

reduceActionForGeneralComp4:nodes 
    self informAboutRuleReduction:'GeneralComp4'.
    ^#leGeneral.
!

reduceActionForGeneralComp5:nodes 
    self informAboutRuleReduction:'GeneralComp5'.
    ^#gtGeneral.
!

reduceActionForGeneralComp6:nodes 
    self informAboutRuleReduction:'GeneralComp6'.
    ^#geGeneral.
!

reduceActionForGroup______updating_1:nodes 
    ^ nodes at:1
!

reduceActionForIfExpr1:nodes 
    self informAboutRuleReduction:'IfExpr1'.
    ^(AstIfExpr new)
        expr:(nodes at:3);
        trueExprSingle:(nodes at:6);
        falseExprSingle:(nodes at:8).
!

reduceActionForInsertClause1:nodes 
    self informAboutRuleReduction:'InsertIntoClause'.
    ^(AstInsertIntoExpr new)
        targetExpr:(nodes at:3);
        sourceExpr:(nodes at:1).
!

reduceActionForInsertClause2:nodes 
    self informAboutRuleReduction:'InsertAsFirstIntoClause'.
    ^(AstInsertAsFirstIntoExpr new)
        targetExpr:(nodes at:5);
        sourceExpr:(nodes at:1).
!

reduceActionForInsertClause3:nodes 
    self informAboutRuleReduction:'InsertAsLastIntoClause'.
    ^(AstInsertAsLastIntoExpr new)
        targetExpr:(nodes at:5);
        sourceExpr:(nodes at:1).
!

reduceActionForInsertClause4:nodes 
    self informAboutRuleReduction:'InsertAfterClause'.
    ^(AstInsertAfterExpr new)
        targetExpr:(nodes at:3);
        sourceExpr:(nodes at:1).
!

reduceActionForInsertClause5:nodes 
    self informAboutRuleReduction:'InsertBeforeClause'.
    ^(AstInsertBeforeExpr new)
        targetExpr:(nodes at:3);
        sourceExpr:(nodes at:1).
!

reduceActionForInsertExpr1:nodes 
    self informAboutRuleReduction:'InsertExpr'.
    ^nodes at:3.
!

reduceActionForInsertTriggerExpr1:nodes 
    self informAboutRuleReduction:'InsertTriggerExpr'.
    ^(AstInsertTriggerExpr new) triggerBodyExpr:(nodes at:2).
!

reduceActionForInstanceOfExpr1:nodes 
    self informAboutRuleReduction:'InstanceOfExpr1'.
    ^nodes at:1.
!

reduceActionForInstanceOfExpr2:nodes 
    self informAboutRuleReduction:'InstanceOfExpr2'.
    ^(AstInstanceOfExpr new)
        treatExpr:(nodes at:1);
        sequenceType:(nodes at:4).
!

reduceActionForIntegerLiteral1:nodes 
    self 
        informAboutRuleReduction:'IntegerLiteral1 -' , ((nodes at:1) asString).
    ^AstIntegerLiteral new content:((nodes at:1) value).
!

reduceActionForIntersectExceptExpr1:nodes 
    self informAboutRuleReduction:'IntersectExceptExpr1'.
    ^nodes at:1.
!

reduceActionForIntersectExceptExpr2:nodes 
    self informAboutRuleReduction:'IntersectExceptExpr2'.
    ^(AstIntersectExceptExpr new)
        unaryExpr:(nodes at:1);
        operand:#intersect;
        intersectExceptExpr:(nodes at:3).
!

reduceActionForIntersectExceptExpr3:nodes 
    self informAboutRuleReduction:'IntersectExceptExpr3'.
    ^(AstIntersectExceptExpr new)
        unaryExpr:(nodes at:1);
        operand:#except;
        intersectExceptExpr:(nodes at:3).
!

reduceActionForItemType1:nodes 
    self informAboutRuleReduction:'ItemType1'.
    ^AstItemType new itemTest:AstItemTypeItem new.
!

reduceActionForItemType2:nodes 
    self informAboutRuleReduction:'ItemType2'.
    ^AstItemType new kindTest:(nodes at:1).
!

reduceActionForItemType3:nodes 
    self informAboutRuleReduction:'ItemType3'.
    ^AstItemType new atomicType:(nodes at:1).
!

reduceActionForKindTest1:nodes 
    self informAboutRuleReduction:'KindTest1'.
    ^nodes at:1.
!

reduceActionForKindTest2:nodes 
    self informAboutRuleReduction:'KindTest2'.
    ^nodes at:1.
!

reduceActionForKindTest3:nodes 
    self informAboutRuleReduction:'KindTest3'.
    ^nodes at:1.
!

reduceActionForKindTest4:nodes 
    self informAboutRuleReduction:'KindTest4'.
    ^nodes at:1.
!

reduceActionForKindTest5:nodes 
    self informAboutRuleReduction:'KindTest5'.
    ^nodes at:1.
!

reduceActionForKindTest6:nodes 
    ^XPathCommentTest new
!

reduceActionForKindTest7:nodes 
    ^XPathProcessingInstructionTest new
!

reduceActionForLetClause1:nodes 
    self informAboutRuleReduction:'LetClause1'.
    ^nodes at:2.
!

reduceActionForLetClause_Impl1:nodes 
    self informAboutRuleReduction:'LetClause_Impl1'.
    ^(AstLetClause new)
        varName:(nodes at:2);
        exprSingle:(nodes at:4).
!

reduceActionForLetClause_Impl2:nodes 
    self informAboutRuleReduction:'LetClause_Impl2'.
    ^(AstLetClause new)
        varName:(nodes at:2);
        exprSingle:(nodes at:4);
        letClause:(nodes at:6).
!

reduceActionForLiteral1:nodes 
    self informAboutRuleReduction:'Literal1'.
    ^nodes at:1.
!

reduceActionForLiteral2:nodes 
    self informAboutRuleReduction:'Literal2'.
    ^nodes at:1.
!

reduceActionForMainModule1:nodes 
    ^(AstMainModule new)
        prolog:(nodes at:1);
        queryBody:(nodes at:2)
!

reduceActionForMultiplicativeExpr1:nodes 
    self informAboutRuleReduction:'MultiplicativeExpr1'.
    ^nodes at:1.
!

reduceActionForMultiplicativeExpr2:nodes 
    self informAboutRuleReduction:'MultiplicativeExpr2'.
    ^(AstMultiplicativeExpr new)
        unionExpr:(nodes at:1);
        operand:#krat;
        multiplicativeExpr:(nodes at:3).
!

reduceActionForMultiplicativeExpr3:nodes 
    self informAboutRuleReduction:'MultiplicativeExpr3'.
    ^(AstMultiplicativeExpr new)
        unionExpr:(nodes at:1);
        operand:#div;
        multiplicativeExpr:(nodes at:3).
!

reduceActionForMultiplicativeExpr4:nodes 
    self informAboutRuleReduction:'MultiplicativeExpr4'.
    ^(AstMultiplicativeExpr new)
        unionExpr:(nodes at:1);
        operand:#idiv;
        multiplicativeExpr:(nodes at:3).
!

reduceActionForMultiplicativeExpr5:nodes 
    self informAboutRuleReduction:'MultiplicativeExpr5'.
    ^(AstMultiplicativeExpr new)
        unionExpr:(nodes at:1);
        operand:#mod;
        multiplicativeExpr:(nodes at:3).
!

reduceActionForNCName1:nodes 
    self informAboutRuleReduction:'NCName1 - ' , ((nodes at:1) asString).
    ^AstNCName new content:((nodes at:1) value).
!

reduceActionForNameTest1:nodes 
    self informAboutRuleReduction:'NameTest1'.
    ^XPathNameTest new qName:(nodes at:1) content
!

reduceActionForNameTest2:nodes 
    self informAboutRuleReduction:'NameTest1'.
    ^(XPathNameTest new)
        prefix:'*';
        localName:'*'
!

reduceActionForNameTest3:nodes 
    self informAboutRuleReduction:'NameTest1'.
    ^(XPathNameTest new)
        prefix:'*';
        localName:(nodes at:3) content
!

reduceActionForNamespaceDecl1:nodes 
    ^(AstNamespaceDecl new)
        prefix:(nodes at:3);
        nsuri:(nodes at:5)
!

reduceActionForNewNameExpr1:nodes 
    self informAboutRuleReduction:'NewNameExpr'.
    ^nodes at:1.
!

reduceActionForNodeComp1:nodes 
    self informAboutRuleReduction:'NodeComp1'.
    ^#is.
!

reduceActionForNodeComp2:nodes 
    self informAboutRuleReduction:'NodeComp2'.
    ^#isLess.
!

reduceActionForNodeComp3:nodes 
    self informAboutRuleReduction:'NodeComp3'.
    ^#isMore.
!

reduceActionForNodeTest1:nodes 
    self informAboutRuleReduction:'NodeTest1'.
    ^nodes at:1.
!

reduceActionForNodeTest2:nodes 
    self informAboutRuleReduction:'NodeTest2'.
    ^nodes at:1.
!

reduceActionForNodeTriggerExpr1:nodes 
    self informAboutRuleReduction:'NodeTriggerExpr'.
    ^(AstNodeTriggerExpr new) triggerNameAndTargetExpr:(nodes at:2).
!

reduceActionForNumericLiteral1:nodes 
    self informAboutRuleReduction:'NumericLiteral1'.
    ^nodes at:1.
!

reduceActionForNumericLiteral2:nodes 
    self informAboutRuleReduction:'NumericLiteral2'.
    ^nodes at:1.
!

reduceActionForNumericLiteral3:nodes 
    self informAboutRuleReduction:'NumericLiteral3'.
    ^nodes at:1.
!

reduceActionForOccurenceIndicator1:nodes 
    self informAboutRuleReduction:'OccurenceIndicator1'.
    ^AstZeroOrOneOccurenceIndicator new.
!

reduceActionForOccurenceIndicator21:nodes 
    ^self informAboutRuleReduction:'OccurenceIndicator2-1'
!

reduceActionForOccurenceIndicator2:nodes 
    self informAboutRuleReduction:'OccurenceIndicator2'.
    ^AstZeroOrMultipleOccurenceIndicator new.
!

reduceActionForOccurenceIndicator3:nodes 
    self informAboutRuleReduction:'OccurenceIndicator3'.
    ^AstOneOrMultipleOccurenceIndicator new.
!

reduceActionForOccurenceIndicator4:nodes 
    ^self informAboutRuleReduction:'OccurenceIndicator4'
!

reduceActionForOccurrenceIndicator1:nodes 
    self informAboutRuleReduction:'OccurrenceIndicator1'.
    ^AstZeroOrOneOccurrenceIndicator new.
!

reduceActionForOccurrenceIndicator2:nodes 
    self informAboutRuleReduction:'OccurrenceIndicator2'.
    ^AstZeroOrMultipleOccurrenceIndicator new.
!

reduceActionForOccurrenceIndicator3:nodes 
    self informAboutRuleReduction:'OccurrenceIndicator3'.
    ^AstOneOrMultipleOccurrenceIndicator new.
!

reduceActionForOneOrMoreParamList1:nodes 
    ^(nodes at:1)
        add:(nodes at:3);
        yourself
!

reduceActionForOneOrMoreParamList2:nodes 
    ^OrderedCollection with:(nodes at:1)
!

reduceActionForOptional__Group______updating_1:nodes 
    ^ nil
!

reduceActionForOptional__Group______updating_2:nodes 
    ^ nodes at:1
!

reduceActionForOptional__Group______value___of_1:nodes 
    ^ nil

    "Modified: / 31-10-2007 / 09:24:55 / janfrog"
!

reduceActionForOptional__Group______value___of_2:nodes 
    ^ nodes at:1

    "Modified: / 31-10-2007 / 09:24:55 / janfrog"
!

reduceActionForOptional__OccurenceIndicator1:nodes 
    ^nil
!

reduceActionForOptional__OccurenceIndicator21:nodes 
    ^nil
!

reduceActionForOptional__OccurenceIndicator22:nodes 
    ^nodes at:1
!

reduceActionForOptional__OccurenceIndicator2:nodes 
    ^nodes at:1
!

reduceActionForOptional__OccurrenceIndicator1:nodes 
    ^nil
!

reduceActionForOptional__OccurrenceIndicator2:nodes 
    ^nodes at:1
!

reduceActionForOptional___updating_1:nodes 
    ^ nil
!

reduceActionForOptional___updating_2:nodes 
    ^ nodes at:1
!

reduceActionForOrExpr1:nodes 
    self informAboutRuleReduction:'OrExpr1'.
    ^nodes at:1.
!

reduceActionForOrExpr2:nodes 
    self informAboutRuleReduction:'OrExpr2'.
    ^(AstOrExpr new)
        andExpr:(nodes at:1);
        orExpr:(nodes at:3).
!

reduceActionForOrderByClause1:nodes 
    self informAboutRuleReduction:'OrderByClause1'.
    ^(AstOrderByClause new)
        isStable:false;
        orderSpecList:(nodes at:3).
!

reduceActionForOrderByClause2:nodes 
    self informAboutRuleReduction:'OrderByClause2'.
    ^(AstOrderByClause new)
        isStable:true;
        orderSpecList:(nodes at:4).
!

reduceActionForOrderModifier1:nodes 
    self informAboutRuleReduction:'OrderModifier1'.
    ^AstOrderModifier new ascDesc:(nodes at:1).
!

reduceActionForOrderModifier2:nodes 
    self informAboutRuleReduction:'OrderModifier2'.
    ^AstOrderModifier new greatestLeast:(nodes at:1).
!

reduceActionForOrderModifier3:nodes 
    self informAboutRuleReduction:'OrderModifier3'.
    ^(AstOrderModifier new)
        ascDesc:(nodes at:1);
        greatestLeast:(nodes at:2).
!

reduceActionForOrderModifier_AscDesc1:nodes 
    self informAboutRuleReduction:'OrderModifier_AscDesc1'.
    ^#asc.
!

reduceActionForOrderModifier_AscDesc2:nodes 
    self informAboutRuleReduction:'OrderModifier_AscDesc2'.
    ^#desc.
!

reduceActionForOrderModifier_GreatestLeast1:nodes 
    self informAboutRuleReduction:'OrderModifier_GreatestLeast1'.
    ^#greatest.
!

reduceActionForOrderModifier_GreatestLeast2:nodes 
    self informAboutRuleReduction:'OrderModifier_GreatestLeast2'.
    ^#least.
!

reduceActionForOrderSpec1:nodes 
    self informAboutRuleReduction:'OrderSpec1'.
    ^AstOrderSpec new exprSingle:(nodes at:1).
!

reduceActionForOrderSpec2:nodes 
    self informAboutRuleReduction:'OrderSpec2'.
    ^(AstOrderSpec new)
        exprSingle:(nodes at:1);
        orderModifier:(nodes at:2).
!

reduceActionForOrderSpecList1:nodes 
    self informAboutRuleReduction:'OrderSpecList1'.
    ^nodes at:1.
!

reduceActionForOrderSpecList2:nodes 
    self informAboutRuleReduction:'OrderSpecList2'.
    ^(AstOrderSpecList new)
        orderSpec:(nodes at:1);
        orderSpecList:(nodes at:3).
!

reduceActionForOrderedExpr1:nodes 
    self informAboutRuleReduction:'OrderedExpr1'.
    ^nodes at:3.
!

reduceActionForParam1:nodes 
    ^AstParam new name:(nodes at:2)
!

reduceActionForParamList1:nodes 
    ^nodes at:1
!

reduceActionForParamList2:nodes 
    ^'2'
!

reduceActionForParenthesizedExpr1:nodes 
    self informAboutRuleReduction:'ParenthesizedExpr1'.
    ^AstParenthesizedExpr new.
!

reduceActionForParenthesizedExpr2:nodes 
    self informAboutRuleReduction:'ParenthesizedExpr2'.
    ^AstParenthesizedExpr new expr:(nodes at:2).
!

reduceActionForPathExpr1:nodes 
    self informAboutRuleReduction:'PathExpr2'.
    ^(nodes at:2)
        absolute:true;
        yourself
!

reduceActionForPathExpr2:nodes 
    self informAboutRuleReduction:'PathExpr3'.
    ^(nodes at:2)
        addFirst:((XPathLocationStep new)
                    axis:XPathAxisDescendantOrSelf new;
                    nodeTest:XPathAnyKindTest new);
        yourself
!

reduceActionForPathExpr3:nodes 
    self informAboutRuleReduction:'PathExpr4'.
    ^nodes at:1.
!

reduceActionForPositionalVar1:nodes 
    self informAboutRuleReduction:'PositionalVar1'.
    ^nodes at:3.
!

reduceActionForPredefinedEntityRef1:nodes 
    self informAboutRuleReduction:'PredefinedEntityRef1 -' 
                , ((nodes at:1) asString).
    ^AstPredefinedEntityRef new content:((nodes at:1) value).
!

reduceActionForPredicate1:nodes 
    self informAboutRuleReduction:'Predicate1'.
    ^XPathPredicate new expr:(nodes at:2).
!

reduceActionForPredicate2:nodes 
    self informAboutRuleReduction:'Predicate2'.
    ^XPathPredicate new
!

reduceActionForPredicateList1:nodes 
    self informAboutRuleReduction:'PredicateList1'.
    ^ nodes at:1.

    "Modified: / 17-11-2007 / 14:00:00 / janfrog"
!

reduceActionForPredicateList2:nodes 
    self informAboutRuleReduction:'PredicateList2'.
    ^ (AstPredicateList new)
        predicate:(nodes at:1);
        predicateList:(nodes at:2).

    "Modified: / 17-11-2007 / 14:00:00 / janfrog"
!

reduceActionForPrimaryExpr1:nodes 
    self informAboutRuleReduction:'PrimaryExpr1'.
    ^nodes at:1.
!

reduceActionForPrimaryExpr2:nodes 
    self informAboutRuleReduction:'PrimaryExpr2'.
    ^nodes at:1.
!

reduceActionForPrimaryExpr3:nodes 
    self informAboutRuleReduction:'PrimaryExpr3'.
    ^nodes at:1.
!

reduceActionForPrimaryExpr4:nodes 
    self informAboutRuleReduction:'PrimaryExpr4'.
    ^nodes at:1.
!

reduceActionForPrimaryExpr5:nodes 
    self informAboutRuleReduction:'PrimaryExpr5'.
    ^nodes at:1.
!

reduceActionForPrimaryExpr6:nodes 
    self informAboutRuleReduction:'PrimaryExpr6'.
    ^nodes at:1.
!

reduceActionForPrimaryExpr7:nodes 
    self informAboutRuleReduction:'PrimaryExpr7'.
    ^nodes at:1.
!

reduceActionForPrimaryExpr8:nodes 
    self informAboutRuleReduction:'PrimaryExpr8'.
    ^nodes at:1.
!

reduceActionForProlog1:nodes 
    ^AstProlog new declarations:((nodes at:1)
                addAll:(nodes at:2);
                yourself)
!

reduceActionForProlog21:nodes 
    ^ AstProlog new declarations:((nodes at:1)
                addAll:(nodes at:2);
                yourself)
!

reduceActionForPrologDeclarationClass11:nodes 
    ^ nodes at:1
!

reduceActionForPrologDeclarationClass12:nodes 
    ^ nodes at:1
!

reduceActionForPrologDeclarationClass13:nodes 
    ^ nodes at:1
!

reduceActionForPrologDeclarationClass1List1:nodes 
    ^ (nodes at:1)
        add:(nodes at:2);
        yourself
!

reduceActionForPrologDeclarationClass1List2:nodes 
    ^ OrderedCollection new:5
!

reduceActionForPrologDeclarationClass21:nodes 
    ^ nodes at:1

    "Modified: / 28-12-2006 / 13:35:22 / janfrog"
!

reduceActionForPrologDeclarationClass2List1:nodes 
    ^ (nodes at:1)
        add:(nodes at:2);
        yourself

    "Modified: / 01-12-2008 / 09:42:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

reduceActionForPrologDeclarationClass2List2:nodes 
    ^ OrderedCollection new:5

    "Modified: / 01-12-2008 / 09:42:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

reduceActionForPrologDeclarationClassA1:nodes 
    ^AstModuleImport new uri:(nodes at:3)
!

reduceActionForPrologDeclarationClassA21:nodes 
    ^ nodes at:1
!

reduceActionForPrologDeclarationClassA22:nodes 
    ^ nodes at:1
!

reduceActionForPrologDeclarationClassA23:nodes 
    ^ nodes at:1
!

reduceActionForPrologDeclarationClassA24:nodes 
    ^ AstModuleImport new uri:(nodes at:3)
!

reduceActionForPrologDeclarationClassA25:nodes 
    ^ (AstModuleImport new)
        prefix:(nodes at:4);
        uri:(nodes at:6)
!

reduceActionForPrologDeclarationClassA2:nodes 
    ^(AstModuleImport new)
        prefix:(nodes at:4);
        uri:(nodes at:6)
!

reduceActionForPrologDeclarationClassA3:nodes 
    ^ AstModuleImport new uri:(nodes at:3)
!

reduceActionForPrologDeclarationClassA4:nodes 
    ^ (AstModuleImport new)
        prefix:(nodes at:4);
        uri:(nodes at:6)
!

reduceActionForPrologDeclarationClassA5:nodes 
    ^ (AstModuleImport new)
        prefix:(nodes at:4);
        uri:(nodes at:6)
!

reduceActionForPrologDeclarationClassA6:nodes 
    ^ nodes at:1
!

reduceActionForPrologDeclarationClassB1:nodes 
    ^nodes at:1
!

reduceActionForPrologDeclarationClassB21:nodes 
    ^ nodes at:1
!

reduceActionForPrologDeclarationClassB2:nodes 
    ^nodes at:1
!

reduceActionForPrologDeclarationClassB3:nodes 
    ^nodes at:1
!

reduceActionForPrologDeclarationClassB4:nodes 
    ^nodes at:1
!

reduceActionForQName1:nodes 
    self informAboutRuleReduction:'QName1 - ' , ((nodes at:1) asString).
    ^AstQName new content:((nodes at:1) value).
!

reduceActionForQuantifiedExpr1:nodes 
    self informAboutRuleReduction:'QuantifiedExpr1'.
    ^(AstQuantifiedExpr new)
        someEvery:#some;
        quantifiedExpr_Impl:(nodes at:2);
        exprSingle:(nodes at:4).
!

reduceActionForQuantifiedExpr2:nodes 
    self informAboutRuleReduction:'QuantifiedExpr2'.
    ^(AstQuantifiedExpr new)
        someEvery:#every;
        quantifiedExpr_Impl:(nodes at:2);
        exprSingle:(nodes at:4).
!

reduceActionForQuantifiedExpr_Impl1:nodes 
    self informAboutRuleReduction:'QuantifiedExpr_Impl1'.
    ^(AstQuantifiedExpr_Impl new)
        varName:(nodes at:2);
        exprSingle:(nodes at:4).
!

reduceActionForQuantifiedExpr_Impl2:nodes 
    self informAboutRuleReduction:'QuantifiedExpr_Impl2'.
    ^(AstQuantifiedExpr_Impl new)
        varName:(nodes at:2);
        exprSingle:(nodes at:4);
        quantifiedExpr_Impl:(nodes at:6).
!

reduceActionForQueryBody1:nodes 
    self informAboutRuleReduction:'QueryBody1'.
    ^nodes at:1.
!

reduceActionForRangeExpr1:nodes 
    self informAboutRuleReduction:'RangeExpr1'.
    ^nodes at:1.
!

reduceActionForRangeExpr2:nodes 
    self informAboutRuleReduction:'RangeExpr2'.
    ^(AstRangeExpr new)
        additiveExprFrom:(nodes at:1);
        additiveExprTo:(nodes at:3).
!

reduceActionForRelativePathExpr1:nodes 
    self informAboutRuleReduction:'RelativePathExpr1'.
    ^XPathExpression with:(nodes at:1).
!

reduceActionForRelativePathExpr2:nodes 
    self informAboutRuleReduction:'RelativePathExpr2'.
    ^(nodes at:1)
        add:(nodes at:3);
        yourself
!

reduceActionForRelativePathExpr3:nodes 
    self informAboutRuleReduction:'RelativePathExpr3'.
    ^(nodes at:1)
        add:((XPathLocationStep new)
                    axis:XPathAxisDescendantOrSelf new;
                    nodeTest:XPathAnyKindTest new);
        add:(nodes at:3);
        yourself
!

reduceActionForRenameExpr1:nodes 
    self informAboutRuleReduction:'RenameExpr'.
    ^(AstRenameExpr new)
        targetExpr:(nodes at:3);
        newNameExpr:(nodes at:5).
!

reduceActionForRenameTriggerExpr1:nodes 
    self informAboutRuleReduction:'RenameTriggerExpr'.
    ^(AstRenameTriggerExpr new) triggerBodyExpr:(nodes at:2).
!

reduceActionForRepeat__DirAttributeListElem1:nodes 
    ^OrderedCollection new
!

reduceActionForRepeat__DirAttributeListElem2:nodes 
    ^(nodes at:1)
        add:(nodes at:2);
        yourself
!

reduceActionForRepeat__DirElemContent1:nodes 
    ^OrderedCollection new
!

reduceActionForRepeat__DirElemContent2:nodes 
    ^(nodes at:1)
        add:(nodes at:2);
        yourself
!

reduceActionForRepeat__Group_____________VarName______ExprSingle1:nodes 
    ^ OrderedCollection new
!

reduceActionForRepeat__Group_____________VarName______ExprSingle2:nodes 
    ^ (nodes at:1)
        add:(nodes at:2);
        yourself
!

reduceActionForRepeat__Predicate1:nodes 
    ^OrderedCollection new
!

reduceActionForRepeat__Predicate2:nodes 
    ^(nodes at:1)
        add:(nodes at:2);
        yourself
!

reduceActionForRepeat__PrologDeclarationClassA1:nodes 
    ^OrderedCollection new
!

reduceActionForRepeat__PrologDeclarationClassA2:nodes 
    ^(nodes at:1)
        add:(nodes at:2);
        yourself
!

reduceActionForRepeat__PrologDeclarationClassAList1:nodes 
    ^ OrderedCollection new

    "Created: / 01-12-2008 / 09:40:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

reduceActionForRepeat__PrologDeclarationClassAList2:nodes 
    ^ (nodes at:1)
        add:(nodes at:2);
        yourself

    "Created: / 01-12-2008 / 09:40:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

reduceActionForRepeat__PrologDeclarationClassB1:nodes 
    ^OrderedCollection new
!

reduceActionForRepeat__PrologDeclarationClassB2:nodes 
    ^(nodes at:1)
        add:(nodes at:2);
        yourself
!

reduceActionForReplaceClause1:nodes 
    self informAboutRuleReduction:'ReplaceValueOfClause'.
    ^(AstReplaceValueOfExpr new)
        targetExpr:(nodes at:3);
        sourceExpr:(nodes at:5).
!

reduceActionForReplaceClause2:nodes 
    self informAboutRuleReduction:'ReplaceClause'.
    ^(AstReplaceExpr new)
        targetExpr:(nodes at:1);
        sourceExpr:(nodes at:3).
!

reduceActionForReplaceExpr1:nodes 
    self informAboutRuleReduction:'ReplaceExpr'.
    ^nodes at:3.
!

reduceActionForReplaceTriggerExpr1:nodes 
    self informAboutRuleReduction:'ReplaceTriggerExpr'.
    ^(AstReplaceTriggerExpr new) triggerBodyExpr:(nodes at:2).
!

reduceActionForReverseAxis1:nodes 
    self informAboutRuleReduction:'ReverseAxis1'.
    ^XPathAxisParent new
!

reduceActionForReverseAxis2:nodes 
    self informAboutRuleReduction:'ReverseAxis2'.
    ^XPathAxisAncestor new
!

reduceActionForReverseAxis3:nodes 
    self informAboutRuleReduction:'ReverseAxis3'.
    ^XPathAxisAncestorOrSelf new
!

reduceActionForReverseAxis4:nodes 
    self informAboutRuleReduction:'ReverseAxis4'.
    ^XPathAxisPrecedingSibling new
!

reduceActionForReverseAxis5:nodes 
    self informAboutRuleReduction:'ReverseAxis5'.
    ^XPathAxisPreceding new
!

reduceActionForReverseStep1:nodes 
    self informAboutRuleReduction:'ReverseStep1'.
    ^(XPathLocationStep new)
        axis:(nodes at:1);
        nodeTest:(nodes at:2);
        yourself
!

reduceActionForReverseStep2:nodes 
    self informAboutRuleReduction:'ReverseStep2'.
    ^nodes at:1
!

reduceActionForSequenceType1:nodes 
    self informAboutRuleReduction:'SequenceType1'.
    ^AstSequenceType new withEmptySequence.
!

reduceActionForSequenceType2:nodes 
    self informAboutRuleReduction:'SequenceType2'.
    ^(AstSequenceType new)
        itemType:(nodes at:1);
        occurrenceIndicator:(nodes at:2).
!

reduceActionForSequenceType3:nodes 
    ^ self informAboutRuleReduction:'SequenceType3'

    "Created: / 08-03-2009 / 21:53:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

reduceActionForSetter1:nodes 
    ^nodes at:1
!

reduceActionForSingleType1:nodes 
    self informAboutRuleReduction:'SingleType1'.
    ^AstSingleType new atomicType:(nodes at:1).
!

reduceActionForSingleType2:nodes 
    self informAboutRuleReduction:'SingleType2'.
    ^(AstSingleType new)
        atomicType:(nodes at:1);
        occurenceIndicator:'?'.
!

reduceActionForSourceExpr1:nodes 
    self informAboutRuleReduction:'SourceExpr'.
    ^nodes at:1.
!

reduceActionForStatementNodeExpr1:nodes 
    self informAboutRuleReduction:'StatementNodeExpr1'.
    ^nodes at:1.
!

reduceActionForStatementNodeExpr2:nodes 
    self informAboutRuleReduction:'StatementNodeExpr2'.
    ^nodes at:1.
!

reduceActionForStatementTriggerExpr1:nodes 
    self informAboutRuleReduction:'StatementTriggerExpr'.
    ^(AstStatementTriggerExpr new) triggerNameAndTargetExpr:(nodes at:2).
!

reduceActionForStepExpr1:nodes 
    self informAboutRuleReduction:'StepExpr1'.
    ^nodes at:1.
!

reduceActionForStepExpr2:nodes 
    self informAboutRuleReduction:'StepExpr2'.
    ^nodes at:1.
!

reduceActionForStringLiteral1:nodes 
    self 
        informAboutRuleReduction:'StringLiteral1 -' , ((nodes at:1) asString).
    ^AstStringLiteral new content:((nodes at:1) value).
!

reduceActionForTargetExpr1:nodes 
    self informAboutRuleReduction:'TargetExpr'.
    ^nodes at:1.
!

reduceActionForTextTest1:nodes 
    self informAboutRuleReduction:'TextTest1'.
    ^XPathTextTest new.
!

reduceActionForTransformCopyClause1:nodes 
    self informAboutRuleReduction:'TransformCopyClause1'.
    ^(AstTransformCopyClause new)
        varName:(nodes at:2);
        exprSingle:(nodes at:4).
!

reduceActionForTransformCopyClause2:nodes 
    self informAboutRuleReduction:'TransformCopyClause2'.
    ^(AstTransformCopyClause new)
        varName:(nodes at:2);
        exprSingle:(nodes at:4);
        transformCopyClause:(nodes at:6).
!

reduceActionForTransformExpr1:nodes 
    self informAboutRuleReduction:'TransformExpr'.
    ^(AstTransformExpr new)
        transformCopyClause:(nodes at:3);
        modifyExpr:(nodes at:5);
        returnExpr:(nodes at:7).
!

reduceActionForTriggerBodyExpr1:nodes 
    self informAboutRuleReduction:'TriggerBodyExpr'.
    ^(AstTriggerBodyExpr new) triggerBodyString:(nodes at:2).
!

reduceActionForTriggerDefExpr1:nodes 
    self informAboutRuleReduction:'TriggerDefExpr'.
    ^nodes at:1.
!

reduceActionForTriggerNameAndTargetExpr1:nodes 
    self informAboutRuleReduction:'TriggerNameAndTargetExpr'.
    ^(AstTriggerNameAndTargetExpr new)
        name:(nodes at:2);
        targetExpr:(nodes at:4);
        beforeAfterExpr:(nodes at:5)
!

reduceActionForTypeDeclaration1:nodes 
    self informAboutRuleReduction:'TypeDeclaration1'.
    ^ nodes at:2
!

reduceActionForURILiteral1:nodes 
    ^nodes at:1
!

reduceActionForUnaryExpr1:nodes 
    self informAboutRuleReduction:'UnaryExpr1'.
    ^(AstUnaryExpr new)
        operand:#minus;
        unaryExpr:(nodes at:2).
!

reduceActionForUnaryExpr2:nodes 
    self informAboutRuleReduction:'UnaryExpr2'.
    ^(AstUnaryExpr new)
        operand:#plus;
        unaryExpr:(nodes at:2).
!

reduceActionForUnaryExpr3:nodes 
    self informAboutRuleReduction:'UnaryExpr3'.
    ^nodes at:1.
!

reduceActionForUnionExpr1:nodes 
    self informAboutRuleReduction:'UnionExpr1'.
    ^nodes at:1.
!

reduceActionForUnionExpr2:nodes 
    self informAboutRuleReduction:'UnionExpr2'.
    ^(AstUnionExpr new)
        intersectExceptExpr:(nodes at:1);
        unionExpr:(nodes at:3).
!

reduceActionForUnionExpr3:nodes 
    self informAboutRuleReduction:'UnionExpr3'.
    ^(AstUnionExpr new)
        intersectExceptExpr:(nodes at:1);
        unionExpr:(nodes at:3).
!

reduceActionForUnorderedExpr1:nodes 
    self informAboutRuleReduction:'UnorderedExpr1'.
    ^nodes at:3.
!

reduceActionForValueComp1:nodes 
    self informAboutRuleReduction:'ValueComp1'.
    ^#eqValue.
!

reduceActionForValueComp2:nodes 
    self informAboutRuleReduction:'ValueComp2'.
    ^#neValue.
!

reduceActionForValueComp3:nodes 
    self informAboutRuleReduction:'ValueComp3'.
    ^#ltValue.
!

reduceActionForValueComp4:nodes 
    self informAboutRuleReduction:'ValueComp4'.
    ^#leValue.
!

reduceActionForValueComp5:nodes 
    self informAboutRuleReduction:'ValueComp5'.
    ^#gtValue.
!

reduceActionForValueComp6:nodes 
    self informAboutRuleReduction:'ValueComp6'.
    ^#geValue.
!

reduceActionForValueExpr1:nodes 
    self informAboutRuleReduction:'ValueExpr'.
    ^nodes at:1.
!

reduceActionForVarDecl1:nodes 
    self informAboutRuleReduction:'VarDecl1'.
    ^ (AstVarDecl new)
        name:(nodes at:4);
        expressionIsExternal
!

reduceActionForVarDecl2:nodes 
    self informAboutRuleReduction:'VarDecl2'.
    ^ (AstVarDecl new)
        name:(nodes at:4);
        type:(nodes at:5);
        expressionIsExternal
!

reduceActionForVarDecl3:nodes 
    self informAboutRuleReduction:'VarDecl3'.
    ^ (AstVarDecl new)
        name:(nodes at:4);
        expression:(nodes at:6)
!

reduceActionForVarDecl4:nodes 
    self informAboutRuleReduction:'VarDecl4'.
    ^ (AstVarDecl new)
        name:(nodes at:4);
        type:(nodes at:5);
        expression:(nodes at:7)
!

reduceActionForVarName1:nodes 
    self informAboutRuleReduction:'VarName1'.
    ^nodes at:1.
!

reduceActionForVarRef1:nodes 
    self informAboutRuleReduction:'VarRef1'.
    ^AstVarRef new varName:(nodes at:2).
!

reduceActionForWhereClause1:nodes 
    self informAboutRuleReduction:'WhereClause1'.
    ^AstWhereClause new exprSingle:(nodes at:2).
!

reduceActionForWildcard1:nodes 
    self informAboutRuleReduction:'Wildcard1'.
    ^ AstWildcard new.

    "Modified: / 17-11-2007 / 14:00:00 / janfrog"
!

reduceActionForWildcard2:nodes 
    self informAboutRuleReduction:'Wildcard2'.
    ^ AstWildcard new ncName:(nodes at:3).

    "Modified: / 17-11-2007 / 14:00:00 / janfrog"
! !

!XQueryParser methodsFor:'generated-tables'!

reduceTable
	^#(
#(139 1 #reduceActionForSetter1:)
#(140 5 #reduceActionForNamespaceDecl1:)
#(141 7 #reduceActionForFunctionDecl1:)
#(142 3 #reduceActionForBaseUriDecl1:)
#(143 3 #reduceActionForBaseUriDecl21:)
#(144 1 #reduceActionForStringLiteral1:)
#(145 1 #reduceActionForQName1:)
#(146 1 #reduceActionForParamList1:)
#(146 1 #reduceActionForParamList2:)
#(147 2 #reduceActionForProlog1:)
#(148 3 #reduceActionForOneOrMoreParamList1:)
#(148 1 #reduceActionForOneOrMoreParamList2:)
#(149 0 #reduceActionForEmptyParamList1:)
#(150 2 #reduceActionForParam1:)
#(151 1 #reduceActionForExpr1:)
#(151 3 #reduceActionForExpr2:)
#(152 1 #reduceActionForExprSingle1:)
#(152 1 #reduceActionForExprSingle2:)
#(152 1 #reduceActionForExprSingle3:)
#(152 1 #reduceActionForExprSingle4:)
#(152 1 #reduceActionForExprSingle5:)
#(152 1 #reduceActionForExprSingle6:)
#(152 1 #reduceActionForExprSingle7:)
#(152 1 #reduceActionForExprSingle8:)
#(152 1 #reduceActionForExprSingle9:)
#(152 1 #reduceActionForExprSingle10:)
#(152 1 #reduceActionForExprSingle11:)
#(152 1 #reduceActionForExprSingle12:)
#(152 1 #reduceActionForExprSingle13:)
#(153 3 #reduceActionForFLWORExpr1:)
#(153 4 #reduceActionForFLWORExpr2:)
#(153 4 #reduceActionForFLWORExpr3:)
#(153 5 #reduceActionForFLWORExpr4:)
#(154 4 #reduceActionForQuantifiedExpr1:)
#(154 4 #reduceActionForQuantifiedExpr2:)
#(155 8 #reduceActionForIfExpr1:)
#(156 1 #reduceActionForOrExpr1:)
#(156 3 #reduceActionForOrExpr2:)
#(157 3 #reduceActionForDeleteExpr1:)
#(158 5 #reduceActionForRenameExpr1:)
#(159 3 #reduceActionForReplaceExpr1:)
#(160 3 #reduceActionForInsertExpr1:)
#(161 7 #reduceActionForTransformExpr1:)
#(162 5 #reduceActionForConnectTriggerExpr1:)
#(163 4 #reduceActionForDisconnectTriggerExpr1:)
#(164 3 #reduceActionForDropTriggerExpr1:)
#(165 4 #reduceActionForCreateTriggerExpr1:)
#(166 1 #'reduceActionForFLWORExpr_ForLet1:')
#(166 1 #'reduceActionForFLWORExpr_ForLet2:')
#(166 2 #'reduceActionForFLWORExpr_ForLet3:')
#(166 2 #'reduceActionForFLWORExpr_ForLet4:')
#(167 2 #reduceActionForWhereClause1:)
#(168 3 #reduceActionForOrderByClause1:)
#(168 4 #reduceActionForOrderByClause2:)
#(169 2 #reduceActionForForClause1:)
#(170 2 #reduceActionForLetClause1:)
#(171 4 #'reduceActionForForClause_Impl1:')
#(171 6 #'reduceActionForForClause_Impl2:')
#(171 5 #'reduceActionForForClause_Impl3:')
#(171 7 #'reduceActionForForClause_Impl4:')
#(172 1 #reduceActionForVarName1:)
#(173 3 #reduceActionForPositionalVar1:)
#(174 4 #'reduceActionForLetClause_Impl1:')
#(174 6 #'reduceActionForLetClause_Impl2:')
#(175 1 #reduceActionForOrderSpecList1:)
#(175 3 #reduceActionForOrderSpecList2:)
#(176 1 #reduceActionForOrderSpec1:)
#(176 2 #reduceActionForOrderSpec2:)
#(177 1 #reduceActionForOrderModifier1:)
#(177 1 #reduceActionForOrderModifier2:)
#(177 2 #reduceActionForOrderModifier3:)
#(178 1 #'reduceActionForOrderModifier_AscDesc1:')
#(178 1 #'reduceActionForOrderModifier_AscDesc2:')
#(179 2 #'reduceActionForOrderModifier_GreatestLeast1:')
#(179 2 #'reduceActionForOrderModifier_GreatestLeast2:')
#(180 4 #'reduceActionForQuantifiedExpr_Impl1:')
#(180 6 #'reduceActionForQuantifiedExpr_Impl2:')
#(181 1 #reduceActionForAndExpr1:)
#(181 3 #reduceActionForAndExpr2:)
#(182 1 #reduceActionForComparisonExpr1:)
#(182 3 #reduceActionForComparisonExpr2:)
#(182 3 #reduceActionForComparisonExpr3:)
#(182 3 #reduceActionForComparisonExpr4:)
#(183 1 #reduceActionForRangeExpr1:)
#(183 3 #reduceActionForRangeExpr2:)
#(184 1 #reduceActionForValueComp1:)
#(184 1 #reduceActionForValueComp2:)
#(184 1 #reduceActionForValueComp3:)
#(184 1 #reduceActionForValueComp4:)
#(184 1 #reduceActionForValueComp5:)
#(184 1 #reduceActionForValueComp6:)
#(185 1 #reduceActionForGeneralComp1:)
#(185 1 #reduceActionForGeneralComp2:)
#(185 1 #reduceActionForGeneralComp3:)
#(185 1 #reduceActionForGeneralComp4:)
#(185 1 #reduceActionForGeneralComp5:)
#(185 1 #reduceActionForGeneralComp6:)
#(186 1 #reduceActionForNodeComp1:)
#(186 1 #reduceActionForNodeComp2:)
#(186 1 #reduceActionForNodeComp3:)
#(187 1 #reduceActionForAdditiveExpr1:)
#(187 3 #reduceActionForAdditiveExpr2:)
#(187 3 #reduceActionForAdditiveExpr3:)
#(188 1 #reduceActionForMultiplicativeExpr1:)
#(188 3 #reduceActionForMultiplicativeExpr2:)
#(188 3 #reduceActionForMultiplicativeExpr3:)
#(188 3 #reduceActionForMultiplicativeExpr4:)
#(188 3 #reduceActionForMultiplicativeExpr5:)
#(189 1 #reduceActionForUnionExpr1:)
#(189 3 #reduceActionForUnionExpr2:)
#(189 3 #reduceActionForUnionExpr3:)
#(190 1 #reduceActionForIntersectExceptExpr1:)
#(190 3 #reduceActionForIntersectExceptExpr2:)
#(190 3 #reduceActionForIntersectExceptExpr3:)
#(191 1 #reduceActionForInstanceOfExpr1:)
#(191 4 #reduceActionForInstanceOfExpr2:)
#(192 1 #reduceActionForCastableExpr1:)
#(192 4 #reduceActionForCastableExpr2:)
#(193 3 #reduceActionForSequenceType1:)
#(193 2 #reduceActionForSequenceType2:)
#(194 1 #reduceActionForCastExpr1:)
#(194 4 #reduceActionForCastExpr2:)
#(195 1 #reduceActionForSingleType1:)
#(195 2 #reduceActionForSingleType2:)
#(196 2 #reduceActionForUnaryExpr1:)
#(196 2 #reduceActionForUnaryExpr2:)
#(196 1 #reduceActionForUnaryExpr3:)
#(197 1 #reduceActionForAtomicType1:)
#(198 3 #reduceActionForItemType1:)
#(198 1 #reduceActionForItemType2:)
#(198 1 #reduceActionForItemType3:)
#(199 1 #reduceActionForNCName1:)
#(200 0 #'reduceActionForOptional__OccurrenceIndicator1:')
#(200 1 #'reduceActionForOptional__OccurrenceIndicator2:')
#(201 1 #reduceActionForKindTest1:)
#(201 1 #reduceActionForKindTest2:)
#(201 1 #reduceActionForKindTest3:)
#(201 1 #reduceActionForKindTest4:)
#(201 1 #reduceActionForKindTest5:)
#(201 3 #reduceActionForKindTest6:)
#(201 3 #reduceActionForKindTest7:)
#(202 1 #reduceActionForValueExpr1:)
#(203 2 #reduceActionForPathExpr1:)
#(203 2 #reduceActionForPathExpr2:)
#(203 1 #reduceActionForPathExpr3:)
#(204 1 #reduceActionForRelativePathExpr1:)
#(204 3 #reduceActionForRelativePathExpr2:)
#(204 3 #reduceActionForRelativePathExpr3:)
#(205 1 #reduceActionForStepExpr1:)
#(205 1 #reduceActionForStepExpr2:)
#(206 2 #reduceActionForAxisStep1:)
#(206 2 #reduceActionForAxisStep2:)
#(207 2 #reduceActionForFilterExpr1:)
#(208 2 #reduceActionForForwardStep1:)
#(208 1 #reduceActionForForwardStep2:)
#(209 3 #reduceActionForPredicate1:)
#(209 2 #reduceActionForPredicate2:)
#(210 0 #'reduceActionForRepeat__Predicate1:')
#(210 2 #'reduceActionForRepeat__Predicate2:')
#(211 2 #reduceActionForReverseStep1:)
#(211 1 #reduceActionForReverseStep2:)
#(212 2 #reduceActionForForwardAxis1:)
#(212 2 #reduceActionForForwardAxis2:)
#(212 2 #reduceActionForForwardAxis3:)
#(212 2 #reduceActionForForwardAxis4:)
#(212 2 #reduceActionForForwardAxis5:)
#(212 2 #reduceActionForForwardAxis6:)
#(212 2 #reduceActionForForwardAxis7:)
#(213 1 #reduceActionForNodeTest1:)
#(213 1 #reduceActionForNodeTest2:)
#(214 2 #reduceActionForAbbrevForwardStep1:)
#(214 1 #reduceActionForAbbrevForwardStep2:)
#(215 2 #reduceActionForReverseAxis1:)
#(215 2 #reduceActionForReverseAxis2:)
#(215 2 #reduceActionForReverseAxis3:)
#(215 2 #reduceActionForReverseAxis4:)
#(215 2 #reduceActionForReverseAxis5:)
#(216 1 #reduceActionForAbbrevReverseStep1:)
#(217 1 #reduceActionForNameTest1:)
#(217 1 #reduceActionForNameTest2:)
#(217 3 #reduceActionForNameTest3:)
#(218 1 #reduceActionForPrimaryExpr1:)
#(218 1 #reduceActionForPrimaryExpr2:)
#(218 1 #reduceActionForPrimaryExpr3:)
#(218 1 #reduceActionForPrimaryExpr4:)
#(218 1 #reduceActionForPrimaryExpr5:)
#(218 1 #reduceActionForPrimaryExpr6:)
#(218 1 #reduceActionForPrimaryExpr7:)
#(218 1 #reduceActionForPrimaryExpr8:)
#(219 1 #reduceActionForLiteral1:)
#(219 1 #reduceActionForLiteral2:)
#(220 2 #reduceActionForVarRef1:)
#(221 2 #reduceActionForParenthesizedExpr1:)
#(221 3 #reduceActionForParenthesizedExpr2:)
#(222 1 #reduceActionForContextItemExpr1:)
#(223 3 #reduceActionForFunctionCall1:)
#(223 4 #reduceActionForFunctionCall2:)
#(224 1 #reduceActionForConstructor1:)
#(224 1 #reduceActionForConstructor2:)
#(225 4 #reduceActionForOrderedExpr1:)
#(226 4 #reduceActionForUnorderedExpr1:)
#(227 1 #reduceActionForNumericLiteral1:)
#(227 1 #reduceActionForNumericLiteral2:)
#(227 1 #reduceActionForNumericLiteral3:)
#(228 1 #reduceActionForIntegerLiteral1:)
#(229 1 #reduceActionForDecimalLiteral1:)
#(230 1 #reduceActionForDoubleLiteral1:)
#(231 1 #reduceActionForFunctionParametersList1:)
#(231 3 #reduceActionForFunctionParametersList2:)
#(232 1 #reduceActionForDirectConstructor1:)
#(233 1 #reduceActionForComputedConstructor1:)
#(233 1 #reduceActionForComputedConstructor2:)
#(233 1 #reduceActionForComputedConstructor3:)
#(233 1 #reduceActionForComputedConstructor4:)
#(234 4 #reduceActionForDirElemConstructor1:)
#(234 8 #reduceActionForDirElemConstructor2:)
#(235 1 #reduceActionForDirAttributeList1:)
#(236 1 #reduceActionForDirElemContent1:)
#(236 1 #reduceActionForDirElemContent2:)
#(236 1 #reduceActionForDirElemContent3:)
#(237 0 #'reduceActionForRepeat__DirElemContent1:')
#(237 2 #'reduceActionForRepeat__DirElemContent2:')
#(238 3 #reduceActionForDirAttributeListElem1:)
#(239 0 #'reduceActionForRepeat__DirAttributeListElem1:')
#(239 2 #'reduceActionForRepeat__DirAttributeListElem2:')
#(240 1 #reduceActionForDirAttributeValue1:)
#(240 1 #reduceActionForDirAttributeValue2:)
#(241 1 #reduceActionForCommonContent1:)
#(241 1 #reduceActionForCommonContent2:)
#(241 1 #reduceActionForCommonContent3:)
#(242 1 #reduceActionForElementContentChar1:)
#(243 1 #reduceActionForDirElemContent21:)
#(243 2 #reduceActionForDirElemContent22:)
#(243 1 #reduceActionForDirElemContent23:)
#(243 2 #reduceActionForDirElemContent24:)
#(244 5 #reduceActionForDefaultNamespaceDecl1:)
#(244 5 #reduceActionForDefaultNamespaceDecl2:)
#(245 1 #reduceActionForPredefinedEntityRef1:)
#(246 1 #reduceActionForCharRef1:)
#(247 2 #reduceActionForPrologDeclarationClassB1:)
#(247 2 #reduceActionForPrologDeclarationClassB2:)
#(247 2 #reduceActionForPrologDeclarationClassB3:)
#(247 2 #reduceActionForPrologDeclarationClassB4:)
#(248 1 #reduceActionForCommonContent21:)
#(248 1 #reduceActionForCommonContent22:)
#(248 1 #reduceActionForCommonContent23:)
#(248 1 #reduceActionForCommonContent24:)
#(248 1 #reduceActionForCommonContent25:)
#(249 4 #reduceActionForCompDocConstructor1:)
#(250 4 #reduceActionForCompElemConstructor1:)
#(250 5 #reduceActionForCompElemConstructor2:)
#(250 6 #reduceActionForCompElemConstructor3:)
#(250 7 #reduceActionForCompElemConstructor4:)
#(251 4 #reduceActionForCompAttrConstructor1:)
#(251 5 #reduceActionForCompAttrConstructor2:)
#(251 6 #reduceActionForCompAttrConstructor3:)
#(251 7 #reduceActionForCompAttrConstructor4:)
#(252 4 #reduceActionForCompTextConstructor1:)
#(253 1 #reduceActionForContentExpr1:)
#(254 3 #reduceActionForDocumentTest1:)
#(254 4 #reduceActionForDocumentTest2:)
#(255 3 #reduceActionForElementTest1:)
#(255 4 #reduceActionForElementTest2:)
#(256 3 #reduceActionForAttributeTest1:)
#(256 4 #reduceActionForAttributeTest2:)
#(257 3 #reduceActionForTextTest1:)
#(258 3 #reduceActionForAnyKindTest1:)
#(259 1 #reduceActionForAttribNameOrWildcard1:)
#(259 1 #reduceActionForAttribNameOrWildcard2:)
#(260 1 #reduceActionForAttributeName1:)
#(261 1 #reduceActionForElementNameOrWildcard1:)
#(261 1 #reduceActionForElementNameOrWildcard2:)
#(262 1 #reduceActionForElementName1:)
#(263 0 #'reduceActionForRepeat__PrologDeclarationClassB1:')
#(263 2 #'reduceActionForRepeat__PrologDeclarationClassB2:')
#(264 0 #'reduceActionForRepeat__PrologDeclarationClassA1:')
#(264 2 #'reduceActionForRepeat__PrologDeclarationClassA2:')
#(265 4 #reduceActionForPrologDeclarationClassA1:)
#(265 7 #reduceActionForPrologDeclarationClassA2:)
#(266 1 #reduceActionForURILiteral1:)
#(267 1 #reduceFor:)
#(268 1 #reduceActionForOccurrenceIndicator1:)
#(268 1 #reduceActionForOccurrenceIndicator2:)
#(268 1 #reduceActionForOccurrenceIndicator3:)
#(269 1 #reduceActionForQueryBody1:)
#(270 1 #reduceActionForTargetExpr1:)
#(271 1 #reduceActionForNewNameExpr1:)
#(272 5 #reduceActionForReplaceClause1:)
#(272 3 #reduceActionForReplaceClause2:)
#(273 3 #reduceActionForInsertClause1:)
#(273 5 #reduceActionForInsertClause2:)
#(273 5 #reduceActionForInsertClause3:)
#(273 3 #reduceActionForInsertClause4:)
#(273 3 #reduceActionForInsertClause5:)
#(274 1 #reduceActionForSourceExpr1:)
#(275 4 #reduceActionForTransformCopyClause1:)
#(275 6 #reduceActionForTransformCopyClause2:)
#(276 1 #reduceActionForTriggerDefExpr1:)
#(277 1 #reduceActionForStatementNodeExpr1:)
#(277 1 #reduceActionForStatementNodeExpr2:)
#(278 2 #reduceActionForStatementTriggerExpr1:)
#(279 2 #reduceActionForNodeTriggerExpr1:)
#(280 5 #reduceActionForTriggerNameAndTargetExpr1:)
#(281 1 #reduceActionForBeforeAfterTriggerExpr1:)
#(281 1 #reduceActionForBeforeAfterTriggerExpr2:)
#(282 2 #reduceActionForBeforeTriggerExpr1:)
#(283 2 #reduceActionForAfterTriggerExpr1:)
#(284 1 #reduceActionForEventTriggerExpr1:)
#(284 1 #reduceActionForEventTriggerExpr2:)
#(284 1 #reduceActionForEventTriggerExpr3:)
#(284 1 #reduceActionForEventTriggerExpr4:)
#(285 2 #reduceActionForDeleteTriggerExpr1:)
#(286 2 #reduceActionForRenameTriggerExpr1:)
#(287 2 #reduceActionForReplaceTriggerExpr1:)
#(288 2 #reduceActionForInsertTriggerExpr1:)
#(289 3 #reduceActionForTriggerBodyExpr1:)
#(292 2 #reduceActionForMainModule1:)
#(293 3 #reduceActionForEnclosedExpr1:)
)
!

transitionTable
	^#(
#[1 4 82 0 2 4 82 0 7 4 82 0 8 4 82 0 10 4 82 0 17 4 82 0 31 4 82 0 36 4 82 0 37 4 82 0 39 4 82 0 42 4 82 0 45 4 82 0 47 4 82 0 53 4 82 0 60 4 82 0 71 4 82 0 72 4 82 0 73 4 82 0 75 4 82 0 76 4 82 0 77 4 82 0 78 4 82 0 81 4 82 0 83 4 82 0 85 4 82 0 88 4 82 0 91 4 82 0 98 4 82 0 99 4 82 0 100 4 82 0 101 4 82 0 102 4 82 0 103 4 82 0 104 4 82 0 111 4 82 0 112 4 82 0 115 4 82 0 116 4 82 0 119 4 82 0 121 4 82 0 122 4 82 0 123 4 82 0 124 4 82 0 125 4 82 0 126 4 82 0 127 4 82 0 132 4 82 0 133 4 82 0 134 4 82 0 135 4 82 0 137 0 13 0 147 0 17 1 8 0 21 1 36]
#[1 4 82 0 2 4 82 0 7 4 82 0 8 4 82 0 10 4 82 0 17 4 82 0 31 4 82 0 36 4 82 0 37 4 82 0 39 4 82 0 42 4 82 0 45 4 82 0 47 4 82 0 53 4 82 0 60 4 82 0 71 4 82 0 72 4 82 0 73 4 82 0 75 4 82 0 76 4 82 0 77 4 82 0 78 4 82 0 81 4 82 0 83 4 82 0 85 4 82 0 88 4 82 0 91 4 82 0 98 4 82 0 99 4 82 0 100 4 82 0 101 4 82 0 102 4 82 0 103 4 82 0 104 4 82 0 111 4 82 0 112 4 82 0 115 4 82 0 116 4 82 0 119 4 82 0 121 4 82 0 122 4 82 0 123 4 82 0 124 4 82 0 125 4 82 0 126 4 82 0 127 4 82 0 132 4 82 0 133 4 82 0 134 4 82 0 135 4 82 0 137 0 13 0 147 0 17 1 8 0 25 1 36]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 0 229 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 1 249 1 13]
#[1 4 74 0 2 4 74 0 7 4 74 0 8 4 74 0 10 4 74 0 17 4 74 0 31 4 74 0 36 4 74 0 37 4 74 0 39 1 253 0 42 4 74 0 45 4 74 0 47 4 74 0 53 4 74 0 60 4 74 0 71 4 74 0 72 4 74 0 73 4 74 0 75 4 74 0 76 4 74 0 77 4 74 0 78 4 74 0 81 4 74 0 83 4 74 0 85 4 74 0 88 4 74 0 91 4 74 0 98 4 74 0 99 4 74 0 100 4 74 0 101 4 74 0 102 4 74 0 103 4 74 0 104 4 74 0 111 4 74 0 112 4 74 0 115 4 74 0 116 4 74 0 119 4 74 0 121 4 74 0 122 4 74 0 123 4 74 0 124 4 74 0 125 4 74 0 126 4 74 0 127 4 74 0 132 4 74 0 133 4 74 0 134 4 74 0 135 4 74 0 137 2 1 1 7 2 5 1 9]
#[0 0 0 1 34]
#[0 0 0 1 34]
#[1 2 210 0 1 2 210 0 2 2 210 0 3 2 210 0 4 2 210 0 5 2 210 0 6 2 210 0 7 2 210 0 8 2 210 0 11 2 210 0 12 2 210 0 13 2 210 0 14 2 210 0 15 2 210 0 16 2 210 0 17 2 210 0 18 2 210 0 19 2 210 0 20 2 210 0 21 2 210 0 22 2 210 0 26 2 210 0 27 2 210 0 28 2 210 0 30 2 210 0 32 2 210 0 35 2 210 0 38 2 210 0 46 2 210 0 47 2 210 0 48 2 210 0 49 2 210 0 50 2 210 0 52 2 210 0 55 2 210 0 60 2 210 0 61 2 210 0 62 2 210 0 63 2 210 0 70 2 210 0 80 2 210 0 82 2 210 0 89 2 210 0 92 2 210 0 93 2 210 0 95 2 210 0 103 2 210 0 104 2 210 0 105 2 210 0 106 2 210 0 107 2 210 0 108 2 210 0 109 2 210 0 110 2 210 0 113 2 210 0 114 2 210 0 117 2 9 0 120 2 210 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 2 13 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 2 17 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 2 21 0 36]
#[1 0 201 0 132 2 25 0 145]
#[1 2 29 0 37 2 33 0 180]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 2 37 0 35 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 2 41 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 201 0 132 2 45 0 145 2 49 0 172]
#[1 2 53 0 36 2 57 0 118 0 201 0 132 2 61 0 145]
#[1 2 65 0 37 2 69 0 171]
#[1 2 29 0 37 2 73 0 180]
#[1 2 77 0 37 2 81 0 174]
#[1 2 85 0 65 2 89 0 66 2 93 0 68 2 97 0 69]
#[0 2 101 0 36]
#[0 2 105 0 118]
#[0 2 109 0 36]
#[1 2 113 0 36 2 117 0 118]
#[0 2 121 0 36]
#[0 2 125 0 36]
#[0 2 129 0 87]
#[0 2 133 0 86]
#[0 2 137 0 11]
#[0 2 141 0 87]
#[0 2 145 0 94]
#[0 2 149 0 97]
#[1 2 153 0 36 2 157 0 97 2 161 0 118 0 201 0 132 2 165 0 145]
#[0 2 169 0 97]
#[0 2 173 0 97]
#[0 2 177 0 97]
#[1 0 29 0 2 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 1 89 0 201 2 181 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 1 89 0 201 2 185 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 2 189 0 97]
#[0 2 193 0 118]
#[0 2 197 0 118]
#[0 3 14 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 201 0 97]
#[0 2 205 0 97]
#[1 0 29 0 2 2 209 0 39 0 81 0 72 0 89 0 75 2 213 0 76 0 97 0 77 0 101 0 78 2 217 0 99 0 201 0 132 2 221 0 145 1 89 0 201 2 225 0 213 1 145 0 217 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 2 229 0 97]
#[0 2 202 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 233 0 97]
#[0 2 237 0 97]
#[0 2 241 0 97]
#[0 0 30 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 36 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 96 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 0 118 0 132 1 34]
#[0 3 54 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 58 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 62 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 0 26 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 44 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 96 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 0 132 1 34]
#[0 2 254 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 2 206 0 1 2 206 0 2 2 206 0 3 2 206 0 4 2 206 0 5 2 206 0 6 2 206 0 7 2 206 0 8 2 206 0 11 2 206 0 12 2 206 0 13 2 206 0 14 2 206 0 15 2 206 0 16 2 206 0 17 2 206 0 18 2 206 0 19 2 206 0 20 2 206 0 21 2 206 0 22 2 206 0 26 2 206 0 27 2 206 0 28 2 206 0 30 2 206 0 32 2 206 0 35 2 245 0 36 2 206 0 38 2 206 0 46 2 206 0 47 2 206 0 48 2 206 0 49 2 206 0 50 2 206 0 52 2 206 0 55 2 206 0 60 2 206 0 61 2 206 0 62 2 206 0 63 2 206 0 70 2 206 0 80 2 206 0 82 2 206 0 89 2 206 0 92 2 206 0 93 2 206 0 95 2 206 0 103 2 206 0 104 2 206 0 105 2 206 0 106 2 206 0 107 2 206 0 108 2 206 0 109 2 206 0 110 2 206 0 113 2 206 0 114 2 206 0 117 2 206 1 34]
#[0 4 118 1 34]
#[1 0 62 0 35 2 249 0 38 0 62 0 113 0 62 0 117 0 62 1 34]
#[0 0 70 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 74 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 78 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 82 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 86 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 90 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 94 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 98 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 102 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 106 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 110 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 114 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 118 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 2 253 0 48 3 1 0 55 3 5 0 61 3 9 0 62 3 13 0 167 3 17 0 168]
#[1 0 65 0 47 0 194 0 48 0 194 0 55 0 73 0 60 0 194 0 61 0 194 0 62 3 21 0 166 1 37 0 169 1 41 0 170]
#[1 0 65 0 47 0 198 0 48 0 198 0 55 0 73 0 60 0 198 0 61 0 198 0 62 3 25 0 166 1 37 0 169 1 41 0 170]
#[1 3 29 0 11 0 150 0 12 0 150 0 27 0 150 0 32 0 150 0 35 0 150 0 38 0 150 0 47 0 150 0 48 0 150 0 49 0 150 0 50 0 150 0 52 0 150 0 55 0 150 0 60 0 150 0 61 0 150 0 62 0 150 0 70 0 150 0 80 0 150 0 82 0 150 0 89 0 150 0 92 0 150 0 93 0 150 0 113 0 150 0 117 0 150 1 34]
#[1 1 58 0 11 1 58 0 12 3 33 0 14 1 58 0 27 1 58 0 32 1 58 0 35 1 58 0 38 1 58 0 47 1 58 0 48 1 58 0 49 1 58 0 50 1 58 0 52 1 58 0 55 1 58 0 60 1 58 0 61 1 58 0 62 1 58 0 70 1 58 0 80 1 58 0 82 1 58 0 89 1 58 0 92 1 58 0 93 1 58 0 113 1 58 0 117 1 58 1 34]
#[1 1 66 0 11 1 66 0 12 1 66 0 14 3 37 0 17 3 41 0 18 3 45 0 19 3 49 0 20 3 53 0 21 3 57 0 22 1 66 0 27 1 66 0 32 1 66 0 35 1 66 0 38 3 61 0 46 1 66 0 47 1 66 0 48 1 66 0 49 1 66 0 50 1 66 0 52 1 66 0 55 1 66 0 60 1 66 0 61 1 66 0 62 3 65 0 63 1 66 0 70 1 66 0 80 1 66 0 82 1 66 0 89 1 66 0 92 1 66 0 93 3 69 0 95 3 73 0 105 3 77 0 106 3 81 0 107 3 85 0 108 3 89 0 109 3 93 0 110 1 66 0 113 1 66 0 117 3 97 0 184 3 101 0 185 3 105 0 186 1 66 1 34]
#[1 1 82 0 11 1 82 0 12 3 109 0 13 1 82 0 14 1 82 0 17 1 82 0 18 1 82 0 19 1 82 0 20 1 82 0 21 1 82 0 22 1 82 0 27 1 82 0 32 1 82 0 35 1 82 0 38 1 82 0 46 1 82 0 47 1 82 0 48 1 82 0 49 1 82 0 50 1 82 0 52 1 82 0 55 1 82 0 60 1 82 0 61 1 82 0 62 1 82 0 63 1 82 0 70 1 82 0 80 1 82 0 82 1 82 0 89 1 82 0 92 1 82 0 93 1 82 0 95 1 82 0 105 1 82 0 106 1 82 0 107 1 82 0 108 1 82 0 109 1 82 0 110 1 82 0 113 1 82 0 117 1 82 1 34]
#[1 3 113 0 7 3 117 0 8 1 150 0 11 1 150 0 12 1 150 0 13 1 150 0 14 1 150 0 17 1 150 0 18 1 150 0 19 1 150 0 20 1 150 0 21 1 150 0 22 1 150 0 27 1 150 0 32 1 150 0 35 1 150 0 38 1 150 0 46 1 150 0 47 1 150 0 48 1 150 0 49 1 150 0 50 1 150 0 52 1 150 0 55 1 150 0 60 1 150 0 61 1 150 0 62 1 150 0 63 1 150 0 70 1 150 0 80 1 150 0 82 1 150 0 89 1 150 0 92 1 150 0 93 1 150 0 95 1 150 0 105 1 150 0 106 1 150 0 107 1 150 0 108 1 150 0 109 1 150 0 110 1 150 0 113 1 150 0 117 1 150 1 34]
#[1 3 121 0 1 3 125 0 2 3 129 0 3 3 133 0 4 1 162 0 7 1 162 0 8 1 162 0 11 1 162 0 12 1 162 0 13 1 162 0 14 1 162 0 17 1 162 0 18 1 162 0 19 1 162 0 20 1 162 0 21 1 162 0 22 1 162 0 27 1 162 0 32 1 162 0 35 1 162 0 38 1 162 0 46 1 162 0 47 1 162 0 48 1 162 0 49 1 162 0 50 1 162 0 52 1 162 0 55 1 162 0 60 1 162 0 61 1 162 0 62 1 162 0 63 1 162 0 70 1 162 0 80 1 162 0 82 1 162 0 89 1 162 0 92 1 162 0 93 1 162 0 95 1 162 0 105 1 162 0 106 1 162 0 107 1 162 0 108 1 162 0 109 1 162 0 110 1 162 0 113 1 162 0 117 1 162 1 34]
#[1 1 182 0 1 1 182 0 2 1 182 0 3 1 182 0 4 3 137 0 5 3 141 0 6 1 182 0 7 1 182 0 8 1 182 0 11 1 182 0 12 1 182 0 13 1 182 0 14 1 182 0 17 1 182 0 18 1 182 0 19 1 182 0 20 1 182 0 21 1 182 0 22 1 182 0 27 1 182 0 32 1 182 0 35 1 182 0 38 1 182 0 46 1 182 0 47 1 182 0 48 1 182 0 49 1 182 0 50 1 182 0 52 1 182 0 55 1 182 0 60 1 182 0 61 1 182 0 62 1 182 0 63 1 182 0 70 1 182 0 80 1 182 0 82 1 182 0 89 1 182 0 92 1 182 0 93 1 182 0 95 1 182 0 105 1 182 0 106 1 182 0 107 1 182 0 108 1 182 0 109 1 182 0 110 1 182 0 113 1 182 0 117 1 182 1 34]
#[1 1 194 0 1 1 194 0 2 1 194 0 3 1 194 0 4 1 194 0 5 1 194 0 6 1 194 0 7 1 194 0 8 1 194 0 11 1 194 0 12 1 194 0 13 1 194 0 14 3 145 0 15 3 149 0 16 1 194 0 17 1 194 0 18 1 194 0 19 1 194 0 20 1 194 0 21 1 194 0 22 1 194 0 27 1 194 0 32 1 194 0 35 1 194 0 38 1 194 0 46 1 194 0 47 1 194 0 48 1 194 0 49 1 194 0 50 1 194 0 52 1 194 0 55 1 194 0 60 1 194 0 61 1 194 0 62 1 194 0 63 1 194 0 70 1 194 0 80 1 194 0 82 1 194 0 89 1 194 0 92 1 194 0 93 1 194 0 95 1 194 0 105 1 194 0 106 1 194 0 107 1 194 0 108 1 194 0 109 1 194 0 110 1 194 0 113 1 194 0 117 1 194 1 34]
#[1 1 206 0 1 1 206 0 2 1 206 0 3 1 206 0 4 1 206 0 5 1 206 0 6 1 206 0 7 1 206 0 8 1 206 0 11 1 206 0 12 1 206 0 13 1 206 0 14 1 206 0 15 1 206 0 16 1 206 0 17 1 206 0 18 1 206 0 19 1 206 0 20 1 206 0 21 1 206 0 22 3 153 0 26 1 206 0 27 1 206 0 32 1 206 0 35 1 206 0 38 1 206 0 46 1 206 0 47 1 206 0 48 1 206 0 49 1 206 0 50 1 206 0 52 1 206 0 55 1 206 0 60 1 206 0 61 1 206 0 62 1 206 0 63 1 206 0 70 1 206 0 80 1 206 0 82 1 206 0 89 1 206 0 92 1 206 0 93 1 206 0 95 1 206 0 105 1 206 0 106 1 206 0 107 1 206 0 108 1 206 0 109 1 206 0 110 1 206 0 113 1 206 0 117 1 206 1 34]
#[1 1 214 0 1 1 214 0 2 1 214 0 3 1 214 0 4 1 214 0 5 1 214 0 6 1 214 0 7 1 214 0 8 1 214 0 11 1 214 0 12 1 214 0 13 1 214 0 14 1 214 0 15 1 214 0 16 1 214 0 17 1 214 0 18 1 214 0 19 1 214 0 20 1 214 0 21 1 214 0 22 1 214 0 26 1 214 0 27 3 157 0 28 1 214 0 32 1 214 0 35 1 214 0 38 1 214 0 46 1 214 0 47 1 214 0 48 1 214 0 49 1 214 0 50 1 214 0 52 1 214 0 55 1 214 0 60 1 214 0 61 1 214 0 62 1 214 0 63 1 214 0 70 1 214 0 80 1 214 0 82 1 214 0 89 1 214 0 92 1 214 0 93 1 214 0 95 1 214 0 105 1 214 0 106 1 214 0 107 1 214 0 108 1 214 0 109 1 214 0 110 1 214 0 113 1 214 0 117 1 214 1 34]
#[1 1 230 0 1 1 230 0 2 1 230 0 3 1 230 0 4 1 230 0 5 1 230 0 6 1 230 0 7 1 230 0 8 1 230 0 11 1 230 0 12 1 230 0 13 1 230 0 14 1 230 0 15 1 230 0 16 1 230 0 17 1 230 0 18 1 230 0 19 1 230 0 20 1 230 0 21 1 230 0 22 1 230 0 26 1 230 0 27 1 230 0 28 3 161 0 30 1 230 0 32 1 230 0 35 1 230 0 38 1 230 0 46 1 230 0 47 1 230 0 48 1 230 0 49 1 230 0 50 1 230 0 52 1 230 0 55 1 230 0 60 1 230 0 61 1 230 0 62 1 230 0 63 1 230 0 70 1 230 0 80 1 230 0 82 1 230 0 89 1 230 0 92 1 230 0 93 1 230 0 95 1 230 0 105 1 230 0 106 1 230 0 107 1 230 0 108 1 230 0 109 1 230 0 110 1 230 0 113 1 230 0 117 1 230 1 34]
#[0 2 170 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 1 254 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 2 58 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[1 2 70 0 1 2 70 0 2 2 70 0 3 2 70 0 4 2 70 0 5 2 70 0 6 2 70 0 7 2 70 0 8 2 70 0 11 2 70 0 12 2 70 0 13 2 70 0 14 2 70 0 15 2 70 0 16 2 70 0 17 2 70 0 18 2 70 0 19 2 70 0 20 2 70 0 21 2 70 0 22 2 70 0 26 2 70 0 27 2 70 0 28 2 70 0 30 2 70 0 32 2 70 0 35 2 70 0 38 2 70 0 46 2 70 0 47 2 70 0 48 2 70 0 49 2 70 0 50 2 70 0 52 2 70 0 55 2 70 0 60 2 70 0 61 2 70 0 62 2 70 0 63 2 70 0 70 2 70 0 80 2 70 0 82 2 70 0 89 2 70 0 92 2 70 0 93 2 70 0 95 3 165 0 103 3 169 0 104 2 70 0 105 2 70 0 106 2 70 0 107 2 70 0 108 2 70 0 109 2 70 0 110 2 70 0 113 2 70 0 117 2 70 1 34]
#[0 2 74 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 2 86 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 2 90 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[1 2 122 0 1 2 122 0 2 2 122 0 3 2 122 0 4 2 122 0 5 2 122 0 6 2 122 0 7 2 122 0 8 2 122 0 11 2 122 0 12 2 122 0 13 2 122 0 14 2 122 0 15 2 122 0 16 2 122 0 17 2 122 0 18 2 122 0 19 2 122 0 20 2 122 0 21 2 122 0 22 2 122 0 26 2 122 0 27 2 122 0 28 2 122 0 30 2 122 0 32 2 122 0 35 2 122 0 38 2 122 0 46 2 122 0 47 2 122 0 48 2 122 0 49 2 122 0 50 2 122 0 52 2 122 0 55 2 122 0 60 2 122 0 61 2 122 0 62 2 122 0 63 2 122 0 70 2 122 0 80 2 122 0 82 2 122 0 89 2 122 0 92 2 122 0 93 2 122 0 95 2 122 0 103 2 122 0 104 2 122 0 105 2 122 0 106 2 122 0 107 2 122 0 108 2 122 0 109 2 122 0 110 2 122 0 113 2 122 0 114 2 122 0 117 3 173 0 210 2 122 1 34]
#[1 2 122 0 1 2 122 0 2 2 122 0 3 2 122 0 4 2 122 0 5 2 122 0 6 2 122 0 7 2 122 0 8 2 122 0 11 2 122 0 12 2 122 0 13 2 122 0 14 2 122 0 15 2 122 0 16 2 122 0 17 2 122 0 18 2 122 0 19 2 122 0 20 2 122 0 21 2 122 0 22 2 122 0 26 2 122 0 27 2 122 0 28 2 122 0 30 2 122 0 32 2 122 0 35 2 122 0 38 2 122 0 46 2 122 0 47 2 122 0 48 2 122 0 49 2 122 0 50 2 122 0 52 2 122 0 55 2 122 0 60 2 122 0 61 2 122 0 62 2 122 0 63 2 122 0 70 2 122 0 80 2 122 0 82 2 122 0 89 2 122 0 92 2 122 0 93 2 122 0 95 2 122 0 103 2 122 0 104 2 122 0 105 2 122 0 106 2 122 0 107 2 122 0 108 2 122 0 109 2 122 0 110 2 122 0 113 2 122 0 114 2 122 0 117 3 177 0 210 2 122 1 34]
#[1 0 29 0 2 2 209 0 39 0 81 0 72 0 89 0 75 2 213 0 76 0 97 0 77 0 101 0 78 2 217 0 99 0 201 0 132 2 221 0 145 1 89 0 201 3 181 0 213 1 145 0 217 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 2 178 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 110 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 0 29 0 2 2 209 0 39 0 81 0 72 0 89 0 75 2 213 0 76 0 97 0 77 0 101 0 78 2 217 0 99 0 201 0 132 2 221 0 145 1 89 0 201 3 185 0 213 1 145 0 217 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 2 134 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 166 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 2 122 0 1 2 122 0 2 2 122 0 3 2 122 0 4 2 122 0 5 2 122 0 6 2 122 0 7 2 122 0 8 2 122 0 11 2 122 0 12 2 122 0 13 2 122 0 14 2 122 0 15 2 122 0 16 2 122 0 17 2 122 0 18 2 122 0 19 2 122 0 20 2 122 0 21 2 122 0 22 2 122 0 26 2 122 0 27 2 122 0 28 2 122 0 30 2 122 0 32 2 122 0 35 2 122 0 38 2 122 0 46 2 122 0 47 2 122 0 48 2 122 0 49 2 122 0 50 2 122 0 52 2 122 0 55 2 122 0 60 2 122 0 61 2 122 0 62 2 122 0 63 2 122 0 70 2 122 0 80 2 122 0 82 2 122 0 89 2 122 0 92 2 122 0 93 2 122 0 95 2 122 0 103 2 122 0 104 2 122 0 105 2 122 0 106 2 122 0 107 2 122 0 108 2 122 0 109 2 122 0 110 2 122 0 113 2 122 0 114 2 122 0 117 3 189 0 210 2 122 1 34]
#[0 2 218 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 222 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 226 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 230 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 234 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 238 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 242 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 246 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 250 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 42 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 46 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 50 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 26 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 30 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 74 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 74 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 0 118 0 130 0 136 0 138 1 34]
#[0 3 78 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 82 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 86 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 90 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 30 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 34 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 38 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 42 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 46 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 4 246 1 34]
#[0 3 193 0 41]
#[1 0 42 0 2 0 42 0 7 0 42 0 8 0 42 0 10 0 42 0 17 0 42 0 31 0 42 0 36 0 42 0 37 0 42 0 39 3 197 0 45 0 42 0 47 0 42 0 53 0 42 0 60 0 42 0 71 0 42 0 72 0 42 0 73 0 42 0 75 0 42 0 76 0 42 0 77 0 42 0 78 0 42 0 81 0 42 0 83 0 42 0 85 0 42 0 88 0 42 0 91 0 42 0 98 0 42 0 99 0 42 0 100 0 42 0 101 0 42 0 102 0 42 0 103 0 42 0 104 0 42 0 111 0 42 0 112 0 42 0 115 0 42 0 116 0 42 0 119 0 42 0 121 0 42 0 122 0 42 0 123 0 42 0 124 0 42 0 125 0 42 0 126 0 42 0 127 0 42 0 132 0 42 0 133 0 42 0 134 0 42 0 135 0 42 0 137 3 201 0 139 3 205 0 140 3 209 0 141 3 213 0 142 3 217 0 244 3 221 0 247]
#[0 4 86 0 2 0 7 0 8 0 10 0 17 0 31 0 36 0 37 0 39 0 42 0 45 0 47 0 53 0 60 0 71 0 72 0 73 0 75 0 76 0 77 0 78 0 81 0 83 0 85 0 88 0 91 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[1 3 225 0 131 3 229 0 199]
#[0 1 246 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 250 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 3 233 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 3 130 0 19 3 130 0 96 3 130 0 132 3 237 0 235 3 241 0 239]
#[1 0 201 0 132 2 45 0 145 3 245 0 172]
#[0 3 249 0 32]
#[0 3 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 253 0 35]
#[0 0 246 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 2 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 4 1 0 2 4 5 0 35 0 201 0 132 4 9 0 145 4 13 1 5 4 17 1 6]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 21 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 4 25 0 118]
#[1 0 201 0 132 2 45 0 145 4 29 0 172]
#[0 0 222 0 47 0 48 0 55 0 60 0 61 0 62]
#[0 4 33 0 32]
#[1 0 201 0 132 2 45 0 145 4 37 0 172]
#[0 0 226 0 47 0 48 0 55 0 60 0 61 0 62]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 4 45 1 14]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 4 49 1 14]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 4 53 0 67 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 4 57 1 14 4 61 1 16]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 65 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 4 69 1 17 4 73 1 18]
#[1 4 77 0 35 2 209 0 39 4 81 0 255]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 85 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 4 89 0 35]
#[0 4 93 0 35]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 97 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 4 101 0 35]
#[0 4 105 0 35]
#[0 4 109 0 84]
#[1 0 217 0 137 4 113 0 144]
#[0 4 117 0 68]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 121 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 4 125 1 20]
#[1 4 129 0 37 4 133 1 19]
#[0 2 138 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[1 4 137 0 2 4 141 0 35 0 201 0 132 4 145 0 145 4 149 1 3 4 153 1 4]
#[0 2 146 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 157 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 4 161 0 118]
#[0 2 142 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[0 2 154 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[0 2 150 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[1 2 66 0 1 2 66 0 2 2 66 0 3 2 66 0 4 2 66 0 5 2 66 0 6 2 66 0 7 2 66 0 8 2 66 0 11 2 66 0 12 2 66 0 13 2 66 0 14 2 66 0 15 2 66 0 16 2 66 0 17 2 66 0 18 2 66 0 19 2 66 0 20 2 66 0 21 2 66 0 22 2 66 0 26 2 66 0 27 2 66 0 28 2 66 0 30 2 66 0 32 2 66 0 35 2 66 0 38 2 66 0 46 2 66 0 47 2 66 0 48 2 66 0 49 2 66 0 50 2 66 0 52 2 66 0 55 2 66 0 60 2 66 0 61 2 66 0 62 2 66 0 63 2 66 0 70 2 66 0 80 2 66 0 82 2 66 0 89 2 66 0 92 2 66 0 93 2 66 0 95 3 165 0 103 3 169 0 104 2 66 0 105 2 66 0 106 2 66 0 107 2 66 0 108 2 66 0 109 2 66 0 110 2 66 0 113 2 66 0 117 2 66 1 34]
#[1 2 62 0 1 2 62 0 2 2 62 0 3 2 62 0 4 2 62 0 5 2 62 0 6 2 62 0 7 2 62 0 8 2 62 0 11 2 62 0 12 2 62 0 13 2 62 0 14 2 62 0 15 2 62 0 16 2 62 0 17 2 62 0 18 2 62 0 19 2 62 0 20 2 62 0 21 2 62 0 22 2 62 0 26 2 62 0 27 2 62 0 28 2 62 0 30 2 62 0 32 2 62 0 35 2 62 0 38 2 62 0 46 2 62 0 47 2 62 0 48 2 62 0 49 2 62 0 50 2 62 0 52 2 62 0 55 2 62 0 60 2 62 0 61 2 62 0 62 2 62 0 63 2 62 0 70 2 62 0 80 2 62 0 82 2 62 0 89 2 62 0 92 2 62 0 93 2 62 0 95 3 165 0 103 3 169 0 104 2 62 0 105 2 62 0 106 2 62 0 107 2 62 0 108 2 62 0 109 2 62 0 110 2 62 0 113 2 62 0 117 2 62 1 34]
#[0 2 158 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 165 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 169 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 2 162 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[0 2 182 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[0 2 53 0 36]
#[0 2 113 0 36]
#[0 2 153 0 36]
#[0 2 206 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 174 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 186 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[0 2 190 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[0 2 198 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[0 2 194 0 2 0 39 0 72 0 75 0 76 0 77 0 78 0 99 0 132]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 4 173 0 35 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 177 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 4 181 0 231 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 185 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 189 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 4 193 0 61]
#[0 4 197 0 56]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 201 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 4 205 0 48 3 1 0 55 3 5 0 61 4 209 0 168]
#[0 4 213 0 48]
#[0 0 202 0 48 0 55 0 61 0 62]
#[0 0 206 0 48 0 55 0 61 0 62]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 217 0 156 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 221 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 1 122 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 118 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 130 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 126 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 90 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 134 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 114 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 94 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 98 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 106 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 102 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 138 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 110 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 146 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 1 142 0 2 0 7 0 8 0 17 0 36 0 37 0 39 0 72 0 73 0 75 0 76 0 77 0 78 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 225 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 229 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 233 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 237 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 241 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 245 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 249 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 253 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 1 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 5 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 9 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 13 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 17 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 21 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 5 25 0 25]
#[0 5 29 0 27]
#[0 5 33 0 27]
#[1 0 29 0 2 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 1 89 0 201 5 37 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 45 0 17 0 53 0 36 0 57 0 37 0 61 0 39 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 1 89 0 201 5 41 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 2 94 0 1 2 94 0 2 2 94 0 3 2 94 0 4 2 94 0 5 2 94 0 6 2 94 0 7 2 94 0 8 2 94 0 11 2 94 0 12 2 94 0 13 2 94 0 14 2 94 0 15 2 94 0 16 2 94 0 17 2 94 0 18 2 94 0 19 2 94 0 20 2 94 0 21 2 94 0 22 2 94 0 26 2 94 0 27 2 94 0 28 2 94 0 30 2 94 0 32 2 94 0 35 2 94 0 38 2 94 0 46 2 94 0 47 2 94 0 48 2 94 0 49 2 94 0 50 2 94 0 52 2 94 0 55 2 94 0 60 2 94 0 61 2 94 0 62 2 94 0 63 2 94 0 70 2 94 0 80 2 94 0 82 2 94 0 89 2 94 0 92 2 94 0 93 2 94 0 95 2 94 0 103 2 94 0 104 2 94 0 105 2 94 0 106 2 94 0 107 2 94 0 108 2 94 0 109 2 94 0 110 2 94 0 113 5 45 0 114 2 94 0 117 5 49 0 209 2 94 1 34]
#[1 2 98 0 1 2 98 0 2 2 98 0 3 2 98 0 4 2 98 0 5 2 98 0 6 2 98 0 7 2 98 0 8 2 98 0 11 2 98 0 12 2 98 0 13 2 98 0 14 2 98 0 15 2 98 0 16 2 98 0 17 2 98 0 18 2 98 0 19 2 98 0 20 2 98 0 21 2 98 0 22 2 98 0 26 2 98 0 27 2 98 0 28 2 98 0 30 2 98 0 32 2 98 0 35 2 98 0 38 2 98 0 46 2 98 0 47 2 98 0 48 2 98 0 49 2 98 0 50 2 98 0 52 2 98 0 55 2 98 0 60 2 98 0 61 2 98 0 62 2 98 0 63 2 98 0 70 2 98 0 80 2 98 0 82 2 98 0 89 2 98 0 92 2 98 0 93 2 98 0 95 2 98 0 103 2 98 0 104 2 98 0 105 2 98 0 106 2 98 0 107 2 98 0 108 2 98 0 109 2 98 0 110 2 98 0 113 5 45 0 114 2 98 0 117 5 49 0 209 2 98 1 34]
#[0 2 106 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 130 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 2 102 0 1 2 102 0 2 2 102 0 3 2 102 0 4 2 102 0 5 2 102 0 6 2 102 0 7 2 102 0 8 2 102 0 11 2 102 0 12 2 102 0 13 2 102 0 14 2 102 0 15 2 102 0 16 2 102 0 17 2 102 0 18 2 102 0 19 2 102 0 20 2 102 0 21 2 102 0 22 2 102 0 26 2 102 0 27 2 102 0 28 2 102 0 30 2 102 0 32 2 102 0 35 2 102 0 38 2 102 0 46 2 102 0 47 2 102 0 48 2 102 0 49 2 102 0 50 2 102 0 52 2 102 0 55 2 102 0 60 2 102 0 61 2 102 0 62 2 102 0 63 2 102 0 70 2 102 0 80 2 102 0 82 2 102 0 89 2 102 0 92 2 102 0 93 2 102 0 95 2 102 0 103 2 102 0 104 2 102 0 105 2 102 0 106 2 102 0 107 2 102 0 108 2 102 0 109 2 102 0 110 2 102 0 113 5 45 0 114 2 102 0 117 5 49 0 209 2 102 1 34]
#[1 5 53 0 43 0 217 0 137 5 57 0 144 5 61 1 10]
#[1 5 65 0 33 5 69 0 34 5 73 0 40 5 77 0 43]
#[0 5 81 0 44]
#[0 5 85 0 44]
#[0 5 89 0 44]
#[0 0 6 0 44]
#[0 5 93 0 44]
#[0 4 78 0 2 0 7 0 8 0 10 0 17 0 31 0 36 0 37 0 39 0 45 0 47 0 53 0 60 0 71 0 72 0 73 0 75 0 76 0 77 0 78 0 81 0 83 0 85 0 88 0 91 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 2 18 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 214 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 5 97 0 35]
#[1 5 101 0 19 5 105 0 96]
#[1 3 102 0 19 3 102 0 96 0 201 0 132 5 109 0 145 5 113 0 238]
#[0 5 117 0 58]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 121 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 3 10 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 4 66 0 35]
#[0 4 26 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 4 70 0 35]
#[0 5 125 0 35]
#[0 4 62 0 35]
#[0 5 129 0 117]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 5 133 0 117 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 137 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 5 141 0 253 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 5 145 0 57 5 149 0 58 5 153 0 173]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 157 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 5 161 0 59]
#[0 4 122 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 5 165 0 27]
#[0 0 158 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 5 169 0 25]
#[0 5 173 0 70]
#[0 0 166 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 158 0 27 0 80 0 89 0 92]
#[0 0 170 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 5 177 0 27 5 181 0 80 5 185 0 89 5 189 0 92]
#[0 4 18 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 5 193 0 35]
#[0 5 197 0 117]
#[0 2 50 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 4 42 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 5 201 0 117]
#[0 4 46 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 2 54 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 5 205 1 14]
#[0 0 186 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 5 209 0 64 5 213 0 77 5 217 1 21 5 221 1 22 5 225 1 23]
#[0 4 170 0 82]
#[0 5 229 0 82]
#[1 0 201 0 132 2 45 0 145 5 233 0 172]
#[0 5 237 0 93]
#[0 4 54 0 35]
#[0 4 34 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 4 58 0 35]
#[0 5 241 0 35]
#[0 4 50 0 35]
#[0 5 245 0 117]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 5 249 0 117 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 253 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 6 1 0 117]
#[0 6 5 0 117]
#[0 3 18 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 3 66 0 35 6 9 0 38]
#[0 6 13 0 35]
#[0 0 66 0 35 0 113 0 117 1 34]
#[0 0 122 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 6 17 0 56]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 21 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 6 25 0 175 6 29 0 176 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 0 210 0 48 0 55 0 61]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 33 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 6 37 0 48]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 0 154 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 1 62 0 11 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 1 70 0 11 0 12 0 14 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 1 74 0 11 0 12 0 14 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 1 78 0 11 0 12 0 14 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 1 86 0 11 0 12 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 158 0 11 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 154 0 11 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 170 0 7 0 8 0 11 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 166 0 7 0 8 0 11 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 178 0 7 0 8 0 11 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 174 0 7 0 8 0 11 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 190 0 1 0 2 0 3 0 4 0 7 0 8 0 11 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 186 0 1 0 2 0 3 0 4 0 7 0 8 0 11 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 202 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 198 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[1 6 45 0 23 6 49 0 24 2 209 0 39 0 81 0 72 0 89 0 75 2 213 0 76 0 97 0 77 0 101 0 78 2 217 0 99 0 201 0 132 6 53 0 145 6 57 0 193 6 61 0 197 6 65 0 198 6 69 0 201 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 201 0 132 6 53 0 145 6 73 0 195 6 77 0 197]
#[1 0 201 0 132 6 53 0 145 6 81 0 195 6 77 0 197]
#[0 2 82 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 2 78 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 6 85 0 113 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 89 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 2 126 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 3 225 0 131 6 93 0 199]
#[0 4 98 0 44]
#[0 6 97 0 44]
#[1 0 217 0 137 5 57 0 144 6 101 1 10]
#[1 0 201 0 132 6 105 0 145]
#[1 6 109 0 34 6 113 0 39]
#[1 3 225 0 131 6 117 0 199]
#[0 3 198 0 2 0 7 0 8 0 10 0 17 0 31 0 36 0 37 0 39 0 45 0 47 0 53 0 60 0 71 0 72 0 73 0 75 0 76 0 77 0 78 0 81 0 83 0 85 0 88 0 91 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 3 202 0 2 0 7 0 8 0 10 0 17 0 31 0 36 0 37 0 39 0 45 0 47 0 53 0 60 0 71 0 72 0 73 0 75 0 76 0 77 0 78 0 81 0 83 0 85 0 88 0 91 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 3 206 0 2 0 7 0 8 0 10 0 17 0 31 0 36 0 37 0 39 0 45 0 47 0 53 0 60 0 71 0 72 0 73 0 75 0 76 0 77 0 78 0 81 0 83 0 85 0 88 0 91 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 3 194 0 2 0 7 0 8 0 10 0 17 0 31 0 36 0 37 0 39 0 45 0 47 0 53 0 60 0 71 0 72 0 73 0 75 0 76 0 77 0 78 0 81 0 83 0 85 0 88 0 91 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 6 121 0 9]
#[1 3 118 0 17 3 118 0 74 3 118 0 118 3 118 0 130 3 118 0 136 3 118 0 138 6 125 0 237]
#[0 3 94 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 74 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 0 118 0 130 0 136 0 138 1 34]
#[0 6 129 0 46]
#[0 3 134 0 19 0 96 0 132]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 133 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 0 142 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 30 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 6 137 0 118]
#[0 3 234 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 4 14 0 117]
#[0 6 141 0 117]
#[0 6 145 0 37]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 149 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 6 153 0 58]
#[0 0 138 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 157 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 161 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 6 165 1 15]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 6 169 1 14]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 173 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 6 177 0 79 6 181 0 90]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 6 185 1 14]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 6 189 1 14]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 6 193 1 14]
#[0 4 22 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 230 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 4 10 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 0 182 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 6 197 0 86 6 201 1 24]
#[1 6 197 0 86 6 205 1 24]
#[0 0 190 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 174 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 178 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 6 209 1 14]
#[0 6 213 0 59]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 217 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 4 38 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 6 221 0 118]
#[0 3 250 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 6 225 0 117]
#[0 3 38 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 34 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 177 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 6 229 0 231 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 3 22 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 21 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 6 233 0 175 6 29 0 176 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 1 14 0 38 1 14 0 48 6 237 0 49 6 241 0 50 6 245 0 52 6 249 0 177 6 253 0 178 7 1 0 179]
#[0 0 214 0 48]
#[1 7 5 0 38 1 6 0 48]
#[0 0 126 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 7 9 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 0 130 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 7 13 0 36]
#[0 7 17 0 36]
#[0 2 2 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 29 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 210 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 2 14 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 29 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[1 2 22 0 1 7 21 0 2 2 22 0 3 2 22 0 4 2 22 0 5 2 22 0 6 2 22 0 7 7 25 0 8 2 22 0 11 2 22 0 12 2 22 0 13 2 22 0 14 2 22 0 15 2 22 0 16 2 22 0 17 2 22 0 18 2 22 0 19 2 22 0 20 2 22 0 21 2 22 0 22 2 22 0 27 7 29 0 29 2 22 0 32 2 22 0 35 2 22 0 38 2 22 0 46 2 22 0 47 2 22 0 48 2 22 0 49 2 22 0 50 2 22 0 52 2 22 0 55 2 22 0 60 2 22 0 61 2 22 0 62 2 22 0 63 2 22 0 70 2 22 0 80 2 22 0 82 2 22 0 89 2 22 0 92 2 22 0 93 2 22 0 95 2 22 0 105 2 22 0 106 2 22 0 107 2 22 0 108 2 22 0 109 2 22 0 110 2 22 0 113 2 22 0 117 7 33 0 200 7 37 1 12 2 22 1 34]
#[0 2 10 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 29 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 218 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[1 1 238 0 1 1 238 0 2 1 238 0 3 1 238 0 4 1 238 0 5 1 238 0 6 1 238 0 7 1 238 0 8 1 238 0 11 1 238 0 12 1 238 0 13 1 238 0 14 1 238 0 15 1 238 0 16 1 238 0 17 1 238 0 18 1 238 0 19 1 238 0 20 1 238 0 21 1 238 0 22 1 238 0 26 1 238 0 27 1 238 0 28 7 41 0 29 1 238 0 32 1 238 0 35 1 238 0 38 1 238 0 46 1 238 0 47 1 238 0 48 1 238 0 49 1 238 0 50 1 238 0 52 1 238 0 55 1 238 0 60 1 238 0 61 1 238 0 62 1 238 0 63 1 238 0 70 1 238 0 80 1 238 0 82 1 238 0 89 1 238 0 92 1 238 0 93 1 238 0 95 1 238 0 105 1 238 0 106 1 238 0 107 1 238 0 108 1 238 0 109 1 238 0 110 1 238 0 113 1 238 0 117 1 238 1 34]
#[0 1 234 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 2 118 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 7 45 0 113]
#[0 7 49 0 46]
#[0 4 90 0 2 0 7 0 8 0 10 0 17 0 31 0 36 0 37 0 39 0 42 0 45 0 47 0 53 0 60 0 71 0 72 0 73 0 75 0 76 0 77 0 78 0 81 0 83 0 85 0 88 0 91 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 0 18 0 44]
#[0 7 53 0 36]
#[0 7 57 0 43]
#[0 7 61 0 43]
#[0 7 65 0 46]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 7 69 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 45 0 17 7 73 0 74 7 77 0 118 7 81 0 130 7 85 0 136 7 89 0 138 7 93 0 232 1 209 0 234 7 97 0 236 7 101 0 241 7 105 0 242 7 109 0 245 7 113 0 246 7 117 1 37]
#[1 7 77 0 118 0 217 0 137 7 121 0 144 7 125 0 240 7 129 1 37]
#[1 1 50 0 32 7 133 0 38]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 7 137 0 117 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 5 137 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 7 141 0 253 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 3 238 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 0 201 0 132 2 45 0 145 7 145 0 172]
#[1 7 149 0 38 0 230 0 47 0 230 0 48 0 230 0 55 0 230 0 60 0 230 0 61 0 230 0 62]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 7 153 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 7 157 0 38 0 254 0 47 0 254 0 48 0 254 0 55 0 254 0 60 0 254 0 61 0 254 0 62]
#[0 4 126 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 162 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 7 161 0 70]
#[0 4 134 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 7 165 0 80]
#[0 7 169 0 80]
#[0 4 138 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 150 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 154 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 0 217 0 137 7 173 0 144]
#[0 4 182 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 186 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 0 178 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 7 177 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 7 181 0 48]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 7 185 0 117 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 7 189 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 3 254 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 3 70 0 35]
#[0 0 218 0 48]
#[0 1 38 0 38 0 48 0 52]
#[0 1 34 0 38 0 48 0 52]
#[1 7 193 0 51 7 197 0 54]
#[0 1 18 0 38 0 48]
#[1 1 22 0 38 1 22 0 48 6 245 0 52 7 201 0 179]
#[0 1 26 0 38 0 48]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 6 21 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 7 205 0 175 6 29 0 176 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 0 134 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 7 209 0 35]
#[0 7 213 0 35]
#[0 4 110 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 4 114 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 4 106 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 226 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 2 26 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 242 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 2 114 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[1 0 217 0 137 5 57 0 144 7 217 1 10]
#[1 0 54 0 35 7 221 0 37 0 54 0 38 7 225 0 146 7 229 0 148 7 233 0 149 7 237 0 150]
#[1 0 217 0 137 5 57 0 144 7 241 1 10]
#[1 0 217 0 137 5 57 0 144 7 245 1 10]
#[1 0 217 0 137 5 57 0 144 7 249 1 10]
#[0 7 253 0 12]
#[1 0 201 0 132 8 1 0 145]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 8 5 0 151 0 233 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 3 190 0 17 0 74 0 118 0 130 0 136 0 138]
#[0 3 186 0 17 0 74 0 118 0 130 0 136 0 138]
#[0 3 158 0 17 0 74 0 118 0 130 0 136 0 138]
#[0 3 106 0 17 0 74 0 118 0 130 0 136 0 138]
#[0 3 122 0 17 0 74 0 118 0 130 0 136 0 138]
#[0 3 110 0 17 0 74 0 118 0 130 0 136 0 138]
#[0 3 114 0 17 0 74 0 118 0 130 0 136 0 138]
#[0 3 146 0 17 0 74 0 118 0 130 0 136 0 138]
#[0 3 154 0 17 0 74 0 118 0 130 0 136 0 138]
#[0 3 150 0 17 0 74 0 118 0 130 0 136 0 138]
#[0 3 138 0 19 0 96 0 132]
#[0 3 126 0 19 0 96 0 132]
#[0 3 142 0 19 0 96 0 132]
#[1 2 29 0 37 8 9 0 180]
#[0 3 242 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 8 13 0 117]
#[0 0 250 0 58]
#[1 2 65 0 37 8 17 0 171]
#[1 8 21 0 38 0 238 0 47 0 238 0 48 0 238 0 55 0 238 0 60 0 238 0 61 0 238 0 62]
#[1 2 77 0 37 8 25 0 174]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 8 29 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 8 33 1 14]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 8 37 1 14]
#[0 8 41 0 82]
#[1 8 45 0 38 4 162 0 93]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 8 49 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 4 2 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 8 53 0 117]
#[0 1 42 0 38 0 48]
#[0 1 46 0 38 0 48]
#[0 1 30 0 38 0 48]
#[0 1 10 0 48]
#[0 2 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 29 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 1 222 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 117 1 34]
#[0 8 57 0 44]
#[1 0 201 0 132 8 61 0 145]
#[1 8 65 0 35 8 69 0 38]
#[0 0 34 0 35 0 38]
#[0 0 38 0 35 0 38]
#[0 0 50 0 35 0 38]
#[0 3 182 0 44]
#[0 3 178 0 44]
#[0 0 10 0 44]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 8 73 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2]
#[0 8 77 0 19]
#[0 8 81 0 117]
#[0 1 54 0 32]
#[0 3 246 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 0 234 0 47 0 48 0 55 0 60 0 61 0 62]
#[1 2 65 0 37 8 85 0 171]
#[0 1 2 0 47 0 48 0 55 0 60 0 61 0 62]
#[0 4 130 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 142 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 146 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 0 29 0 2 0 33 0 7 0 37 0 8 0 41 0 10 0 45 0 17 0 49 0 31 0 53 0 36 0 57 0 37 0 61 0 39 0 65 0 47 0 69 0 53 0 73 0 60 0 77 0 71 0 81 0 72 0 85 0 73 0 89 0 75 0 93 0 76 0 97 0 77 0 101 0 78 0 105 0 81 0 109 0 83 0 113 0 85 0 117 0 88 0 121 0 91 0 125 0 98 0 129 0 99 0 133 0 100 0 137 0 101 0 141 0 102 0 145 0 103 0 149 0 104 0 153 0 111 0 157 0 112 0 161 0 115 0 165 0 116 0 169 0 119 0 173 0 121 0 177 0 122 0 181 0 123 0 185 0 124 0 189 0 125 0 193 0 126 0 197 0 127 0 201 0 132 0 205 0 133 0 209 0 134 0 213 0 135 0 217 0 137 0 221 0 144 0 225 0 145 4 41 0 152 0 237 0 153 0 241 0 154 0 245 0 155 0 249 0 156 0 253 0 157 1 1 0 158 1 5 0 159 1 9 0 160 1 13 0 161 1 17 0 162 1 21 0 163 1 25 0 164 1 29 0 165 1 33 0 166 1 37 0 169 1 41 0 170 1 45 0 181 1 49 0 182 1 53 0 183 1 57 0 187 1 61 0 188 1 65 0 189 1 69 0 190 1 73 0 191 1 77 0 192 1 81 0 194 1 85 0 196 1 89 0 201 1 93 0 202 1 97 0 203 1 101 0 204 1 105 0 205 1 109 0 206 1 113 0 207 1 117 0 208 1 121 0 211 1 125 0 212 1 129 0 213 1 133 0 214 1 137 0 215 1 141 0 216 1 145 0 217 1 149 0 218 1 153 0 219 1 157 0 220 1 161 0 221 1 165 0 222 1 169 0 223 1 173 0 224 1 177 0 225 1 181 0 226 1 185 0 227 1 189 0 228 1 193 0 229 1 197 0 230 1 201 0 232 1 205 0 233 1 209 0 234 1 213 0 249 1 217 0 250 1 221 0 251 1 225 0 252 1 229 0 254 1 233 0 255 1 237 1 0 1 241 1 1 1 245 1 2 8 89 1 14]
#[1 4 129 0 37 8 93 1 19]
#[0 0 174 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 1 34]
#[0 4 94 0 2 0 7 0 8 0 10 0 17 0 31 0 36 0 37 0 39 0 42 0 45 0 47 0 53 0 60 0 71 0 72 0 73 0 75 0 76 0 77 0 78 0 81 0 83 0 85 0 88 0 91 0 98 0 99 0 100 0 101 0 102 0 103 0 104 0 111 0 112 0 115 0 116 0 119 0 121 0 122 0 123 0 124 0 125 0 126 0 127 0 132 0 133 0 134 0 135 0 137]
#[0 0 58 0 35 0 38]
#[1 7 77 0 118 8 97 1 37]
#[1 7 221 0 37 8 101 0 150]
#[0 0 146 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 3 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 26 0 27 0 28 0 30 0 32 0 35 0 38 0 46 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 63 0 70 0 74 0 80 0 82 0 89 0 92 0 93 0 95 0 103 0 104 0 105 0 106 0 107 0 108 0 109 0 110 0 113 0 114 0 117 0 118 0 130 0 136 0 138 1 34]
#[0 4 250 0 17 0 19 0 44 0 74 0 96 0 118 0 130 0 132 0 136 0 138]
#[0 0 242 0 47 0 48 0 55 0 60 0 61 0 62]
#[1 8 105 0 89 8 109 0 92 8 113 1 25 8 117 1 26 8 121 1 27]
#[0 4 166 0 93]
#[0 0 14 0 44]
#[0 0 46 0 35 0 38]
#[1 8 125 0 65 8 129 0 66 8 133 0 68 8 137 0 69 8 141 1 28 8 145 1 29 8 149 1 30 8 153 1 31 8 157 1 32]
#[1 8 125 0 65 8 129 0 66 8 133 0 68 8 137 0 69 8 161 1 28 8 145 1 29 8 149 1 30 8 153 1 31 8 157 1 32]
#[0 4 190 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 194 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 198 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 8 165 0 118 8 169 1 33]
#[1 8 165 0 118 8 173 1 33]
#[1 8 165 0 118 8 177 1 33]
#[1 8 165 0 118 8 181 1 33]
#[0 4 206 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 210 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 214 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 218 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 222 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 202 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[1 0 217 0 137 8 185 0 144]
#[0 4 230 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 226 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 234 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 4 238 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
#[0 8 189 0 117]
#[0 4 242 0 12 0 27 0 32 0 35 0 38 0 47 0 48 0 49 0 50 0 52 0 55 0 60 0 61 0 62 0 70 0 80 0 82 0 89 0 92 0 93 0 113 0 117 1 34]
)
! !

!XQueryParser methodsFor:'informing'!

informAboutRuleReduction: aString

    (Smalltalk isStandAloneApp or:[self class isVerbose]) ifTrue:
        [Transcript show: '[XQuery::Parser] reducing rule '; showCR: aString]

    "Created: / 10-02-2007 / 13:00:28 / janfrog"
    "Modified: / 12-04-2007 / 11:16:11 / janfrog"
! !

!XQueryParser methodsFor:'private'!

actionForCurrentToken
    "find the token, which does not couse an error (not only the first one)"
    |ids action|

    ids := currentToken id.
    1 to:ids size do:[:i | 
        action := self actionFor:(ids at:i).
        (action bitAnd:self actionMask) = self errorAction ifFalse:[
            ^ action
        ]
    ].
    ^ self errorAction

    "Created: / 17-03-2006 / 14:55:30 / ked"
    "Modified: / 12-07-2009 / 18:09:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

reduce: anInteger 
    super reduce: anInteger.
    self saveCurrentValidState.

    "Modified: / 12-07-2009 / 18:15:17 / Jan Kurs <kursj1@fel.cvut.cz>"
!

shift: stateIndex 
    super shift: stateIndex.
    self saveCurrentValidState.

    "Modified: / 12-07-2009 / 18:15:05 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryParser methodsFor:'private-error handling'!

handleError: anInteger
    (self couldBeRecoveredFromError) ifTrue: [
        "XQuery sppec:
            When tokenizing, the longest possible match that is valid in the current context is used

         We found invalid token, lets try to find out shorter and valid token.
        "
        self recoverFromErrorNumber: anInteger.
    ] ifFalse: [
        super handleError: anInteger.
    ].

    "Created: / 12-07-2009 / 17:58:00 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 19-07-2009 / 15:31:00 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryParser methodsFor:'xquery-invalid-token-recovery'!

couldBeRecoveredFromError
    "If the current token id is #(0) all the possibilities
        were checked and the token is realy invalid"

    (currentToken id first = 0) ifTrue: [ ^ false ].
    (currentToken id first = scanner emptySymbolTokenId) ifTrue: [ ^ false ].
    (currentToken id first = scanner errorTokenId) ifTrue: [ ^ false ].
    (scanner invalidTokenIds contains: [ :elem | elem = (currentToken id)]) ifTrue: [ ^ false ].
    ^ true.

    "Created: / 19-07-2009 / 15:31:10 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 22-09-2009 / 14:25:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

recoverFromErrorNumber: anInteger
    currentToken value = ' ' ifTrue: [
        self recoverFromWhitespace.
    ] ifFalse: [
        self recoverFromInvalidToken.
    ].

    "Created: / 12-07-2009 / 18:04:13 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 19-07-2009 / 14:19:54 / Jan Kurs <kursj1@fel.cvut.cz>"
!

recoverFromInvalidToken
        scanner addInvalidToken: currentToken.
        scanner recoverFromError.

        nodeStack := self lastValidState nodeStack.
        stateStack := self lastValidState stateStack.
"/        currentToken := self lastValidState currentToken.
        currentToken := nil.

    "Created: / 19-07-2009 / 14:19:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 20-09-2009 / 14:36:07 / Jan Kurs <kursj1@fel.cvut.cz>"
!

recoverFromWhitespace
    currentToken := nil.
    scanner resetScanner.

    "Created: / 19-07-2009 / 14:18:49 / Jan Kurs <kursj1@fel.cvut.cz>"
!

saveCurrentValidState
    self lastValidState nodeStack: nodeStack copy.
    self lastValidState stateStack: stateStack copy.
    self lastValidState currentToken: currentToken copy.

    scanner saveCurrentState.

    "Created: / 12-07-2009 / 18:15:05 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 13-07-2009 / 23:19:15 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryParser class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
