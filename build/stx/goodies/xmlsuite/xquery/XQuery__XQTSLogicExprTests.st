"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSLogicExprTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSLogicExprTests methodsFor:'tests'!

test_K_LogicExpr_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-1                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not("" or 0)`.     :)
(:*******************************************************:)
not("" or 0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-1.txt')

!

test_K_LogicExpr_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-10                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Non-empty xs:anyURIs in the left branch of an or-expression has an EBV value of true. :)
(:*******************************************************:)
not(xs:anyURI("") or 0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-10.txt')

!

test_K_LogicExpr_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-11                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Non-empty xs:anyURIs in the right branch of an or-expression has an EBV value of true. :)
(:*******************************************************:)
not(0 or xs:anyURI(""))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-11.txt')

!

test_K_LogicExpr_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-12                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Non-empty xs:untypedAtomics in the left branch of an or-expression has an EBV value of true. :)
(:*******************************************************:)
xs:untypedAtomic("a string") or 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-12.txt')

!

test_K_LogicExpr_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-13                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Non-empty xs:untypedAtomics in the right branch of an or-expression has an EBV value of true. :)
(:*******************************************************:)
0 or xs:untypedAtomic("a string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-13.txt')

!

test_K_LogicExpr_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-14                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `true() or (0, current-time())[1] treat as xs:integer`. :)
(:*******************************************************:)
true() or (0, current-time())[1] treat as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-14.txt')

!

test_K_LogicExpr_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-15                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(0, current-time())[1] treat as xs:integer or true()`. :)
(:*******************************************************:)
(0, current-time())[1] treat as xs:integer or true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-15.txt')

!

test_K_LogicExpr_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-16                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An "or" expression having an operand which EBV cannot be extracted from. :)
(:*******************************************************:)
current-date() or 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_LogicExpr_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-17                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An "or" expression having an operand which EBV cannot be extracted from. :)
(:*******************************************************:)
0 or current-date()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_LogicExpr_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-18                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An "or" expression whose operands EBV cannot be extracted from. :)
(:*******************************************************:)
current-date() or current-date()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_LogicExpr_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-19                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An "and" expression having an operand which EBV cannot be extracted from. :)
(:*******************************************************:)
current-date() and current-date()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_LogicExpr_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-2                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(0 or 0)`.      :)
(:*******************************************************:)
not(0 or 0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-2.txt')

!

test_K_LogicExpr_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-20                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An "and" expression having an operand which EBV cannot be extracted from. :)
(:*******************************************************:)
1 and current-date()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_LogicExpr_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-21                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An "and" expression whose operands EBV cannot be extracted from. :)
(:*******************************************************:)
current-date() and 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_LogicExpr_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-22                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An and-test applied on fn:count().           :)
(:*******************************************************:)
count((1, 2, 3, timezone-from-time(current-time()), 4)) or false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-22.txt')

!

test_K_LogicExpr_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-23                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An or-test applied on fn:count().            :)
(:*******************************************************:)
false() or count((1, 2, 3, timezone-from-time(current-time()), 4))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-23.txt')

!

test_K_LogicExpr_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-24                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An or-test applied on fn:count().            :)
(:*******************************************************:)
count((1, 2, 3, timezone-from-time(current-time()), 4)) or count((1, 2, 3, timezone-from-time(current-time()), 4))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-24.txt')

!

test_K_LogicExpr_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-25                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: or expression combined with fn:boolean().    :)
(:*******************************************************:)
boolean((1, 2, 3, current-time())[1] treat as xs:integer) or boolean((1, 2, 3, current-time())[1] treat as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-25.txt')

!

test_K_LogicExpr_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-26                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: and expression combined or fn:boolean().     :)
(:*******************************************************:)
boolean((1, 2, 3, current-time())[1] treat as xs:integer) and true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-26.txt')

!

test_K_LogicExpr_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-27                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: or expression combined with fn:boolean().    :)
(:*******************************************************:)
true() or boolean((1, 2, 3, current-time())[1] treat as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-27.txt')

!

test_K_LogicExpr_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-28                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not("" and 0)`.    :)
(:*******************************************************:)
not("" and 0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-28.txt')

!

test_K_LogicExpr_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-29                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 and 1`.          :)
(:*******************************************************:)
1 and 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-29.txt')

!

test_K_LogicExpr_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-3                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(0 or 0)`.      :)
(:*******************************************************:)
not(0 or 0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-3.txt')

!

test_K_LogicExpr_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-30                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `10.3 and "non-zero length string"`. :)
(:*******************************************************:)
10.3 and "non-zero length string"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-30.txt')

!

test_K_LogicExpr_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-31                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 and 5`.          :)
(:*******************************************************:)
1 and 5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-31.txt')

!

test_K_LogicExpr_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-32                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not((1, current-time())[1] treat as xs:integer and false())`. :)
(:*******************************************************:)
not((1, current-time())[1] treat as xs:integer and false())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-32.txt')

!

test_K_LogicExpr_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-33                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(false() and (1, current-time())[1] treat as xs:integer)`. :)
(:*******************************************************:)
not(false() and (1, current-time())[1] treat as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-33.txt')

!

test_K_LogicExpr_34

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-34                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Non-empty xs:anyURIs have an EBV value of true. :)
(:*******************************************************:)
xs:anyURI("example.com/") and xs:anyURI("example.com/")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-34.txt')

!

test_K_LogicExpr_35

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-35                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Empty xs:anyURIs have an EBV value of false. :)
(:*******************************************************:)
not(xs:anyURI("example.com/") and xs:anyURI(""))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-35.txt')

!

test_K_LogicExpr_36

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-36                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Empty xs:anyURIs have an EBV value of false. :)
(:*******************************************************:)
not(xs:anyURI("") and xs:anyURI("example.com/"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-36.txt')

!

test_K_LogicExpr_37

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-37                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Non-empty xs:untypedAtomics have an EBV value of true. :)
(:*******************************************************:)
xs:untypedAtomic("a string") and xs:untypedAtomic("a string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-37.txt')

!

test_K_LogicExpr_38

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-38                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Empty xs:untypedAtomics have an EBV value of false. :)
(:*******************************************************:)
not(xs:untypedAtomic("a string") and xs:untypedAtomic(""))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-38.txt')

!

test_K_LogicExpr_39

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-39                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An and-test applied on fn:count().           :)
(:*******************************************************:)
count((1, 2, 3, timezone-from-time(current-time()), 4)) and true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-39.txt')

!

test_K_LogicExpr_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-4                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not("" or 0)`.     :)
(:*******************************************************:)
not("" or 0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-4.txt')

!

test_K_LogicExpr_40

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-40                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An and-test applied on fn:count().           :)
(:*******************************************************:)
true() and count((1, 2, 3, timezone-from-time(current-time()), 4))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-40.txt')

!

test_K_LogicExpr_41

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-41                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An and-test applied on fn:count().           :)
(:*******************************************************:)
count((1, 2, 3, timezone-from-time(current-time()), 4)) and count((1, 2, 3, timezone-from-time(current-time()), 4))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-41.txt')

!

test_K_LogicExpr_42

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-42                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: and-expression combined with fn:boolean().   :)
(:*******************************************************:)
boolean((1, 2, 3, current-time())[1] treat as xs:integer) and boolean((1, 2, 3, current-time())[1] treat as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-42.txt')

!

test_K_LogicExpr_43

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-43                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: and-expression combined with fn:boolean().   :)
(:*******************************************************:)
boolean((1, 2, 3, current-time())[1] treat as xs:integer) and true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-43.txt')

!

test_K_LogicExpr_44

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-44                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: and-expression combined with fn:boolean().   :)
(:*******************************************************:)
true() and boolean((1, 2, 3, current-time())[1] treat as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-44.txt')

!

test_K_LogicExpr_45

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-45                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `"a string is ok" and QName("", "local")`. :)
(:*******************************************************:)
"a string is ok" and QName("", "local")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_LogicExpr_46

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-46                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `"a string is ok" or QName("", "local")`. :)
(:*******************************************************:)
"a string is ok" or QName("", "local")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-46.txt')

!

test_K_LogicExpr_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-5                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 or 1`.           :)
(:*******************************************************:)
1 or 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-5.txt')

!

test_K_LogicExpr_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-6                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 or 0`.           :)
(:*******************************************************:)
1 or 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-6.txt')

!

test_K_LogicExpr_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-7                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 or 5`.           :)
(:*******************************************************:)
1 or 5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-7.txt')

!

test_K_LogicExpr_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-8                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Non-empty xs:anyURIs in the left branch of an or-expression has an EBV value of true. :)
(:*******************************************************:)
xs:anyURI("example.com/") or 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-8.txt')

!

test_K_LogicExpr_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LogicExpr-9                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Non-empty xs:anyURIs in the right branch of an or-expression has an EBV value of true. :)
(:*******************************************************:)
0 or xs:anyURI("example.com/")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/K-LogicExpr-9.txt')

!

test_op_logical_and_001

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-001.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using Boolean values           :)
(:*******************************************************:)

   <return>
     { false() and false() }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-001.xml')

!

test_op_logical_and_002

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-002.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using Boolean values           :)
(:*******************************************************:)

   <return>
     { true() and false() }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-002.xml')

!

test_op_logical_and_003

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-003.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using Boolean values           :)
(:*******************************************************:)

   <return>
     { false() and true() }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-003.xml')

!

test_op_logical_and_004

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-004.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using Boolean values           :)
(:*******************************************************:)

   <return>
     { true() and true() }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-004.xml')

!

test_op_logical_and_005

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-005.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

   <return>
     { () and () }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-005.xml')

!

test_op_logical_and_006

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-006.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

   <return>
     { (1) and () }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-006.xml')

!

test_op_logical_and_007

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-007.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

   <return>
     { () and (1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-007.xml')

!

test_op_logical_and_008

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-008.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

   <return>
     { (1) and (1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-008.xml')

!

test_op_logical_and_009

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-009.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

   <return>
     { (0) and () }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-009.xml')

!

test_op_logical_and_010

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-010.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

   <return>
     { () and (0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-010.xml')

!

test_op_logical_and_011

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-011.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

   <return>
     { (0) and (0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-011.xml')

!

test_op_logical_and_012

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-012.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

   <return>
     { (1) and (0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-012.xml')

!

test_op_logical_and_013

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-013.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

   <return>
     { (0) and (1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-013.xml')

!

test_op_logical_and_014

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-014.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

   <return>
     { (0) and ($input-context/bib/book/price/text()) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-014.xml')

!

test_op_logical_and_015

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-015.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

   <return>
     { ($input-context/bib/book/price/text()) and (1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-015.xml')

!

test_op_logical_and_016

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-016.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using sequences                :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

   <return>
     { ($input-context/bib/book/price/text())
          and ($input-context/bib/book/price/text()) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-016.xml')

!

test_op_logical_and_017

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-017.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using string values            :)
(:*******************************************************:)

   <return>
     { "" and ""}
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-017.xml')

!

test_op_logical_and_018

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-018.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using string values            :)
(:*******************************************************:)

   <return>
     { "" and "a"}
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-018.xml')

!

test_op_logical_and_019

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-019.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using string values            :)
(:*******************************************************:)

   <return>
     { "0" and ""}
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-019.xml')

!

test_op_logical_and_020

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-020.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using string values            :)
(:*******************************************************:)

   <return>
     { "a" and "0"}
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-020.xml')

!

test_op_logical_and_021

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-021.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using string values            :)
(:*******************************************************:)

   <return>
     { xs:string("") and xs:string("") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-021.xml')

!

test_op_logical_and_022

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-022.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using string values            :)
(:*******************************************************:)

   <return>
     { xs:string("") and xs:string("abc") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-022.xml')

!

test_op_logical_and_023

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-023.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using string values            :)
(:*******************************************************:)

   <return>
     { xs:string("abc") and xs:string("") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-023.xml')

!

test_op_logical_and_024

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-024.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using string values            :)
(:*******************************************************:)

   <return>
     { xs:string("0") and xs:string("abc") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-024.xml')

!

test_op_logical_and_025

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-025.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using untypedAtomic values     :)
(:*******************************************************:)

   <return>
     { xs:untypedAtomic("") and xs:untypedAtomic("") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-025.xml')

!

test_op_logical_and_026

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-026.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using untypedAtomic values     :)
(:*******************************************************:)

   <return>
     { xs:untypedAtomic("abc") and xs:untypedAtomic("") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-026.xml')

!

test_op_logical_and_027

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-027.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using untypedAtomic values     :)
(:*******************************************************:)

   <return>
     { xs:untypedAtomic("") and xs:untypedAtomic("0") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-027.xml')

!

test_op_logical_and_028

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-028.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using untypedAtomic values     :)
(:*******************************************************:)

   <return>
     { xs:untypedAtomic("abc") and xs:untypedAtomic("0") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-028.xml')

!

test_op_logical_and_029

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-029.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using number values            :)
(:*******************************************************:)

   <return>
     { 0 and 0 }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-029.xml')

!

test_op_logical_and_030

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-030.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using number values            :)
(:*******************************************************:)

   <return>
     { 0 and 1 }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-030.xml')

!

test_op_logical_and_031

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-031.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using number values            :)
(:*******************************************************:)

   <return>
     { 1 and 0 }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-031.xml')

!

test_op_logical_and_032

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-032.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using number values            :)
(:*******************************************************:)

   <return>
     { 0 and -1 }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-032.xml')

!

test_op_logical_and_033

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-033.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using number values            :)
(:*******************************************************:)

   <return>
     { -1 and 1 }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-033.xml')

!

test_op_logical_and_034

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-034.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float(0) and xs:float(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-034.xml')

!

test_op_logical_and_035

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-035.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float(0) and xs:float(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-035.xml')

!

test_op_logical_and_036

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-036.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float(-1) and xs:float(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-036.xml')

!

test_op_logical_and_037

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-037.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float(1) and xs:float(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-037.xml')

!

test_op_logical_and_038

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-038.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("NaN") and xs:float(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-038.xml')

!

test_op_logical_and_039

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-039.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("NaN") and xs:float(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-039.xml')

!

test_op_logical_and_040

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-040.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("NaN") and xs:float("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-040.xml')

!

test_op_logical_and_041

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-041.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("INF") and xs:float(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-041.xml')

!

test_op_logical_and_042

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-042.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("INF") and xs:float(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-042.xml')

!

test_op_logical_and_043

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-043.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("INF") and xs:float("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-043.xml')

!

test_op_logical_and_044

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-044.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("-INF") and xs:float(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-044.xml')

!

test_op_logical_and_045

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-045.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("-INF") and xs:float(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-045.xml')

!

test_op_logical_and_046

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-046.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("-INF") and xs:float("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-046.xml')

!

test_op_logical_and_047

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-047.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("-INF") and xs:float("INF") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-047.xml')

!

test_op_logical_and_048

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-048.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double(0) and xs:double(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-048.xml')

!

test_op_logical_and_049

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-049.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double(0) and xs:double(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-049.xml')

!

test_op_logical_and_050

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-050.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double(-1) and xs:double(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-050.xml')

!

test_op_logical_and_051

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-051.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double(1) and xs:double(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-051.xml')

!

test_op_logical_and_052

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-052.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("NaN") and xs:double(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-052.xml')

!

test_op_logical_and_053

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-053.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("NaN") and xs:double(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-053.xml')

!

test_op_logical_and_054

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-054.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("NaN") and xs:double("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-054.xml')

!

test_op_logical_and_055

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-055.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("INF") and xs:double(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-055.xml')

!

test_op_logical_and_056

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-056.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("INF") and xs:double(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-056.xml')

!

test_op_logical_and_057

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-057.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("INF") and xs:double("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-057.xml')

!

test_op_logical_and_058

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-058.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("-INF") and xs:double(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-058.xml')

!

test_op_logical_and_059

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-059.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("-INF") and xs:double(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-059.xml')

!

test_op_logical_and_060

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-060.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("-INF") and xs:double("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-060.xml')

!

test_op_logical_and_061

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-061.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("-INF") and xs:double("INF") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-061.xml')

!

test_op_logical_and_062

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-062.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(0) and xs:decimal(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-062.xml')

!

test_op_logical_and_063

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-063.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(0) and xs:decimal(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-063.xml')

!

test_op_logical_and_064

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-064.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(-1) and xs:decimal(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-064.xml')

!

test_op_logical_and_065

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-065.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(1) and xs:decimal(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-065.xml')

!

test_op_logical_and_066

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-066.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(9.99999999999999999999999999) and xs:decimal(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-066.xml')

!

test_op_logical_and_067

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-067.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(-123456789.123456789123456789) and xs:decimal(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-067.xml')

!

test_op_logical_and_068

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-068.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(9.99999999999999999999999999)
         and xs:decimal(-123456789.123456789123456789) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-068.xml')

!

test_op_logical_and_069

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-069.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(0) and xs:integer(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-069.xml')

!

test_op_logical_and_070

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-070.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(0) and xs:integer(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-070.xml')

!

test_op_logical_and_071

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-071.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(-1) and xs:integer(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-071.xml')

!

test_op_logical_and_072

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-072.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(1) and xs:integer(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-072.xml')

!

test_op_logical_and_073

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-073.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(99999999999999999) and xs:integer(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-073.xml')

!

test_op_logical_and_074

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-074.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(-99999999999999999) and xs:integer(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-074.xml')

!

test_op_logical_and_075

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-075.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(99999999999999999)
         and xs:integer(-99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-075.xml')

!

test_op_logical_and_076

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-076.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(0) and xs:nonPositiveInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-076.xml')

!

test_op_logical_and_077

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-077.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(0) and xs:nonPositiveInteger(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-077.xml')

!

test_op_logical_and_078

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-078.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(-1) and xs:nonPositiveInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-078.xml')

!

test_op_logical_and_079

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-079.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(-1) and xs:nonPositiveInteger(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-079.xml')

!

test_op_logical_and_080

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-080.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(-99999999999999999)
         and xs:nonPositiveInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-080.xml')

!

test_op_logical_and_081

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-081.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(-1)
         and xs:nonPositiveInteger(-9999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-081.xml')

!

test_op_logical_and_082

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-082.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(-99999999999999999)
         and xs:nonPositiveInteger(-99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-082.xml')

!

test_op_logical_and_083

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-083.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(0) and xs:nonNegativeInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-083.xml')

!

test_op_logical_and_084

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-084.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(0) and xs:nonNegativeInteger(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-084.xml')

!

test_op_logical_and_085

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-085.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(1) and xs:nonNegativeInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-085.xml')

!

test_op_logical_and_086

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-086.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(1) and xs:nonNegativeInteger(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-086.xml')

!

test_op_logical_and_087

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-087.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(9999999999)
         and xs:nonNegativeInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-087.xml')

!

test_op_logical_and_088

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-088.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(1)
         and xs:nonNegativeInteger(99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-088.xml')

!

test_op_logical_and_089

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-089.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(99999999999999999)
         and xs:nonNegativeInteger(99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-089.xml')

!

test_op_logical_and_090

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-090.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using negativeInteger values   :)
(:*******************************************************:)

    <return>
     { xs:negativeInteger(-1) and xs:negativeInteger(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-090.xml')

!

test_op_logical_and_091

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-091.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using negativeInteger values   :)
(:*******************************************************:)

   <return>
     { xs:negativeInteger(-99999999999999999)
         and xs:negativeInteger(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-091.xml')

!

test_op_logical_and_092

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-092.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using negativeInteger values   :)
(:*******************************************************:)

   <return>
     { xs:negativeInteger(-99999999999999999)
         and xs:negativeInteger(-99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-092.xml')

!

test_op_logical_and_093

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-093.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using positiveInteger values   :)
(:*******************************************************:)

    <return>
     { xs:positiveInteger(1) and xs:positiveInteger(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-093.xml')

!

test_op_logical_and_094

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-094.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using positiveInteger values   :)
(:*******************************************************:)

   <return>
     { xs:positiveInteger(99999999999999999)
         and xs:positiveInteger(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-094.xml')

!

test_op_logical_and_095

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-095.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using positiveInteger values   :)
(:*******************************************************:)

   <return>
     { xs:positiveInteger(99999999999999999)
         and xs:positiveInteger(99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-095.xml')

!

test_op_logical_and_096

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-096.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(0) and xs:long(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-096.xml')

!

test_op_logical_and_097

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-097.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(0) and xs:long(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-097.xml')

!

test_op_logical_and_098

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-098.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(-1) and xs:long(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-098.xml')

!

test_op_logical_and_099

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-099.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(1) and xs:long(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-099.xml')

!

test_op_logical_and_100

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-100.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(9223372036854775807) and xs:long(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-100.xml')

!

test_op_logical_and_101

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-101.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(9223372036854775807) and xs:long(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-101.xml')

!

test_op_logical_and_102

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-102.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(-99999999999999999) and xs:long(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-102.xml')

!

test_op_logical_and_103

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-103.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(-99999999999999999) and xs:long(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-103.xml')

!

test_op_logical_and_104

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-104.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(99999999999999999) and xs:long(-99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-104.xml')

!

test_op_logical_and_105

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-105.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedLong values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(0) and xs:unsignedLong(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-105.xml')

!

test_op_logical_and_106

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-106.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedLong values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(0) and xs:unsignedLong(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-106.xml')

!

test_op_logical_and_107

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-107.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedLong values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(1) and xs:unsignedLong(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-107.xml')

!

test_op_logical_and_108

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-108.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedLong values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(1) and xs:unsignedLong(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-108.xml')

!

test_op_logical_and_109

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-109.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedLong values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(9223372036854775807) and xs:unsignedLong(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-109.xml')

!

test_op_logical_and_110

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-110.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedLong values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(9223372036854775807) and xs:unsignedLong(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-110.xml')

!

test_op_logical_and_111

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-111.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedLong values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(99999999999999999) and
          xs:unsignedLong(99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-111.xml')

!

test_op_logical_and_112

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-112.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using int values               :)
(:*******************************************************:)

   <return>
     { xs:int(0) and xs:int(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-112.xml')

!

test_op_logical_and_113

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-113.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using int values               :)
(:*******************************************************:)

   <return>
     { xs:int(0) and xs:int(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-113.xml')

!

test_op_logical_and_114

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-114.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using int values               :)
(:*******************************************************:)

   <return>
     { xs:int(-1) and xs:int(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-114.xml')

!

test_op_logical_and_115

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-115.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using int values               :)
(:*******************************************************:)

   <return>
     { xs:int(1) and xs:int(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-115.xml')

!

test_op_logical_and_116

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-116.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using int values               :)
(:*******************************************************:)

   <return>
     { xs:int(2147483647) and xs:int(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-116.xml')

!

test_op_logical_and_117

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-117.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using int values               :)
(:*******************************************************:)

   <return>
     { xs:int(2147483647) and xs:int(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-117.xml')

!

test_op_logical_and_118

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-118.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using int values               :)
(:*******************************************************:)

   <return>
     { xs:int(-2147483648) and xs:int(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-118.xml')

!

test_op_logical_and_119

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-119.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using int values               :)
(:*******************************************************:)

   <return>
     { xs:int(-2147483648) and xs:int(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-119.xml')

!

test_op_logical_and_120

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-120.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using int values               :)
(:*******************************************************:)

   <return>
     { xs:int(2147483647) and xs:int(-2147483648) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-120.xml')

!

test_op_logical_and_121

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-121.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedInt values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(0) and xs:unsignedInt(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-121.xml')

!

test_op_logical_and_122

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-122.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedInt values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(0) and xs:unsignedInt(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-122.xml')

!

test_op_logical_and_123

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-123.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedInt values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(1) and xs:unsignedInt(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-123.xml')

!

test_op_logical_and_124

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-124.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedInt values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(1) and xs:unsignedInt(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-124.xml')

!

test_op_logical_and_125

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-125.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedInt values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(4294967295) and xs:unsignedInt(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-125.xml')

!

test_op_logical_and_126

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-126.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedInt values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(4294967295) and xs:unsignedInt(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-126.xml')

!

test_op_logical_and_127

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-127.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedInt values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(4294967295) and xs:unsignedInt(4294967295) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-127.xml')

!

test_op_logical_and_128

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-128.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using short values             :)
(:*******************************************************:)

   <return>
     { xs:short(0) and xs:short(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-128.xml')

!

test_op_logical_and_129

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-129.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using short values             :)
(:*******************************************************:)

   <return>
     { xs:short(0) and xs:short(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-129.xml')

!

test_op_logical_and_130

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-130.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using short values             :)
(:*******************************************************:)

   <return>
     { xs:short(-1) and xs:short(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-130.xml')

!

test_op_logical_and_131

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-131.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using short values             :)
(:*******************************************************:)

   <return>
     { xs:short(1) and xs:short(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-131.xml')

!

test_op_logical_and_132

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-132.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using short values             :)
(:*******************************************************:)

   <return>
     { xs:short(32767) and xs:short(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-132.xml')

!

test_op_logical_and_133

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-133.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using short values             :)
(:*******************************************************:)

   <return>
     { xs:short(32767) and xs:short(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-133.xml')

!

test_op_logical_and_134

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-134.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using short values             :)
(:*******************************************************:)

   <return>
     { xs:short(-32768) and xs:short(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-134.xml')

!

test_op_logical_and_135

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-135.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using short values             :)
(:*******************************************************:)

   <return>
     { xs:short(-32768) and xs:short(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-135.xml')

!

test_op_logical_and_136

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-136.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using short values             :)
(:*******************************************************:)

   <return>
     { xs:short(32767) and xs:short(-32768) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-136.xml')

!

test_op_logical_and_137

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-137.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedShort values     :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(0) and xs:unsignedShort(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-137.xml')

!

test_op_logical_and_138

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-138.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedShort values     :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(0) and xs:unsignedShort(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-138.xml')

!

test_op_logical_and_139

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-139.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedShort values     :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(1) and xs:unsignedShort(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-139.xml')

!

test_op_logical_and_140

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-140.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedShort values     :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(1) and xs:unsignedShort(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-140.xml')

!

test_op_logical_and_141

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-141.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedShort values     :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(65535) and xs:unsignedShort(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-141.xml')

!

test_op_logical_and_142

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-142.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedShort values     :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(65535) and xs:unsignedShort(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-142.xml')

!

test_op_logical_and_143

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-143.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedShort values     :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(65535) and xs:unsignedShort(65535) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-143.xml')

!

test_op_logical_and_144

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-144.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using byte values              :)
(:*******************************************************:)

   <return>
     { xs:byte(0) and xs:byte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-144.xml')

!

test_op_logical_and_145

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-145.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using byte values              :)
(:*******************************************************:)

   <return>
     { xs:byte(0) and xs:byte(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-145.xml')

!

test_op_logical_and_146

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-146.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using byte values              :)
(:*******************************************************:)

   <return>
     { xs:byte(-1) and xs:byte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-146.xml')

!

test_op_logical_and_147

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-147.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using byte values              :)
(:*******************************************************:)

   <return>
     { xs:byte(1) and xs:byte(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-147.xml')

!

test_op_logical_and_148

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-148.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using byte values              :)
(:*******************************************************:)

   <return>
     { xs:byte(127) and xs:byte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-148.xml')

!

test_op_logical_and_149

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-149.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using byte values              :)
(:*******************************************************:)

   <return>
     { xs:byte(127) and xs:byte(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-149.xml')

!

test_op_logical_and_150

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-150.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using byte values              :)
(:*******************************************************:)

   <return>
     { xs:byte(-128) and xs:byte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-150.xml')

!

test_op_logical_and_151

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-151.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using byte values              :)
(:*******************************************************:)

   <return>
     { xs:byte(-128) and xs:byte(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-151.xml')

!

test_op_logical_and_152

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-152.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using byte values              :)
(:*******************************************************:)

   <return>
     { xs:byte(127) and xs:byte(-128) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-152.xml')

!

test_op_logical_and_153

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-153.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedByte values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(0) and xs:unsignedByte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-153.xml')

!

test_op_logical_and_154

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-154.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedByte values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(0) and xs:unsignedByte(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-154.xml')

!

test_op_logical_and_155

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-155.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedByte values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(1) and xs:unsignedByte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-155.xml')

!

test_op_logical_and_156

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-156.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedByte values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(1) and xs:unsignedByte(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-156.xml')

!

test_op_logical_and_157

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-157.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedByte values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(255) and xs:unsignedByte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-157.xml')

!

test_op_logical_and_158

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-158.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedByte values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(255) and xs:unsignedByte(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-158.xml')

!

test_op_logical_and_159

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-and-159.xq                           :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:50:40 2005                        :)
(: Purpose: Logical "and" using unsignedByte values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(255) and xs:unsignedByte(255) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-and-159.xml')

!

test_op_logical_or_001

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-001.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using boolean values           :)
(:*******************************************************:)

   <return>
     { false() or false() }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-001.xml')

!

test_op_logical_or_002

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-002.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using boolean values           :)
(:*******************************************************:)

   <return>
     { true() or false() }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-002.xml')

!

test_op_logical_or_003

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-003.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using boolean values           :)
(:*******************************************************:)

   <return>
     { false() or true() }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-003.xml')

!

test_op_logical_or_004

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-004.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using boolean values           :)
(:*******************************************************:)

   <return>
     { true() or true() }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-004.xml')

!

test_op_logical_or_005

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-005.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

   <return>
     { () or () }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-005.xml')

!

test_op_logical_or_006

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-006.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

   <return>
     { (1) or () }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-006.xml')

!

test_op_logical_or_007

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-007.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

   <return>
     { () or (1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-007.xml')

!

test_op_logical_or_008

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-008.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

   <return>
     { (1) or (1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-008.xml')

!

test_op_logical_or_009

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-009.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

   <return>
     { (0) or () }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-009.xml')

!

test_op_logical_or_010

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-010.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

   <return>
     { () or (0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-010.xml')

!

test_op_logical_or_011

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-011.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

   <return>
     { (0) or (0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-011.xml')

!

test_op_logical_or_012

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-012.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

   <return>
     { (1) or (0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-012.xml')

!

test_op_logical_or_013

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-013.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

   <return>
     { (0) or (1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-013.xml')

!

test_op_logical_or_014

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-014.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

   <return>
     { (0) or ($input-context/bib/book/price/text()) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-014.xml')

!

test_op_logical_or_015

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-015.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

   <return>
     { ($input-context/bib/book/price/text()) or (1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-015.xml')

!

test_op_logical_or_016

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-016.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using sequences values         :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

   <return>
     { ($input-context/bib/book/price/text())
          or ($input-context/bib/book/price/text()) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-016.xml')

!

test_op_logical_or_017

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-017.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using string values            :)
(:*******************************************************:)

   <return>
     { "" or ""}
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-017.xml')

!

test_op_logical_or_018

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-018.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using string values            :)
(:*******************************************************:)

   <return>
     { "" or "a"}
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-018.xml')

!

test_op_logical_or_019

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-019.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using string values            :)
(:*******************************************************:)

   <return>
     { "0" or ""}
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-019.xml')

!

test_op_logical_or_020

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-020.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using string values            :)
(:*******************************************************:)

   <return>
     { "a" or "0"}
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-020.xml')

!

test_op_logical_or_021

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-021.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using string values            :)
(:*******************************************************:)

   <return>
     { xs:string("") or xs:string("") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-021.xml')

!

test_op_logical_or_022

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-022.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using string values            :)
(:*******************************************************:)

   <return>
     { xs:string("") or xs:string("abc") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-022.xml')

!

test_op_logical_or_023

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-023.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using string values            :)
(:*******************************************************:)

   <return>
     { xs:string("abc") or xs:string("") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-023.xml')

!

test_op_logical_or_024

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-024.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using string values            :)
(:*******************************************************:)

   <return>
     { xs:string("0") or xs:string("abc") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-024.xml')

!

test_op_logical_or_025

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-025.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using untypedAtomic values     :)
(:*******************************************************:)

   <return>
     { xs:untypedAtomic("") or xs:untypedAtomic("") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-025.xml')

!

test_op_logical_or_026

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-026.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using untypedAtomic values     :)
(:*******************************************************:)

   <return>
     { xs:untypedAtomic("abc") or xs:untypedAtomic("") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-026.xml')

!

test_op_logical_or_027

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-027.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using untypedAtomic values     :)
(:*******************************************************:)

   <return>
     { xs:untypedAtomic("") or xs:untypedAtomic("0") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-027.xml')

!

test_op_logical_or_028

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-028.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using untypedAtomic values     :)
(:*******************************************************:)

   <return>
     { xs:untypedAtomic("abc") or xs:untypedAtomic("0") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-028.xml')

!

test_op_logical_or_029

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-029.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using number values            :)
(:*******************************************************:)

   <return>
     { 0 or 0 }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-029.xml')

!

test_op_logical_or_030

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-030.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using number values            :)
(:*******************************************************:)

   <return>
     { 0 or 1 }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-030.xml')

!

test_op_logical_or_031

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-031.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using number values            :)
(:*******************************************************:)

   <return>
     { 1 or 0 }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-031.xml')

!

test_op_logical_or_032

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-032.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using number values            :)
(:*******************************************************:)

   <return>
     { 0 or -1 }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-032.xml')

!

test_op_logical_or_033

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-033.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using number values            :)
(:*******************************************************:)

   <return>
     { -1 or 1 }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-033.xml')

!

test_op_logical_or_034

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-034.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float(0) or xs:float(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-034.xml')

!

test_op_logical_or_035

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-035.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float(0) or xs:float(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-035.xml')

!

test_op_logical_or_036

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-036.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float(-1) or xs:float(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-036.xml')

!

test_op_logical_or_037

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-037.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float(1) or xs:float(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-037.xml')

!

test_op_logical_or_038

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-038.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("NaN") or xs:float(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-038.xml')

!

test_op_logical_or_039

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-039.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("NaN") or xs:float(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-039.xml')

!

test_op_logical_or_040

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-040.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("NaN") or xs:float("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-040.xml')

!

test_op_logical_or_041

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-041.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("INF") or xs:float(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-041.xml')

!

test_op_logical_or_042

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-042.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("INF") or xs:float(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-042.xml')

!

test_op_logical_or_043

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-043.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("INF") or xs:float("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-043.xml')

!

test_op_logical_or_044

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-044.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("-INF") or xs:float(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-044.xml')

!

test_op_logical_or_045

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-045.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("-INF") or xs:float(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-045.xml')

!

test_op_logical_or_046

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-046.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("-INF") or xs:float("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-046.xml')

!

test_op_logical_or_047

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-047.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using float values             :)
(:*******************************************************:)

   <return>
     { xs:float("-INF") or xs:float("INF") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-047.xml')

!

test_op_logical_or_048

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-048.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double(0) or xs:double(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-048.xml')

!

test_op_logical_or_049

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-049.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double(0) or xs:double(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-049.xml')

!

test_op_logical_or_050

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-050.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double(-1) or xs:double(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-050.xml')

!

test_op_logical_or_051

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-051.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double(1) or xs:double(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-051.xml')

!

test_op_logical_or_052

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-052.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("NaN") or xs:double(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-052.xml')

!

test_op_logical_or_053

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-053.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("NaN") or xs:double(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-053.xml')

!

test_op_logical_or_054

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-054.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("NaN") or xs:double("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-054.xml')

!

test_op_logical_or_055

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-055.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("INF") or xs:double(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-055.xml')

!

test_op_logical_or_056

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-056.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("INF") or xs:double(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-056.xml')

!

test_op_logical_or_057

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-057.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("INF") or xs:double("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-057.xml')

!

test_op_logical_or_058

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-058.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("-INF") or xs:double(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-058.xml')

!

test_op_logical_or_059

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-059.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("-INF") or xs:double(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-059.xml')

!

test_op_logical_or_060

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-060.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("-INF") or xs:double("NaN") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-060.xml')

!

test_op_logical_or_061

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-061.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using double values            :)
(:*******************************************************:)

   <return>
     { xs:double("-INF") or xs:double("INF") }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-061.xml')

!

test_op_logical_or_062

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-062.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(0) or xs:decimal(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-062.xml')

!

test_op_logical_or_063

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-063.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(0) or xs:decimal(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-063.xml')

!

test_op_logical_or_064

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-064.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(-1) or xs:decimal(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-064.xml')

!

test_op_logical_or_065

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-065.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(1) or xs:decimal(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-065.xml')

!

test_op_logical_or_066

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-066.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(9.99999999999999999999999999) or xs:decimal(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-066.xml')

!

test_op_logical_or_067

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-067.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(-123456789.123456789123456789) or xs:decimal(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-067.xml')

!

test_op_logical_or_068

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-068.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using decimal values           :)
(:*******************************************************:)

   <return>
     { xs:decimal(9.99999999999999999999999999)
         or xs:decimal(-123456789.123456789123456789) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-068.xml')

!

test_op_logical_or_069

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-069.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(0) or xs:integer(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-069.xml')

!

test_op_logical_or_070

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-070.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(0) or xs:integer(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-070.xml')

!

test_op_logical_or_071

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-071.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(-1) or xs:integer(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-071.xml')

!

test_op_logical_or_072

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-072.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(1) or xs:integer(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-072.xml')

!

test_op_logical_or_073

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-073.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(99999999999999999) or xs:integer(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-073.xml')

!

test_op_logical_or_074

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-074.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(-99999999999999999) or xs:integer(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-074.xml')

!

test_op_logical_or_075

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-075.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using integer values           :)
(:*******************************************************:)

   <return>
     { xs:integer(99999999999999999)
         or xs:integer(-99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-075.xml')

!

test_op_logical_or_076

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-076.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(0) or xs:nonPositiveInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-076.xml')

!

test_op_logical_or_077

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-077.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(0) or xs:nonPositiveInteger(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-077.xml')

!

test_op_logical_or_078

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-078.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(-1) or xs:nonPositiveInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-078.xml')

!

test_op_logical_or_079

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-079.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(-1) or xs:nonPositiveInteger(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-079.xml')

!

test_op_logical_or_080

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-080.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(-99999999999999999)
         or xs:nonPositiveInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-080.xml')

!

test_op_logical_or_081

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-081.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(-1)
         or xs:nonPositiveInteger(-99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-081.xml')

!

test_op_logical_or_082

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-082.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonPositiveInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonPositiveInteger(-99999999999999999)
         or xs:nonPositiveInteger(-99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-082.xml')

!

test_op_logical_or_083

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-083.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(0) or xs:nonNegativeInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-083.xml')

!

test_op_logical_or_084

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-084.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(0) or xs:nonNegativeInteger(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-084.xml')

!

test_op_logical_or_085

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-085.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(1) or xs:nonNegativeInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-085.xml')

!

test_op_logical_or_086

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-086.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(1) or xs:nonNegativeInteger(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-086.xml')

!

test_op_logical_or_087

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-087.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(99999999999999999)
         or xs:nonNegativeInteger(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-087.xml')

!

test_op_logical_or_088

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-088.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(1)
         or xs:nonNegativeInteger(99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-088.xml')

!

test_op_logical_or_089

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-089.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using nonNegativeInteger values:)
(:*******************************************************:)

   <return>
     { xs:nonNegativeInteger(99999999999999999)
         or xs:nonNegativeInteger(99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-089.xml')

!

test_op_logical_or_090

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-090.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using negativeInteger values   :)
(:*******************************************************:)

    <return>
     { xs:negativeInteger(-1) or xs:negativeInteger(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-090.xml')

!

test_op_logical_or_091

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-091.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using negativeInteger values   :)
(:*******************************************************:)

   <return>
     { xs:negativeInteger(-99999999999999999)
         or xs:negativeInteger(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-091.xml')

!

test_op_logical_or_092

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-092.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using negativeInteger values   :)
(:*******************************************************:)

   <return>
     { xs:negativeInteger(-99999999999999999)
         or xs:negativeInteger(-99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-092.xml')

!

test_op_logical_or_093

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-093.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using positiveInteger values   :)
(:*******************************************************:)

    <return>
     { xs:positiveInteger(1) or xs:positiveInteger(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-093.xml')

!

test_op_logical_or_094

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-094.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using positiveInteger values   :)
(:*******************************************************:)

   <return>
     { xs:positiveInteger(99999999999999999)
         or xs:positiveInteger(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-094.xml')

!

test_op_logical_or_095

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-095.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using positiveInteger values   :)
(:*******************************************************:)

   <return>
     { xs:positiveInteger(99999999999999999)
         or xs:positiveInteger(99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-095.xml')

!

test_op_logical_or_096

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-096.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(0) or xs:long(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-096.xml')

!

test_op_logical_or_097

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-097.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(0) or xs:long(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-097.xml')

!

test_op_logical_or_098

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-098.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(-1) or xs:long(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-098.xml')

!

test_op_logical_or_099

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-099.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(1) or xs:long(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-099.xml')

!

test_op_logical_or_100

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-100.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(9223372036854775807) or xs:long(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-100.xml')

!

test_op_logical_or_101

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-101.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(9223372036854775807) or xs:long(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-101.xml')

!

test_op_logical_or_102

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-102.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(-99999999999999999) or xs:long(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-102.xml')

!

test_op_logical_or_103

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-103.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(-99999999999999999) or xs:long(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-103.xml')

!

test_op_logical_or_104

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-104.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or"  using long values              :)
(:*******************************************************:)

   <return>
     { xs:long(99999999999999999) or xs:long(-99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-104.xml')

!

test_op_logical_or_105

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-105.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedLong values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(0) or xs:unsignedLong(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-105.xml')

!

test_op_logical_or_106

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-106.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedLong values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(0) or xs:unsignedLong(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-106.xml')

!

test_op_logical_or_107

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-107.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedLong values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(1) or xs:unsignedLong(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-107.xml')

!

test_op_logical_or_108

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-108.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedLong values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(1) or xs:unsignedLong(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-108.xml')

!

test_op_logical_or_109

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-109.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedLong values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(9223372036854775807) or xs:unsignedLong(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-109.xml')

!

test_op_logical_or_110

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-110.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedLong values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(9223372036854775807) or xs:unsignedLong(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-110.xml')

!

test_op_logical_or_111

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-111.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedLong values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedLong(99999999999999999) or
          xs:unsignedLong(99999999999999999) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-111.xml')

!

test_op_logical_or_112

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-112.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using int values                :)
(:*******************************************************:)

   <return>
     { xs:int(0) or xs:int(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-112.xml')

!

test_op_logical_or_113

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-113.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using int values                :)
(:*******************************************************:)

   <return>
     { xs:int(0) or xs:int(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-113.xml')

!

test_op_logical_or_114

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-114.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using int values                :)
(:*******************************************************:)

   <return>
     { xs:int(-1) or xs:int(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-114.xml')

!

test_op_logical_or_115

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-115.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using int values                :)
(:*******************************************************:)

   <return>
     { xs:int(1) or xs:int(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-115.xml')

!

test_op_logical_or_116

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-116.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using int values                :)
(:*******************************************************:)

   <return>
     { xs:int(2147483647) or xs:int(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-116.xml')

!

test_op_logical_or_117

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-117.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using int values                :)
(:*******************************************************:)

   <return>
     { xs:int(2147483647) or xs:int(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-117.xml')

!

test_op_logical_or_118

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-118.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using int values                :)
(:*******************************************************:)

   <return>
     { xs:int(-2147483648) or xs:int(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-118.xml')

!

test_op_logical_or_119

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-119.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using int values                :)
(:*******************************************************:)

   <return>
     { xs:int(-2147483648) or xs:int(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-119.xml')

!

test_op_logical_or_120

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-120.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using int values                :)
(:*******************************************************:)

   <return>
     { xs:int(2147483647) or xs:int(-2147483648) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-120.xml')

!

test_op_logical_or_121

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-121.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedInt values        :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(0) or xs:unsignedInt(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-121.xml')

!

test_op_logical_or_122

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-122.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedInt values        :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(0) or xs:unsignedInt(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-122.xml')

!

test_op_logical_or_123

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-123.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedInt values        :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(1) or xs:unsignedInt(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-123.xml')

!

test_op_logical_or_124

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-124.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedInt values        :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(1) or xs:unsignedInt(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-124.xml')

!

test_op_logical_or_125

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-125.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedInt values        :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(4294967295) or xs:unsignedInt(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-125.xml')

!

test_op_logical_or_126

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-126.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedInt values        :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(4294967295) or xs:unsignedInt(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-126.xml')

!

test_op_logical_or_127

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-127.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedInt values        :)
(:*******************************************************:)

   <return>
     { xs:unsignedInt(4294967295) or xs:unsignedInt(4294967295) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-127.xml')

!

test_op_logical_or_128

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-128.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using short values              :)
(:*******************************************************:)

   <return>
     { xs:short(0) or xs:short(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-128.xml')

!

test_op_logical_or_129

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-129.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using short values              :)
(:*******************************************************:)

   <return>
     { xs:short(0) or xs:short(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-129.xml')

!

test_op_logical_or_130

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-130.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using short values              :)
(:*******************************************************:)

   <return>
     { xs:short(-1) or xs:short(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-130.xml')

!

test_op_logical_or_131

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-131.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using short values              :)
(:*******************************************************:)

   <return>
     { xs:short(1) or xs:short(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-131.xml')

!

test_op_logical_or_132

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-132.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using short values              :)
(:*******************************************************:)

   <return>
     { xs:short(32767) or xs:short(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-132.xml')

!

test_op_logical_or_133

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-133.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using short values              :)
(:*******************************************************:)

   <return>
     { xs:short(32767) or xs:short(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-133.xml')

!

test_op_logical_or_134

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-134.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using short values              :)
(:*******************************************************:)

   <return>
     { xs:short(-32768) or xs:short(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-134.xml')

!

test_op_logical_or_135

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-135.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using short values              :)
(:*******************************************************:)

   <return>
     { xs:short(-32768) or xs:short(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-135.xml')

!

test_op_logical_or_136

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-136.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using short values              :)
(:*******************************************************:)

   <return>
     { xs:short(32767) or xs:short(-32768) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-136.xml')

!

test_op_logical_or_137

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-137.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedShort values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(0) or xs:unsignedShort(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-137.xml')

!

test_op_logical_or_138

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-138.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedShort values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(0) or xs:unsignedShort(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-138.xml')

!

test_op_logical_or_139

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-139.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedShort values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(1) or xs:unsignedShort(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-139.xml')

!

test_op_logical_or_140

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-140.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedShort values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(1) or xs:unsignedShort(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-140.xml')

!

test_op_logical_or_141

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-141.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedShort values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(65535) or xs:unsignedShort(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-141.xml')

!

test_op_logical_or_142

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-142.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedShort values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(65535) or xs:unsignedShort(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-142.xml')

!

test_op_logical_or_143

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-143.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedShort values      :)
(:*******************************************************:)

   <return>
     { xs:unsignedShort(65535) or xs:unsignedShort(65535) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-143.xml')

!

test_op_logical_or_144

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-144.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using byte values               :)
(:*******************************************************:)

   <return>
     { xs:byte(0) or xs:byte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-144.xml')

!

test_op_logical_or_145

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-145.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using byte values               :)
(:*******************************************************:)

   <return>
     { xs:byte(0) or xs:byte(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-145.xml')

!

test_op_logical_or_146

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-146.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using byte values               :)
(:*******************************************************:)

   <return>
     { xs:byte(-1) or xs:byte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-146.xml')

!

test_op_logical_or_147

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-147.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using byte values               :)
(:*******************************************************:)

   <return>
     { xs:byte(1) or xs:byte(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-147.xml')

!

test_op_logical_or_148

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-148.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using byte values               :)
(:*******************************************************:)

   <return>
     { xs:byte(127) or xs:byte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-148.xml')

!

test_op_logical_or_149

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-149.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using byte values               :)
(:*******************************************************:)

   <return>
     { xs:byte(127) or xs:byte(-1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-149.xml')

!

test_op_logical_or_150

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-150.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using byte values               :)
(:*******************************************************:)

   <return>
     { xs:byte(-128) or xs:byte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-150.xml')

!

test_op_logical_or_151

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-151.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using byte values               :)
(:*******************************************************:)

   <return>
     { xs:byte(-128) or xs:byte(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-151.xml')

!

test_op_logical_or_152

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-152.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using byte values               :)
(:*******************************************************:)

   <return>
     { xs:byte(127) or xs:byte(-128) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-152.xml')

!

test_op_logical_or_153

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-153.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedByte values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(0) or xs:unsignedByte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-153.xml')

!

test_op_logical_or_154

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-154.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedByte values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(0) or xs:unsignedByte(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-154.xml')

!

test_op_logical_or_155

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-155.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedByte values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(1) or xs:unsignedByte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-155.xml')

!

test_op_logical_or_156

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-156.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedByte values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(1) or xs:unsignedByte(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-156.xml')

!

test_op_logical_or_157

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-157.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedByte values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(255) or xs:unsignedByte(0) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-157.xml')

!

test_op_logical_or_158

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-158.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedByte values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(255) or xs:unsignedByte(1) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-158.xml')

!

test_op_logical_or_159

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-logical-or-159.xq                            :)
(: Written By: Lalith Kumar                              :)
(: Date: Thu May 12 05:53:51 2005                        :)
(: Purpose: Logical "or" using unsignedByte values       :)
(:*******************************************************:)

   <return>
     { xs:unsignedByte(255) or xs:unsignedByte(255) }
   </return>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/LogicExpr/op-logical-or-159.xml')

! !

!XQTSLogicExprTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
