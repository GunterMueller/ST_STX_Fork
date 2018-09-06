"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TestCase subclass:#XQueryInterpreterTests
	instanceVariableNames:'interpreter bookstoreDocURI namespacesDocURI attributesDocURI'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests'
!

!XQueryInterpreterTests class methodsFor:'documentation'!

documentation
"
    2 tests fails...

    [author:]

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!XQueryInterpreterTests class methodsFor:'accessing'!

resources

    ^Array 
        with:XQueryDocumentProviderTestResource

    "Created: / 06-04-2007 / 17:18:09 / janfrog"
! !

!XQueryInterpreterTests class methodsFor:'defaults'!

attributesURI
    ^'file:///attr.xml'.

    "Created: / 30-04-2009 / 19:07:40 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testedURI
    ^'file:///bookstore.xml'.

    "Created: / 02-12-2006 / 12:11:18 / ked"
    "Modified: / 24-12-2006 / 17:41:19 / janfrog"
! !

!XQueryInterpreterTests methodsFor:'initialization & release'!

setUp

    bookstoreDocURI := 'doc("file:///bookstore.xml")'.
    namespacesDocURI := 'doc("file:///namespaces.xml")'.
    attributesDocURI := 'doc("file:///attributes.xml")'.


    "interpreter := (XQueryInterpreter new)
                setDocumentProvider:XQueryDocumentProviderTestResource current;
                yourself."
    interpreter := (XQueryInterpreter new)
                setDocumentProvider: XQueryDocumentProviderTestResource current;
                openPerseusDebuggerOnError:false;
                                yourself.

    "Created: / 25-10-2006 / 09:08:14 / ked"
    "Modified: / 14-11-2007 / 12:23:58 / janfrog"
    "Modified: / 18-09-2008 / 16:45:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-06-2009 / 13:44:27 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:07:13 / Marek Susicky <susicm1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 13:22:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown

    interpreter := nil.    
    bookstoreDocURI := nil.

    "Created: / 25-10-2006 / 09:08:15 / ked"
    "Modified: / 18-09-2008 / 16:45:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:21:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XQueryInterpreterTests methodsFor:'tests'!

testAdditiveExpr
    |result|

    result := interpreter basicEvaluate:'1 + 2.0'.
    self assert:result size = 1.
    self assert:result first  = 3.0.

    result := interpreter basicEvaluate:'(1 + 2.0) instance of xs:decimal'.
    self assert:result size = 1.
    self assert:result first = true.

    "Modified: / 03-03-2007 / 11:04:23 / ked"
    "Created: / 29-03-2007 / 09:58:14 / janfrog"
    "Modified: / 05-12-2007 / 15:15:54 / janfrog"
    "Modified: / 18-09-2008 / 16:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-10-2009 / 20:29:43 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testDoubleLiteral
    |result|

    result := interpreter 
                basicEvaluate:'1.23e45 * 1'.
    self assert:result size = 1.
    self assert:result first = 1.23e45.

    result := interpreter basicEvaluate:'1.23e45 instance of xs:double'.
    self assert:result size = 1.
    self assert:result first = true.

    "Created: / 30-04-2009 / 20:48:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 19-10-2009 / 21:35:14 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testExpr
    |result|

    result := interpreter basicEvaluate:'1, 2, 3, 5 to 7'.
    self assert:result size = 6.

    result := interpreter basicEvaluate:'1 instance of xs:integer'.
    self assert:result size = 1.
    self assert:result first = true.

    result := interpreter basicEvaluate:'(1, 2, 3, 5 to 7) instance of xs:integer*'.
    self assert:result size = 1.
    self assert:result first = true.

    "Created: / 13-09-2006 / 16:28:01 / ked"
    "Modified: / 03-12-2006 / 13:36:01 / ked"
    "Modified: / 05-12-2007 / 15:29:47 / janfrog"
    "Modified: / 18-09-2008 / 16:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-10-2009 / 22:05:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testFunctionCall1
    |result|
    result := interpreter basicEvaluate:'fn:sum((3, 4, 5))'.
    self assert:result size = 1.
    self assert:result first = 12.


    result := interpreter basicEvaluate:'fn:sum((3, 4, 5)) instance of xs:integer'.
    self 
        assert:(result first = true).

    "Created: / 29-03-2007 / 09:58:14 / janfrog"
    "Modified: / 05-12-2007 / 15:37:05 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:30:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testFunctionCall2
    |result|

    result := interpreter basicEvaluate:'fn:boolean(())'.
    self assert:result size = 1.
    self assert:(result first isSubtypeOf: 'xs:boolean').
    self assert:result first = false.
    result := interpreter basicEvaluate:'fn:boolean(3)'.
    self assert:result size = 1.
    self assert:(result first isSubtypeOf: 'xs:boolean').
    self assert:result first = true.

    "Created: / 29-03-2007 / 09:58:14 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:31:31 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testIfExpr
    |result|

    result := interpreter 
                basicEvaluate:'if (1.1 eq 1 and 1 eq 1)
     then "TRUE"
     else if ("a" ne "a")
          then 1
          else 2'.
    self assert:result size = 1.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 2.

    "Created: / 13-09-2006 / 16:00:58 / ked"
    "Modified: / 03-12-2006 / 13:39:13 / ked"
    "Modified: / 05-12-2007 / 15:37:06 / janfrog"
    "Modified: / 18-09-2008 / 16:57:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:46:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testInvalidSyntax1
    "Code to test Parser recovery from invalid XQuerySyntax"
    Exception handle:
    [ :ex |
        self assert: true.
    ]
    do:
    [
        interpreter basicEvaluate:'for $x'.
        self assert: false.
    ].

    "Created: / 20-09-2009 / 14:52:19 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testInvalidSyntax2
    "Code to test Parser recovery from invalid XQuerySyntax"
    Exception handle:
    [ :ex |
        self assert: true.
    ]
    do:
    [
        interpreter basicEvaluate:'for $x in <a>text</a>'.
        self assert: false.
    ].

    "Created: / 20-09-2009 / 14:52:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testMultiplicativeExpr
    |result|

    result := interpreter basicEvaluate:'9 idiv 4'.
    self assert:result size = 1.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 2.

    "Created: / 13-09-2006 / 16:21:36 / ked"
    "Modified: / 03-12-2006 / 13:39:26 / ked"
    "Modified: / 05-12-2007 / 15:37:06 / janfrog"
    "Modified: / 18-09-2008 / 16:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:51:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testParenthesizedExpr
    |result|

    result := interpreter basicEvaluate:'5 * (2 + 4)'.
    self assert:result size = 1.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 30.
    result := interpreter basicEvaluate:'5 * 2 + 4'.
    self assert:result size = 1.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 14.

    "Created: / 13-09-2006 / 16:24:25 / ked"
    "Modified: / 03-12-2006 / 13:39:45 / ked"
    "Modified: / 05-12-2007 / 15:36:02 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:53:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testQuantifiedExpr
    |result|

    result := interpreter 
                basicEvaluate:'if (every $x in (1, 2, 3), $y in (2, 3, 4) satisfies $x + $y eq 4)
     then "TRUE"
     else "FALSE"'.
    self assert:result size = 1.
    self assert:(result first isSubtypeOf:'xs:string').
    self assert:result first = 'FALSE'.
    result := interpreter 
                basicEvaluate:'if (some $x in (1, 2, 3), $y in (2, 3, 4) satisfies $x + $y eq 4)
     then "TRUE"
     else "FALSE"'.
    self assert:result size = 1.
    self assert:(result first isSubtypeOf:'xs:string').
    self assert:result first = 'TRUE'.

    "Created: / 13-09-2006 / 17:02:10 / ked"
    "Modified: / 03-12-2006 / 13:42:32 / ked"
    "Modified: / 05-12-2007 / 15:38:52 / janfrog"
    "Modified: / 18-09-2008 / 16:57:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:53:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testRangeExpr
    |result i|

    result := interpreter basicEvaluate:'1 to 10'.
    self assert:result size = 10.
    i := 1.
    result do:[:item | 
        self assert:(result first isSubtypeOf:'xs:decimal').
        self assert:item = i.
        i := i + 1.
    ].

    "Created: / 13-09-2006 / 16:07:03 / ked"
    "Modified: / 03-12-2006 / 13:42:49 / ked"
    "Modified: / 05-12-2007 / 15:37:05 / janfrog"
    "Modified: / 18-09-2008 / 16:57:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 16:01:33 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreterTests methodsFor:'tests - FLWOR'!

testFLWORExpr1
    |result|

    result := interpreter basicEvaluate:'let $i := (1, 2, 3) return $i'.
    self assert:result size = 3.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 1.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result second = 2.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result third = 3.

    "Created: / 13-09-2006 / 16:29:35 / ked"
    "Modified: / 03-12-2006 / 13:36:19 / ked"
    "Modified: / 05-12-2007 / 15:30:14 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-10-2009 / 22:13:53 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testFLWORExpr2
    |result|

    result := interpreter basicEvaluate:'for $j in (4, 5, 6) return $j'.
    self assert:result size = 3.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 4.
    self assert:(result second isSubtypeOf:'xs:decimal').
    self assert:result second = 5.
    self assert:(result third isSubtypeOf:'xs:decimal').
    self assert:result third = 6.

    "Created: / 13-09-2006 / 16:42:20 / ked"
    "Modified: / 03-12-2006 / 13:36:40 / ked"
    "Modified: / 05-12-2007 / 15:30:37 / janfrog"
    "Modified: / 18-09-2008 / 16:57:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-10-2009 / 22:22:36 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testFLWORExpr3
    |result|

    result := interpreter 
                basicEvaluate:'for $i in (1, 2), $j in (3, 4) return ($i, $j)'.
    self assert:result size = 8.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 1.
    self assert:(result second isSubtypeOf:'xs:decimal').
    self assert:result second = 3.
    self assert:(result third isSubtypeOf:'xs:decimal').
    self assert:result third = 1.
    self assert:(result fourth isSubtypeOf:'xs:decimal').
    self assert:result fourth = 4.
    self assert:(result fifth isSubtypeOf:'xs:decimal').
    self assert:result fifth = 2.
    self assert:(result sixth isSubtypeOf:'xs:decimal').
    self assert:result sixth = 3.
    self assert:(result seventh isSubtypeOf:'xs:decimal').
    self assert:result seventh = 2.
    self assert:((result at:8) isSubtypeOf:'xs:decimal').
    self assert:(result at:8) = 4.

    "Created: / 13-09-2006 / 16:46:47 / ked"
    "Modified: / 03-12-2006 / 13:37:25 / ked"
    "Modified: / 05-12-2007 / 15:37:05 / janfrog"
    "Modified: / 18-09-2008 / 16:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 16:03:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testFLWORExpr4
    |result|

    result := interpreter 
                basicEvaluate:'let $i := 5,
         $j := 20 * $i
     return ($i, $j)'.
    self assert:result size = 2.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 5.
    self assert:(result second isSubtypeOf:'xs:decimal').
    self assert:result second = 100.

    "Created: / 13-09-2006 / 16:29:35 / ked"
    "Modified: / 03-12-2006 / 13:37:42 / ked"
    "Modified: / 05-12-2007 / 15:35:57 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-10-2009 / 22:32:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testFLWORExpr5
    |result|

    result := interpreter basicEvaluate:'for $a in (1 to 100) return $a'.
    self assert:result size = 100.
    1 to:100 do:[:i | 
        self assert:((result at:i) isSubtypeOf:'xs:decimal').
        self assert:(result at:i) = i.
    ].

    "Created: / 13-09-2006 / 16:54:50 / ked"
    "Modified: / 03-12-2006 / 13:43:25 / ked"
    "Modified: / 05-12-2007 / 15:35:57 / janfrog"
    "Modified: / 18-09-2008 / 16:57:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 16:04:17 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testFLWORExpr6
    |result|

    result := interpreter 
                basicEvaluate:'for $a at $b in (5, 10, 15) return ($b, $a)'.
    self assert:result size = 6.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 1.
    self assert:(result second isSubtypeOf:'xs:decimal').
    self assert:result second = 5.
    self assert:(result third isSubtypeOf:'xs:decimal').
    self assert:result third = 2.
    self assert:(result fourth isSubtypeOf:'xs:decimal').
    self assert:result fourth = 10.
    self assert:(result fifth isSubtypeOf:'xs:decimal').
    self assert:result fifth = 3.
    self assert:(result sixth isSubtypeOf:'xs:decimal').
    self assert:result sixth = 15.

    "Created: / 13-09-2006 / 16:57:10 / ked"
    "Modified: / 03-12-2006 / 13:43:34 / ked"
    "Modified: / 05-12-2007 / 15:36:04 / janfrog"
    "Modified: / 18-09-2008 / 16:57:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-10-2009 / 22:34:15 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testFLWORExpr7
    |result|

    result := interpreter 
                basicEvaluate:'for $a in (10, 15, 20, 25, 30)
     let $b := $a * 10
     where $b lt 230
     return
       if ($b mod 100 = 0)
       then ($b, "hundred :-)")
       else ($b, "no hundred :-(")'.
    self assert:result size = 6.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 100.
    self assert:(result second isSubtypeOf:'xs:string').
    self assert:result second = 'hundred :-)'.
    self assert:(result third isSubtypeOf:'xs:decimal').
    self assert:result third = 150.
    self assert:(result fourth isSubtypeOf:'xs:string').
    self assert:result fourth = 'no hundred :-('.
    self assert:(result fifth isSubtypeOf:'xs:decimal').
    self assert:result fifth = 200.
    self assert:(result sixth isSubtypeOf:'xs:string').
    self assert:result sixth = 'hundred :-)'.

    "Created: / 13-09-2006 / 17:00:01 / ked"
    "Modified: / 03-12-2006 / 13:39:00 / ked"
    "Modified: / 05-12-2007 / 15:38:52 / janfrog"
    "Modified: / 18-09-2008 / 16:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-10-2009 / 22:34:23 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreterTests methodsFor:'tests - arithmetic'!

test_arithmetic_additive_01
    |result|

    result := interpreter basicEvaluate:'1 + 2.0'.
    self assert:result size = 1.
    self assert:result first = 3.0.

    "Modified: / 03-12-2006 / 13:30:25 / ked"
    "Created: / 21-03-2007 / 14:02:10 / janfrog"
    "Modified: / 05-12-2007 / 15:45:46 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-10-2009 / 22:43:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_arithmetic_additive_02
    |result|

    result := interpreter basicEvaluate:'1 - 1'.
    self assert:result size = 1.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 0.

    "Modified: / 03-12-2006 / 13:30:25 / ked"
    "Created: / 21-03-2007 / 14:02:30 / janfrog"
    "Modified: / 05-12-2007 / 15:37:05 / janfrog"
    "Modified: / 18-09-2008 / 16:57:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-10-2009 / 22:07:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_arithmetic_multiplicative_01
    |result|

    result := interpreter basicEvaluate:'1 * 2'.
    self assert:result size = 1.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 2.

    "Modified: / 03-12-2006 / 13:30:25 / ked"
    "Created: / 21-03-2007 / 14:03:23 / janfrog"
    "Modified: / 05-12-2007 / 15:21:57 / janfrog"
    "Modified: / 18-09-2008 / 16:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-10-2009 / 22:06:45 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreterTests methodsFor:'tests - constructors'!

testConstructor1
    |result|

    result := interpreter basicEvaluate:'element a { "element a" }'.
    self assert:result size = 1.
    self 
        assert: result first dmNodeKind = 'element'.
    self assert:result first dmNodeName localName = 'a'.
    self assert:result first dmStringValue = 'element a'.

    "Created: / 22-11-2006 / 16:50:12 / ked"
    "Modified: / 03-12-2006 / 13:43:14 / ked"
    "Modified: / 05-12-2007 / 15:27:41 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 12:49:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testConstructor10
    | result |

    "TEST, if the parent was realy changed"
    result := interpreter basicEvaluate: '<myroot>{',bookstoreDocURI 
                        , '/bookstore/book}</myroot>/book/title/../..'.
    self assert: (result first xpathName = 'myroot').

    "Created: / 06-09-2009 / 20:08:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-09-2009 / 22:36:43 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:36:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testConstructor11
    | result  books |

    "Test appending accessed nodes to the constructed node"
    result := interpreter basicEvaluate: '<myroot>{', bookstoreDocURI 
                        , '/bookstore}</myroot>'.
    self assert: (result first xpathName = 'myroot').
    self assert: (result first dmChildren notEmpty).
    self assert: (result first xpathChild notEmpty).
    self 
        assert: (result first xpathChild first dmNodeName qName = 'bookstore').
    self assert: (result first xpathChild first dmNodeKind = 'element').
    books := result first xpathChild first xpathChild.
    self assert: (books size = 3).
    self assert: (books first dmNodeName qName = 'book').
    self assert: (books second dmNodeName qName = 'book').
    self assert: (books third dmNodeName qName = 'book').
    self assert: (books first xpathParent size = 1).
    self assert: (books first xpathParent first dmNodeKind = 'element').
    self 
        assert: (books first xpathParent first dmNodeName qName = 'bookstore').
    self 
        assert: (books first xpathParent first xpathParent first dmNodeName qName 
                = 'myroot').

    "TODO"

    "Created: / 03-10-2009 / 22:27:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 14:09:42 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:37:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testConstructor2
    |result resultChild resultAttribute|

    result := interpreter 
                basicEvaluate:'document { element a { attribute atr { "atr" }, element b {}, text { "element a" } } }'.
    self assert:result size = 1.
    self assert:result first dmNodeKind = 'document'.
    result := result first xpathChild.
    self assert:result size = 1.
    self assert:result first dmNodeKind = 'element'.
    self assert:result first dmNodeName localName = 'a'.
    resultChild := result first xpathChild.
    self assert:resultChild size = 2.
    self assert:resultChild first dmNodeKind = 'element'.
    self assert:resultChild first dmNodeName localName = 'b'.
    self assert:resultChild second xpathIsText.
    self assert:resultChild second dmStringValue = 'element a'.
    resultAttribute := result first xpathAttribute.
    self assert:resultAttribute size = 1.
    self assert:resultAttribute first dmNodeKind = 'attribute'.
    self assert:resultAttribute first dmNodeName localName = 'atr'.
    self assert:resultAttribute first dmTypedValue = 'atr'.

    "Created: / 22-11-2006 / 16:52:42 / ked"
    "Modified: / 03-03-2007 / 11:04:44 / ked"
    "Modified: / 18-11-2007 / 09:42:58 / janfrog"
    "Modified: / 18-09-2008 / 16:57:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 12:50:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testConstructor3
    | result |

    result := interpreter 
                basicEvaluate: 'document {
        for $i in ' , bookstoreDocURI 
                        , '/bookstore/book
        return element reduced-book {
              $i/title,
              $i/price,
              element reduced-price { $i/price * 0.9 }
            }
     }'.

    "TODO TODO TODO"

    "Created: / 22-11-2006 / 17:03:32 / ked"
    "Modified: / 02-12-2006 / 12:12:03 / ked"
    "Modified: / 24-12-2006 / 13:56:13 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:37:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testConstructor4
    |result|

    result := interpreter 
                basicEvaluate:'let $i := element a { element b { element c {} } }
     return $i//c/ancestor::*'.

    "TODO TODO TODO"

    "Created: / 22-11-2006 / 17:05:24 / ked"
    "Modified: / 24-12-2006 / 13:56:17 / janfrog"
    "Modified: / 18-09-2008 / 16:57:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

testConstructor5
    | result |

    result := interpreter basicEvaluate: 'for $i in ' , bookstoreDocURI 
                        , '/bookstore/book[3]
     return element { $i/title } { $i/@*, $i/* }'.

    "TODO TODO TODO"

    "Created: / 22-11-2006 / 17:07:50 / ked"
    "Modified: / 02-12-2006 / 12:12:20 / ked"
    "Modified: / 24-12-2006 / 13:56:23 / janfrog"
    "Modified: / 18-09-2008 / 16:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 14:54:24 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:37:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testConstructor6
    |result|

    result := interpreter 
                basicEvaluate:'<vycet>{ for $i in (1 to 20) where $i mod 3 eq 0 return <cislo>{ $i }</cislo> }</vycet>'.

    "TODO TODO TODO"

    "Created: / 22-11-2006 / 17:11:20 / ked"
    "Modified: / 24-12-2006 / 13:56:27 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

testConstructor7
    |result|

   "doc() function has to return more than one result item
        eg: <root>{doc('xmldb:attr.xml')/root/a}</root>
        which return two <a> elements"

    "TODO - test is not complete"
    result := interpreter
                basicEvaluate:'<root>{' , attributesDocURI 
                        , '/root/a}</root>/a'.
    self assert: (result size = 2).

    "Created: / 18-04-2009 / 20:54:48 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-04-2009 / 20:46:27 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 13:24:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testConstructor8
    |result|

    result := interpreter basicEvaluate:'<root><a>2a1</a></root>/a/text()'.
    self assert:(result size = 1).
    self assert:result first dmTypedValue = '2a1'.

    "Created: / 03-05-2009 / 11:06:43 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 17:36:13 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testConstructor9
    | result |

    "TEST, if the parent was realy changed"
    result := interpreter basicEvaluate: '<myroot>{' , bookstoreDocURI 
                        , '/bookstore/book}</myroot>/book'.
    self assert: (result size = 3).
    result := interpreter basicEvaluate: '<myroot>{' , bookstoreDocURI 
                        , '/bookstore/book}</myroot>/book/..'.
    self assert: (result first xpathName = 'myroot').

    "Created: / 06-09-2009 / 16:37:23 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-09-2009 / 17:52:55 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:37:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_constructor_07
    |result|

    result := interpreter basicEvaluate:'element a { attribute b { "bee" } }'.
    self assert:result size = 1.
    self assert:(result first dmNodeKind = 'element').
    self assert:result first dmNodeName qName = 'a'.
    self assert:result first dmAttributes size = 1.
    self assert:result first xpathAttribute first dmNodeName qName = 'b'.
    self assert:result first xpathAttribute first dmTypedValue = 'bee'.

    "Modified: / 03-12-2006 / 13:43:14 / ked"
    "Created: / 21-03-2007 / 15:59:55 / janfrog"
    "Modified: / 05-12-2007 / 15:47:38 / janfrog"
    "Modified: / 18-09-2008 / 16:57:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 21:48:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_direct_constructor_01
    |result|

    result := interpreter basicEvaluate:'<a/>'.
    self assert:result size = 1.
    self assert:(result first dmNodeKind = 'element'). 
    self assert:result first dmNodeName qName = 'a'.

    "Modified: / 03-12-2006 / 13:43:14 / ked"
    "Created: / 21-03-2007 / 16:16:27 / janfrog"
    "Modified: / 05-12-2007 / 15:47:38 / janfrog"
    "Modified: / 18-09-2008 / 16:57:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 21:49:12 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryInterpreterTests methodsFor:'tests - functions'!

test_function_fn_abs_01

    | result |

    result := interpreter evaluate:'
    abs(-1)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '1'

    "Created: / 26-12-2006 / 09:12:14 / janfrog"
    "Modified: / 18-09-2008 / 16:45:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_function_fn_abs_02

    | result |

    result := interpreter evaluate:'
    abs(0)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '0'

    "Created: / 26-12-2006 / 09:12:39 / janfrog"
    "Modified: / 18-09-2008 / 16:45:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_function_fn_abs_03

    | result |

    result := interpreter evaluate:'
    abs(0.1)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '0.1'

    "Created: / 26-12-2006 / 09:12:22 / janfrog"
    "Modified: / 18-09-2008 / 16:45:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_function_fn_abs_04

    | result |

    result := interpreter evaluate:'
    fn:abs(-1)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '1'

    "Created: / 28-12-2006 / 12:26:19 / janfrog"
    "Modified: / 18-09-2008 / 16:45:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_function_fn_abs_05

    | result |

    result := interpreter evaluate:'
    declare namespace fnx = "http://www.w3.org/2005/xpath-functions";
    fnx:abs(-1)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '1'

    "Created: / 28-12-2006 / 12:27:01 / janfrog"
    "Modified: / 18-09-2008 / 16:45:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_function_fn_base_uri_01
    | result |

    result := interpreter 
                basicEvaluate: 'fn:base-uri(' , bookstoreDocURI , ')'.

    "TODO: this test needs assertion"

    "Created: / 26-07-2009 / 20:27:54 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 12:13:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_function_fn_count_01

    | result |

    result := interpreter evaluate:'
    let $i := <a><b/><b/></a>
    return count($i//b)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '2'

    "Created: / 26-12-2006 / 09:10:06 / janfrog"
    "Modified: / 18-09-2008 / 16:45:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_function_fn_endsWith_01

    | result |

    result := interpreter evaluate:'
    fn:ends-with("Query","ry")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'true'

    "Created: / 03-05-2013 / 16:59:02 / houzvjir@fel.cvut.cz"
!

test_function_fn_endsWith_02

    | result |

    result := interpreter evaluate:'
    fn:ends-with("Query","uer")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'false'

    "Created: / 03-05-2013 / 16:59:58 / houzvjir@fel.cvut.cz"
!

test_function_fn_endsWith_03

    | result |

    result := interpreter evaluate:'
    fn:ends-with("Query","Y")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'false'

    "Created: / 03-05-2013 / 17:01:48 / houzvjir@fel.cvut.cz"
!

test_function_fn_endsWith_04

    | result |

    result := interpreter evaluate:'
    fn:ends-with("Query","")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'false'

    "Created: / 03-05-2013 / 17:03:23 / houzvjir@fel.cvut.cz"
!

test_function_fn_endsWith_05

    | result |

    result := interpreter evaluate:'
    fn:ends-with("","uer")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'false'

    "Created: / 03-05-2013 / 17:03:40 / houzvjir@fel.cvut.cz"
!

test_function_fn_endsWith_06

    | result |

    result := interpreter evaluate:'
    fn:ends-with("","uer")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'false'

    "Created: / 03-05-2013 / 17:04:14 / houzvjir@fel.cvut.cz"
!

test_function_fn_lowerCase_01

    | result |

    result := interpreter evaluate:'
    fn:lower-case("Query")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'query'

    "Created: / 05-05-2013 / 19:18:37 / houzvjir@fel.cvut.cz"
!

test_function_fn_lowerCase_02

    | result |

    result := interpreter evaluate:'
    fn:lower-case("qUERY")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'query'

    "Created: / 05-05-2013 / 19:24:23 / houzvjir@fel.cvut.cz"
!

test_function_fn_matches_01

    | result |

    result := interpreter evaluate:'
    fn:matches("Query","ue")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'true'

    "Created: / 05-05-2013 / 18:59:43 / houzvjir@fel.cvut.cz"
!

test_function_fn_matches_02

    | result |

    result := interpreter evaluate:'
    fn:matches("Query","ur")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'false'

    "Created: / 05-05-2013 / 19:00:52 / houzvjir@fel.cvut.cz"
!

test_function_fn_startsWith_01

    | result |

    result := interpreter evaluate:'
    fn:starts-with("Query","Que")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'true'

    "Created: / 03-05-2013 / 16:20:47 / houzvjir@fel.cvut.cz"
!

test_function_fn_startsWith_02

    | result |

    result := interpreter evaluate:'
    fn:starts-with("Query","que")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'false'

    "Created: / 03-05-2013 / 16:22:00 / houzvjir@fel.cvut.cz"
!

test_function_fn_startsWith_03

    | result |

    result := interpreter evaluate:'
    fn:starts-with("Query","ue")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'false'

    "Created: / 03-05-2013 / 16:22:42 / houzvjir@fel.cvut.cz"
!

test_function_fn_startsWith_04

    | result |

    result := interpreter evaluate:'
    fn:starts-with("Query","Q")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'true'

    "Created: / 03-05-2013 / 16:23:10 / houzvjir@fel.cvut.cz"
!

test_function_fn_startsWith_05

    | result |

    result := interpreter evaluate:'
    fn:starts-with("Query","")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'false'

    "Created: / 03-05-2013 / 16:24:02 / houzvjir@fel.cvut.cz"
!

test_function_fn_startsWith_06

    | result |

    result := interpreter evaluate:'
    fn:starts-with("","ue")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'false'

    "Created: / 03-05-2013 / 16:24:43 / houzvjir@fel.cvut.cz"
!

test_function_fn_stringLength_01

    | result |

    result := interpreter evaluate:'
    string-length("query")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '5'

    "Created: / 18-05-2013 / 15:58:11 / houzvjir@fel.cvut.cz"
!

test_function_fn_stringLength_02

    | result |

    result := interpreter evaluate:'
    string-length("  query  ")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '9'

    "Created: / 18-05-2013 / 15:58:52 / houzvjir@fel.cvut.cz"
!

test_function_fn_substringAfter_02

    | result |

    result := interpreter evaluate:'
    fn:substring-after("Query Command","ery")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = ' Command'

    "Created: / 05-05-2013 / 17:31:33 / houzvjir@fel.cvut.cz"
!

test_function_fn_substringBefore_01

    | result |

    result := interpreter evaluate:'
    fn:substring-before("Query Command","Co")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'Query '

    "Created: / 05-05-2013 / 17:40:10 / houzvjir@fel.cvut.cz"
!

test_function_fn_substringBefore_02

    | result |

    result := interpreter evaluate:'
    fn:substring-before("Query Command","Qu")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue) = ''

    "Created: / 05-05-2013 / 17:53:25 / houzvjir@fel.cvut.cz"
!

test_function_fn_substring_01

    | result |

    result := interpreter evaluate:'
    fn:substring("Query",2,3)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'uer'

    "Created: / 05-05-2013 / 17:12:35 / houzvjir@fel.cvut.cz"
!

test_function_fn_substring_02

    | result |

    result := interpreter evaluate:'
    fn:substring("Query",2)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'uery'

    "Created: / 05-05-2013 / 17:49:19 / houzvjir@fel.cvut.cz"
!

test_function_fn_translate_01

    | result |

    result := interpreter evaluate:'
      translate("1999/01/02", "/", "-")   
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '1999-01-02'

    "Created: / 18-05-2013 / 15:40:33 / houzvjir@fel.cvut.cz"
!

test_function_fn_translate_02

    | result |

    result := interpreter evaluate:'
      translate("xml query", "qlmx ", "Q")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'Query'

    "Created: / 18-05-2013 / 15:42:22 / houzvjir@fel.cvut.cz"
!

test_function_fn_translate_03

    | result |

    result := interpreter evaluate:'
    translate("xml query", "qlmx ", "")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'uery'

    "Created: / 18-05-2013 / 15:44:19 / houzvjir@fel.cvut.cz"
!

test_function_fn_translate_04

    | result |

    result := interpreter evaluate:'
    translate("xml query", "abcd", "ABCD")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'xml query'

    "Created: / 18-05-2013 / 15:52:23 / houzvjir@fel.cvut.cz"
!

test_function_fn_upperCase_01

    | result |

    result := interpreter evaluate:'
    fn:upper-case("Query")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'QUERY'

    "Created: / 05-05-2013 / 19:05:12 / houzvjir@fel.cvut.cz"
!

test_function_fn_upperCase_02

    | result |

    result := interpreter evaluate:'
    fn:upper-case("QUERy")
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = 'QUERY'

    "Created: / 05-05-2013 / 19:06:29 / houzvjir@fel.cvut.cz"
!

test_function_user_defined_function_01

    | result |

    result := interpreter evaluate:'
    declare function f($a, $b) {
        $a + $b
    };
    f(1,1)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '2'

    "Created: / 28-12-2006 / 14:01:21 / janfrog"
    "Modified: / 18-09-2008 / 16:45:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_function_user_defined_function_02

    | result |

    result := interpreter evaluate:'
    declare function f($a, $b) {
        $a + $b
    };
    fn:f(1,1)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '2'

    "Created: / 28-12-2006 / 14:01:44 / janfrog"
    "Modified: / 29-12-2006 / 15:56:52 / janfrog"
    "Modified: / 18-09-2008 / 16:45:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_function_user_defined_function_03

    | result |

    result := interpreter evaluate:'
    declare function local:f($a) {
        $a/title
    };
    local:f(<book><title>Lord</title><author>Gandalf</author></book>)
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                childNodes first "first child of result element"
                    nodeValue)
                    = 'Lord'

    "Created: / 03-01-2007 / 09:43:21 / janfrog"
    "Modified: / 21-03-2007 / 16:14:01 / janfrog"
    "Modified: / 18-09-2008 / 16:45:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_function_user_defined_function_04

    | result |

    result := interpreter evaluate:'
    declare function f($a) {
        $a + 1
    };
    for $a in (1) return 
        f(10) , $a
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                nodeValue)
                    = '11'

    "Modified: / 29-12-2006 / 15:56:52 / janfrog"
    "Created: / 17-09-2008 / 12:44:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-09-2008 / 16:45:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryInterpreterTests methodsFor:'tests - namespaces'!

test_namespace_01

    | result |

    result := interpreter basicEvaluate:'
    declare namespace testns = "urn:ns:ns1";
    element testns:a { }
    '.

    self assert:
        (result first "first item in result as document fragment"
            dmNodeName "the only one child of document fragment"
                namespaceURI)
                    = 'urn:ns:ns1'

    "Created: / 24-12-2006 / 15:27:57 / janfrog"
    "Modified: / 18-09-2008 / 16:45:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 11:54:19 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_namespace_02

    | result |

    result := interpreter basicEvaluate:'
    declare default element namespace "urn:ns:ns1";
    element a { }
    '.

    self assert:
        (result first dmNodeName
               namespaceURI)
                    = 'urn:ns:ns1'

    "Created: / 24-12-2006 / 17:20:15 / janfrog"
    "Modified: / 18-09-2008 / 16:45:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 12:24:03 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_namespace_03

    | result |

    result := interpreter basicEvaluate:'
    declare namespace testns = "urn:ns:ns1";
    <testns:a />
    '.

    self assert:
        (result first dmNodeName
                namespaceURI)
                    = 'urn:ns:ns1'

    "Created: / 24-12-2006 / 17:26:53 / janfrog"
    "Modified: / 18-09-2008 / 16:45:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 12:24:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_namespace_04

    | result |

    result := interpreter evaluate:'
    <a/>
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                namespaceURI)
                    = ''

    "Created: / 24-12-2006 / 17:29:02 / janfrog"
    "Modified: / 18-09-2008 / 16:45:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_namespace_05

    | result |

    result := interpreter evaluate:'
    declare namespace testns = "urn:ns:testns";            
    let $a := <root><testns:a/></root>
    return $a/testns:a
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                namespaceURI)
                    = 'urn:ns:testns'

    "Created: / 24-12-2006 / 17:30:18 / janfrog"
    "Modified: / 18-09-2008 / 16:45:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_namespace_06

    | result |

    result := interpreter evaluate:'
    declare namespace testns = "urn:ns:nsA";            
    ',namespacesDocURI,'//testns:a
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                namespaceURI)
                    = 'urn:ns:nsA'

    "Created: / 24-12-2006 / 17:42:34 / janfrog"
    "Modified: / 18-09-2008 / 16:45:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 12:08:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_namespace_07

    | result |

    result := interpreter basicEvaluate:'
    declare namespace testns = "urn:ns:nsB";            
    ',namespacesDocURI,'//testns:b
    '.

    self assert:
        (result first dmNodeName"the only one child of document fragment"
                namespaceURI)
                    = 'urn:ns:nsB'

    "Created: / 24-12-2006 / 17:42:53 / janfrog"
    "Modified: / 18-09-2008 / 16:45:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 12:25:24 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 12:08:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_namespace_08

    | result |

    result := interpreter evaluate:'
    declare namespace testns = "urn:ns:nsD";            
    ',namespacesDocURI,'//c[@testns:d]
    '.

    self assert:
        (result first "first item in result as document fragment"
            childNodes first "the only one child of document fragment"
                localName)
                    = 'c'

    "Created: / 24-12-2006 / 17:59:07 / janfrog"
    "Modified: / 18-09-2008 / 16:45:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 12:08:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XQueryInterpreterTests methodsFor:'tests - xpath'!

testPathExpr1
    |result|

    result := interpreter 
                basicEvaluate:bookstoreDocURI , '/bookstore/book/title'.
    self assert:result size = 3.
    self assert:(result first dmNodeKind = 'element').
    self assert:result first dmStringValue = 'Harry Potter'.
    self assert:(result second dmNodeKind = 'element').
    self assert:result second dmStringValue = 'Learning XML'.
    self assert:result third dmNodeKind = 'element'.
    self assert:result third dmStringValue = '1984'.

    "/   #('Harry Potter' 'Learning XML' 1984)

    "Created: / 08-10-2006 / 21:23:52 / ked"
    "Modified: / 03-12-2006 / 13:40:09 / ked"
    "Modified: / 05-12-2007 / 15:47:38 / janfrog"
    "Modified: / 18-09-2008 / 16:57:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 17:39:59 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:21:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPathExpr2
    |result|

    result := interpreter basicEvaluate:bookstoreDocURI , '//price'.
    self assert:result size = 3.
    self assert:result first dmNodeKind = 'element'.
    self assert:result first dmStringValue = '29.99'.
    self assert:result second dmNodeKind = 'element'.
    self assert:result second dmStringValue = '39.95'.
    self assert:result third dmNodeKind = 'element'.
    self assert:result third dmStringValue = '19.84'.

    "Created: / 08-10-2006 / 21:24:21 / ked"
    "Modified: / 03-12-2006 / 13:40:34 / ked"
    "Modified: / 05-12-2007 / 15:47:38 / janfrog"
    "Modified: / 18-09-2008 / 16:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 17:09:24 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:22:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPathExpr3
    |result aux|

    "NOTE: I am not sure, if the test is according to the specifications
        see http://www.w3.org/TR/xquery/#doc-xquery-ComparisonExpr for more
        details

     My suspection is the xs:untypedAtomic, which is contained in the
        price element."
    result := interpreter 
                basicEvaluate:'for $book in ', bookstoreDocURI , '/bookstore/book
     where $book/price > 30
     return ($book/title, $book/price, $book/price * 0.9)'.
    self assert:result size = 3.
    self assert:result first dmNodeKind = 'element'.
    self assert:result first dmStringValue = 'Learning XML'.
    self assert:result second dmNodeKind = 'element'.
    self assert:result second dmStringValue = '39.95'.
    self assert:(result third isSubtypeOf:'xs:double').
    aux := result third value - 35.955.
    self assert:aux < 0.001.

    "Created: / 08-10-2006 / 21:22:44 / ked"
    "Modified: / 03-12-2006 / 13:43:44 / ked"
    "Modified: / 05-12-2007 / 15:56:09 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-11-2009 / 12:19:40 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:22:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPathExpr4
    |result|

    result := interpreter 
                basicEvaluate:bookstoreDocURI , '/bookstore/book[2]/preceding-sibling::*/title/text()'.
    self assert:result size = 1.
    self assert:result first dmNodeKind = 'text'.
    self assert:result first xpathIsText.
    self assert:result first dmTypedValue = 'Harry Potter'.

    "Modified: / 03-12-2006 / 13:41:16 / ked"
    "Modified: / 05-12-2007 / 15:47:38 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 04-10-2009 / 18:04:05 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 19:03:21 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:22:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPathExpr5
    |result|

    result := interpreter 
                basicEvaluate:bookstoreDocURI , '/bookstore/book[1]/title/@*'.
    self assert:result size = 2.
    self assert:(result 
                anySatisfy:[:sequenceItem | 
                    (((sequenceItem isSubtypeOf: 'node') 
                        & sequenceItem isAttributeNode & sequenceItem dmNodeName qName) 
                        = 'lang' & sequenceItem dmTypedValue) 
                        = 'eng'
                ]).
    self assert:(result 
                anySatisfy:[:sequenceItem | 
                    (((sequenceItem isSubtypeOf: 'node') 
                        & sequenceItem isAttributeNode & sequenceItem dmNodeName qName) 
                        = 'withPictures' & sequenceItem dmTypedValue) 
                        = 'yes'
                ]).

    "Created: / 22-11-2006 / 16:17:58 / ked"
    "Modified: / 03-12-2006 / 13:41:33 / ked"
    "Modified: / 05-12-2007 / 15:47:38 / janfrog"
    "Modified: / 18-09-2008 / 16:57:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 18:07:31 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:22:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPredicate1
    |result|

    result := interpreter basicEvaluate:'(1 to 100)[. mod 5 eq 0][. < 11]'.
    self assert:result size = 2.
    self assert:(result first isSubtypeOf:'xs:decimal').
    self assert:result first = 5.
    self assert:(result second isSubtypeOf:'xs:decimal').
    self assert:result second = 10.

    "Created: / 22-11-2006 / 16:39:11 / ked"
    "Modified: / 03-12-2006 / 13:41:50 / ked"
    "Modified: / 05-12-2007 / 15:37:06 / janfrog"
    "Modified: / 18-09-2008 / 16:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 19:03:43 / Jan Kurs <kursj1@fel.cvut.cz>"
!

testPredicate2
    |result|

    result := interpreter 
                basicEvaluate:bookstoreDocURI , '/bookstore/book[1]/title'.
    self assert:result size = 1.
    self assert:result first dmNodeKind = 'element'.
    self assert:result first dmTypedValue = 'Harry Potter'.

    "Created: / 22-11-2006 / 16:41:23 / ked"
    "Modified: / 03-12-2006 / 13:42:02 / ked"
    "Modified: / 05-12-2007 / 15:47:38 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 19:10:20 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:22:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPredicate3
    |result|

    result := interpreter 
                basicEvaluate:bookstoreDocURI , '/bookstore/book[price > 30]/title'.
    self assert:result size = 1.
    self assert:result first dmNodeKind = 'element'.
    self assert:result first dmTypedValue = 'Learning XML'.

    "Created: / 22-11-2006 / 16:42:01 / ked"
    "Modified: / 03-12-2006 / 13:42:13 / ked"
    "Modified: / 05-12-2007 / 15:47:38 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 19:10:30 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:22:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPredicate4

    |result|

    result := interpreter 
                basicEvaluate:bookstoreDocURI , '/bookstore/book[2]'.
    self assert:result size = 1.
    self assert:result first dmNodeKind = 'element'.

    "Modified: / 03-12-2006 / 13:41:16 / ked"
    "Modified: / 05-12-2007 / 15:47:38 / janfrog"
    "Modified: / 18-09-2008 / 16:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 04-10-2009 / 18:03:56 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:22:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_index_01_low
    |result|

    result := interpreter 
                basicEvaluate:'(element a { element b { element c { "c" } } })/*/* '.
    self assert:(result size = 1).
    self assert:(result first xpathLocalName = 'c')

    "Modified: / 18-09-2008 / 16:57:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-06-2009 / 16:50:05 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_xpath_01
    |result|

    result := interpreter 
                basicEvaluate:bookstoreDocURI , '/bookstore'.
    self assert:result size = 1.

    "Modified: / 03-12-2006 / 13:40:09 / ked"
    "Created: / 21-03-2007 / 18:45:28 / janfrog"
    "Modified: / 18-11-2007 / 09:10:18 / janfrog"
    "Modified: / 18-09-2008 / 16:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-12-2009 / 11:23:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XQueryInterpreterTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
