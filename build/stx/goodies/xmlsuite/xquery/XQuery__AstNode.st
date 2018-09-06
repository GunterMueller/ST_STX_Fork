"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::ASTNode subclass:#AstNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstNode methodsFor:'accessing'!

nodeTypeName

    ^self class nameWithoutNameSpacePrefix copyFrom: 4

    "Created: / 31-10-2007 / 12:30:48 / janfrog"
! !

!AstNode methodsFor:'checks'!

assert: aBlockOrBoolean description: aString

    aBlockOrBoolean value ifFalse:
        [XQueryInterpreterError raiseErrorString:'err:XUST - ', aString]

    "Created: / 21-11-2007 / 15:30:59 / janfrog"
!

ensureIsNotUpdatingExpression

self assert: (self isUpdatingExpression not) description:'must be an updating expression here'

    "Modified: / 05-12-2007 / 10:16:50 / janfrog"
!

ensureIsUpdatingExpression

self assert: (self isUpdatingExpression) description:'cannot be an updating expression here'

    "Created: / 21-11-2007 / 16:51:34 / janfrog"
    "Modified: / 13-02-2012 / 20:56:17 / Adam Senk <senkadam@gmail.com>"
! !

!AstNode methodsFor:'converting'!

asCollectionOfForClauses
    |s|

    s := (OrderedCollection new:2) writeStream.
    self forClausesOn:s.
    ^ s contents

    "Created: / 28-03-2007 / 19:32:57 / janfrog"
!

asCollectionOfForLetClauses
    |s|

    s := (OrderedCollection new:2) writeStream.
    self forLetClausesOn:s.
    ^ s contents

    "Created: / 28-03-2007 / 17:58:42 / janfrog"
!

asCollectionOfLetClauses
    |s|

    s := (OrderedCollection new:2) writeStream.
    self letClausesOn:s.
    ^ s contents

    "Created: / 28-03-2007 / 19:33:42 / janfrog"
!

asCollectionOfQuantifiedExprImpls
    |s|

    s := (OrderedCollection new:2) writeStream.
    self quantifiedExprImplsOn:s.
    ^ s contents

    "Created: / 28-03-2007 / 22:01:31 / janfrog"
!

asDummyValue

    ^AstDummyNode new
        dummyValue: self

    "Created: / 28-03-2007 / 20:26:24 / janfrog"
! !

!AstNode methodsFor:'private'!

forClausesOn:aStream 
    "nothing to do here"

    "Created: / 28-03-2007 / 19:33:15 / janfrog"
!

forLetClausesOn:aStream 
    "nothing to do here"

    "Created: / 28-03-2007 / 17:58:16 / janfrog"
!

letClausesOn:aStream 
    "nothing to do here"

    "Created: / 28-03-2007 / 19:33:48 / janfrog"
!

quantifiedExprImplsOn:s

    "Created: / 28-03-2007 / 22:01:56 / janfrog"
! !

!AstNode methodsFor:'testing'!

isAstAbbrevForwardStep
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstAdditiveExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstAfterTriggerExpr
    ^ false
!

isAstAndExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstAnyKindTest
    ^ false

    "Created: / 21-11-2006 / 21:54:04 / ked"
!

isAstAttribNameOrWildcard
    ^ false

    "Created: / 21-11-2006 / 21:58:21 / ked"
!

isAstAttributeTest
    ^ false

    "Created: / 21-11-2006 / 21:57:19 / ked"
!

isAstAxisStep
    ^ false

    "Modified: / 12-10-2006 / 21:57:48 / ked"
!

isAstBeforeTriggerExpr
    ^ false
!

isAstCompAttrConstructor
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstCompDocConstructor
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstCompElemConstructor
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstCompTextConstructor
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstComparisonExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:48 / ked"
!

isAstConnectTriggerExpr
    ^false.

    "Created: / 24-03-2012 / 23:56:14 / Adam Senk <senkadam@gmail.com>"
!

isAstContextItemExpr
    ^ false

    "Created: / 07-11-2006 / 22:03:56 / ked"
!

isAstDecimalLiteral
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstDeleteTriggerExpr
    ^ false
!

isAstDirAttributeList
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstDirElemConstructor
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstDirElemContent
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstDisconnectTriggerExpr
    ^ false
!

isAstDocumentTest
    ^ false

    "Created: / 21-11-2006 / 21:55:13 / ked"
!

isAstDoubleLiteral
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstDropTriggerExpr
    ^ false
!

isAstElementNameOrWildcard
    ^ false

    "Created: / 21-11-2006 / 22:00:25 / ked"
!

isAstElementTest
    ^ false

    "Created: / 21-11-2006 / 21:59:24 / ked"
!

isAstEnclosedExpr
    ^ false

    "Created: / 06-11-2006 / 22:41:13 / ked"
!

isAstExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstFLWORExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstFLWORExpr_ForLet
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstFilterExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstForClause
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstForwardStep
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstFunctionCall
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstFunctionParametersList
    ^ false

    "Created: / 11-11-2006 / 18:51:39 / ked"
!

isAstIfExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:48 / ked"
!

isAstInsertTriggerExpr
    ^ false
!

isAstIntegerLiteral
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstIntersectExceptExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstLetClause
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstMultiplicativeExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstNCName
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstNameTest
    ^ false

    "Created: / 12-10-2006 / 21:57:47 / ked"
!

isAstNodeTriggerExpr
    ^ false
!

isAstOrExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstOrderByClause
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstOrderModifier
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstOrderSpec
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstOrderSpecList
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstParenthesizedExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstPathExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstPredefinedEntityRef
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstPredicate
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstPredicateList
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstQName
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstQuantifiedExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstQuantifiedExpr_Impl
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstRangeExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstRelativePathExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstRenameTriggerExpr
    ^ false
!

isAstReplaceTriggerExpr
    ^ false
!

isAstReverseStep
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstStatementTriggerExpr
    ^ false
!

isAstStringLiteral
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstTextTest
    ^ false

    "Created: / 21-11-2006 / 21:56:13 / ked"
!

isAstTriggerBodyExpr
    ^ false
!

isAstTriggerNameAndTargetExpr
    ^ false
!

isAstUnaryExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstUnionExpr
    ^ false

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isAstVarRef
    ^ false

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isAstWhereClause
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isAstWildcard
    ^ false

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isUpdatingExpression

  "
    self children do:
        [:childNode| childNode ensureIsNotUpdatingExpression ].
   "

    self children do:
        [:childNode|childNode isUpdatingExpression ifTrue:[^true]].



    ^ false.

    "Created: / 21-11-2007 / 14:17:06 / janfrog"
    "Modified: / 21-11-2007 / 15:59:29 / janfrog"
! !

!AstNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    self subclassResponsibility

    "Created: / 06-07-2006 / 19:12:11 / ked"
! !

!AstNode class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
