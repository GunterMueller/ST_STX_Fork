"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#AstNodeVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstNodeVisitor methodsFor:'visiting'!

visit:anObject 
    "visit anObject (visitor pattern).
     The object should call back one of my visitXXXX methods."

    ^ anObject acceptVisitor:self

    "Modified: / 21-03-2007 / 17:55:26 / janfrog"
!

visitAstAbbrevForwardStep:anObject 

    ^self
        visit: anObject stepType;
        visit: anObject nodeTest

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstAdditiveExpr:anObject 
    "dispatched back from the visited astAdditiveExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self 
        visit:anObject multiplicativeExpr;
        visit:anObject additiveExpr

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstAndExpr:anObject 

    ^ self 
        visit:anObject comparisonExpr ;
        visit:anObject andExpr

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstAnyKindTest:anObject

    "Modified: / 21-03-2007 / 17:58:39 / janfrog"
!

visitAstAttribNameOrWildcard:anObject 

    ^ self 
        visit:anObject attributeName

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstAttributeTest:anObject 
    ^ self 
        visit:anObject attribName

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstAxisStep:anObject 

    ^ self 
        visit:anObject forwardStep ;
        visit:anObject reverseStep;
        visit:anObject predicateList

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstCompAttrConstructor:anObject 
    ^ self 
        visit:anObject qname ;
        visit:anObject expr ;
        visit:anObject contentExpr

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstCompDocConstructor:anObject 
    ^ self 
        visit:anObject expr

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstCompElemConstructor:anObject 
    ^ self 
        visit:anObject qname;
        visit:anObject expr;
        visit:anObject contentExpr

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstCompTextConstructor:anObject 
    ^ self 
        visit:anObject expr

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstComparisonExpr:anObject 

    ^ self 
        visit:anObject rangeExprLeft ;
        visit:anObject valueComp;
        visit:anObject generalComp;
        visit:anObject nodeComp;
        visit:anObject rangeExprRight

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstContextItemExpr:anObject

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstDecimalLiteral:anObject

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstDefaultNamespaceDecl:anObject

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstDirAttributeList:anObject 

    ^ self 
        visit:anObject qname ;
        visit:anObject dirAttributeValue;
        visit:anObject dirAttributeList

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstDirElemConstructor:anObject 

   ^ self 
        visit:anObject qname;
        visit:anObject dirAttributeList;
        visit:anObject dirElemContent

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstDirElemContent:anObject 
    ^ self 
        visit:anObject content;
        visit:anObject dirElemContent

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstDocumentTest:anObject 
   ^ self 
        visit:anObject elementTest

    "Created: / 21-03-2007 / 17:55:24 / janfrog"
!

visitAstDoubleLiteral:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstElementNameOrWildcard:anObject 
     self 
        visit:anObject elementName

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstElementTest:anObject 

    ^ self visit:anObject elementName

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstEnclosedExpr:anObject 

    ^ self visit:anObject expr

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstExpr:anObject 
    ^ self 
        visit:anObject exprSingle ;
        visit:anObject expr

    "Modified: / 21-03-2007 / 18:08:44 / janfrog"
!

visitAstFLWORExpr:anObject 

    self
        visit: anObject flworExpr_ForLet;
        visit: anObject whereClause;
        visit: anObject orderByClause;
        visit: anObject exprSingle

    "Modified: / 21-03-2007 / 18:09:32 / janfrog"
!

visitAstFLWORExpr_ForLet:anObject 
    ^ self 
        visit:anObject forClause ;
        visit:anObject letClause ;
        visit:anObject flworExpr_ForLet

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstFilterExpr:anObject 
    ^ self 
        visit:anObject primaryExpr;
        visit:anObject predicateList

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstForClause:anObject 
    "dispatched back from the visited astForClause-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstForwardStep:anObject 
    "dispatched back from the visited astForwardStep-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstFunctionCall:anObject 
    "dispatched back from the visited astFunctionCall-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstFunctionDecl:anObject 
    "dispatched back from the visited astFunctionDecl-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstFunctionParametersList:anObject 
    "dispatched back from the visited astFunctionParametersList-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstIfExpr:anObject 
    "dispatched back from the visited astIfExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstIntegerLiteral:anObject 
    "dispatched back from the visited astIntegerLiteral-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstIntersectExceptExpr:anObject 
    "dispatched back from the visited astIntersectExceptExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstLetClause:anObject 
    "dispatched back from the visited astLetClause-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstMainModule:anObject 
    "dispatched back from the visited astMainModule-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstMultiplicativeExpr:anObject 
    "dispatched back from the visited astMultiplicativeExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstNCName:anObject 
    "dispatched back from the visited astNCName-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstNameTest:anObject 
    "dispatched back from the visited astNameTest-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstNamespaceDecl:anObject 
    "dispatched back from the visited astNamespaceDecl-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstOrExpr:anObject 
    "dispatched back from the visited astOrExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstOrderByClause:anObject 
    "dispatched back from the visited astOrderByClause-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstOrderModifier:anObject 
    "dispatched back from the visited astOrderModifier-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstOrderSpec:anObject 
    "dispatched back from the visited astOrderSpec-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstOrderSpecList:anObject 
    "dispatched back from the visited astOrderSpecList-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstParam:anObject 
    "dispatched back from the visited astParam-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstParenthesizedExpr:anObject 
    "dispatched back from the visited astParenthesizedExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstPathExpr:anObject 
    "dispatched back from the visited astPathExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstPredefinedEntityRef:anObject 
    "dispatched back from the visited astPredefinedEntityRef-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstPredicate:anObject 
    "dispatched back from the visited astPredicate-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstPredicateList:anObject 
    "dispatched back from the visited astPredicateList-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstProlog:anObject 
    "dispatched back from the visited astProlog-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstQName:anObject 
    "dispatched back from the visited astQName-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstQuantifiedExpr:anObject 
    "dispatched back from the visited astQuantifiedExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstQuantifiedExpr_Impl:anObject 
    "dispatched back from the visited astQuantifiedExpr_Impl-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstRangeExpr:anObject 
    "dispatched back from the visited astRangeExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstRelativePathExpr:anObject 
    "dispatched back from the visited astRelativePathExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstReverseStep:anObject 
    "dispatched back from the visited astReverseStep-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstStringLiteral:anObject 
    "dispatched back from the visited astStringLiteral-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:25 / janfrog"
!

visitAstTextTest:anObject 
    "dispatched back from the visited astTextTest-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:26 / janfrog"
!

visitAstUnaryExpr:anObject 
    "dispatched back from the visited astUnaryExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:26 / janfrog"
!

visitAstUnionExpr:anObject 
    "dispatched back from the visited astUnionExpr-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:26 / janfrog"
!

visitAstVarRef:anObject 
    "dispatched back from the visited astVarRef-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:26 / janfrog"
!

visitAstWhereClause:anObject 
    "dispatched back from the visited astWhereClause-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:26 / janfrog"
!

visitAstWildcard:anObject 
    "dispatched back from the visited astWildcard-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject

    "Created: / 21-03-2007 / 17:55:26 / janfrog"
!

visitObject:anObject 
    "dispatched back from the visited objects (visitor pattern)"

    "general fallBack - please change as required"

    self halt:'not yet implemented'

    "Modified: / 21-03-2007 / 17:55:26 / janfrog"
! !

!AstNodeVisitor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
