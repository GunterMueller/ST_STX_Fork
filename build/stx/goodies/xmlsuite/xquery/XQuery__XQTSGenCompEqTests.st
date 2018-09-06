"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSGenCompEqTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSGenCompEqTests methodsFor:'tests'!

test_K_GenCompEq_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-1                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparisons involving the empty sequence. :)
(:*******************************************************:)
not(() = ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-1.txt')

!

test_K_GenCompEq_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-10                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Example from the XPath 2.0 specification.    :)
(:*******************************************************:)
not((xs:untypedAtomic("1"), xs:untypedAtomic("2")) =
				   (xs:untypedAtomic("2.0"), 3.0))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-10.txt')

!

test_K_GenCompEq_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-11                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing numeric promotion from xs:untypedAtomic. :)
(:*******************************************************:)
xs:untypedAtomic("1") = 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-11.txt')

!

test_K_GenCompEq_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-12                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing numeric promotion from xs:untypedAtomic. :)
(:*******************************************************:)
not(xs:untypedAtomic("2") = 1)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-12.txt')

!

test_K_GenCompEq_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-13                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing numeric promotion from xs:untypedAtomic. :)
(:*******************************************************:)
xs:untypedAtomic("1") = 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-13.txt')

!

test_K_GenCompEq_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-14                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing numeric promotion from xs:untypedAtomic. :)
(:*******************************************************:)
1 = xs:untypedAtomic("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-14.txt')

!

test_K_GenCompEq_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-15                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing numeric promotion from xs:untypedAtomic. :)
(:*******************************************************:)
1 = xs:untypedAtomic("1")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-15.txt')

!

test_K_GenCompEq_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-16                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A general comparison involving the error() function. :)
(:*******************************************************:)
error() = 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-17                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A general comparison involving the error() function. :)
(:*******************************************************:)
(error(), 3) = 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-18                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A general comparison involving the error() function. :)
(:*******************************************************:)
3 = error()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-19                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A general comparison involving the error() function. :)
(:*******************************************************:)
3 = (error(), 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-2                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparisons involving the empty sequence. :)
(:*******************************************************:)
not((() = ()))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-2.txt')

!

test_K_GenCompEq_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-20                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An expression involving the "=" operator that trigger certain optimization paths in some implementations. :)
(:*******************************************************:)
count(remove(remove((current-time(), 1), 1), 1)) = 0
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-20.txt')

!

test_K_GenCompEq_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-21                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Test that fn:count combined with expressions that might disable compile time evaluations(optimization) as well as the "=" operator, is conformant. :)
(:*******************************************************:)
not(0 = count((1, 2, timezone-from-time(current-time()))))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-21.txt')

!

test_K_GenCompEq_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-23                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Comparison where type of operands are incompatible. :)
(:*******************************************************:)

		(xs:anyURI("example.com/"), 1, QName("example.com", "ncname"), false(), xs:hexBinary("FF"))
		=
		(xs:anyURI("example.com/NOT"), 0, QName("example.com", "p:ncname"), true(), xs:hexBinary("EF"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-24                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison involving xs:untypedAtomic/xs:string. :)
(:*******************************************************:)
"a string" = "a string"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-24.txt')

!

test_K_GenCompEq_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-25                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison involving xs:untypedAtomic/xs:string. :)
(:*******************************************************:)
xs:untypedAtomic("a string") = "a string"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-25.txt')

!

test_K_GenCompEq_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-26                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison involving xs:untypedAtomic/xs:string. :)
(:*******************************************************:)
"a string" = xs:untypedAtomic("a string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-26.txt')

!

test_K_GenCompEq_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-27                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison involving xs:untypedAtomic/xs:string. :)
(:*******************************************************:)
not(xs:untypedAtomic("a string") = "a stringDIFF")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-27.txt')

!

test_K_GenCompEq_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-28                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison involving xs:untypedAtomic/xs:string. :)
(:*******************************************************:)
not("a string" = xs:untypedAtomic("a stringDIFF"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-28.txt')

!

test_K_GenCompEq_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-29                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison involving xs:untypedAtomic/xs:string. :)
(:*******************************************************:)
not("a string" = "a stringDIFF")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-29.txt')

!

test_K_GenCompEq_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-3                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparisons involving the empty sequence. :)
(:*******************************************************:)
not((() = 1))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-3.txt')

!

test_K_GenCompEq_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-30                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison with remove() as operand, resulting in incompatible operand types. :)
(:*******************************************************:)
remove((6, "a string"), 1) = 6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-31                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison with remove() as operand, resulting in incompatible operand types. :)
(:*******************************************************:)
6 = remove(("a string", 6), 2)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-32                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison involving remove(), resulting in operands that require conversion to numeric from xs:untypedAtomic. :)
(:*******************************************************:)
remove((6, "a string"), 2) = xs:untypedAtomic("6")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-32.txt')

!

test_K_GenCompEq_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-33                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison involving remove(), resulting in operands that require conversion to numeric from xs:untypedAtomic. :)
(:*******************************************************:)
xs:untypedAtomic("6") = remove(("a string", 6), 1)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-33.txt')

!

test_K_GenCompEq_34

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-34                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison involving remove(), resulting in operands that require conversion to numeric from xs:untypedAtomic. Implementations supporting the static typing feature may raise XPTY0004. :)
(:*******************************************************:)
(remove((xs:untypedAtomic("6"), "a string"), 2)) = 6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-34.txt')

!

test_K_GenCompEq_35

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-35                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison involving remove(), resulting in operands that require conversion to numeric from xs:untypedAtomic. Implementations supporting the static typing feature may raise XPTY0004. :)
(:*******************************************************:)
6 = (remove(("a string", xs:untypedAtomic("6")), 1))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-35.txt')

!

test_K_GenCompEq_36

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-36                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
1 = 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-36.txt')

!

test_K_GenCompEq_37

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-37                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
(1, 2, 3) = 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-37.txt')

!

test_K_GenCompEq_38

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-38                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
(1, 2, 3) = 2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-38.txt')

!

test_K_GenCompEq_39

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-39                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
(1, 2, 3) = 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-39.txt')

!

test_K_GenCompEq_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-4                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparisons involving the empty sequence. :)
(:*******************************************************:)
not(1 = ())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-4.txt')

!

test_K_GenCompEq_40

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-40                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
2 = (1, 2, 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-40.txt')

!

test_K_GenCompEq_41

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-41                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
1 = (1, 2, 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-41.txt')

!

test_K_GenCompEq_42

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-42                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where the operands are various various sequence of xs:integers. :)
(:*******************************************************:)
3 = (1, 2, 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-42.txt')

!

test_K_GenCompEq_43

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-43                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
xs:untypedAtomic("false") = false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-43.txt')

!

test_K_GenCompEq_44

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-44                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
false() = xs:untypedAtomic("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-44.txt')

!

test_K_GenCompEq_45

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-45                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
not(xs:untypedAtomic("true") = false())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-45.txt')

!

test_K_GenCompEq_46

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-46                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing a xs:untypedAtomic value to be cast to xs:boolean, and then compared. :)
(:*******************************************************:)
(true() = xs:untypedAtomic("true"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-46.txt')

!

test_K_GenCompEq_47

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-47                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
"1" = 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_48

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-48                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
1 = "1"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_49

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-49                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
false() = 5
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-5                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A syntactically invalid expression that reminds of a general comparison operator. :)
(:*******************************************************:)
1 == 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_50

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-50                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
5 = false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_51

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-51                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
xs:untypedAtomic("three") = 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_52

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-52                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
xs:string("false") = false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_53

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-53                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
false() = xs:string("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_54

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-54                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
xs:untypedAtomic("falseERR") = false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_55

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-55                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)

		(xs:untypedAtomic("1"), xs:anyURI("example.com")) =
		(xs:untypedAtomic("2.0"), 3.0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_56

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-56                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
false() = xs:untypedAtomic("falseERR")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_57

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-57                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
3 = xs:untypedAtomic("three")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_58

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-58                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
xs:anyURI("example.com/") = false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_59

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-59                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison which fails due to invalid operator combination or casting. :)
(:*******************************************************:)
false() = xs:anyURI("example.com/")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_GenCompEq_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-6                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Example from the XPath 2.0 specification.    :)
(:*******************************************************:)
(1, 2) = (2, 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-6.txt')

!

test_K_GenCompEq_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-7                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Example from the XPath 2.0 specification.    :)
(:*******************************************************:)
(2, 3) = (3, 4)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-7.txt')

!

test_K_GenCompEq_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-8                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Example from the XPath 2.0 specification.    :)
(:*******************************************************:)
not((1, 2) = (3, 4))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-8.txt')

!

test_K_GenCompEq_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompEq-9                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Example from the XPath 2.0 specification.    :)
(:*******************************************************:)
(xs:untypedAtomic("1"), xs:untypedAtomic("2")) =
			       (xs:untypedAtomic("2.0"), 2.0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/K-GenCompEq-9.txt')

!

test_generalexpression1

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = =:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

() = ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression1.txt')

!

test_generalexpression10

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

() = ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression10.txt')

!

test_generalexpression11

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = =:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

10000 = ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression11.txt')

!

test_generalexpression12

    | query result |

    query := ' 
        (:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                     :)
(:Purpose: Test of a General Expression                  :)
(:with the operands set as follows                       :)
(:  operand1 = Atomic Value                              :)
(:  operator = "="                                       :)
(:  operand2 = empty sequence                            :)
(:*******************************************************:)

10000 = ()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression12.txt')

!

test_generalexpression13

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

10000 = (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression13.txt')

!

test_generalexpression14

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = =:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

10000 = <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression14.txt')

!

test_generalexpression15

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = =:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

10000 = (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression15.txt')

!

test_generalexpression16

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

10000 = (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression16.txt')

!

test_generalexpression17

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = =:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

10000 = ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression17.txt')

!

test_generalexpression18

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

10000 = ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression18.txt')

!

test_generalexpression19

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Atomic Value:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

10000 = ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression19.txt')

!

test_generalexpression2

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = =:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

() = 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression2.txt')

!

test_generalexpression20

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = =:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(50000) = ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression20.txt')

!

test_generalexpression21

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = =:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(50000) = 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression21.txt')

!

test_generalexpression22

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(50000) = (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression22.txt')

!

test_generalexpression23

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(50000) = (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression23.txt')

!

test_generalexpression24

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = =:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(50000) = <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression24.txt')

!

test_generalexpression25

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = =:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(50000) = (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression25.txt')

!

test_generalexpression26

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(50000) = (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression26.txt')

!

test_generalexpression27

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = =:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(50000) = ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression27.txt')

!

test_generalexpression28

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(50000) = ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression28.txt')

!

test_generalexpression29

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic value:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(50000) = ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression29.txt')

!

test_generalexpression3

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

() = (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression3.txt')

!

test_generalexpression30

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = =:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(10000,50000) = ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression30.txt')

!

test_generalexpression31

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = =:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(10000,50000) = 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression31.txt')

!

test_generalexpression32

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(10000,50000) = (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression32.txt')

!

test_generalexpression33

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(10000,50000) = (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression33.txt')

!

test_generalexpression34

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = =:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(10000,50000) = <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression34.txt')

!

test_generalexpression35

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = =:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(10000,50000) = (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression35.txt')

!

test_generalexpression36

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(10000,50000) = (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression36.txt')

!

test_generalexpression37

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = =:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(10000,50000) = ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression37.txt')

!

test_generalexpression38

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(10000,50000) = ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression38.txt')

!

test_generalexpression39

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single atomic values:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(10000,50000) = ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression39.txt')

!

test_generalexpression4

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

() = (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression4.txt')

!

test_generalexpression40

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = =:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

<a>10000</a> = ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression40.txt')

!

test_generalexpression41

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = =:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

<a>10000</a> = 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression41.txt')

!

test_generalexpression42

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

<a>10000</a> = (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression42.txt')

!

test_generalexpression43

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

<a>10000</a> = (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression43.txt')

!

test_generalexpression44

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = =:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

<a>10000</a> = <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression44.txt')

!

test_generalexpression45

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = =:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

<a>10000</a> = (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression45.txt')

!

test_generalexpression46

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

<a>10000</a> = (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression46.txt')

!

test_generalexpression47

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = =:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<a>10000</a> = ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression47.txt')

!

test_generalexpression48

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

<a>10000</a> = ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression48.txt')

!

test_generalexpression49

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Element Constructor:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

<a>10000</a> = ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression49.txt')

!

test_generalexpression5

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = =:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

() = <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression5.txt')

!

test_generalexpression50

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = =:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(<a>10000</a>) = ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression50.txt')

!

test_generalexpression51

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = =:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(<a>10000</a>) = 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression51.txt')

!

test_generalexpression52

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(<a>10000</a>) = (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression52.txt')

!

test_generalexpression53

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(<a>10000</a>) = (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression53.txt')

!

test_generalexpression54

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = =:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(<a>10000</a>) = <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression54.txt')

!

test_generalexpression55

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = =:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(<a>10000</a>) = (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression55.txt')

!

test_generalexpression56

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(<a>10000</a>) = (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression56.txt')

!

test_generalexpression57

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = =:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>) = ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression57.txt')

!

test_generalexpression58

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>) = ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression58.txt')

!

test_generalexpression59

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element constructor:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(<a>10000</a>) = ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression59.txt')

!

test_generalexpression6

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = =:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

() = (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression6.txt')

!

test_generalexpression60

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = =:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) = ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression60.txt')

!

test_generalexpression61

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = =:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) = 10000

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression61.txt')

!

test_generalexpression62

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) = (50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression62.txt')

!

test_generalexpression63

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) = (10000,50000)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression63.txt')

!

test_generalexpression64

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = =:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) = <a>10000</a>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression64.txt')

!

test_generalexpression65

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = =:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) = (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression65.txt')

!

test_generalexpression66

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(<a>10000</a>,<b>50000</b>) = (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression66.txt')

!

test_generalexpression67

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = =:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) = ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression67.txt')

!

test_generalexpression68

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) = ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression68.txt')

!

test_generalexpression69

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element constructors:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

(<a>10000</a>,<b>50000</b>) = ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression69.txt')

!

test_generalexpression7

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

() = (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression7.txt')

!

test_generalexpression70

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = =:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) = ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression70.txt')

!

test_generalexpression71

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = =:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) = 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression71.txt')

!

test_generalexpression72

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) = (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression72.txt')

!

test_generalexpression73

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = =:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) = (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression73.txt')

!

test_generalexpression74

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = =:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) = <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression74.txt')

!

test_generalexpression75

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = =:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) = (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression75.txt')

!

test_generalexpression76

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) = (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression76.txt')

!

test_generalexpression77

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = =:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) = ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression77.txt')

!

test_generalexpression78

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) = ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression78.txt')

!

test_generalexpression79

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of single element nodes:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1]) = ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression79.txt')

!

test_generalexpression8

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = =:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

() = ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression8.txt')

!

test_generalexpression80

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = =:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) = ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression80.txt')

!

test_generalexpression81

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = =:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) = 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression81.txt')

!

test_generalexpression82

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = =:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) = (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression82.txt')

!

test_generalexpression83

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = =:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) = (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression83.txt')

!

test_generalexpression84

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = =:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) = <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression84.txt')

!

test_generalexpression85

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = =:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) = (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression85.txt')

!

test_generalexpression86

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = =:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) = (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression86.txt')

!

test_generalexpression87

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = =:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) = ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression87.txt')

!

test_generalexpression88

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) = ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression88.txt')

!

test_generalexpression89

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (single source):)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1]) = ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression89.txt')

!

test_generalexpression9

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Empty sequence:)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

() = ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression9.txt')

!

test_generalexpression90

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = =:)
(:  operand2 = Empty sequence:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) = ()

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression90.txt')

!

test_generalexpression91

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = =:)
(:  operand2 = Atomic Value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) = 10000

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression91.txt')

!

test_generalexpression92

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = =:)
(:  operand2 = Sequence of single atomic value:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) = (50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression92.txt')

!

test_generalexpression93

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = =:)
(:  operand2 = Sequence of single atomic values:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) = (10000,50000)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression93.txt')

!

test_generalexpression94

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = =:)
(:  operand2 = Element Constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) = <a>10000</a>

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression94.txt')

!

test_generalexpression95

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = =:)
(:  operand2 = Sequence of single element constructor:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) = (<a>10000</a>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression95.txt')

!

test_generalexpression96

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = =:)
(:  operand2 = Sequence of multiple element constructors:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) = (<a>10000</a>,<b>50000</b>)

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression96.txt')

!

test_generalexpression97

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = =:)
(:  operand2 = Sequence of single element nodes:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) = ($input-context1/works/employee[1]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression97.txt')

!

test_generalexpression98

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (single source):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) = ($input-context1/works/employee[1]/hours[1],$input-context1/works/employee[6]/hours[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression98.txt')

!

test_generalexpression99

    | query result |

    query := ' 
        
(:*******************************************************:)
(:Written By: Carmelo Montanez (Automatic Generation)    :)
(:Date: June 2, 2005                                :)
(:Purpose: Test of a General Expression      :)
(:with the operands set as follows          :)
(:  operand1 = Sequence of multiple element nodes (multiple sources):)
(:  operator = =:)
(:  operand2 = Sequence of multiple element nodes (multiple sources):)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/hours[1]) = ($input-context1/works/employee[1]/hours[1],$input-context2/staff/employee[6]/grade[1])

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompEq/generalexpression99.txt')

! !

!XQTSGenCompEqTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
