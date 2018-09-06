"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSAbbrAxesTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!

!XQTSAbbrAxesTests class methodsFor:'documentation'!

documentation
"
    4 tests fails

    [author:]

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!XQTSAbbrAxesTests methodsFor:'tests'!

test_abbreviatedSyntax_1

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-1 :)
(: Description: Evaluates "hours".  Selects the "hours" element children of the context node.  :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[4]) 
 return $h/hours
      
'.

   self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-1.txt')

    "Modified: / 18-04-2009 / 12:21:02 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_abbreviatedSyntax_10

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-10 :)
(: Description: Evaluates "//hours".  Selects all the hours descendants of the root document node and thus selects all hours elements in the same document as the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h//hours
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-10.txt')

!

test_abbreviatedSyntax_12

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-12 :)
(: Description: Evaluates "//overtime/day".  Selects all the day elements in the same document as the context node that have an overtime parent. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h//overtime/day
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-12.txt')

!

test_abbreviatedSyntax_13
    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-13 :)
(: Description: Evaluates ".//day".  Selects the day element descendants of the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/.//day
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-13.txt')

    "Modified: / 29-06-2009 / 23:19:17 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_abbreviatedSyntax_14

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-14 :)
(: Description: Evaluates "..".  Selects the parent of the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[12]/overtime) 
 return $h/..
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-14.txt')

    "Modified: / 19-04-2009 / 12:46:12 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_abbreviatedSyntax_16

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-16 :)
(: Description: Evaluates "employee[@name="Jane Doe 11"]".  Selects all employee children of the context node that have a name attribute with a value "Jane Doe 11". :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee[@name="Jane Doe 11"]
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-16.txt')

!

test_abbreviatedSyntax_17

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-17 :)
(: Description: Evaluates "employee[@gender="female"][5]". Selects the fifth element child of the context node that has a gender attribute with value "female". :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee[@gender="female"][5]
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-17.txt')

!

test_abbreviatedSyntax_18

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-18 :)
(: Description: Evaluates "employee[5][@gender="female"]".  Selects the fifth employee child of the context node if that child has a gender attribute with value "female". :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee[5][@gender="female"]
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-18.txt')

!

test_abbreviatedSyntax_19

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-19 :)
(: Description: Evaluates "employee[status="active"]".  Selects the employee children of the context node that have one or more status children whose typed value is equal to the string "active". :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee[status="active"]
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-19.txt')

!

test_abbreviatedSyntax_2

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-2 :)
(: Description: Evaluates "text()".  Selects all text node children of the context node. :)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[2]) 
 return $h/text()
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-2.txt')

!

test_abbreviatedSyntax_20

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-20 :)
(: Description: Evaluates "employee[overtime]".  Selects the employee children of the context node that have one or more overtime children. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee[overtime]
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-20.txt')

!

test_abbreviatedSyntax_21

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-21 :)
(: Description: Evaluates "employee[@name and @type]".  Selects all the employee children of the context node that have both a name attribute and a type attribute. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee[@name and @type]
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-21.txt')

!

test_abbreviatedSyntax_22

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-22 :)
(: Description: Evaluates "employee/(status|overtime)/day".  Selects every day element that has a parent that is either a status or an overime element, that in turn is a child of an employee element that is a child of the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee/(status|overtime)/day
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-22.txt')

    "Modified: / 29-06-2009 / 23:19:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_abbreviatedSyntax_24
    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-24 :)
(: Description: Evaluates "employee/(status|overtime)/day".  Selects every day element that has a parent that is either a status or an overime element, that in turn is a child of an employee element that is a child of the context node. Uses "union" Operator:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee/(status union overtime)/day
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-24.txt')

    "Modified: / 29-06-2009 / 23:30:07 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_abbreviatedSyntax_25

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-25 :)
(: Description: Evaluates "employee[@name = condition @type=condition]".  Selects all the employee children of the context node that have both a name attribute and a type attribute. Uses "or" operator. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee[@name = "Jane Doe 13" or @type="FT"]
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-25.txt')

!

test_abbreviatedSyntax_3

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-3 :)
(: Description: Evaluates "@name". Selects the name attribute of the context node. :)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[10]) 
 return $h
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-3.txt')

!

test_abbreviatedSyntax_5

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-5 :)
(: Description: Evaluates "employee[1]". Selects the first employee child of the context node. :)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee[1]
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-5.txt')

!

test_abbreviatedSyntax_6
    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-6 :)
(: Description: Evaluates "para[fn:last()]". Selects the last employee child of the context node. :)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee[fn:last()]
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-6.txt')

    "Modified: / 29-06-2009 / 23:30:40 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_abbreviatedSyntax_7

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-7 :)
(: Description: Evaluates "*/hours". Selects all hours grandchildren of the context node. :)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/*/hours
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-7.txt')

!

test_abbreviatedSyntax_8

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-8 :)
(: Description: Evaluates "/works/employee[5]/hours[2]" selects the second hours of the fifth employee of the book whose parent is the document node that contains the context node. :)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/*/hours
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-8.txt')

!

test_abbreviatedSyntax_9

    | query result |

    query := ' 
        (: Name: abbreviatedSyntax-9 :)
(: Description: Evaluates "employee//hours".  Selects the hours element descendants of the employee element children of the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/employee//hours
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'works-mod'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/AbbrAxes/abbreviatedSyntax-9.txt')

! !

!XQTSAbbrAxesTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
