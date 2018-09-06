"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSSequenceTypeSyntaxTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSSequenceTypeSyntaxTests methodsFor:'tests'!

test_sequence_type_1

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: sequence-type-1                                  :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance of :)
(: and integers.                                         :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1,2,3) instance of xs:integer*

      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

    "Modified: / 08-03-2009 / 20:19:08 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_sequence_type_10

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-10                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using castable :)
(: and integer. uses "integer?" on sequence of two integers.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1,2) castable as xs:integer?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/falsevalue.txt')

!

test_sequence_type_11

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-11                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using castable :)
(: and double. uses "double?" on sequence of one double.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1E3) castable as xs:double?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

!

test_sequence_type_12

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-12                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using castable :)
(: and double. uses "double?" on sequence of two doubles.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1E3,2E3) castable as xs:double?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/falsevalue.txt')

!

test_sequence_type_13

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-13                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using castable :)
(: and decimal. uses "decimal?" on sequence of one decimal.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1.2) castable as xs:decimal?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

!

test_sequence_type_14

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-14                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using castable :)
(: and decimal. uses "decimal?" on sequence of two decimals.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1.2,2.1) castable as xs:decimal?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/falsevalue.txt')

!

test_sequence_type_15

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-15                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using castable :)
(: and string. uses "string?" on sequence of one string.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

("abc") castable as xs:string?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

!

test_sequence_type_16

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-16                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using castable :)
(: and string. uses "string?" on sequence of two strings.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

("abc","def") castable as xs:string?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/falsevalue.txt')

!

test_sequence_type_17

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-17                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using castable :)
(: and integer. uses "integer?" on sequence of one string.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

("abc") castable as xs:integer?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/falsevalue.txt')

!

test_sequence_type_18

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-18                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using castable :)
(: and integer. uses "integer?" on sequence of two strings.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

("abc","def") castable as xs:integer?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/falsevalue.txt')

!

test_sequence_type_19

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-19                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance :)
(: and boolean. uses "boolean*" on sequence of two booleans.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(fn:true(),fn:false()) instance of xs:boolean*
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

!

test_sequence_type_2

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-2                                  :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance of :)
(: and doubles.                                         :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1E3,2E3,3E3) instance of xs:double*

      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

!

test_sequence_type_20

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-20                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance :)
(: and boolean. uses "boolean?" on sequence of two booleans.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(fn:true(),fn:false()) instance of xs:boolean?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/falsevalue.txt')

!

test_sequence_type_21

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-21                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance :)
(: and boolean. uses "boolean+" on sequence of two booleans.:)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(fn:true(),fn:false()) instance of xs:boolean+
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

!

test_sequence_type_3

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-3                                  :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance of :)
(: and decimal.                                          :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1.1,3.2,4.5) instance of xs:decimal*

      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

!

test_sequence_type_4

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-4                                  :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance of :)
(: and string.                                          :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

("ab","cde","fgh") instance of xs:string*

      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

!

test_sequence_type_5

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-5                                  :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance of :)
(: and strings. uses "integer*" on string sequence.       :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

("ab","cde","fgh") instance of xs:integer*

      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/falsevalue.txt')

!

test_sequence_type_6

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-6                                  :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance of :)
(: and string. uses "integer?".                          :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1) instance of xs:integer?

      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

!

test_sequence_type_7

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-7                                  :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance of :)
(: and integer. uses "integer?".                         :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1,2) instance of xs:integer?

      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/falsevalue.txt')

!

test_sequence_type_8

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-8                                  :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using instance of :)
(: and integer. uses "integer+".                         :)
(:*******************************************************:)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1,2) instance of xs:integer+
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

!

test_sequence_type_9

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: sequence-type-9                                  :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluate simple sequence type using castable :)
(: and integer. uses "integer?".                         :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(2) castable as xs:integer?
      
'.

    self xqtxBind: 'input-context1' toContentsOf: 'emptydoc'.

   result  := interpreter evaluate: query.

   self
        assert:
           (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Basics/Types/SequenceTypeSyntax/truevalue.txt')

! !

!XQTSSequenceTypeSyntaxTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
