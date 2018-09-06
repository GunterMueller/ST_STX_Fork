"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSLetExprWithTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSLetExprWithTests methodsFor:'tests'!

test_letexprwith_1

    | query result |

    query := ' 
        (: Name: letexprwith-1 :)
(: Description: Evaluation of let clause bound to variable used in expression that raises error. :)

let $salary as xs:decimal :=  "cat"
return $salary * 2
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_letexprwith_10

    | query result |

    query := ' 
        (: Name: letexprwith-10 :)
(: Description: Let clause using dateTime type. :)

let $var as xs:dateTime :=  xs:dateTime("1999-05-31T13:20:00Z")
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-10.txt')

!

test_letexprwith_11

    | query result |

    query := ' 
        (: Name: letexprwith-11 :)
(: Description: Let clause using float type. :)

let $var as xs:float :=  xs:float(100)
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-11.txt')

!

test_letexprwith_12

    | query result |

    query := ' 
        (: Name: letexprwith-12 :)
(: Description: Let clause using an ineteger expression type. :)

let $var as xs:integer := 100+200
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-12.txt')

!

test_letexprwith_13

    | query result |

    query := ' 
        (: Name: letexprwith-13 :)
(: Description: Let clause using the fn:count function. :)

let $var as xs:integer := fn:count((100,200))
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-13.txt')

!

test_letexprwith_14

    | query result |

    query := ' 
        (: Name: letexprwith-14 :)
(: Description: Let clause using the fn:not function. :)

let $var as xs:boolean := fn:not(fn:true())
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-14.txt')

!

test_letexprwith_15

    | query result |

    query := ' 
        (: Name: letexprwith-15 :)
(: Description: Let clause using the "and" operator function. :)

let $var as xs:boolean := fn:true() and fn:true()
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-15.txt')

!

test_letexprwith_16

    | query result |

    query := ' 
        (: Name: letexprwith-16 :)
(: Description: Let clause using the "or" operator function. :)

let $var as xs:boolean := fn:true() and fn:true()
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-16.txt')

!

test_letexprwith_17

    | query result |

    query := ' 
        (: Name: letexprwith-17 :)
(: Description: Let clause using the "string-length" function. :)

let $var as xs:integer := fn:string-length("A String")
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-17.txt')

!

test_letexprwith_18

    | query result |

    query := ' 
        (: Name: letexprwith-18 :)
(: Description: Let clause using a casting from integer to string :)

let $var as xs:string := xs:string((xs:integer(100)))
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-18.txt')

!

test_letexprwith_19

    | query result |

    query := ' 
        (: Name: letexprwith-19 :)
(: Description: Let clause using a casting from decimal to string :)

let $var as xs:string := xs:string((xs:decimal(100)))
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-19.txt')

!

test_letexprwith_2

    | query result |

    query := ' 
        (: Name: letexprwith-2 :)
(: Description: Let clause used decimal type. :)

let $var as xs:decimal :=  100
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-2.txt')

!

test_letexprwith_20

    | query result |

    query := ' 
        (: Name: letexprwith-20 :)
(: Description: Let clause using a casting from double to string :)

let $var as xs:string := xs:string((xs:double(100E2)))
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-20.txt')

!

test_letexprwith_21

    | query result |

    query := ' 
        (: Name: letexprwith-21 :)
(: Description: Let clause using a casting from boolean to string :)

let $var as xs:string := xs:string(fn:true())
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-21.txt')

!

test_letexprwith_22

    | query result |

    query := ' 
        (: Name: letexprwith-22 :)
(: Description: Let clause using a integer type and addition expression on return clause :)

let $var as xs:integer := 100
return $var + 1
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-22.txt')

!

test_letexprwith_23

    | query result |

    query := ' 
        (: Name: letexprwith-23 :)
(: Description: Let clause using an "if" expression :)

let $var as xs:boolean := if (fn:true()) then fn:true() else fn:false()
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-23.txt')

!

test_letexprwith_24

    | query result |

    query := ' 
        (: Name: letexprwith-24 :)
(: Description: Let clause using a "typeswitch" expression :)

let $var as xs:string := typeswitch(fn:true())
                           case $i as xs:boolean
                             return "Test Passed"
                           default
                             return "Test failed"
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-24.txt')

!

test_letexprwith_3

    | query result |

    query := ' 
        (: Name: letexprwith-3 :)
(: Description: Let clause using integer type. :)

let $var as xs:integer :=  100
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-3.txt')

!

test_letexprwith_4

    | query result |

    query := ' 
        (: Name: letexprwith-4 :)
(: Description: Let clause using double type. :)

let $var as xs:double :=  100E1
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-4.txt')

!

test_letexprwith_5

    | query result |

    query := ' 
        (: Name: letexprwith-5 :)
(: Description: Let clause using double type. :)

let $var as xs:string :=  "A String"
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-5.txt')

!

test_letexprwith_6

    | query result |

    query := ' 
        (: Name: letexprwith-6 :)
(: Description: Let clause using boolean (true) type. :)

let $var as xs:boolean :=  fn:true()
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-6.txt')

!

test_letexprwith_7

    | query result |

    query := ' 
        (: Name: letexprwith-7 :)
(: Description: Let clause using boolean (false) type. :)

let $var as xs:boolean :=  fn:false()
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-7.txt')

!

test_letexprwith_8

    | query result |

    query := ' 
        (: Name: letexprwith-8 :)
(: Description: Let clause using date type. :)

let $var as xs:date :=  xs:date("1999-05-31Z") 
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-8.txt')

!

test_letexprwith_9

    | query result |

    query := ' 
        (: Name: letexprwith-9 :)
(: Description: Let clause using time type. :)

let $var as xs:time :=  xs:time("21:23:00Z") 
return $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExprWith/letexprwith-9.txt')

! !

!XQTSLetExprWithTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
