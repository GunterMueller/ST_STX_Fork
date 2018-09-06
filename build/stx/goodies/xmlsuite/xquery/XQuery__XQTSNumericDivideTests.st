"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSNumericDivideTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSNumericDivideTests methodsFor:'tests'!

test_K_NumericDivide_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-1                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double(6) div xs:double(2) eq 3`. :)
(:*******************************************************:)
xs:double(6) div xs:double(2) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-1.txt')

!

test_K_NumericDivide_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-10                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:integer(5) div xs:integer(2) ne 2.6`. :)
(:*******************************************************:)
xs:integer(5) div xs:integer(2) ne 2.6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-10.txt')

!

test_K_NumericDivide_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-11                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:decimal(5) div xs:decimal(2) eq 2.5`. :)
(:*******************************************************:)
xs:decimal(5) div xs:decimal(2) eq 2.5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-11.txt')

!

test_K_NumericDivide_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-12                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:decimal(5) div xs:decimal(2) ne 2.6`. :)
(:*******************************************************:)
xs:decimal(5) div xs:decimal(2) ne 2.6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-12.txt')

!

test_K_NumericDivide_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-13                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `5 div 2 ne 2.6`.   :)
(:*******************************************************:)
5 div 2 ne 2.6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-13.txt')

!

test_K_NumericDivide_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-14                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `5.0 div 2.0 eq 2.5`. :)
(:*******************************************************:)
5.0 div 2.0 eq 2.5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-14.txt')

!

test_K_NumericDivide_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-15                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `5.0 div 2.0 ne 2.6`. :)
(:*******************************************************:)
5.0 div 2.0 ne 2.6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-15.txt')

!

test_K_NumericDivide_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-16                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) div xs:integer(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:decimal(6) div xs:integer(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-16.txt')

!

test_K_NumericDivide_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-17                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) div xs:decimal(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:integer(6) div xs:decimal(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-17.txt')

!

test_K_NumericDivide_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-18                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) div xs:integer(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:integer(6) div xs:integer(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-18.txt')

!

test_K_NumericDivide_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-19                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) div xs:decimal(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:decimal(6) div xs:decimal(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-19.txt')

!

test_K_NumericDivide_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-2                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:decimal(6) div xs:decimal(2) eq 3`. :)
(:*******************************************************:)
xs:decimal(6) div xs:decimal(2) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-2.txt')

!

test_K_NumericDivide_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-20                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) div xs:decimal(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) div xs:decimal(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-20.txt')

!

test_K_NumericDivide_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-21                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) div xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:decimal(6) div xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-21.txt')

!

test_K_NumericDivide_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-22                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) div xs:integer(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) div xs:integer(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-22.txt')

!

test_K_NumericDivide_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-23                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) div xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:integer(6) div xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-23.txt')

!

test_K_NumericDivide_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-24                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) div xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) div xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-24.txt')

!

test_K_NumericDivide_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-25                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) div xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:decimal(6) div xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-25.txt')

!

test_K_NumericDivide_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-26                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) div xs:decimal(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) div xs:decimal(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-26.txt')

!

test_K_NumericDivide_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-27                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) div xs:float(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) div xs:float(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-27.txt')

!

test_K_NumericDivide_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-28                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) div xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:float(6) div xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-28.txt')

!

test_K_NumericDivide_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-29                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) div xs:integer(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) div xs:integer(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-29.txt')

!

test_K_NumericDivide_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-3                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:integer(6) div xs:integer(2) eq 3`. :)
(:*******************************************************:)
xs:integer(6) div xs:integer(2) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-3.txt')

!

test_K_NumericDivide_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-30                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) div xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:integer(6) div xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-30.txt')

!

test_K_NumericDivide_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-31                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) div xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) div xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-31.txt')

!

test_K_NumericDivide_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-32                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "div operator with invalid operands. :)
(:*******************************************************:)
"3" div "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericDivide_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-33                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "div" operator with invalid operands. :)
(:*******************************************************:)
xs:double(3) div "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericDivide_34

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-34                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(3) div xs:untypedAtomic("3")) eq 1`. :)
(:*******************************************************:)
(xs:double(3) div xs:untypedAtomic("3")) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-34.txt')

!

test_K_NumericDivide_35

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-35                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:untypedAtomic("3") div xs:double(3)) eq 1`. :)
(:*******************************************************:)
(xs:untypedAtomic("3") div xs:double(3)) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-35.txt')

!

test_K_NumericDivide_36

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-36                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace for the "div" operator.   :)
(:*******************************************************:)
10 div3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericDivide_37

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-37                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace for the "div" operator.   :)
(:*******************************************************:)
10div 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericDivide_38

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-38                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace for the "div" operator.   :)
(:*******************************************************:)
10div3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericDivide_39

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-39                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() div ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-39.txt')

!

test_K_NumericDivide_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-4                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(6) div xs:float(2) eq 3`. :)
(:*******************************************************:)
xs:float(6) div xs:float(2) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-4.txt')

!

test_K_NumericDivide_40

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-40                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(1 div ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-40.txt')

!

test_K_NumericDivide_41

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-41                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() div 1)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-41.txt')

!

test_K_NumericDivide_42

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-42                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(xs:double(3) div ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-42.txt')

!

test_K_NumericDivide_43

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-43                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() div xs:decimal(1))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-43.txt')

!

test_K_NumericDivide_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-5                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double(5) div xs:double(2) eq 2.5`. :)
(:*******************************************************:)
xs:double(5) div xs:double(2) eq 2.5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-5.txt')

!

test_K_NumericDivide_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-6                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double(5) div xs:double(2) ne 2.6`. :)
(:*******************************************************:)
xs:double(5) div xs:double(2) ne 2.6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-6.txt')

!

test_K_NumericDivide_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-7                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(5) div xs:float(2) eq 2.5`. :)
(:*******************************************************:)
xs:float(5) div xs:float(2) eq 2.5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-7.txt')

!

test_K_NumericDivide_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-8                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(5) div xs:float(2) ne 2.6`. :)
(:*******************************************************:)
xs:float(5) div xs:float(2) ne 2.6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-8.txt')

!

test_K_NumericDivide_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericDivide-9                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:integer(5) div xs:integer(2) eq 2.5`. :)
(:*******************************************************:)
xs:integer(5) div xs:integer(2) eq 2.5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/K-NumericDivide-9.txt')

!

test_op_numeric_dividedbl2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividedbl2args-1                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("-1.7976931348623157E308") div xs:double("-1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividedbl2args-1.txt')

!

test_op_numeric_dividedbl2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividedbl2args-2                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(mid range)                           :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("0") div xs:double("-1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividedbl2args-2.txt')

!

test_op_numeric_dividedbl2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividedbl2args-3                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(upper bound)                         :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("1.7976931348623157E308") div xs:double("-1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividedbl2args-3.txt')

!

test_op_numeric_dividedbl2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividedbl2args-4                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(upper bound)                         :)
(:*******************************************************:)

xs:double("-1.7976931348623157E308") div xs:double("1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividedbl2args-4.txt')

!

test_op_numeric_dividedec2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividedec2args-1                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("-999999999999999999") div xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividedec2args-1.txt')

!

test_op_numeric_dividedec2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividedec2args-2                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(mid range)                          :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

fn:round-half-to-even((xs:decimal("617375191608514839") div xs:decimal("-999999999999999999")),18)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividedec2args-2.txt')

!

test_op_numeric_dividedec2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividedec2args-3                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(upper bound)                        :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("999999999999999999") div xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividedec2args-3.txt')

!

test_op_numeric_dividedec2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividedec2args-4                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(mid range)                          :)
(:*******************************************************:)

fn:round-half-to-even((xs:decimal("-999999999999999999") div xs:decimal("617375191608514839")),18)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividedec2args-4.txt')

!

test_op_numeric_dividedec2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividedec2args-5                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(upper bound)                        :)
(:*******************************************************:)

xs:decimal("-999999999999999999") div xs:decimal("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividedec2args-5.txt')

!

test_op_numeric_divideflt2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideflt2args-1                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("-3.4028235E38") div xs:float("-3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideflt2args-1.txt')

!

test_op_numeric_divideflt2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideflt2args-2                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(mid range)                            :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("0") div xs:float("-3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideflt2args-2.txt')

!

test_op_numeric_divideflt2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideflt2args-3                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(upper bound)                          :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("3.4028235E38") div xs:float("-3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideflt2args-3.txt')

!

test_op_numeric_divideflt2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideflt2args-4                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(upper bound)                          :)
(:*******************************************************:)

xs:float("-3.4028235E38") div xs:float("3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideflt2args-4.txt')

!

test_op_numeric_divideint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideint2args-1                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

xs:int("-2147483648") div xs:int("-2147483648")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideint2args-1.txt')

!

test_op_numeric_divideint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideint2args-2                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(mid range)                              :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

 fn:round-half-to-even((xs:int("-1873914410") div xs:int("-2147483648")),10)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideint2args-2.txt')

!

test_op_numeric_divideint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideint2args-3                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(upper bound)                            :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

fn:round-half-to-even((xs:int("2147483647") div xs:int("-2147483648")),10)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideint2args-3.txt')

!

test_op_numeric_divideint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideint2args-4                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(mid range)                              :)
(:*******************************************************:)

fn:round-half-to-even((xs:int("-2147483648") div xs:int("-1873914410")),10)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideint2args-4.txt')

!

test_op_numeric_divideint2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideint2args-5                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(upper bound)                            :)
(:*******************************************************:)

fn:round-half-to-even((xs:int("-2147483648") div xs:int("2147483647")),10)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideint2args-5.txt')

!

test_op_numeric_divideintg2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideintg2args-1                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

xs:integer("-999999999999999999") div xs:integer("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideintg2args-1.txt')

!

test_op_numeric_divideintg2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideintg2args-2                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(mid range)                          :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

fn:round-half-to-even((xs:integer("830993497117024304") div xs:integer("-999999999999999999")),18)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideintg2args-2.txt')

!

test_op_numeric_divideintg2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideintg2args-3                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(upper bound)                        :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

xs:integer("999999999999999999") div xs:integer("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideintg2args-3.txt')

!

test_op_numeric_divideintg2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideintg2args-4                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(mid range)                          :)
(:*******************************************************:)

fn:round-half-to-even((xs:integer("-999999999999999999") div xs:integer("830993497117024304")),18)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideintg2args-4.txt')

!

test_op_numeric_divideintg2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideintg2args-5                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(upper bound)                        :)
(:*******************************************************:)

xs:integer("-999999999999999999") div xs:integer("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideintg2args-5.txt')

!

test_op_numeric_dividelng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividelng2args-1                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

xs:long("-92233720368547758") div xs:long("-92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividelng2args-1.txt')

!

test_op_numeric_dividelng2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividelng2args-2                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(mid range)                             :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

fn:round-half-to-even((xs:long("-47175562203048468") div xs:long("-92233720368547758")),17)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividelng2args-2.txt')

!

test_op_numeric_dividelng2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividelng2args-3                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(upper bound)                           :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

xs:long("92233720368547758") div xs:long("-92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividelng2args-3.txt')

!

test_op_numeric_dividelng2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividelng2args-4                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(mid range)                             :)
(:*******************************************************:)

fn:round-half-to-even((xs:long("-92233720368547758") div xs:long("-47175562203048468")),17)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividelng2args-4.txt')

!

test_op_numeric_dividelng2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividelng2args-5                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(upper bound)                           :)
(:*******************************************************:)

xs:long("-92233720368547758") div xs:long("92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividelng2args-5.txt')

!

test_op_numeric_dividemix2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-dividemix2args-1.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple division test with () as one operand should return null :)
(:*******************************************************:)

() div 1 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividemix2args-1.txt')

!

test_op_numeric_dividemix2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-dividemix2args-2.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple division test pass string for second operator :)
(:*******************************************************:)

1 div "1" 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_dividemix2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-dividemix2args-3.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple division test, second operator cast string to integer :)
(:*******************************************************:)

1 div xs:integer("1")



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividemix2args-3.txt')

!

test_op_numeric_dividemix2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-dividemix2args-4.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple division test, second operator is a node, atomization applied :)
(:*******************************************************:)

1 div <a> 2 </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividemix2args-4.txt')

!

test_op_numeric_dividemix2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-dividemix2args-5.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple division test, second operator is a node, atomization applied :)
(:*******************************************************:)

1 div <a> <b> 2 </b> </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividemix2args-5.txt')

!

test_op_numeric_dividemix2args_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-dividemix2args-6.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple division test, second operator node which is not atomizable :)
(:*******************************************************:)

1 div <a> <b> 2</b> <c> 2</c> </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_dividemix2args_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-dividemix2args-7.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple division test, two operands are nodes :)
(:*******************************************************:)

<a> 1 </a> div <b> 2 </b>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividemix2args-7.txt')

!

test_op_numeric_dividemix2args_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-dividemix2args-8.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple division test, second operator is a node, atomizable but not castable to integer :)
(:*******************************************************:)

1 div <a> x </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_dividemix2args_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-dividemix2args-9.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple division test pass an empty node for second operator:)
(:*******************************************************:)

1 div <a/>





      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_dividenint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenint2args-1                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(lower bound)                :)
(:$arg2 = xs:negativeInteger(lower bound)                :)
(:*******************************************************:)

xs:negativeInteger("-999999999999999999") div xs:negativeInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenint2args-1.txt')

!

test_op_numeric_dividenint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenint2args-2                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(mid range)                  :)
(:$arg2 = xs:negativeInteger(lower bound)                :)
(:*******************************************************:)

fn:round-half-to-even((xs:negativeInteger("-297014075999096793") div xs:negativeInteger("-999999999999999999")),18)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenint2args-2.txt')

!

test_op_numeric_dividenint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenint2args-3                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(upper bound)                :)
(:$arg2 = xs:negativeInteger(lower bound)                :)
(:*******************************************************:)

xs:negativeInteger("-1") div xs:negativeInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenint2args-3.txt')

!

test_op_numeric_dividenint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenint2args-4                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(lower bound)                :)
(:$arg2 = xs:negativeInteger(mid range)                  :)
(:*******************************************************:)

fn:round-half-to-even((xs:negativeInteger("-999999999999999999") div xs:negativeInteger("-297014075999096793")),18)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenint2args-4.txt')

!

test_op_numeric_dividenint2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenint2args-5                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(lower bound)                :)
(:$arg2 = xs:negativeInteger(upper bound)                :)
(:*******************************************************:)

xs:negativeInteger("-999999999999999999") div xs:negativeInteger("-1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenint2args-5.txt')

!

test_op_numeric_dividenni2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenni2args-1                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(mid range)               :)
(:*******************************************************:)

xs:nonNegativeInteger("0") div xs:nonNegativeInteger("303884545991464527")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenni2args-1.txt')

!

test_op_numeric_dividenni2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenni2args-2                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(upper bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("0") div xs:nonNegativeInteger("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenni2args-2.txt')

!

test_op_numeric_dividenpi2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenpi2args-1                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(lower bound)             :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("-999999999999999999") div xs:nonPositiveInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenpi2args-1.txt')

!

test_op_numeric_dividenpi2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenpi2args-2                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(mid range)               :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

fn:round-half-to-even((xs:nonPositiveInteger("-475688437271870490") div xs:nonPositiveInteger("-999999999999999999")),18)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenpi2args-2.txt')

!

test_op_numeric_dividenpi2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenpi2args-3                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(upper bound)             :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("0") div xs:nonPositiveInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenpi2args-3.txt')

!

test_op_numeric_dividenpi2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividenpi2args-4                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(lower bound)             :)
(:$arg2 = xs:nonPositiveInteger(mid range)               :)
(:*******************************************************:)

fn:round-half-to-even((xs:nonPositiveInteger("-999999999999999999") div xs:nonPositiveInteger("-475688437271870490")),18)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividenpi2args-4.txt')

!

test_op_numeric_dividepint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividepint2args-1                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("1") div xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividepint2args-1.txt')

!

test_op_numeric_dividepint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividepint2args-2                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(mid range)                  :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("52704602390610033") div xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividepint2args-2.txt')

!

test_op_numeric_dividepint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividepint2args-3                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(upper bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("999999999999999999") div xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividepint2args-3.txt')

!

test_op_numeric_dividepint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividepint2args-4                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(mid range)                  :)
(:*******************************************************:)

fn:round-half-to-even((xs:positiveInteger("1") div xs:positiveInteger("52704602390610033")),17)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividepint2args-4.txt')

!

test_op_numeric_dividepint2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividepint2args-5                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(upper bound)                :)
(:*******************************************************:)

xs:positiveInteger("1") div xs:positiveInteger("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividepint2args-5.txt')

!

test_op_numeric_dividesht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividesht2args-1                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

xs:short("-32768") div xs:short("-32768")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividesht2args-1.txt')

!

test_op_numeric_dividesht2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividesht2args-2                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(mid range)                            :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

fn:round-half-to-even((xs:short("-5324") div xs:short("-32768")),5)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividesht2args-2.txt')

!

test_op_numeric_dividesht2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividesht2args-3                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(upper bound)                          :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

xs:short("32767") div xs:short("-32768")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividesht2args-3.txt')

!

test_op_numeric_dividesht2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividesht2args-4                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(mid range)                            :)
(:*******************************************************:)

fn:round-half-to-even((xs:short("-32768") div xs:short("-5324")),5)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividesht2args-4.txt')

!

test_op_numeric_dividesht2args_5

    | query result |
    self assert: false message: 'should be fixed'.

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-dividesht2args-5                       :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(upper bound)                          :)
(:*******************************************************:)

xs:short("-32768") div xs:short("32767")
      
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
"/    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-dividesht2args-5.txt')

    "Modified: / 30-12-2009 / 14:15:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_op_numeric_divideulng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideulng2args-1                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(mid range)                     :)
(:*******************************************************:)

xs:unsignedLong("0") div xs:unsignedLong("130747108607674654")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideulng2args-1.txt')

!

test_op_numeric_divideulng2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideulng2args-2                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(upper bound)                   :)
(:*******************************************************:)

xs:unsignedLong("0") div xs:unsignedLong("184467440737095516")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideulng2args-2.txt')

!

test_op_numeric_divideusht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideusht2args-1                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(mid range)                    :)
(:*******************************************************:)

xs:unsignedShort("0") div xs:unsignedShort("44633")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideusht2args-1.txt')

!

test_op_numeric_divideusht2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-divideusht2args-2                      :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-divide" operator    :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(upper bound)                  :)
(:*******************************************************:)

xs:unsignedShort("0") div xs:unsignedShort("65535")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericDivide/op-numeric-divideusht2args-2.txt')

! !

!XQTSNumericDivideTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
