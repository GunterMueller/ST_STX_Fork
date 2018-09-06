"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XPathExpressionOptimizer
	instanceVariableNames:'xpathExpression'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Optimizations'
!


!XPathExpressionOptimizer class methodsFor:'optimizer'!

optimize: xpathExpression

    ^self new
        xpathExpression: xpathExpression;
        optimize;
        xpathExpression

    "Created: / 21-11-2007 / 10:43:43 / janfrog"
! !

!XPathExpressionOptimizer methodsFor:'accessing'!

xpathExpression
    ^ xpathExpression

    "Created: / 21-11-2007 / 10:43:48 / janfrog"
!

xpathExpression:something
    xpathExpression := something.

    "Created: / 21-11-2007 / 10:43:48 / janfrog"
! !

!XPathExpressionOptimizer methodsFor:'optimizing'!

optimize

    self optimizeDescendantOrSelf

    "Created: / 21-11-2007 / 10:45:04 / janfrog"
!

optimizeDescendantOrSelf

    | newXPathExpression locationStepIndex |
    xpathExpression size < 1 ifTrue:[^self].
    newXPathExpression := XPathExpression new absolute: xpathExpression absolute.
    locationStepIndex := 1.

    [locationStepIndex < xpathExpression size] whileTrue:
        [| currentLocationStep nextLocationStep |
        currentLocationStep := xpathExpression at:locationStepIndex.
        nextLocationStep := xpathExpression at:locationStepIndex + 1.
        (currentLocationStep isDescendantOrSelfWithAnyKindTestStepAndWithoutPredicates
            and:[nextLocationStep isChildWithNameTestStep])
                ifTrue:
                    [newXPathExpression add:
                        (XPathLocationStep new
                            axis: XPathAxisDescendantOrSelf new;
                            nodeTest: nextLocationStep nodeTest;
                            predicates: nextLocationStep predicates).
                    locationStepIndex := locationStepIndex + 1]
                ifFalse:
                    [newXPathExpression
                        add: currentLocationStep].
        locationStepIndex := locationStepIndex + 1].
    locationStepIndex = xpathExpression size ifTrue:
        [newXPathExpression add:xpathExpression last].
    xpathExpression := newXPathExpression

    "Created: / 21-11-2007 / 11:02:49 / janfrog"
! !

!XPathExpressionOptimizer class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
