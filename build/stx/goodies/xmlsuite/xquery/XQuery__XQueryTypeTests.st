"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TestCase subclass:#XQueryTypeTests
	instanceVariableNames:'interpreter'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests'
!


!XQueryTypeTests class methodsFor:'defaults'!

attributesURI
    ^'file:///attributes.xml'.

    "Created: / 30-04-2009 / 19:49:25 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 28-12-2009 / 16:34:36 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testedURI
    ^'file:///bookstore.xml'.

    "Created: / 30-04-2009 / 19:06:55 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryTypeTests methodsFor:'defaults'!

attributesURI
    ^'file:///attr.xml'.

    "Created: / 30-04-2009 / 19:07:40 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryTypeTests methodsFor:'initialization & release'!

setUp

    interpreter := XQueryInterpreter new
                        openPerseusDebuggerOnError: false;
                        setDocumentProvider: XQueryDocumentProviderTestResource current;
                        yourself

    "Modified: / 27-06-2009 / 19:26:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

tearDown

    interpreter := nil.

! !

!XQueryTypeTests methodsFor:'tests'!

test_01

    self 
        assert: (TypeFactory isType: 'element' subtypeOf: 'node');
        assert: (TypeFactory isType: 'xs:integer' subtypeOf: 'xs:anyAtomicType');
        assert: (TypeFactory isType: 'xs:integer' subtypeOf: 'xs:integer').

    "Created: / 05-12-2007 / 14:59:24 / janfrog"
    "Modified: / 07-11-2009 / 23:58:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_02

    self 
        assert: (TypeFactory isType:'xs:integer' subtypeOf: 'xs:boolean') not.

    "Created: / 05-12-2007 / 15:00:11 / janfrog"
    "Modified: / 07-11-2009 / 23:58:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_decimal_format
    self             
        assert:(AtomicItem withValue: -1.1234 asType:'xs:decimal') asString 
                    = '-1.1234';
        assert:(AtomicItem withValue: -0.0E0 asType:'xs:decimal') asString 
                    = '0'.

    "Created: / 17-11-2009 / 17:40:53 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 18:55:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_float_format
    self             
        assert:(AtomicItem withValue:0.000001 asType:'xs:float') asString 
                    = '0.000001';
        assert:(AtomicItem withValue:-1.75e-3 asType:'xs:float') asString 
                    = '-0.00175';
        assert:(AtomicItem withValue:0.0 asType:'xs:float') asString 
                    = '0';
        assert:(AtomicItem withValue:-0.0e1 asType:'xs:float') asString 
                    = '-0';
        assert:(AtomicItem withValue:-10.0 asType:'xs:float') asString 
                    = '-10';
        assert:(AtomicItem withValue:100.0 asType:'xs:float') asString 
                    = '100';
        assert:(AtomicItem withValue:123.456 asType:'xs:float') asString 
                    = '123.456';
        assert:(AtomicItem withValue:100000.0 asType:'xs:float') asString 
                    = '100000';
        assert:(AtomicItem withValue:1000000.0 asType:'xs:float') asString 
                    = '1.0E6';
        assert:(AtomicItem withValue:0.0000001 asType:'xs:float') asString 
                    = '1.0E-7'.

    "Created: / 10-11-2009 / 12:57:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 19:07:10 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_fn_attribute
    | result |

    "constructed node attribute test"
    result := interpreter basicEvaluate: 
        '<root><a attr="1" /> <a attr="2" /> <c attr="3"/></root>/attribute()'.
    "constructed node does not implement attributes yet"
    "/    self assert: (result size = 3).

    result := interpreter basicEvaluate: 'doc("' , self class attributesURI 
                        , '")//a/attribute()'.

    self assert: (result size = 2).
    self assert: (result first dmTypedValue = '1').
    self assert: (result second dmTypedValue = '2').
    "TODO
        - attribute(name) function
    "

    "Created: / 18-04-2009 / 20:41:52 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 19:27:40 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_fn_element
    | document result |

    document := '<root><a /> <b /> <a /> <c /></root>'.
    result := interpreter basicEvaluate: document, '//element()'.
    self assert: (result size = 4).
    result := interpreter basicEvaluate: document, '//element(a)'.
    self assert: (result size = 2).
    self assert: (result first asString = '<a/>').
    self assert: (result second asString = '<a/>').

    "Created: / 18-04-2009 / 20:34:00 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 27-06-2009 / 19:28:43 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_fn_node_kind
    | document result |
    " TODO  "
"/    document := 'dm:node-kind(<a />)'.
"/    result := interpreter basicEvaluate: document.
"/    self assert: (result size = 1).
"/    self assert: (result first asString = 'element').
"/
"/    document := 'dm:node-kind(doc("' , self class attributesURI, '")/root/a/attribute()[1])'.
"/    result := interpreter basicEvaluate: document.
"/    self assert: (result size = 1).
"/    self assert: (result first asString = 'attribute').
"/
"/    document := 'dm:node-kind(doc("' , self class attributesURI, '")/root/a/text()[1])'.
"/    result := interpreter basicEvaluate: document.
"/    self assert: (result size = 1).
"/    self assert: (result first asString = 'text').
"/
"/    document := 'dm:node-kind(doc("' , self class attributesURI, '"))'.
"/    result := interpreter basicEvaluate: document.
"/    self assert: (result size = 1).
"/    self assert: (result first asString = 'document').

    "Created: / 30-04-2009 / 17:30:47 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-07-2009 / 23:21:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_instanceof_01
    |document result|

    document := '<root><a attr="1"/> <b /> <a /> <c /></root>'.
    result := interpreter 
                basicEvaluate:document , '//node()[1] instance of element()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'true').
    self assert:(result first type = 'xs:boolean').
    result := interpreter basicEvaluate:'<root /> instance of element()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'true').
    self assert:(result first type = 'xs:boolean').
    result := interpreter basicEvaluate:'"hello" instance of node()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'false').
    self assert:(result first type = 'xs:boolean').
    result := interpreter 
                basicEvaluate:document , '//node()[1] instance of attribute()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'false').
    self assert:(result first type = 'xs:boolean').
    result := interpreter 
                basicEvaluate:document , '//node()[1] instance of text()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'false').
    self assert:(result first type = 'xs:boolean').
    result := interpreter basicEvaluate:'doc("' , self class attributesURI 
                        , '")//a/attribute()[1] instance of attribute()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'true').
    self assert:(result first type = 'xs:boolean').

    "Created: / 09-05-2009 / 22:35:42 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 19:32:40 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_instanceof_02
    |result|

    result := interpreter basicEvaluate:'"hello" instance of node()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'false').
    self assert:(result first type = 'xs:boolean').
    result := interpreter basicEvaluate:'1 instance of node()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'false').
    self assert:result first type = 'xs:boolean'.
    result := interpreter basicEvaluate:'<root /> instance of node()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'true').
    self assert:result first type = 'xs:boolean'.
    result := interpreter basicEvaluate:'"hello" instance of item()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'true').
    self assert:result first type = 'xs:boolean'.
    result := interpreter basicEvaluate:'"hello" instance of xs:integer'.
    self assert:(result size = 1).
    self assert:(result first asString = 'false').
    self assert:result first type = 'xs:boolean'.
    result := interpreter 
                basicEvaluate:'"hello" instance of empty-sequence()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'false').
    self assert:result first type = 'xs:boolean'.
    result := interpreter basicEvaluate:'() instance of empty-sequence()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'true').
    self assert:result first type = 'xs:boolean'.
    result := interpreter basicEvaluate:'(1,2,3) instance of item()'.
    self assert:(result size = 1).
    self assert:(result first asString = 'false').
    self assert:result first type = 'xs:boolean'.
    result := interpreter basicEvaluate:'(1,2,3) instance of xs:boolean*'.
    self assert:(result size = 1).
    self assert:(result first asString = 'false').
    self assert:result first type = 'xs:boolean'.

    "Created: / 10-05-2009 / 18:05:03 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 19:33:03 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryTypeTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
