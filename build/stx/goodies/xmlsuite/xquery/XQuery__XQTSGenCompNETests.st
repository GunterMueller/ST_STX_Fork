"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSGenCompNETests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSGenCompNETests methodsFor:'tests'!

test_K_GenCompNE_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompNE-10                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison causing numeric promotion from xs:untypedAtomic. :)
(:*******************************************************:)
not("2" = xs:untypedAtomic("1"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompNE/K-GenCompNE-10.txt')

!

test_K_GenCompNE_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompNE-2                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: General comparison where one or more operands is the empty sequence. :)
(:*******************************************************:)
not(() = 1 )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Operators/CompExpr/GenComprsn/GenCompNE/K-GenCompNE-2.txt')

!

test_K_GenCompNE_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-GenCompNE-6                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A syntactically invalid expression that reminds of a general comparison operator. :)
(:*******************************************************:)
1 !! 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
! !

!XQTSGenCompNETests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
