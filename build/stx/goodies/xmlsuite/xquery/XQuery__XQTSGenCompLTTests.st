"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSGenCompLTTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSGenCompLTTests methodsFor:'tests'!

test_K_GenCompLT_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-1                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where one or more operands is the empty sequence. :)
(:*******************************************************:)
not(() < () )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-1.txt')

!

test_K_GenCompLT_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-10                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
0 < (1, 2, 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-10.txt')

!

test_K_GenCompLT_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-11                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
1 < 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-11.txt')

!

test_K_GenCompLT_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-12                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
xs:untypedAtomic("false") < true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-12.txt')

!

test_K_GenCompLT_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-13                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
false() < xs:untypedAtomic("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-13.txt')

!

test_K_GenCompLT_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-14                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
not(xs:untypedAtomic("true") < false())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-14.txt')

!

test_K_GenCompLT_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-15                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
not(true() < xs:untypedAtomic("false"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-15.txt')

!

test_K_GenCompLT_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-16                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
1 < xs:anyURI("0")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompLT_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-17                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
xs:anyURI("0") < 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompLT_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-18                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: <= combined with count().                    :)
(:*******************************************************:)
1 <= count((1, 2, 3, timezone-from-time(current-time()), 4))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-18.txt')

!

test_K_GenCompLT_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-19                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: < combined with count().                     :)
(:*******************************************************:)
0 < count((1, 2, 3, timezone-from-time(current-time()), 4))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-19.txt')

!

test_K_GenCompLT_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-2                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where one or more operands is the empty sequence. :)
(:*******************************************************:)
not(1 < () )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-2.txt')

!

test_K_GenCompLT_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-3                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where one or more operands is the empty sequence. :)
(:*******************************************************:)
not(() < 1 )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-3.txt')

!

test_K_GenCompLT_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-4                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A syntactically invalid expression that reminds of a general comparison operator. :)
(:*******************************************************:)
1 =< 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompLT_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-5                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
(1, 2, 3) < 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-5.txt')

!

test_K_GenCompLT_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-6                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
(1, 2, 3) < 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-6.txt')

!

test_K_GenCompLT_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-7                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
(1, 2, 3) < 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-7.txt')

!

test_K_GenCompLT_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-8                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
1 < (1, 2, 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-8.txt')

!

test_K_GenCompLT_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLT-9                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
2 < (1, 2, 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/K-GenCompLT-9.txt')

!

test_generalexpression199

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

() < ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression199.txt')

!

test_generalexpression200

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

() < 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression200.txt')

!

test_generalexpression201

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

() < (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression201.txt')

!

test_generalexpression202

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

() < (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression202.txt')

!

test_generalexpression203

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

() < <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression203.txt')

!

test_generalexpression204

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

() < (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression204.txt')

!

test_generalexpression205

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

() < (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression205.txt')

!

test_generalexpression206

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

() < ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression206.txt')

!

test_generalexpression207

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

() < ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression207.txt')

!

test_generalexpression208

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

() < ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression208.txt')

!

test_generalexpression209

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

10000 < ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression209.txt')

!

test_generalexpression210

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

10000 < (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression210.txt')

!

test_generalexpression211

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

10000 < (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression211.txt')

!

test_generalexpression212

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

10000 < <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression212.txt')

!

test_generalexpression213

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

10000 < (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression213.txt')

!

test_generalexpression214

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

10000 < (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression214.txt')

!

test_generalexpression215

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

10000 < ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression215.txt')

!

test_generalexpression216

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

10000 < ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression216.txt')

!

test_generalexpression217

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

10000 < ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression217.txt')

!

test_generalexpression218

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(50000) < ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression218.txt')

!

test_generalexpression219

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(50000) < 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression219.txt')

!

test_generalexpression220

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(50000) < (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression220.txt')

!

test_generalexpression221

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(50000) < (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression221.txt')

!

test_generalexpression222

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(50000) < <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression222.txt')

!

test_generalexpression223

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(50000) < (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression223.txt')

!

test_generalexpression224

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(50000) < (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression224.txt')

!

test_generalexpression225

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(50000) < ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression225.txt')

!

test_generalexpression226

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(50000) < ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression226.txt')

!

test_generalexpression227

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(50000) < ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression227.txt')

!

test_generalexpression228

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(10000,50000) < ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression228.txt')

!

test_generalexpression229

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(10000,50000) < 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression229.txt')

!

test_generalexpression230

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(10000,50000) < (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression230.txt')

!

test_generalexpression231

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(10000,50000) < (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression231.txt')

!

test_generalexpression232

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(10000,50000) < <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression232.txt')

!

test_generalexpression233

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(10000,50000) < (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression233.txt')

!

test_generalexpression234

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(10000,50000) < (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression234.txt')

!

test_generalexpression235

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(10000,50000) < ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression235.txt')

!

test_generalexpression236

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(10000,50000) < ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression236.txt')

!

test_generalexpression237

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(10000,50000) < ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression237.txt')

!

test_generalexpression238

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

<a>10000</a> < ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression238.txt')

!

test_generalexpression239

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

<a>10000</a> < 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression239.txt')

!

test_generalexpression240

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

<a>10000</a> < (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression240.txt')

!

test_generalexpression241

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

<a>10000</a> < (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression241.txt')

!

test_generalexpression242

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

<a>10000</a> < <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression242.txt')

!

test_generalexpression243

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

<a>10000</a> < (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression243.txt')

!

test_generalexpression244

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

<a>10000</a> < (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression244.txt')

!

test_generalexpression245

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<a>10000</a> < ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression245.txt')

!

test_generalexpression246

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<a>10000</a> < ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression246.txt')

!

test_generalexpression247

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

<a>10000</a> < ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression247.txt')

!

test_generalexpression248

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(<a>10000</a>) < ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression248.txt')

!

test_generalexpression249

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(<a>10000</a>) < 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression249.txt')

!

test_generalexpression250

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(<a>10000</a>) < (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression250.txt')

!

test_generalexpression251

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(<a>10000</a>) < (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression251.txt')

!

test_generalexpression252

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(<a>10000</a>) < <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression252.txt')

!

test_generalexpression253

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(<a>10000</a>) < (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression253.txt')

!

test_generalexpression254

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(<a>10000</a>) < (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression254.txt')

!

test_generalexpression255

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>) < ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression255.txt')

!

test_generalexpression256

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>) < ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression256.txt')

!

test_generalexpression257

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(<a>10000</a>) < ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression257.txt')

!

test_generalexpression258

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) < ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression258.txt')

!

test_generalexpression259

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) < 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression259.txt')

!

test_generalexpression260

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) < (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression260.txt')

!

test_generalexpression261

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) < (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression261.txt')

!

test_generalexpression262

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) < <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression262.txt')

!

test_generalexpression263

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) < (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression263.txt')

!

test_generalexpression264

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) < (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression264.txt')

!

test_generalexpression265

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) < ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression265.txt')

!

test_generalexpression266

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) < ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression266.txt')

!

test_generalexpression267

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) < ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression267.txt')

!

test_generalexpression268

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) < ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression268.txt')

!

test_generalexpression269

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) < 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression269.txt')

!

test_generalexpression270

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) < (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression270.txt')

!

test_generalexpression271

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) < (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression271.txt')

!

test_generalexpression272

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) < <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression272.txt')

!

test_generalexpression273

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) < (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression273.txt')

!

test_generalexpression274

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) < (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression274.txt')

!

test_generalexpression275

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) < ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression275.txt')

!

test_generalexpression276

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) < ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression276.txt')

!

test_generalexpression277

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) < ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression277.txt')

!

test_generalexpression278

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) < ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression278.txt')

!

test_generalexpression279

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) < 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression279.txt')

!

test_generalexpression280

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) < (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression280.txt')

!

test_generalexpression281

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) < (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression281.txt')

!

test_generalexpression282

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) < <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression282.txt')

!

test_generalexpression283

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) < (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression283.txt')

!

test_generalexpression284

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) < (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression284.txt')

!

test_generalexpression285

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) < ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression285.txt')

!

test_generalexpression286

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) < ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression286.txt')

!

test_generalexpression287

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) < ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression287.txt')

!

test_generalexpression288

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) < ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression288.txt')

!

test_generalexpression289

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) < 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression289.txt')

!

test_generalexpression290

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) < (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression290.txt')

!

test_generalexpression291

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) < (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression291.txt')

!

test_generalexpression292

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) < <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression292.txt')

!

test_generalexpression293

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) < (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression293.txt')

!

test_generalexpression294

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) < (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression294.txt')

!

test_generalexpression295

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) < ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression295.txt')

!

test_generalexpression296

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) < ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression296.txt')

!

test_generalexpression297

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) < ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/generalexpression297.txt')

!

test_lessthanonanyuri_1

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test - lessthanonanyuri-1                              :)
(:Written By: Carmelo Montanez                           :)
(:Date: September, 25 2006                               :)
(:Purpose: Evaluation of "lt" operator on xs:anyURI datatype.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:anyURI("http://www.example/com")) < (xs:anyURI("http://www.example/com"))

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLT/false.txt')

! !

!XQTSGenCompLTTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
