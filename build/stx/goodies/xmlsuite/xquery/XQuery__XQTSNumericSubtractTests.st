"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSNumericSubtractTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSNumericSubtractTests methodsFor:'tests'!

test_K_NumericSubtract_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-1                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:double(6) - xs:double(2) eq 4`. :)
(:*******************************************************:)
xs:double(6) - xs:double(2) eq 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-1.txt')

!

test_K_NumericSubtract_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-10                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) - xs:decimal(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) - xs:decimal(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-10.txt')

!

test_K_NumericSubtract_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-11                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) - xs:integer(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) - xs:integer(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-11.txt')

!

test_K_NumericSubtract_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-12                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) - xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:integer(6) - xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-12.txt')

!

test_K_NumericSubtract_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-13                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) - xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) - xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-13.txt')

!

test_K_NumericSubtract_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-14                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) - xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:decimal(6) - xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-14.txt')

!

test_K_NumericSubtract_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-15                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) - xs:decimal(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) - xs:decimal(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-15.txt')

!

test_K_NumericSubtract_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-16                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) - xs:float(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) - xs:float(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-16.txt')

!

test_K_NumericSubtract_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-17                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) - xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:float(6) - xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-17.txt')

!

test_K_NumericSubtract_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-18                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) - xs:integer(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) - xs:integer(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-18.txt')

!

test_K_NumericSubtract_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-19                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) - xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:integer(6) - xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-19.txt')

!

test_K_NumericSubtract_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-2                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:decimal(6) - xs:decimal(2) eq 4`. :)
(:*******************************************************:)
xs:decimal(6) - xs:decimal(2) eq 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-2.txt')

!

test_K_NumericSubtract_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-20                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) - xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) - xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-20.txt')

!

test_K_NumericSubtract_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-21                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(xs:float("NaN") - 3) eq "NaN"`. :)
(:*******************************************************:)
string(xs:float("NaN") - 3) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-21.txt')

!

test_K_NumericSubtract_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-22                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(xs:double("NaN") - 3) eq "NaN"`. :)
(:*******************************************************:)
string(xs:double("NaN") - 3) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-22.txt')

!

test_K_NumericSubtract_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-23                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(3 - xs:float("NaN")) eq "NaN"`. :)
(:*******************************************************:)
string(3 - xs:float("NaN")) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-23.txt')

!

test_K_NumericSubtract_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-24                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `string(3 - xs:double("NaN")) eq "NaN"`. :)
(:*******************************************************:)
string(3 - xs:double("NaN")) eq "NaN"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-24.txt')

!

test_K_NumericSubtract_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-25                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "-" operator with invalid operands. :)
(:*******************************************************:)
"3" - "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericSubtract_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-26                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "-" operator with invalid operands. :)
(:*******************************************************:)
xs:untypedAtomic("3") - "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericSubtract_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-27                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:untypedAtomic("3") - 3) eq 0`. :)
(:*******************************************************:)
(xs:untypedAtomic("3") - 3) eq 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-27.txt')

!

test_K_NumericSubtract_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-28                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(3 - xs:untypedAtomic("3")) eq 0`. :)
(:*******************************************************:)
(3 - xs:untypedAtomic("3")) eq 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-28.txt')

!

test_K_NumericSubtract_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-29                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() - ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-29.txt')

!

test_K_NumericSubtract_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-3                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:integer(6) - xs:integer(2) eq 4`. :)
(:*******************************************************:)
xs:integer(6) - xs:integer(2) eq 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-3.txt')

!

test_K_NumericSubtract_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-30                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() - xs:float(3))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-30.txt')

!

test_K_NumericSubtract_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-31                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() - xs:double(3))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-31.txt')

!

test_K_NumericSubtract_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-32                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:untypedAtomic("3") - xs:untypedAtomic("3")) eq 0`. :)
(:*******************************************************:)
(xs:untypedAtomic("3") - xs:untypedAtomic("3")) eq 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-32.txt')

!

test_K_NumericSubtract_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-33                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:untypedAtomic("3") - xs:untypedAtomic("3")) instance of xs:double`. :)
(:*******************************************************:)
(xs:untypedAtomic("3") -
			       xs:untypedAtomic("3")) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-33.txt')

!

test_K_NumericSubtract_34

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-34                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:untypedAtomic("3") - 1.1) instance of xs:double`. :)
(:*******************************************************:)
(xs:untypedAtomic("3") - 1.1) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-34.txt')

!

test_K_NumericSubtract_35

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-35                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(1.1 - xs:untypedAtomic("3")) instance of xs:double`. :)
(:*******************************************************:)
(1.1 - xs:untypedAtomic("3")) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-35.txt')

!

test_K_NumericSubtract_36

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-36                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Substracting zero, with complex operands. Implementations supporting the static typing feature may raise XPTY0004. :)
(:*******************************************************:)
1 eq (remove((current-time(), 1), 1) - 0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-36.txt')

!

test_K_NumericSubtract_37

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-37                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Adding zero, with complex operands. Implementations supporting the static typing feature may raise XPTY0004. :)
(:*******************************************************:)
1 eq (remove((current-time(), 1), 1) + 0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-37.txt')

!

test_K_NumericSubtract_38

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-38                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Adding zero, with complex operands. Implementations supporting the static typing feature may raise XPTY0004. :)
(:*******************************************************:)
1 eq (0 + remove((current-time(), 1), 1))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-38.txt')

!

test_K_NumericSubtract_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-4                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(5) - xs:float(1) eq 4`. :)
(:*******************************************************:)
xs:float(5) - xs:float(1) eq 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-4.txt')

!

test_K_NumericSubtract_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-5                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) - xs:integer(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:decimal(6) - xs:integer(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-5.txt')

!

test_K_NumericSubtract_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-6                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) - xs:decimal(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:integer(6) - xs:decimal(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-6.txt')

!

test_K_NumericSubtract_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-7                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) - xs:integer(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:integer(6) - xs:integer(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-7.txt')

!

test_K_NumericSubtract_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-8                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) - xs:decimal(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:decimal(6) - xs:decimal(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-8.txt')

!

test_K_NumericSubtract_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericSubtract-9                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) - xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:decimal(6) - xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/K-NumericSubtract-9.txt')

!

test_op_numeric_subtractdbl2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractdbl2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("-1.7976931348623157E308") - xs:double("-1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractdbl2args-1.txt')

!

test_op_numeric_subtractdbl2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractdbl2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(mid range)                           :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("0") - xs:double("-1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractdbl2args-2.txt')

!

test_op_numeric_subtractdbl2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractdbl2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(upper bound)                         :)
(:$arg2 = xs:double(lower bound)                         :)
(:*******************************************************:)

xs:double("0") - xs:double("-1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractdbl2args-3.txt')

!

test_op_numeric_subtractdbl2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractdbl2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(mid range)                           :)
(:*******************************************************:)

xs:double("-1.7976931348623157E308") - xs:double("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractdbl2args-4.txt')

!

test_op_numeric_subtractdbl2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractdbl2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(upper bound)                         :)
(:*******************************************************:)

xs:double("0") - xs:double("1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractdbl2args-5.txt')

!

test_op_numeric_subtractdec2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractdec2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("-999999999999999999") - xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractdec2args-1.txt')

!

test_op_numeric_subtractdec2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractdec2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Tue Apr 12 16:28:58 GMT-05:00 2005                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(mid range)                          :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("0") - xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractdec2args-2.txt')

!

test_op_numeric_subtractdec2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractdec2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Tue Apr 12 16:28:58 GMT-05:00 2005                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(upper bound)                        :)
(:$arg2 = xs:decimal(lower bound)                        :)
(:*******************************************************:)

xs:decimal("0") - xs:decimal("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractdec2args-3.txt')

!

test_op_numeric_subtractdec2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractdec2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(mid range)                          :)
(:*******************************************************:)

xs:decimal("-382624808391485160") - xs:decimal("617375191608514839")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractdec2args-4.txt')

!

test_op_numeric_subtractdec2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractdec2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(upper bound)                        :)
(:*******************************************************:)

xs:decimal("0") - xs:decimal("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractdec2args-5.txt')

!

test_op_numeric_subtractflt2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractflt2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("-3.4028235E38") - xs:float("-3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractflt2args-1.txt')

!

test_op_numeric_subtractflt2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractflt2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(mid range)                            :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("0") - xs:float("-3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractflt2args-2.txt')

!

test_op_numeric_subtractflt2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractflt2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(upper bound)                          :)
(:$arg2 = xs:float(lower bound)                          :)
(:*******************************************************:)

xs:float("0") - xs:float("-3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractflt2args-3.txt')

!

test_op_numeric_subtractflt2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractflt2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(mid range)                            :)
(:*******************************************************:)

xs:float("-3.4028235E38") - xs:float("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractflt2args-4.txt')

!

test_op_numeric_subtractflt2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractflt2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(upper bound)                          :)
(:*******************************************************:)

xs:float("0") - xs:float("3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractflt2args-5.txt')

!

test_op_numeric_subtractint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractint2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

xs:int("-2147483648") - xs:int("-2147483648")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractint2args-1.txt')

!

test_op_numeric_subtractint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractint2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(mid range)                              :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

xs:int("-1873914410") - xs:int("-2147483648")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractint2args-2.txt')

!

test_op_numeric_subtractint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractint2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(upper bound)                            :)
(:$arg2 = xs:int(lower bound)                            :)
(:*******************************************************:)

xs:int("-1") - xs:int("-2147483648")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractint2args-3.txt')

!

test_op_numeric_subtractint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractint2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(mid range)                              :)
(:*******************************************************:)

xs:int("-2147483648") - xs:int("-1873914410")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractint2args-4.txt')

!

test_op_numeric_subtractint2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractint2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(upper bound)                            :)
(:*******************************************************:)

xs:int("-1") - xs:int("2147483647")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractint2args-5.txt')

!

test_op_numeric_subtractintg2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractintg2args-1                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

xs:integer("-999999999999999999") - xs:integer("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractintg2args-1.txt')

!

test_op_numeric_subtractintg2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractintg2args-2                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(mid range)                          :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

xs:integer("0") - xs:integer("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractintg2args-2.txt')

!

test_op_numeric_subtractintg2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractintg2args-3                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(upper bound)                        :)
(:$arg2 = xs:integer(lower bound)                        :)
(:*******************************************************:)

xs:integer("0") - xs:integer("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractintg2args-3.txt')

!

test_op_numeric_subtractintg2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractintg2args-4                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(mid range)                          :)
(:*******************************************************:)

xs:integer("-169006502882975695") - xs:integer("830993497117024304")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractintg2args-4.txt')

!

test_op_numeric_subtractintg2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractintg2args-5                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(upper bound)                        :)
(:*******************************************************:)

xs:integer("0") - xs:integer("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractintg2args-5.txt')

!

test_op_numeric_subtractlng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractlng2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

xs:long("-92233720368547758") - xs:long("-92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractlng2args-1.txt')

!

test_op_numeric_subtractlng2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractlng2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(mid range)                             :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

xs:long("-47175562203048468") - xs:long("-92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractlng2args-2.txt')

!

test_op_numeric_subtractlng2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractlng2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(upper bound)                           :)
(:$arg2 = xs:long(lower bound)                           :)
(:*******************************************************:)

xs:long("0") - xs:long("-92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractlng2args-3.txt')

!

test_op_numeric_subtractlng2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractlng2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(mid range)                             :)
(:*******************************************************:)

xs:long("-92233720368547758") - xs:long("-47175562203048468")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractlng2args-4.txt')

!

test_op_numeric_subtractlng2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractlng2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(upper bound)                           :)
(:*******************************************************:)

xs:long("0") - xs:long("92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractlng2args-5.txt')

!

test_op_numeric_subtractmix2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-subtractmix2args-1.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:07:00 2005                        :)
(: Purpose: Simple subtraction test with () as one operand should return null :)
(:*******************************************************:)

1 - ()



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractmix2args-1.txt')

!

test_op_numeric_subtractmix2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-subtractmix2args-2.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:07:00 2005                        :)
(: Purpose: Simple subtraction test pass string for second operator :)
(:*******************************************************:)

1 - "1" 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_subtractmix2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-subtractmix2args-3.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:07:00 2005                        :)
(: Purpose: Simple subtraction test, second operator cast string to integer :)
(:*******************************************************:)

1 - xs:integer("1")



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractmix2args-3.txt')

!

test_op_numeric_subtractmix2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-subtractmix2args-4.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:07:00 2005                        :)
(: Purpose: Simple subtraction test, second operator is a node, atomization applied :)
(:*******************************************************:)

3 - <a> 2 </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractmix2args-4.txt')

!

test_op_numeric_subtractmix2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-subtractmix2args-5.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:07:00 2005                        :)
(: Purpose: Simple subtraction test, second operator is a node, atomization applied :)
(:*******************************************************:)

3 - <a> <b> 2 </b> </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractmix2args-5.txt')

!

test_op_numeric_subtractmix2args_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-subtractmix2args-6.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:07:00 2005                        :)
(: Purpose: Simple subtraction test, second operator node which is not atomizable :)
(:*******************************************************:)

3 - <a> <b> 2</b> <c> 2</c> </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_subtractmix2args_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-subtractmix2args-7.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:07:00 2005                        :)
(: Purpose: Simple subtraction test, two operands are nodes :)
(:*******************************************************:)

<a> 2 </a> - <b> 1 </b>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractmix2args-7.txt')

!

test_op_numeric_subtractmix2args_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-subtractmix2args-8.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:07:00 2005                        :)
(: Purpose: Simple subtraction test, second operator is a node, atomizable but not castable to integer :)
(:*******************************************************:)

1 - <a> x </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_subtractmix2args_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-subtractmix2args-9.xq                :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:07:00 2005                        :)
(: Purpose: Simple subtraction test pass an empty node for second operator :)
(:*******************************************************:)

1 - <a/>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_subtractnint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnint2args-1                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(lower bound)                :)
(:$arg2 = xs:negativeInteger(mid range)                  :)
(:*******************************************************:)

xs:negativeInteger("-999999999999999999") - xs:negativeInteger("-297014075999096793")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnint2args-1.txt')

!

test_op_numeric_subtractnint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnint2args-2                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:negativeInteger(lower bound)                :)
(:$arg2 = xs:negativeInteger(upper bound)                :)
(:*******************************************************:)

xs:negativeInteger("-999999999999999999") - xs:negativeInteger("-1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnint2args-2.txt')

!

test_op_numeric_subtractnni2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnni2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(lower bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("0") - xs:nonNegativeInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnni2args-1.txt')

!

test_op_numeric_subtractnni2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnni2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(mid range)               :)
(:$arg2 = xs:nonNegativeInteger(lower bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("303884545991464527") - xs:nonNegativeInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnni2args-2.txt')

!

test_op_numeric_subtractnni2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnni2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(upper bound)             :)
(:$arg2 = xs:nonNegativeInteger(lower bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("999999999999999999") - xs:nonNegativeInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnni2args-3.txt')

!

test_op_numeric_subtractnni2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnni2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(mid range)               :)
(:*******************************************************:)

xs:nonNegativeInteger("303884545991464527") - xs:nonNegativeInteger("303884545991464527")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnni2args-4.txt')

!

test_op_numeric_subtractnni2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnni2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(upper bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("999999999999999999") - xs:nonNegativeInteger("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnni2args-5.txt')

!

test_op_numeric_subtractnpi2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnpi2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(lower bound)             :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("-999999999999999999") - xs:nonPositiveInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnpi2args-1.txt')

!

test_op_numeric_subtractnpi2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnpi2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(mid range)               :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("-999999999999999999") - xs:nonPositiveInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnpi2args-2.txt')

!

test_op_numeric_subtractnpi2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnpi2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(upper bound)             :)
(:$arg2 = xs:nonPositiveInteger(lower bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("-999999999999999999") - xs:nonPositiveInteger("-999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnpi2args-3.txt')

!

test_op_numeric_subtractnpi2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnpi2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(lower bound)             :)
(:$arg2 = xs:nonPositiveInteger(mid range)               :)
(:*******************************************************:)

xs:nonPositiveInteger("-999999999999999999") - xs:nonPositiveInteger("-475688437271870490")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnpi2args-4.txt')

!

test_op_numeric_subtractnpi2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractnpi2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonPositiveInteger(lower bound)             :)
(:$arg2 = xs:nonPositiveInteger(upper bound)             :)
(:*******************************************************:)

xs:nonPositiveInteger("-999999999999999999") - xs:nonPositiveInteger("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractnpi2args-5.txt')

!

test_op_numeric_subtractpint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractpint2args-1                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(mid range)                  :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("52704602390610033") - xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractpint2args-1.txt')

!

test_op_numeric_subtractpint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractpint2args-2                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(upper bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("999999999999999999") - xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractpint2args-2.txt')

!

test_op_numeric_subtractpint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractpint2args-3                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(mid range)                  :)
(:*******************************************************:)

xs:positiveInteger("52704602390610034") - xs:positiveInteger("52704602390610033")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractpint2args-3.txt')

!

test_op_numeric_subtractsht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractsht2args-1                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

xs:short("-32768") - xs:short("-32768")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractsht2args-1.txt')

!

test_op_numeric_subtractsht2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractsht2args-2                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(mid range)                            :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

xs:short("-5324") - xs:short("-32768")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractsht2args-2.txt')

!

test_op_numeric_subtractsht2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractsht2args-3                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(upper bound)                          :)
(:$arg2 = xs:short(lower bound)                          :)
(:*******************************************************:)

xs:short("-1") - xs:short("-32768")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractsht2args-3.txt')

!

test_op_numeric_subtractsht2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractsht2args-4                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(mid range)                            :)
(:*******************************************************:)

xs:short("-32768") - xs:short("-5324")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractsht2args-4.txt')

!

test_op_numeric_subtractsht2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractsht2args-5                     :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(upper bound)                          :)
(:*******************************************************:)

xs:short("-1") - xs:short("32767")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractsht2args-5.txt')

!

test_op_numeric_subtractulng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractulng2args-1                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(lower bound)                   :)
(:*******************************************************:)

xs:unsignedLong("0") - xs:unsignedLong("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractulng2args-1.txt')

!

test_op_numeric_subtractulng2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractulng2args-2                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(mid range)                     :)
(:$arg2 = xs:unsignedLong(lower bound)                   :)
(:*******************************************************:)

xs:unsignedLong("130747108607674654") - xs:unsignedLong("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractulng2args-2.txt')

!

test_op_numeric_subtractulng2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractulng2args-3                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(upper bound)                   :)
(:$arg2 = xs:unsignedLong(lower bound)                   :)
(:*******************************************************:)

xs:unsignedLong("184467440737095516") - xs:unsignedLong("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractulng2args-3.txt')

!

test_op_numeric_subtractulng2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractulng2args-4                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(mid range)                     :)
(:*******************************************************:)

xs:unsignedLong("130747108607674654") - xs:unsignedLong("130747108607674654")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractulng2args-4.txt')

!

test_op_numeric_subtractulng2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractulng2args-5                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(upper bound)                   :)
(:*******************************************************:)

xs:unsignedLong("184467440737095516") - xs:unsignedLong("184467440737095516")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractulng2args-5.txt')

!

test_op_numeric_subtractusht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractusht2args-1                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(lower bound)                  :)
(:*******************************************************:)

xs:unsignedShort("0") - xs:unsignedShort("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractusht2args-1.txt')

!

test_op_numeric_subtractusht2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractusht2args-2                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(mid range)                    :)
(:$arg2 = xs:unsignedShort(lower bound)                  :)
(:*******************************************************:)

xs:unsignedShort("44633") - xs:unsignedShort("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractusht2args-2.txt')

!

test_op_numeric_subtractusht2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractusht2args-3                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:15 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(upper bound)                  :)
(:$arg2 = xs:unsignedShort(lower bound)                  :)
(:*******************************************************:)

xs:unsignedShort("65535") - xs:unsignedShort("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractusht2args-3.txt')

!

test_op_numeric_subtractusht2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractusht2args-4                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(mid range)                    :)
(:*******************************************************:)

xs:unsignedShort("44633") - xs:unsignedShort("44633")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractusht2args-4.txt')

!

test_op_numeric_subtractusht2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-subtractusht2args-5                    :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-subtract" operator  :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(upper bound)                  :)
(:*******************************************************:)

xs:unsignedShort("65535") - xs:unsignedShort("65535")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericSubtract/op-numeric-subtractusht2args-5.txt')

! !

!XQTSNumericSubtractTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
