"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSSeqExprCastSupportedTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSSeqExprCastSupportedTests methodsFor:'tests'!

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

test_CastAs038

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs038:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(1999-05-31T13:20:00) to xs:dateTime:)
(:*******************************************************:)

xs:untypedAtomic("1999-05-31T13:20:00") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs038.txt')

!

test_CastAs039

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs039:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(-1999-05-31T13:20:00+14:00) to xs:dateTime:)
(:*******************************************************:)

xs:untypedAtomic("-1999-05-31T13:20:00+14:00") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs039.txt')

!

test_CastAs040

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs040:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(2000-01-16T00:00:00Z) to xs:dateTime:)
(:*******************************************************:)

xs:untypedAtomic("2000-01-16T00:00:00Z") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs040.txt')

!

test_CastAs041

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs041:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:dateTime:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs042

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs042:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(13:20:00-05:00) to xs:time:)
(:*******************************************************:)

xs:untypedAtomic("13:20:00-05:00") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs042.txt')

!

test_CastAs043

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs043:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(13:20:02.123) to xs:time:)
(:*******************************************************:)

xs:untypedAtomic("13:20:02.123") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs043.txt')

!

test_CastAs044

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs044:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(13:20:00Z) to xs:time:)
(:*******************************************************:)

xs:untypedAtomic("13:20:00Z") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs044.txt')

!

test_CastAs045

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs045:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:time:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs046

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs046:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(1999-05-31) to xs:date:)
(:*******************************************************:)

xs:untypedAtomic("1999-05-31") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs046.txt')

!

test_CastAs047

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs047:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(-0012-12-03-05:00) to xs:date:)
(:*******************************************************:)

xs:untypedAtomic("-0012-12-03-05:00") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs047.txt')

!

test_CastAs048

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs048:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(1999-05-31Z) to xs:date:)
(:*******************************************************:)

xs:untypedAtomic("1999-05-31Z") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs048.txt')

!

test_CastAs049

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs049:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:51-07:00:)
(:Purpose:Try casting xs:untypedAtomic(true) to xs:date:)
(:*******************************************************:)

xs:untypedAtomic("true") cast as xs:date
      
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

test_CastAs120

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs120:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(1999-05-31T13:20:00) to xs:dateTime:)
(:*******************************************************:)

xs:string("1999-05-31T13:20:00") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs120.txt')

!

test_CastAs121

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs121:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(-1999-05-31T13:20:00+14:00) to xs:dateTime:)
(:*******************************************************:)

xs:string("-1999-05-31T13:20:00+14:00") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs121.txt')

!

test_CastAs122

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs122:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(2000-01-16T00:00:00Z) to xs:dateTime:)
(:*******************************************************:)

xs:string("2000-01-16T00:00:00Z") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs122.txt')

!

test_CastAs123

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs123:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(true) to xs:dateTime:)
(:*******************************************************:)

xs:string("true") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs124

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs124:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(13:20:00-05:00) to xs:time:)
(:*******************************************************:)

xs:string("13:20:00-05:00") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs124.txt')

!

test_CastAs125

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs125:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(13:20:02.123) to xs:time:)
(:*******************************************************:)

xs:string("13:20:02.123") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs125.txt')

!

test_CastAs126

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs126:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(13:20:00Z) to xs:time:)
(:*******************************************************:)

xs:string("13:20:00Z") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs126.txt')

!

test_CastAs127

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs127:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(true) to xs:time:)
(:*******************************************************:)

xs:string("true") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs128

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs128:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(1999-05-31) to xs:date:)
(:*******************************************************:)

xs:string("1999-05-31") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs128.txt')

!

test_CastAs129

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs129:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(-0012-12-03-05:00) to xs:date:)
(:*******************************************************:)

xs:string("-0012-12-03-05:00") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs129.txt')

!

test_CastAs130

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs130:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(1999-05-31Z) to xs:date:)
(:*******************************************************:)

xs:string("1999-05-31Z") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs130.txt')

!

test_CastAs131

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs131:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:52-07:00:)
(:Purpose:Try casting xs:string(true) to xs:date:)
(:*******************************************************:)

xs:string("true") cast as xs:date
      
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

test_CastAs184

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs184:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(5.4321E-100) to xs:dateTime:)
(:*******************************************************:)

xs:float("5.4321E-100") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs185

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs185:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(5.4321E-100) to xs:time:)
(:*******************************************************:)

xs:float("5.4321E-100") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs186

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs186:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:53-07:00:)
(:Purpose:Try casting xs:float(5.4321E-100) to xs:date:)
(:*******************************************************:)

xs:float("5.4321E-100") cast as xs:date
      
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

test_CastAs222

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs222:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:double(1e5) to xs:dateTime:)
(:*******************************************************:)

xs:double("1e5") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs223

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs223:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:double(1e5) to xs:time:)
(:*******************************************************:)

xs:double("1e5") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs224

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs224:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:double(1e5) to xs:date:)
(:*******************************************************:)

xs:double("1e5") cast as xs:date
      
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

test_CastAs244

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs244:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:dateTime:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs245

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs245:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:time:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs246

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs246:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:decimal(-1.1234) to xs:date:)
(:*******************************************************:)

xs:decimal("-1.1234") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
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

test_CastAs265

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs265:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(-100) to xs:dateTime:)
(:*******************************************************:)

xs:integer("-100") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs266

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs266:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(-100) to xs:time:)
(:*******************************************************:)

xs:integer("-100") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs267

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs267:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:54-07:00:)
(:Purpose:Try casting xs:integer(-100) to xs:date:)
(:*******************************************************:)

xs:integer("-100") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
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

test_CastAs352

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs352:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(1999-05-31T13:20:00) to xs:untypedAtomic:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs352.txt')

!

test_CastAs353

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs353:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(-1999-05-31T13:20:00+14:00) to xs:untypedAtomic:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs353.txt')

!

test_CastAs354

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs354:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(1999-05-31T13:20:00) to xs:string:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs354.txt')

!

test_CastAs355

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs355:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(-1999-05-31T13:20:00+14:00) to xs:string:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs355.txt')

!

test_CastAs356

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs356:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(1999-05-31T13:20:00) to xs:float:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs357

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs357:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(2000-01-16T00:00:00Z) to xs:float:)
(:*******************************************************:)

xs:dateTime("2000-01-16T00:00:00Z") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs358

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs358:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(1999-05-31T13:20:00) to xs:decimal:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs359

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs359:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(1999-05-31T13:20:00) to xs:integer:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs363

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs363:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(1999-05-31T13:20:00) to xs:dateTime:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs363.txt')

!

test_CastAs364

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs364:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(1999-05-31T13:20:00) to xs:time:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs364.txt')

!

test_CastAs365

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs365:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(-1999-05-31T13:20:00+14:00) to xs:time:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs365.txt')

!

test_CastAs366

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs366:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(1999-05-31T13:20:00) to xs:date:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs366.txt')

!

test_CastAs367

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs367:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(-1999-05-31T13:20:00+14:00) to xs:date:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs367.txt')

!

test_CastAs378

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs378:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(1999-05-31T13:20:00) to xs:boolean:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs381

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs381:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:dateTime(1999-05-31T13:20:00) to xs:anyURI:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs382

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs382:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:untypedAtomic:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs382.txt')

!

test_CastAs383

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs383:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:string:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs383.txt')

!

test_CastAs384

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs384:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:float:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs385

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs385:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:double:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs386

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs386:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:decimal:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs387

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs387:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:integer:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs391

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs391:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:dateTime:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs392

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs392:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:time:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs392.txt')

!

test_CastAs393

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs393:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:02.123) to xs:time:)
(:*******************************************************:)

xs:time("13:20:02.123") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs393.txt')

!

test_CastAs394

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs394:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00Z) to xs:time:)
(:*******************************************************:)

xs:time("13:20:00Z") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs394.txt')

!

test_CastAs395

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs395:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:date:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs401

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs401:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:boolean:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs404

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs404:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:time(13:20:00-05:00) to xs:anyURI:)
(:*******************************************************:)

xs:time("13:20:00-05:00") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs405

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs405:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31) to xs:untypedAtomic:)
(:*******************************************************:)

xs:date("1999-05-31") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs405.txt')

!

test_CastAs406

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs406:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(-0012-12-03-05:00) to xs:untypedAtomic:)
(:*******************************************************:)

xs:date("-0012-12-03-05:00") cast as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs406.txt')

!

test_CastAs407

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs407:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31) to xs:string:)
(:*******************************************************:)

xs:date("1999-05-31") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs407.txt')

!

test_CastAs408

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs408:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(-0012-12-03-05:00) to xs:string:)
(:*******************************************************:)

xs:date("-0012-12-03-05:00") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs408.txt')

!

test_CastAs409

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs409:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31) to xs:float:)
(:*******************************************************:)

xs:date("1999-05-31") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs410

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs410:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31) to xs:double:)
(:*******************************************************:)

xs:date("1999-05-31") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs411

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs411:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31Z) to xs:double:)
(:*******************************************************:)

xs:date("1999-05-31Z") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs412

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs412:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31) to xs:integer:)
(:*******************************************************:)

xs:date("1999-05-31") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs416

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs416:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31) to xs:dateTime:)
(:*******************************************************:)

xs:date("1999-05-31") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs416.txt')

!

test_CastAs417

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs417:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31) to xs:time:)
(:*******************************************************:)

xs:date("1999-05-31") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs418

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs418:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31) to xs:date:)
(:*******************************************************:)

xs:date("1999-05-31") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs418.txt')

!

test_CastAs419

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs419:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(-0012-12-03-05:00) to xs:date:)
(:*******************************************************:)

xs:date("-0012-12-03-05:00") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs419.txt')

!

test_CastAs420

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs420:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31Z) to xs:date:)
(:*******************************************************:)

xs:date("1999-05-31Z") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/CastAs420.txt')

!

test_CastAs431

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs431:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31) to xs:boolean:)
(:*******************************************************:)

xs:date("1999-05-31") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs434

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs434:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:55-07:00:)
(:Purpose:Try casting xs:date(1999-05-31) to xs:anyURI:)
(:*******************************************************:)

xs:date("1999-05-31") cast as xs:anyURI
      
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

test_CastAs563

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs563:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:dateTime:)
(:*******************************************************:)

xs:boolean("true") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs564

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs564:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:time:)
(:*******************************************************:)

xs:boolean("true") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs565

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs565:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:56-07:00:)
(:Purpose:Try casting xs:boolean(true) to xs:date:)
(:*******************************************************:)

xs:boolean("true") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
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

test_CastAs635

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs635:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:57-07:00:)
(:Purpose:Try casting xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) to xs:dateTime:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs636

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs636:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:57-07:00:)
(:Purpose:Try casting xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) to xs:time:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_CastAs637

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastAs637:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:49:57-07:00:)
(:Purpose:Try casting xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) to xs:date:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") cast as xs:date
      
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

test_K_SeqExprCast_1238

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1238                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:dateTime isn"t allowed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1239

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1239                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:dateTime as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:boolean("true") castable as xs:dateTime)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1239.txt')

!

test_K_SeqExprCast_1240

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1240                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:time isn"t allowed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1241

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1241                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:time as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:boolean("true") castable as xs:time)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1241.txt')

!

test_K_SeqExprCast_1242

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1242                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:boolean to xs:date isn"t allowed. :)
(:*******************************************************:)
xs:boolean("true") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1243

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1243                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:boolean as source type and xs:date as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:boolean("true") castable as xs:date)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1243.txt')

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

test_K_SeqExprCast_1394

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1394                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:dateTime isn"t allowed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1395

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1395                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:dateTime as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:dateTime)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1395.txt')

!

test_K_SeqExprCast_1396

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1396                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:time isn"t allowed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1397

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1397                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:time as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:time)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1397.txt')

!

test_K_SeqExprCast_1398

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1398                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:anyURI to xs:date isn"t allowed. :)
(:*******************************************************:)
xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1399

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1399                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:anyURI as source type and xs:date as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:anyURI("http://www.example.com/an/arbitrary/URI.ext") castable as xs:date)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1399.txt')

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

!

test_K_SeqExprCast_1437

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1437                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:integer isn"t allowed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1438

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1438                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:integer as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:QName("ncname") castable as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1438.txt')

!

test_K_SeqExprCast_144

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-144                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(xs:decimal(remove((3e3, 1.1), 1))) eq 1.1`. :)
(:*******************************************************:)
(xs:decimal(remove((3e3, 1.1), 1))) eq 1.1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-144.txt')

!

test_K_SeqExprCast_1445

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1445                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:dateTime isn"t allowed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1446

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1446                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:dateTime as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:QName("ncname") castable as xs:dateTime)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1446.txt')

!

test_K_SeqExprCast_1447

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1447                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:time isn"t allowed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1448

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1448                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:time as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:QName("ncname") castable as xs:time)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1448.txt')

!

test_K_SeqExprCast_1449

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1449                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:date isn"t allowed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_145

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-145                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Casting where the cardinality of the source value is wrong. :)
(:*******************************************************:)
xs:decimal(remove((1, 2, 3), 1))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1450

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1450                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:date as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:QName("ncname") castable as xs:date)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1450.txt')

!

test_K_SeqExprCast_1461

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1461                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:boolean isn"t allowed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1462

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1462                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:boolean as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:QName("ncname") castable as xs:boolean)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1462.txt')

!

test_K_SeqExprCast_1467

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1467                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting from xs:QName to xs:anyURI isn"t allowed. :)
(:*******************************************************:)
xs:QName("ncname") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_1468

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1468                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:anyURI as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:QName("ncname") castable as xs:anyURI)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1468.txt')

!

test_K_SeqExprCast_1469

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-1469                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "castable as" involving xs:QName as source type and xs:QName as target type should always evaluate to true. :)
(:*******************************************************:)
xs:QName("ncname") castable as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-1469.txt')

!

test_K_SeqExprCast_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-15                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `"true" cast as xs:boolean eq true()`. :)
(:*******************************************************:)
"true" cast as xs:boolean eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-15.txt')

!

test_K_SeqExprCast_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-16                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `"false" cast as xs:boolean eq false()`. :)
(:*******************************************************:)
"false" cast as xs:boolean eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-16.txt')

!

test_K_SeqExprCast_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-17                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `"0" cast as xs:boolean eq false()`. :)
(:*******************************************************:)
"0" cast as xs:boolean eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-17.txt')

!

test_K_SeqExprCast_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-18                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `false() cast as xs:boolean eq false()`. :)
(:*******************************************************:)
false() cast as xs:boolean eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-18.txt')

!

test_K_SeqExprCast_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-19                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `not(true() cast as xs:boolean eq false())`. :)
(:*******************************************************:)
not(true() cast as xs:boolean eq false())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-19.txt')

!

test_K_SeqExprCast_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-2                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Syntax: only ? is allowed as occurence indicator in "cast as" expressions. :)
(:*******************************************************:)
"string" cast as xs:string+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-20                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:double(3)) eq true()`. :)
(:*******************************************************:)
xs:boolean(xs:double(3)) eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-20.txt')

!

test_K_SeqExprCast_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-21                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:string(1)) eq true()`. :)
(:*******************************************************:)
xs:boolean(xs:string(1)) eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-21.txt')

!

test_K_SeqExprCast_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-22                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:integer(3)) eq true()`. :)
(:*******************************************************:)
xs:boolean(xs:integer(3)) eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-22.txt')

!

test_K_SeqExprCast_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-23                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:decimal(3)) eq true()`. :)
(:*******************************************************:)
xs:boolean(xs:decimal(3)) eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-23.txt')

!

test_K_SeqExprCast_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-24                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:double(0)) eq false()`. :)
(:*******************************************************:)
xs:boolean(xs:double(0)) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-24.txt')

!

test_K_SeqExprCast_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-25                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:string(0)) eq false()`. :)
(:*******************************************************:)
xs:boolean(xs:string(0)) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-25.txt')

!

test_K_SeqExprCast_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-26                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:integer(0)) eq false()`. :)
(:*******************************************************:)
xs:boolean(xs:integer(0)) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-26.txt')

!

test_K_SeqExprCast_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-27                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:decimal(0)) eq false()`. :)
(:*******************************************************:)
xs:boolean(xs:decimal(0)) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-27.txt')

!

test_K_SeqExprCast_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-28                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:decimal(0.0)) eq false()`. :)
(:*******************************************************:)
xs:boolean(xs:decimal(0.0)) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-28.txt')

!

test_K_SeqExprCast_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-29                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(+0) eq false()`. :)
(:*******************************************************:)
xs:boolean(+0) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-29.txt')

!

test_K_SeqExprCast_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-3                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Syntax: only ? is allowed as occurence indicator in "cast as" expressions. :)
(:*******************************************************:)
"string" cast as xs:anyType*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-30                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(-0) eq false()`. :)
(:*******************************************************:)
xs:boolean(-0) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-30.txt')

!

test_K_SeqExprCast_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-31                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:double(+0)) eq false()`. :)
(:*******************************************************:)
xs:boolean(xs:double(+0)) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-31.txt')

!

test_K_SeqExprCast_310

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-310                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "+2004-08-01T12:44:05" is an invalid lexical representation, a preceding "+" sign is not allowed for xs:dateTime. :)
(:*******************************************************:)
xs:dateTime("+2004-08-01T12:44:05")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_311

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-311                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "02004-08-01T12:44:05" is an invalid lexical representation for xs:dateTime; if the year part has more than four digits, leading zeros are prohibited. :)
(:*******************************************************:)
xs:dateTime("02004-08-01T12:44:05")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_312

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-312                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "00004-08-01T12:44:05" is an invalid lexical representation for xs:dateTime; if the year part has more than four digits, leading zeros are prohibited. :)
(:*******************************************************:)
xs:dateTime("00004-08-01T12:44:05")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_313

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-313                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2004-32-01T12:44:05" is an invalid lexical representation for xs:dateTime; the month part cannot be larger than 32. :)
(:*******************************************************:)
xs:dateTime("2004-32-01T12:44:05")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_314

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-314                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-02-30T12:44:05" is a non-existent xs:dateTime date. :)
(:*******************************************************:)
xs:dateTime("2002-02-30T12:44:05")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_315

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-315                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-002-15T12:44:05" is an invalid lexical representation for xs:dateTime. :)
(:*******************************************************:)
xs:dateTime("2002-002-15T12:44:05")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_316

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-316                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-02-150T12:44:05" is an invalid lexical representation for xs:dateTime. :)
(:*******************************************************:)
xs:dateTime("2002-02-150T12:44:05")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_317

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-317                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-02-15T24:00:00.001" is an invalid lexical representation for xs:dateTime; if hour is 24, seconds part must be 00. :)
(:*******************************************************:)
xs:dateTime("2002-02-15T24:00:00.001")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_318

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-318                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-02-15T24:01:00" is an invalid lexical representation for xs:dateTime; if hour is 24, minutes part must be 00. :)
(:*******************************************************:)
xs:dateTime("2002-02-15T24:01:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_319

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-319                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-02-15T25:00:00" is an invalid lexical representation for xs:dateTime; hour part can never be larger than 24. :)
(:*******************************************************:)
xs:dateTime("2002-02-15T25:01:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-32                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:double(-0)) eq false()`. :)
(:*******************************************************:)
xs:boolean(xs:double(-0)) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-32.txt')

!

test_K_SeqExprCast_320

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-320                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-02-15T21:60:00" is an invalid lexical representation for xs:dateTime; minute part can never be larger than 59. :)
(:*******************************************************:)
xs:dateTime("2002-02-15T21:60:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_321

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-321                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-02-15T21:01:60" is an invalid lexical representation for xs:dateTime; seconds part can never be larger than 59. :)
(:*******************************************************:)
xs:dateTime("2002-02-15T21:01:60")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_322

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-322                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "--2002-02-15T21:01:23" is an invalid lexical representation for xs:dateTime. :)
(:*******************************************************:)
xs:dateTime("--2002-02-15T21:01:23")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_323

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-323                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:dateTime: the hour component cannot be -15. :)
(:*******************************************************:)
xs:dateTime("1999-12-01T23:59:12.432-15:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_324

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-324                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:dateTime: the hour component cannot be +15. :)
(:*******************************************************:)
xs:dateTime("1999-12-01T23:59:12.432+15:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_325

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-325                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:dateTime: the minute component cannot be +60. :)
(:*******************************************************:)
xs:dateTime("1999-12-01T23:59:12.432+10:60")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_326

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-326                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:dateTime: the minute component cannot be -60. :)
(:*******************************************************:)
xs:dateTime("1999-12-01T23:59:12.432-10:60")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_327

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-327                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:dateTime: the minute field must always be present. :)
(:*******************************************************:)
xs:dateTime("1999-12-01T23:59:12.999-00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-33                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(0.0E0) eq false()`. :)
(:*******************************************************:)
xs:boolean(0.0E0) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-33.txt')

!

test_K_SeqExprCast_338

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-338                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Simple test of casting a xs:dateTime with UTC timezone to xs:date. :)
(:*******************************************************:)

		   xs:date(xs:dateTime("2002-11-23T22:12:23.867-00:00")) eq xs:date("2002-11-23Z")
	
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-338.txt')

!

test_K_SeqExprCast_339

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-339                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Simple test of casting a xs:dateTime with UTC offset to xs:date. :)
(:*******************************************************:)

		   xs:date(xs:dateTime("2002-11-23T22:12:23.867-13:37")) eq xs:date("2002-11-23-13:37")
	
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-339.txt')

!

test_K_SeqExprCast_34

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-34                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:double("NaN")) eq false()`. :)
(:*******************************************************:)
xs:boolean(xs:double("NaN")) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-34.txt')

!

test_K_SeqExprCast_340

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-340                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Simple test of casting a xs:dateTime with UTC timezone to xs:time. :)
(:*******************************************************:)

		   xs:time(xs:dateTime("2002-11-23T22:12:23.867-00:00")) eq xs:time("22:12:23.867Z")
	
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-340.txt')

!

test_K_SeqExprCast_341

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-341                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Simple test of casting a xs:dateTime with UTC offset to xs:time. :)
(:*******************************************************:)

		   xs:time(xs:dateTime("2002-11-23T22:12:23.867-13:37")) eq xs:time("22:12:23.867-13:37")
	
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-341.txt')

!

test_K_SeqExprCast_342

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-342                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure casting xs:dateTime to xs:string, with timezone "-00:00" is properly handled. :)
(:*******************************************************:)
xs:string(xs:dateTime("1999-12-01T23:59:12.999-00:00")) eq
		"1999-12-01T23:59:12.999Z"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-342.txt')

!

test_K_SeqExprCast_343

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-343                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure casting xs:dateTime to xs:string, with timezone "+00:00" is properly handled. :)
(:*******************************************************:)
xs:string(xs:dateTime("1999-12-01T23:59:12.432+00:00")) eq
		"1999-12-01T23:59:12.432Z"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-343.txt')

!

test_K_SeqExprCast_344

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-344                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:dateTime to xs:string that an empty milli seconds part is not serialized. :)
(:*******************************************************:)
xs:string(xs:dateTime("2002-02-15T21:01:23.000")) eq
						 "2002-02-15T21:01:23"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-344.txt')

!

test_K_SeqExprCast_345

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-345                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:dateTime to xs:string that milli seconds have no trailing zeros. :)
(:*******************************************************:)
xs:string(xs:dateTime("2002-02-15T21:01:23.100")) eq
						 "2002-02-15T21:01:23.1"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-345.txt')

!

test_K_SeqExprCast_346

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-346                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:dateTime to xs:string that milli seconds are properly padded with zeros. :)
(:*******************************************************:)
xs:string(xs:dateTime("2002-02-15T21:01:23.001")) eq
						 "2002-02-15T21:01:23.001"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-346.txt')

!

test_K_SeqExprCast_347

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-347                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:dateTime to xs:string that milli seconds are properly padded with zeros. :)
(:*******************************************************:)
xs:string(xs:dateTime("2002-02-15T21:01:23.010")) eq
						 "2002-02-15T21:01:23.01"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-347.txt')

!

test_K_SeqExprCast_348

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-348                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:dateTime to xs:string that a milli seconds part of "435" is handled properly. :)
(:*******************************************************:)
xs:string(xs:dateTime("2002-02-15T21:01:23.435")) eq
						 "2002-02-15T21:01:23.435"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-348.txt')

!

test_K_SeqExprCast_349

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-349                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:dateTime to xs:string that a milli seconds part of "11" is handled properly. :)
(:*******************************************************:)
xs:string(xs:dateTime("2002-02-15T21:01:23.11")) eq
						 "2002-02-15T21:01:23.11"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-349.txt')

!

test_K_SeqExprCast_35

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-35                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean(xs:float("NaN")) eq false()`. :)
(:*******************************************************:)
xs:boolean(xs:float("NaN")) eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-35.txt')

!

test_K_SeqExprCast_350

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-350                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:dateTime to xs:string that a milli seconds part of "110" is handled properly. :)
(:*******************************************************:)
xs:string(xs:dateTime("2002-02-15T21:01:23.110")) eq
						 "2002-02-15T21:01:23.11"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-350.txt')

!

test_K_SeqExprCast_351

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-351                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Simple xs:dateTime involving time with no milli seconds. :)
(:*******************************************************:)
string(xs:dateTime("2000-08-01T12:44:05")) eq
		 "2000-08-01T12:44:05"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-351.txt')

!

test_K_SeqExprCast_352

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-352                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The canonical form of an xs:dateTime containing 24:00:00 is the following day at 00:00:00. :)
(:*******************************************************:)
string(xs:dateTime("2004-03-31T24:00:00")) eq "2004-04-01T00:00:00"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-352.txt')

!

test_K_SeqExprCast_353

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-353                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "24:00:00.001" is an invalid lexical representation for xs:time; if hour is 24, seconds part must be 00. :)
(:*******************************************************:)
xs:time("24:00:00.001")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_354

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-354                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "24:01:00" is an invalid lexical representation for xs:time; if hour is 24, minutes part must be 00. :)
(:*******************************************************:)
xs:time("24:01:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_355

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-355                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "25:00:00" is an invalid lexical representation for xs:time; hour part can never be larger than 24. :)
(:*******************************************************:)
xs:time("25:01:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_356

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-356                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "21:60:00" is an invalid lexical representation for xs:time; minute part can never be larger than 59. :)
(:*******************************************************:)
xs:time("21:60:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_357

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-357                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "21:01:60" is an invalid lexical representation for xs:time; seconds part can never be larger than 59. :)
(:*******************************************************:)
xs:time("21:01:60")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_358

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-358                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "+21:01:50" is an invalid lexical representation for xs:time. :)
(:*******************************************************:)
xs:time("+21:01:50")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_359

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-359                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "-21:01:50" is an invalid lexical representation for xs:time. :)
(:*******************************************************:)
xs:time("-21:01:50")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_36

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-36                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Invalid casting combination, combined with value comparison. :)
(:*******************************************************:)
"12312" cast as xs:boolean eq false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_360

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-360                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A valid xs:dateTime is an invalid xs:time.   :)
(:*******************************************************:)
xs:time("2002-02-15T08:12:12")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_361

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-361                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:time: the hour component cannot be -15. :)
(:*******************************************************:)
xs:time("23:59:12.432-15:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_362

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-362                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:time: the hour component cannot be +15. :)
(:*******************************************************:)
xs:time("23:59:12.432+15:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_363

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-363                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:time: the minute component cannot be +60. :)
(:*******************************************************:)
xs:time("23:59:12.432+10:60")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_364

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-364                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:time: the minute component cannot be -60. :)
(:*******************************************************:)
xs:time("23:59:12.432-10:60")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_365

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-365                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:time: the minute field must always be present. :)
(:*******************************************************:)
xs:dateTime("T23:59:12.999-03")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_366

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-366                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Simple xs:time involving time with no milli seconds. :)
(:*******************************************************:)
string(xs:time("12:44:05")) eq "12:44:05"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-366.txt')

!

test_K_SeqExprCast_367

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-367                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure casting xs:time to xs:string, with timezone "-00:00" is properly handled. :)
(:*******************************************************:)
xs:string(xs:time("23:59:12.999-00:00")) eq "23:59:12.999Z"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-367.txt')

!

test_K_SeqExprCast_368

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-368                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure casting xs:time to xs:string, with timezone "+00:00" is properly handled. :)
(:*******************************************************:)
xs:string(xs:time("23:59:12.432+00:00")) eq "23:59:12.432Z"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-368.txt')

!

test_K_SeqExprCast_369

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-369                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:time to xs:string that an empty milli seconds part is not serialized. :)
(:*******************************************************:)
xs:string(xs:time("21:01:23.000")) eq "21:01:23"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-369.txt')

!

test_K_SeqExprCast_37

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-37                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `false() cast as xs:string eq "false"`. :)
(:*******************************************************:)
false() cast as xs:string eq "false"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-37.txt')

!

test_K_SeqExprCast_370

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-370                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:time to xs:string that milli seconds have no trailing zeros. :)
(:*******************************************************:)
xs:string(xs:time("21:01:23.100")) eq "21:01:23.1"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-370.txt')

!

test_K_SeqExprCast_371

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-371                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:time to xs:string that milli seconds are properly padded with zeros. :)
(:*******************************************************:)
xs:string(xs:time("21:01:23.001")) eq "21:01:23.001"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-371.txt')

!

test_K_SeqExprCast_372

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-372                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:time to xs:string that milli seconds are properly padded with zeros. :)
(:*******************************************************:)
xs:string(xs:time("21:01:23.010")) eq "21:01:23.01"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-372.txt')

!

test_K_SeqExprCast_373

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-373                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:time to xs:string that a milli seconds part of "435" is handled properly. :)
(:*******************************************************:)
xs:string(xs:time("21:01:23.435")) eq "21:01:23.435"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-373.txt')

!

test_K_SeqExprCast_374

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-374                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:time to xs:string that a milli seconds part of "11" is handled properly. :)
(:*******************************************************:)
xs:string(xs:time("21:01:23.11")) eq "21:01:23.11"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-374.txt')

!

test_K_SeqExprCast_375

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-375                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:time to xs:string that a milli seconds part of "110" is handled properly. :)
(:*******************************************************:)
xs:string(xs:time("21:01:23.110")) eq "21:01:23.11"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-375.txt')

!

test_K_SeqExprCast_376

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-376                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The canonical form of an xs:time containing 24:00:00 is 00:00:00. :)
(:*******************************************************:)
string(xs:time("24:00:00")) eq "00:00:00"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-376.txt')

!

test_K_SeqExprCast_377

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-377                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "+2004-08-01" is an invalid lexical representation, a preceding "+" sign is not allowed for xs:date. :)
(:*******************************************************:)
xs:date("+2004-08-01")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_378

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-378                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "02004-08-01" is an invalid lexical representation for xs:date; if the year part has more than four digits, leading zeros are prohibited. :)
(:*******************************************************:)
xs:date("02004-08-01")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_379

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-379                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "00004-08-01" is an invalid lexical representation for xs:date; if the year part has more than four digits, leading zeros are prohibited. :)
(:*******************************************************:)
xs:date("00004-08-01")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_38

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-38                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `true() cast as xs:string eq "true"`. :)
(:*******************************************************:)
true() cast as xs:string eq "true"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-38.txt')

!

test_K_SeqExprCast_380

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-380                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2004-32-01" is an invalid lexical representation for xs:date; the month part cannot be larger than 32. :)
(:*******************************************************:)
xs:date("2004-32-01")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_381

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-381                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-02-30" is a non-existent xs:date date. :)
(:*******************************************************:)
xs:date("2002-02-30")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_382

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-382                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-002-15" is an invalid lexical representation for xs:date. :)
(:*******************************************************:)
xs:date("2002-002-15")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_383

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-383                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "2002-02-150" is an invalid lexical representation for xs:date. :)
(:*******************************************************:)
xs:date("2002-02-150")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_384

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-384                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "--2002-02-15" is an invalid lexical representation for xs:date. :)
(:*******************************************************:)
xs:date("--2002-02-15")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_385

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-385                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A valid xs:dateTime is an invalid xs:date.   :)
(:*******************************************************:)
xs:date("2002-02-15T08:12:12")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_386

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-386                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:date: the hour component cannot be -15. :)
(:*******************************************************:)
xs:date("1999-12-01-15:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_387

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-387                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:date: the hour component cannot be +15. :)
(:*******************************************************:)
xs:date("1999-12-01+15:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_388

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-388                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:date: the minute component cannot be +60. :)
(:*******************************************************:)
xs:date("1999-12-01+10:60")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_389

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-389                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing timezone field in xs:date: the minute component cannot be -60. :)
(:*******************************************************:)
xs:date("1999-12-01-10:60")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_39

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-39                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `("1" cast as xs:boolean) cast as xs:string eq "true"`. :)
(:*******************************************************:)
("1" cast as xs:boolean) cast as xs:string eq "true"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-39.txt')

!

test_K_SeqExprCast_390

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-390                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Testing datezone field in xs:date: the minute field must always be present. :)
(:*******************************************************:)
xs:dateTime("1999-12-01-03")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-4                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: "cast as" where the type is invalid.         :)
(:*******************************************************:)
"string" cast as xs:anySimpleType
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_40

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-40                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:boolean("0") cast as xs:string eq "false"`. :)
(:*******************************************************:)
xs:boolean("0") cast as xs:string eq "false"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-40.txt')

!

test_K_SeqExprCast_401

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-401                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Simple test of casting a xs:date with UTC timezone to xs:time. :)
(:*******************************************************:)

		   xs:dateTime(xs:date("2002-11-23-00:00"))
		   eq xs:dateTime("2002-11-23T00:00:00.000Z")
	
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-401.txt')

!

test_K_SeqExprCast_402

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-402                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Simple test of casting a xs:date with UTC offset to xs:dateTime. :)
(:*******************************************************:)

		   xs:dateTime(xs:date("2002-11-23-13:37"))
		   eq xs:dateTime("2002-11-23T00:00:00.000-13:37")
	
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-402.txt')

!

test_K_SeqExprCast_403

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-403                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure casting xs:date to xs:string, with timezone "-00:00" is properly handled. :)
(:*******************************************************:)
xs:string(xs:date("1999-12-01-00:00")) eq "1999-12-01Z"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-403.txt')

!

test_K_SeqExprCast_404

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-404                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure casting xs:date to xs:string, with timezone "+00:00" is properly handled. :)
(:*******************************************************:)
xs:string(xs:date("1999-12-01+00:00")) eq "1999-12-01Z"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-404.txt')

!

test_K_SeqExprCast_405

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-405                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:date to xs:string that an empty milli seconds part is not serialized. :)
(:*******************************************************:)
xs:string(xs:date("2002-02-15")) eq "2002-02-15"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-405.txt')

!

test_K_SeqExprCast_406

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-406                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:date to xs:string that milli seconds have no trailing zeros. :)
(:*******************************************************:)
xs:string(xs:date("2002-02-15")) eq "2002-02-15"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-406.txt')

!

test_K_SeqExprCast_407

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-407                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:date to xs:string that milli seconds are properly padded with zeros. :)
(:*******************************************************:)
xs:string(xs:date("2002-02-15")) eq "2002-02-15"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-407.txt')

!

test_K_SeqExprCast_408

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-408                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:date to xs:string that milli seconds are properly padded with zeros. :)
(:*******************************************************:)
xs:string(xs:date("2002-02-15")) eq "2002-02-15"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-408.txt')

!

test_K_SeqExprCast_409

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-409                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:date to xs:string that a milli seconds part of "435" is handled properly. :)
(:*******************************************************:)
xs:string(xs:date("2002-02-15")) eq "2002-02-15"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-409.txt')

!

test_K_SeqExprCast_41

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-41                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `" white space left alone" cast as xs:string eq xs:string(" white space left alone")`. :)
(:*******************************************************:)
"  white space	left alone" cast as xs:string eq 
					xs:string("  white space	left alone")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-41.txt')

!

test_K_SeqExprCast_410

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-410                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:date to xs:string that a milli seconds part of "11" is handled properly. :)
(:*******************************************************:)
xs:string(xs:date("2002-02-15")) eq "2002-02-15"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-410.txt')

!

test_K_SeqExprCast_411

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-411                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Ensure when casting xs:date to xs:string that a milli seconds part of "110" is handled properly. :)
(:*******************************************************:)
xs:string(xs:date("2002-02-15")) eq "2002-02-15"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-411.txt')

!

test_K_SeqExprCast_415

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-415                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:untypedAtomic constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:untypedAtomic()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_416

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-416                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:untypedAtomic constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:untypedAtomic(
      "an arbitrary string(untypedAtomic source)"
    ,
                                                     
      "an arbitrary string(untypedAtomic source)"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_417

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-417                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:untypedAtomic constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:untypedAtomic("an arbitrary string(untypedAtomic source)")), 3, 1) instance of xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-417.txt')

!

test_K_SeqExprCast_418

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-418                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:untypedAtomic. :)
(:*******************************************************:)
xs:untypedAtomic("

	 an arbitrary string(untypedAtomic source)

	 ")
        eq
        xs:untypedAtomic("

	 an arbitrary string(untypedAtomic source)

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-418.txt')

!

test_K_SeqExprCast_419

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-419                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: An empty string is a valid lexical representation of xs:untypedAtomic. :)
(:*******************************************************:)
xs:untypedAtomic("")
            eq
            xs:untypedAtomic("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-419.txt')

!

test_K_SeqExprCast_42

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-42                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(xs:QName("fn:local-name") cast as xs:string) eq "fn:local-name"`. :)
(:*******************************************************:)
(xs:QName("fn:local-name") cast as xs:string) eq "fn:local-name"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-42.txt')

!

test_K_SeqExprCast_420

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-420                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "an arbitrary string(untypedAtomic source)" . :)
(:*******************************************************:)
xs:untypedAtomic(xs:untypedAtomic(
      "an arbitrary string(untypedAtomic source)"
    )) eq xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-420.txt')

!

test_K_SeqExprCast_421

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-421                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Applying fn:boolean() to a value of type xs:untypedAtomic that has the lexical value " "an arbitrary string(untypedAtomic source)" " should result in the boolean value true. :)
(:*******************************************************:)

          boolean(xs:untypedAtomic("an arbitrary string(untypedAtomic source)"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-421.txt')

!

test_K_SeqExprCast_422

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-422                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:untypedAtomic to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:untypedAtomic("an arbitrary string(untypedAtomic source)") cast as xs:untypedAtomic
                    eq
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-422.txt')

!

test_K_SeqExprCast_423

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-423                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:untypedAtomic as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:untypedAtomic("an arbitrary string(untypedAtomic source)") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-423.txt')

!

test_K_SeqExprCast_424

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-424                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:untypedAtomic to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:untypedAtomic("an arbitrary string(untypedAtomic source)") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-424.txt')

!

test_K_SeqExprCast_425

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-425                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:untypedAtomic as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:untypedAtomic("an arbitrary string(untypedAtomic source)") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-425.txt')

!

test_K_SeqExprCast_426

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-426                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:untypedAtomic to xs:QName isn"t allowed. :)
(:*******************************************************:)
xs:untypedAtomic("an arbitrary string(untypedAtomic source)") cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_427

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-427                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:untypedAtomic as source type and xs:QName as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:untypedAtomic("an arbitrary string(untypedAtomic source)") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-427.txt')

!

test_K_SeqExprCast_429

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-429                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:string constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:string()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_43

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-43                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(xs:QName("local-name") cast as xs:string) eq "local-name"`. :)
(:*******************************************************:)
(xs:QName("local-name") cast as xs:string) eq "local-name"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-43.txt')

!

test_K_SeqExprCast_430

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-430                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:string constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:string(
      "an arbitrary string"
    ,
                                                     
      "an arbitrary string"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_431

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-431                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:string constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:string("an arbitrary string")), 3, 1) instance of xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-431.txt')

!

test_K_SeqExprCast_432

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-432                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:string. :)
(:*******************************************************:)
xs:string("

	 an arbitrary string

	 ")
        eq
        xs:string("

	 an arbitrary string

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-432.txt')

!

test_K_SeqExprCast_433

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-433                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: An empty string is a valid lexical representation of xs:string. :)
(:*******************************************************:)
xs:string("")
            eq
            xs:string("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-433.txt')

!

test_K_SeqExprCast_434

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-434                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "an arbitrary string" . :)
(:*******************************************************:)
xs:string(xs:untypedAtomic(
      "an arbitrary string"
    )) eq xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-434.txt')

!

test_K_SeqExprCast_435

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-435                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Applying fn:boolean() to a value of type xs:string that has the lexical value " "an arbitrary string" " should result in the boolean value true. :)
(:*******************************************************:)

          boolean(xs:string("an arbitrary string"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-435.txt')

!

test_K_SeqExprCast_436

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-436                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:string to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:string("an arbitrary string") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-436.txt')

!

test_K_SeqExprCast_437

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-437                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:string as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:string("an arbitrary string") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-437.txt')

!

test_K_SeqExprCast_438

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-438                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:string to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:string("an arbitrary string") cast as xs:string
                    eq
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-438.txt')

!

test_K_SeqExprCast_439

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-439                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:string as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:string("an arbitrary string") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-439.txt')

!

test_K_SeqExprCast_44

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-44                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:string(xs:anyURI("example.com/")) eq "example.com/"`. :)
(:*******************************************************:)
xs:string(xs:anyURI("example.com/")) eq "example.com/"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-44.txt')

!

test_K_SeqExprCast_441

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-441                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:float constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:float()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_442

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-442                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:float constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:float(
      "3.4e5"
    ,
                                                     
      "3.4e5"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_443

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-443                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:float constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:float("3.4e5")), 3, 1) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-443.txt')

!

test_K_SeqExprCast_444

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-444                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:float. :)
(:*******************************************************:)
xs:float("

	 3.4e5

	 ")
        eq
        xs:float("

	 3.4e5

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-444.txt')

!

test_K_SeqExprCast_445

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-445                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: An empty string is not a valid lexical representation of xs:float. :)
(:*******************************************************:)
xs:float("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_446

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-446                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "3.4e5" . :)
(:*******************************************************:)
xs:float(xs:untypedAtomic(
      "3.4e5"
    )) eq xs:float("3.4e5")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-446.txt')

!

test_K_SeqExprCast_447

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-447                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Applying fn:boolean() to a value of type xs:float that has the lexical value " "3.4e5" " should result in the boolean value true. :)
(:*******************************************************:)

          boolean(xs:float("3.4e5"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-447.txt')

!

test_K_SeqExprCast_448

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-448                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:float to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:float("3.4e5") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-448.txt')

!

test_K_SeqExprCast_449

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-449                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:float as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:float("3.4e5") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-449.txt')

!

test_K_SeqExprCast_45

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-45                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:string(xs:double(3)) eq "3"`. :)
(:*******************************************************:)
xs:string(xs:double(3)) eq "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-45.txt')

!

test_K_SeqExprCast_450

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-450                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:float to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:float("3.4e5") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-450.txt')

!

test_K_SeqExprCast_451

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-451                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:float as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:float("3.4e5") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-451.txt')

!

test_K_SeqExprCast_452

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-452                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:float to xs:float is allowed and should always succeed. :)
(:*******************************************************:)
xs:float("3.4e5") cast as xs:float
                    eq
                  xs:float("3.4e5")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-452.txt')

!

test_K_SeqExprCast_453

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-453                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:float as source type and xs:float as target type should always evaluate to true. :)
(:*******************************************************:)
xs:float("3.4e5") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-453.txt')

!

test_K_SeqExprCast_454

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-454                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:float to xs:double is allowed and should always succeed. :)
(:*******************************************************:)
xs:float("3.4e5") cast as xs:double
                    ne
                  xs:double("3.3e3")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-454.txt')

!

test_K_SeqExprCast_455

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-455                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:float as source type and xs:double as target type should always evaluate to true. :)
(:*******************************************************:)
xs:float("3.4e5") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-455.txt')

!

test_K_SeqExprCast_46

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-46                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:string(xs:string(3)) eq "3"`. :)
(:*******************************************************:)
xs:string(xs:string(3)) eq "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-46.txt')

!

test_K_SeqExprCast_462

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-462                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:float to xs:dateTime isn"t allowed. :)
(:*******************************************************:)
xs:float("3.4e5") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_463

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-463                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:float as source type and xs:dateTime as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:float("3.4e5") castable as xs:dateTime)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-463.txt')

!

test_K_SeqExprCast_464

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-464                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:float to xs:time isn"t allowed. :)
(:*******************************************************:)
xs:float("3.4e5") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_465

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-465                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:float as source type and xs:time as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:float("3.4e5") castable as xs:time)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-465.txt')

!

test_K_SeqExprCast_466

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-466                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:float to xs:date isn"t allowed. :)
(:*******************************************************:)
xs:float("3.4e5") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_467

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-467                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:float as source type and xs:date as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:float("3.4e5") castable as xs:date)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-467.txt')

!

test_K_SeqExprCast_47

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-47                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:string(xs:integer(3)) eq "3"`. :)
(:*******************************************************:)
xs:string(xs:integer(3)) eq "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-47.txt')

!

test_K_SeqExprCast_478

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-478                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:float to xs:boolean is allowed and should always succeed. :)
(:*******************************************************:)
xs:float("3.4e5") cast as xs:boolean
                    eq
                  xs:boolean("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-478.txt')

!

test_K_SeqExprCast_479

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-479                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:float as source type and xs:boolean as target type should always evaluate to true. :)
(:*******************************************************:)
xs:float("3.4e5") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-479.txt')

!

test_K_SeqExprCast_48

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-48                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:string(xs:decimal(3)) eq "3"`. :)
(:*******************************************************:)
xs:string(xs:decimal(3)) eq "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-48.txt')

!

test_K_SeqExprCast_484

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-484                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:float to xs:anyURI isn"t allowed. :)
(:*******************************************************:)
xs:float("3.4e5") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_485

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-485                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:float as source type and xs:anyURI as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:float("3.4e5") castable as xs:anyURI)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-485.txt')

!

test_K_SeqExprCast_486

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-486                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:float to xs:QName isn"t allowed. :)
(:*******************************************************:)
xs:float("3.4e5") cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_487

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-487                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:float as source type and xs:QName as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:float("3.4e5") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-487.txt')

!

test_K_SeqExprCast_489

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-489                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:double constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:double()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_49

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-49                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `"untyped a " cast as xs:untypedAtomic eq xs:untypedAtomic("untyped a ")`. :)
(:*******************************************************:)
"untyped a   " cast as xs:untypedAtomic 
		eq xs:untypedAtomic("untyped a   ")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-49.txt')

!

test_K_SeqExprCast_490

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-490                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:double constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:double(
      "3.3e3"
    ,
                                                     
      "3.3e3"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_491

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-491                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:double constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:double("3.3e3")), 3, 1) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-491.txt')

!

test_K_SeqExprCast_492

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-492                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:double. :)
(:*******************************************************:)
xs:double("

	 3.3e3

	 ")
        eq
        xs:double("

	 3.3e3

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-492.txt')

!

test_K_SeqExprCast_493

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-493                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: An empty string is not a valid lexical representation of xs:double. :)
(:*******************************************************:)
xs:double("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_494

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-494                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "3.3e3" . :)
(:*******************************************************:)
xs:double(xs:untypedAtomic(
      "3.3e3"
    )) eq xs:double("3.3e3")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-494.txt')

!

test_K_SeqExprCast_495

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-495                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Applying fn:boolean() to a value of type xs:double that has the lexical value " "3.3e3" " should result in the boolean value true. :)
(:*******************************************************:)

          boolean(xs:double("3.3e3"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-495.txt')

!

test_K_SeqExprCast_496

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-496                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:double to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:double("3.3e3") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-496.txt')

!

test_K_SeqExprCast_497

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-497                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:double as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:double("3.3e3") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-497.txt')

!

test_K_SeqExprCast_498

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-498                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:double to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:double("3.3e3") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-498.txt')

!

test_K_SeqExprCast_499

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-499                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:double as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:double("3.3e3") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-499.txt')

!

test_K_SeqExprCast_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-5                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: "cast as" where the type is invalid.         :)
(:*******************************************************:)
"string" cast as xs:untyped
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_50

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-50                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `false() cast as xs:untypedAtomic eq xs:untypedAtomic("false")`. :)
(:*******************************************************:)
false() cast as xs:untypedAtomic 
		eq xs:untypedAtomic("false")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-50.txt')

!

test_K_SeqExprCast_500

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-500                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:double to xs:float is allowed and should always succeed. :)
(:*******************************************************:)
xs:double("3.3e3") cast as xs:float
                    ne
                  xs:float("3.4e5")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-500.txt')

!

test_K_SeqExprCast_501

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-501                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:double as source type and xs:float as target type should always evaluate to true. :)
(:*******************************************************:)
xs:double("3.3e3") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-501.txt')

!

test_K_SeqExprCast_502

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-502                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:double to xs:double is allowed and should always succeed. :)
(:*******************************************************:)
xs:double("3.3e3") cast as xs:double
                    eq
                  xs:double("3.3e3")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-502.txt')

!

test_K_SeqExprCast_503

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-503                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:double as source type and xs:double as target type should always evaluate to true. :)
(:*******************************************************:)
xs:double("3.3e3") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-503.txt')

!

test_K_SeqExprCast_51

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-51                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `true() cast as xs:untypedAtomic eq xs:untypedAtomic("true")`. :)
(:*******************************************************:)
true() cast as xs:untypedAtomic 
		eq xs:untypedAtomic("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-51.txt')

!

test_K_SeqExprCast_510

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-510                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:double to xs:dateTime isn"t allowed. :)
(:*******************************************************:)
xs:double("3.3e3") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_511

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-511                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:double as source type and xs:dateTime as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:double("3.3e3") castable as xs:dateTime)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-511.txt')

!

test_K_SeqExprCast_512

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-512                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:double to xs:time isn"t allowed. :)
(:*******************************************************:)
xs:double("3.3e3") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_513

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-513                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:double as source type and xs:time as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:double("3.3e3") castable as xs:time)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-513.txt')

!

test_K_SeqExprCast_514

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-514                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:double to xs:date isn"t allowed. :)
(:*******************************************************:)
xs:double("3.3e3") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_515

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-515                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:double as source type and xs:date as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:double("3.3e3") castable as xs:date)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-515.txt')

!

test_K_SeqExprCast_52

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-52                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `false() cast as xs:untypedAtomic instance of xs:untypedAtomic`. :)
(:*******************************************************:)
false() cast as xs:untypedAtomic instance of xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-52.txt')

!

test_K_SeqExprCast_526

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-526                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:double to xs:boolean is allowed and should always succeed. :)
(:*******************************************************:)
xs:double("3.3e3") cast as xs:boolean
                    eq
                  xs:boolean("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-526.txt')

!

test_K_SeqExprCast_527

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-527                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:double as source type and xs:boolean as target type should always evaluate to true. :)
(:*******************************************************:)
xs:double("3.3e3") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-527.txt')

!

test_K_SeqExprCast_53

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-53                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `true() cast as xs:untypedAtomic instance of xs:untypedAtomic`. :)
(:*******************************************************:)
true() cast as xs:untypedAtomic instance of xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-53.txt')

!

test_K_SeqExprCast_532

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-532                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:double to xs:anyURI isn"t allowed. :)
(:*******************************************************:)
xs:double("3.3e3") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_533

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-533                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:double as source type and xs:anyURI as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:double("3.3e3") castable as xs:anyURI)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-533.txt')

!

test_K_SeqExprCast_534

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-534                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:double to xs:QName isn"t allowed. :)
(:*******************************************************:)
xs:double("3.3e3") cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_535

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-535                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:double as source type and xs:QName as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:double("3.3e3") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-535.txt')

!

test_K_SeqExprCast_537

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-537                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:decimal constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:decimal()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_538

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-538                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:decimal constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:decimal(
      "10.01"
    ,
                                                     
      "10.01"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_539

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-539                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:decimal constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:decimal("10.01")), 3, 1) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-539.txt')

!

test_K_SeqExprCast_54

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-54                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(xs:QName("local-name") cast as xs:untypedAtomic) eq xs:untypedAtomic("local-name")`. :)
(:*******************************************************:)
(xs:QName("local-name") cast as xs:untypedAtomic) 
		eq xs:untypedAtomic("local-name")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-54.txt')

!

test_K_SeqExprCast_540

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-540                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:decimal. :)
(:*******************************************************:)
xs:decimal("

	 10.01

	 ")
        eq
        xs:decimal("

	 10.01

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-540.txt')

!

test_K_SeqExprCast_541

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-541                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: An empty string is not a valid lexical representation of xs:decimal. :)
(:*******************************************************:)
xs:decimal("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_542

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-542                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "10.01" . :)
(:*******************************************************:)
xs:decimal(xs:untypedAtomic(
      "10.01"
    )) eq xs:decimal("10.01")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-542.txt')

!

test_K_SeqExprCast_543

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-543                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Applying fn:boolean() to a value of type xs:decimal that has the lexical value " "10.01" " should result in the boolean value true. :)
(:*******************************************************:)

          boolean(xs:decimal("10.01"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-543.txt')

!

test_K_SeqExprCast_544

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-544                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-544.txt')

!

test_K_SeqExprCast_545

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-545                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:decimal("10.01") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-545.txt')

!

test_K_SeqExprCast_546

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-546                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-546.txt')

!

test_K_SeqExprCast_547

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-547                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:decimal("10.01") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-547.txt')

!

test_K_SeqExprCast_548

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-548                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:float is allowed and should always succeed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:float
                    ne
                  xs:float("3.4e5")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-548.txt')

!

test_K_SeqExprCast_549

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-549                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:float as target type should always evaluate to true. :)
(:*******************************************************:)
xs:decimal("10.01") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-549.txt')

!

test_K_SeqExprCast_55

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-55                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(xs:QName("fn:local-name") cast as xs:untypedAtomic) eq xs:untypedAtomic("fn:local-name")`. :)
(:*******************************************************:)
(xs:QName("fn:local-name") cast as xs:untypedAtomic) 
		eq xs:untypedAtomic("fn:local-name")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-55.txt')

!

test_K_SeqExprCast_550

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-550                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:double is allowed and should always succeed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:double
                    ne
                  xs:double("3.3e3")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-550.txt')

!

test_K_SeqExprCast_551

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-551                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:double as target type should always evaluate to true. :)
(:*******************************************************:)
xs:decimal("10.01") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-551.txt')

!

test_K_SeqExprCast_552

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-552                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:decimal is allowed and should always succeed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:decimal
                    eq
                  xs:decimal("10.01")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-552.txt')

!

test_K_SeqExprCast_553

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-553                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:decimal as target type should always evaluate to true. :)
(:*******************************************************:)
xs:decimal("10.01") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-553.txt')

!

test_K_SeqExprCast_554

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-554                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:integer is allowed and should always succeed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:integer
                    ne
                  xs:integer("6789")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-554.txt')

!

test_K_SeqExprCast_555

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-555                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:integer as target type should always evaluate to true. :)
(:*******************************************************:)
xs:decimal("10.01") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-555.txt')

!

test_K_SeqExprCast_56

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-56                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:untypedAtomic(xs:anyURI("example.com/")) eq "example.com/"`. :)
(:*******************************************************:)
xs:untypedAtomic(xs:anyURI("example.com/")) eq "example.com/"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-56.txt')

!

test_K_SeqExprCast_562

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-562                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:dateTime isn"t allowed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_563

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-563                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:dateTime as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:decimal("10.01") castable as xs:dateTime)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-563.txt')

!

test_K_SeqExprCast_564

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-564                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:time isn"t allowed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_565

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-565                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:time as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:decimal("10.01") castable as xs:time)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-565.txt')

!

test_K_SeqExprCast_566

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-566                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:date isn"t allowed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_567

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-567                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:date as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:decimal("10.01") castable as xs:date)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-567.txt')

!

test_K_SeqExprCast_57

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-57                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:untypedAtomic(xs:double(3)) eq "3"`. :)
(:*******************************************************:)
xs:untypedAtomic(xs:double(3)) eq "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-57.txt')

!

test_K_SeqExprCast_578

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-578                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:boolean is allowed and should always succeed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:boolean
                    eq
                  xs:boolean("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-578.txt')

!

test_K_SeqExprCast_579

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-579                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:boolean as target type should always evaluate to true. :)
(:*******************************************************:)
xs:decimal("10.01") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-579.txt')

!

test_K_SeqExprCast_58

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-58                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:untypedAtomic(xs:string(3)) eq "3"`. :)
(:*******************************************************:)
xs:untypedAtomic(xs:string(3)) eq "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-58.txt')

!

test_K_SeqExprCast_584

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-584                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:anyURI isn"t allowed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_585

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-585                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:anyURI as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:decimal("10.01") castable as xs:anyURI)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-585.txt')

!

test_K_SeqExprCast_586

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-586                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:decimal to xs:QName isn"t allowed. :)
(:*******************************************************:)
xs:decimal("10.01") cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_587

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-587                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:decimal as source type and xs:QName as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:decimal("10.01") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-587.txt')

!

test_K_SeqExprCast_589

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-589                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:integer constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:integer()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_59

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-59                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:untypedAtomic(xs:integer(3)) eq "3"`. :)
(:*******************************************************:)
xs:untypedAtomic(xs:integer(3)) eq "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-59.txt')

!

test_K_SeqExprCast_590

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-590                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:integer constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:integer(
      "6789"
    ,
                                                     
      "6789"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_591

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-591                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:integer constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:integer("6789")), 3, 1) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-591.txt')

!

test_K_SeqExprCast_592

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-592                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:integer. :)
(:*******************************************************:)
xs:integer("

	 6789

	 ")
        eq
        xs:integer("

	 6789

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-592.txt')

!

test_K_SeqExprCast_593

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-593                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: An empty string is not a valid lexical representation of xs:integer. :)
(:*******************************************************:)
xs:integer("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_594

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-594                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "6789" . :)
(:*******************************************************:)
xs:integer(xs:untypedAtomic(
      "6789"
    )) eq xs:integer("6789")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-594.txt')

!

test_K_SeqExprCast_595

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-595                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Applying fn:boolean() to a value of type xs:integer that has the lexical value " "6789" " should result in the boolean value true. :)
(:*******************************************************:)

          boolean(xs:integer("6789"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-595.txt')

!

test_K_SeqExprCast_596

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-596                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-596.txt')

!

test_K_SeqExprCast_597

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-597                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:integer("6789") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-597.txt')

!

test_K_SeqExprCast_598

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-598                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-598.txt')

!

test_K_SeqExprCast_599

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-599                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:integer("6789") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-599.txt')

!

test_K_SeqExprCast_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-6                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: "cast as" where the type is invalid.         :)
(:*******************************************************:)
"string" cast as xs:anyAtomicType
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_60

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-60                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:untypedAtomic(xs:decimal(3)) eq "3"`. :)
(:*******************************************************:)
xs:untypedAtomic(xs:decimal(3)) eq "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-60.txt')

!

test_K_SeqExprCast_600

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-600                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:float is allowed and should always succeed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:float
                    ne
                  xs:float("3.4e5")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-600.txt')

!

test_K_SeqExprCast_601

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-601                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:float as target type should always evaluate to true. :)
(:*******************************************************:)
xs:integer("6789") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-601.txt')

!

test_K_SeqExprCast_602

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-602                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:double is allowed and should always succeed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:double
                    ne
                  xs:double("3.3e3")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-602.txt')

!

test_K_SeqExprCast_603

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-603                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:double as target type should always evaluate to true. :)
(:*******************************************************:)
xs:integer("6789") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-603.txt')

!

test_K_SeqExprCast_604

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-604                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:decimal is allowed and should always succeed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:decimal
                    ne
                  xs:decimal("10.01")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-604.txt')

!

test_K_SeqExprCast_605

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-605                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:decimal as target type should always evaluate to true. :)
(:*******************************************************:)
xs:integer("6789") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-605.txt')

!

test_K_SeqExprCast_606

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-606                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:integer is allowed and should always succeed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:integer
                    eq
                  xs:integer("6789")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-606.txt')

!

test_K_SeqExprCast_607

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-607                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:integer as target type should always evaluate to true. :)
(:*******************************************************:)
xs:integer("6789") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-607.txt')

!

test_K_SeqExprCast_614

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-614                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:dateTime isn"t allowed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_615

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-615                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:dateTime as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:integer("6789") castable as xs:dateTime)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-615.txt')

!

test_K_SeqExprCast_616

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-616                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:time isn"t allowed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_617

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-617                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:time as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:integer("6789") castable as xs:time)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-617.txt')

!

test_K_SeqExprCast_618

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-618                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:date isn"t allowed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_619

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-619                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:date as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:integer("6789") castable as xs:date)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-619.txt')

!

test_K_SeqExprCast_630

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-630                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:boolean is allowed and should always succeed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:boolean
                    eq
                  xs:boolean("true")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-630.txt')

!

test_K_SeqExprCast_631

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-631                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:boolean as target type should always evaluate to true. :)
(:*******************************************************:)
xs:integer("6789") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-631.txt')

!

test_K_SeqExprCast_636

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-636                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:anyURI isn"t allowed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_637

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-637                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:anyURI as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:integer("6789") castable as xs:anyURI)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-637.txt')

!

test_K_SeqExprCast_638

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-638                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:integer to xs:QName isn"t allowed. :)
(:*******************************************************:)
xs:integer("6789") cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_639

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-639                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:integer as source type and xs:QName as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:integer("6789") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-639.txt')

!

test_K_SeqExprCast_67

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-67                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Casting to xs:QName where the cardinality is wrong. :)
(:*******************************************************:)
() cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_68

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-68                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Input when casting to xs:QName must be a string literal. :)
(:*******************************************************:)
3 cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_69

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-69                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Input when casting to xs:QName must be a string literal. :)
(:*******************************************************:)
. cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-7                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: "cast as" where the type is invalid.         :)
(:*******************************************************:)
"string" cast as xs:anyType
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_70

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-70                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Casting a xs:QName value to xs:QName is possible. :)
(:*******************************************************:)
(xs:QName("local-name") cast as xs:QName) eq xs:QName("local-name")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-70.txt')

!

test_K_SeqExprCast_71

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-71                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Casting xs:untypedAtomic to xs:QName is an error. :)
(:*******************************************************:)
xs:untypedAtomic("ncname") cast as xs:QName?
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_72

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-72                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `"example.com/" cast as xs:anyURI eq xs:anyURI("example.com/")`. :)
(:*******************************************************:)
"example.com/" cast as xs:anyURI eq 
				xs:anyURI("example.com/")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-72.txt')

!

test_K_SeqExprCast_73

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-73                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:untypedAtomic("example.com/") cast as xs:anyURI eq xs:anyURI("example.com/")`. :)
(:*******************************************************:)
xs:untypedAtomic("example.com/") cast as xs:anyURI eq 
				xs:anyURI("example.com/")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-73.txt')

!

test_K_SeqExprCast_74

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-74                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:anyURI("example.com/") cast as xs:anyURI eq xs:anyURI("example.com/")`. :)
(:*******************************************************:)
xs:anyURI("example.com/") cast as xs:anyURI eq 
				xs:anyURI("example.com/")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-74.txt')

!

test_K_SeqExprCast_75

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-75                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:double(3) eq 3`. :)
(:*******************************************************:)
xs:double(3) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-75.txt')

!

test_K_SeqExprCast_76

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-76                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:double(3.1) eq 3.1`. :)
(:*******************************************************:)
xs:double(3.1) eq 3.1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-76.txt')

!

test_K_SeqExprCast_77

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-77                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:double(6) instance of xs:double`. :)
(:*******************************************************:)
xs:double(6) instance of xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-77.txt')

!

test_K_SeqExprCast_78

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-78                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:string(xs:double("INF")) eq "INF"`. :)
(:*******************************************************:)
xs:string(xs:double("INF")) eq "INF"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-78.txt')

!

test_K_SeqExprCast_79

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-79                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:string(xs:double("-INF")) eq "-INF"`. :)
(:*******************************************************:)
xs:string(xs:double("-INF")) eq "-INF"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-79.txt')

!

test_K_SeqExprCast_797

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-797                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:dateTime constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:dateTime()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_798

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-798                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:dateTime constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:dateTime(
      "2002-10-10T12:00:00-05:00"
    ,
                                                     
      "2002-10-10T12:00:00-05:00"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_799

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-799                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:dateTime constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:dateTime("2002-10-10T12:00:00-05:00")), 3, 1) instance of xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-799.txt')

!

test_K_SeqExprCast_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-8                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A prefix is used which isn"t declared.       :)
(:*******************************************************:)
3 cast as prefixDoesNotExist:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_80

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-80                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(3) eq 3`. :)
(:*******************************************************:)
xs:float(3) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-80.txt')

!

test_K_SeqExprCast_800

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-800                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:dateTime. :)
(:*******************************************************:)
xs:dateTime("

	 2002-10-10T12:00:00-05:00

	 ")
        eq
        xs:dateTime("

	 2002-10-10T12:00:00-05:00

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-800.txt')

!

test_K_SeqExprCast_801

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-801                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: An empty string is not a valid lexical representation of xs:dateTime. :)
(:*******************************************************:)
xs:dateTime("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_802

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-802                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "2002-10-10T12:00:00-05:00" . :)
(:*******************************************************:)
xs:dateTime(xs:untypedAtomic(
      "2002-10-10T12:00:00-05:00"
    )) eq xs:dateTime("2002-10-10T12:00:00-05:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-802.txt')

!

test_K_SeqExprCast_803

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-803                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: It is not possible to extract an Effective Boolean Value from the type xs:dateTime, with the boolean() function. :)
(:*******************************************************:)
boolean(xs:dateTime("2002-10-10T12:00:00-05:00"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_804

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-804                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-804.txt')

!

test_K_SeqExprCast_805

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-805                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-805.txt')

!

test_K_SeqExprCast_806

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-806                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-806.txt')

!

test_K_SeqExprCast_807

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-807                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-807.txt')

!

test_K_SeqExprCast_808

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-808                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:float isn"t allowed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_809

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-809                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:float as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:float)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-809.txt')

!

test_K_SeqExprCast_81

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-81                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(3.1) eq 3.1`. :)
(:*******************************************************:)
xs:float(3.1) eq 3.1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-81.txt')

!

test_K_SeqExprCast_810

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-810                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:double isn"t allowed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_811

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-811                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:double as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:double)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-811.txt')

!

test_K_SeqExprCast_812

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-812                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:decimal isn"t allowed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_813

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-813                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:decimal as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:decimal)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-813.txt')

!

test_K_SeqExprCast_814

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-814                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:integer isn"t allowed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_815

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-815                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:integer as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-815.txt')

!

test_K_SeqExprCast_82

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-82                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(6) instance of xs:float`. :)
(:*******************************************************:)
xs:float(6) instance of xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-82.txt')

!

test_K_SeqExprCast_822

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-822                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:dateTime is allowed and should always succeed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:dateTime
                    eq
                  xs:dateTime("2002-10-10T12:00:00-05:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-822.txt')

!

test_K_SeqExprCast_823

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-823                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:dateTime as target type should always evaluate to true. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-823.txt')

!

test_K_SeqExprCast_824

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-824                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:time is allowed and should always succeed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:time
                    ne
                  xs:time("03:20:00-05:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-824.txt')

!

test_K_SeqExprCast_825

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-825                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:time as target type should always evaluate to true. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-825.txt')

!

test_K_SeqExprCast_826

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-826                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:date is allowed and should always succeed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:date
                    ne
                  xs:date("2004-10-13")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-826.txt')

!

test_K_SeqExprCast_827

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-827                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:date as target type should always evaluate to true. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-827.txt')

!

test_K_SeqExprCast_83

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-83                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:string(xs:float("INF")) eq "INF"`. :)
(:*******************************************************:)
xs:string(xs:float("INF")) eq "INF"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-83.txt')

!

test_K_SeqExprCast_838

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-838                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:boolean isn"t allowed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_839

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-839                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:boolean as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:boolean)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-839.txt')

!

test_K_SeqExprCast_84

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-84                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:string(xs:float("-INF")) eq "-INF"`. :)
(:*******************************************************:)
xs:string(xs:float("-INF")) eq "-INF"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-84.txt')

!

test_K_SeqExprCast_844

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-844                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:anyURI isn"t allowed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_845

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-845                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:anyURI as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:anyURI)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-845.txt')

!

test_K_SeqExprCast_846

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-846                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:dateTime to xs:QName isn"t allowed. :)
(:*******************************************************:)
xs:dateTime("2002-10-10T12:00:00-05:00") cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_847

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-847                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:dateTime as source type and xs:QName as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:dateTime("2002-10-10T12:00:00-05:00") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-847.txt')

!

test_K_SeqExprCast_849

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-849                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:time constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:time()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_85

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-85                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:decimal(3) eq 3`. :)
(:*******************************************************:)
xs:decimal(3) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-85.txt')

!

test_K_SeqExprCast_850

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-850                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:time constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:time(
      "03:20:00-05:00"
    ,
                                                     
      "03:20:00-05:00"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_851

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-851                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:time constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:time("03:20:00-05:00")), 3, 1) instance of xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-851.txt')

!

test_K_SeqExprCast_852

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-852                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:time. :)
(:*******************************************************:)
xs:time("

	 03:20:00-05:00

	 ")
        eq
        xs:time("

	 03:20:00-05:00

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-852.txt')

!

test_K_SeqExprCast_853

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-853                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: An empty string is not a valid lexical representation of xs:time. :)
(:*******************************************************:)
xs:time("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_854

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-854                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "03:20:00-05:00" . :)
(:*******************************************************:)
xs:time(xs:untypedAtomic(
      "03:20:00-05:00"
    )) eq xs:time("03:20:00-05:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-854.txt')

!

test_K_SeqExprCast_855

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-855                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: It is not possible to extract an Effective Boolean Value from the type xs:time, with the boolean() function. :)
(:*******************************************************:)
boolean(xs:time("03:20:00-05:00"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_856

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-856                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-856.txt')

!

test_K_SeqExprCast_857

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-857                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-857.txt')

!

test_K_SeqExprCast_858

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-858                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-858.txt')

!

test_K_SeqExprCast_859

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-859                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-859.txt')

!

test_K_SeqExprCast_86

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-86                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:decimal(3.1) eq 3.1`. :)
(:*******************************************************:)
xs:decimal(3.1) eq 3.1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-86.txt')

!

test_K_SeqExprCast_860

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-860                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:float isn"t allowed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_861

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-861                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:float as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:time("03:20:00-05:00") castable as xs:float)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-861.txt')

!

test_K_SeqExprCast_862

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-862                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:double isn"t allowed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_863

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-863                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:double as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:time("03:20:00-05:00") castable as xs:double)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-863.txt')

!

test_K_SeqExprCast_864

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-864                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:decimal isn"t allowed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_865

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-865                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:decimal as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:time("03:20:00-05:00") castable as xs:decimal)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-865.txt')

!

test_K_SeqExprCast_866

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-866                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:integer isn"t allowed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_867

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-867                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:integer as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:time("03:20:00-05:00") castable as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-867.txt')

!

test_K_SeqExprCast_87

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-87                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:decimal(6) instance of xs:decimal`. :)
(:*******************************************************:)
xs:decimal(6) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-87.txt')

!

test_K_SeqExprCast_874

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-874                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:dateTime isn"t allowed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_875

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-875                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:dateTime as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:time("03:20:00-05:00") castable as xs:dateTime)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-875.txt')

!

test_K_SeqExprCast_876

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-876                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:time is allowed and should always succeed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:time
                    eq
                  xs:time("03:20:00-05:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-876.txt')

!

test_K_SeqExprCast_877

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-877                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:time as target type should always evaluate to true. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-877.txt')

!

test_K_SeqExprCast_878

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-878                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:date isn"t allowed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_879

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-879                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:date as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:time("03:20:00-05:00") castable as xs:date)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-879.txt')

!

test_K_SeqExprCast_88

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-88                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:integer(3) eq 3`. :)
(:*******************************************************:)
xs:integer(3) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-88.txt')

!

test_K_SeqExprCast_89

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-89                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:integer(3.1) eq 3`. :)
(:*******************************************************:)
xs:integer(3.1) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-89.txt')

!

test_K_SeqExprCast_890

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-890                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:boolean isn"t allowed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_891

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-891                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:boolean as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:time("03:20:00-05:00") castable as xs:boolean)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-891.txt')

!

test_K_SeqExprCast_896

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-896                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:anyURI isn"t allowed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_897

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-897                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:anyURI as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:time("03:20:00-05:00") castable as xs:anyURI)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-897.txt')

!

test_K_SeqExprCast_898

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-898                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:time to xs:QName isn"t allowed. :)
(:*******************************************************:)
xs:time("03:20:00-05:00") cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_899

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-899                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:time as source type and xs:QName as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:time("03:20:00-05:00") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-899.txt')

!

test_K_SeqExprCast_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-9                                 :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A type is specified which doesn"t exist.     :)
(:*******************************************************:)
3 cast as xs:doesNotExist
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_90

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-90                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Test that when casting xs:decimal to xs:integer that conversion happens. :)
(:*******************************************************:)
xs:integer(3.1) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-90.txt')

!

test_K_SeqExprCast_901

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-901                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:date constructor function must be passed exactly one argument, not zero. :)
(:*******************************************************:)
xs:date()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_902

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-902                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: The xs:date constructor function must be passed exactly one argument, not two. :)
(:*******************************************************:)
xs:date(
      "2004-10-13"
    ,
                                                     
      "2004-10-13"
    )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_903

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-903                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Verify with "instance of" that the xs:date constructor function produces values of the correct type. The subsequence() function makes it more difficult for optimizers to take short cuts based on static type information. :)
(:*******************************************************:)

        subsequence(("dummy", 1.1, xs:date("2004-10-13")), 3, 1) instance of xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-903.txt')

!

test_K_SeqExprCast_904

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-904                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: A simple test exercising the whitespace facet for type xs:date. :)
(:*******************************************************:)
xs:date("

	 2004-10-13

	 ")
        eq
        xs:date("

	 2004-10-13

	 ")
      
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-904.txt')

!

test_K_SeqExprCast_905

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-905                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: An empty string is not a valid lexical representation of xs:date. :)
(:*******************************************************:)
xs:date("")
          
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_906

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-906                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Cast a simple xs:untypedAtomic value to "2004-10-13" . :)
(:*******************************************************:)
xs:date(xs:untypedAtomic(
      "2004-10-13"
    )) eq xs:date("2004-10-13")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-906.txt')

!

test_K_SeqExprCast_907

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-907                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: It is not possible to extract an Effective Boolean Value from the type xs:date, with the boolean() function. :)
(:*******************************************************:)
boolean(xs:date("2004-10-13"))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_908

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-908                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:untypedAtomic is allowed and should always succeed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:untypedAtomic
                    ne
                  xs:untypedAtomic("an arbitrary string(untypedAtomic source)")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-908.txt')

!

test_K_SeqExprCast_909

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-909                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:untypedAtomic as target type should always evaluate to true. :)
(:*******************************************************:)
xs:date("2004-10-13") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-909.txt')

!

test_K_SeqExprCast_91

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-91                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:integer(6) instance of xs:integer`. :)
(:*******************************************************:)
xs:integer(6) instance of xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-91.txt')

!

test_K_SeqExprCast_910

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-910                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:string is allowed and should always succeed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:string
                    ne
                  xs:string("an arbitrary string")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-910.txt')

!

test_K_SeqExprCast_911

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-911                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:string as target type should always evaluate to true. :)
(:*******************************************************:)
xs:date("2004-10-13") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-911.txt')

!

test_K_SeqExprCast_912

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-912                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:float isn"t allowed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_913

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-913                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:float as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:date("2004-10-13") castable as xs:float)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-913.txt')

!

test_K_SeqExprCast_914

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-914                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:double isn"t allowed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_915

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-915                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:double as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:date("2004-10-13") castable as xs:double)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-915.txt')

!

test_K_SeqExprCast_916

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-916                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:decimal isn"t allowed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_917

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-917                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:decimal as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:date("2004-10-13") castable as xs:decimal)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-917.txt')

!

test_K_SeqExprCast_918

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-918                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:integer isn"t allowed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_919

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-919                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:integer as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:date("2004-10-13") castable as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-919.txt')

!

test_K_SeqExprCast_92

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-92                                :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `xs:integer(6) instance of xs:decimal`. :)
(:*******************************************************:)
xs:integer(6) instance of xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-92.txt')

!

test_K_SeqExprCast_926

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-926                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:dateTime is allowed and should always succeed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:dateTime
                    ne
                  xs:dateTime("2002-10-10T12:00:00-05:00")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-926.txt')

!

test_K_SeqExprCast_927

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-927                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:dateTime as target type should always evaluate to true. :)
(:*******************************************************:)
xs:date("2004-10-13") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-927.txt')

!

test_K_SeqExprCast_928

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-928                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:time isn"t allowed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_929

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-929                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:time as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:date("2004-10-13") castable as xs:time)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-929.txt')

!

test_K_SeqExprCast_930

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-930                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:date is allowed and should always succeed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:date
                    eq
                  xs:date("2004-10-13")
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-930.txt')

!

test_K_SeqExprCast_931

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-931                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:date as target type should always evaluate to true. :)
(:*******************************************************:)
xs:date("2004-10-13") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-931.txt')

!

test_K_SeqExprCast_942

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-942                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:boolean isn"t allowed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_943

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-943                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:boolean as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:date("2004-10-13") castable as xs:boolean)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-943.txt')

!

test_K_SeqExprCast_948

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-948                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:anyURI isn"t allowed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_949

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-949                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:anyURI as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:date("2004-10-13") castable as xs:anyURI)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-949.txt')

!

test_K_SeqExprCast_950

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-950                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: Casting from xs:date to xs:QName isn"t allowed. :)
(:*******************************************************:)
xs:date("2004-10-13") cast as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCast_951

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCast-951                               :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:38+02:00                       :)
(: Purpose: "castable as" involving xs:date as source type and xs:QName as target type should always evaluate to false. :)
(:*******************************************************:)
not(xs:date("2004-10-13") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCast/K-SeqExprCast-951.txt')

!

test_casthc1

    | query result |

    query := ' 
        (: Name: casthc1 :)
(: Description: Simple test for evaluation of a simple expression casted as xs:integer :)

(5 + 5) cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc1.txt')

!

test_casthc10

    | query result |

    query := ' 
        (: Name: casthc10 :)
(: Description: Simple test for casting a float as a double:)

xs:float(2.1E3) cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc10.txt')

!

test_casthc11

    | query result |

    query := ' 
        (: Name: casthc11 :)
(: Description: Simple test for casting a float as a boolean:)

xs:float(2.1E3) cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc11.txt')

!

test_casthc12

    | query result |

    query := ' 
        (: Name: casthc12 :)
(: Description: Simple test for casting a double as a double :)

xs:double(1267.43233E12) cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc12.txt')

!

test_casthc13

    | query result |

    query := ' 
        (: Name: casthc13 :)
(: Description: Simple test for casting a double as a string :)

xs:double(1267.43233E12) cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc13.txt')

!

test_casthc14

    | query result |

    query := ' 
        (: Name: casthc14 :)
(: Description: Simple test for casting a double as a float :)

(xs:double(1267.43233E12) cast as xs:float) eq xs:float(1267.43233E12)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_casthc15

    | query result |

    query := ' 
        (: Name: casthc15 :)
(: Description: Simple test for casting a double as a boolean :)

xs:double(1267.43233E12) cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc15.txt')

!

test_casthc16

    | query result |

    query := ' 
        (: Name: casthc16 :)
(: Description: Simple test for casting a decimal as a string :)

xs:decimal(12678967.543233) cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc16.txt')

!

test_casthc17

    | query result |

    query := ' 
        (: Name: casthc17 :)
(: Description: Simple test for casting a decimal as a float :)

xs:decimal(12678967.543233) cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc17.txt')

!

test_casthc18

    | query result |

    query := ' 
        (: Name: casthc18 :)
(: Description: Simple test for casting a decimal as a double :)

xs:decimal(12678967.543233) cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc18.txt')

!

test_casthc19

    | query result |

    query := ' 
        (: Name: casthc19 :)
(: Description: Simple test for casting a decimal as a decimal :)

xs:decimal(12678967.543233) cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc19.txt')

!

test_casthc2

    | query result |

    query := ' 
        (: Name: casthc2 :)
(: Description: Simple test for evaluation of a simple expression casted as xs:float :)

(5 + 5) cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc2.txt')

!

test_casthc20

    | query result |

    query := ' 
        (: Name: casthc20 :)
(: Description: Simple test for casting a decimal as a integer :)

xs:decimal(12678967.543233) cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc20.txt')

!

test_casthc21

    | query result |

    query := ' 
        (: Name: casthc21 :)
(: Description: Simple test for casting a decimal as a boolean :)

xs:decimal(12678967.543233) cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc21.txt')

!

test_casthc22

    | query result |

    query := ' 
        (: Name: casthc22 :)
(: Description: Simple test for casting an integer  as a string :)

xs:integer(12678967543233) cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc22.txt')

!

test_casthc23

    | query result |

    query := ' 
        (: Name: casthc23 :)
(: Description: Simple test for casting an integer as a float :)

(xs:integer(12678967543233) cast as xs:float) eq xs:float(12678967543233)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/truevalue.txt')

!

test_casthc24

    | query result |

    query := ' 
        (: Name: casthc24 :)
(: Description: Simple test for casting an integer as a double :)

xs:integer(12678967543233) cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc24.txt')

!

test_casthc25

    | query result |

    query := ' 
        (: Name: casthc25 :)
(: Description: Simple test for casting an integer as a decimal :)

xs:integer(12678967543233) cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc25.txt')

!

test_casthc26

    | query result |

    query := ' 
        (: Name: casthc26 :)
(: Description: Simple test for casting an integer as an integer :)

xs:integer(12678967543233) cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc26.txt')

!

test_casthc27

    | query result |

    query := ' 
        (: Name: casthc27 :)
(: Description: Simple test for casting an integer as a boolean :)

xs:integer(12678967543233) cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc27.txt')

!

test_casthc28

    | query result |

    query := ' 
        (: Name: casthc28 :)
(: Description: Simple test for casting an dateTime as a string :)

xs:dateTime("1999-05-31T13:20:00-05:00") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc28.txt')

!

test_casthc29

    | query result |

    query := ' 
        (: Name: casthc29 :)
(: Description: Simple test for casting an dateTime as a dateTime :)

xs:dateTime("1999-05-31T13:20:00-05:00") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc29.txt')

!

test_casthc3

    | query result |

    query := ' 
        (: Name: casthc3 :)
(: Description: Simple test for evaluation of a simple expression casted as xs:boolean :)

(5 + 5) cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc3.txt')

!

test_casthc30

    | query result |

    query := ' 
        (: Name: casthc30 :)
(: Description: Simple test for casting an dateTime as a time :)

xs:dateTime("1999-05-31T13:20:00-05:00") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc30.txt')

!

test_casthc31

    | query result |

    query := ' 
        (: Name: casthc31 :)
(: Description: Simple test for casting an dateTime as a date :)

xs:dateTime("1999-05-31T13:20:00-05:00") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc31.txt')

!

test_casthc32

    | query result |

    query := ' 
        (: Name: casthc32 :)
(: Description: Simple test for casting an date as a string :)

xs:date("1999-05-31") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc32.txt')

!

test_casthc33

    | query result |

    query := ' 
        (: Name: casthc33 :)
(: Description: Simple test for casting an date as a dateTime :)

xs:date("1999-05-31") cast as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc33.txt')

!

test_casthc34

    | query result |

    query := ' 
        (: Name: casthc34 :)
(: Description: Simple test for casting an date as a date :)

xs:date("1999-05-31") cast as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc34.txt')

!

test_casthc35

    | query result |

    query := ' 
        (: Name: casthc35 :)
(: Description: Simple test for casting an xs:time as a string :)

xs:time("12:00:00") cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc35.txt')

!

test_casthc36

    | query result |

    query := ' 
        (: Name: casthc36 :)
(: Description: Simple test for casting an xs:time as an xs:time :)

xs:time("12:00:00") cast as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc36.txt')

!

test_casthc37

    | query result |

    query := ' 
        (: Name: casthc37 :)
(: Description: Simple test for casting a boolean as string :)

fn:true() cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc37.txt')

!

test_casthc38

    | query result |

    query := ' 
        (: Name: casthc38 :)
(: Description: Simple test for casting a boolean as float :)

fn:true() cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc38.txt')

!

test_casthc39

    | query result |

    query := ' 
        (: Name: casthc39 :)
(: Description: Simple test for casting a boolean as double :)

fn:true() cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc39.txt')

!

test_casthc4

    | query result |

    query := ' 
        (: Name: casthc4 :)
(: Description: Simple test for evaluation of a simple expression casted as xs:double :)

(5 + 5) cast as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc4.txt')

!

test_casthc40

    | query result |

    query := ' 
        (: Name: casthc40 :)
(: Description: Simple test for casting a boolean as decimal :)

fn:true() cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc40.txt')

!

test_casthc41

    | query result |

    query := ' 
        (: Name: casthc41 :)
(: Description: Simple test for casting a boolean as integer :)

fn:true() cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc41.txt')

!

test_casthc42

    | query result |

    query := ' 
        (: Name: casthc42 :)
(: Description: Simple test for casting a boolean as boolean :)

fn:true() cast as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc42.txt')

!

test_casthc5

    | query result |

    query := ' 
        (: Name: casthc5 :)
(: Description: Simple test for evaluation of a simple expression casted as xs:decimal :)

(5 + 5) cast as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc5.txt')

!

test_casthc6

    | query result |

    query := ' 
        (: Name: casthc6 :)
(: Description: Simple test for evaluation of a simple expression casted as xs:string :)

(5 + 5) cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc6.txt')

!

test_casthc7

    | query result |

    query := ' 
        (: Name: casthc7 :)
(: Description: Simple test for evaluation a string casted as xs:string :)

"A String" cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc7.txt')

!

test_casthc8

    | query result |

    query := ' 
        (: Name: casthc8 :)
(: Description: Simple test for casting a float as a float :)

xs:float(2.1E3) cast as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc8.txt')

!

test_casthc9

    | query result |

    query := ' 
        (: Name: casthc9 :)
(: Description: Simple test for casting a float as a string :)

xs:float(2.1E3) cast as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCast/casthc9.txt')

! !

!XQTSSeqExprCastSupportedTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
