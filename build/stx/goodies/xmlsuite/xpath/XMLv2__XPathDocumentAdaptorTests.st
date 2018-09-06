"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#XPathDocumentAdaptorTests
	instanceVariableNames:'documentAdaptor'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Tests'
!


!XPathDocumentAdaptorTests class methodsFor:'defaults'!

testedURI
    ^'file://bookstore.xml'.

    "Created: / 16-11-2006 / 23:08:32 / janfrog"
! !

!XPathDocumentAdaptorTests class methodsFor:'test documents'!

bookstore

    ^'<bookstore xmlns="urn:xmlsuite:bookstore:ns"><book><title lang="eng" xmlns:ns2="urn:xmlsuite:bookstore:ns2" ns2:withPictures="yes">Harry Potter</title><price>29.99</price><parentalAdvisory>50+</parentalAdvisory><description></description></book><book><title lang="eng">Learning XML</title><price>39.95</price></book><book><title>1984</title><price>19.84</price></book></bookstore>'

    "Created: / 16-11-2006 / 23:19:29 / janfrog"
    "Modified: / 10-12-2006 / 19:56:15 / janfrog"
! !

!XPathDocumentAdaptorTests class methodsFor:'testing'!

isAbstract

    ^self == XPathDocumentAdaptorTests

    "Created: / 16-11-2006 / 23:09:11 / janfrog"
! !

!XPathDocumentAdaptorTests methodsFor:'helpers'!

apply: collection

    ^self apply: collection to: documentAdaptor document

    "Created: / 16-11-2006 / 23:27:17 / janfrog"
    "Modified: / 21-11-2006 / 23:20:41 / janfrog"
!

apply: collection to: node

    ^collection 
        inject:node
        into:[:nodeIdOrCollection :selector|
            nodeIdOrCollection isCollection
                ifTrue:[nodeIdOrCollection perform:selector]
                ifFalse:[documentAdaptor perform:selector with:nodeIdOrCollection]]

    "Created: / 21-11-2006 / 23:20:22 / janfrog"
! !

!XPathDocumentAdaptorTests methodsFor:'initialization & release'!

createDocumentAdaptor

    self subclassResponsibility

    "Created: / 16-11-2006 / 23:22:53 / janfrog"
!

setUp

    documentAdaptor := self createDocumentAdaptor.

    "Created: / 16-11-2006 / 23:08:32 / janfrog"
!

tearDown

    documentAdaptor releaseResources

    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 31-10-2007 / 10:25:03 / janfrog"
! !

!XPathDocumentAdaptorTests methodsFor:'tests - misc'!

test_invalid_id

    self 
        should:[documentAdaptor xpathChildOf:nil]
        raise: XPathInvalidNodeIdError

    "Created: / 10-12-2006 / 19:53:21 / janfrog"
!

test_releaseResources

    documentAdaptor releaseResources. 
    self 
        should:[documentAdaptor xpathDocument]
        raise: XPathDocumentAdaptorReleasedError

    "Created: / 10-12-2006 / 19:52:01 / janfrog"
! !

!XPathDocumentAdaptorTests methodsFor:'tests - xpath axes'!

testAncestor
    "Selects all ancestors (parent, grandparent, etc.) of the current node"

    | childNode ancestorsCollection |

    childNode := self apply:#(xpathChildOf: first 
                              xpathChildOf: first 
                              xpathChildOf: first ).
        "first item xpathChild first item xpathChild first item xpathChild first item."
    ancestorsCollection := documentAdaptor xpathAncestorOf: childNode.

    self assert: ancestorsCollection size = 3.

    "reverse document order"
    self assert:(documentAdaptor xpathIsDocument: ancestorsCollection third ). 
    self assert:(documentAdaptor xpathNameOf: ancestorsCollection second) = 'bookstore'.
    self assert:(documentAdaptor xpathIsElement: ancestorsCollection second).
    self assert:(documentAdaptor xpathNameOf: ancestorsCollection first) = 'book'.
    self assert:(documentAdaptor xpathIsElement: ancestorsCollection first).

    childNode := self apply:#().
        "(XQueryAccessedNode new documentAdaptor:documentAdaptor; xpathDocument) first item."
    ancestorsCollection := documentAdaptor xpathAncestorOf: childNode.

    self assert: ancestorsCollection size = 0.

    "Modified: / 02-11-2006 / 12:56:36 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 21-11-2006 / 23:28:04 / janfrog"
!

testAncestorOrSelf
    "Selects all ancestors (parent, grandparent, etc.) of the current node and the current node itself"

    | childNode ancestorsCollection |

    childNode := self apply:#(xpathChildOf: first "root element"
                              xpathChildOf: first 
                              xpathChildOf: first ).
    ancestorsCollection := documentAdaptor xpathAncestorOrSelfOf: childNode.

    self assert: ancestorsCollection size = 4.

    "reverse document order"
    self assert:(documentAdaptor xpathIsDocument: ancestorsCollection fourth ).
    self assert:(documentAdaptor xpathNameOf: ancestorsCollection third  ) = 'bookstore'.
    self assert:(documentAdaptor xpathIsElement: ancestorsCollection third  ).
    self assert:(documentAdaptor xpathNameOf: ancestorsCollection second  ) = 'book'.
    self assert:(documentAdaptor xpathIsElement: ancestorsCollection second  ).
    self assert:(documentAdaptor xpathNameOf: ancestorsCollection first  ) = 'title'.
    self assert:(documentAdaptor xpathIsElement: ancestorsCollection first  ).

    childNode := self apply:#().
    ancestorsCollection := documentAdaptor xpathAncestorOrSelfOf:childNode .

    self assert: ancestorsCollection size = 1.

    "reverse document order"
    self assert:(documentAdaptor xpathIsDocument:ancestorsCollection first).

    "Modified: / 02-11-2006 / 12:57:00 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 21-11-2006 / 23:04:10 / janfrog"
!

testAttribute
    "Selects all attributes of the current node"

    | childNode attributesCollection attributeNode |

    childNode := self apply:#(xpathChildOf: first "root element"
                              xpathChildOf: first 
                              xpathChildOf: first ).
    attributesCollection := documentAdaptor xpathAttributeOf:childNode.

    self assert: attributesCollection size = 2.

    self assert:(attributesCollection anySatisfy:
                    [:node | (documentAdaptor xpathNameOf:node) = 'lang' 
                        and:[(documentAdaptor xpathValueOf:node) = 'eng']]).

    self assert:(attributesCollection anySatisfy:
                    [:node | (documentAdaptor xpathNameOf:node) = 'ns2:withPictures' 
                        and:[(documentAdaptor xpathValueOf:node) = 'yes']]).

    attributeNode := attributesCollection detect:
                        [:node | (documentAdaptor xpathNameOf:node) = 'lang'].

    " TODO - nikoli podle XDM
    self should: [ attributeNodeHandlingCollection := documentAdaptor xpathAncestorOf: attributeNode. ] raise: Exception.
    "
    " TODO - mozna ano, mozna ne
    self should: [ attributeNodeHandlingCollection := documentAdaptor xpathFollowingSibling. ] raise: Exception.
    "

    childNode := self apply:#(xpathChildOf: first "root element"
                              xpathChildOf: third 
                              xpathChildOf: first ).


    "
    (XQueryAccessedNode new documentAdaptor:documentAdaptor; xpathDocument) 
    xpathChild first item 
    xpathChild third item 
    xpathChild first item."


    attributesCollection := documentAdaptor xpathAttributeOf:childNode.

    self assert: attributesCollection size = 0.

    "Modified: / 02-11-2006 / 12:55:40 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 10-12-2006 / 19:57:02 / janfrog"
!

testChild
    "Selects all children of the current node"

    | parentNode childrenCollection anotherChildrenCollection |

    parentNode := self apply:#(
                                xpathChildOf: first
                                xpathChildOf: first
                                ).

    childrenCollection := documentAdaptor xpathChildOf:parentNode.

    self assert: childrenCollection size = 4.

    "document order"
    self assert:(documentAdaptor xpathNameOf: childrenCollection first ) = 'title'.
    self assert:(documentAdaptor xpathIsElement: childrenCollection first ).
    self assert:(documentAdaptor xpathNameOf: childrenCollection second ) = 'price'.
    self assert:(documentAdaptor xpathIsElement: childrenCollection second ).
    self assert:(documentAdaptor xpathNameOf: childrenCollection third  ) = 'parentalAdvisory'.
    self assert:(documentAdaptor xpathIsElement: childrenCollection third ).
    self assert:(documentAdaptor xpathNameOf: childrenCollection fourth ) = 'description'.
    self assert:(documentAdaptor xpathIsElement: childrenCollection fourth).

    anotherChildrenCollection := documentAdaptor xpathChildOf:childrenCollection first.

    self assert: anotherChildrenCollection size = 1.

    self assert:(documentAdaptor xpathValueOf: anotherChildrenCollection first) = 'Harry Potter'.
    self assert:(documentAdaptor xpathIsText: anotherChildrenCollection first).

    anotherChildrenCollection := documentAdaptor xpathChildOf: anotherChildrenCollection first.

    self assert: anotherChildrenCollection size = 0.

    anotherChildrenCollection := documentAdaptor xpathChildOf: childrenCollection fourth.

    self assert: anotherChildrenCollection size = 0.

    "Modified: / 02-11-2006 / 12:57:42 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 21-11-2006 / 23:15:30 / janfrog"
!

testDescendant
    "Selects all descendants (children, grandchildren, etc.) of the current node"

    | parentNode descendantsCollection anotherDescendantsCollection |

    parentNode := self apply:#(
                                xpathChildOf: first
                                xpathChildOf: first
                                 ).
    descendantsCollection := documentAdaptor xpathDescendantOf: parentNode.

    self assert: descendantsCollection size = 7.

    "document order"
    self assert:(documentAdaptor xpathNameOf:  descendantsCollection first  ) = 'title'.
    self assert:(documentAdaptor xpathIsElement: descendantsCollection first  ).
    self assert:(documentAdaptor xpathValueOf: descendantsCollection second  ) = 'Harry Potter'.
    self assert:(documentAdaptor xpathIsText: descendantsCollection second  ).
    self assert:(documentAdaptor xpathNameOf: descendantsCollection third  ) = 'price'.
    self assert:(documentAdaptor xpathIsElement: descendantsCollection third  ).
    self assert:(documentAdaptor xpathValueOf: descendantsCollection fourth  ) = '29.99'.
    self assert:(documentAdaptor xpathIsText: descendantsCollection fourth  ).
    self assert:(documentAdaptor xpathNameOf: descendantsCollection fifth  ) = 'parentalAdvisory'.
    self assert:(documentAdaptor xpathIsElement: descendantsCollection fifth  ).
    self assert:(documentAdaptor xpathValueOf: descendantsCollection sixth  ) = '50+'.
    self assert:(documentAdaptor xpathIsText: descendantsCollection sixth  ).
    self assert:(documentAdaptor xpathNameOf: descendantsCollection seventh  ) = 'description'.
    self assert:(documentAdaptor xpathIsElement: descendantsCollection seventh  ).

    anotherDescendantsCollection := documentAdaptor xpathDescendantOf: descendantsCollection fifth.

    self assert: anotherDescendantsCollection size = 1.

    anotherDescendantsCollection := documentAdaptor xpathDescendantOf:descendantsCollection sixth.

    self assert: anotherDescendantsCollection size = 0.

    anotherDescendantsCollection := documentAdaptor xpathDescendantOf:descendantsCollection seventh.

    self assert: anotherDescendantsCollection size = 0.

    "Modified: / 02-11-2006 / 12:58:07 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 07-12-2006 / 00:18:57 / janfrog"
!

testDescendantOrSelf
    "Selects all descendants (children, grandchildren, etc.) of the current node and the current node itself"

    | parentNode descendantsCollection anotherDescendantsCollection |

    parentNode := self apply:#(
                                xpathChildOf: first
                                xpathChildOf: second
                                     ).
    descendantsCollection :=  documentAdaptor xpathDescendantOrSelfOf: parentNode .

    self assert: descendantsCollection size = 5.

    "document order"
    self assert:(documentAdaptor xpathNameOf: descendantsCollection first) = 'book'.
    self assert:(documentAdaptor xpathIsElement: descendantsCollection first ).
    self assert:(documentAdaptor xpathNameOf: descendantsCollection second) = 'title'.
    self assert:(documentAdaptor xpathIsElement: descendantsCollection second).
    self assert:(documentAdaptor xpathValueOf: descendantsCollection third) = 'Learning XML'.
    self assert:(documentAdaptor xpathIsText: descendantsCollection third).
    self assert:(documentAdaptor xpathNameOf: descendantsCollection fourth) = 'price'.
    self assert:(documentAdaptor xpathIsElement: descendantsCollection fourth).
    self assert:(documentAdaptor xpathValueOf: descendantsCollection fifth) = '39.95'.
    self assert:(documentAdaptor xpathIsText: descendantsCollection fifth).

    anotherDescendantsCollection := documentAdaptor xpathDescendantOrSelfOf: descendantsCollection fourth.

    self assert: anotherDescendantsCollection size = 2.

    anotherDescendantsCollection :=  documentAdaptor xpathDescendantOrSelfOf: descendantsCollection fifth.

    self assert: anotherDescendantsCollection size = 1.

    "Modified: / 02-11-2006 / 12:58:24 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 07-12-2006 / 00:22:50 / janfrog"
!

testDocument
    "Retrieves document element of the document"

    | document |

    document := self apply:#().

    self assert:(documentAdaptor xpathIsDocument:document).

    "Modified: / 28-10-2006 / 23:37:11 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 21-11-2006 / 23:16:51 / janfrog"
!

testFollowing
    "Selects everything in the document after the closing tag of the current node"

    | node followingsCollection |

    node := self apply:#(xpathChildOf: first 
                         xpathChildOf: second 
                         xpathChildOf: second ).

    self assert:(documentAdaptor xpathNameOf: node) = 'price'.
    self assert:(documentAdaptor xpathIsElement: node).

    followingsCollection := documentAdaptor xpathFollowingOf: node.

    self assert: followingsCollection size = 5.

    "document order"
    self assert:(documentAdaptor xpathNameOf:  followingsCollection first ) = 'book'.
    self assert:(documentAdaptor xpathIsElement: followingsCollection first ).
    self assert:(documentAdaptor xpathNameOf:  followingsCollection second) = 'title'.
    self assert:(documentAdaptor xpathIsElement: followingsCollection second).
    self assert:(documentAdaptor xpathValueOf: followingsCollection third) = '1984'.
    self assert:(documentAdaptor xpathIsText: followingsCollection third).
    self assert:(documentAdaptor xpathNameOf: followingsCollection fourth) = 'price'.
    self assert:(documentAdaptor xpathIsElement: followingsCollection fourth).
    self assert:(documentAdaptor xpathValueOf: followingsCollection fifth) = '19.84'.
    self assert:(documentAdaptor xpathIsText: followingsCollection fifth).

    node := self apply:#(xpathChildOf: first 
                         xpathChildOf: third 
                         xpathChildOf: second ).

    "
    node := (XQueryAccessedNode new documentAdaptor:documentAdaptor; xpathDocument) first item xpathChild first item xpathChild third item xpathChild second item.
    "
    self assert:(documentAdaptor xpathNameOf: node ) = 'price'.
    self assert:(documentAdaptor xpathIsElement: node ).

    followingsCollection := documentAdaptor xpathFollowingOf:node .

    self assert: followingsCollection size = 0.

    "Modified: / 02-11-2006 / 12:58:59 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 21-11-2006 / 23:33:12 / janfrog"
!

testFollowingSibling
    "Selects all siblings after the current node"

    | node followingSiblingsCollection anotherFollowingSiblingsCollection |

    node := self apply:#(
                                xpathChildOf: first
                                xpathChildOf: first
                                xpathChildOf: first
                                  ).

    self assert:(documentAdaptor xpathNameOf: node ) = 'title'.
    self assert:(documentAdaptor xpathIsElement: node).

    followingSiblingsCollection :=documentAdaptor xpathFollowingSiblingOf: node .

    self assert: followingSiblingsCollection size = 3.

    "document order"
    self assert:(documentAdaptor xpathNameOf: followingSiblingsCollection first ) = 'price'.
    self assert:(documentAdaptor xpathIsElement: followingSiblingsCollection first).
    self assert:(documentAdaptor xpathNameOf: followingSiblingsCollection second ) = 'parentalAdvisory'.
    self assert:(documentAdaptor xpathIsElement: followingSiblingsCollection second).
    self assert:(documentAdaptor xpathNameOf: followingSiblingsCollection third ) = 'description'.
    self assert:(documentAdaptor xpathIsElement: followingSiblingsCollection third).

    anotherFollowingSiblingsCollection := documentAdaptor xpathFollowingSiblingOf: followingSiblingsCollection third .

    self assert: anotherFollowingSiblingsCollection size = 0.

    "Modified: / 02-11-2006 / 13:29:37 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 07-12-2006 / 00:27:22 / janfrog"
!

testParent
    "Selects the parent of the current node"

    | childrenCollection parentNode documentNode |

    childrenCollection := self apply:#(xpathChildOf: first
                                       xpathChildOf: ).
    parentNode := documentAdaptor xpathParentOf:childrenCollection first.

    self assert:(documentAdaptor xpathIsElement:parentNode).
    self assert:(documentAdaptor xpathNameOf: parentNode) = 'bookstore'.

    "parentNode := dataAccessor to: childrenCollection apply:#(first getChildPointersOf: first getChildPointersOf: first getParentPointerOf:)."

    parentNode := self apply:#(xpathChildOf: first
                               xpathChildOf: first
                               xpathChildOf: first).


    self assert:(documentAdaptor xpathIsElement:parentNode).
    self assert:(documentAdaptor xpathNameOf: parentNode) = 'title'.

    documentNode := self apply:#().
    parentNode := documentAdaptor xpathParentOf:documentNode . 

    self assert: parentNode isNil

    "Modified: / 02-11-2006 / 13:29:52 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 21-11-2006 / 23:23:21 / janfrog"
!

testPreceding
    "Selects everything in the document that is before the start tag of the current node"

    | node precedingsCollection |

    node := self apply:#(xpathChildOf: first 
                         xpathChildOf: second 
                         xpathChildOf: second).

    self assert:(documentAdaptor xpathNameOf: node) = 'price'.
    self assert:(documentAdaptor xpathIsElement: node).

    precedingsCollection := documentAdaptor xpathPrecedingOf: node.

    self assert: precedingsCollection size = 10.

    "document order"
    self assert:(documentAdaptor xpathNameOf: precedingsCollection first) = 'title'.
    self assert:(documentAdaptor xpathIsElement: precedingsCollection first).
    self assert:(documentAdaptor xpathValueOf: precedingsCollection second) = 'Learning XML'.
    self assert:(documentAdaptor xpathIsText: precedingsCollection second).
    self assert:(documentAdaptor xpathNameOf: precedingsCollection third) = 'book'.
    self assert:(documentAdaptor xpathIsElement: precedingsCollection third).
    self assert:(documentAdaptor xpathNameOf: precedingsCollection fourth) = 'title'.
    self assert:(documentAdaptor xpathIsElement: precedingsCollection fourth).
    self assert:(documentAdaptor xpathValueOf: precedingsCollection fifth) = 'Harry Potter'.
    self assert:(documentAdaptor xpathIsText: precedingsCollection fifth).
    self assert:(documentAdaptor xpathNameOf: precedingsCollection sixth) = 'price'.
    self assert:(documentAdaptor xpathIsElement: precedingsCollection sixth).
    self assert:(documentAdaptor xpathValueOf: precedingsCollection seventh) = '29.99'.
    self assert:(documentAdaptor xpathIsText: precedingsCollection seventh).
    self assert:(documentAdaptor xpathNameOf: (precedingsCollection at:8)) = 'parentalAdvisory'.
    self assert:(documentAdaptor xpathIsElement: (precedingsCollection at:8)).
    self assert:(documentAdaptor xpathValueOf: (precedingsCollection at:9)) = '50+'.
    self assert:(documentAdaptor xpathIsText: (precedingsCollection at:9)).
    self assert:(documentAdaptor xpathNameOf: (precedingsCollection at:10)) = 'description'.
    self assert:(documentAdaptor xpathIsElement: (precedingsCollection at:10)).

    node := self apply:#().
    precedingsCollection := documentAdaptor xpathPrecedingOf:  node .

    self assert: precedingsCollection size = 0.

    node := (documentAdaptor xpathChildOf:node) first .
    precedingsCollection := documentAdaptor xpathPrecedingOf:  node.

    self assert: precedingsCollection size = 0.

    "Modified: / 02-11-2006 / 13:52:09 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 07-12-2006 / 00:34:56 / janfrog"
!

testPrecedingSibling
    "Selects all siblings before the current node"

    | node precedingSiblingsCollection |

    node := self apply:#(xpathChildOf: first 
                         xpathChildOf: second 
                         xpathChildOf: second).


    self assert:(documentAdaptor xpathNameOf: node) = 'price'.
    self assert:(documentAdaptor xpathIsElement: node).

    precedingSiblingsCollection := documentAdaptor xpathPrecedingSiblingOf: node.

    self assert: precedingSiblingsCollection size = 1.

    self assert:(documentAdaptor xpathNameOf: precedingSiblingsCollection first ) = 'title'.
    self assert:(documentAdaptor xpathIsElement: precedingSiblingsCollection first).

    node := self apply:#().
    precedingSiblingsCollection := documentAdaptor xpathPrecedingSiblingOf: node.

    self assert: precedingSiblingsCollection size = 0.

    node := (documentAdaptor xpathChildOf: node) first.
    precedingSiblingsCollection := documentAdaptor xpathPrecedingSiblingOf: node.

    self assert: precedingSiblingsCollection size = 0.

    "Modified: / 02-11-2006 / 13:52:32 / ked"
    "Created: / 16-11-2006 / 23:08:32 / janfrog"
    "Modified: / 07-12-2006 / 00:37:36 / janfrog"
! !

!XPathDocumentAdaptorTests methodsFor:'tests - xpath values'!

testLocalName

    | node |
    node := self apply:#(xpathChildOf: first).

    self assert:(documentAdaptor xpathLocalNameOf:node) = 'bookstore'.


    node := self apply:#(xpathChildOf: first
                         xpathChildOf: first
                         xpathChildOf: first
                         xpathAttributeOf: second).

    self assert:(documentAdaptor xpathLocalNameOf:node) = 'withPictures'.

    "Created: / 10-12-2006 / 19:57:58 / janfrog"
!

testNamespace

    | node |
    node := self apply:#(xpathChildOf: first).

    self assert:(documentAdaptor xpathNamespaceOf:node) = 'urn:xmlsuite:bookstore:ns'.

    node := self apply:#(xpathChildOf: first
                         xpathChildOf: first
                         xpathChildOf: first
                         xpathAttributeOf: second).

    self assert:(documentAdaptor xpathNamespaceOf:node) = 'urn:xmlsuite:bookstore:ns2'.

    "Created: / 10-12-2006 / 19:59:19 / janfrog"
! !

!XPathDocumentAdaptorTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathDocumentAdaptorTests.st,v 1.5 2007-10-31 09:38:48 vranyj1 Exp $'
! !
