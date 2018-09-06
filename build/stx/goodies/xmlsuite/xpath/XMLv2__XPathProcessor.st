"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathProcessor
	instanceVariableNames:'expressionParser documentAdaptor'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathProcessor class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!XPathProcessor methodsFor:'initialization'!

documentAdaptor:anXPathDocumentAdaptor

    <resource: #obsolete>
    self obsoleteMethodWarning.
    
    documentAdaptor := anXPathDocumentAdaptor.

    "Created: / 13-10-2006 / 17:23:33 / janfrog"
    "Modified: / 25-10-2006 / 17:14:36 / janfrog"
!

initialize
    super initialize.
    expressionParser := XPathExpressionParser new.
!

setDocumentAdaptor:anXPathDocumentAdaptor 

    documentAdaptor := anXPathDocumentAdaptor.

    "Created: / 25-10-2006 / 17:14:07 / janfrog"
!

setDocumentProvider:aDocumentProvider

    "Nothing to do here"

    "Created: / 25-10-2006 / 17:15:40 / janfrog"
! !

!XPathProcessor methodsFor:'private'!

evaluateTree:anExpressionTreeRootNode inContext:aContext 
    |location_path nodeSet context|

    XPathExprTreeNode loadRules.
    location_path := anExpressionTreeRootNode 
                evaluateWithDerivedValue:(XPathExpression new).
    context := aContext.
    location_path absolute ifTrue:[
        context := documentAdaptor xpathRootContext
    ].
    nodeSet := aContext newNodeSetWith:(context node).
    location_path steps do:[:step | 
        |newNodeSet|

        newNodeSet := aContext newNodeSet.
        nodeSet do:[:node | 
            "get elements by axis"
            newNodeSet addAll:(step axis 
                        createNodeSetFromContext:(documentAdaptor xpathContextOf:node)).
             "filter the set using node test"
            newNodeSet := step nodeTest filterNodeSet:newNodeSet.
             "filter the set using predicates"
        ].
        nodeSet := newNodeSet.
    ].
    nodeSet documentAdaptor:documentAdaptor.
    ^ nodeSet.

    "Created: / 25-10-2006 / 17:27:44 / janfrog"
    "Modified: / 15-11-2007 / 22:10:42 / janfrog"
!

sortByDocumentOrder:aNodeSet 
    ^aNodeSet 
        ifNil:[#()]
        ifNotNil:[
            aNodeSet 
                asSortedCollection:documentAdaptor xpathNodePositionComparator]

                "[:right :left | 
                |result leftPos rightPos pos|

                leftPos := documentAdaptor xpathPositionVectorOf:left.
                rightPos := documentAdaptor xpathPositionVectorOf:right.
                pos := 1.

                [
                    ((pos <= leftPos elementPosition size) 
                        and:[ pos <= rightPos elementPosition size ]) and:[ result isNil ]
                ] whileTrue:[
                    ((leftPos elementPosition at:pos) > (rightPos elementPosition at:pos)) ifTrue:[
                        result := true.
                    ].
                    ((leftPos elementPosition at:pos) < (rightPos elementPosition at:pos)) ifTrue:[
                        result := false.
                    ].
                    pos := pos + 1.
                ].
                (leftPos elementPosition size = (rightPos elementPosition size)) ifTrue:[
                    pos := 1.
                    [
                        ((pos <= leftPos attributePosition size) 
                            and:[ pos <= rightPos attributePosition size ]) and:[ result isNil ]
                    ] whileTrue:[
                        ((leftPos attributePosition at:pos) > (rightPos attributePosition at:pos)) ifTrue:[
                            result := true.
                        ].
                        ((leftPos attributePosition at:pos) < (rightPos attributePosition at:pos)) ifTrue:[
                            result := false.
                        ].
                        pos := pos + 1.
                    ].
                ].
                result isNil ifTrue:[
                    result := true
                ].
                result.
            ]
    ]."

    "Modified: / 13-10-2006 / 20:06:46 / janfrog"
! !

!XPathProcessor methodsFor:'processing'!

evaluate: aString

    ^self evaluate: aString inContext: documentAdaptor xpathRootContext

    "Created: / 25-10-2006 / 17:25:55 / janfrog"
!

evaluate:aString inContext:aContext 
    ^ self evaluateTree:(expressionParser parse:aString) inContext:aContext.

    "Created: / 25-10-2006 / 17:28:13 / janfrog"
!

processExpression:aString

    <resource: #obsolete>
    self obsoleteMethodWarning: 'User #evaluate: instead'.
    ^self evaluate:aString inContext: documentAdaptor xpathRootContext.

    "Modified: / 25-10-2006 / 17:29:25 / janfrog"
! !

!XPathProcessor class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathProcessor.st,v 1.4 2007-11-16 09:20:57 vranyj1 Exp $'
! !
