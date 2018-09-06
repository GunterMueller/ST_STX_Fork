"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSOrderbyExprWithTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSOrderbyExprWithTests methodsFor:'tests'!

test_orderBy1

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy1 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by $x ascending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy1.txt')

!

test_orderBy10

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy10 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"") ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat($x,"") ascending return concat($x,"")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy10.txt')

!

test_orderBy11

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy11 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat("",$x) ", where $x is a set of Strings and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat("",$x) descending return concat("",$x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy11.txt')

!

test_orderBy12

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy12 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat("",$x) ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat("",$x) ascending return concat("",$x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy12.txt')

!

test_orderBy13

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy13 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat("",$x) ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat("",$x) ascending return concat("",$x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy13.txt')

!

test_orderBy14

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy14 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by $x is $x ascending return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy14.txt')

!

test_orderBy15

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy15 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of Strings and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by $x is $x descending return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy15.txt')

!

test_orderBy16

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy16 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,$x) ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat($x,$x) ascending return concat($x,$x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy16.txt')

!

test_orderBy17

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy17 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "string-length($x) ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by string-length($x) ascending return string-length($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy17.txt')

!

test_orderBy18

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy18 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "count($x) ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by count($x) ascending return count($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy18.txt')

!

test_orderBy19

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy19 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "string-length($x) ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by string-length($x) ascending return string-length($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy19.txt')

!

test_orderBy2

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy2 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of Strings and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by $x descending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy2.txt')

!

test_orderBy20

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy20 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of negative numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/NegativeNumbers/orderData
 order by $x ascending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy20.txt')

!

test_orderBy21

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy21 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/NegativeNumbers/orderData
 order by $x descending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy21.txt')

!

test_orderBy22

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy22 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "($x + $x) ", where $x is a set of negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/NegativeNumbers/orderData
 order by ($x + $x) descending return $x + $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy22.txt')

!

test_orderBy23

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy23 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of negative numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/NegativeNumbers/orderData
 order by $x is $x ascending return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy23.txt')

!

test_orderBy24

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy24 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/NegativeNumbers/orderData
 order by $x is $x descending return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy24.txt')

!

test_orderBy25

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy25 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:float($x) ", where $x is a set of negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/NegativeNumbers/orderData
 order by xs:float($x) descending return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy25.txt')

!

test_orderBy26

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy26 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:decimal($x) ", where $x is a set of negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/NegativeNumbers/orderData
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy26.txt')

!

test_orderBy27

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy27 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:double($x) ", where $x is a set of negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/NegativeNumbers/orderData
 order by xs:double($x) descending return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy27.txt')

!

test_orderBy28

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy28 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:integer($x) ", where $x is a set of negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/NegativeNumbers/orderData
 order by xs:integer($x) descending return xs:integer($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy28.txt')

!

test_orderBy29

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy29 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "($x * -1) ", where $x is a set of negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/NegativeNumbers/orderData
 order by ($x * -1) descending return ($x * -1)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy29.txt')

!

test_orderBy3

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy3 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"()") ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat($x,"()") ascending return concat($x,"()")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy3.txt')

!

test_orderBy30

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy30 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of positive numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/PositiveNumbers/orderData
 order by $x ascending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy30.txt')

!

test_orderBy31

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy31 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/PositiveNumbers/orderData
 order by $x descending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy31.txt')

!

test_orderBy32

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy32 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "($x + $x) ", where $x is a set of positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/PositiveNumbers/orderData
 order by ($x + $x) descending return $x + $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy32.txt')

!

test_orderBy33

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy33 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of positive numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/PositiveNumbers/orderData
 order by $x is $x ascending return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy33.txt')

!

test_orderBy34

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy34 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/PositiveNumbers/orderData
 order by $x is $x descending return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy34.txt')

!

test_orderBy35

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy35 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:float($x) ", where $x is a set of positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/PositiveNumbers/orderData
 order by xs:float($x) descending return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy35.txt')

!

test_orderBy36

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy36 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:decimal($x) ", where $x is a set of positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/PositiveNumbers/orderData
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy36.txt')

!

test_orderBy37

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy37 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:double($x) ", where $x is a set of positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/PositiveNumbers/orderData
 order by xs:double($x) descending return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy37.txt')

!

test_orderBy38

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy38 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:integer($x) ", where $x is a set of positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/PositiveNumbers/orderData
 order by xs:integer($x) descending return xs:integer($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy38.txt')

!

test_orderBy39

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy39 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "string($x) ", where $x is a set of positive numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/PositiveNumbers/orderData
 order by string($x) ascending return string($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy39.txt')

!

test_orderBy4

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy4 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"()") ", where $x is a set of Strings and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat($x,"()") descending return concat($x,"()")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy4.txt')

!

test_orderBy40

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy40 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of small positive numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallPositiveNumbers/orderData
 order by $x ascending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy40.txt')

!

test_orderBy41

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy41 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of small positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallPositiveNumbers/orderData
 order by $x descending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy41.txt')

!

test_orderBy42

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy42 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "($x + $x) ", where $x is a set of small positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallPositiveNumbers/orderData
 order by ($x + $x) descending return $x + $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy42.txt')

!

test_orderBy43

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy43 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of small positive numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallPositiveNumbers/orderData
 order by $x is $x ascending return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy43.txt')

!

test_orderBy44

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy44 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of small positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallPositiveNumbers/orderData
 order by $x is $x descending return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy44.txt')

!

test_orderBy45

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy45 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:float($x) ", where $x is a set of small positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallPositiveNumbers/orderData
 order by xs:float($x) descending return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy45.txt')

!

test_orderBy46

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy46 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:decimal($x) ", where $x is a set of small positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallPositiveNumbers/orderData
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy46.txt')

!

test_orderBy47

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy47 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:double($x) ", where $x is a set of small positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallPositiveNumbers/orderData
 order by xs:double($x) descending return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy47.txt')

!

test_orderBy49

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy49 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "string($x) ", where $x is a set of small positive numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallPositiveNumbers/orderData
 order by string($x) ascending return string($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy49.txt')

!

test_orderBy5

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy5 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"another String After") ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat($x,"another String After") ascending return concat($x,"another String After")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy5.txt')

!

test_orderBy50

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy50 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of small negative numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallNegativeNumbers/orderData
 order by $x ascending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy50.txt')

!

test_orderBy51

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy51 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of small negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallNegativeNumbers/orderData
 order by $x descending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy51.txt')

!

test_orderBy52

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy52 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "($x + $x) ", where $x is a set of small negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallNegativeNumbers/orderData
 order by ($x + $x) descending return $x + $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy52.txt')

!

test_orderBy53

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy53 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of small negative numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallNegativeNumbers/orderData
 order by $x is $x ascending return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy53.txt')

!

test_orderBy54

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy54 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of small negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallNegativeNumbers/orderData
 order by $x is $x descending return $x is $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy54.txt')

!

test_orderBy55

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy55 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:float($x) ", where $x is a set of small negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallNegativeNumbers/orderData
 order by xs:float($x) descending return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy55.txt')

!

test_orderBy56

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy56 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:decimal($x) ", where $x is a set of small negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallNegativeNumbers/orderData
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy56.txt')

!

test_orderBy57

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy57 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:double($x) ", where $x is a set of small negative numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallNegativeNumbers/orderData
 order by xs:double($x) descending return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy57.txt')

!

test_orderBy59

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy59 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "string($x) ", where $x is a set of small negative numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/SmallNegativeNumbers/orderData
 order by string($x) ascending return string($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy59.txt')

!

test_orderBy6

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy6 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"another String After") ", where $x is a set of Strings and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat($x,"another String After") descending return concat($x,"another String After")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy6.txt')

!

test_orderBy7

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy7 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"another String Before") ", where $x is a set of Strings and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat($x,"another String Before") ascending return concat($x,"another String Before")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy7.txt')

!

test_orderBy8

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy8 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"another String Before") ", where $x is a set of Strings and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat($x,"another String Before") descending return concat($x,"another String Before")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy8.txt')

!

test_orderBy9

    | query result |

    query := ' 
        declare default element namespace "http://www.w3.org/XQueryTestOrderBy";
(: name : orderBy9 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"") ", where $x is a set of Strings and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in $input-context1/DataValues/Strings/orderData
 order by concat($x,"") descending return concat($x,"")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderBy9.txt')

!

test_orderbylocal_1

    | query result |

    query := ' 
        (: name : orderbylocal-1 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of Strings and the ordering mode set to ascending :)
(: Uses a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by xs:string($x) ascending return xs:string($x)
}
</results>
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-1.txt')

!

test_orderbylocal_10

    | query result |

    query := ' 
        (: name : orderbylocal-10 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"") ", where $x is a set of Strings and the ordering mode set to ascending :)
(: Uses a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),"") ascending return concat(xs:string($x),"")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-10.txt')

!

test_orderbylocal_11

    | query result |

    query := ' 
        (: name : orderbylocal-l1 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat("",$x) ", where $x is a set of Strings and the ordering mode set to descending :)
(: Use locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat("",xs:string($x)) descending return concat("",xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-11.txt')

!

test_orderbylocal_12

    | query result |

    query := ' 
        (: name : orderbylocal-12 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat("",$x) ", where $x is a set of Strings and the ordering mode set to ascending :)
(: Uses locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat("",xs:string($x)) ascending return concat("",xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-12.txt')

!

test_orderbylocal_16

    | query result |

    query := ' 
        (: name : orderbylocal-16 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,$x) ", where $x is a set of Strings and the ordering mode set to ascending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),xs:string($x)) ascending return concat(xs:string($x),xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-16.txt')

!

test_orderbylocal_17

    | query result |

    query := ' 
        (: name : orderbylocal-17 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "string-length($x) ", where $x is a set of Strings and the ordering mode set to ascending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by string-length(xs:string($x)) ascending return string-length(xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-17.txt')

!

test_orderbylocal_18

    | query result |

    query := ' 
        (: name : orderbylocal-18 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "count($x) ", where $x is a set of Strings and the ordering mode set to ascending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by count(xs:string($x)) ascending return count(xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-18.txt')

!

test_orderbylocal_19

    | query result |

    query := ' 
        (: name : orderbylocal-19 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "string-length($x) ", where $x is a set of Strings and the ordering mode set to ascending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by string-length(xs:string($x)) ascending return string-length(xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-19.txt')

!

test_orderbylocal_2

    | query result |

    query := ' 
        (: name : orderbylocal-2 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of Strings and the ordering mode set to descending :)
(: Uses a local sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by xs:string($x) descending return xs:string($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-2.txt')

!

test_orderbylocal_20

    | query result |

    query := ' 
        (: name : orderbylocal-20 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of negative numbers and the ordering mode set to ascending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by xs:decimal($x) ascending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-20.txt')

!

test_orderbylocal_21

    | query result |

    query := ' 
        (: name : orderbylocal-21 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-21.txt')

!

test_orderbylocal_22

    | query result |

    query := ' 
        (: name : orderbylocal-22 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "($x + $x) ", where $x is a set of negative numbers and the ordering mode set to descending :)
(: Use a locally define sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by (xs:decimal($x) + xs:decimal($x)) descending return xs:decimal($x) + xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-22.txt')

!

test_orderbylocal_25

    | query result |

    query := ' 
        (: name : orderbylocal-25 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:float($x) ", where $x is a set of negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by xs:float($x) descending return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-25.txt')

!

test_orderbylocal_26

    | query result |

    query := ' 
        (: name : orderbylocal-26 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:decimal($x) ", where $x is a set of negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-26.txt')

!

test_orderbylocal_27

    | query result |

    query := ' 
        (: name : orderbylocal-27 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:double($x) ", where $x is a set of negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by xs:double($x) descending return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-27.txt')

!

test_orderbylocal_28

    | query result |

    query := ' 
        (: name : orderbylocal-28 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:integer($x) ", where $x is a set of negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by xs:integer($x) descending return xs:integer($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-28.txt')

!

test_orderbylocal_29

    | query result |

    query := ' 
        (: name : orderbylocal-29 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "($x * -1) ", where $x is a set of negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-100000000000000000,-10000000000000000,-1000000000000000,-100000000000000,-10000000000000,-1000000000000,-100000000000,-10000000000,-1000000000,-100000000,-10000000,-1000000,-100000,-10000,-1000,-100,-10,-1,-0)
 order by (xs:decimal($x) * -1) descending return (xs:decimal($x) * -1)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-29.txt')

!

test_orderbylocal_3

    | query result |

    query := ' 
        (: name : orderbylocal-3 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"()") ", where $x is a set of Strings and the ordering mode set to ascending :)
(: Uses a local sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),"()") ascending return concat(xs:string($x),"()")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-3.txt')

!

test_orderbylocal_30

    | query result |

    query := ' 
        (: name : orderbylocal-30 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of positive numbers and the ordering mode set to ascending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:decimal($x) ascending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-30.txt')

!

test_orderbylocal_31

    | query result |

    query := ' 
        (: name : orderbylocal-31 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of positive numbers and the ordering mode set to descending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-31.txt')

!

test_orderbylocal_32

    | query result |

    query := ' 
        (: name : orderbylocal-32 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "($x + $x) ", where $x is a set of positive numbers and the ordering mode set to descending :)
(: Use a locally defined sequwnce. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by (xs:decimal($x) + xs:decimal($x)) descending return xs:decimal($x) + xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-32.txt')

!

test_orderbylocal_35

    | query result |

    query := ' 
        (: name : orderbylocal-35 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:float($x) ", where $x is a set of positive numbers and the ordering mode set to descending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:float($x) descending return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-35.txt')

!

test_orderbylocal_36

    | query result |

    query := ' 
        (: name : orderbylocal-36 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:decimal($x) ", where $x is a set of positive numbers and the ordering mode set to descending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-36.txt')

!

test_orderbylocal_37

    | query result |

    query := ' 
        (: name : orderbylocal-37 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:double($x) ", where $x is a set of positive numbers and the ordering mode set to descending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:double($x) descending return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-37.txt')

!

test_orderbylocal_38

    | query result |

    query := ' 
        (: name : orderbylocal-38 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:integer($x) ", where $x is a set of positive numbers and the ordering mode set to descending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by xs:integer($x) descending return xs:integer($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-38.txt')

!

test_orderbylocal_39

    | query result |

    query := ' 
        (: name : orderbylocal-39 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "string($x) ", where $x is a set of positive numbers and the ordering mode set to ascending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (100000000000000000,10000000000000000,1000000000000000,100000000000000,10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0)
 order by string($x) ascending return string($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-39.txt')

!

test_orderbylocal_4

    | query result |

    query := ' 
        (: name : orderbylocal-4 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"()") ", where $x is a set of Strings and the ordering mode set to descending :)
(: Uses a locally defined string :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),"()") descending return concat(xs:string($x),"()")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-4.txt')

!

test_orderbylocal_40

    | query result |

    query := ' 
        (: name : orderbylocal-40 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of small positive numbers and the ordering mode set to ascending :)
(: Use a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by $x ascending return $x
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-40.txt')

!

test_orderbylocal_41

    | query result |

    query := ' 
        (: name : orderbylocal-41 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of small positive numbers and the ordering mode set to descending :)
(: Uses a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-41.txt')

!

test_orderbylocal_42

    | query result |

    query := ' 
        (: name : orderbylocal-42 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "($x + $x) ", where $x is a set of small positive numbers and the ordering mode set to descending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by (xs:decimal($x) + xs:decimal($x)) descending return xs:decimal($x) + xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-42.txt')

!

test_orderbylocal_43

    | query result |

    query := ' 
        (: name : orderbylocal-43 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of small positive numbers and the ordering mode set to ascending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results>{
for $x in (<a>0.000000000000000001</a>,<a>0.00000000000000001</a>,<a>0.0000000000000001</a>,<a>0.000000000000001</a>,<a>0.00000000000001</a>,<a>0.0000000000001</a>,<a>0.000000000001</a>,<a>0.00000000001</a>,<a>0.0000000001</a>,<a>0.000000001</a>,<a>0.00000001</a>,<a>0.0000001</a>,<a>0.000001</a>,<a>0.00001</a>,<a>0.0001</a>,<a>0.001</a>,<a>0.01</a>,<a>0.1</a>,<a>0.0</a>)
order by $x is $x ascending return $x is $x}</results>
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-43.txt')

!

test_orderbylocal_44

    | query result |

    query := ' 
        (: name : orderbylocal-44 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x is $x ", where $x is a set of small positive numbers and the ordering mode set to descending :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results>{ for $x in (<a>0.000000000000000001</a>,<a>0.00000000000000001</a>,<a>0.0000000000000001</a>,<a>0.000000000000001</a>,<a>0.00000000000001</a>,<a>0.0000000000001</a>,<a>0.000000000001</a>,<a>0.00000000001</a>,<a>0.0000000001</a>,<a>0.000000001</a>,<a>0.00000001</a>,<a>0.0000001</a>,<a>0.000001</a>,<a>0.00001</a>,<a>0.0001</a>,<a>0.001</a>,<a>0.01</a>,<a>0.1</a>,<a>0.0</a>)
order by $x is $x descending return $x is $x }</results>
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-44.txt')

!

test_orderbylocal_45

    | query result |

    query := ' 
        (: name : orderbylocal-45 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:float($x) ", where $x is a set of small positive numbers and the ordering mode set to descending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by xs:float($x) descending return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-45.txt')

!

test_orderbylocal_46

    | query result |

    query := ' 
        (: name : orderbylocal-46 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:decimal($x) ", where $x is a set of small positive numbers and the ordering mode set to descending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-46.txt')

!

test_orderbylocal_47

    | query result |

    query := ' 
        (: name : orderbylocal-47 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:double($x) ", where $x is a set of small positive numbers and the ordering mode set to descending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by xs:double($x) descending return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-47.txt')

!

test_orderbylocal_49

    | query result |

    query := ' 
        (: name : orderbylocal-49 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "string($x) ", where $x is a set of small positive numbers and the ordering mode set to ascending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (0.000000000000000001,0.00000000000000001,0.0000000000000001,0.000000000000001,0.00000000000001,0.0000000000001,0.000000000001,0.00000000001,0.0000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,0.0)
 order by string($x) ascending return string($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-49.txt')

!

test_orderbylocal_5

    | query result |

    query := ' 
        (: name : orderbylocal-5 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"another String After") ", where $x is a set of Strings and the ordering mode set to ascending :)
(: Uses Locally define sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),"another String After") ascending return concat(xs:string($x),"another String After")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-5.txt')

!

test_orderbylocal_50

    | query result |

    query := ' 
        (: name : orderbylocal-50 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of small negative numbers and the ordering mode set to ascending :)
(: Use a locally definded sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by xs:decimal($x) ascending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-50.txt')

!

test_orderbylocal_51

    | query result |

    query := ' 
        (: name : orderbylocal-51 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "$x ", where $x is a set of small negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-51.txt')

!

test_orderbylocal_52

    | query result |

    query := ' 
        (: name : orderbylocal-52 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "($x + $x) ", where $x is a set of small negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by (xs:decimal($x) + xs:decimal($x)) descending return xs:decimal($x) + xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-52.txt')

!

test_orderbylocal_55

    | query result |

    query := ' 
        (: name : orderbylocal-55 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:float($x) ", where $x is a set of small negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by xs:float($x) descending return xs:float($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-55.txt')

!

test_orderbylocal_56

    | query result |

    query := ' 
        (: name : orderbylocal-56 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:decimal($x) ", where $x is a set of small negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by xs:decimal($x) descending return xs:decimal($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-56.txt')

!

test_orderbylocal_57

    | query result |

    query := ' 
        (: name : orderbylocal-57 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "xs:double($x) ", where $x is a set of small negative numbers and the ordering mode set to descending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by xs:double($x) descending return xs:double($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-57.txt')

!

test_orderbylocal_59

    | query result |

    query := ' 
        (: name : orderbylocal-59 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "string($x) ", where $x is a set of small negative numbers and the ordering mode set to ascending :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in (-0.000000000000000001,-0.00000000000000001,-0.0000000000000001,-0.000000000000001,-0.00000000000001,-0.0000000000001,-0.000000000001,-0.00000000001,-0.0000000001,-0.000000001,-0.00000001,-0.0000001,-0.000001,-0.00001,-0.0001,-0.001,-0.01,-0.0,-0.1)
 order by string($x) ascending return string($x)
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-59.txt')

!

test_orderbylocal_6

    | query result |

    query := ' 
        (: name : orderbylocal-6 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"another String After") ", where $x is a set of Strings and the ordering mode set to descending :)
(: Uses a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),"another String After") descending return concat(xs:string($x),"another String After")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-6.txt')

!

test_orderbylocal_60

    | query result |

    query := ' 
        (: name : orderbylocal-60 :)
(: description : Evaluation of "order by" clause with an unknown collation. :)
(: Use a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)


for $x in ("A","B","C")
 order by string($x) ascending collation "http://nonexistentcollition.org/ifsupportedwoooayouarethebestQueryimplementation/makeitharder" return string($x)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_orderbylocal_7

    | query result |

    query := ' 
        (: name : orderbylocal-7 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat("another String Before",$x) ", where $x is a set of Strings and the ordering mode set to ascending :)
(: uses a locally defined sequence :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat("another String Before",xs:string($x)) ascending return concat("another String Before",xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-7.txt')

!

test_orderbylocal_8

    | query result |

    query := ' 
        (: name : orderbylocal-8 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat("another String Before",$x) ", where $x is a set of Strings and the ordering mode set to descending :)
(: Uses a locally defined sequence. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat("another String Before",xs:string($x)) descending return concat("another String Before",xs:string($x))
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-8.txt')

!

test_orderbylocal_9

    | query result |

    query := ' 
        (: name : orderbylocal-9 :)
(: description : Evaluation of "order by" clause with the "order by" clause of a FLWR expression set to "concat($x,"") ", where $x is a set of Strings and the ordering mode set to descending :)
(: Uses a locally defined sequence . :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<results> {
for $x in ("A String","B String","C String","D String","E String","F String","G String","H String","I String","J String","K String","L String","M String","N String","O String","P String","R String","S String","T String","U String","V String","W String","X String","Y String","Z String")
 order by concat(xs:string($x),"") descending return concat(xs:string($x),"")
}
</results>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/OrderbyExpr/OrderbyExprWith/orderbylocal-9.txt')

! !

!XQTSOrderbyExprWithTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
