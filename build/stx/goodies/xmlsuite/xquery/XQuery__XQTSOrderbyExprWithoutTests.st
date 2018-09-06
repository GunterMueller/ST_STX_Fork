"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSOrderbyExprWithoutTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSOrderbyExprWithoutTests methodsFor:'tests'!

test_orderbywithout_1

    | query result |

    query := ' 
        (: name : orderbywithout-1 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of Strings. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by xs:string($x) return xs:string($x)
}
</results>
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-1.txt')

!

test_orderbywithout_10

    | query result |

    query := ' 
        (: name : orderbywithout-10 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "count($x) ", where $x is a set of node with strings as content.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by count(xs:string($x)) return count(xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-10.txt')

!

test_orderbywithout_11

    | query result |

    query := ' 
        (: name : orderbywithout-11 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "$x ", where $x is a set of negative numbers casted as decimals. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by xs:decimal($x) return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-11.txt')

!

test_orderbywithout_12

    | query result |

    query := ' 
        (: name : orderbywithout-12 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "($x + $x) ", where $x is a set of negative numbers casted as decimals. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by (xs:decimal($x) + xs:decimal($x)) return xs:decimal($x) + xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-12.txt')

!

test_orderbywithout_13

    | query result |

    query := ' 
        (: name : orderbywithout-13 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "$x is $x ", where $x is a set of nodes with negative numbers as content. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (<orderData>-100000000000000000</orderData>,<orderData>-10000000000000000</orderData>,<orderData>-1000000000000000</orderData>,<orderData>-100000000000000</orderData>,
<orderData>-10000000000000</orderData>,<orderData>-1000000000000</orderData>,<orderData>-100000000000</orderData>,<orderData>-10000000000</orderData>,<orderData>-1000000000</orderData>,
<orderData>-100000000</orderData>,<orderData>-10000000</orderData>,<orderData>-1000000</orderData>,<orderData>-100000</orderData>,<orderData>-10000</orderData>,<orderData>-1000</orderData>,
<orderData>-100</orderData>,<orderData>-10</orderData>,<orderData>-1</orderData>,<orderData>-0</orderData>)
 order by $x is $x return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-13.txt')

!

test_orderbywithout_14

    | query result |

    query := ' 
        (: name : orderbywithout-14 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:float($x) ", where $x is a set of negative numbers. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by xs:float($x) return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-14.txt')

!

test_orderbywithout_15

    | query result |

    query := ' 
        (: name : orderbywithout-15 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:double($x) ", where $x is a set of negative numbers. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by xs:double($x) return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-15.txt')

!

test_orderbywithout_16

    | query result |

    query := ' 
        (: name : orderbywithout-16 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:integer($x) ", where $x is a set of negative numbers. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by xs:integer($x) return xs:integer($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-16.txt')

!

test_orderbywithout_17

    | query result |

    query := ' 
        (: name : orderbywithout-17 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "($x * -1) ", where $x is a set of negative numbers. :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by (xs:decimal($x) * -1) return (xs:decimal($x) * -1)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-17.txt')

!

test_orderbywithout_18

    | query result |

    query := ' 
        (: name : orderbywithout-18 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "$x ", where $x is a set of positive numbers.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:decimal($x) return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-18.txt')

!

test_orderbywithout_19

    | query result |

    query := ' 
        (: name : orderbywithout-19 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "($x + $x) ", where $x is a set of positive numbers. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by (xs:decimal($x) + xs:decimal($x)) return xs:decimal($x) + xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-19.txt')

!

test_orderbywithout_2

    | query result |

    query := ' 
        (: name : orderbywithout-2 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"()") ", where $x is a set of Strings.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),"()") return concat(xs:string($x),"()")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-2.txt')

!

test_orderbywithout_20

    | query result |

    query := ' 
        (: name : orderbywithout-20 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "$x is $x ", where $x is a set of nodes with positive numbers as content. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (<orderData>100000000000000000</orderData>,<orderData>10000000000000000</orderData>,<orderData>1000000000000000</orderData>,
<orderData>100000000000000</orderData>,<orderData>10000000000000</orderData>,<orderData>1000000000000</orderData>,<orderData>100000000000</orderData>,
<orderData>10000000000</orderData>,<orderData>1000000000</orderData>,<orderData>100000000</orderData>,<orderData>10000000</orderData>,
<orderData>1000000</orderData>,<orderData>100000</orderData>,<orderData>10000</orderData>,<orderData>1000</orderData>,<orderData>100</orderData>,
<orderData>10</orderData>,<orderData>1</orderData>,<orderData>0</orderData>)
 order by $x is $x return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-20.txt')

!

test_orderbywithout_21

    | query result |

    query := ' 
        (: name : orderbywithout-21 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:float($x) ", where $x is a set of positive numbers.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:float($x) return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-21.txt')

!

test_orderbywithout_22

    | query result |

    query := ' 
        (: name : orderbywithout-22 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:decimal($x)", where $x is a set of positive numbers.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:decimal($x) return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-22.txt')

!

test_orderbywithout_23

    | query result |

    query := ' 
        (: name : orderbywithout-23 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:double($x)", where $x is a set of positive numbers.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:double($x) return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-23.txt')

!

test_orderbywithout_24

    | query result |

    query := ' 
        (: name : orderbywithout-24 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:integer($x)", where $x is a set of positive numbers.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:integer($x) return xs:integer($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-24.txt')

!

test_orderbywithout_25

    | query result |

    query := ' 
        (: name : orderbywithout-25 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "string($x)", where $x is a set of positive numbers.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by string($x) return string($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-25.txt')

!

test_orderbywithout_26

    | query result |

    query := ' 
        (: name : orderbywithout-26 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "$x", where $x is a set of small positive numbers.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by $x return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-26.txt')

!

test_orderbywithout_27

    | query result |

    query := ' 
        (: name : orderbywithout-27 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "$x", where $x is a set of small positive numbers casted as decimals. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by xs:decimal($x) return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-27.txt')

!

test_orderbywithout_28

    | query result |

    query := ' 
        (: name : orderbywithout-28 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "($x + $x) ", where $x is a set of small positive numbers casted as decimals. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by (xs:decimal($x) + xs:decimal($x)) return xs:decimal($x) + xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-28.txt')

!

test_orderbywithout_29

    | query result |

    query := ' 
        (: name : orderbywithout-29 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "$x is $x ", where $x is a set nodes with small positive numbers as content. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (<orderData>0.000000000000000001</orderData>,<orderData>0.00000000000000001</orderData>,<orderData>0.0000000000000001</orderData>,<orderData>0.000000000000001</orderData>,
<orderData>0.00000000000001</orderData>,<orderData>0.0000000000001</orderData>,<orderData>0.000000000001</orderData>,<orderData>0.00000000001</orderData>,<orderData>0.0000000001</orderData>,
<orderData>0.000000001</orderData>,<orderData>0.00000001</orderData>,<orderData>0.0000001</orderData>,<orderData>0.000001</orderData>,<orderData>0.00001</orderData>,
<orderData>0.0001</orderData>,<orderData>0.001</orderData>,<orderData>0.01</orderData>,<orderData>0.1</orderData>,<orderData>0.0</orderData>)
 order by $x is $x return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-29.txt')

!

test_orderbywithout_3

    | query result |

    query := ' 
        (: name : orderbywithout-3 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "concat($x,"another String After") ", where $x is a set of Strings. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),"another String After") return concat(xs:string($x),"another String After")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-3.txt')

!

test_orderbywithout_30

    | query result |

    query := ' 
        (: name : orderbywithout-30 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:float($x) ", where $x is a set of small positive numbers. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by xs:float($x) return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-30.txt')

!

test_orderbywithout_31

    | query result |

    query := ' 
        (: name : orderbywithout-31 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:decimal($x) ", where $x is a set of small positive numbers.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by xs:decimal($x) return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-31.txt')

!

test_orderbywithout_32

    | query result |

    query := ' 
        (: name : orderbywithout-32 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:double($x) ", where $x is a set of small positive numbers. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by xs:double($x) return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-32.txt')

!

test_orderbywithout_33

    | query result |

    query := ' 
        (: name : orderbywithout-33 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "string($x) ", where $x is a set of small positive numbers.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by string($x) return string($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-33.txt')

!

test_orderbywithout_34

    | query result |

    query := ' 
        (: name : orderbywithout-34 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "$x ", where $x is a set of small negative numbers casted as decimals. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by xs:decimal($x) return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-34.txt')

!

test_orderbywithout_35

    | query result |

    query := ' 
        (: name : orderbywithout-35 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "($x + $x) ", where $x is a set of small negative numbers casted as decimals.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by (xs:decimal($x) + xs:decimal($x)) return xs:decimal($x) + xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-35.txt')

!

test_orderbywithout_36

    | query result |

    query := ' 
        (: name : orderbywithout-36 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "$x is $x ", where $x is a set of nodes with small negative numbers as argument. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (<orderData>-0.000000000000000001</orderData>,<orderData>-0.00000000000000001</orderData>,<orderData>-0.0000000000000001</orderData>,<orderData>-0.000000000000001</orderData>,<orderData>-0.00000000000001</orderData>,<orderData>-0.0000000000001</orderData>,
<orderData>-0.000000000001</orderData>,<orderData>-0.00000000001</orderData>,<orderData>-0.0000000001</orderData>,<orderData>-0.000000001</orderData>,
<orderData>-0.00000001</orderData>,<orderData>-0.0000001</orderData>,<orderData>-0.000001</orderData>,<orderData>-0.00001</orderData>,<orderData>-0.0001</orderData>,<orderData>-0.001</orderData>,<orderData>-0.01</orderData>,<orderData>-0.0</orderData>,
<orderData>-0.1</orderData>)
 order by $x is $x return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-36.txt')

!

test_orderbywithout_37

    | query result |

    query := ' 
        (: name : orderbywithout-37 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:float($x) ", where $x is a set of small negative numbers. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by xs:float($x) return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-37.txt')

!

test_orderbywithout_38

    | query result |

    query := ' 
        (: name : orderbywithout-38 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:decimal($x) ", where $x is a set of small negative numbers.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by xs:decimal($x) return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-38.txt')

!

test_orderbywithout_39

    | query result |

    query := ' 
        (: name : orderbywithout-39 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "xs:double($x) ", where $x is a set of small negative numbers. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by xs:double($x) return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-39.txt')

!

test_orderbywithout_4

    | query result |

    query := ' 
        (: name : orderbywithout-4 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "concat("another String Before",$x) ", where $x is a set of Strings. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat("another String Before",xs:string($x)) return concat("another String Before",xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-4.txt')

!

test_orderbywithout_40

    | query result |

    query := ' 
        (: name : orderbywithout-40 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "string($x) ", where $x is a set of small negative numbers. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by string($x) return string($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-40.txt')

!

test_orderbywithout_5

    | query result |

    query := ' 
        (: name : orderbywithout-5 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "concat($x,"") ", where $x is a set of Strings. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),"") return concat(xs:string($x),"")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-5.txt')

!

test_orderbywithout_6

    | query result |

    query := ' 
        (: name : orderbywithout-6 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "concat("",$x) ", where $x is a set of Strings. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat("",xs:string($x)) return concat("",xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-6.txt')

!

test_orderbywithout_7

    | query result |

    query := ' 
        (: name : orderbywithout-7 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "$x is $x ", where $x is a set of nodes with strings as content. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (<a>A String</a>,<a>B String</a>,<a>C String</a>,<a>D String</a>,<a>E String</a>,<a>F String</a>,<a>G String</a>,<a>H String</a>,<a>I String</a>,
<a>J String</a>,<a>K String</a>,<a>L String</a>,<a>M String</a>,<a>N String</a>,<a>O String</a>,<a>P String</a>,<a>R String</a>,<a>S String</a>,<a>T String</a>, 
<a>U String</a>,<a>V String</a>,<a>W String</a>,<a>X String</a>,<a>Y String</a>,<a>Z String</a>)
 order by $x is $x return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-7.txt')

!

test_orderbywithout_8

    | query result |

    query := ' 
        (: name : orderbywithout-8 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "concat($x,$x) ", where $x is a set of Strings.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),xs:string($x)) return concat(xs:string($x),xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-8.txt')

!

test_orderbywithout_9

    | query result |

    query := ' 
        (: name : orderbywithout-9 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWOR expression set to "string-length($x) ", where $x is a set of Nodes with strings as content.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (<a>A String</a>,<a>B String</a>,<a>C String</a>,<a>D String</a>,<a>E String</a>,<a>F String</a>,<a>G String</a>,<a>H String</a>,<a>I String</a>,
<a>J String</a>,<a>K String</a>,<a>L String</a>,<a>M String</a>,<a>N String</a>,<a>O String</a>,<a>P String</a>,<a>R String</a>,<a>S String</a>,<a>T String</a>, 
<a>U String</a>,<a>V String</a>,<a>W String</a>,<a>X String</a>,<a>Y String</a>,<a>Z String</a>)
order by string-length($x) return string-length($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWithout/orderbywithout-9.txt')

! !

!XQTSOrderbyExprWithoutTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
