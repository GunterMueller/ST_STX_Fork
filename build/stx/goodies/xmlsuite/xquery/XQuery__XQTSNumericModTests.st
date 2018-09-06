"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSNumericModTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSNumericModTests methodsFor:'tests'!

test_K_NumericMod_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-1                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) mod xs:integer(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:decimal(6) mod xs:integer(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-1.txt')

!

test_K_NumericMod_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-10                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) mod xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:decimal(6) mod xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-10.txt')

!

test_K_NumericMod_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-11                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) mod xs:decimal(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) mod xs:decimal(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-11.txt')

!

test_K_NumericMod_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-12                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) mod xs:float(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) mod xs:float(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-12.txt')

!

test_K_NumericMod_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-13                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) mod xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:float(6) mod xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-13.txt')

!

test_K_NumericMod_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-14                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) mod xs:integer(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) mod xs:integer(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-14.txt')

!

test_K_NumericMod_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-15                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) mod xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:integer(6) mod xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-15.txt')

!

test_K_NumericMod_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-16                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:double(6) mod xs:double(2)) instance of xs:double`. :)
(:*******************************************************:)
(xs:double(6) mod xs:double(2)) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-16.txt')

!

test_K_NumericMod_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-17                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `10 mod 3 eq 1`.    :)
(:*******************************************************:)
10 mod 3 eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-17.txt')

!

test_K_NumericMod_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-18                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `6 mod -2 eq 0`.    :)
(:*******************************************************:)
6 mod -2 eq 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-18.txt')

!

test_K_NumericMod_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-19                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `4.5 mod 1.2 eq 0.9`. :)
(:*******************************************************:)
4.5 mod 1.2 eq 0.9
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-19.txt')

!

test_K_NumericMod_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-2                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) mod xs:decimal(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:integer(6) mod xs:decimal(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-2.txt')

!

test_K_NumericMod_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-20                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `1.23E2 mod 0.6E1 eq 3.0E0`. :)
(:*******************************************************:)
1.23E2 mod 0.6E1 eq 3.0E0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-20.txt')

!

test_K_NumericMod_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-21                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace for the "mod" operator.   :)
(:*******************************************************:)
10 mod3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericMod_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-22                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace for the "mod" operator.   :)
(:*******************************************************:)
10mod 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericMod_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-23                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invalid whitespace for the "mod" operator.   :)
(:*******************************************************:)
10mod3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericMod_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-24                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "mod operator with invalid operands. :)
(:*******************************************************:)
"3" mod "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericMod_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-25                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Invoke the "mod operator with invalid operands. :)
(:*******************************************************:)
"3" mod 1.1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_NumericMod_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-26                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:untypedAtomic("5") mod xs:double(3)) eq 2`. :)
(:*******************************************************:)
(xs:untypedAtomic("5") mod xs:double(3)) eq 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-26.txt')

!

test_K_NumericMod_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-27                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(5) mod xs:untypedAtomic("3")) eq 2`. :)
(:*******************************************************:)
(xs:decimal(5) mod xs:untypedAtomic("3")) eq 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-27.txt')

!

test_K_NumericMod_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-28                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(() mod ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-28.txt')

!

test_K_NumericMod_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-29                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Operand(s) which are the empty sequence.     :)
(:*******************************************************:)
empty(xs:float(3) mod ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-29.txt')

!

test_K_NumericMod_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-3                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) mod xs:integer(2)) instance of xs:integer`. :)
(:*******************************************************:)
(xs:integer(6) mod xs:integer(2)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-3.txt')

!

test_K_NumericMod_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-4                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) mod xs:decimal(2)) instance of xs:decimal`. :)
(:*******************************************************:)
(xs:decimal(6) mod xs:decimal(2)) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-4.txt')

!

test_K_NumericMod_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-5                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(6) mod xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:decimal(6) mod xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-5.txt')

!

test_K_NumericMod_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-6                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) mod xs:decimal(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) mod xs:decimal(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-6.txt')

!

test_K_NumericMod_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-7                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) mod xs:integer(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) mod xs:integer(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-7.txt')

!

test_K_NumericMod_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-8                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:integer(6) mod xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:integer(6) mod xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-8.txt')

!

test_K_NumericMod_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-NumericMod-9                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A test whose essence is: `(xs:float(6) mod xs:float(2)) instance of xs:float`. :)
(:*******************************************************:)
(xs:float(6) mod xs:float(2)) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/K-NumericMod-9.txt')

!

test_op_numeric_moddbl2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-moddbl2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:double(lower bound)                         :)
(:$arg2 = xs:double(upper bound)                         :)
(:*******************************************************:)

xs:double("-1.7976931348623157E308") mod xs:double("1.7976931348623157E308")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-moddbl2args-1.txt')

!

test_op_numeric_moddec2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-moddec2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(mid range)                          :)
(:*******************************************************:)

xs:decimal("-999999999999999999") mod xs:decimal("617375191608514839")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-moddec2args-1.txt')

!

test_op_numeric_moddec2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-moddec2args-2                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:decimal(lower bound)                        :)
(:$arg2 = xs:decimal(upper bound)                        :)
(:*******************************************************:)

xs:decimal("-999999999999999999") mod xs:decimal("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-moddec2args-2.txt')

!

test_op_numeric_modflt2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modflt2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:float(lower bound)                          :)
(:$arg2 = xs:float(upper bound)                          :)
(:*******************************************************:)

xs:float("-3.4028235E38") mod xs:float("3.4028235E38")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modflt2args-1.txt')

!

test_op_numeric_modint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modint2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:int(lower bound)                            :)
(:$arg2 = xs:int(upper bound)                            :)
(:*******************************************************:)

xs:int("-2147483648") mod xs:int("2147483647")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modint2args-1.txt')

!

test_op_numeric_modintg2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modintg2args-1                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(mid range)                          :)
(:*******************************************************:)

xs:integer("-999999999999999999") mod xs:integer("830993497117024304")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modintg2args-1.txt')

!

test_op_numeric_modintg2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modintg2args-2                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:integer(lower bound)                        :)
(:$arg2 = xs:integer(upper bound)                        :)
(:*******************************************************:)

xs:integer("-999999999999999999") mod xs:integer("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modintg2args-2.txt')

!

test_op_numeric_modlng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modlng2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:long(lower bound)                           :)
(:$arg2 = xs:long(upper bound)                           :)
(:*******************************************************:)

xs:long("-92233720368547758") mod xs:long("92233720368547758")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modlng2args-1.txt')

!

test_op_numeric_modmix2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-modmix2args-1.xq                     :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple mod test with () as one operand should return null :)
(:*******************************************************:)

() mod 1 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modmix2args-1.txt')

!

test_op_numeric_modmix2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-modmix2args-2.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple mod test pass string for second operator :)
(:*******************************************************:)

1 mod "1" 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_modmix2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-modmix2args-3.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple mod test, second operator cast string to integer :)
(:*******************************************************:)

1 mod xs:integer("1")



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modmix2args-3.txt')

!

test_op_numeric_modmix2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-modmix2args-4.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple mod test, second operator is a node, atomization applied :)
(:*******************************************************:)

1 mod <a> 2 </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modmix2args-4.txt')

!

test_op_numeric_modmix2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-modmix2args-5.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple mod test, second operator is a node, atomization applied :)
(:*******************************************************:)

1 mod <a> <b> 2 </b> </a>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modmix2args-5.txt')

!

test_op_numeric_modmix2args_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-modmix2args-6.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple mod test, second operator node which is not atomizable :)
(:*******************************************************:)

1 mod <a> <b> 2</b> <c> 2</c> </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_modmix2args_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-modmix2args-7.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple mod test, two operands are nodes :)
(:*******************************************************:)

<a> 1 </a> mod <b> 2 </b>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modmix2args-7.txt')

!

test_op_numeric_modmix2args_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-modmix2args-8.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple mod test, second operator is a node, atomizable but not castable to integer :)
(:*******************************************************:)

1 mod <a> x </a> 



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_modmix2args_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-numeric-modmix2args-9.xq                  :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed Feb  2 15:17:31 2005                        :)
(: Purpose: Simple mod test pass an empty node for second operator:)
(:*******************************************************:)

1 mod <a/>





      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_numeric_modnni2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modnni2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(mid range)               :)
(:*******************************************************:)

xs:nonNegativeInteger("0") mod xs:nonNegativeInteger("303884545991464527")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modnni2args-1.txt')

!

test_op_numeric_modnni2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modnni2args-2                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:nonNegativeInteger(lower bound)             :)
(:$arg2 = xs:nonNegativeInteger(upper bound)             :)
(:*******************************************************:)

xs:nonNegativeInteger("0") mod xs:nonNegativeInteger("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modnni2args-2.txt')

!

test_op_numeric_modpint2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modpint2args-1                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("1") mod xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modpint2args-1.txt')

!

test_op_numeric_modpint2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modpint2args-2                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(mid range)                  :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("52704602390610033") mod xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modpint2args-2.txt')

!

test_op_numeric_modpint2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modpint2args-3                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(upper bound)                :)
(:$arg2 = xs:positiveInteger(lower bound)                :)
(:*******************************************************:)

xs:positiveInteger("999999999999999999") mod xs:positiveInteger("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modpint2args-3.txt')

!

test_op_numeric_modpint2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modpint2args-4                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(mid range)                  :)
(:*******************************************************:)

xs:positiveInteger("1") mod xs:positiveInteger("52704602390610033")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modpint2args-4.txt')

!

test_op_numeric_modpint2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modpint2args-5                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:positiveInteger(lower bound)                :)
(:$arg2 = xs:positiveInteger(upper bound)                :)
(:*******************************************************:)

xs:positiveInteger("1") mod xs:positiveInteger("999999999999999999")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modpint2args-5.txt')

!

test_op_numeric_modsht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modsht2args-1                          :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:short(lower bound)                          :)
(:$arg2 = xs:short(upper bound)                          :)
(:*******************************************************:)

xs:short("-32768") mod xs:short("32767")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modsht2args-1.txt')

!

test_op_numeric_modulng2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modulng2args-1                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(mid range)                     :)
(:*******************************************************:)

xs:unsignedLong("0") mod xs:unsignedLong("130747108607674654")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modulng2args-1.txt')

!

test_op_numeric_modulng2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modulng2args-2                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedLong(lower bound)                   :)
(:$arg2 = xs:unsignedLong(upper bound)                   :)
(:*******************************************************:)

xs:unsignedLong("0") mod xs:unsignedLong("184467440737095516")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modulng2args-2.txt')

!

test_op_numeric_modusht2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modusht2args-1                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(mid range)                    :)
(:*******************************************************:)

xs:unsignedShort("0") mod xs:unsignedShort("44633")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modusht2args-1.txt')

!

test_op_numeric_modusht2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-numeric-modusht2args-2                         :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:16 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:numeric-mod" operator       :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:unsignedShort(lower bound)                  :)
(:$arg2 = xs:unsignedShort(upper bound)                  :)
(:*******************************************************:)

xs:unsignedShort("0") mod xs:unsignedShort("65535")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/ArithExpr/NumericOpr/NumericMod/op-numeric-modusht2args-2.txt')

! !

!XQTSNumericModTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
