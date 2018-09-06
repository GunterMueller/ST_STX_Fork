"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTScommaOpTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTScommaOpTests methodsFor:'tests'!

test_K_commaOp_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-commaOp-1                                     :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: A heavily nested sequence of expressions with the comma operator. On some implementations this triggers certain optimization paths. :)
(:*******************************************************:)
deep-equal(((1, (2, (3, 4, (5, 6)), 7), 8, (9, 10), 11)),
					      (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/K-commaOp-1.txt')

!

test_K_commaOp_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-commaOp-2                                     :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: An expression sequence containing only empty sequences. On some implementations this triggers certain optimization paths. :)
(:*******************************************************:)
empty(((), (), ((), (), ((), (), (())), ()), (), (())))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/K-commaOp-2.txt')

!

test_K_commaOp_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-commaOp-3                                     :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:36+02:00                       :)
(: Purpose: An expression sequence containing many empty sequences and one xs:string. On some implementations this triggers certain optimization paths. :)
(:*******************************************************:)
((), (), ((), (), ((), (), ("str")), ()), (), (())) eq "str"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/K-commaOp-3.txt')

!

test_constSeq_1

    | query result |

    query := ' 
        (: Name: constSeq-1 :)
(: Description: Constructing sequences.  Constructing a sequence, where one of the members is an addition operation:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1, 1 + 1, 3, 4, 5)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-1.txt')

!

test_constSeq_10

    | query result |

    query := ' 
        (: Name: constSeq-10:)
(: Description: Constructing sequences.  Constructing a sequence, where both members contains invocation to "fn:not()" function.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(fn:not("true"),fn:not("false"))
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-10.txt')

!

test_constSeq_11

    | query result |

    query := ' 
        (: Name: constSeq-11:)
(: Description: Constructing sequences.  Constructing a sequence, where one of its members contains a boolean (and) operation.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(fn:true() and fn:true(), fn:true())
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-11.txt')

!

test_constSeq_12

    | query result |

    query := ' 
        (: Name: constSeq-12:)
(: Description: Constructing sequences.  Constructing a sequence, where one of its members contains a boolean (or) operation.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(fn:true() or fn:true(), fn:true())
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-12.txt')

!

test_constSeq_13

    | query result |

    query := ' 
        (: Name: constSeq-13:)
(: Description: Constructing sequences.  Constructing a sequence, where one of its members contains invocation to "xs:string()".:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:string("ABC"), "D", "E")
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-13.txt')

!

test_constSeq_14

    | query result |

    query := ' 
        (: Name: constSeq-14:)
(: Description: Constructing sequences.  Constructing a sequence, where one of its members contains invocation to "xs:integer".:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:integer(1), 2, 3)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-14.txt')

!

test_constSeq_15

    | query result |

    query := ' 
        (: Name: constSeq-15:)
(: Description: Constructing sequences.  Constructing a sequence, where one of its members contains invocation to "xs:decimal()".:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:decimal(1), 2, 3)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-15.txt')

!

test_constSeq_16

    | query result |

    query := ' 
        (: Name: constSeq-16:)
(: Description: Constructing sequences.  Constructing a sequence, where both of its members contains invocation to "xs:anyURI".:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:anyURI("http://www.example.com"),xs:anyURI("http://www.example1.com"))
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-16.txt')

!

test_constSeq_17

    | query result |

    query := ' 
        (: Name: constSeq-17:)
(: Description: Constructing sequences.  Constructing a sequence, where one of its members contains invocation to "xs:float".:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:float(1.1), 2.2, 3.3)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-17.txt')

!

test_constSeq_18

    | query result |

    query := ' 
        (: Name: constSeq-18:)
(: Description: Constructing sequences.  Constructing a sequence, where one of its members contains invocation to "xs:double()".:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:double(1.2E2), 2.2E2, 3.3E2)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-18.txt')

!

test_constSeq_19

    | query result |

    query := ' 
        (: Name: constSeq-19:)
(: Description: Constructing sequences.  Constructing a sequence, where one of its members contains invocation to "xs:boolean()".:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:boolean(fn:true()), fn:false(), fn:true())
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-19.txt')

!

test_constSeq_2

    | query result |

    query := ' 
        (: Name: constSeq-2 :)
(: Description: Constructing sequences.  Constructing a sequence, where one of the members is subtraction operation.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1, 3 - 1, 3, 4, 5)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-2.txt')

!

test_constSeq_20

    | query result |

    query := ' 
        (: Name: constSeq-20:)
(: Description: Constructing sequences.  Constructing a sequence, where both of its members contains invocation to "xs:date()".:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:date("2004-12-25Z"),xs:date("2004-12-26Z"))
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-20.txt')

!

test_constSeq_21

    | query result |

    query := ' 
        (: Name: constSeq-21:)
(: Description: Constructing sequences.  Constructing a sequence, where both of its members contains invocation to "xs:dateTime()".:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:dateTime("1999-11-28T09:00:00Z"),xs:dateTime("1998-11-28T09:00:00Z"))
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-21.txt')

!

test_constSeq_22

    | query result |

    query := ' 
        (: Name: constSeq-22:)
(: Description: Constructing sequences.  Constructing a sequence, where both of its members contains invocation to "xs:time()".:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(xs:time("08:00:00+09:00"),xs:time("08:00:00+10:00"))
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-22.txt')

!

test_constSeq_3

    | query result |

    query := ' 
        (: Name: constSeq-3 :)
(: Description: Constructing sequences.  Constructing a sequence, where one of the members is a multiplication operation.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1, 2 * 1, 3, 4, 5)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-3.txt')

!

test_constSeq_4

    | query result |

    query := ' 
        (: Name: constSeq-4 :)
(: Description: Constructing sequences.  Constructing a sequence, where one of the members is a division (div) operation.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1, 4 div 2, 3, 4, 5)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-4.txt')

!

test_constSeq_5

    | query result |

    query := ' 
        (: Name: constSeq-5 :)
(: Description: Constructing sequences.  Constructing a sequence, where one of the members is a division (idiv) operation.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1, 4 idiv 2, 3, 4, 5)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-5.txt')

!

test_constSeq_6

    | query result |

    query := ' 
        (: Name: constSeq-6 :)
(: Description: Constructing sequences.  Constructing a sequence, where one of the members contains invocation to "fn:count" function.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1, fn:count((1, 2)), 3, 4, 5)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-6.txt')

!

test_constSeq_7

    | query result |

    query := ' 
        (: Name: constSeq-7 :)
(: Description: Constructing sequences.  Constructing a sequence, where one of the members contains invocation to "fn:string-length" function.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(1, fn:string-length("AB"), 3, 4, 5)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-7.txt')

!

test_constSeq_8

    | query result |

    query := ' 
        (: Name: constSeq-8:)
(: Description: Constructing sequences.  Constructing a sequence, where both members contains invocation to "fn:true" function.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(fn:true(),fn:true())
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-8.txt')

!

test_constSeq_9

    | query result |

    query := ' 
        (: Name: constSeq-9:)
(: Description: Constructing sequences.  Constructing a sequence, where both members contains invocation to "fn:false" function.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(fn:false(),fn:false())
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/constSeq-9.txt')

!

test_op_concatenate_mix_args_001

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-001.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1 & arg2 : sequence of number             :)
(:*******************************************************:)

(1) , (2)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-001.txt')

!

test_op_concatenate_mix_args_002

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-002.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1 & arg2 : string                         :)
(:*******************************************************:)

xs:string("a") , xs:string("b")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-002.txt')

!

test_op_concatenate_mix_args_003

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-003.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: args : string                                :)
(:*******************************************************:)

xs:string("a") , (), "xyz"

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-003.txt')

!

test_op_concatenate_mix_args_004

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-004.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: args : string                                :)
(:*******************************************************:)

"xyz" , xs:string(" "), "b"

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-004.txt')

!

test_op_concatenate_mix_args_005

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-005.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1 : string, arg2:anyURI                   :)
(:*******************************************************:)

xs:string("a") , xs:anyURI("www.example.com")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-005.txt')

!

test_op_concatenate_mix_args_006

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-006.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1 : string, arg2:integer, arg3:anyURI     :)
(:*******************************************************:)

xs:string("hello") , xs:integer("100"), xs:anyURI("www.example.com")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-006.txt')

!

test_op_concatenate_mix_args_007

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-007.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1 : anyURI, arg2: decimal                 :)
(:*******************************************************:)

xs:anyURI("www.example.com") , xs:decimal("1.01")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-007.txt')

!

test_op_concatenate_mix_args_008

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-008.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1 & arg2 : float                          :)
(:*******************************************************:)

xs:float("1.01"), xs:float("NaN")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-008.txt')

!

test_op_concatenate_mix_args_009

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-009.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1:float, arg2: double                     :)
(:*******************************************************:)

xs:float("INF") , xs:double("NaN")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-009.txt')

!

test_op_concatenate_mix_args_010

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-010.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1: double, arg2: double, arg3:float       :)
(:*******************************************************:)

xs:double("INF"), xs:double("-INF"), xs:float("-INF")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-010.txt')

!

test_op_concatenate_mix_args_011

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-011.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1:boolean, arg2: boolean, arg3: integer   :)
(:*******************************************************:)

xs:boolean("true") , xs:boolean("0"), xs:integer("0")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-011.txt')

!

test_op_concatenate_mix_args_012

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-012.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1:boolean, arg2: boolean                  :)
(:*******************************************************:)

xs:boolean("false"), xs:boolean("1")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-012.txt')

!

test_op_concatenate_mix_args_013

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-013.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1:date, arg2: boolean, arg3: string      :)
(:*******************************************************:)

xs:date("1993-03-31") , xs:boolean("true"), xs:string("abc")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-013.txt')

!

test_op_concatenate_mix_args_014

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-014.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1:dateTime, arg2: empty sequence          :)
(:*******************************************************:)

xs:dateTime("1972-12-31T00:00:00Z") , (())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-014.txt')

!

test_op_concatenate_mix_args_015

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-015.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1:time, arg2: string , arg3: decimal      :)
(:*******************************************************:)

xs:time("12:30:00Z") , xs:string(" ") , xs:decimal("2.000000000000002")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-015.txt')

!

test_op_concatenate_mix_args_016

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-016.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: arg1:empty seq, arg2: string , arg3: decimal      :)
(:*******************************************************:)

() , xs:string(" ") , xs:decimal("2.000000000000002")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-016.txt')

!

test_op_concatenate_mix_args_017

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-017.xq          :)
(: Written By: Ravindranath Chennoju                             :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: Use simple arithmetic expression with concat :)
(:*******************************************************:)

(1+1), (2-2)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-017.txt')

!

test_op_concatenate_mix_args_018

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-018.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: Concat more than two sequences               :)
(:*******************************************************:)

(1,2,2),(1,2,3),(123,""),(),("")

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-018.txt')

!

test_op_concatenate_mix_args_019

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-019.xq          :)
(: Written By: Ravindranath Chennnoju                    :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: Use an external variable with op:concatenate :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context//book/price, (), (1)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-019.txt')

!

test_op_concatenate_mix_args_020

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: op-concatenate-mix-args-020.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Thu May 12 23:38:31 2005                        :)
(: Purpose: Use two external variables with op:contenate :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context//book/price, $input-context//book/title

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqConcat/op-concatenate-mix-args-020.txt')

!

test_sequenceexpressionhc1

    | query result |

    query := ' 
        (: Name: sequenceexpressionhc1 :)
(: Description: Constructing Sequences.  Simple sequence involving integers. :)

(1,2,3,4,5)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/sequenceexpressionhc1.txt')

!

test_sequenceexpressionhc2

    | query result |

    query := ' 
        (: Name: sequenceexpressionhc2 :)
(: Description: Constructing Sequences. Simple sequence involving nested sequences. :)

(1,(2,3),4,5)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/sequenceexpressionhc2.txt')

!

test_sequenceexpressionhc3

    | query result |

    query := ' 
        (: Name: sequenceexpressionhc3 :)
(: Description: Constructing Sequences. Simple sequence involving the empty sequence. :)

(1, 2, (), 3, 4)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/sequenceexpressionhc3.txt')

!

test_sequenceexpressionhc4

    | query result |

    query := ' 
        (: Name: sequenceexpressionhc4 :)
(: Description: Constructing Sequences. Simple sequence involving the "to" operand. :)

(1, 2 to 5)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/sequenceexpressionhc4.txt')

!

test_sequenceexpressionhc5

    | query result |

    query := ' 
        (: Name: sequenceexpressionhc5 :)
(: Description: Constructing Sequences. Simple sequence involving repetition :)

(1, 2, 2)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/sequenceexpressionhc5.txt')

!

test_sequenceexpressionhc6

    | query result |

    query := ' 
        (: Name: sequenceexpressionhc6 :)
(: Description: Constructing Sequences. Simple sequence expression resulting in an empty sequence.  Uses count to avoid empty file. :)

count((15 to 10))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/sequenceexpressionhc6.txt')

!

test_sequenceexpressionhc7

    | query result |

    query := ' 
        (: Name: sequenceexpressionhc7 :)
(: Description: Constructing Sequences. Simple sequence expression that results on a sequence in reverse order :)

fn:reverse(10 to 15)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/sequenceexpressionhc7.txt')

!

test_sequenceexpressionhc8

    | query result |

    query := ' 
        (: Name: sequenceexpressionhc8 :)
(: Description: Constructing Sequences. Sequence expression resulting by quering xml file string data :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

($input-context//empnum)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/sequenceexpressionhc8.txt')

!

test_sequenceexpressionhc9

    | query result |

    query := ' 
        (: Name: sequenceexpressionhc9 :)
(: Description: Constructing Sequences. Sequence expression resulting by quering xml file string data (multiple xml sources):)

(: insert-start :)
declare variable $input-context1 external;
declare variable $input-context2 external;
(: insert-end :)

($input-context1//empnum,$input-context2//empname)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'works'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/SeqExpr/ConstructSeq/commaOp/sequenceexpressionhc9.txt')

! !

!XQTScommaOpTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
