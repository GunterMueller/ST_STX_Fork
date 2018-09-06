"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSNumericAddTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSNumericAddTests methodsFor:'tests'!

test_K2_NumericAdd_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-NumericAdd-1                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Arithmethics involving operands of integer type but where both have wrong cardinality. :)
(:*******************************************************:)
(1, 2) + (1, 2)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-1                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double(6) + xs:double(2) eq 8`. :)
(:*******************************************************:)
xs:double(6) + xs:double(2) eq 8
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-1.txt')

!

test_K_NumericAdd_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-10                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(xs:double("NaN") + 3) eq "NaN"`. :)
(:*******************************************************:)
string(xs:double("NaN") + 3) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-10.txt')

!

test_K_NumericAdd_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-11                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(3 + xs:float("NaN")) eq "NaN"`. :)
(:*******************************************************:)
string(3 + xs:float("NaN")) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-11.txt')

!

test_K_NumericAdd_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-12                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(3 + xs:double("NaN")) eq "NaN"`. :)
(:*******************************************************:)
string(3 + xs:double("NaN")) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-12.txt')

!

test_K_NumericAdd_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-13                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) + xs:integer(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:decimal(6) + xs:integer(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-13.txt')

!

test_K_NumericAdd_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-14                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) + xs:decimal(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:integer(6) + xs:decimal(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-14.txt')

!

test_K_NumericAdd_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-15                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) + xs:integer(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:integer(6) + xs:integer(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-15.txt')

!

test_K_NumericAdd_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-16                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) + xs:decimal(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:decimal(6) + xs:decimal(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-16.txt')

!

test_K_NumericAdd_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-17                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) + xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:decimal(6) + xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-17.txt')

!

test_K_NumericAdd_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-18                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) + xs:decimal(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) + xs:decimal(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-18.txt')

!

test_K_NumericAdd_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-19                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) + xs:integer(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) + xs:integer(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-19.txt')

!

test_K_NumericAdd_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-2                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:decimal(6) + xs:decimal(2) eq 8`. :)
(:*******************************************************:)
xs:decimal(6) + xs:decimal(2) eq 8
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-2.txt')

!

test_K_NumericAdd_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-20                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) + xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:integer(6) + xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-20.txt')

!

test_K_NumericAdd_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-21                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) + xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) + xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-21.txt')

!

test_K_NumericAdd_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-22                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) + xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:decimal(6) + xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-22.txt')

!

test_K_NumericAdd_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-23                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) + xs:decimal(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) + xs:decimal(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-23.txt')

!

test_K_NumericAdd_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-24                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) + xs:float(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) + xs:float(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-24.txt')

!

test_K_NumericAdd_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-25                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) + xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:float(6) + xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-25.txt')

!

test_K_NumericAdd_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-26                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) + xs:integer(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) + xs:integer(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-26.txt')

!

test_K_NumericAdd_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-27                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) + xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:integer(6) + xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-27.txt')

!

test_K_NumericAdd_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-28                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) + xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) + xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-28.txt')

!

test_K_NumericAdd_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-29                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Test parser handles "+" operator with critical whitespace. :)
(:*******************************************************:)
1+1 eq 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-29.txt')

!

test_K_NumericAdd_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-3                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:decimal(6.1) + xs:decimal(2.1) eq 8.2`. :)
(:*******************************************************:)
xs:decimal(6.1) + xs:decimal(2.1) eq 8.2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-3.txt')

!

test_K_NumericAdd_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-30                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Test parser handles "+" operator with critical whitespace(#2). :)
(:*******************************************************:)
2 eq 1+1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-30.txt')

!

test_K_NumericAdd_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-31                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke operator "+" where one of the operands is of type none. :)
(:*******************************************************:)
3 + error()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-32                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke operator "+" where one of the operands is of type none. :)
(:*******************************************************:)
error() + 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-33                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke operator "+" where one of the operands is of type none. :)
(:*******************************************************:)
3 + (error(), 4)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_34

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-34                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke operator "+" where one of the operands is of type none. :)
(:*******************************************************:)
(4, error()) + 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_35

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-35                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke operator "+" where one of the operands is of type none. :)
(:*******************************************************:)
3 + (4, error())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_36

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-36                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke operator "+" where one of the operands is of type none. :)
(:*******************************************************:)
(error(), 4) + 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_37

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-37                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Arithmethics involving operands of integer type but with wrong cardinality. :)
(:*******************************************************:)
(1, 2) + 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_38

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-38                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Arithmethics involving operands of integer type but with wrong cardinality. :)
(:*******************************************************:)
empty((1, 2) + ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-38.txt')

!

test_K_NumericAdd_39

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-39                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Arithmethics involving operands of integer type but with wrong cardinality. :)
(:*******************************************************:)
1 + (1, 2)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-4                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `1.1 + 2.2 eq 3.3`. :)
(:*******************************************************:)
1.1 + 2.2 eq 3.3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-4.txt')

!

test_K_NumericAdd_40

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-40                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Arithmethics involving operands of integer type but with wrong cardinality. :)
(:*******************************************************:)
empty(() + (1, 2))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-40.txt')

!

test_K_NumericAdd_41

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-41                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Number addition with error() as the left operand. :)
(:*******************************************************:)
error() + 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_42

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-42                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Number addition with error() as the right operand. :)
(:*******************************************************:)
3 + error()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_43

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-43                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "+" operator with invalid operands. :)
(:*******************************************************:)
"3" + "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_44

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-44                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "+" operator with invalid operands. :)
(:*******************************************************:)
"3" + xs:untypedAtomic("3")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_45

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-45                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(3 + xs:untypedAtomic("3")) eq 6`. :)
(:*******************************************************:)
(3 + xs:untypedAtomic("3")) eq 6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-45.txt')

!

test_K_NumericAdd_46

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-46                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:untypedAtomic("3") + 3.0) eq 6`. :)
(:*******************************************************:)
(xs:untypedAtomic("3") + 3.0) eq 6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-46.txt')

!

test_K_NumericAdd_47

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-47                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Complex combination of numeric arithmetics in order to stress operator precedence. :)
(:*******************************************************:)
(2 + 4) * 5 eq 30
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-47.txt')

!

test_K_NumericAdd_48

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-48                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Complex combination of numeric arithmetics in order to stress operator precedence. :)
(:*******************************************************:)
2 + 4 * 5 eq 22
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-48.txt')

!

test_K_NumericAdd_49

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-49                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Complex combination of numeric arithmetics in order to stress operator precedence. :)
(:*******************************************************:)
1 + 2 * 4 + (1 + 2 + 3 * 4) eq 24
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-49.txt')

!

test_K_NumericAdd_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-5                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double(1.1) + xs:double(2.2) ne 3.3`. :)
(:*******************************************************:)
xs:double(1.1) + xs:double(2.2) ne 3.3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-5.txt')

!

test_K_NumericAdd_50

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-50                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() + ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-50.txt')

!

test_K_NumericAdd_51

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-51                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Implementations supporting the static typing feature may raise XPTy0004. :)
(:*******************************************************:)
(remove((1, "two"), 2) + 1) eq 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-51.txt')

!

test_K_NumericAdd_52

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-52                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Implementations supporting the static typing feature may raise XPTy0004. :)
(:*******************************************************:)
2 eq (1 + remove((1, "two"), 2))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-52.txt')

!

test_K_NumericAdd_53

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-53                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Implementations supporting the static typing feature may raise XPTy0004. :)
(:*******************************************************:)
(remove((1, "two"), 2) + xs:untypedAtomic("1")) eq 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-53.txt')

!

test_K_NumericAdd_54

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-54                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Implementations supporting the static typing feature may raise XPTy0004. :)
(:*******************************************************:)
2 eq (xs:untypedAtomic("1") + remove((1, "two"), 2))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-54.txt')

!

test_K_NumericAdd_55

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-55                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Implementations supporting the static typing feature may raise XPTy0004. :)
(:*******************************************************:)
(remove((xs:untypedAtomic("1"), "two"), 2) + 1) eq 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-55.txt')

!

test_K_NumericAdd_56

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-56                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Implementations supporting the static typing feature may raise XPTy0004. :)
(:*******************************************************:)
2 eq (1 + remove((xs:untypedAtomic("1"), "two"), 2))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-56.txt')

!

test_K_NumericAdd_57

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-57                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Implementations supporting the static typing feature may raise XPTy0004. :)
(:*******************************************************:)
(remove((1, "two"), 2) + xs:untypedAtomic("1")) eq 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-57.txt')

!

test_K_NumericAdd_58

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-58                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Implementations supporting the static typing feature may raise XPTy0004. :)
(:*******************************************************:)
2 eq (xs:untypedAtomic("1") + remove((1, "two"), 2))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-58.txt')

!

test_K_NumericAdd_59

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-59                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:untypedAtomic("3") + 3 eq 6`. :)
(:*******************************************************:)
xs:untypedAtomic("3") + 3 eq 6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-59.txt')

!

test_K_NumericAdd_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-6                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(1.1) + xs:float(2.2) ne 3.3`. :)
(:*******************************************************:)
xs:float(1.1) + xs:float(2.2) ne 3.3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-6.txt')

!

test_K_NumericAdd_60

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-60                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:untypedAtomic("3") + 3) instance of xs:double`. :)
(:*******************************************************:)
(xs:untypedAtomic("3") + 3) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-60.txt')

!

test_K_NumericAdd_61

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-61                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(remove((5, 1e0), 2) + 1) eq 6`. :)
(:*******************************************************:)
(remove((5, 1e0), 2) + 1) eq 6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-61.txt')

!

test_K_NumericAdd_62

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-62                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(1 + remove((5, 1e0), 2)) eq 6`. :)
(:*******************************************************:)
(1 + remove((5, 1e0), 2)) eq 6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-62.txt')

!

test_K_NumericAdd_63

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-63                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke operator "+" where one of the operands, using subsequence(), evaluates to an invalid cardinality. :)
(:*******************************************************:)
1 + subsequence("a string", 1, 1)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_64

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-64                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke operator "+" where one of the operands, using subsequence(), evaluates to an invalid cardinality. :)
(:*******************************************************:)
subsequence("a string", 1, 1) + 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_65

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-65                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke operator "+" where one of the operands is a string. :)
(:*******************************************************:)
"foo" + 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_66

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-66                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke operator "+" where one of the operands is a string. :)
(:*******************************************************:)
1 + "foo"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericAdd_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-7                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:integer(6) + xs:integer(2) eq 8`. :)
(:*******************************************************:)
xs:integer(6) + xs:integer(2) eq 8
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-7.txt')

!

test_K_NumericAdd_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-8                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(6) + xs:float(2) eq 8`. :)
(:*******************************************************:)
xs:float(6) + xs:float(2) eq 8
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-8.txt')

!

test_K_NumericAdd_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericAdd-9                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(xs:float("NaN") + 3) eq "NaN"`. :)
(:*******************************************************:)
string(xs:float("NaN") + 3) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/K-NumericAdd-9.txt')

!

test_op_numeric_add_derived_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-add-derived-1                         :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the operators set as follows                     :)
(:$arg1 = xs:long                                        :)
(:$arg2 = xs:unsignedLong                                :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:long(10) + xs:unsignedLong(35)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-add-derived-1.txt')

!

test_op_numeric_add_derived_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-add-derived-2                         :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the operators set as follows                     :)
(:$arg1 = xs:positiveInteger                             :)
(:$arg2 = xs:nonPositiveInteger                          :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:positiveInteger(10) + xs:nonPositiveInteger(-15)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-add-derived-2.txt')

!

test_op_numeric_add_derived_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-add-derived-3                         :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the operators set as follows                     :)
(:$arg1 = xs:nonNegativeInteger                          :)
(:$arg2 = xs:short                                       :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:nonNegativeInteger(10) + xs:short(15)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-add-derived-3.txt')

!

test_op_numeric_add_derived_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-add-derived-4                         :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the operators set as follows                     :)
(:$arg1 = xs:short                                       :)
(:$arg2 = xs:long                                       :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:short(10) + xs:long(145)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-add-derived-4.txt')

!

test_op_numeric_add_derived_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-add-derived-5                         :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the operators set as follows                     :)
(:$arg1 = xs:positiveInteger                             :)
(:$arg2 = xs:negativeInteger                             :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:positiveInteger(10) + xs:negativeInteger(-5)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-add-derived-5.txt')

!

test_op_numeric_adddbl2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-adddbl2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(mid range)                           :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("0") + xs:double("-1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-adddbl2args-1.txt')

!

test_op_numeric_adddbl2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-adddbl2args-2                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(upper bound)                         :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("1.7976931348623157E308") + xs:double("-1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-adddbl2args-2.txt')

!

test_op_numeric_adddbl2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-adddbl2args-3                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(mid range)                           :)
(:*******************************************************:)

xs:double("-1.7976931348623157E308") + xs:double("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-adddbl2args-3.txt')

!

test_op_numeric_adddbl2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-adddbl2args-4                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(upper bound)                         :)
(:*******************************************************:)

xs:double("-1.7976931348623157E308") + xs:double("1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-adddbl2args-4.txt')

!

test_op_numeric_adddec2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-adddec2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(mid range)                          :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("617375191608514839") + xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-adddec2args-1.txt')

!

test_op_numeric_adddec2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-adddec2args-2                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(upper bound)                        :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("999999999999999999") + xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-adddec2args-2.txt')

!

test_op_numeric_adddec2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-adddec2args-3                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(mid range)                          :)
(:*******************************************************:)

xs:decimal("-999999999999999999") + xs:decimal("617375191608514839")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-adddec2args-3.txt')

!

test_op_numeric_adddec2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-adddec2args-4                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(upper bound)                        :)
(:*******************************************************:)

xs:decimal("-999999999999999999") + xs:decimal("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-adddec2args-4.txt')

!

test_op_numeric_addflt2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addflt2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(mid range)                            :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("0") + xs:float("-3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addflt2args-1.txt')

!

test_op_numeric_addflt2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addflt2args-2                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(upper bound)                          :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("3.4028235E38") + xs:float("-3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addflt2args-2.txt')

!

test_op_numeric_addflt2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addflt2args-3                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(mid range)                            :)
(:*******************************************************:)

xs:float("-3.4028235E38") + xs:float("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addflt2args-3.txt')

!

test_op_numeric_addflt2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addflt2args-4                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(upper bound)                          :)
(:*******************************************************:)

xs:float("-3.4028235E38") + xs:float("3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addflt2args-4.txt')

!

test_op_numeric_addint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addint2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(mid range)                              :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

xs:int("-1873914410") + xs:int("-273569238")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addint2args-1.txt')

!

test_op_numeric_addint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addint2args-2                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(upper bound)                            :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

xs:int("2147483647") + xs:int("-2147483648")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addint2args-2.txt')

!

test_op_numeric_addint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addint2args-3                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(mid range)                              :)
(:*******************************************************:)

xs:int("-273569238") + xs:int("-1873914410")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addint2args-3.txt')

!

test_op_numeric_addint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addint2args-4                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(upper bound)                            :)
(:*******************************************************:)

xs:int("-2147483648") + xs:int("2147483647")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addint2args-4.txt')

!

test_op_numeric_addintg2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addintg2args-1                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(mid range)                          :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

xs:integer("830993497117024304") + xs:integer("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addintg2args-1.txt')

!

test_op_numeric_addintg2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addintg2args-2                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(upper bound)                        :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

xs:integer("999999999999999999") + xs:integer("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addintg2args-2.txt')

!

test_op_numeric_addintg2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addintg2args-3                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(mid range)                          :)
(:*******************************************************:)

xs:integer("-999999999999999999") + xs:integer("830993497117024304")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addintg2args-3.txt')

!

test_op_numeric_addintg2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addintg2args-4                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(upper bound)                        :)
(:*******************************************************:)

xs:integer("-999999999999999999") + xs:integer("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addintg2args-4.txt')

!

test_op_numeric_addlng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addlng2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(mid range)                             :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

xs:long("-47175562203048468") + xs:long("-45058158165499290")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addlng2args-1.txt')

!

test_op_numeric_addlng2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addlng2args-2                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(upper bound)                           :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

xs:long("92233720368547758") + xs:long("-92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addlng2args-2.txt')

!

test_op_numeric_addlng2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addlng2args-3                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(mid range)                             :)
(:*******************************************************:)

xs:long("-45058158165499290") + xs:long("-47175562203048468")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addlng2args-3.txt')

!

test_op_numeric_addlng2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addlng2args-4                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(upper bound)                           :)
(:*******************************************************:)

xs:long("-92233720368547758") + xs:long("92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addlng2args-4.txt')

!

test_op_numeric_addmix2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-addmix2args-1.xq                     :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 14:43:40 2005                        :)
(: Purpose: Simple addition test with () as one operand should return null :)
(:*******************************************************:)

1 + ()



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addmix2args-1.txt')

!

test_op_numeric_addmix2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-addmix2args-2.xq                     :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 14:43:40 2005                        :)
(: Purpose: Simple addition test pass string for second operator :)
(:*******************************************************:)

1 + "1" 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_addmix2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-addmix2args-3.xq                     :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 14:43:40 2005                        :)
(: Purpose: Simple addition test, second operator cast string to integer :)
(:*******************************************************:)

1 + xs:integer("1")



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addmix2args-3.txt')

!

test_op_numeric_addmix2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-addmix2args-4.xq                     :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 14:43:40 2005                        :)
(: Purpose: Simple addition test, second operator is a node, atomization applied :)
(:*******************************************************:)

1 + <a> 2 </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addmix2args-4.txt')

!

test_op_numeric_addmix2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-addmix2args-5.xq                     :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 14:43:41 2005                        :)
(: Purpose: Simple addition test, second operator is a node, atomization applied :)
(:*******************************************************:)

1+<a> <b> 2 </b> </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addmix2args-5.txt')

!

test_op_numeric_addmix2args_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-addmix2args-6.xq                     :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 14:43:41 2005                        :)
(: Purpose: Simple addition test, second operator node which is not atomizable :)
(:*******************************************************:)

1 + <a> <b> 2</b> <c> 2</c> </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_addmix2args_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-addmix2args-7.xq                     :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 14:43:41 2005                        :)
(: Purpose: Simple addition test, two operands are nodes :)
(:*******************************************************:)

<a> 1 </a> + <b> 2 </b>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addmix2args-7.txt')

!

test_op_numeric_addmix2args_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-addmix2args-8.xq                     :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 14:43:41 2005                        :)
(: Purpose: Simple addition test, second operator is a node, atomizable but not castable to integer :)
(:*******************************************************:)

1 + <a> x </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_addmix2args_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-addmix2args-9.xq                     :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 14:43:41 2005                        :)
(: Purpose: Simple addition test pass an empty node for second operator:)
(:*******************************************************:)

1 + <a/>





      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_addnint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnint2args-1                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(mid range)                  :)
(:$arg2 = xs:negativeInteger(lower bound)                :)
(:*******************************************************:)

xs:negativeInteger("-297014075999096793") + xs:negativeInteger("-702985924000903206")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnint2args-1.txt')

!

test_op_numeric_addnint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnint2args-2                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(upper bound)                :)
(:$arg2 = xs:negativeInteger(lower bound)                :)
(:*******************************************************:)

xs:negativeInteger("-1") + xs:negativeInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnint2args-2.txt')

!

test_op_numeric_addnint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnint2args-3                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(lower bound)                :)
(:$arg2 = xs:negativeInteger(mid range)                  :)
(:*******************************************************:)

xs:negativeInteger("-702985924000903206") + xs:negativeInteger("-297014075999096793")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnint2args-3.txt')

!

test_op_numeric_addnint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnint2args-4                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(lower bound)                :)
(:$arg2 = xs:negativeInteger(upper bound)                :)
(:*******************************************************:)

xs:negativeInteger("-999999999999999999") + xs:negativeInteger("-1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnint2args-4.txt')

!

test_op_numeric_addnni2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnni2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(lower bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("0") + xs:nonNegativeInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnni2args-1.txt')

!

test_op_numeric_addnni2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnni2args-2                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(mid range)               :)
(:$arg2 = xs:nonNegativeInteger(lower bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("303884545991464527") + xs:nonNegativeInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnni2args-2.txt')

!

test_op_numeric_addnni2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnni2args-3                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(upper bound)             :)
(:$arg2 = xs:nonNegativeInteger(lower bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("999999999999999999") + xs:nonNegativeInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnni2args-3.txt')

!

test_op_numeric_addnni2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnni2args-4                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(mid range)               :)
(:*******************************************************:)

xs:nonNegativeInteger("0") + xs:nonNegativeInteger("303884545991464527")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnni2args-4.txt')

!

test_op_numeric_addnni2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnni2args-5                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(upper bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("0") + xs:nonNegativeInteger("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnni2args-5.txt')

!

test_op_numeric_addnpi2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnpi2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(mid range)               :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("-475688437271870490") + xs:nonPositiveInteger("-524311562728129509")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnpi2args-1.txt')

!

test_op_numeric_addnpi2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnpi2args-2                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(upper bound)             :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("0") + xs:nonPositiveInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnpi2args-2.txt')

!

test_op_numeric_addnpi2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnpi2args-3                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(lower bound)             :)
(:$arg2 = xs:nonPositiveInteger(mid range)               :)
(:*******************************************************:)

xs:nonPositiveInteger("-524311562728129509") + xs:nonPositiveInteger("-475688437271870490")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnpi2args-3.txt')

!

test_op_numeric_addnpi2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addnpi2args-4                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(lower bound)             :)
(:$arg2 = xs:nonPositiveInteger(upper bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("-999999999999999999") + xs:nonPositiveInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addnpi2args-4.txt')

!

test_op_numeric_addpint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addpint2args-1                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("1") + xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addpint2args-1.txt')

!

test_op_numeric_addpint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addpint2args-2                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(mid range)                  :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("52704602390610033") + xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addpint2args-2.txt')

!

test_op_numeric_addpint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addpint2args-3                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(upper bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("999999999999999998") + xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addpint2args-3.txt')

!

test_op_numeric_addpint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addpint2args-4                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(mid range)                  :)
(:*******************************************************:)

xs:positiveInteger("1") + xs:positiveInteger("52704602390610033")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addpint2args-4.txt')

!

test_op_numeric_addpint2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addpint2args-5                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(upper bound)                :)
(:*******************************************************:)

xs:positiveInteger("1") + xs:positiveInteger("999999999999999998")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addpint2args-5.txt')

!

test_op_numeric_addsht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addsht2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(mid range)                            :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

xs:short("-5324") + xs:short("-27444")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addsht2args-1.txt')

!

test_op_numeric_addsht2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addsht2args-2                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(upper bound)                          :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

xs:short("32767") + xs:short("-32768")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addsht2args-2.txt')

!

test_op_numeric_addsht2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addsht2args-3                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(mid range)                            :)
(:*******************************************************:)

xs:short("-27444") + xs:short("-5324")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addsht2args-3.txt')

!

test_op_numeric_addsht2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addsht2args-4                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(upper bound)                          :)
(:*******************************************************:)

xs:short("-32768") + xs:short("32767")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addsht2args-4.txt')

!

test_op_numeric_addulng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addulng2args-1                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(lower bound)                   :)
(:*******************************************************:)

xs:unsignedLong("0") + xs:unsignedLong("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addulng2args-1.txt')

!

test_op_numeric_addulng2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addulng2args-2                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(mid range)                     :)
(:$arg2 = xs:unsignedLong(lower bound)                   :)
(:*******************************************************:)

xs:unsignedLong("130747108607674654") + xs:unsignedLong("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addulng2args-2.txt')

!

test_op_numeric_addulng2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addulng2args-3                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(upper bound)                   :)
(:$arg2 = xs:unsignedLong(lower bound)                   :)
(:*******************************************************:)

xs:unsignedLong("184467440737095516") + xs:unsignedLong("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addulng2args-3.txt')

!

test_op_numeric_addulng2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addulng2args-4                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(mid range)                     :)
(:*******************************************************:)

xs:unsignedLong("0") + xs:unsignedLong("130747108607674654")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addulng2args-4.txt')

!

test_op_numeric_addulng2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addulng2args-5                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(upper bound)                   :)
(:*******************************************************:)

xs:unsignedLong("0") + xs:unsignedLong("184467440737095516")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addulng2args-5.txt')

!

test_op_numeric_addusht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addusht2args-1                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(lower bound)                  :)
(:*******************************************************:)

xs:unsignedShort("0") + xs:unsignedShort("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addusht2args-1.txt')

!

test_op_numeric_addusht2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addusht2args-2                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(mid range)                    :)
(:$arg2 = xs:unsignedShort(lower bound)                  :)
(:*******************************************************:)

xs:unsignedShort("44633") + xs:unsignedShort("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addusht2args-2.txt')

!

test_op_numeric_addusht2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addusht2args-3                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(upper bound)                  :)
(:$arg2 = xs:unsignedShort(lower bound)                  :)
(:*******************************************************:)

xs:unsignedShort("65535") + xs:unsignedShort("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addusht2args-3.txt')

!

test_op_numeric_addusht2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addusht2args-4                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(mid range)                    :)
(:*******************************************************:)

xs:unsignedShort("0") + xs:unsignedShort("44633")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addusht2args-4.txt')

!

test_op_numeric_addusht2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-addusht2args-5                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-add" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(upper bound)                  :)
(:*******************************************************:)

xs:unsignedShort("0") + xs:unsignedShort("65535")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericAdd/op-numeric-addusht2args-5.txt')

! !

!XQTSNumericAddTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
