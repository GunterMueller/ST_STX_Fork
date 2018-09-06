"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#DOMImplementationRegistry
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3-Implementation'
!


!DOMImplementationRegistry class methodsFor:'DOM3 interface'!

getDOMImplementation:featureString
    | featureArray |

    featureArray := self parseFeatureString: featureString.
    ^self domImplementations 
        detect:[:impl| impl hasFeatures:featureArray]
        ifNone:[nil]

    "
        DOMImplementationRegistry getDOMImplementation:'XML 3.0' 
        DOMImplementationRegistry getDOMImplementation:'XML 1.0'  
        DOMImplementationRegistry getDOMImplementation:'+XML 3.0 '   
        DOMImplementationRegistry getDOMImplementation:'XML 3.0 XPath 3.0'    
    "

    "Created: / 04-08-2005 / 12:05:59 / janfrog"
! !

!DOMImplementationRegistry class methodsFor:'utilities'!

domImplementations

    ^DOMImplementation allSubclasses collect:[:implClass|implClass default]

    "Created: / 04-08-2005 / 12:18:43 / janfrog"
!

parseFeatureString:featureString

    "Answers array required features. Each element in array
     is two-element array with feature name and feature version
     asStrings"

    | tokens featureArray|
    tokens := (featureString tokensBasedOn:(Character space)) reject:[:t|t isEmpty].
    tokens size even ifFalse:[
        DOMException 
            raiseErrorString:'Invalid feature string: "',featureString,'"'
            withCode:#SYNTAX_ERR
    ].
    featureArray := OrderedCollection new:(tokens size / 2).
    tokens pairWiseDo:[:feature :version|
        | modifiedFeature |
        modifiedFeature := (feature first = $+) 
                            ifTrue:[feature copyFrom:2]
                            ifFalse:[feature].
        featureArray add:(Array with:modifiedFeature with:version)
    ].
    ^featureArray asArray

    "
        DOMImplementationRegistry parseFeatureString:'XML 3.0'
        DOMImplementationRegistry parseFeatureString:'XML 3.0 +XPath 2.0'
        DOMImplementationRegistry parseFeatureString:'XML 3.0 XPath'

    "

    "Created: / 04-08-2005 / 12:15:30 / janfrog"
! !

!DOMImplementationRegistry class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOMImplementationRegistry.st,v 1.4 2006-12-24 10:20:24 stillj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
