"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#XPathTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Tests'
!


!XPathTests class methodsFor:'defaults'!

defaultTestDirectory

    ^(Smalltalk getPackageDirectoryForPackage:self package) construct: 'resources/tests/'.

    "Modified: / 28-09-2006 / 18:10:10 / janfrog"
! !

!XPathTests methodsFor:'private'!

loadExprTrees

    | col tree |
    col := Set new.

    "child::*"
                
    tree := XPathExprTreeNode new id:#rule_1_1.
    tree subnodes add:(XPathExprTreeNode new id:#rule_3_1).
    (tree subnodes at:1) subnodes add:(XPathExprTreeNode new id:#rule_4_1).
    ((tree subnodes at:1) subnodes at:1) subnodes 
        add:(XPathExprTreeNode new id:#rule_5_1);
        add:(XPathExprTreeNode new id:#rule_7_1).
    (((tree subnodes at:1) subnodes at:1) subnodes at:1) subnodes 
        add:(XPathExprTreeNode new id:#rule_6_x; synthetizedValue:'child');
        add:(XPathExprTreeNode new).
    (((tree subnodes at:1) subnodes at:1) subnodes at:2) subnodes
        add:(XPathExprTreeNode new id:#rule_37_1).
    col add: tree.

    ^ col.
!

validateExpression:anExpressionString withResult:aString 
    |doc filename nodeSet nodeSetString|

    "an example of complete usage"
    filename := self class defaultTestDirectory construct:'sample_001.xml'.
    doc := XPathDocumentAdaptorFactory 
                documentAdaptorFor:(XMLv2::Parser forDOM3 processDocumentInFilename:filename
                        beforeScanDo:[:parser | parser validate:false ]).
    nodeSet := (XPathProcessor new)
                documentAdaptor:doc;
                processExpression:anExpressionString.
    nodeSetString := (nodeSet asString).
    self assert:(nodeSetString = aString).

    "Modified: / 24-10-2006 / 12:00:27 / janfrog"
! !

!XPathTests methodsFor:'testing'!

testExpression_001
    self validateExpression:'child::*' withResult:'root1 '
!

testExpression_002
    self validateExpression:'descendant::*' withResult:'root1 tag2 tag3 subtag4 subtag5 emp6 subtag7 b8 tag9 '
!

testExpression_003
    self validateExpression:'child::*/child::*/descendant::*' withResult:'subtag1 subtag2 emp3 subtag4 b5 '
!

testExpression_004
    self validateExpression:'descendant::tag' withResult:'tag1 tag2 tag3 '
!

testExpression_005
    |doc filename node_set|

    "an example of complete usage"
    filename := self class defaultTestDirectory construct:'sample_001.xml'.
    doc := XPathDocumentAdaptorFactory 
                documentAdaptorFor:(XML::XMLParser processDocumentInFilename:filename
                        beforeScanDo:[:parser | parser validate:false ]).
    node_set := (XPathProcessor new documentAdaptor:doc) processExpression:'/'.
    self assert:((node_set nodesInDocumentOrder at:1) isDocument).

    "Modified: / 13-10-2006 / 20:54:33 / janfrog"
!

testExpression_006
    self validateExpression:'/child::*' withResult:'root1 '
!

testExpression_007
    self validateExpression:'//child::subtag' withResult:'subtag1 subtag2 subtag3 '
!

testExpression_008
    self validateExpression:'child::root/child::tag//self::*' withResult:'tag1 tag2 subtag3 subtag4 emp5 subtag6 b7 tag8 '
!

testExpression_009
    self validateExpression:'child::root/child::tag//child::*' withResult:'subtag1 subtag2 emp3 subtag4 b5 '
!

testExpression_010
    self validateExpression:'child::root//.' withResult:'root1 tag2 tag3 subtag4 subtag5 emp7 subtag9 b11 tag13 '.
!

testExpression_011
    self validateExpression:'/root/tag' withResult:'tag1 tag2 tag3 '.
!

testExpression_012
    self validateExpression:'/root//@*' withResult:'1234somethingyes'.
! !

!XPathTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathTests.st,v 1.4 2006-12-15 11:06:35 vranyj1 Exp $'
! !
