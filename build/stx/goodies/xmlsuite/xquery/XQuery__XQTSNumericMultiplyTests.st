"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSNumericMultiplyTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSNumericMultiplyTests methodsFor:'tests'!

test_K_NumericMultiply_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-1                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double(6) * xs:double(2) eq 12`. :)
(:*******************************************************:)
xs:double(6) * xs:double(2) eq 12
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-1.txt')

!

test_K_NumericMultiply_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-10                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) * xs:decimal(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) * xs:decimal(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-10.txt')

!

test_K_NumericMultiply_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-11                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) * xs:integer(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) * xs:integer(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-11.txt')

!

test_K_NumericMultiply_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-12                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) * xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:integer(6) * xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-12.txt')

!

test_K_NumericMultiply_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-13                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) * xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) * xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-13.txt')

!

test_K_NumericMultiply_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-14                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) * xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:decimal(6) * xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-14.txt')

!

test_K_NumericMultiply_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-15                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) * xs:decimal(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) * xs:decimal(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-15.txt')

!

test_K_NumericMultiply_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-16                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) * xs:float(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) * xs:float(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-16.txt')

!

test_K_NumericMultiply_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-17                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) * xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:float(6) * xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-17.txt')

!

test_K_NumericMultiply_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-18                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) * xs:integer(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) * xs:integer(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-18.txt')

!

test_K_NumericMultiply_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-19                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) * xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:integer(6) * xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-19.txt')

!

test_K_NumericMultiply_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-2                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:decimal(6) * xs:decimal(2) eq 12`. :)
(:*******************************************************:)
xs:decimal(6) * xs:decimal(2) eq 12
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-2.txt')

!

test_K_NumericMultiply_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-20                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) * xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) * xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-20.txt')

!

test_K_NumericMultiply_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-21                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(xs:float("NaN") * 3) eq "NaN"`. :)
(:*******************************************************:)
string(xs:float("NaN") * 3) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-21.txt')

!

test_K_NumericMultiply_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-22                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(xs:double("NaN") * 3) eq "NaN"`. :)
(:*******************************************************:)
string(xs:double("NaN") * 3) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-22.txt')

!

test_K_NumericMultiply_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-23                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(3 * xs:float("NaN")) eq "NaN"`. :)
(:*******************************************************:)
string(3 * xs:float("NaN")) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-23.txt')

!

test_K_NumericMultiply_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-24                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(3 * xs:double("NaN")) eq "NaN"`. :)
(:*******************************************************:)
string(3 * xs:double("NaN")) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-24.txt')

!

test_K_NumericMultiply_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-25                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace involving multiplication operator and "/". :)
(:*******************************************************:)
/*5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericMultiply_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-26                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace involving multiplication operator and "/". :)
(:*******************************************************:)
/ * 5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericMultiply_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-27                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace involving multiplication operator and "/". :)
(:*******************************************************:)
4 + / * 5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericMultiply_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-28                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "*" operator with invalid operands. :)
(:*******************************************************:)
"3" * "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericMultiply_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-29                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "*" operator with invalid operands. :)
(:*******************************************************:)
1 * "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericMultiply_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-3                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:integer(6) * xs:integer(2) eq 12`. :)
(:*******************************************************:)
xs:integer(6) * xs:integer(2) eq 12
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-3.txt')

!

test_K_NumericMultiply_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-30                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(3 * xs:untypedAtomic(3)) eq 9`. :)
(:*******************************************************:)
(3 * xs:untypedAtomic(3)) eq 9
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-30.txt')

!

test_K_NumericMultiply_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-31                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:untypedAtomic(3) * 3) eq 9`. :)
(:*******************************************************:)
(xs:untypedAtomic(3) * 3) eq 9
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-31.txt')

!

test_K_NumericMultiply_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-32                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() * ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-32.txt')

!

test_K_NumericMultiply_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-33                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() * 1)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-33.txt')

!

test_K_NumericMultiply_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-4                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(6) * xs:float(2) eq 12`. :)
(:*******************************************************:)
xs:float(6) * xs:float(2) eq 12
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-4.txt')

!

test_K_NumericMultiply_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-5                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) * xs:integer(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:decimal(6) * xs:integer(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-5.txt')

!

test_K_NumericMultiply_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-6                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) * xs:decimal(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:integer(6) * xs:decimal(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-6.txt')

!

test_K_NumericMultiply_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-7                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) * xs:integer(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:integer(6) * xs:integer(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-7.txt')

!

test_K_NumericMultiply_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-8                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) * xs:decimal(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:decimal(6) * xs:decimal(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-8.txt')

!

test_K_NumericMultiply_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMultiply-9                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) * xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:decimal(6) * xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/K-NumericMultiply-9.txt')

!

test_op_numeric_multiplydbl2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplydbl2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("-1.0000000000") * xs:double("-1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplydbl2args-1.txt')

!

test_op_numeric_multiplydbl2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplydbl2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(mid range)                           :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("0") * xs:double("-1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplydbl2args-2.txt')

!

test_op_numeric_multiplydbl2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplydbl2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(upper bound)                         :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("1.7976931348623157E308") * xs:double("-1.0000000000")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplydbl2args-3.txt')

!

test_op_numeric_multiplydbl2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplydbl2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(mid range)                           :)
(:*******************************************************:)

xs:double("-1.7976931348623157E308") * xs:double("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplydbl2args-4.txt')

!

test_op_numeric_multiplydbl2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplydbl2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(upper bound)                         :)
(:*******************************************************:)

xs:double("-1.0000000000") * xs:double("1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplydbl2args-5.txt')

!

test_op_numeric_multiplydec2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplydec2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("-1.0000000000") * xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplydec2args-1.txt')

!

test_op_numeric_multiplydec2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplydec2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Tue Apr 12 16:28:58 GMT-05:00 2005                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(mid range)                          :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("617375191608514839") * xs:decimal("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplydec2args-2.txt')

!

test_op_numeric_multiplydec2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplydec2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(upper bound)                        :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("999999999999999999") * xs:decimal("-1.0000000000")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplydec2args-3.txt')

!

test_op_numeric_multiplydec2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplydec2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Tue Apr 12 16:28:58 GMT-05:00 2005                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(mid range)                          :)
(:*******************************************************:)

xs:decimal("0") * xs:decimal("617375191608514839")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplydec2args-4.txt')

!

test_op_numeric_multiplydec2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplydec2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(upper bound)                        :)
(:*******************************************************:)

xs:decimal("-1.0000000000") * xs:decimal("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplydec2args-5.txt')

!

test_op_numeric_multiplyflt2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyflt2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("-1.0000000000") * xs:float("-3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyflt2args-1.txt')

!

test_op_numeric_multiplyflt2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyflt2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(mid range)                            :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("0") * xs:float("-3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyflt2args-2.txt')

!

test_op_numeric_multiplyflt2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyflt2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(upper bound)                          :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("3.4028235E38") * xs:float("-1.0000000000")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyflt2args-3.txt')

!

test_op_numeric_multiplyflt2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyflt2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(mid range)                            :)
(:*******************************************************:)

xs:float("-3.4028235E38") * xs:float("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyflt2args-4.txt')

!

test_op_numeric_multiplyflt2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyflt2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(upper bound)                          :)
(:*******************************************************:)

xs:float("-1.0000000000") * xs:float("3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyflt2args-5.txt')

!

test_op_numeric_multiplymix2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-multiplymix2args-1.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:12:19 2005                        :)
(: Purpose: Simple multiplication test with () as one operand should return null :)
(:*******************************************************:)

1 * ()



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplymix2args-1.txt')

!

test_op_numeric_multiplymix2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-multiplymix2args-2.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:12:19 2005                        :)
(: Purpose: Simple multiplication test pass string for second operator :)
(:*******************************************************:)

1 * "1" 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_multiplymix2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-multiplymix2args-3.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:12:19 2005                        :)
(: Purpose: Simple multiplication test, second operator cast string to integer :)
(:*******************************************************:)

1 * xs:integer("1")



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplymix2args-3.txt')

!

test_op_numeric_multiplymix2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-multiplymix2args-4.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:12:19 2005                        :)
(: Purpose: Simple multiplication test, second operator is a node, atomization applied :)
(:*******************************************************:)

1 * <a> 2 </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplymix2args-4.txt')

!

test_op_numeric_multiplymix2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-multiplymix2args-5.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:12:19 2005                        :)
(: Purpose: Simple multiplication test, second operator is a node, atomization applied :)
(:*******************************************************:)

1 * <a> <b> 2 </b> </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplymix2args-5.txt')

!

test_op_numeric_multiplymix2args_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-multiplymix2args-6.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:12:19 2005                        :)
(: Purpose: Simple multiplication test, second operator node which is not atomizable :)
(:*******************************************************:)

1 * <a> <b> 2</b> <c> 2</c> </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_multiplymix2args_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-multiplymix2args-7.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:12:19 2005                        :)
(: Purpose: Simple multiplication test, two operands are nodes :)
(:*******************************************************:)

<a> 1 </a> * <b> 2 </b>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplymix2args-7.txt')

!

test_op_numeric_multiplymix2args_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-multiplymix2args-8.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:12:19 2005                        :)
(: Purpose: Simple multiplication test, second operator is a node, atomizable but not castable to integer :)
(:*******************************************************:)

1 * <a> x </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_multiplymix2args_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-multiplymix2args-9.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:12:19 2005                        :)
(: Purpose: Simple multiplication test, pass an empty node for second operator:)
(:*******************************************************:)

1 * <a/>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_multiplynni2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplynni2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(lower bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("0") * xs:nonNegativeInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplynni2args-1.txt')

!

test_op_numeric_multiplynni2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplynni2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(mid range)               :)
(:$arg2 = xs:nonNegativeInteger(lower bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("303884545991464527") * xs:nonNegativeInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplynni2args-2.txt')

!

test_op_numeric_multiplynni2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplynni2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(upper bound)             :)
(:$arg2 = xs:nonNegativeInteger(lower bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("999999999999999999") * xs:nonNegativeInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplynni2args-3.txt')

!

test_op_numeric_multiplynni2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplynni2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(mid range)               :)
(:*******************************************************:)

xs:nonNegativeInteger("0") * xs:nonNegativeInteger("303884545991464527")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplynni2args-4.txt')

!

test_op_numeric_multiplynni2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplynni2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(upper bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("0") * xs:nonNegativeInteger("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplynni2args-5.txt')

!

test_op_numeric_multiplynpi2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplynpi2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(upper bound)             :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("0") * xs:nonPositiveInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplynpi2args-1.txt')

!

test_op_numeric_multiplynpi2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplynpi2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(lower bound)             :)
(:$arg2 = xs:nonPositiveInteger(upper bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("-999999999999999999") * xs:nonPositiveInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplynpi2args-2.txt')

!

test_op_numeric_multiplypint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplypint2args-1                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("1") * xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplypint2args-1.txt')

!

test_op_numeric_multiplypint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplypint2args-2                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(mid range)                  :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("52704602390610033") * xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplypint2args-2.txt')

!

test_op_numeric_multiplypint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplypint2args-3                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(upper bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("999999999999999999") * xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplypint2args-3.txt')

!

test_op_numeric_multiplypint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplypint2args-4                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(mid range)                  :)
(:*******************************************************:)

xs:positiveInteger("1") * xs:positiveInteger("52704602390610033")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplypint2args-4.txt')

!

test_op_numeric_multiplypint2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplypint2args-5                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(upper bound)                :)
(:*******************************************************:)

xs:positiveInteger("1") * xs:positiveInteger("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplypint2args-5.txt')

!

test_op_numeric_multiplyulng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyulng2args-1                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(lower bound)                   :)
(:*******************************************************:)

xs:unsignedLong("0") * xs:unsignedLong("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyulng2args-1.txt')

!

test_op_numeric_multiplyulng2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyulng2args-2                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(mid range)                     :)
(:$arg2 = xs:unsignedLong(lower bound)                   :)
(:*******************************************************:)

xs:unsignedLong("130747108607674654") * xs:unsignedLong("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyulng2args-2.txt')

!

test_op_numeric_multiplyulng2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyulng2args-3                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(upper bound)                   :)
(:$arg2 = xs:unsignedLong(lower bound)                   :)
(:*******************************************************:)

xs:unsignedLong("184467440737095516") * xs:unsignedLong("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyulng2args-3.txt')

!

test_op_numeric_multiplyulng2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyulng2args-4                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(mid range)                     :)
(:*******************************************************:)

xs:unsignedLong("0") * xs:unsignedLong("130747108607674654")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyulng2args-4.txt')

!

test_op_numeric_multiplyulng2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyulng2args-5                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(upper bound)                   :)
(:*******************************************************:)

xs:unsignedLong("0") * xs:unsignedLong("184467440737095516")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyulng2args-5.txt')

!

test_op_numeric_multiplyusht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyusht2args-1                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(lower bound)                  :)
(:*******************************************************:)

xs:unsignedShort("0") * xs:unsignedShort("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyusht2args-1.txt')

!

test_op_numeric_multiplyusht2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyusht2args-2                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(mid range)                    :)
(:$arg2 = xs:unsignedShort(lower bound)                  :)
(:*******************************************************:)

xs:unsignedShort("44633") * xs:unsignedShort("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyusht2args-2.txt')

!

test_op_numeric_multiplyusht2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyusht2args-3                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(upper bound)                  :)
(:$arg2 = xs:unsignedShort(lower bound)                  :)
(:*******************************************************:)

xs:unsignedShort("65535") * xs:unsignedShort("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyusht2args-3.txt')

!

test_op_numeric_multiplyusht2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyusht2args-4                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(mid range)                    :)
(:*******************************************************:)

xs:unsignedShort("0") * xs:unsignedShort("44633")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyusht2args-4.txt')

!

test_op_numeric_multiplyusht2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-multiplyusht2args-5                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-multiply" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(upper bound)                  :)
(:*******************************************************:)

xs:unsignedShort("0") * xs:unsignedShort("65535")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMultiply/op-numeric-multiplyusht2args-5.txt')

! !

!XQTSNumericMultiplyTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
