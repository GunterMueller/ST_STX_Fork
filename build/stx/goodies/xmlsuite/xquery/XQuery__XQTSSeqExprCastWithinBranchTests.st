"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSSeqExprCastWithinBranchTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSSeqExprCastWithinBranchTests methodsFor:'tests'!

test_cast_within_1

    | query result |

    query := ' 
        (: name : cast-within-1 :)
(: description :Casting from integer to nonPositiveInteger.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(-10.0)
return $value cast as xs:nonPositiveInteger
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/minus10.txt')

!

test_cast_within_10

    | query result |

    query := ' 
        (: name : cast-within-10 :)
(: description : Casting from integer to byte.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:byte
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_11

    | query result |

    query := ' 
        (: name : cast-within-11 :)
(: description : Casting from integer to unsignedShort.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:unsignedShort
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_12

    | query result |

    query := ' 
        (: name : cast-within-12 :)
(: description : Casting from integer to an unsignedByte.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:unsignedByte
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_13

    | query result |

    query := ' 
        (: name : cast-within-13 :)
(: description : Casting from a long to an integer.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(10.0)
return $value cast as xs:integer
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_14

    | query result |

    query := ' 
        (: name : cast-within-14 :)
(: description : Casting from long to a nonNegativeInteger.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(10.0)
return $value cast as xs:nonNegativeInteger
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_15

    | query result |

    query := ' 
        (: name : cast-within-15 :)
(: description : Casting from long to a negativeInteger.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(-10)
return $value cast as xs:negativeInteger
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/minus10.txt')

!

test_cast_within_16

    | query result |

    query := ' 
        (: name : cast-within-16 :)
(: description : Casting from long to an int.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(10)
return $value cast as xs:int
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_17

    | query result |

    query := ' 
        (: name : cast-within-17 :)
(: description : Casting from long to an unsignedLong.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(10)
return $value cast as xs:unsignedLong
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_18

    | query result |

    query := ' 
        (: name : cast-within-18 :)
(: description : Casting from long to a positiveInteger.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(10)
return $value cast as xs:positiveInteger
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_19

    | query result |

    query := ' 
        (: name : cast-within-19 :)
(: description : Casting from long to a short.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(10)
return $value cast as xs:short
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_2

    | query result |

    query := ' 
        (: name : cast-within-2 :)
(: description : Casting from integer to long.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:long
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_20

    | query result |

    query := ' 
        (: name : cast-within-20 :)
(: description : Casting from long to unsignedInt.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(10)
return $value cast as xs:unsignedInt
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_21

    | query result |

    query := ' 
        (: name : cast-within-21 :)
(: description : Casting from long to a byte.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(10)
return $value cast as xs:byte
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_3

    | query result |

    query := ' 
        (: name : cast-within-3 :)
(: description : Casting from integer to nonNegativeInteger.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:nonNegativeInteger
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_4

    | query result |

    query := ' 
        (: name : cast-within-4 :)
(: description : Casting from integer to negativeInteger.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(-10.0)
return $value cast as xs:negativeInteger
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/minus10.txt')

!

test_cast_within_5

    | query result |

    query := ' 
        (: name : cast-within-5 :)
(: description : Casting from integer to int.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:int
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_6

    | query result |

    query := ' 
        (: name : cast-within-6 :)
(: description : Casting from integer to unsignedLong.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:unsignedLong
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_7

    | query result |

    query := ' 
        (: name : cast-within-7 :)
(: description : Casting from integer to positiveInteger.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:positiveInteger
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_8

    | query result |

    query := ' 
        (: name : cast-within-8 :)
(: description : Casting from integer to short.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:short
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

!

test_cast_within_9

    | query result |

    query := ' 
        (: name : cast-within-9 :)
(: description : Casting from integer to unsignedInt.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:unsignedInt
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastWithinBranch/value10.txt')

! !

!XQTSSeqExprCastWithinBranchTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
