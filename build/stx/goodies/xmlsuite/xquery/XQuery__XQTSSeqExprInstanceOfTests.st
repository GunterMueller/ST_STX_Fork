"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSSeqExprInstanceOfTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSSeqExprInstanceOfTests methodsFor:'tests'!

test_K_SeqExprInstanceOf_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-1                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 instance of item()`. :)
(:*******************************************************:)
1 instance of item()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-1.txt')

!

test_K_SeqExprInstanceOf_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-10                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `"a string" instance of xs:string`. :)
(:*******************************************************:)
"a string" instance of xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-10.txt')

!

test_K_SeqExprInstanceOf_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-11                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not("false" instance of xs:boolean)`. :)
(:*******************************************************:)
not("false" instance of xs:boolean)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-11.txt')

!

test_K_SeqExprInstanceOf_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-12                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1.1 instance of xs:decimal`. :)
(:*******************************************************:)
1.1 instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-12.txt')

!

test_K_SeqExprInstanceOf_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-13                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(1.1 instance of xs:integer)`. :)
(:*******************************************************:)
not(1.1 instance of xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-13.txt')

!

test_K_SeqExprInstanceOf_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-14                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:anyURI("http://www.example.com/") instance of xs:anyURI`. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/") instance of xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-14.txt')

!

test_K_SeqExprInstanceOf_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-15                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(xs:anyURI("http://www.example.com/") instance of xs:string)`. :)
(:*******************************************************:)
not(xs:anyURI("http://www.example.com/") instance of xs:string)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-15.txt')

!

test_K_SeqExprInstanceOf_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-16                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not("a string" instance of xs:untypedAtomic)`. :)
(:*******************************************************:)
not("a string" instance of xs:untypedAtomic)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-16.txt')

!

test_K_SeqExprInstanceOf_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-17                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(1, 2, 3, 4, 5) instance of xs:integer+`. :)
(:*******************************************************:)
(1, 2, 3, 4, 5) instance of xs:integer+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-17.txt')

!

test_K_SeqExprInstanceOf_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-18                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not((1, 2, 3, 4, 5) instance of xs:integer)`. :)
(:*******************************************************:)
not((1, 2, 3, 4, 5) instance of xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-18.txt')

!

test_K_SeqExprInstanceOf_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-19                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not((1, 2, 3, 4, 5) instance of xs:integer?)`. :)
(:*******************************************************:)
not((1, 2, 3, 4, 5) instance of xs:integer?)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-19.txt')

!

test_K_SeqExprInstanceOf_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-2                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: item() type with comment appearing inside the paranteses. :)
(:*******************************************************:)
1 instance of item((:comment:))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-2.txt')

!

test_K_SeqExprInstanceOf_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-20                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(1, 2, 3, 4, 5) instance of xs:integer*`. :)
(:*******************************************************:)
(1, 2, 3, 4, 5) instance of xs:integer*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-20.txt')

!

test_K_SeqExprInstanceOf_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-21                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(1, 2, 3, 4, 5) instance of item()+`. :)
(:*******************************************************:)
(1, 2, 3, 4, 5) instance of item()+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-21.txt')

!

test_K_SeqExprInstanceOf_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-22                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not((1, 2, "a string", 4, 5) instance of xs:integer*)`. :)
(:*******************************************************:)
not((1, 2, "a string", 4, 5) instance of xs:integer*)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-22.txt')

!

test_K_SeqExprInstanceOf_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-23                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not((1, 2, 1.1, 4, 5) instance of xs:integer*)`. :)
(:*******************************************************:)
not((1, 2, 1.1, 4, 5) instance of xs:integer*)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-23.txt')

!

test_K_SeqExprInstanceOf_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-24                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not((1, 2, "a string", 4, 5) instance of xs:string*)`. :)
(:*******************************************************:)
not((1, 2, "a string", 4, 5) instance of xs:string*)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-24.txt')

!

test_K_SeqExprInstanceOf_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-25                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(1, 2, "a string", 4, 5) instance of xs:anyAtomicType*`. :)
(:*******************************************************:)
(1, 2, "a string", 4, 5) instance of xs:anyAtomicType*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-25.txt')

!

test_K_SeqExprInstanceOf_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-26                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(1, 2, count("one"), 4, 5) instance of xs:integer+`. :)
(:*******************************************************:)
(1, 2, count("one"), 4, 5) instance of xs:integer+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-26.txt')

!

test_K_SeqExprInstanceOf_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-27                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(1 instance of text())`. :)
(:*******************************************************:)
not(1 instance of text())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-27.txt')

!

test_K_SeqExprInstanceOf_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-28                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(1 instance of node())`. :)
(:*******************************************************:)
not(1 instance of node())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-28.txt')

!

test_K_SeqExprInstanceOf_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-29                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(1 instance of element())`. :)
(:*******************************************************:)
not(1 instance of element())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-29.txt')

!

test_K_SeqExprInstanceOf_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-3                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 instance of xs:integer`. :)
(:*******************************************************:)
1 instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-3.txt')

!

test_K_SeqExprInstanceOf_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-30                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(1 instance of processing-instruction())`. :)
(:*******************************************************:)
not(1 instance of processing-instruction())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-30.txt')

!

test_K_SeqExprInstanceOf_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-31                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(1 instance of comment())`. :)
(:*******************************************************:)
not(1 instance of comment())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-31.txt')

!

test_K_SeqExprInstanceOf_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-32                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A comment appearing inside the paranteses of the sequence type text(). :)
(:*******************************************************:)
not(1 instance of text((:comment:)))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-32.txt')

!

test_K_SeqExprInstanceOf_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-33                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A comment appearing inside the paranteses of the sequence type node(). :)
(:*******************************************************:)
not(1 instance of node((:comment:)))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-33.txt')

!

test_K_SeqExprInstanceOf_34

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-34                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A comment appearing inside the paranteses of the sequence type element(). :)
(:*******************************************************:)
not(1 instance of element((:comment:)))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-34.txt')

!

test_K_SeqExprInstanceOf_35

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-35                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A comment appearing inside the paranteses of the sequence type processing-instruction(). :)
(:*******************************************************:)
not(1 instance of processing-instruction((:comment:)))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-35.txt')

!

test_K_SeqExprInstanceOf_36

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-36                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A comment appearing inside the paranteses of the sequence type comment(). :)
(:*******************************************************:)
not(1 instance of comment((:comment:)))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-36.txt')

!

test_K_SeqExprInstanceOf_37

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-37                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(1 instance of empty-sequence())`. :)
(:*******************************************************:)
not(1 instance of empty-sequence())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-37.txt')

!

test_K_SeqExprInstanceOf_38

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-38                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not( (1, 2, 3) instance of empty-sequence())`. :)
(:*******************************************************:)
not( (1, 2, 3) instance of empty-sequence())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-38.txt')

!

test_K_SeqExprInstanceOf_39

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-39                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `() instance of empty-sequence()`. :)
(:*******************************************************:)
() instance of empty-sequence()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-39.txt')

!

test_K_SeqExprInstanceOf_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-4                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 instance of xs:decimal`. :)
(:*******************************************************:)
1 instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-4.txt')

!

test_K_SeqExprInstanceOf_40

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-40                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Comment appearing inside the paranteses of empty-sequence(). :)
(:*******************************************************:)
() instance of empty-sequence((:comment:))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-40.txt')

!

test_K_SeqExprInstanceOf_41

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-41                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(((()))) instance of empty-sequence()`. :)
(:*******************************************************:)
(((()))) instance of empty-sequence()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-41.txt')

!

test_K_SeqExprInstanceOf_42

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-42                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `((), (), ()) instance of empty-sequence()`. :)
(:*******************************************************:)
((), (), ()) instance of empty-sequence()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-42.txt')

!

test_K_SeqExprInstanceOf_43

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-43                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `((), "xs:string") instance of xs:string`. :)
(:*******************************************************:)
((), "xs:string") instance of xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-43.txt')

!

test_K_SeqExprInstanceOf_44

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-44                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `("xs:string", (), "xs:string") instance of xs:string+`. :)
(:*******************************************************:)
("xs:string", (), "xs:string") instance of xs:string+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-44.txt')

!

test_K_SeqExprInstanceOf_45

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-45                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(1.1, (), 1) instance of xs:decimal+`. :)
(:*******************************************************:)
(1.1, (), 1) instance of xs:decimal+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-45.txt')

!

test_K_SeqExprInstanceOf_46

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-46                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not("a string" instance of xs:NOTATION)`. :)
(:*******************************************************:)
not("a string" instance of xs:NOTATION)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-46.txt')

!

test_K_SeqExprInstanceOf_47

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-47                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not("a string" instance of xs:QName)`. :)
(:*******************************************************:)
not("a string" instance of xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-47.txt')

!

test_K_SeqExprInstanceOf_48

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-48                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1.1 instance of xs:decimal and not(1.1 instance of xs:integer)`. :)
(:*******************************************************:)
1.1 instance of xs:decimal and not(1.1 instance of xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-48.txt')

!

test_K_SeqExprInstanceOf_49

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-49                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A type is referenced which doesn"t exist.    :)
(:*******************************************************:)
3 instance of prefixDoesNotExist:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-5                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 instance of xs:integer?`. :)
(:*******************************************************:)
1 instance of xs:integer?
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-5.txt')

!

test_K_SeqExprInstanceOf_50

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-50                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A type is referenced which doesn"t exist.    :)
(:*******************************************************:)
3 instance of xs:doesNotExist
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_51

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-51                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A type is referenced which doesn"t exist.    :)
(:*******************************************************:)
3 instance of xs:qname
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_52

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-52                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A type is referenced which doesn"t exist.    :)
(:*******************************************************:)
3 instance of none
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_53

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-53                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A type is referenced which doesn"t exist.    :)
(:*******************************************************:)
3 instance of void
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_54

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-54                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A type is referenced which doesn"t exist.    :)
(:*******************************************************:)
3 instance of none()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_55

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-55                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A type is referenced which doesn"t exist.    :)
(:*******************************************************:)
3 instance of void()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_56

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-56                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: The fn:error() function in combination with "instance of". :)
(:*******************************************************:)
error() instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_57

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-57                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: The fn:error() function in combination with "instance of". :)
(:*******************************************************:)
error() instance of xs:integer*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_58

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-58                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: The fn:error() function in combination with "instance of". :)
(:*******************************************************:)
error() instance of empty-sequence()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_59

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-59                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: The fn:error() function in combination with "instance of". :)
(:*******************************************************:)
(error(), 1) instance of empty-sequence()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-6                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 instance of xs:integer+`. :)
(:*******************************************************:)
1 instance of xs:integer+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-6.txt')

!

test_K_SeqExprInstanceOf_60

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-60                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: The fn:error() function in combination with "instance of". :)
(:*******************************************************:)
(1, error()) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_61

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-61                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: The fn:error() function in combination with "instance of". :)
(:*******************************************************:)
(error(), 1) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_62

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-62                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: The fn:error() function in combination with "instance of". :)
(:*******************************************************:)
(1, error()) instance of xs:integer*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_63

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-63                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: The fn:error() function in combination with "instance of". :)
(:*******************************************************:)
(error(), 1) instance of xs:integer*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprInstanceOf_64

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-64                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(((10)div(3)) instance of xs:integer)`. :)
(:*******************************************************:)
not(((10)div(3)) instance of xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-64.txt')

!

test_K_SeqExprInstanceOf_65

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-65                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `((10)idiv(3)) instance of xs:integer`. :)
(:*******************************************************:)
((10)idiv(3)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-65.txt')

!

test_K_SeqExprInstanceOf_66

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-66                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `((10)mod(3)) instance of xs:integer`. :)
(:*******************************************************:)
((10)mod(3)) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-66.txt')

!

test_K_SeqExprInstanceOf_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-7                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 instance of xs:integer*`. :)
(:*******************************************************:)
1 instance of xs:integer*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-7.txt')

!

test_K_SeqExprInstanceOf_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-8                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `false() instance of xs:boolean`. :)
(:*******************************************************:)
false() instance of xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-8.txt')

!

test_K_SeqExprInstanceOf_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprInstanceOf-9                           :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `false() instance of xs:anyAtomicType`. :)
(:*******************************************************:)
false() instance of xs:anyAtomicType
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprInstanceOf/K-SeqExprInstanceOf-9.txt')

!

test_instanceof1

    | query result |

    query := ' 
        (: Name: instanceof1 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:dateTime".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:dateTime

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof1.txt')

!

test_instanceof10

    | query result |

    query := ' 
        (: Name: instanceof10 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:integer".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof10.txt')

!

test_instanceof100

    | query result |

    query := ' 
        (: Name: instanceof100 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:dateTime".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:dateTime

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof100.txt')

!

test_instanceof101

    | query result |

    query := ' 
        (: Name: instanceof101 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:time".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:time

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof101.txt')

!

test_instanceof102

    | query result |

    query := ' 
        (: Name: instanceof102 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:date".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:date

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof102.txt')

!

test_instanceof103

    | query result |

    query := ' 
        (: Name: instanceof103 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:boolean".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:boolean

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof103.txt')

!

test_instanceof104

    | query result |

    query := ' 
        (: Name: instanceof104 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:float".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:float

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof104.txt')

!

test_instanceof105

    | query result |

    query := ' 
        (: Name: instanceof105 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:double".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:double

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof105.txt')

!

test_instanceof106

    | query result |

    query := ' 
        (: Name: instanceof106 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:anyURI".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:anyURI

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof106.txt')

!

test_instanceof107

    | query result |

    query := ' 
        (: Name: instanceof107 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:string".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:string

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof107.txt')

!

test_instanceof108

    | query result |

    query := ' 
        (: Name: instanceof108 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:decimal".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:decimal

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof108.txt')

!

test_instanceof109

    | query result |

    query := ' 
        (: Name: instanceof109 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:integer".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof109.txt')

!

test_instanceof11

    | query result |

    query := ' 
        (: Name: instanceof11 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:int".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:int

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof11.txt')

!

test_instanceof110

    | query result |

    query := ' 
        (: Name: instanceof110 :)
(: purpose: Evaluation of "instance of" expression for pattern "integer instance of xs:int".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967543233 instance of xs:int

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof110.txt')

!

test_instanceof12

    | query result |

    query := ' 
        (: Name: instanceof12 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:dateTime".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:dateTime

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof12.txt')

!

test_instanceof13

    | query result |

    query := ' 
        (: Name: instanceof13 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:time".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:time

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof13.txt')

!

test_instanceof14

    | query result |

    query := ' 
        (: Name: instanceof14 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:date".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:date

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof14.txt')

!

test_instanceof15

    | query result |

    query := ' 
        (: Name: instanceof15 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:boolean".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:boolean

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof15.txt')

!

test_instanceof16

    | query result |

    query := ' 
        (: Name: instanceof16 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:float".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:float

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof16.txt')

!

test_instanceof17

    | query result |

    query := ' 
        (: Name: instanceof17 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:double".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:double

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof17.txt')

!

test_instanceof18

    | query result |

    query := ' 
        (: Name: instanceof18 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:anyURI".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:anyURI

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof18.txt')

!

test_instanceof19

    | query result |

    query := ' 
        (: Name: instanceof19 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:string".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:string

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof19.txt')

!

test_instanceof2

    | query result |

    query := ' 
        (: Name: instanceof2 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:time".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:time

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof2.txt')

!

test_instanceof20

    | query result |

    query := ' 
        (: Name: instanceof20 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:decimal".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:decimal

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof20.txt')

!

test_instanceof21

    | query result |

    query := ' 
        (: Name: instanceof21 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:integer".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof21.txt')

!

test_instanceof22

    | query result |

    query := ' 
        (: Name: instanceof22 :)
(: purpose: Evaluation of "instance of" expression for pattern "time instance of xs:int".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:time("13:20:10.5Z") instance of xs:int

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof22.txt')

!

test_instanceof23

    | query result |

    query := ' 
        (: Name: instanceof23 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:dateTime".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:dateTime

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof23.txt')

!

test_instanceof24

    | query result |

    query := ' 
        (: Name: instanceof24 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:time".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:time

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof24.txt')

!

test_instanceof25

    | query result |

    query := ' 
        (: Name: instanceof25 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:date".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:date

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof25.txt')

!

test_instanceof26

    | query result |

    query := ' 
        (: Name: instanceof26 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:boolean".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:boolean

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof26.txt')

!

test_instanceof27

    | query result |

    query := ' 
        (: Name: instanceof27 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:float".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:float

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof27.txt')

!

test_instanceof28

    | query result |

    query := ' 
        (: Name: instanceof28 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:double".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:double

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof28.txt')

!

test_instanceof29

    | query result |

    query := ' 
        (: Name: instanceof29 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:anyURI".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:anyURI

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof29.txt')

!

test_instanceof3

    | query result |

    query := ' 
        (: Name: instanceof3 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:date".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:date

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof3.txt')

!

test_instanceof30

    | query result |

    query := ' 
        (: Name: instanceof30 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:string".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:string

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof30.txt')

!

test_instanceof31

    | query result |

    query := ' 
        (: Name: instanceof31 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:decimal".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:decimal

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof31.txt')

!

test_instanceof32

    | query result |

    query := ' 
        (: Name: instanceof32 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:integer".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof32.txt')

!

test_instanceof33

    | query result |

    query := ' 
        (: Name: instanceof33 :)
(: purpose: Evaluation of "instance of" expression for pattern "date instance of xs:int".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:date("2000-01-01+05:00") instance of xs:int

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof33.txt')

!

test_instanceof34

    | query result |

    query := ' 
        (: Name: instanceof34 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:dateTime".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:dateTime

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof34.txt')

!

test_instanceof35

    | query result |

    query := ' 
        (: Name: instanceof35 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:time".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:time

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof35.txt')

!

test_instanceof36

    | query result |

    query := ' 
        (: Name: instanceof36 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:date".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:date

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof36.txt')

!

test_instanceof37

    | query result |

    query := ' 
        (: Name: instanceof37 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:boolean".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:boolean

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof37.txt')

!

test_instanceof38

    | query result |

    query := ' 
        (: Name: instanceof38 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:float".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:float

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof38.txt')

!

test_instanceof39

    | query result |

    query := ' 
        (: Name: instanceof39 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:double".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:double

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof39.txt')

!

test_instanceof4

    | query result |

    query := ' 
        (: Name: instanceof4 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:boolean".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:boolean

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof4.txt')

!

test_instanceof40

    | query result |

    query := ' 
        (: Name: instanceof40 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:anyURI".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:anyURI

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof40.txt')

!

test_instanceof41

    | query result |

    query := ' 
        (: Name: instanceof41 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:string".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:string

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof41.txt')

!

test_instanceof42

    | query result |

    query := ' 
        (: Name: instanceof42 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:decimal".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:decimal

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof42.txt')

!

test_instanceof43

    | query result |

    query := ' 
        (: Name: instanceof43 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:integer".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof43.txt')

!

test_instanceof44

    | query result |

    query := ' 
        (: Name: instanceof44 :)
(: purpose: Evaluation of "instance of" expression for pattern "boolean instance of xs:int".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:boolean("true") instance of xs:int

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof44.txt')

!

test_instanceof45

    | query result |

    query := ' 
        (: Name: instanceof45 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:dateTime".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:dateTime

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof45.txt')

!

test_instanceof46

    | query result |

    query := ' 
        (: Name: instanceof46 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:time".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:time

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof46.txt')

!

test_instanceof47

    | query result |

    query := ' 
        (: Name: instanceof47 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:date".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:date

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof47.txt')

!

test_instanceof48

    | query result |

    query := ' 
        (: Name: instanceof48 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:boolean".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:boolean

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof48.txt')

!

test_instanceof49

    | query result |

    query := ' 
        (: Name: instanceof49 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:float".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:float

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof49.txt')

!

test_instanceof5

    | query result |

    query := ' 
        (: Name: instanceof5 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:float".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:float

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof5.txt')

!

test_instanceof50

    | query result |

    query := ' 
        (: Name: instanceof50 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:double".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:double

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof50.txt')

!

test_instanceof51

    | query result |

    query := ' 
        (: Name: instanceof51 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:anyURI".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:anyURI

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof51.txt')

!

test_instanceof52

    | query result |

    query := ' 
        (: Name: instanceof52 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:string".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:string

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof52.txt')

!

test_instanceof53

    | query result |

    query := ' 
        (: Name: instanceof53 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:decimal".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:decimal

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof53.txt')

!

test_instanceof54

    | query result |

    query := ' 
        (: Name: instanceof54 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:integer".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof54.txt')

!

test_instanceof55

    | query result |

    query := ' 
        (: Name: instanceof55 :)
(: purpose: Evaluation of "instance of" expression for pattern "float instance of xs:int".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:int

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof55.txt')

!

test_instanceof56

    | query result |

    query := ' 
        (: Name: instanceof56 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:dateTime".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:dateTime

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof56.txt')

!

test_instanceof57

    | query result |

    query := ' 
        (: Name: instanceof57 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:time".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:time

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof57.txt')

!

test_instanceof58

    | query result |

    query := ' 
        (: Name: instanceof58 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:date".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:date

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof58.txt')

!

test_instanceof59

    | query result |

    query := ' 
        (: Name: instanceof59 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:boolean".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:boolean

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof59.txt')

!

test_instanceof6

    | query result |

    query := ' 
        (: Name: instanceof6 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:double".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:double

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof6.txt')

!

test_instanceof60

    | query result |

    query := ' 
        (: Name: instanceof60 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:float".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:float

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof60.txt')

!

test_instanceof61

    | query result |

    query := ' 
        (: Name: instanceof61 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:double".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:double

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof61.txt')

!

test_instanceof62

    | query result |

    query := ' 
        (: Name: instanceof62 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:anyURI".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:anyURI

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof62.txt')

!

test_instanceof63

    | query result |

    query := ' 
        (: Name: instanceof63 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:string".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:string

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof63.txt')

!

test_instanceof64

    | query result |

    query := ' 
        (: Name: instanceof64 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:decimal".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:decimal

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof64.txt')

!

test_instanceof65

    | query result |

    query := ' 
        (: Name: instanceof65 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:integer".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof65.txt')

!

test_instanceof66

    | query result |

    query := ' 
        (: Name: instanceof66 :)
(: purpose: Evaluation of "instance of" expression for pattern "double instance of xs:int".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
1267.43233E12 instance of xs:int

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof66.txt')

!

test_instanceof67

    | query result |

    query := ' 
        (: Name: instanceof67 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:dateTime".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:dateTime

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof67.txt')

!

test_instanceof68

    | query result |

    query := ' 
        (: Name: instanceof68 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:time".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:time

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof68.txt')

!

test_instanceof69

    | query result |

    query := ' 
        (: Name: instanceof69 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:date".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:date

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof69.txt')

!

test_instanceof7

    | query result |

    query := ' 
        (: Name: instanceof7 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:anyURI".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:anyURI

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof7.txt')

!

test_instanceof70

    | query result |

    query := ' 
        (: Name: instanceof70 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:boolean".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:boolean

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof70.txt')

!

test_instanceof71

    | query result |

    query := ' 
        (: Name: instanceof71 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:float".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:float

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof71.txt')

!

test_instanceof72

    | query result |

    query := ' 
        (: Name: instanceof72 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:double".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:double

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof72.txt')

!

test_instanceof73

    | query result |

    query := ' 
        (: Name: instanceof73 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:anyURI".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:anyURI

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof73.txt')

!

test_instanceof74

    | query result |

    query := ' 
        (: Name: instanceof74 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:string".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:string

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof74.txt')

!

test_instanceof75

    | query result |

    query := ' 
        (: Name: instanceof75 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:decimal".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:decimal

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof75.txt')

!

test_instanceof76

    | query result |

    query := ' 
        (: Name: instanceof76 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:integer".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof76.txt')

!

test_instanceof77

    | query result |

    query := ' 
        (: Name: instanceof77 :)
(: purpose: Evaluation of "instance of" expression for pattern "anyURI instance of xs:int".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:anyURI("http://www.example.com") instance of xs:int

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof77.txt')

!

test_instanceof78

    | query result |

    query := ' 
        (: Name: instanceof78 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:dateTime".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:dateTime

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof78.txt')

!

test_instanceof79

    | query result |

    query := ' 
        (: Name: instanceof79 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:time".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:time

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof79.txt')

!

test_instanceof8

    | query result |

    query := ' 
        (: Name: instanceof8 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:string".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:string

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof8.txt')

!

test_instanceof80

    | query result |

    query := ' 
        (: Name: instanceof80 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:date".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:date

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof80.txt')

!

test_instanceof81

    | query result |

    query := ' 
        (: Name: instanceof81 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:boolean".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:boolean

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof81.txt')

!

test_instanceof82

    | query result |

    query := ' 
        (: Name: instanceof82 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:float".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:float

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof82.txt')

!

test_instanceof83

    | query result |

    query := ' 
        (: Name: instanceof83 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:double".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:double

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof83.txt')

!

test_instanceof84

    | query result |

    query := ' 
        (: Name: instanceof84 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:anyURI".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:anyURI

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof84.txt')

!

test_instanceof85

    | query result |

    query := ' 
        (: Name: instanceof85 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:string".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:string

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof85.txt')

!

test_instanceof86

    | query result |

    query := ' 
        (: Name: instanceof86 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:decimal".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:decimal

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof86.txt')

!

test_instanceof87

    | query result |

    query := ' 
        (: Name: instanceof87 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:integer".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof87.txt')

!

test_instanceof88

    | query result |

    query := ' 
        (: Name: instanceof88 :)
(: purpose: Evaluation of "instance of" expression for pattern "string instance of xs:int".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
"A String Function" instance of xs:int

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof88.txt')

!

test_instanceof89

    | query result |

    query := ' 
        (: Name: instanceof89 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:dateTime".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:dateTime

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof89.txt')

!

test_instanceof9

    | query result |

    query := ' 
        (: Name: instanceof9 :)
(: purpose: Evaluation of "instance of" expression for pattern "dateTime instance of xs:decimal".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
xs:dateTime("2002-04-02T12:00:00Z") instance of xs:decimal

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof9.txt')

!

test_instanceof90

    | query result |

    query := ' 
        (: Name: instanceof90 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:time".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:time

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof90.txt')

!

test_instanceof91

    | query result |

    query := ' 
        (: Name: instanceof91 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:date".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:date

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof91.txt')

!

test_instanceof92

    | query result |

    query := ' 
        (: Name: instanceof92 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:boolean".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:boolean

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof92.txt')

!

test_instanceof93

    | query result |

    query := ' 
        (: Name: instanceof93 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:float".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:float

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof93.txt')

!

test_instanceof94

    | query result |

    query := ' 
        (: Name: instanceof94 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:double".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:double

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof94.txt')

!

test_instanceof95

    | query result |

    query := ' 
        (: Name: instanceof95 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:anyURI".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:anyURI

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof95.txt')

!

test_instanceof96

    | query result |

    query := ' 
        (: Name: instanceof96 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:string".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:string

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof96.txt')

!

test_instanceof97

    | query result |

    query := ' 
        (: Name: instanceof97 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:decimal".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:decimal

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof97.txt')

!

test_instanceof98

    | query result |

    query := ' 
        (: Name: instanceof98 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:integer".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof98.txt')

!

test_instanceof99

    | query result |

    query := ' 
        (: Name: instanceof99 :)
(: purpose: Evaluation of "instance of" expression for pattern "decimal instance of xs:int".:)
(: insert-start :)
declare variable $input-context external;
(: insert-end :)
12678967.543233 instance of xs:int

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprInstanceOf/instanceof99.txt')

! !

!XQTSSeqExprInstanceOfTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
