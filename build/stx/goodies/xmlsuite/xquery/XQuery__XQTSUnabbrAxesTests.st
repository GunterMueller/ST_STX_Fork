"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSUnabbrAxesTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSUnabbrAxesTests methodsFor:'tests'!

test_unabbreviatedSyntax_1

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-1 :)
(: Description: Evaluate the child axis of the context node (child::empnum)  :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee) 
 return $h/child::empnum
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-1.txt')

!

test_unabbreviatedSyntax_12

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-12 :)
(: Description: Evaluate selecting an descendant or self (descendant-or-self::employee)- Select the "employee" descendants of the context node and if the :)
(: context is "employee" select it as well.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[1]) 
 return $h/descendant-or-self::employee
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-12.txt')

!

test_unabbreviatedSyntax_13

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-13 :)
(: Description: Evaluate self (self::employee)- Select the context node, if it is an "employee", otherwise return empty sequence :)
(: This test selects an "employee" element:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[1]) 
 return $h/self::employee
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-13.txt')

!

test_unabbreviatedSyntax_14

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-14 :)
(: Description: Evaluate self (self::hours)- Select the context node, if it is an "employee", otherwise return empty sequence :)
(: This test selects an empty sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works[1]/employee[1]) 
 return fn:count(($h/self::employee[1000]))
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-14.txt')

!

test_unabbreviatedSyntax_15

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-15 :)
(: Description: Evaluate more on child/descendant (child::employee/descendant:empnum)- selects the empnum element descendants of the employee element children of the context node  :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/child::employee/descendant::empnum
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-15.txt')

!

test_unabbreviatedSyntax_16

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-16 :)
(: Description: Evaluate child::*/child::pnum - Selects the "pnum" grandchildren of the context node:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/child::*/child::pnum
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-16.txt')

!

test_unabbreviatedSyntax_18

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-18 :)
(: Description: Evaluate /descendant::pnum selects all the pnum elements in the same document as the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/descendant::pnum
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-18.txt')

!

test_unabbreviatedSyntax_19

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-19 :)
(: Description: Evaluate "/descendant::employee/child::pnum" - Selects all the pnum elements that have an "employee" parent and that are in the same document as the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/descendant::employee/child::pnum
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-19.txt')

!

test_unabbreviatedSyntax_2

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-2 :)
(: Description: Evaluate selecting all element children of the context node:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[1]) 
 return $h/child::*
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-2.txt')

!

test_unabbreviatedSyntax_20

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-20 :)
(: Description: Evaluate "child::employee[fn:position() = 1]". Selects the first employee child of the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/child::employee[fn:position() = 1]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-20.txt')

!

test_unabbreviatedSyntax_21

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-21 :)
(: Description: Evaluate "child::employee[fn:position() = fn:last()]" selects the previous to the one "employee" child of the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/child::employee[fn:position() = fn:last()]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-21.txt')

!

test_unabbreviatedSyntax_22

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-22 :)
(: Description: Evaluate "child::employee[fn:position() = fn:last()-1]" Selects the last but one "employee" child of the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/child::employee[fn:position() = fn:last()-1]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-22.txt')

!

test_unabbreviatedSyntax_23

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-23 :)
(: Description: Evaluate "child::hours[fn:position() > 1]".  Selects all the hours children of the context node other than the first hours child of the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee) 
 return $h/child::hours[fn:position() > 1]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-23.txt')

!

test_unabbreviatedSyntax_26

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-26 :)
(: Description: Evaluate "/descendant::employee[fn:position() = 12]".  Selects the twelfth employee element in the document containing the context node. :)			  

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/descendant::employee[fn:position() = 12]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-26.txt')

!

test_unabbreviatedSyntax_27

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-27 :)
(: Description: Evaluate "/child::works/child::employee[fn:position() = 5]/child::hours[fn:position() = 2]". Selects the second hour of the fifth employee of the works whose parent is the document :)
(: node that contains the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1) 
 return $h/child::works/child::employee[fn:position() = 5]/child::hours[fn:position() = 2]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-27.txt')

!

test_unabbreviatedSyntax_28

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-28 :)
(: Description: Evaluate "child::employee[attribute::name eq "Jane Doe 11"]". Selects all "employee" children of the context node :)
(: that have a "name" attribute with value "Jane Doe 11". :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/child::employee[attribute::name eq "Jane Doe 11"]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-28.txt')

!

test_unabbreviatedSyntax_29

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-29 :)
(: Description: Evaluate "child::employee[attribute::gender eq "female"][fn:position() = 5]".  Selects the fifth employee child of the context node that has a gender attribute with value "female". :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/child::employee[attribute::gender eq "female"][fn:position() = 5]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-29.txt')

!

test_unabbreviatedSyntax_3

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-3 :)
(: Description: Evaluate selecting all text node children of the context node:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works[1]/employee[2]) 
 return $h/child::text() 
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-3.txt')

!

test_unabbreviatedSyntax_30

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-30 :)
(: Description: Evaluate "child::employee[child::empnum = "E3"]".  Selects the employee children of the context node that have one or more empnum children whose :)
(: typed value is equal to the string "E3". :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/child::employee[child::empnum = "E3"]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-30.txt')

!

test_unabbreviatedSyntax_31

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-31 :)
(: Description: Evaluate "child::employee[child::status]".  Selects the employee children of the context node that have one or more status children. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works) 
 return $h/child::employee[child::status]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-31.txt')

!

test_unabbreviatedSyntax_32

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-32 :)
(: Description: Evaluate "child::*[self::pnum or self::empnum]".  Selects the pnum and empnum children of the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[7]) 
 return $h/child::*[self::pnum or self::empnum]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-32.txt')

!

test_unabbreviatedSyntax_33

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-33 :)
(: Description: Evaluate "child::*[self::empnum or self::pnum][fn:position() = fn:last()]".  Selects the last empnum or pnum child of the context node. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[6]) 
 return $h/child::*[self::empnum or self::pnum][fn:position() = fn:last()]
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-33.txt')

!

test_unabbreviatedSyntax_4

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-4 :)
(: Description: Evaluate selecting all children of the context node:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[1]) 
 return $h/child::node()
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-4.txt')

!

test_unabbreviatedSyntax_5

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-5 :)
(: Description: Evaluate selecting all the children the context node (child::node). :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[2]) 
 return $h/child::node()
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-5.txt')

!

test_unabbreviatedSyntax_8

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-8 :)
(: Description: Evaluate selecting the parent (parent::node()) of the context node:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee[1]/hours) 
 return $h/parent::node()
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-8.txt')

!

test_unabbreviatedSyntax_9

    | query result |

    query := ' 
        (: Name: unabbreviatedSyntax-9 :)
(: Description: Evaluate selecting a descendant (descendant::empnum)- Select the "empnum" descendants of the context node:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

for $h in ($input-context1/works/employee) 
 return $h/descendant::empnum
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works-mod'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PathExpr/UnabbrAxes/unabbreviatedSyntax-9.txt')

! !

!XQTSUnabbrAxesTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
