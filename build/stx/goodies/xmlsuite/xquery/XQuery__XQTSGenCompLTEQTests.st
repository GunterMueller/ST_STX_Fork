"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSGenCompLTEQTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSGenCompLTEQTests methodsFor:'tests'!

test_K_GenCompLTEQ_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLTEQ-1                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where one or more operands is the empty sequence. :)
(:*******************************************************:)
not(() <= () )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/K-GenCompLTEQ-1.txt')

!

test_K_GenCompLTEQ_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLTEQ-2                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where one or more operands is the empty sequence. :)
(:*******************************************************:)
not(1 <= () )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/K-GenCompLTEQ-2.txt')

!

test_K_GenCompLTEQ_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLTEQ-3                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where one or more operands is the empty sequence. :)
(:*******************************************************:)
not(() <= 1 )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/K-GenCompLTEQ-3.txt')

!

test_K_GenCompLTEQ_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLTEQ-4                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
1 <= 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/K-GenCompLTEQ-4.txt')

!

test_K_GenCompLTEQ_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLTEQ-5                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
xs:untypedAtomic("false") <= false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/K-GenCompLTEQ-5.txt')

!

test_K_GenCompLTEQ_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLTEQ-6                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
false() <= xs:untypedAtomic("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/K-GenCompLTEQ-6.txt')

!

test_K_GenCompLTEQ_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLTEQ-7                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
xs:untypedAtomic("false") <= false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/K-GenCompLTEQ-7.txt')

!

test_K_GenCompLTEQ_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompLTEQ-8                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
true() <= xs:untypedAtomic("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/K-GenCompLTEQ-8.txt')

!

test_generalexpression298

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <=:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

() <= ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression298.txt')

!

test_generalexpression299

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <=:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

() <= 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression299.txt')

!

test_generalexpression300

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

() <= (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression300.txt')

!

test_generalexpression301

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

() <= (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression301.txt')

!

test_generalexpression302

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <=:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

() <= <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression302.txt')

!

test_generalexpression303

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <=:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

() <= (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression303.txt')

!

test_generalexpression304

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

() <= (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression304.txt')

!

test_generalexpression305

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <=:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

() <= ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression305.txt')

!

test_generalexpression306

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

() <= ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression306.txt')

!

test_generalexpression307

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

() <= ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression307.txt')

!

test_generalexpression308

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <=:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

10000 <= ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression308.txt')

!

test_generalexpression309

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

10000 <= (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression309.txt')

!

test_generalexpression310

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

10000 <= (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression310.txt')

!

test_generalexpression311

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <=:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

10000 <= <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression311.txt')

!

test_generalexpression312

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <=:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

10000 <= (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression312.txt')

!

test_generalexpression313

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

10000 <= (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression313.txt')

!

test_generalexpression314

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <=:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

10000 <= ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression314.txt')

!

test_generalexpression315

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

10000 <= ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression315.txt')

!

test_generalexpression316

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

10000 <= ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression316.txt')

!

test_generalexpression317

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <=:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(50000) <= ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression317.txt')

!

test_generalexpression318

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <=:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(50000) <= 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression318.txt')

!

test_generalexpression319

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(50000) <= (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression319.txt')

!

test_generalexpression320

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(50000) <= (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression320.txt')

!

test_generalexpression321

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <=:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(50000) <= <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression321.txt')

!

test_generalexpression322

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <=:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(50000) <= (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression322.txt')

!

test_generalexpression323

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(50000) <= (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression323.txt')

!

test_generalexpression324

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <=:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(50000) <= ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression324.txt')

!

test_generalexpression325

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(50000) <= ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression325.txt')

!

test_generalexpression326

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(50000) <= ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression326.txt')

!

test_generalexpression327

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <=:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(10000,50000) <= ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression327.txt')

!

test_generalexpression328

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <=:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(10000,50000) <= 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression328.txt')

!

test_generalexpression329

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(10000,50000) <= (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression329.txt')

!

test_generalexpression330

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(10000,50000) <= (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression330.txt')

!

test_generalexpression331

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <=:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(10000,50000) <= <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression331.txt')

!

test_generalexpression332

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <=:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(10000,50000) <= (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression332.txt')

!

test_generalexpression333

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(10000,50000) <= (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression333.txt')

!

test_generalexpression334

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <=:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(10000,50000) <= ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression334.txt')

!

test_generalexpression335

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(10000,50000) <= ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression335.txt')

!

test_generalexpression336

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(10000,50000) <= ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression336.txt')

!

test_generalexpression337

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <=:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

<a>10000</a> <= ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression337.txt')

!

test_generalexpression338

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <=:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

<a>10000</a> <= 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression338.txt')

!

test_generalexpression339

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

<a>10000</a> <= (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression339.txt')

!

test_generalexpression340

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

<a>10000</a> <= (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression340.txt')

!

test_generalexpression341

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <=:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

<a>10000</a> <= <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression341.txt')

!

test_generalexpression342

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

<a>10000</a> <= (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression342.txt')

!

test_generalexpression343

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

<a>10000</a> <= (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression343.txt')

!

test_generalexpression344

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<a>10000</a> <= ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression344.txt')

!

test_generalexpression345

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<a>10000</a> <= ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression345.txt')

!

test_generalexpression346

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

<a>10000</a> <= ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression346.txt')

!

test_generalexpression347

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <=:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(<a>10000</a>) <= ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression347.txt')

!

test_generalexpression348

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <=:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(<a>10000</a>) <= 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression348.txt')

!

test_generalexpression349

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(<a>10000</a>) <= (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression349.txt')

!

test_generalexpression350

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(<a>10000</a>) <= (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression350.txt')

!

test_generalexpression351

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <=:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(<a>10000</a>) <= <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression351.txt')

!

test_generalexpression352

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(<a>10000</a>) <= (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression352.txt')

!

test_generalexpression353

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(<a>10000</a>) <= (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression353.txt')

!

test_generalexpression354

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>) <= ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression354.txt')

!

test_generalexpression355

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>) <= ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression355.txt')

!

test_generalexpression356

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(<a>10000</a>) <= ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression356.txt')

!

test_generalexpression357

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <=:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) <= ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression357.txt')

!

test_generalexpression358

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <=:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) <= 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression358.txt')

!

test_generalexpression359

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) <= (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression359.txt')

!

test_generalexpression360

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) <= (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression360.txt')

!

test_generalexpression361

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <=:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) <= <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression361.txt')

!

test_generalexpression362

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <=:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) <= (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression362.txt')

!

test_generalexpression363

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) <= (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression363.txt')

!

test_generalexpression364

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <=:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) <= ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression364.txt')

!

test_generalexpression365

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) <= ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression365.txt')

!

test_generalexpression366

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) <= ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression366.txt')

!

test_generalexpression367

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <=:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) <= ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression367.txt')

!

test_generalexpression368

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <=:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) <= 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression368.txt')

!

test_generalexpression369

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) <= (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression369.txt')

!

test_generalexpression370

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) <= (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression370.txt')

!

test_generalexpression371

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <=:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) <= <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression371.txt')

!

test_generalexpression372

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <=:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) <= (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression372.txt')

!

test_generalexpression373

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) <= (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression373.txt')

!

test_generalexpression374

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <=:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) <= ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression374.txt')

!

test_generalexpression375

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) <= ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression375.txt')

!

test_generalexpression376

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) <= ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression376.txt')

!

test_generalexpression377

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <=:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) <= ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression377.txt')

!

test_generalexpression378

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <=:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) <= 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression378.txt')

!

test_generalexpression379

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) <= (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression379.txt')

!

test_generalexpression380

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) <= (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression380.txt')

!

test_generalexpression381

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <=:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) <= <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression381.txt')

!

test_generalexpression382

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <=:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) <= (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression382.txt')

!

test_generalexpression383

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) <= (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression383.txt')

!

test_generalexpression384

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <=:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) <= ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression384.txt')

!

test_generalexpression385

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) <= ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression385.txt')

!

test_generalexpression386

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) <= ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression386.txt')

!

test_generalexpression387

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <=:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) <= ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression387.txt')

!

test_generalexpression388

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <=:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) <= 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression388.txt')

!

test_generalexpression389

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) <= (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression389.txt')

!

test_generalexpression390

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <=:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) <= (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression390.txt')

!

test_generalexpression391

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <=:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) <= <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression391.txt')

!

test_generalexpression392

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <=:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) <= (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression392.txt')

!

test_generalexpression393

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) <= (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression393.txt')

!

test_generalexpression394

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <=:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) <= ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression394.txt')

!

test_generalexpression395

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) <= ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression395.txt')

!

test_generalexpression396

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = <=:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) <= ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/generalexpression396.txt')

!

test_lessthaneqonanyuri_1

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Test - lessthaneqonanyuri-1                              :)
(:Written By: Carmelo Montanez                           :)
(:Date: September, 25 2006                               :)
(:Purpose: Evaluation of "le" operator on xs:anyURI datatype.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:anyURI("http://www.example/com")) <= (xs:anyURI("http://www.example/com"))

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompLTEQ/true.txt')

! !

!XQTSGenCompLTEQTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
