"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSSeqUnionTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSSeqUnionTests methodsFor:'tests'!

test_fn_union_node_args_001

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-001.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: node                                    :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/bib/book[3]/title union $input-context/bib/book[1]/title

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-001.txt')

!

test_fn_union_node_args_002

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-002.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: incorrect nodes                         :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/bib/book/title | $input-context/bib/book

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-002.txt')

!

test_fn_union_node_args_003

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-003.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: node                                    :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/bib/book[3]/title | root(fn:exactly-one($input-context/bib/book[3]/title))

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-003.txt')

!

test_fn_union_node_args_004

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-004.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: text node & node                        :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/bib/book[3]/title/text() union $input-context/bib/book[1]/title

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-004.txt')

!

test_fn_union_node_args_005

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-005.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: processing-instruction node & node      :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/processing-instruction() union $input-context/bib/book[2]/title

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-005.txt')

!

test_fn_union_node_args_006

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-006.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: processing-instruction node & node      :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/processing-instruction(PI1) union $input-context/bib/book[3]/title

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-006.txt')

!

test_fn_union_node_args_007

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-007.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: comment node & node                     :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/comment() union $input-context/bib/book[1]/title

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-007.txt')

!

test_fn_union_node_args_008

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-008.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: text node & node                        :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/bib/book[3]/title/text() | $input-context/bib/book[1]/title

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-008.txt')

!

test_fn_union_node_args_009

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-009.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: processing-instruction node & node      :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/processing-instruction() | $input-context/bib/book[2]/title

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-009.txt')

!

test_fn_union_node_args_010

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-010.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: processing-instruction node & node      :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/processing-instruction(PI1) | $input-context/bib/book[3]/title

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-010.txt')

!

test_fn_union_node_args_011

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-011.xq          :)
(: Written By: Pulkita Tyagi                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: comment node & node                     :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context/comment() | $input-context/bib/book[1]/title

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-011.txt')

!

test_fn_union_node_args_012

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-012.xq          :)
(: Written By: Ravindranath Chennoju                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg:  node & non existing node                     :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context//author union $input-context//nonexisting

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-012.txt')

!

test_fn_union_node_args_013

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-013.xq          :)
(: Written By: Ravindranath Chennoju                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: node & empty sequence                     :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

$input-context//author | () 

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-013.txt')

!

test_fn_union_node_args_014

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-014.xq          :)
(: Written By: Ravindranath Chennoju                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: empty sequence & empty sequence                     :)
(:*******************************************************:)

() | ()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-014.txt')

!

test_fn_union_node_args_015

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-015.xq          :)
(: Written By: Ravindranath Chennoju                             :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: node and node                     :)
(:*******************************************************:)

(: insert-start :)
declare namespace atomic="http://www.w3.org/XQueryTest";
declare variable $input-context external;
(: insert-end :)

($input-context/atomic:root/atomic:integer) union ($input-context/atomic:root/atomic:integer)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-015.txt')

!

test_fn_union_node_args_016

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-016.xq                       :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: node & node                     :)
(:*******************************************************:)

(: insert-start :)
declare namespace atomic="http://www.w3.org/XQueryTest";
declare variable $input-context1 external;
(: insert-end :)

($input-context1/atomic:root/atomic:integer) union ($input-context1/atomic:root/atomic:integer)


      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-016.txt')

!

test_fn_union_node_args_017

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-017.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: node & node                     :)
(:*******************************************************:)

(: insert-start :)
declare namespace atomic="http://www.w3.org/XQueryTest";
declare variable $input-context external;
(: insert-end :)

($input-context/atomic:root/atomic:integer) | ($input-context/atomic:root/atomic:string)


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-017.txt')

!

test_fn_union_node_args_018

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-018.xq                       :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: text node & text node                     :)
(:*******************************************************:)

(: insert-start :)
declare namespace atomic="http://www.w3.org/XQueryTest";
declare variable $input-context external;
(: insert-end :)

($input-context/atomic:root/atomic:duration/text()) | ($input-context/atomic:root/atomic:duration/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-018.txt')

!

test_fn_union_node_args_019

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-019.xq                       :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: text node & text node                     :)
(:*******************************************************:)

(: insert-start :)
declare namespace atomic="http://www.w3.org/XQueryTest";
declare variable $input-context external;
(: insert-end :)

($input-context/atomic:root/atomic:date/text()) | ($input-context/atomic:root/atomic:date/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-019.txt')

!

test_fn_union_node_args_020

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-020.xq                       :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: text node & text node                     :)
(:*******************************************************:)

(: insert-start :)
declare namespace atomic="http://www.w3.org/XQueryTest";
declare variable $input-context external;
(: insert-end :)

($input-context/atomic:root/atomic:base64Binary/text()) | ($input-context/atomic:root/atomic:base64Binary/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-020.txt')

!

test_fn_union_node_args_021

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-021.xq                       :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: text node & text node                     :)
(:*******************************************************:)

(: insert-start :)
declare namespace atomic="http://www.w3.org/XQueryTest";
declare variable $input-context external;
(: insert-end :)

($input-context/atomic:root/atomic:QName/text()) | ($input-context/atomic:root/atomic:QName/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-021.txt')

!

test_fn_union_node_args_022

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-022.xq                       :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: text node & text node                     :)
(:*******************************************************:)

(: insert-start :)
declare namespace atomic="http://www.w3.org/XQueryTest";
declare variable $input-context external;
(: insert-end :)

($input-context/atomic:root/atomic:idrefs/text()) | ($input-context/atomic:root/atomic:idrefs/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-022.txt')

!

test_fn_union_node_args_023

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: fn-union-node-args-023.xq                       :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Tue May 24 03:34:54 2005                        :)
(: Purpose: arg: node & node                     :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $node in 
(($input-context//price/text()) , ($input-context//price/text())) union
(($input-context//price/text()) , ($input-context//price/text()))
return <a> {$node} </a>


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'bib2'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/SeqOp/SeqUnion/fn-union-node-args-023.txt')

! !

!XQTSSeqUnionTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
