"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSParenExprTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSParenExprTests methodsFor:'tests'!

test_Parenexpr_1

    | query result |

    query := ' 
        (: Name: Parenexpr-1 :)
(: Written by: Andreas Behm :)
(: Description: Arithmetic operations :)

(1 + 2) * 3

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-1.txt')

!

test_Parenexpr_10

    | query result |

    query := ' 
        (: Name: Parenexpr-10 :)
(: Written by: Andreas Behm :)
(: Description: Logical expressions :)

fn:true() or (fn:true() and fn:false())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-10.txt')

!

test_Parenexpr_11

    | query result |

    query := ' 
        (: Name: Parenexpr-11 :)
(: Written by: Andreas Behm :)
(: Description: FLWOR expression :)

(for $x in (1) where (fn:true()) order by ($x) return ($x))

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-11.txt')

!

test_Parenexpr_12

    | query result |

    query := ' 
        (: Name: Parenexpr-12 :)
(: Written by: Andreas Behm :)
(: Description: if expression :)

for $x in (1,2) return (if (($x eq 1)) then ($x) else ($x + 1))

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-12.txt')

!

test_Parenexpr_13

    | query result |

    query := ' 
        (: Name: Parenexpr-13 :)
(: Written by: Andreas Behm :)
(: Description: Literal :)

(1)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-13.txt')

!

test_Parenexpr_14

    | query result |

    query := ' 
        (: Name: Parenexpr-14 :)
(: Written by: Andreas Behm :)
(: Description: Sequence :)

(1, (2, (3, 4)), (5))

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-14.txt')

!

test_Parenexpr_15

    | query result |

    query := ' 
        (: Name: Parenexpr-15 :)
(: Written by: Andreas Behm :)
(: Description: union and except :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{$input-context//node() | ($input-context//node() except $input-context//comment())}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-15.xml')

!

test_Parenexpr_16

    | query result |

    query := ' 
        (: Name: Parenexpr-16 :)
(: Written by: Andreas Behm :)
(: Description: union and except :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{($input-context//node() | $input-context//node()) except $input-context//comment()}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-16.xml')

!

test_Parenexpr_17

    | query result |

    query := ' 
        (: Name: Parenexpr-17 :)
(: Written by: Andreas Behm :)
(: Description: Constructor :)

(<elem/>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-17.xml')

!

test_Parenexpr_18

    | query result |

    query := ' 
        (: Name: Parenexpr-18 :)
(: Written by: Andreas Behm :)
(: Description: Constructor :)

<elem attr="{(1)}">{(<child/>),(<child/>)}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-18.xml')

!

test_Parenexpr_19

    | query result |

    query := ' 
        (: Name: Parenexpr-19 :)
(: Written by: Andreas Behm :)
(: Description: Input context :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

($input-context)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'Tree1Child'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-19.xml')

!

test_Parenexpr_2

    | query result |

    query := ' 
        (: Name: Parenexpr-2 :)
(: Written by: Andreas Behm :)
(: Description: Arithmetic operations :)

1 + (2 * 3)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-2.txt')

!

test_Parenexpr_20

    | query result |

    query := ' 
        (: Name: Parenexpr-20 :)
(: Written by: Andreas Behm :)
(: Description: Path expression :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{($input-context//(north)/(/)//(@mark)[(1)]/(.)/(..))}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'Tree1Child'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-20.xml')

!

test_Parenexpr_3

    | query result |

    query := ' 
        (: Name: Parenexpr-3 :)
(: Written by: Andreas Behm :)
(: Description: Arithmetic operations :)

-(2 + 5)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-3.txt')

!

test_Parenexpr_4

    | query result |

    query := ' 
        (: Name: Parenexpr-4 :)
(: Written by: Andreas Behm :)
(: Description: Arithmetic operations :)

(-2) + 5

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-4.txt')

!

test_Parenexpr_5

    | query result |

    query := ' 
        (: Name: Parenexpr-5 :)
(: Written by: Andreas Behm :)
(: Description: Arithmetic operations :)

2 + (4 idiv 2)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-5.txt')

!

test_Parenexpr_6

    | query result |

    query := ' 
        (: Name: Parenexpr-6 :)
(: Written by: Andreas Behm :)
(: Description: Arithmetic operations :)

(2 + 4) idiv 2

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-6.txt')

!

test_Parenexpr_7

    | query result |

    query := ' 
        (: Name: Parenexpr-7 :)
(: Written by: Andreas Behm :)
(: Description: Arithmetic operations :)

2 * (5 mod 3)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-7.txt')

!

test_Parenexpr_8

    | query result |

    query := ' 
        (: Name: Parenexpr-8 :)
(: Written by: Andreas Behm :)
(: Description: Arithmetic operations :)

(2 * 5) mod 3

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-8.txt')

!

test_Parenexpr_9

    | query result |

    query := ' 
        (: Name: Parenexpr-9 :)
(: Written by: Andreas Behm :)
(: Description: Logical expressions :)

(fn:true() or fn:true()) and fn:false()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/PrimaryExpr/ParenExpr/Parenexpr-9.txt')

! !

!XQTSParenExprTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
