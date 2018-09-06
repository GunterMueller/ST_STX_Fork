"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSLetExprWithoutTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSLetExprWithoutTests methodsFor:'tests'!

test_K2_LetExprWithout_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-LetExprWithout-1                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: A test whose essence is: `deep-equal((<b/>, <b/>, <b/>, <b/>), (for $v1 in (1, 2, 3, 4) let $v2 := <b/> return ($v2))/.)`. :)
(:*******************************************************:)
deep-equal((<b/>, <b/>, <b/>, <b/>),
           (for $v1 in (1, 2, 3, 4)
            let $v2 := <b/>
            return ($v2))/.)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/LetExpr/LetExprWithout/K2-LetExprWithout-1.txt')

!

test_K2_LetExprWithout_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-LetExprWithout-2                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: A test whose essence is: `deep-equal((<b/>, <b/>, <b/>, <b/>), (for $v1 in (1, 2, 3, 4) let $v2 := <b/> return ($v2)))`. :)
(:*******************************************************:)
deep-equal((<b/>, <b/>, <b/>, <b/>),
            (for $v1 in (1, 2, 3, 4)
             let $v2 := <b/>
             return ($v2)))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/LetExpr/LetExprWithout/K2-LetExprWithout-2.txt')

!

test_K_LetExprWithout_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LetExprWithout-1                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A "let" variable is out-of-scope due to FLWOR has higher precendence than the comma operator. :)
(:*******************************************************:)
let $i := 5, $j := 20 * $i
return $i, $j
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_LetExprWithout_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LetExprWithout-2                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A value in a "let" variable cannot be assigned to with "=", it must be ":=". :)
(:*******************************************************:)
let $i = 5 return 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_LetExprWithout_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LetExprWithout-3                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A value in a "let" variable cannot be assigned to with "in", it must be ":=". :)
(:*******************************************************:)
let $i in 5 return 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_LetExprWithout_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-LetExprWithout-4                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A binding in a let-expression shadows global variables. :)
(:*******************************************************:)
declare variable $i := false();
declare variable $t := false();
deep-equal((let $i := true(), $t := true() return ($i, $t)),
(true(), true()))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/LetExpr/LetExprWithout/K-LetExprWithout-4.txt')

!

test_LetExpr001

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr001.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Assign a simple string using let :)
(:*******************************************************:)
let $x := "92233720368547758"
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr001.txt')

!

test_LetExpr002

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr002.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Assign a simple integer using let :)
(:*******************************************************:)
let $x := 92233720368547758
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr002.txt')

!

test_LetExpr003

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr003.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use an arithmetic operator with let :)
(:*******************************************************:)
let $x := 92233720368547758+1
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr003.txt')

!

test_LetExpr004

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr004.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use xs:long(upper bound) :)
(:*******************************************************:)
let $x := xs:long("92233720368547758")
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr004.txt')

!

test_LetExpr005

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr005.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use xs:long(lower bound) +1  :)
(:*******************************************************:)
let $x := xs:long("-92233720368547758")+1
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr005.txt')

!

test_LetExpr006

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr006.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use xs:double(upper bound) :)
(:*******************************************************:)
let $x := xs:double("1.7976931348623157E308")
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr006.txt')

!

test_LetExpr007

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr007.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : A node with an expression in curly braces :)
(:*******************************************************:)
let $x:=<a>{1+1}</a>
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr007.xml')

!

test_LetExpr008

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr008.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : More than one variable cross referencing compatible values :)
(:*******************************************************:)
let $x:=1, $y:=$x+1
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr008.txt')

!

test_LetExpr009

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr009.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : More than one variable cross referencing compatible values :)
(:*******************************************************:)
let $x:=1, $y:=<a>{$x+1}</a>
return $y

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr009.xml')

!

test_LetExpr010

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr010.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : More than one variable cross referencing incompatible values :)
(:*******************************************************:)
let $x:=(1,2,3), $y:=$x+1
return $y

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_LetExpr011

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr011.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use sequences with filter expressions :)
(:*******************************************************:)
let $x :=(1 to 100)[. mod 5 eq 0]
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr011.txt')

!

test_LetExpr012

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr012.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use sequences with filter expressions with more than one variable :)
(:*******************************************************:)
let $x :=(1 to 100)[. mod 5 eq 0], $y := $x[. mod 10 eq 0]
return $y

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr012.txt')

!

test_LetExpr013

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr013.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use a function in the let :)
(:*******************************************************:)
let $x:="hello", $y:=concat($x," there")
return $y

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr013.txt')

!

test_LetExpr014

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr014.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use incompatible types in let :)
(:*******************************************************:)
let $x := "1", $y := $x+1
return $y

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_LetExpr015

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr015.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use a sequence of different types of scalars :)
(:*******************************************************:)
let $x := (0,0.1e-1,2.0,"a","cat","",true())
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr015.txt')

!

test_LetExpr016

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr016.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use a sequence of nodes :)
(:*******************************************************:)
let $a := (<elem1/>, <elem2/>, <elem3 att="test"/>)
return <root>{$a}</root>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr016.xml')

!

test_LetExpr017

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr017.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use a sequence with step :)
(:*******************************************************:)
let $x := (<a> <b> <c> 123 </c> </b> </a>)
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr017.xml')

!

test_LetExpr018

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr018.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use a sequence of different values:)
(:*******************************************************:)
let $x := (0,0.1e-1,2.0,"a","cat","",true(), ("<a> <b> <c> 123 </c> </b> </a>")/a/b)
return $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_LetExpr019

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr019.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : combine two "Let" exprs in one "Return" :)
(:*******************************************************:)
let $a := <elem/>
let $b := <elem2/>
return ($a,$b)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr019.txt')

!

test_LetExpr020

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr020.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Use three variables  :)
(:*******************************************************:)
let $a := 1 
let $b := $a
let $c := $a+$b 
return ($c)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/LetExpr/LetExpr020.txt')

!

test_LetExpr021

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: LetExpr021.xq          :)
(: Written By: Ravindranath Chennoju                     :)
(: Date: Wed May 11 13:55:57 2005                        :)
(: Purpose : Refer to an undefined variable  :)
(:*******************************************************:)
let $a := $b 
return ($a)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
! !

!XQTSLetExprWithoutTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
