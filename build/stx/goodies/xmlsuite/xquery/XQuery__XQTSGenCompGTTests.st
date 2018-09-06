"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSGenCompGTTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSGenCompGTTests methodsFor:'tests'!

test_K_GenCompGT_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-1                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where one or more operands is the empty sequence. :)
(:*******************************************************:)
not(() > () )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-1.txt')

!

test_K_GenCompGT_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-10                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
2 > 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-10.txt')

!

test_K_GenCompGT_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-11                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
1 >= 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-11.txt')

!

test_K_GenCompGT_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-12                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
xs:untypedAtomic("true") > false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-12.txt')

!

test_K_GenCompGT_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-13                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
true() > xs:untypedAtomic("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-13.txt')

!

test_K_GenCompGT_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-14                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
not(xs:untypedAtomic("false") > true())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-14.txt')

!

test_K_GenCompGT_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-15                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
not(false() > xs:untypedAtomic("true"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-15.txt')

!

test_K_GenCompGT_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-16                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
1 > xs:anyURI("2")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompGT_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-17                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
xs:anyURI("2") > 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompGT_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-18                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: > combined with count().                     :)
(:*******************************************************:)
count((1, 2, 3, timezone-from-time(current-time()), 4)) > 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-18.txt')

!

test_K_GenCompGT_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-19                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: >= combined with count().                    :)
(:*******************************************************:)
count((1, 2, 3, timezone-from-time(current-time()), 4)) >= 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-19.txt')

!

test_K_GenCompGT_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-2                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where one or more operands is the empty sequence. :)
(:*******************************************************:)
not(1 > () )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-2.txt')

!

test_K_GenCompGT_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-3                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where one or more operands is the empty sequence. :)
(:*******************************************************:)
not(() > 1 )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-3.txt')

!

test_K_GenCompGT_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-4                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
(1, 2, 3) > 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-4.txt')

!

test_K_GenCompGT_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-5                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
(1, 2, 3) > 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-5.txt')

!

test_K_GenCompGT_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-6                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
(1, 2, 3) > 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-6.txt')

!

test_K_GenCompGT_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-7                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
4 > (1, 2, 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-7.txt')

!

test_K_GenCompGT_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-8                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
2 > (1, 2, 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-8.txt')

!

test_K_GenCompGT_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompGT-9                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
3 > (1, 2, 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/K-GenCompGT-9.txt')

!

test_generalexpression397

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = >:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

() > ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression397.txt')

!

test_generalexpression398

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = >:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

() > 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression398.txt')

!

test_generalexpression399

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

() > (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression399.txt')

!

test_generalexpression400

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

() > (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression400.txt')

!

test_generalexpression401

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = >:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

() > <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression401.txt')

!

test_generalexpression402

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = >:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

() > (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression402.txt')

!

test_generalexpression403

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

() > (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression403.txt')

!

test_generalexpression404

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = >:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

() > ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression404.txt')

!

test_generalexpression405

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

() > ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression405.txt')

!

test_generalexpression406

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

() > ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression406.txt')

!

test_generalexpression407

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = >:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

10000 > ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression407.txt')

!

test_generalexpression408

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

10000 > (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression408.txt')

!

test_generalexpression409

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

10000 > (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression409.txt')

!

test_generalexpression410

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = >:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

10000 > <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression410.txt')

!

test_generalexpression411

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = >:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

10000 > (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression411.txt')

!

test_generalexpression412

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

10000 > (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression412.txt')

!

test_generalexpression413

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = >:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

10000 > ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression413.txt')

!

test_generalexpression414

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

10000 > ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression414.txt')

!

test_generalexpression415

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

10000 > ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression415.txt')

!

test_generalexpression416

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = >:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(50000) > ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression416.txt')

!

test_generalexpression417

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = >:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(50000) > 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression417.txt')

!

test_generalexpression418

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(50000) > (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression418.txt')

!

test_generalexpression419

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(50000) > (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression419.txt')

!

test_generalexpression420

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = >:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(50000) > <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression420.txt')

!

test_generalexpression421

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = >:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(50000) > (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression421.txt')

!

test_generalexpression422

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(50000) > (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression422.txt')

!

test_generalexpression423

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = >:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(50000) > ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression423.txt')

!

test_generalexpression424

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(50000) > ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression424.txt')

!

test_generalexpression425

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(50000) > ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression425.txt')

!

test_generalexpression426

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = >:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(10000,50000) > ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression426.txt')

!

test_generalexpression427

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = >:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(10000,50000) > 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression427.txt')

!

test_generalexpression428

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(10000,50000) > (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression428.txt')

!

test_generalexpression429

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(10000,50000) > (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression429.txt')

!

test_generalexpression430

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = >:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(10000,50000) > <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression430.txt')

!

test_generalexpression431

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = >:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(10000,50000) > (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression431.txt')

!

test_generalexpression432

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(10000,50000) > (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression432.txt')

!

test_generalexpression433

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = >:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(10000,50000) > ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression433.txt')

!

test_generalexpression434

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(10000,50000) > ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression434.txt')

!

test_generalexpression435

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(10000,50000) > ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression435.txt')

!

test_generalexpression436

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = >:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

<a>10000</a> > ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression436.txt')

!

test_generalexpression437

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = >:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

<a>10000</a> > 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression437.txt')

!

test_generalexpression438

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

<a>10000</a> > (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression438.txt')

!

test_generalexpression439

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

<a>10000</a> > (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression439.txt')

!

test_generalexpression440

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = >:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

<a>10000</a> > <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression440.txt')

!

test_generalexpression441

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = >:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

<a>10000</a> > (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression441.txt')

!

test_generalexpression442

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

<a>10000</a> > (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression442.txt')

!

test_generalexpression443

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = >:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<a>10000</a> > ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression443.txt')

!

test_generalexpression444

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<a>10000</a> > ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression444.txt')

!

test_generalexpression445

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

<a>10000</a> > ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression445.txt')

!

test_generalexpression446

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = >:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(<a>10000</a>) > ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression446.txt')

!

test_generalexpression447

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = >:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(<a>10000</a>) > 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression447.txt')

!

test_generalexpression448

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(<a>10000</a>) > (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression448.txt')

!

test_generalexpression449

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(<a>10000</a>) > (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression449.txt')

!

test_generalexpression450

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = >:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(<a>10000</a>) > <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression450.txt')

!

test_generalexpression451

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = >:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(<a>10000</a>) > (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression451.txt')

!

test_generalexpression452

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(<a>10000</a>) > (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression452.txt')

!

test_generalexpression453

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = >:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>) > ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression453.txt')

!

test_generalexpression454

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>) > ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression454.txt')

!

test_generalexpression455

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(<a>10000</a>) > ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression455.txt')

!

test_generalexpression456

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = >:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) > ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression456.txt')

!

test_generalexpression457

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = >:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) > 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression457.txt')

!

test_generalexpression458

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) > (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression458.txt')

!

test_generalexpression459

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) > (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression459.txt')

!

test_generalexpression460

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = >:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) > <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression460.txt')

!

test_generalexpression461

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = >:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) > (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression461.txt')

!

test_generalexpression462

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) > (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression462.txt')

!

test_generalexpression463

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = >:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) > ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression463.txt')

!

test_generalexpression464

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) > ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression464.txt')

!

test_generalexpression465

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) > ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression465.txt')

!

test_generalexpression466

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = >:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) > ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression466.txt')

!

test_generalexpression467

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = >:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) > 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression467.txt')

!

test_generalexpression468

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) > (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression468.txt')

!

test_generalexpression469

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = >:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) > (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression469.txt')

!

test_generalexpression470

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = >:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) > <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression470.txt')

!

test_generalexpression471

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = >:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) > (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression471.txt')

!

test_generalexpression472

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) > (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression472.txt')

!

test_generalexpression473

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = >:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) > ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression473.txt')

!

test_generalexpression474

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) > ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression474.txt')

!

test_generalexpression475

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) > ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression475.txt')

!

test_generalexpression476

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = >:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) > ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression476.txt')

!

test_generalexpression477

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = >:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) > 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression477.txt')

!

test_generalexpression478

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = >:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) > (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression478.txt')

!

test_generalexpression479

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = >:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) > (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression479.txt')

!

test_generalexpression480

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = >:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) > <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression480.txt')

!

test_generalexpression481

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = >:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) > (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression481.txt')

!

test_generalexpression482

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = >:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) > (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression482.txt')

!

test_generalexpression483

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = >:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) > ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression483.txt')

!

test_generalexpression484

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) > ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression484.txt')

!

test_generalexpression485

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) > ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression485.txt')

!

test_generalexpression486

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = >:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) > ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression486.txt')

!

test_generalexpression487

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = >:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) > 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression487.txt')

!

test_generalexpression488

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = >:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) > (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression488.txt')

!

test_generalexpression489

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = >:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) > (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression489.txt')

!

test_generalexpression490

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = >:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) > <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression490.txt')

!

test_generalexpression491

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = >:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) > (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression491.txt')

!

test_generalexpression492

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = >:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) > (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression492.txt')

!

test_generalexpression493

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = >:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) > ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression493.txt')

!

test_generalexpression494

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = >:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) > ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/generalexpression494.txt')

!

test_greaterthanonanyuri_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test - greaterthanonanyuri-1                             :)
(:Written By: Carmelo Montanez                           :)
(:Date: September, 25 2006                               :)
(:Purpose: Evaluation of "gt" operator on xs:anyURI datatype.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:anyURI("http://www.example/com")) > (xs:anyURI("http://www.example/com"))

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompGT/false.txt')

! !

!XQTSGenCompGTTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
