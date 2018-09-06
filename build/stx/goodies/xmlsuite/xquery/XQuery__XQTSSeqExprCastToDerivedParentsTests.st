"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSSeqExprCastToDerivedParentsTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSSeqExprCastToDerivedParentsTests methodsFor:'tests'!

test_cast_to_parent_1

    | query result |

    query := ' 
        (: name : cast-to-parent-1 :)
(: description :Casting from decimal to float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:decimal(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

    "Modified: / 27-10-2009 / 12:32:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_cast_to_parent_10

    | query result |

    query := ' 
        (: name : cast-to-parent-10 :)
(: description : Casting from a shortto a float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:short(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

    "Modified: / 27-10-2009 / 12:32:31 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_cast_to_parent_11

    | query result |

    query := ' 
        (: name : cast-to-parent-11 :)
(: description : Casting from an unsignedInt to a float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:unsignedInt(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

!

test_cast_to_parent_12

    | query result |

    query := ' 
        (: name : cast-to-parent-12 :)
(: description : Casting from an unsignedShort to a float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:unsignedShort(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

!

test_cast_to_parent_13

    | query result |

    query := ' 
        (: name : cast-to-parent-13 :)
(: description : Casting from an unsignedByte to a float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:unsignedByte(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

!

test_cast_to_parent_14

    | query result |

    query := ' 
        (: name : cast-to-parent-14 :)
(: description : Casting from a byte to a float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:byte(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

!

test_cast_to_parent_15

    | query result |

    query := ' 
        (: name : cast-to-parent-15 :)
(: description : Casting from a decimal to a double.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:decimal(10E2)
return $value cast as xs:double
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/thousand.txt')

!

test_cast_to_parent_16

    | query result |

    query := ' 
        (: name : cast-to-parent-16 :)
(: description : Casting from an integer to a double.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10E2)
return $value cast as xs:double
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/thousand.txt')

!

test_cast_to_parent_17

    | query result |

    query := ' 
        (: name : cast-to-parent-17 :)
(: description : Casting from a positiveInteger to a double.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:positiveInteger(10E2)
return $value cast as xs:double
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/thousand.txt')

!

test_cast_to_parent_18

    | query result |

    query := ' 
        (: name : cast-to-parent-18 :)
(: description : Casting from a long to a double.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(10E2)
return $value cast as xs:double
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/thousand.txt')

!

test_cast_to_parent_19

    | query result |

    query := ' 
        (: name : cast-to-parent-19 :)
(: description : Casting from an int to a double.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:int(10E2)
return $value cast as xs:double
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/thousand.txt')

!

test_cast_to_parent_2

    | query result |

    query := ' 
        (: name : cast-parent-2 :)
(: description : Casting from intger to float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:integer(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

!

test_cast_to_parent_20

    | query result |

    query := ' 
        (: name : cast-to-parent-20 :)
(: description : Casting from an unsignedLong to a double.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:unsignedLong(10E2)
return $value cast as xs:double
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/thousand.txt')

!

test_cast_to_parent_21

    | query result |

    query := ' 
        (: name : cast-to-parent-21 :)
(: description : Casting from a short to a double.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:short(10E2)
return $value cast as xs:double
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/thousand.txt')

!

test_cast_to_parent_3

    | query result |

    query := ' 
        (: name : cast-to-parent-3 :)
(: description : Casting from nonPositiveInteger to float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:nonPositiveInteger(-10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/minus10.txt')

!

test_cast_to_parent_4

    | query result |

    query := ' 
        (: name : cast-to-parent-4 :)
(: description : Casting from long to float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:long(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

!

test_cast_to_parent_5

    | query result |

    query := ' 
        (: name : cast-to-parent-5 :)
(: description : Casting from nonNegativeInteger to float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:nonNegativeInteger(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

!

test_cast_to_parent_6

    | query result |

    query := ' 
        (: name : cast-to-parent-6 :)
(: description : Casting from a negativeInteger to a float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:negativeInteger(-10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/minus10.txt')

!

test_cast_to_parent_7

    | query result |

    query := ' 
        (: name : cast-to-parent-7 :)
(: description : Casting from an int to a float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:int(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

!

test_cast_to_parent_8

    | query result |

    query := ' 
        (: name : cast-to-parent-8 :)
(: description : Casting from an unsignedLong to a float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:unsignedLong(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

!

test_cast_to_parent_9

    | query result |

    query := ' 
        (: name : cast-to-parent-9 :)
(: description : Casting from a positiveInteger to a float.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $value := xs:positiveInteger(10.0)
return $value cast as xs:float
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastToDerivedParents/value10.txt')

! !

!XQTSSeqExprCastToDerivedParentsTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
