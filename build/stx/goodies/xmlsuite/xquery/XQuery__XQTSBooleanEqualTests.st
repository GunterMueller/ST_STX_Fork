"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSBooleanEqualTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSBooleanEqualTests methodsFor:'tests'!

test_K2_BooleanEqual_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-BooleanEqual-1                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Cannot compare xs:boolean and xs:untypedAtomic. :)
(:*******************************************************:)
xs:untypedAtomic("true") eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K2_BooleanEqual_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-BooleanEqual-2                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Cannot compare xs:boolean and xs:untypedAtomic. :)
(:*******************************************************:)
<name>true</name> eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K2_BooleanEqual_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-BooleanEqual-3                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Cannot compare xs:boolean and xs:untypedAtomic(#2). :)
(:*******************************************************:)
true() eq <name>true</name>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_BooleanEqual_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-BooleanEqual-1                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Compare two xs:boolean values.               :)
(:*******************************************************:)
false() eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/K-BooleanEqual-1.txt')

!

test_K_BooleanEqual_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-BooleanEqual-2                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Compare two xs:boolean values.               :)
(:*******************************************************:)
true() eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/K-BooleanEqual-2.txt')

!

test_K_BooleanEqual_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-BooleanEqual-3                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Compare two xs:boolean values.               :)
(:*******************************************************:)
false() ne true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/K-BooleanEqual-3.txt')

!

test_K_BooleanEqual_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-BooleanEqual-4                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: Compare two xs:boolean values.               :)
(:*******************************************************:)
true() ne false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/K-BooleanEqual-4.txt')

!

test_K_BooleanEqual_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-BooleanEqual-5                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A complex value-comparison involving xs:boolean. :)
(:*******************************************************:)
((((((((((((false() eq false()) eq false()) eq false())
					eq false()) eq false()) eq false()) eq false())
					eq false()) eq false()) eq false()) eq false())
					eq false()) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/K-BooleanEqual-5.txt')

!

test_op_boolean_equal2args_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal2args-1                           :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:17 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:boolean-equal" operator     :)
(: with the arguments set as follows:                    :)
(:$value1 = xs:boolean(lower bound)                      :)
(:$value2 = xs:boolean(lower bound)                      :)
(:*******************************************************:)

xs:boolean("false") eq xs:boolean("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal2args-1.txt')

!

test_op_boolean_equal2args_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal2args-2                           :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:17 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:boolean-equal" operator     :)
(: with the arguments set as follows:                    :)
(:$value1 = xs:boolean(mid range)                        :)
(:$value2 = xs:boolean(lower bound)                      :)
(:*******************************************************:)

xs:boolean("1") eq xs:boolean("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal2args-2.txt')

!

test_op_boolean_equal2args_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal2args-3                           :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:17 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:boolean-equal" operator     :)
(: with the arguments set as follows:                    :)
(:$value1 = xs:boolean(upper bound)                      :)
(:$value2 = xs:boolean(lower bound)                      :)
(:*******************************************************:)

xs:boolean("0") eq xs:boolean("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal2args-3.txt')

!

test_op_boolean_equal2args_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal2args-4                           :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:17 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:boolean-equal" operator     :)
(: with the arguments set as follows:                    :)
(:$value1 = xs:boolean(lower bound)                      :)
(:$value2 = xs:boolean(mid range)                        :)
(:*******************************************************:)

xs:boolean("false") eq xs:boolean("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal2args-4.txt')

!

test_op_boolean_equal2args_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal2args-5                           :)
(:Written By: Carmelo Montanez                            :)
(:Date: Thu Dec 16 10:48:17 GMT-05:00 2004                :)
(:Purpose: Evaluates The "op:boolean-equal" operator     :)
(: with the arguments set as follows:                    :)
(:$value1 = xs:boolean(lower bound)                      :)
(:$value2 = xs:boolean(upper bound)                      :)
(:*******************************************************:)

xs:boolean("false") eq xs:boolean("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal2args-5.txt')

!

test_op_boolean_equal_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-1                               :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with operands set to "not(true)", "true" respectively.:)
(: Use of eq operator.                                   :)
(:*******************************************************:)
 
fn:not(xs:boolean("true")) eq xs:boolean("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-1.txt')

!

test_op_boolean_equal_10

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-10                              :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with operands set to "(7 eq 7)" and "false" respectively. :)
(: Use of ge operator.                                   :)
(:*******************************************************:)
 
(7 eq 7) eq xs:boolean("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-10.txt')

!

test_op_boolean_equal_11

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-11                              :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with operands set to "not(7 lt 7)", "true" respectively.:)
(: Use of lt operator.                                   :)
(:*******************************************************:)
 
fn:not(7 lt 7) eq xs:boolean("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-11.txt')

!

test_op_boolean_equal_12

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-12                              :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with operands set to "not(7 lt 7)" and "false" respectively.:)
(:*******************************************************:)
 
fn:not(7 lt 7) and xs:boolean("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-12.txt')

!

test_op_boolean_equal_13

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-13                              :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with both operands set to expressions unsing multiple :)
(: "eq" operators connected by an "and" expression.      :)
(:*******************************************************:)
 
((7 eq 7) eq xs:boolean("true")) and (xs:boolean("false") eq xs:boolean("true"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-13.txt')

!

test_op_boolean_equal_14

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-14                              :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with both operands set to expressions unsing multiple :)
(: "eq" operators connected by an "or" expression.      :)
(:*******************************************************:)
 
((7 eq 7) eq xs:boolean("true")) or (xs:boolean("false") eq xs:boolean("true"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-14.txt')

!

test_op_boolean_equal_15

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-15                              :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: using the "starts-with" function.                     :)
(:*******************************************************:)
 
fn:starts-with("Query","Que") eq  xs:boolean("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-15.txt')

!

test_op_boolean_equal_16

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-16                              :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: using the "ends-with" function.                       :)
(:*******************************************************:)
 
fn:ends-with("Query","ry") eq  xs:boolean("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-16.txt')

!

test_op_boolean_equal_17

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-17                              :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 26, 2006                                   :)
(:Purpose: Evaluates cardinality violation on a sequence :)
(: of two or more items.                                 :)
(:*******************************************************:)

let $e := (0,1) 
 return $e eq 0 

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_op_boolean_equal_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-2                               :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with operands set to "not(true)", "false" respectively.:)
(: Use of eq operator.                                   :)
(:*******************************************************:)
 
fn:not(xs:boolean("true")) eq xs:boolean("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-2.txt')

!

test_op_boolean_equal_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-3                               :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with operands set to "not(false)" ad "false" respectively.:)
(: Use of eq operator.                                   :)
(:*******************************************************:)
 
fn:not(xs:boolean("false")) eq xs:boolean("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-3.txt')

!

test_op_boolean_equal_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-4                               :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with both operands set to "and" expressions respectively.:)
(: Use of eq operator.                                   :)
(:*******************************************************:)
 
(xs:boolean("true") and xs:boolean("true")) eq (xs:boolean("false") and xs:boolean("false"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-4.txt')

!

test_op_boolean_equal_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-5                               :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with left operand set to and "and" expressions with the :)
(: "not" function and right operand set to "true".       :)
(:*******************************************************:)
 
fn:not(xs:boolean("true") and xs:boolean("true")) eq xs:boolean("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-5.txt')

!

test_op_boolean_equal_6

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-6                               :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with left operand set to and "and" expressions with the :)
(: "not" function and right operand set to "false".  :)
(:*******************************************************:)
 
fn:not(xs:boolean("false") and xs:boolean("false")) eq xs:boolean("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-6.txt')

!

test_op_boolean_equal_7

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-7                               :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with operands set to "fn:not(false)" and "fn:not(false)" :)
(: respectively.                                         :)
(:*******************************************************:)
 
fn:not(xs:boolean("false")) eq fn:not(xs:boolean("false"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-7.txt')

!

test_op_boolean_equal_8

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-8                               :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function  with  :)
(: with operands set to "not(false and true)" and        :)
(: "not(false and true)" respectively.                   :)
(:*******************************************************:)
 
fn:not(xs:boolean("false") and xs:boolean("true")) eq fn:not(xs:boolean("false") and xs:boolean("true"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-8.txt')

!

test_op_boolean_equal_9

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: op-boolean-equal-9                               :)
(:Written By: Carmelo Montanez                           :)
(:Date: June 24, 2005                                    :)
(:Purpose: Evaluates The "boolean-equal" function        :)
(: with operands set to "(7 lt 7)" and "true" respectively. :)
(:*******************************************************:)
 
(7 lt 7) eq xs:boolean("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-9.txt')

!

test_op_boolean_equal_more_args_001

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-001.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("false") eq xs:boolean("true")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-001.txt')

!

test_op_boolean_equal_more_args_002

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-002.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("false") eq xs:boolean("1")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-002.txt')

!

test_op_boolean_equal_more_args_003

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-003.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("false") eq xs:boolean("0")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-003.txt')

!

test_op_boolean_equal_more_args_004

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-004.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("false") eq xs:boolean("0")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-004.txt')

!

test_op_boolean_equal_more_args_005

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-005.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("false") eq xs:boolean("1")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-005.txt')

!

test_op_boolean_equal_more_args_006

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-006.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("false") eq true()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-006.txt')

!

test_op_boolean_equal_more_args_007

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-007.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("false") eq false()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-007.txt')

!

test_op_boolean_equal_more_args_008

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-008.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("true") eq xs:boolean("true")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-008.txt')

!

test_op_boolean_equal_more_args_009

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-009.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("true") eq xs:boolean("false")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-009.txt')

!

test_op_boolean_equal_more_args_010

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-010.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("true") eq xs:boolean("1")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-010.txt')

!

test_op_boolean_equal_more_args_011

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-011.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("true") eq xs:boolean("0")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-011.txt')

!

test_op_boolean_equal_more_args_012

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-012.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("1") eq xs:boolean("true")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-012.txt')

!

test_op_boolean_equal_more_args_013

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-013.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("0") eq xs:boolean("true")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-013.txt')

!

test_op_boolean_equal_more_args_014

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-014.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("true") eq xs:boolean("1")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-014.txt')

!

test_op_boolean_equal_more_args_015

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-015.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("true") eq xs:boolean("0")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-015.txt')

!

test_op_boolean_equal_more_args_016

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-016.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("true") eq xs:boolean("1")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-016.txt')

!

test_op_boolean_equal_more_args_017

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-017.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("true") eq xs:boolean("1")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-017.txt')

!

test_op_boolean_equal_more_args_018

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-018.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("true") eq true()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-018.txt')

!

test_op_boolean_equal_more_args_019

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-boolean-equal-more-args-019.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu Jun  2 00:10:02 2005                        :)
(: Purpose: To check if args of Boolean type are equal   :)
(:*******************************************************:)

xs:boolean("true") eq false()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/ValComp/BooleanOp/BooleanEqual/op-boolean-equal-more-args-019.txt')

! !

!XQTSBooleanEqualTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
