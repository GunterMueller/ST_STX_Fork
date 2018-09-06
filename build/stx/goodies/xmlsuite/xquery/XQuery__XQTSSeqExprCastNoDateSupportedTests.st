"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSSeqExprCastNoDateSupportedTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSSeqExprCastNoDateSupportedTests methodsFor:'tests'!

test_CastAs001

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs001:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:50-07:00:)
(:Purpose:Try casting xs:untypedAtomic(INF) to xs:untypedAtomic:)
(:*******************************************************:)

xs:untypedAtomic("INF") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs001.txt')

!

test_CastAs002

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs002:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:50-07:00:)
(:Purpose:Try casting xs:untypedAtomic(0.0E0) to xs:untypedAtomic:)
(:*******************************************************:)

xs:untypedAtomic("0.0E0") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs002.txt')

!

test_CastAs003

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs003:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:50-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:untypedAtomic:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs003.txt')

!

test_CastAs004

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs004:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:50-07:00:)
(:Purpose:Try casting xs:untypedAtomic(INF) to xs:string:)
(:*******************************************************:)

xs:untypedAtomic("INF") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs004.txt')

!

test_CastAs005

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs005:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:50-07:00:)
(:Purpose:Try casting xs:untypedAtomic(0.0E0) to xs:string:)
(:*******************************************************:)

xs:untypedAtomic("0.0E0") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs005.txt')

!

test_CastAs006

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs006:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:50-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:string:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs006.txt')

!

test_CastAs007

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs007:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:50-07:00:)
(:Purpose:Try casting xs:untypedAtomic(-0.0E0) to xs:float:)
(:*******************************************************:)

xs:untypedAtomic("-0.0E0") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs007.txt')

!

test_CastAs008

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs008:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(NaN) to xs:float:)
(:*******************************************************:)

xs:untypedAtomic("NaN") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs008.txt')

!

test_CastAs009

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs009:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(1e-5) to xs:float:)
(:*******************************************************:)

xs:untypedAtomic("1e-5") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs009.txt')

!

test_CastAs010

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs010:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(-10000000) to xs:float:)
(:*******************************************************:)

xs:untypedAtomic("-10000000") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs010.txt')

!

test_CastAs011

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs011:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:float:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs012

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs012:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(-0.0E0) to xs:double:)
(:*******************************************************:)

xs:untypedAtomic("-0.0E0") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs012.txt')

!

test_CastAs013

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs013:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(NaN) to xs:double:)
(:*******************************************************:)

xs:untypedAtomic("NaN") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs013.txt')

!

test_CastAs014

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs014:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(1e-5) to xs:double:)
(:*******************************************************:)

xs:untypedAtomic("1e-5") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs014.txt')

!

test_CastAs015

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs015:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(-10000000) to xs:double:)
(:*******************************************************:)

xs:untypedAtomic("-10000000") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs015.txt')

!

test_CastAs016

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs016:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:double:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs017

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs017:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(-0.0E0) to xs:decimal:)
(:*******************************************************:)

xs:untypedAtomic("-0.0E0") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs018

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs018:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(NaN) to xs:decimal:)
(:*******************************************************:)

xs:untypedAtomic("NaN") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs019

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs019:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(1e-5) to xs:decimal:)
(:*******************************************************:)

xs:untypedAtomic("1e-5") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs020

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs020:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(5.5432) to xs:decimal:)
(:*******************************************************:)

xs:untypedAtomic("5.5432") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs020.txt')

!

test_CastAs021

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs021:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:decimal:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs022

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs022:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(-0.0E0) to xs:integer:)
(:*******************************************************:)

xs:untypedAtomic("-0.0E0") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs023

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs023:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(NaN) to xs:integer:)
(:*******************************************************:)

xs:untypedAtomic("NaN") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs024

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs024:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(1e-5) to xs:integer:)
(:*******************************************************:)

xs:untypedAtomic("1e-5") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs025

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs025:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(-1.1234) to xs:integer:)
(:*******************************************************:)

xs:untypedAtomic("-1.1234") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs026

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs026:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:integer:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs070

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs070:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(0.0) to xs:boolean:)
(:*******************************************************:)

xs:untypedAtomic("0.0") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs071

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs071:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(0) to xs:boolean:)
(:*******************************************************:)

xs:untypedAtomic("0") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs071.txt')

!

test_CastAs072

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs072:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:boolean:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs072.txt')

!

test_CastAs080

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs080:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:untypedAtomic(-0012-05:00) to xs:anyURI:)
(:*******************************************************:)

xs:untypedAtomic("http://www.example.com/~b%C3%A9b%C3%A9") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs080.txt')

!

test_CastAs081

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs081:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:anyURI:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs081.txt')

!

test_CastAs082

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs082:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:untypedAtomic(http://www.ietf.org/rfc/rfc2396.txt) to xs:anyURI:)
(:*******************************************************:)

xs:untypedAtomic("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs082.txt')

!

test_CastAs083

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs083:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(INF) to xs:untypedAtomic:)
(:*******************************************************:)

xs:string("INF") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs083.txt')

!

test_CastAs084

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs084:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(0.0E0) to xs:untypedAtomic:)
(:*******************************************************:)

xs:string("0.0E0") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs084.txt')

!

test_CastAs085

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs085:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(true) to xs:untypedAtomic:)
(:*******************************************************:)

xs:string("true") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs085.txt')

!

test_CastAs086

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs086:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(INF) to xs:string:)
(:*******************************************************:)

xs:string("INF") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs086.txt')

!

test_CastAs087

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs087:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(0.0E0) to xs:string:)
(:*******************************************************:)

xs:string("0.0E0") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs087.txt')

!

test_CastAs088

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs088:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(true) to xs:string:)
(:*******************************************************:)

xs:string("true") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs088.txt')

!

test_CastAs089

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs089:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(-0.0E0) to xs:float:)
(:*******************************************************:)

xs:string("-0.0E0") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs089.txt')

!

test_CastAs090

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs090:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(NaN) to xs:float:)
(:*******************************************************:)

xs:string("NaN") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs090.txt')

!

test_CastAs091

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs091:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(1e-5) to xs:float:)
(:*******************************************************:)

xs:string("1e-5") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs091.txt')

!

test_CastAs092

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs092:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(-10000000) to xs:float:)
(:*******************************************************:)

xs:string("-10000000") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs092.txt')

!

test_CastAs093

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs093:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(true) to xs:float:)
(:*******************************************************:)

xs:string("true") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs094

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs094:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(-0.0E0) to xs:double:)
(:*******************************************************:)

xs:string("-0.0E0") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs094.txt')

!

test_CastAs095

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs095:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(NaN) to xs:double:)
(:*******************************************************:)

xs:string("NaN") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs095.txt')

!

test_CastAs096

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs096:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(1e-5) to xs:double:)
(:*******************************************************:)

xs:string("1e-5") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs096.txt')

!

test_CastAs097

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs097:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(-10000000) to xs:double:)
(:*******************************************************:)

xs:string("-10000000") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs097.txt')

!

test_CastAs098

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs098:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(true) to xs:double:)
(:*******************************************************:)

xs:string("true") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs099

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs099:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(-0.0E0) to xs:decimal:)
(:*******************************************************:)

xs:string("-0.0E0") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs100

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs100:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(NaN) to xs:decimal:)
(:*******************************************************:)

xs:string("NaN") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs101

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs101:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(1e-5) to xs:decimal:)
(:*******************************************************:)

xs:string("1e-5") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs102

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs102:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(5.5432) to xs:decimal:)
(:*******************************************************:)

xs:string("5.5432") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs102.txt')

!

test_CastAs103

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs103:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(true) to xs:decimal:)
(:*******************************************************:)

xs:string("true") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs104

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs104:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(-0.0E0) to xs:integer:)
(:*******************************************************:)

xs:string("-0.0E0") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs105

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs105:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(NaN) to xs:integer:)
(:*******************************************************:)

xs:string("NaN") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs106

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs106:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(1e-5) to xs:integer:)
(:*******************************************************:)

xs:string("1e-5") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs107

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs107:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(-1.1234) to xs:integer:)
(:*******************************************************:)

xs:string("-1.1234") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs108

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs108:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(true) to xs:integer:)
(:*******************************************************:)

xs:string("true") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs152

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs152:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:string(0.0) to xs:boolean:)
(:*******************************************************:)

xs:string("0.0") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs153

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs153:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:string(0) to xs:boolean:)
(:*******************************************************:)

xs:string("0") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs153.txt')

!

test_CastAs154

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs154:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:string(true) to xs:boolean:)
(:*******************************************************:)

xs:string("true") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs154.txt')

!

test_CastAs162

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs162:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:string(-0012-05:00) to xs:anyURI:)
(:*******************************************************:)

xs:string("http://www.example.com/~b%C3%A9b%C3%A9") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs162.txt')

!

test_CastAs163

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs163:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:string(true) to xs:anyURI:)
(:*******************************************************:)

xs:string("true") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs163.txt')

!

test_CastAs164

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs164:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:string(http://www.ietf.org/rfc/rfc2396.txt) to xs:anyURI:)
(:*******************************************************:)

xs:string("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs164.txt')

!

test_CastAs165

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs165:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(1e5) to xs:untypedAtomic:)
(:*******************************************************:)

xs:float("1e5") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs165.txt')

!

test_CastAs166

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs166:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(-INF) to xs:untypedAtomic:)
(:*******************************************************:)

xs:float("-INF") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs166.txt')

!

test_CastAs167

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs167:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(-0.0E0) to xs:string:)
(:*******************************************************:)

xs:float("-0.0E0") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs167.txt')

!

test_CastAs168

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs168:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(NaN) to xs:string:)
(:*******************************************************:)

xs:float("NaN") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs168.txt')

!

test_CastAs169

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs169:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(5.4321E-100) to xs:float:)
(:*******************************************************:)

xs:float("5.4321E-100") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs169.txt')

!

test_CastAs170

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs170:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(-1.75e-3) to xs:float:)
(:*******************************************************:)

xs:float("-1.75e-3") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs170.txt')

!

test_CastAs171

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs171:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(INF) to xs:float:)
(:*******************************************************:)

xs:float("INF") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs171.txt')

!

test_CastAs172

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs172:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(-0.0E0) to xs:double:)
(:*******************************************************:)

xs:float("-0.0E0") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs172.txt')

!

test_CastAs173

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs173:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(-INF) to xs:double:)
(:*******************************************************:)

xs:float("-INF") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs173.txt')

!

test_CastAs174

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs174:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(-0.0E0) to xs:decimal:)
(:*******************************************************:)

xs:float("-0.0E0") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs174.txt')

!

test_CastAs175

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs175:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(5.4321E-100) to xs:decimal:)
(:*******************************************************:)

xs:float("5.4321E-100") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs175.txt')

!

test_CastAs176

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs176:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(1e5) to xs:decimal:)
(:*******************************************************:)

xs:float("1e5") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs176.txt')

!

test_CastAs177

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs177:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(-1.75e-3) to xs:decimal:)
(:*******************************************************:)

round-half-to-even(xs:float("-1.75e-3") cast as xs:decimal,5)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs177.txt')

!

test_CastAs178

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs178:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(-0.0E0) to xs:integer:)
(:*******************************************************:)

xs:float("-0.0E0") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs178.txt')

!

test_CastAs179

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs179:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(1e5) to xs:integer:)
(:*******************************************************:)

xs:float("1e5") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs179.txt')

!

test_CastAs180

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs180:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(INF) to xs:integer:)
(:*******************************************************:)

xs:float("INF") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs192

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs192:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(-0.0E0) to xs:boolean:)
(:*******************************************************:)

xs:float("-0.0E0") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs192.txt')

!

test_CastAs193

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs193:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(1e5) to xs:boolean:)
(:*******************************************************:)

xs:float("1e5") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs193.txt')

!

test_CastAs194

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs194:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(-INF) to xs:boolean:)
(:*******************************************************:)

xs:float("-INF") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs194.txt')

!

test_CastAs195

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs195:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(NaN) to xs:boolean:)
(:*******************************************************:)

xs:float("NaN") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs195.txt')

!

test_CastAs198

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs198:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(5.4321E-100) to xs:anyURI:)
(:*******************************************************:)

xs:float("5.4321E-100") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs199

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs199:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(1e5) to xs:untypedAtomic:)
(:*******************************************************:)

xs:double("1e5") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs199.txt')

!

test_CastAs200

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs200:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(INF) to xs:untypedAtomic:)
(:*******************************************************:)

xs:double("INF") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs200.txt')

!

test_CastAs201

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs201:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(1e8) to xs:string:)
(:*******************************************************:)

xs:double("1e8") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs201.txt')

!

test_CastAs202

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs202:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(INF) to xs:string:)
(:*******************************************************:)

xs:double("INF") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs202.txt')

!

test_CastAs203

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs203:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(-0.0E0) to xs:float:)
(:*******************************************************:)

xs:double("-0.0E0") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs203.txt')

!

test_CastAs204

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs204:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(5.4321E-1001) to xs:float:)
(:*******************************************************:)

xs:double("5.4321E-1001") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs204.txt')

!

test_CastAs205

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs205:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(1e5) to xs:float:)
(:*******************************************************:)

xs:double("1e5") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs205.txt')

!

test_CastAs206

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs206:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(-1.75e-3) to xs:float:)
(:*******************************************************:)

xs:double("-1.75e-3") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs206.txt')

!

test_CastAs207

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs207:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(NaN) to xs:float:)
(:*******************************************************:)

xs:double("NaN") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs207.txt')

!

test_CastAs208

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs208:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(1e5) to xs:double:)
(:*******************************************************:)

xs:double("1e5") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs208.txt')

!

test_CastAs209

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs209:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(INF) to xs:double:)
(:*******************************************************:)

xs:double("INF") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs209.txt')

!

test_CastAs210

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs210:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(-0.0E0) to xs:decimal:)
(:*******************************************************:)

xs:double("-0.0E0") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs210.txt')

!

test_CastAs211

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs211:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(5.4321E-1001) to xs:decimal:)
(:*******************************************************:)

xs:double("5.4321E-1001") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs211.txt')

!

test_CastAs212

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs212:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(-1.75e-3) to xs:decimal:)
(:*******************************************************:)

round-half-to-even(xs:double("-1.75e-3") cast as xs:decimal,5)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs212.txt')

!

test_CastAs213

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs213:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(INF) to xs:decimal:)
(:*******************************************************:)

xs:double("INF") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs214

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs214:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(-0.0E0) to xs:integer:)
(:*******************************************************:)

xs:double("-0.0E0") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs214.txt')

!

test_CastAs215

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs215:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(1e5) to xs:integer:)
(:*******************************************************:)

xs:double("1e5") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs215.txt')

!

test_CastAs216

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs216:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(-1.75e-3) to xs:integer:)
(:*******************************************************:)

xs:double("-1.75e-3") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs216.txt')

!

test_CastAs217

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs217:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(INF) to xs:integer:)
(:*******************************************************:)

xs:double("INF") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs218

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs218:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:double(NaN) to xs:integer:)
(:*******************************************************:)

xs:double("NaN") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs230

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs230:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:double(1e5) to xs:boolean:)
(:*******************************************************:)

xs:double("1e5") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs230.txt')

!

test_CastAs233

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs233:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:double(1e5) to xs:anyURI:)
(:*******************************************************:)

xs:double("1e5") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs234

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs234:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:untypedAtomic:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs234.txt')

!

test_CastAs235

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs235:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:string:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs235.txt')

!

test_CastAs236

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs236:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:float:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs236.txt')

!

test_CastAs237

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs237:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:double:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs237.txt')

!

test_CastAs238

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs238:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:decimal:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs238.txt')

!

test_CastAs239

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs239:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:integer:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs239.txt')

!

test_CastAs240

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs240:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(5.5432) to xs:integer:)
(:*******************************************************:)

xs:decimal("5.5432") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs240.txt')

!

test_CastAs252

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs252:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:boolean:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs252.txt')

!

test_CastAs255

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs255:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:anyURI:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs256

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs256:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(1) to xs:untypedAtomic:)
(:*******************************************************:)

xs:integer("1") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs256.txt')

!

test_CastAs257

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs257:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(-100) to xs:string:)
(:*******************************************************:)

xs:integer("-100") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs257.txt')

!

test_CastAs258

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs258:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(-100) to xs:float:)
(:*******************************************************:)

xs:integer("-100") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs258.txt')

!

test_CastAs259

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs259:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(-100) to xs:double:)
(:*******************************************************:)

xs:integer("-100") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs259.txt')

!

test_CastAs260

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs260:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(-100) to xs:decimal:)
(:*******************************************************:)

xs:integer("-100") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs260.txt')

!

test_CastAs261

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs261:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(-100) to xs:integer:)
(:*******************************************************:)

xs:integer("-100") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs261.txt')

!

test_CastAs273

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs273:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(-100) to xs:boolean:)
(:*******************************************************:)

xs:integer("-100") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs273.txt')

!

test_CastAs276

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs276:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(-100) to xs:anyURI:)
(:*******************************************************:)

xs:integer("-100") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs550

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs550:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:untypedAtomic:)
(:*******************************************************:)

xs:boolean("true") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs550.txt')

!

test_CastAs551

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs551:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:string:)
(:*******************************************************:)

xs:boolean("true") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs551.txt')

!

test_CastAs552

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs552:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:float:)
(:*******************************************************:)

xs:boolean("true") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs552.txt')

!

test_CastAs553

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs553:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(false) to xs:float:)
(:*******************************************************:)

xs:boolean("false") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs553.txt')

!

test_CastAs554

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs554:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:double:)
(:*******************************************************:)

xs:boolean("true") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs554.txt')

!

test_CastAs555

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs555:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(false) to xs:double:)
(:*******************************************************:)

xs:boolean("false") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs555.txt')

!

test_CastAs556

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs556:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:decimal:)
(:*******************************************************:)

xs:boolean("true") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs556.txt')

!

test_CastAs557

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs557:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(false) to xs:decimal:)
(:*******************************************************:)

xs:boolean("false") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs557.txt')

!

test_CastAs558

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs558:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:integer:)
(:*******************************************************:)

xs:boolean("true") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs558.txt')

!

test_CastAs559

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs559:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(false) to xs:integer:)
(:*******************************************************:)

xs:boolean("false") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs559.txt')

!

test_CastAs571

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs571:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:boolean:)
(:*******************************************************:)

xs:boolean("true") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs571.txt')

!

test_CastAs572

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs572:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(false) to xs:boolean:)
(:*******************************************************:)

xs:boolean("false") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs572.txt')

!

test_CastAs575

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs575:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:anyURI:)
(:*******************************************************:)

xs:boolean("true") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs627

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs627:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:57-07:00:)
(:Purpose:Try casting xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) to xs:string:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs627.txt')

!

test_CastAs628

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs628:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:57-07:00:)
(:Purpose:Try casting xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) to xs:float:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs629

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs629:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:57-07:00:)
(:Purpose:Try casting xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) to xs:double:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs630

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs630:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:57-07:00:)
(:Purpose:Try casting xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) to xs:decimal:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs631

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs631:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:57-07:00:)
(:Purpose:Try casting xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) to xs:integer:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs643

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs643:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:57-07:00:)
(:Purpose:Try casting xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) to xs:boolean:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs646

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs646:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:57-07:00:)
(:Purpose:Try casting xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) to xs:anyURI:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs646.txt')

!

test_CastAs647

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs647                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: March 29, 2006                                   :)
(:Purpose: Evaluates casting a string into a decimal.    :)
(:may process casting or raise error. This test may have different :)
(: outcomes.                                             :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)


xs:string(2.123456789123456789) cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs647.txt')

!

test_CastAs648

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs648                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into a nonPositiveInteger.  :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)


xs:string(-20) cast as xs:nonPositiveInteger
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs648.txt')

!

test_CastAs649

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs649                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:long.   :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)


xs:string(20) cast as xs:long
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs649.txt')

!

test_CastAs650

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs650                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:nonNegativeInteger   :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)


xs:string(200) cast as xs:nonNegativeInteger
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs650.txt')

!

test_CastAs651

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs651                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:negativeInteger   :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)


xs:string(-201) cast as xs:negativeInteger
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs651.txt')

!

test_CastAs652

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs652                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:int     :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:string(20) cast as xs:int
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs652.txt')

!

test_CastAs653

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs653                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:unsignedLong :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:string(20) cast as xs:unsignedLong
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs653.txt')

!

test_CastAs654

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs654                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:positiveInteger :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:string(300) cast as xs:positiveInteger
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs654.txt')

!

test_CastAs655

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs655                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:short :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:string(30) cast as xs:short
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs655.txt')

!

test_CastAs656

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs656                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:unsignedInt :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:string(300) cast as xs:unsignedInt
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs656.txt')

!

test_CastAs657

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs657                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:byte :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:string(120) cast as xs:byte
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs657.txt')

!

test_CastAs658

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs658                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:unsignedShort :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:string(12) cast as xs:unsignedShort
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs658.txt')

!

test_CastAs659

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs659                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a string into an xs:unsignedByte :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

xs:string(12) cast as xs:unsignedByte
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs659.txt')

!

test_CastAs660

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs660                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a long into an xs:short :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

let $var := xs:long(120) cast as xs:short
return $var instance of xs:short
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_CastAs661

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs661                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 10, 2006                                    :)
(:Purpose: Evaluates casting a short into an xs:long :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

let $var := xs:short(120) cast as xs:long
return $var instance of xs:long
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_CastAs662

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs662                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 11, 2006                                    :)
(:Purpose: Evaluates casting a xs:nonPositiveInteger into an xs:negativeInteger :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

let $var := xs:nonPositiveInteger(-120) cast as xs:negativeInteger
return $var instance of xs:negativeInteger
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_CastAs663

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs663                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 11, 2006                                    :)
(:Purpose: Evaluates casting a xs:nonNegativeInteger into an xs:positiveInteger :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

let $var := xs:nonNegativeInteger(120) cast as xs:positiveInteger
return $var instance of xs:positiveInteger
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_CastAs664

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs664                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 11, 2006                                    :)
(:Purpose: Evaluates casting a xs:short into an xs:unsignedShort :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

let $var := xs:short(120) cast as xs:unsignedShort
return $var instance of xs:unsignedShort
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_CastAs665

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs665                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 11, 2006                                    :)
(:Purpose: Evaluates casting a xs:int into an xs:long :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

let $var := xs:int(120) cast as xs:long
return $var instance of xs:long
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_CastAs666

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs666                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 11, 2006                                    :)
(:Purpose: Evaluates casting a xs:long into an xs:int    :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

let $var := xs:long(120) cast as xs:int
return $var instance of xs:int
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_CastAs667

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs667                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 11, 2006                                    :)
(:Purpose: Evaluates casting a xs:unsignedShort into an xs:unsignedInt    :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

let $var := xs:unsignedShort(120) cast as xs:unsignedInt
return $var instance of xs:unsignedInt
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_CastAs668

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs668                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 11, 2006                                    :)
(:Purpose: Evaluates casting a xs:unsignedInt into an xs:unsignedShort    :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

let $var := xs:unsignedInt(120) cast as xs:unsignedShort
return $var instance of xs:unsignedShort
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_CastAs669

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test: CastAs669                                        :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 11, 2006                                    :)
(:Purpose: Evaluates casting a xs:byte into an xs:unsignedByte    :)
(:*******************************************************:)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

let $var := xs:byte(120) cast as xs:unsignedByte
return $var instance of xs:unsignedByte
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_CastFOCA0001_1

    | query result |

    query := ' 
        (: Name: CastFOCA0001:)
(: Description: casting an xs:decimal with a value to big for that type.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

xs:decimal(99e100)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastFOCA0001-1.txt')

!

test_CastFOCA0003_1

    | query result |

    query := ' 
        (: Name: CastFOCA0003:)
(: Description: casting an xs:integer with a value to big for that type.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

xs:integer(99e100)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastFOCA0003-1.txt')

!

test_K2_SeqExprCast_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-SeqExprCast-1                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Cast to xs:QName where the prefix is declared in the prolog. :)
(:*******************************************************:)
declare namespace myPrefix = "http://example.com/";
"myPrefix:ncname" cast as xs:QName eq QName("http://example.com/", "anotherPrefix:ncname")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K2-SeqExprCast-1.txt')

!

test_K2_SeqExprCast_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-SeqExprCast-2                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Casting the empty sequence to xs:QName? is ok. :)
(:*******************************************************:)
empty(() cast as xs:QName?)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K2-SeqExprCast-2.txt')

!

test_K_SeqExprCast_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Syntax: only ? is allowed as occurence indicator in "cast as" expressions. :)
(:*******************************************************:)
"string" cast as xs:string*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-10                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A non-atomic type is referenced, leading to a syntax error. :)
(:*******************************************************:)
"string" cast as item()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-12                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A non-atomic type is referenced, leading to a syntax error. :)
(:*******************************************************:)
"string" cast as attribute()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1213

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1213                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: The xs:boolean constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:boolean()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1214

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1214                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: The xs:boolean constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:boolean(
      "true"
    ,
                                                     
      "true"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1215

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1215                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:boolean constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:boolean("true")), 3, 1) instance of xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1215.txt')

!

test_K_SeqExprCast_1216

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1216                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:boolean. :)
(:*******************************************************:)
xs:boolean("

	 true

	 ")
        eq
        xs:boolean("

	 true

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1216.txt')

!

test_K_SeqExprCast_1217

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1217                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An empty string is not a valid lexical representation of xs:boolean. :)
(:*******************************************************:)
xs:boolean("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1218

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1218                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "true" . :)
(:*******************************************************:)
xs:boolean(xs:untypedAtomic(
      "true"
    )) eq xs:boolean("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1218.txt')

!

test_K_SeqExprCast_1219

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1219                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Applying fn:boolean() to a value of type xs:boolean that has the lexical value " "true" " should result in the boolean value true. :)
(:*******************************************************:)

          boolean(xs:boolean("true"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1219.txt')

!

test_K_SeqExprCast_1220

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1220                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1220.txt')

!

test_K_SeqExprCast_1221

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1221                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:boolean("true") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1221.txt')

!

test_K_SeqExprCast_1222

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1222                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1222.txt')

!

test_K_SeqExprCast_1223

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1223                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:boolean("true") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1223.txt')

!

test_K_SeqExprCast_1224

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1224                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:float is allowed and should always succeed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:float
                    ne
                  xs:float("3.4e5")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1224.txt')

!

test_K_SeqExprCast_1225

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1225                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:float as target type should always evaluate to true. :)
(:*******************************************************:)
xs:boolean("true") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1225.txt')

!

test_K_SeqExprCast_1226

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1226                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:double is allowed and should always succeed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:double
                    ne
                  xs:double("3.3e3")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1226.txt')

!

test_K_SeqExprCast_1227

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1227                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:double as target type should always evaluate to true. :)
(:*******************************************************:)
xs:boolean("true") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1227.txt')

!

test_K_SeqExprCast_1228

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1228                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:decimal is allowed and should always succeed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:decimal
                    ne
                  xs:decimal("10.01")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1228.txt')

!

test_K_SeqExprCast_1229

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1229                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:decimal as target type should always evaluate to true. :)
(:*******************************************************:)
xs:boolean("true") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1229.txt')

!

test_K_SeqExprCast_1230

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1230                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:integer is allowed and should always succeed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:integer
                    ne
                  xs:integer("6789")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1230.txt')

!

test_K_SeqExprCast_1231

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1231                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:integer as target type should always evaluate to true. :)
(:*******************************************************:)
xs:boolean("true") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1231.txt')

!

test_K_SeqExprCast_1254

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1254                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:boolean is allowed and should always succeed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:boolean
                    eq
                  xs:boolean("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1254.txt')

!

test_K_SeqExprCast_1255

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1255                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:boolean as target type should always evaluate to true. :)
(:*******************************************************:)
xs:boolean("true") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1255.txt')

!

test_K_SeqExprCast_1260

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1260                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:anyURI isn"t allowed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1261

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1261                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:anyURI as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:boolean("true") castable as xs:anyURI)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1261.txt')

!

test_K_SeqExprCast_1262

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1262                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:QName isn"t allowed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1263

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1263                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:QName as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:boolean("true") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1263.txt')

!

test_K_SeqExprCast_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-13                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A non-atomic type is referenced, leading to a syntax error. :)
(:*******************************************************:)
"string" cast as empty-sequence()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1370

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1370                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: The xs:anyURI constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:anyURI(
      "http://www.example.com/an/arbitrary/URI.ext"
    ,
                                                     
      "http://www.example.com/an/arbitrary/URI.ext"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1371

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1371                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:anyURI constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:anyURI("http://www.example.com/an/arbitrary/URI.ext")), 3, 1) instance of xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1371.txt')

!

test_K_SeqExprCast_1372

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1372                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:anyURI. :)
(:*******************************************************:)
xs:anyURI("

	 http://www.example.com/an/arbitrary/URI.ext

	 ")
        eq
        xs:anyURI("

	 http://www.example.com/an/arbitrary/URI.ext

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1372.txt')

!

test_K_SeqExprCast_1373

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1373                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An empty string is a valid lexical representation of xs:anyURI. :)
(:*******************************************************:)
xs:anyURI("")
            eq
            xs:anyURI("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1373.txt')

!

test_K_SeqExprCast_1374

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1374                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "http://www.example.com/an/arbitrary/URI.ext" . :)
(:*******************************************************:)
xs:anyURI(xs:untypedAtomic(
      "http://www.example.com/an/arbitrary/URI.ext"
    )) eq xs:anyURI("http://www.example.com/an/arbitrary/URI.ext")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1374.txt')

!

test_K_SeqExprCast_1375

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1375                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Applying fn:boolean() to a value of type xs:anyURI that has the lexical value " "http://www.example.com/an/arbitrary/URI.ext" " should result in the boolean value true. :)
(:*******************************************************:)

          boolean(xs:anyURI("http://www.example.com/an/arbitrary/URI.ext"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1375.txt')

!

test_K_SeqExprCast_1376

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1376                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1376.txt')

!

test_K_SeqExprCast_1377

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1377                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1377.txt')

!

test_K_SeqExprCast_1378

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1378                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1378.txt')

!

test_K_SeqExprCast_1379

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1379                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1379.txt')

!

test_K_SeqExprCast_1380

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1380                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:float isn"t allowed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1381

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1381                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:float as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:float)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1381.txt')

!

test_K_SeqExprCast_1382

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1382                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:double isn"t allowed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1383

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1383                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:double as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:double)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1383.txt')

!

test_K_SeqExprCast_1384

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1384                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:decimal isn"t allowed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1385

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1385                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:decimal as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:decimal)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1385.txt')

!

test_K_SeqExprCast_1386

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1386                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:integer isn"t allowed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1387

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1387                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:integer as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1387.txt')

!

test_K_SeqExprCast_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-14                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `"1" cast as xs:boolean eq true()`. :)
(:*******************************************************:)
"1" cast as xs:boolean eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-14.txt')

!

test_K_SeqExprCast_1410

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1410                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:boolean isn"t allowed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1411

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1411                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:boolean as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:boolean)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1411.txt')

!

test_K_SeqExprCast_1416

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1416                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:anyURI is allowed and should always succeed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:anyURI
                    eq
                  xs:anyURI("http://www.example.com/an/arbitrary/URI.ext")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1416.txt')

!

test_K_SeqExprCast_1417

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1417                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:anyURI as target type should always evaluate to true. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1417.txt')

!

test_K_SeqExprCast_1418

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1418                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:QName isn"t allowed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1419

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1419                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:QName as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1419.txt')

!

test_K_SeqExprCast_1421

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1421                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: The xs:QName constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:QName()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1422

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1422                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: The xs:QName constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:QName(
      "ncname"
    ,
                                                     
      "ncname"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1423

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1423                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:QName constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:QName("ncname")), 3, 1) instance of xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1423.txt')

!

test_K_SeqExprCast_1424

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1424                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:QName. :)
(:*******************************************************:)
xs:QName("

	 ncname

	 ")
        eq
        xs:QName("

	 ncname

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1424.txt')

!

test_K_SeqExprCast_1425

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1425                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An empty string is not a valid lexical representation of xs:QName. :)
(:*******************************************************:)
xs:QName("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1426

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1426                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: It is not possible to extract an Effective Boolean Value from the type xs:QName, with the boolean() function. :)
(:*******************************************************:)
boolean(xs:QName("ncname"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1427

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1427                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1427.txt')

!

test_K_SeqExprCast_1428

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1428                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:QName("ncname") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1428.txt')

!

test_K_SeqExprCast_1429

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1429                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1429.txt')

!

test_K_SeqExprCast_1430

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1430                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:QName("ncname") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1430.txt')

!

test_K_SeqExprCast_1431

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1431                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:float isn"t allowed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1432

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1432                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:float as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:QName("ncname") castable as xs:float)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1432.txt')

!

test_K_SeqExprCast_1433

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1433                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:double isn"t allowed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1434

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1434                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:double as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:QName("ncname") castable as xs:double)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1434.txt')

!

test_K_SeqExprCast_1435

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1435                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:decimal isn"t allowed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1436

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1436                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:decimal as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:QName("ncname") castable as xs:decimal)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1436.txt')

! !

!XQTSSeqExprCastNoDateSupportedTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
