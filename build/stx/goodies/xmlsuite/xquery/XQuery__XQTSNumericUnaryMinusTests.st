"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSNumericUnaryMinusTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSNumericUnaryMinusTests methodsFor:'tests'!

test_K_NumericUnaryMinus_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-1                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: No unary operator is available for xs:string. :)
(:*******************************************************:)
-"a string"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericUnaryMinus_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-10                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `---------3 eq -3`. :)
(:*******************************************************:)
---------3 eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-10.txt')

!

test_K_NumericUnaryMinus_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-11                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `+-+-+-+-+-+-+-+3 eq -3`. :)
(:*******************************************************:)
+-+-+-+-+-+-+-+3 eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-11.txt')

!

test_K_NumericUnaryMinus_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-12                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `----+-+-++-+-+-+-+++-+--+--3 eq -3`. :)
(:*******************************************************:)
----+-+-++-+-+-+-+++-+--+--3 eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-12.txt')

!

test_K_NumericUnaryMinus_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-13                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `---3 eq -3`.       :)
(:*******************************************************:)
---3 eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-13.txt')

!

test_K_NumericUnaryMinus_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-2                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `+(-3) eq -3`.      :)
(:*******************************************************:)
+(-3) eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-2.txt')

!

test_K_NumericUnaryMinus_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-3                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(-3) eq -3`.       :)
(:*******************************************************:)
(-3) eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-3.txt')

!

test_K_NumericUnaryMinus_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-4                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(+3) ne -3`.       :)
(:*******************************************************:)
(+3) ne -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-4.txt')

!

test_K_NumericUnaryMinus_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-5                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `-3 eq -3`.         :)
(:*******************************************************:)
-3 eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-5.txt')

!

test_K_NumericUnaryMinus_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-6                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `+(-3) eq -3`.      :)
(:*******************************************************:)
+(-3) eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-6.txt')

!

test_K_NumericUnaryMinus_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-7                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `-(+3) eq -3`.      :)
(:*******************************************************:)
-(+3) eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-7.txt')

!

test_K_NumericUnaryMinus_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-8                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `-(3) eq -3`.       :)
(:*******************************************************:)
-(3) eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-8.txt')

!

test_K_NumericUnaryMinus_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericUnaryMinus-9                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `-(3) eq -3`.       :)
(:*******************************************************:)
-(3) eq -3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/K-NumericUnaryMinus-9.txt')

!

test_op_numeric_unary_minusdbl1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusdbl1args-1                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:double(lower bound)                          :)
(:*******************************************************:)

-(xs:double("-1.7976931348623157E308"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusdbl1args-1.txt')

!

test_op_numeric_unary_minusdbl1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusdbl1args-2                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:double(mid range)                            :)
(:*******************************************************:)

-(xs:double("0"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusdbl1args-2.txt')

!

test_op_numeric_unary_minusdbl1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusdbl1args-3                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:double(upper bound)                          :)
(:*******************************************************:)

-(xs:double("1.7976931348623157E308"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusdbl1args-3.txt')

!

test_op_numeric_unary_minusdec1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusdec1args-1                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:decimal(lower bound)                         :)
(:*******************************************************:)

-(xs:decimal("-999999999999999999"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusdec1args-1.txt')

!

test_op_numeric_unary_minusdec1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusdec1args-2                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:decimal(mid range)                           :)
(:*******************************************************:)

-(xs:decimal("617375191608514839"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusdec1args-2.txt')

!

test_op_numeric_unary_minusdec1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusdec1args-3                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:decimal(upper bound)                         :)
(:*******************************************************:)

-(xs:decimal("999999999999999999"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusdec1args-3.txt')

!

test_op_numeric_unary_minusflt1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusflt1args-1                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:float(lower bound)                           :)
(:*******************************************************:)

-(xs:float("-3.4028235E38"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusflt1args-1.txt')

!

test_op_numeric_unary_minusflt1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusflt1args-2                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:float(mid range)                             :)
(:*******************************************************:)

-(xs:float("0"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusflt1args-2.txt')

!

test_op_numeric_unary_minusflt1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusflt1args-3                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:float(upper bound)                           :)
(:*******************************************************:)

-(xs:float("3.4028235E38"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusflt1args-3.txt')

!

test_op_numeric_unary_minusint1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusint1args-1                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:int(lower bound)                             :)
(:*******************************************************:)

-(xs:int("-2147483647"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusint1args-1.txt')

!

test_op_numeric_unary_minusint1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusint1args-2                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:int(mid range)                               :)
(:*******************************************************:)

-(xs:int("-1873914410"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusint1args-2.txt')

!

test_op_numeric_unary_minusint1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusint1args-3                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:int(upper bound)                             :)
(:*******************************************************:)

-(xs:int("2147483647"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusint1args-3.txt')

!

test_op_numeric_unary_minusintg1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusintg1args-1                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:integer(lower bound)                         :)
(:*******************************************************:)

-(xs:integer("-999999999999999999"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusintg1args-1.txt')

!

test_op_numeric_unary_minusintg1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusintg1args-2                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:integer(mid range)                           :)
(:*******************************************************:)

-(xs:integer("830993497117024304"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusintg1args-2.txt')

!

test_op_numeric_unary_minusintg1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusintg1args-3                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:integer(upper bound)                         :)
(:*******************************************************:)

-(xs:integer("999999999999999999"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusintg1args-3.txt')

!

test_op_numeric_unary_minuslng1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minuslng1args-1                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:long(lower bound)                            :)
(:*******************************************************:)

-(xs:long("-92233720368547758"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minuslng1args-1.txt')

!

test_op_numeric_unary_minuslng1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minuslng1args-2                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:long(mid range)                              :)
(:*******************************************************:)

-(xs:long("-47175562203048468"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minuslng1args-2.txt')

!

test_op_numeric_unary_minuslng1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minuslng1args-3                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:long(upper bound)                            :)
(:*******************************************************:)

-(xs:long("92233720368547758"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minuslng1args-3.txt')

!

test_op_numeric_unary_minusnint1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusnint1args-1                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:negativeInteger(lower bound)                 :)
(:*******************************************************:)

-(xs:negativeInteger("-999999999999999999"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusnint1args-1.txt')

!

test_op_numeric_unary_minusnint1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusnint1args-2                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:negativeInteger(mid range)                   :)
(:*******************************************************:)

-(xs:negativeInteger("-297014075999096793"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusnint1args-2.txt')

!

test_op_numeric_unary_minusnint1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusnint1args-3                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:negativeInteger(upper bound)                 :)
(:*******************************************************:)

-(xs:negativeInteger("-1"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusnint1args-3.txt')

!

test_op_numeric_unary_minusnni1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusnni1args-1                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:nonNegativeInteger(lower bound)              :)
(:*******************************************************:)

-(xs:nonNegativeInteger("0"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusnni1args-1.txt')

!

test_op_numeric_unary_minusnni1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusnni1args-2                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:nonNegativeInteger(mid range)                :)
(:*******************************************************:)

-(xs:nonNegativeInteger("303884545991464527"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusnni1args-2.txt')

!

test_op_numeric_unary_minusnni1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusnni1args-3                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:nonNegativeInteger(upper bound)              :)
(:*******************************************************:)

-(xs:nonNegativeInteger("999999999999999999"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusnni1args-3.txt')

!

test_op_numeric_unary_minusnpi1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusnpi1args-1                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:nonPositiveInteger(lower bound)              :)
(:*******************************************************:)

-(xs:nonPositiveInteger("-999999999999999999"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusnpi1args-1.txt')

!

test_op_numeric_unary_minusnpi1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusnpi1args-2                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:nonPositiveInteger(mid range)                :)
(:*******************************************************:)

-(xs:nonPositiveInteger("-475688437271870490"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusnpi1args-2.txt')

!

test_op_numeric_unary_minusnpi1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusnpi1args-3                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:nonPositiveInteger(upper bound)              :)
(:*******************************************************:)

-(xs:nonPositiveInteger("0"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusnpi1args-3.txt')

!

test_op_numeric_unary_minuspint1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minuspint1args-1                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:positiveInteger(lower bound)                 :)
(:*******************************************************:)

-(xs:positiveInteger("1"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minuspint1args-1.txt')

!

test_op_numeric_unary_minuspint1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minuspint1args-2                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:positiveInteger(mid range)                   :)
(:*******************************************************:)

-(xs:positiveInteger("52704602390610033"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minuspint1args-2.txt')

!

test_op_numeric_unary_minuspint1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minuspint1args-3                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:positiveInteger(upper bound)                 :)
(:*******************************************************:)

-(xs:positiveInteger("999999999999999999"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minuspint1args-3.txt')

!

test_op_numeric_unary_minussht1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minussht1args-1                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:short(lower bound)                           :)
(:*******************************************************:)

-(xs:short("-32768"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minussht1args-1.txt')

!

test_op_numeric_unary_minussht1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minussht1args-2                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:short(mid range)                             :)
(:*******************************************************:)

-(xs:short("-5324"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minussht1args-2.txt')

!

test_op_numeric_unary_minussht1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minussht1args-3                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:short(upper bound)                           :)
(:*******************************************************:)

-(xs:short("32767"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minussht1args-3.txt')

!

test_op_numeric_unary_minusulng1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusulng1args-1                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:unsignedLong(lower bound)                    :)
(:*******************************************************:)

-(xs:unsignedLong("0"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusulng1args-1.txt')

!

test_op_numeric_unary_minusulng1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusulng1args-2                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:unsignedLong(mid range)                      :)
(:*******************************************************:)

-(xs:unsignedLong("130747108607674654"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusulng1args-2.txt')

!

test_op_numeric_unary_minusulng1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minusulng1args-3                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:unsignedLong(upper bound)                    :)
(:*******************************************************:)

-(xs:unsignedLong("184467440737095516"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minusulng1args-3.txt')

!

test_op_numeric_unary_minususht1args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minususht1args-1                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:unsignedShort(lower bound)                   :)
(:*******************************************************:)

-(xs:unsignedShort("0"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minususht1args-1.txt')

!

test_op_numeric_unary_minususht1args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minususht1args-2                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:unsignedShort(mid range)                     :)
(:*******************************************************:)

-(xs:unsignedShort("44633"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minususht1args-2.txt')

!

test_op_numeric_unary_minususht1args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-unary-minususht1args-3                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-unary-minus" operator:)
(: with the arguments set as follows:                    :)
(:$arg = xs:unsignedShort(upper bound)                   :)
(:*******************************************************:)

-(xs:unsignedShort("65535"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericUnaryMinus/op-numeric-unary-minususht1args-3.txt')

! !

!XQTSNumericUnaryMinusTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
