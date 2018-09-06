"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathCoverageMonitor
	instanceVariableNames:''
	classVariableNames:'idSet'
	poolDictionaries:''
	category:'XML Suite-XPath-Tests'
!


!XPathCoverageMonitor class methodsFor:'expression tree coverage'!

addId: anId
    idSet isNil ifTrue:[idSet := Set new].
    idSet add:anId.
!

reset
    idSet := Set new.
!

showUncoveredRules
    XPathExprTreeNode rules keys do:[:key|
        (idSet includes:key) ifFalse:[
            Transcript showCR:key
        ]
    ]

    "
        XPathCoverageMonitor showUncoveredRules
    "

    "Modified: / 28-09-2006 / 18:12:09 / janfrog"
! !

!XPathCoverageMonitor class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathCoverageMonitor.st,v 1.2 2006-12-15 11:06:57 vranyj1 Exp $'
! !
