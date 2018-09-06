"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSNumericIntegerDivideTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSNumericIntegerDivideTests methodsFor:'tests'!

test_K_NumericIntegerDivide_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-1                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) idiv xs:integer(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:decimal(6) idiv xs:integer(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-1.txt')

!

test_K_NumericIntegerDivide_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-10                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) idiv xs:float(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:float(6) idiv xs:float(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-10.txt')

!

test_K_NumericIntegerDivide_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-11                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) idiv xs:double(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:decimal(6) idiv xs:double(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-11.txt')

!

test_K_NumericIntegerDivide_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-12                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) idiv xs:decimal(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:double(6) idiv xs:decimal(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-12.txt')

!

test_K_NumericIntegerDivide_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-13                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) idiv xs:float(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:double(6) idiv xs:float(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-13.txt')

!

test_K_NumericIntegerDivide_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-14                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) idiv xs:double(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:float(6) idiv xs:double(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-14.txt')

!

test_K_NumericIntegerDivide_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-15                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) idiv xs:integer(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:double(6) idiv xs:integer(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-15.txt')

!

test_K_NumericIntegerDivide_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-16                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) idiv xs:double(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:integer(6) idiv xs:double(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-16.txt')

!

test_K_NumericIntegerDivide_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-17                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) idiv xs:double(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:double(6) idiv xs:double(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-17.txt')

!

test_K_NumericIntegerDivide_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-18                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `10 idiv 3 eq 3`.   :)
(:*******************************************************:)
10 idiv 3 eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-18.txt')

!

test_K_NumericIntegerDivide_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-19                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `3 idiv -2 eq -1`.  :)
(:*******************************************************:)
3 idiv -2 eq -1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-19.txt')

!

test_K_NumericIntegerDivide_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-2                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) idiv xs:decimal(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:integer(6) idiv xs:decimal(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-2.txt')

!

test_K_NumericIntegerDivide_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-20                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `-3 idiv 2 eq -1`.  :)
(:*******************************************************:)
-3 idiv 2 eq -1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-20.txt')

!

test_K_NumericIntegerDivide_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-21                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `-3 idiv -2 eq 1`.  :)
(:*******************************************************:)
-3 idiv -2 eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-21.txt')

!

test_K_NumericIntegerDivide_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-22                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `5.0 idiv 2.0 eq 2`. :)
(:*******************************************************:)
5.0 idiv 2.0 eq 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-22.txt')

!

test_K_NumericIntegerDivide_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-23                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `9.0 idiv 3 eq 3`.  :)
(:*******************************************************:)
9.0 idiv 3 eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-23.txt')

!

test_K_NumericIntegerDivide_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-24                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `-3.5 idiv 3 eq -1`. :)
(:*******************************************************:)
-3.5 idiv 3 eq -1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-24.txt')

!

test_K_NumericIntegerDivide_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-25                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `3.0 idiv 4 eq 0`.  :)
(:*******************************************************:)
3.0 idiv 4 eq 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-25.txt')

!

test_K_NumericIntegerDivide_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-26                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `3.1E1 idiv 6 eq 5`. :)
(:*******************************************************:)
3.1E1 idiv 6 eq 5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-26.txt')

!

test_K_NumericIntegerDivide_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-27                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `3.1E1 idiv 7 eq 4`. :)
(:*******************************************************:)
3.1E1 idiv 7 eq 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-27.txt')

!

test_K_NumericIntegerDivide_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-28                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(1.1 idiv 1) instance of xs:integer`. :)
(:*******************************************************:)
(1.1 idiv 1) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-28.txt')

!

test_K_NumericIntegerDivide_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-29                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(1.1) idiv 1.1) instance of xs:integer`. :)
(:*******************************************************:)
(xs:double(1.1) idiv 1.1) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-29.txt')

!

test_K_NumericIntegerDivide_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-3                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) idiv xs:integer(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:integer(6) idiv xs:integer(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-3.txt')

!

test_K_NumericIntegerDivide_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-30                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `3 idiv 1.1 eq 2`.  :)
(:*******************************************************:)
3 idiv 1.1 eq 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-30.txt')

!

test_K_NumericIntegerDivide_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-31                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `1 idiv xs:float("NaN")`. :)
(:*******************************************************:)
1 idiv xs:float("NaN")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-32                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float("NaN") idiv 1`. :)
(:*******************************************************:)
xs:float("NaN") idiv 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-33                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float("INF") idiv xs:float(3)`. :)
(:*******************************************************:)
xs:float("INF") idiv xs:float(3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_34

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-34                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float("-INF") idiv xs:float(3)`. :)
(:*******************************************************:)
xs:float("-INF") idiv xs:float(3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_35

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-35                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float("3") idiv xs:float("INF") eq xs:float(0)`. :)
(:*******************************************************:)
xs:float("3") idiv xs:float("INF") eq xs:float(0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-35.txt')

!

test_K_NumericIntegerDivide_36

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-36                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float("3") idiv xs:float("-INF") eq xs:float(0)`. :)
(:*******************************************************:)
xs:float("3") idiv xs:float("-INF") eq xs:float(0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-36.txt')

!

test_K_NumericIntegerDivide_37

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-37                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `1 idiv xs:double("NaN")`. :)
(:*******************************************************:)
1 idiv xs:double("NaN")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_38

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-38                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double("NaN") idiv 1`. :)
(:*******************************************************:)
xs:double("NaN") idiv 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_39

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-39                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double("INF") idiv xs:double(3)`. :)
(:*******************************************************:)
xs:double("INF") idiv xs:double(3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-4                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) idiv xs:decimal(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:decimal(6) idiv xs:decimal(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-4.txt')

!

test_K_NumericIntegerDivide_40

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-40                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double("-INF") idiv xs:double(3)`. :)
(:*******************************************************:)
xs:double("-INF") idiv xs:double(3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_41

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-41                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double("3") idiv xs:double("INF") eq xs:double(0)`. :)
(:*******************************************************:)
xs:double("3") idiv xs:double("INF") eq xs:double(0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-41.txt')

!

test_K_NumericIntegerDivide_42

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-42                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double("3") idiv xs:double("-INF") eq xs:double(0)`. :)
(:*******************************************************:)
xs:double("3") idiv xs:double("-INF") eq xs:double(0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-42.txt')

!

test_K_NumericIntegerDivide_43

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-43                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace for the "idiv" operator.  :)
(:*******************************************************:)
10idiv 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_44

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-44                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace for the "idiv" operator.  :)
(:*******************************************************:)
10 idiv3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_45

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-45                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace for the "idiv" operator.  :)
(:*******************************************************:)
10idiv3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_46

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-46                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "idiv operator with invalid operands. :)
(:*******************************************************:)
"3" idiv "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_47

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-47                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "idiv" operator with invalid operands. :)
(:*******************************************************:)
"3" idiv xs:float(3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_48

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-48                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:untypedAtomic("9") idiv xs:float(5)) eq 1`. :)
(:*******************************************************:)
(xs:untypedAtomic("9") idiv xs:float(5)) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-48.txt')

!

test_K_NumericIntegerDivide_49

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-49                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(9) idiv xs:untypedAtomic("5")) eq 1`. :)
(:*******************************************************:)
(xs:float(9) idiv xs:untypedAtomic("5")) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-49.txt')

!

test_K_NumericIntegerDivide_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-5                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) idiv xs:decimal(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:decimal(6) idiv xs:decimal(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-5.txt')

!

test_K_NumericIntegerDivide_50

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-50                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke "idiv" where an untypedAtomic conversion fails. :)
(:*******************************************************:)
(xs:untypedAtomic("nine") idiv xs:float(5)) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_51

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-51                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke "idiv" where an untypedAtomic conversion fails. :)
(:*******************************************************:)
(xs:float(9) idiv xs:untypedAtomic("five")) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericIntegerDivide_52

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-52                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() idiv ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-52.txt')

!

test_K_NumericIntegerDivide_53

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-53                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() idiv xs:decimal(1))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-53.txt')

!

test_K_NumericIntegerDivide_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-6                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) idiv xs:decimal(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:float(6) idiv xs:decimal(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-6.txt')

!

test_K_NumericIntegerDivide_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-7                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) idiv xs:float(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:decimal(6) idiv xs:float(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-7.txt')

!

test_K_NumericIntegerDivide_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-8                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) idiv xs:integer(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:float(6) idiv xs:integer(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-8.txt')

!

test_K_NumericIntegerDivide_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericIntegerDivide-9                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) idiv xs:float(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:integer(6) idiv xs:float(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/K-NumericIntegerDivide-9.txt')

!

test_op_numeric_integer_divide_1

    | query result |

    query := ' 
        (:Test: op-numeric-integer-divide-1                                           :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator for error condition. :)


(0 div 0E0) idiv xs:integer(2)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_integer_dividedec2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividedec2args-1               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("-999999999999999999") idiv xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividedec2args-1.txt')

!

test_op_numeric_integer_dividedec2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividedec2args-2               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(mid range)                          :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("617375191608514839") idiv xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividedec2args-2.txt')

!

test_op_numeric_integer_dividedec2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividedec2args-3               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(upper bound)                        :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("999999999999999999") idiv xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividedec2args-3.txt')

!

test_op_numeric_integer_dividedec2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividedec2args-4               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(mid range)                          :)
(:*******************************************************:)

xs:decimal("-999999999999999999") idiv xs:decimal("617375191608514839")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividedec2args-4.txt')

!

test_op_numeric_integer_dividedec2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividedec2args-5               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(upper bound)                        :)
(:*******************************************************:)

xs:decimal("-999999999999999999") idiv xs:decimal("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividedec2args-5.txt')

!

test_op_numeric_integer_divideint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideint2args-1               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

xs:int("-2147483648") idiv xs:int("-2147483648")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideint2args-1.txt')

!

test_op_numeric_integer_divideint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideint2args-2               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(mid range)                              :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

xs:int("-1873914410") idiv xs:int("-2147483648")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideint2args-2.txt')

!

test_op_numeric_integer_divideint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideint2args-3               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(upper bound)                            :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

xs:int("2147483647") idiv xs:int("-2147483648")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideint2args-3.txt')

!

test_op_numeric_integer_divideint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideint2args-4               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(mid range)                              :)
(:*******************************************************:)

xs:int("-2147483648") idiv xs:int("-1873914410")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideint2args-4.txt')

!

test_op_numeric_integer_divideint2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideint2args-5               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(upper bound)                            :)
(:*******************************************************:)

xs:int("-2147483648") idiv xs:int("2147483647")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideint2args-5.txt')

!

test_op_numeric_integer_divideintg2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideintg2args-1              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

xs:integer("-999999999999999999") idiv xs:integer("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideintg2args-1.txt')

!

test_op_numeric_integer_divideintg2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideintg2args-2              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(mid range)                          :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

xs:integer("830993497117024304") idiv xs:integer("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideintg2args-2.txt')

!

test_op_numeric_integer_divideintg2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideintg2args-3              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(upper bound)                        :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

xs:integer("999999999999999999") idiv xs:integer("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideintg2args-3.txt')

!

test_op_numeric_integer_divideintg2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideintg2args-4              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(mid range)                          :)
(:*******************************************************:)

xs:integer("-999999999999999999") idiv xs:integer("830993497117024304")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideintg2args-4.txt')

!

test_op_numeric_integer_divideintg2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideintg2args-5              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(upper bound)                        :)
(:*******************************************************:)

xs:integer("-999999999999999999") idiv xs:integer("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideintg2args-5.txt')

!

test_op_numeric_integer_dividelng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividelng2args-1               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

xs:long("-92233720368547758") idiv xs:long("-92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividelng2args-1.txt')

!

test_op_numeric_integer_dividelng2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividelng2args-2               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(mid range)                             :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

xs:long("-47175562203048468") idiv xs:long("-92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividelng2args-2.txt')

!

test_op_numeric_integer_dividelng2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividelng2args-3               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(upper bound)                           :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

xs:long("92233720368547758") idiv xs:long("-92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividelng2args-3.txt')

!

test_op_numeric_integer_dividelng2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividelng2args-4               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(mid range)                             :)
(:*******************************************************:)

xs:long("-92233720368547758") idiv xs:long("-47175562203048468")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividelng2args-4.txt')

!

test_op_numeric_integer_dividelng2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividelng2args-5               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(upper bound)                           :)
(:*******************************************************:)

xs:long("-92233720368547758") idiv xs:long("92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividelng2args-5.txt')

!

test_op_numeric_integer_dividemix2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-integer-dividemix2args-1.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 16:05:25 2005                        :)
(: Purpose: Simple integer division test with () as one operand should return null :)
(:*******************************************************:)

() idiv 1 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividemix2args-1.txt')

!

test_op_numeric_integer_dividemix2args_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-integer-dividemix2args-9.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 16:05:26 2005                        :)
(: Purpose: If the divisor is zer0, then an error is raised :)
(:*******************************************************:)

1 idiv 0 

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_integer_dividemix2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-integer-dividemix2args-2.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 16:05:25 2005                        :)
(: Purpose: Simple integer division test pass string for second operator :)
(:*******************************************************:)

1 idiv "1" 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_integer_dividemix2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-integer-dividemix2args-3.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 16:05:25 2005                        :)
(: Purpose: Simple integer division test, second operator cast string to integer :)
(:*******************************************************:)

1 idiv xs:integer("1")



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividemix2args-3.txt')

!

test_op_numeric_integer_dividemix2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-integer-dividemix2args-4.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 16:05:25 2005                        :)
(: Purpose: Simple integer division test, second operator is a node, atomization applied :)
(:*******************************************************:)

3 idiv <a> 2 </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividemix2args-4.txt')

!

test_op_numeric_integer_dividemix2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-integer-dividemix2args-5.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 16:05:25 2005                        :)
(: Purpose: Simple integer division test, second operator is a node, atomization applied :)
(:*******************************************************:)

1 idiv <a> <b> 2 </b> </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividemix2args-5.txt')

!

test_op_numeric_integer_dividemix2args_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-integer-dividemix2args-6.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 16:05:25 2005                        :)
(: Purpose: Simple integer division test, second operator node which is not atomizable :)
(:*******************************************************:)

3 idiv <a> <b> 2</b> <c> 2</c> </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_integer_dividemix2args_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-integer-dividemix2args-7.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 16:05:25 2005                        :)
(: Purpose: Simple integer division test, two operands are nodes :)
(:*******************************************************:)

<a> 1 </a> idiv <b> 2 </b>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividemix2args-7.txt')

!

test_op_numeric_integer_dividemix2args_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-integer-dividemix2args-8.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 16:05:25 2005                        :)
(: Purpose: Simple integer division test, second operator is a node, atomizable but not castable to integer :)
(:*******************************************************:)

1 idiv <a> x </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_integer_dividemix2args_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-integer-dividemix2args-9.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 16:05:26 2005                        :)
(: Purpose: Simple integer division test pass an empty node for second operator:)
(:*******************************************************:)

1 idiv <a/>





      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_integer_dividenint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenint2args-1              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(lower bound)                :)
(:$arg2 = xs:negativeInteger(lower bound)                :)
(:*******************************************************:)

xs:negativeInteger("-999999999999999999") idiv xs:negativeInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenint2args-1.txt')

!

test_op_numeric_integer_dividenint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenint2args-2              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(mid range)                  :)
(:$arg2 = xs:negativeInteger(lower bound)                :)
(:*******************************************************:)

xs:negativeInteger("-297014075999096793") idiv xs:negativeInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenint2args-2.txt')

!

test_op_numeric_integer_dividenint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenint2args-3              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(upper bound)                :)
(:$arg2 = xs:negativeInteger(lower bound)                :)
(:*******************************************************:)

xs:negativeInteger("-1") idiv xs:negativeInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenint2args-3.txt')

!

test_op_numeric_integer_dividenint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenint2args-4              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(lower bound)                :)
(:$arg2 = xs:negativeInteger(mid range)                  :)
(:*******************************************************:)

xs:negativeInteger("-999999999999999999") idiv xs:negativeInteger("-297014075999096793")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenint2args-4.txt')

!

test_op_numeric_integer_dividenint2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenint2args-5              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(lower bound)                :)
(:$arg2 = xs:negativeInteger(upper bound)                :)
(:*******************************************************:)

xs:negativeInteger("-999999999999999999") idiv xs:negativeInteger("-1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenint2args-5.txt')

!

test_op_numeric_integer_dividenni2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenni2args-1               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(mid range)               :)
(:*******************************************************:)

xs:nonNegativeInteger("0") idiv xs:nonNegativeInteger("303884545991464527")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenni2args-1.txt')

!

test_op_numeric_integer_dividenni2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenni2args-2               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(upper bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("0") idiv xs:nonNegativeInteger("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenni2args-2.txt')

!

test_op_numeric_integer_dividenpi2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenpi2args-1               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(lower bound)             :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("-999999999999999999") idiv xs:nonPositiveInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenpi2args-1.txt')

!

test_op_numeric_integer_dividenpi2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenpi2args-2               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(mid range)               :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("-475688437271870490") idiv xs:nonPositiveInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenpi2args-2.txt')

!

test_op_numeric_integer_dividenpi2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenpi2args-3               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(upper bound)             :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("0") idiv xs:nonPositiveInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenpi2args-3.txt')

!

test_op_numeric_integer_dividenpi2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividenpi2args-4               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(lower bound)             :)
(:$arg2 = xs:nonPositiveInteger(mid range)               :)
(:*******************************************************:)

xs:nonPositiveInteger("-999999999999999999") idiv xs:nonPositiveInteger("-475688437271870490")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividenpi2args-4.txt')

!

test_op_numeric_integer_dividepint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividepint2args-1              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("1") idiv xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividepint2args-1.txt')

!

test_op_numeric_integer_dividepint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividepint2args-2              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(mid range)                  :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("52704602390610033") idiv xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividepint2args-2.txt')

!

test_op_numeric_integer_dividepint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividepint2args-3              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(upper bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("999999999999999999") idiv xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividepint2args-3.txt')

!

test_op_numeric_integer_dividepint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividepint2args-4              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(mid range)                  :)
(:*******************************************************:)

xs:positiveInteger("1") idiv xs:positiveInteger("52704602390610033")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividepint2args-4.txt')

!

test_op_numeric_integer_dividepint2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividepint2args-5              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(upper bound)                :)
(:*******************************************************:)

xs:positiveInteger("1") idiv xs:positiveInteger("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividepint2args-5.txt')

!

test_op_numeric_integer_dividesht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividesht2args-1               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

xs:short("-32768") idiv xs:short("-32768")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividesht2args-1.txt')

!

test_op_numeric_integer_dividesht2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividesht2args-2               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(mid range)                            :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

xs:short("-5324") idiv xs:short("-32768")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividesht2args-2.txt')

!

test_op_numeric_integer_dividesht2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividesht2args-3               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(upper bound)                          :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

xs:short("32767") idiv xs:short("-32768")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividesht2args-3.txt')

!

test_op_numeric_integer_dividesht2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividesht2args-4               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(mid range)                            :)
(:*******************************************************:)

xs:short("-32768") idiv xs:short("-5324")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividesht2args-4.txt')

!

test_op_numeric_integer_dividesht2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-dividesht2args-5               :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(upper bound)                          :)
(:*******************************************************:)

xs:short("-32768") idiv xs:short("32767")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-dividesht2args-5.txt')

!

test_op_numeric_integer_divideulng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideulng2args-1              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(mid range)                     :)
(:*******************************************************:)

xs:unsignedLong("0") idiv xs:unsignedLong("130747108607674654")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideulng2args-1.txt')

!

test_op_numeric_integer_divideulng2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideulng2args-2              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(upper bound)                   :)
(:*******************************************************:)

xs:unsignedLong("0") idiv xs:unsignedLong("184467440737095516")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideulng2args-2.txt')

!

test_op_numeric_integer_divideusht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideusht2args-1              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(mid range)                    :)
(:*******************************************************:)

xs:unsignedShort("0") idiv xs:unsignedShort("44633")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideusht2args-1.txt')

!

test_op_numeric_integer_divideusht2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-integer-divideusht2args-2              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-integer-divide" operator:)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(upper bound)                  :)
(:*******************************************************:)

xs:unsignedShort("0") idiv xs:unsignedShort("65535")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericIntegerDivide/op-numeric-integer-divideusht2args-2.txt')

! !

!XQTSNumericIntegerDivideTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
