"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSForExprPositionalVarTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSForExprPositionalVarTests methodsFor:'tests'!

test_K_ForExprPositionalVar_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-1                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $a at $p in (1, 2) return 1, $p
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprPositionalVar_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-10                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:string-to-codepoints(). :)
(:*******************************************************:)
deep-equal((1, 2, 3), for $i at $p in distinct-values((1, 2, 3, 1, 2)) return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-10.txt')

!

test_K_ForExprPositionalVar_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-11                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for the empty sequence. :)
(:*******************************************************:)
empty(for $i at $p in () return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-11.txt')

!

test_K_ForExprPositionalVar_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-12                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:insert-before(). :)
(:*******************************************************:)
deep-equal((1, 2, 3, 4),
	    for $i at $p
	    in insert-before((1, current-time()), 13, (current-date(), 3))
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-12.txt')

!

test_K_ForExprPositionalVar_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-13                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:insert-before()(#2). :)
(:*******************************************************:)
deep-equal((1, 2, 3, 4),
	    for $i at $p
	    in insert-before((1, current-time()), 1, (current-date(), 3))
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-13.txt')

!

test_K_ForExprPositionalVar_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-14                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:insert-before()(#3). :)
(:*******************************************************:)
deep-equal((1, 2, 3, 4),
	    for $i at $p
	    in insert-before((1, current-time()), 2, (current-date(), 3))
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-14.txt')

!

test_K_ForExprPositionalVar_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-15                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for the range expression. :)
(:*******************************************************:)
deep-equal((1, 2, 3, 4),
	    for $i at $p
	    in 1 to 4
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-15.txt')

!

test_K_ForExprPositionalVar_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-16                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for the range expression(#2). :)
(:*******************************************************:)
deep-equal((1, 2, 3, 4),
	    for $i at $p
	    in -10 to -7
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-16.txt')

!

test_K_ForExprPositionalVar_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-17                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:remove(). :)
(:*******************************************************:)
deep-equal((1, 2, 3),
	    for $i at $p
	    in remove((1, 2, 3, current-time()), 2)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-17.txt')

!

test_K_ForExprPositionalVar_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-18                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:remove(). :)
(:*******************************************************:)
deep-equal((1, 2, 3),
	    for $i at $p
	    in remove((1, 2, 3, current-time()), 4)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-18.txt')

!

test_K_ForExprPositionalVar_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-19                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:remove(). :)
(:*******************************************************:)
deep-equal((1, 2, 3),
	    for $i at $p
	    in remove((1, 2, current-time()), 10)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-19.txt')

!

test_K_ForExprPositionalVar_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-2                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Position variable which is not in scope.     :)
(:*******************************************************:)
for $a at $p1 in (1, 2), $b at $p2 in (1, 2), $c at $p3 in (1, 2) return 1, $p1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprPositionalVar_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-20                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:remove(). :)
(:*******************************************************:)
deep-equal((1, 2, 3),
	    for $i at $p
	    in remove((1, 2, current-time()), 0)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-20.txt')

!

test_K_ForExprPositionalVar_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-21                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:remove(). :)
(:*******************************************************:)
deep-equal((1, 2, 3),
	    for $i at $p
	    in remove((1, 2, 3, current-time()), 1)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-21.txt')

!

test_K_ForExprPositionalVar_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-22                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:remove(). :)
(:*******************************************************:)
deep-equal((1, 2, 3),
	    for $i at $p
	    in remove((1, 2, 3, current-time()), 3)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-22.txt')

!

test_K_ForExprPositionalVar_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-23                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:subsequence(). :)
(:*******************************************************:)
1 eq 
	    (for $i at $p
	    in subsequence((1, 2, 3, current-time()), 1, 1)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-23.txt')

!

test_K_ForExprPositionalVar_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-24                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:subsequence(). :)
(:*******************************************************:)
empty(for $i at $p
	    in subsequence((1, 2, 3, current-time()), 5)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-24.txt')

!

test_K_ForExprPositionalVar_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-25                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:subsequence(). :)
(:*******************************************************:)
empty(for $i at $p
	    in subsequence((1, 2, 3, current-time()), 5, 8)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-25.txt')

!

test_K_ForExprPositionalVar_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-26                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:subsequence(). :)
(:*******************************************************:)
deep-equal((1, 2),
	    for $i at $p
	    in subsequence((1, 2, 3, current-time()), 3, 2)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-26.txt')

!

test_K_ForExprPositionalVar_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-27                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:subsequence(). :)
(:*******************************************************:)
deep-equal((1, 2),
	    for $i at $p
	    in subsequence((1, 2, 3, current-time()), 1, 2)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-27.txt')

!

test_K_ForExprPositionalVar_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-28                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:subsequence(). :)
(:*******************************************************:)
deep-equal((1, 2),
	    for $i at $p
	    in subsequence((1, 2, 3, current-time()), 2, 2)
	    return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-28.txt')

!

test_K_ForExprPositionalVar_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-29                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for a singleton value. :)
(:*******************************************************:)
1 eq (for $i at $p in 0 return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-29.txt')

!

test_K_ForExprPositionalVar_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-3                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Position variable which is not in scope.     :)
(:*******************************************************:)
for $a at $p1 in (1, 2), $b at $p2 in (1, 2), $c at $p3 in (1, 2) return 1, $p2
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprPositionalVar_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-30                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Evaluate the positional and binding expression at the same time. :)
(:*******************************************************:)
deep-equal(for $i at $p in (1, 2, 3, 4) return ($i, $p),
           (1, 1, 2, 2, 3, 3, 4, 4))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-30.txt')

!

test_K_ForExprPositionalVar_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-4                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Position variable which is not in scope.     :)
(:*******************************************************:)
for $a at $p1 in (1, 2), $b at $p2 in (1, 2), $c at $p3 in (1, 2) return 1, $p3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprPositionalVar_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-5                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: The name for a positional variable must be preceeded with "$". :)
(:*******************************************************:)
for $a at p1 in 1 return 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprPositionalVar_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-6                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify positional variable with fn:deep-equal(). :)
(:*******************************************************:)
deep-equal((1, 2, 3), for $i at $p in (1, 2, 3) return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-6.txt')

!

test_K_ForExprPositionalVar_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-7                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Extract the EBV from a positional variable.  :)
(:*******************************************************:)
deep-equal((true(), true()), for $i at $p in (1, 2) return boolean($p))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-7.txt')

!

test_K_ForExprPositionalVar_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-8                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A positional variable causing a type error.  :)
(:*******************************************************:)
for $i at $p in (1, 2, 3) return $p + "1"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprPositionalVar_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprPositionalVar-9                        :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Verify that the position is properly computed for fn:string-to-codepoints(). :)
(:*******************************************************:)
deep-equal((1, 2, 3), for $i at $p in string-to-codepoints("abc") return $p)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprPositionalVar/K-ForExprPositionalVar-9.txt')

! !

!XQTSForExprPositionalVarTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
