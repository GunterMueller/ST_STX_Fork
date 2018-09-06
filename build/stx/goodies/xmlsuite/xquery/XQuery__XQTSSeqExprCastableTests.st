"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSSeqExprCastableTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSSeqExprCastableTests methodsFor:'tests'!

test_CastableAs001

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs001:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:16-07:00:)
(:Purpose:Try xs:untypedAtomic(INF) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:untypedAtomic("INF") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs001.txt')

!

test_CastableAs002

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs002:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:16-07:00:)
(:Purpose:Try xs:untypedAtomic(0.0E0) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:untypedAtomic("0.0E0") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs002.txt')

!

test_CastableAs003

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs003:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:16-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs003.txt')

!

test_CastableAs004

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs004:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:16-07:00:)
(:Purpose:Try xs:untypedAtomic(INF) castable as xs:string:)
(:*******************************************************:)

xs:untypedAtomic("INF") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs004.txt')

!

test_CastableAs005

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs005:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:16-07:00:)
(:Purpose:Try xs:untypedAtomic(0.0E0) castable as xs:string:)
(:*******************************************************:)

xs:untypedAtomic("0.0E0") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs005.txt')

!

test_CastableAs006

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs006:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:string:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs006.txt')

!

test_CastableAs007

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs007:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-0.0E0) castable as xs:float:)
(:*******************************************************:)

xs:untypedAtomic("-0.0E0") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs007.txt')

!

test_CastableAs008

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs008:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(NaN) castable as xs:float:)
(:*******************************************************:)

xs:untypedAtomic("NaN") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs008.txt')

!

test_CastableAs009

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs009:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(1e-5) castable as xs:float:)
(:*******************************************************:)

xs:untypedAtomic("1e-5") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs009.txt')

!

test_CastableAs010

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs010:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-10000000) castable as xs:float:)
(:*******************************************************:)

xs:untypedAtomic("-10000000") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs010.txt')

!

test_CastableAs011

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs011:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:float:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs011.txt')

!

test_CastableAs012

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs012:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-0.0E0) castable as xs:double:)
(:*******************************************************:)

xs:untypedAtomic("-0.0E0") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs012.txt')

!

test_CastableAs013

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs013:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(NaN) castable as xs:double:)
(:*******************************************************:)

xs:untypedAtomic("NaN") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs013.txt')

!

test_CastableAs014

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs014:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(1e-5) castable as xs:double:)
(:*******************************************************:)

xs:untypedAtomic("1e-5") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs014.txt')

!

test_CastableAs015

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs015:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-10000000) castable as xs:double:)
(:*******************************************************:)

xs:untypedAtomic("-10000000") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs015.txt')

!

test_CastableAs016

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs016:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:double:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs016.txt')

!

test_CastableAs017

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs017:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-0.0E0) castable as xs:decimal:)
(:*******************************************************:)

xs:untypedAtomic("-0.0E0") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs017.txt')

!

test_CastableAs018

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs018:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(NaN) castable as xs:decimal:)
(:*******************************************************:)

xs:untypedAtomic("NaN") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs018.txt')

!

test_CastableAs019

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs019:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(1e-5) castable as xs:decimal:)
(:*******************************************************:)

xs:untypedAtomic("1e-5") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs019.txt')

!

test_CastableAs020

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs020:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(5.5432) castable as xs:decimal:)
(:*******************************************************:)

xs:untypedAtomic("5.5432") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs020.txt')

!

test_CastableAs021

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs021:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:decimal:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs021.txt')

!

test_CastableAs022

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs022:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-0.0E0) castable as xs:integer:)
(:*******************************************************:)

xs:untypedAtomic("-0.0E0") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs022.txt')

!

test_CastableAs023

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs023:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(NaN) castable as xs:integer:)
(:*******************************************************:)

xs:untypedAtomic("NaN") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs023.txt')

!

test_CastableAs024

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs024:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(1e-5) castable as xs:integer:)
(:*******************************************************:)

xs:untypedAtomic("1e-5") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs024.txt')

!

test_CastableAs025

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs025:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-1.1234) castable as xs:integer:)
(:*******************************************************:)

xs:untypedAtomic("-1.1234") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs025.txt')

!

test_CastableAs026

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs026:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:integer:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs026.txt')

!

test_CastableAs027

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs027:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(P1Y2M3DT10H30M23S) castable as xs:duration:)
(:*******************************************************:)

xs:untypedAtomic("P1Y2M3DT10H30M23S") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs027.txt')

!

test_CastableAs028

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs028:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-P1Y1M1DT1H1M1.123S) castable as xs:duration:)
(:*******************************************************:)

xs:untypedAtomic("-P1Y1M1DT1H1M1.123S") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs028.txt')

!

test_CastableAs029

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs029:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:duration:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs029.txt')

!

test_CastableAs030

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs030:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-P1Y1M1DT1H1M1.123S) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:untypedAtomic("-P1Y1M1DT1H1M1.123S") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs030.txt')

!

test_CastableAs031

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs031:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(P24M) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:untypedAtomic("P24M") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs031.txt')

!

test_CastableAs032

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs032:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-P21M) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:untypedAtomic("-P21M") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs032.txt')

!

test_CastableAs033

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs033:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs033.txt')

!

test_CastableAs034

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs034:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-P1Y1M1DT1H1M1.123S) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:untypedAtomic("-P1Y1M1DT1H1M1.123S") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs034.txt')

!

test_CastableAs035

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs035:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(P3DT10H30M) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:untypedAtomic("P3DT10H30M") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs035.txt')

!

test_CastableAs036

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs036:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-PT100M) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:untypedAtomic("-PT100M") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs036.txt')

!

test_CastableAs037

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs037:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs037.txt')

!

test_CastableAs038

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs038:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(1999-05-31T13:20:00) castable as xs:dateTime:)
(:*******************************************************:)

xs:untypedAtomic("1999-05-31T13:20:00") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs038.txt')

!

test_CastableAs039

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs039:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-1999-05-31T13:20:00+14:00) castable as xs:dateTime:)
(:*******************************************************:)

xs:untypedAtomic("-1999-05-31T13:20:00+14:00") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs039.txt')

!

test_CastableAs040

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs040:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(2000-01-16T00:00:00Z) castable as xs:dateTime:)
(:*******************************************************:)

xs:untypedAtomic("2000-01-16T00:00:00Z") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs040.txt')

!

test_CastableAs041

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs041:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:dateTime:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs041.txt')

!

test_CastableAs042

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs042:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(13:20:00-05:00) castable as xs:time:)
(:*******************************************************:)

xs:untypedAtomic("13:20:00-05:00") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs042.txt')

!

test_CastableAs043

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs043:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(13:20:02.123) castable as xs:time:)
(:*******************************************************:)

xs:untypedAtomic("13:20:02.123") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs043.txt')

!

test_CastableAs044

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs044:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(13:20:00Z) castable as xs:time:)
(:*******************************************************:)

xs:untypedAtomic("13:20:00Z") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs044.txt')

!

test_CastableAs045

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs045:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:time:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs045.txt')

!

test_CastableAs046

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs046:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(1999-05-31) castable as xs:date:)
(:*******************************************************:)

xs:untypedAtomic("1999-05-31") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs046.txt')

!

test_CastableAs047

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs047:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-0012-12-03-05:00) castable as xs:date:)
(:*******************************************************:)

xs:untypedAtomic("-0012-12-03-05:00") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs047.txt')

!

test_CastableAs048

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs048:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(1999-05-31Z) castable as xs:date:)
(:*******************************************************:)

xs:untypedAtomic("1999-05-31Z") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs048.txt')

!

test_CastableAs049

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs049:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:date:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs049.txt')

!

test_CastableAs050

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs050:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(1999-05) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:untypedAtomic("1999-05") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs050.txt')

!

test_CastableAs051

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs051:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(-0012-12-05:00) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:untypedAtomic("-0012-12-05:00") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs051.txt')

!

test_CastableAs052

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs052:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(1999-05Z) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:untypedAtomic("1999-05Z") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs052.txt')

!

test_CastableAs053

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs053:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:17-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs053.txt')

!

test_CastableAs054

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs054:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(1999) castable as xs:gYear:)
(:*******************************************************:)

xs:untypedAtomic("1999") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs054.txt')

!

test_CastableAs055

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs055:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(-0012-05:00) castable as xs:gYear:)
(:*******************************************************:)

xs:untypedAtomic("-0012-05:00") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs055.txt')

!

test_CastableAs056

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs056:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(1999Z) castable as xs:gYear:)
(:*******************************************************:)

xs:untypedAtomic("1999Z") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs056.txt')

!

test_CastableAs057

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs057:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:gYear:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs057.txt')

!

test_CastableAs058

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs058:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(--05-31) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:untypedAtomic("--05-31") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs058.txt')

!

test_CastableAs059

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs059:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(--05-31+14:00) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:untypedAtomic("--05-31+14:00") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs059.txt')

!

test_CastableAs060

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs060:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(--05-31Z) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:untypedAtomic("--05-31Z") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs060.txt')

!

test_CastableAs061

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs061:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs061.txt')

!

test_CastableAs062

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs062:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(---31) castable as xs:gDay:)
(:*******************************************************:)

xs:untypedAtomic("---31") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs062.txt')

!

test_CastableAs063

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs063:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(---03-05:00) castable as xs:gDay:)
(:*******************************************************:)

xs:untypedAtomic("---03-05:00") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs063.txt')

!

test_CastableAs064

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs064:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(---31Z) castable as xs:gDay:)
(:*******************************************************:)

xs:untypedAtomic("---31Z") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs064.txt')

!

test_CastableAs065

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs065:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:gDay:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs065.txt')

!

test_CastableAs066

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs066:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(--05) castable as xs:gMonth:)
(:*******************************************************:)

xs:untypedAtomic("--05") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs066.txt')

!

test_CastableAs067

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs067:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(--12-05:00) castable as xs:gMonth:)
(:*******************************************************:)

xs:untypedAtomic("--12-05:00") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs067.txt')

!

test_CastableAs068

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs068:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(--05Z) castable as xs:gMonth:)
(:*******************************************************:)

xs:untypedAtomic("--05Z") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs068.txt')

!

test_CastableAs069

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs069:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:gMonth:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs069.txt')

!

test_CastableAs070

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs070:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(0.0) castable as xs:boolean:)
(:*******************************************************:)

xs:untypedAtomic("0.0") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs070.txt')

!

test_CastableAs071

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs071:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(0) castable as xs:boolean:)
(:*******************************************************:)

xs:untypedAtomic("0") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs071.txt')

!

test_CastableAs072

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs072:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:boolean:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs072.txt')

!

test_CastableAs073

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs073:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:base64Binary:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs073.txt')

!

test_CastableAs074

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs074:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(00000000) castable as xs:base64Binary:)
(:*******************************************************:)

xs:untypedAtomic("00000000") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs074.txt')

!

test_CastableAs075

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs075:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(D74D35D35D35) castable as xs:base64Binary:)
(:*******************************************************:)

xs:untypedAtomic("D74D35D35D35") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs075.txt')

!

test_CastableAs076

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs076:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:hexBinary:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs076.txt')

!

test_CastableAs077

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs077:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(010010101) castable as xs:hexBinary:)
(:*******************************************************:)

xs:untypedAtomic("010010101") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs077.txt')

!

test_CastableAs078

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs078:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(0fb7) castable as xs:hexBinary:)
(:*******************************************************:)

xs:untypedAtomic("0fb7") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs078.txt')

!

test_CastableAs079

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs079:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(D74D35D35D35) castable as xs:hexBinary:)
(:*******************************************************:)

xs:untypedAtomic("D74D35D35D35") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs079.txt')

!

test_CastableAs080

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs080:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(-0012-05:00) castable as xs:anyURI:)
(:*******************************************************:)

xs:untypedAtomic("http://www.example.com/~b%C3%A9b%C3%A9") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs080.txt')

!

test_CastableAs081

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs081:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(true) castable as xs:anyURI:)
(:*******************************************************:)

xs:untypedAtomic("true") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs081.txt')

!

test_CastableAs082

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs082:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:untypedAtomic(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:anyURI:)
(:*******************************************************:)

xs:untypedAtomic("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs082.txt')

!

test_CastableAs083

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs083:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(INF) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:string("INF") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs083.txt')

!

test_CastableAs084

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs084:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(0.0E0) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:string("0.0E0") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs084.txt')

!

test_CastableAs085

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs085:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(true) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:string("true") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs085.txt')

!

test_CastableAs086

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs086:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(INF) castable as xs:string:)
(:*******************************************************:)

xs:string("INF") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs086.txt')

!

test_CastableAs087

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs087:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(0.0E0) castable as xs:string:)
(:*******************************************************:)

xs:string("0.0E0") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs087.txt')

!

test_CastableAs088

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs088:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(true) castable as xs:string:)
(:*******************************************************:)

xs:string("true") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs088.txt')

!

test_CastableAs089

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs089:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(-0.0E0) castable as xs:float:)
(:*******************************************************:)

xs:string("-0.0E0") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs089.txt')

!

test_CastableAs090

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs090:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(NaN) castable as xs:float:)
(:*******************************************************:)

xs:string("NaN") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs090.txt')

!

test_CastableAs091

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs091:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(1e-5) castable as xs:float:)
(:*******************************************************:)

xs:string("1e-5") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs091.txt')

!

test_CastableAs092

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs092:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(-10000000) castable as xs:float:)
(:*******************************************************:)

xs:string("-10000000") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs092.txt')

!

test_CastableAs093

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs093:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(true) castable as xs:float:)
(:*******************************************************:)

xs:string("true") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs093.txt')

!

test_CastableAs094

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs094:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(-0.0E0) castable as xs:double:)
(:*******************************************************:)

xs:string("-0.0E0") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs094.txt')

!

test_CastableAs095

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs095:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(NaN) castable as xs:double:)
(:*******************************************************:)

xs:string("NaN") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs095.txt')

!

test_CastableAs096

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs096:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(1e-5) castable as xs:double:)
(:*******************************************************:)

xs:string("1e-5") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs096.txt')

!

test_CastableAs097

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs097:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(-10000000) castable as xs:double:)
(:*******************************************************:)

xs:string("-10000000") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs097.txt')

!

test_CastableAs098

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs098:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(true) castable as xs:double:)
(:*******************************************************:)

xs:string("true") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs098.txt')

!

test_CastableAs099

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs099:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(-0.0E0) castable as xs:decimal:)
(:*******************************************************:)

xs:string("-0.0E0") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs099.txt')

!

test_CastableAs100

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs100:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(NaN) castable as xs:decimal:)
(:*******************************************************:)

xs:string("NaN") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs100.txt')

!

test_CastableAs101

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs101:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(1e-5) castable as xs:decimal:)
(:*******************************************************:)

xs:string("1e-5") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs101.txt')

!

test_CastableAs102

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs102:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(5.5432) castable as xs:decimal:)
(:*******************************************************:)

xs:string("5.5432") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs102.txt')

!

test_CastableAs103

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs103:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(true) castable as xs:decimal:)
(:*******************************************************:)

xs:string("true") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs103.txt')

!

test_CastableAs104

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs104:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(-0.0E0) castable as xs:integer:)
(:*******************************************************:)

xs:string("-0.0E0") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs104.txt')

!

test_CastableAs105

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs105:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(NaN) castable as xs:integer:)
(:*******************************************************:)

xs:string("NaN") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs105.txt')

!

test_CastableAs106

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs106:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(1e-5) castable as xs:integer:)
(:*******************************************************:)

xs:string("1e-5") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs106.txt')

!

test_CastableAs107

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs107:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(-1.1234) castable as xs:integer:)
(:*******************************************************:)

xs:string("-1.1234") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs107.txt')

!

test_CastableAs108

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs108:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(true) castable as xs:integer:)
(:*******************************************************:)

xs:string("true") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs108.txt')

!

test_CastableAs109

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs109:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(P1Y2M3DT10H30M23S) castable as xs:duration:)
(:*******************************************************:)

xs:string("P1Y2M3DT10H30M23S") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs109.txt')

!

test_CastableAs110

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs110:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:18-07:00:)
(:Purpose:Try xs:string(-P1Y1M1DT1H1M1.123S) castable as xs:duration:)
(:*******************************************************:)

xs:string("-P1Y1M1DT1H1M1.123S") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs110.txt')

!

test_CastableAs111

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs111:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:duration:)
(:*******************************************************:)

xs:string("true") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs111.txt')

!

test_CastableAs112

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs112:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(-P1Y1M1DT1H1M1.123S) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:string("-P1Y1M1DT1H1M1.123S") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs112.txt')

!

test_CastableAs113

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs113:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(P24M) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:string("P24M") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs113.txt')

!

test_CastableAs114

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs114:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(-P21M) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:string("-P21M") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs114.txt')

!

test_CastableAs115

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs115:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:string("true") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs115.txt')

!

test_CastableAs116

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs116:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(-P1Y1M1DT1H1M1.123S) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:string("-P1Y1M1DT1H1M1.123S") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs116.txt')

!

test_CastableAs117

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs117:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(P3DT10H30M) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:string("P3DT10H30M") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs117.txt')

!

test_CastableAs118

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs118:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(-PT100M) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:string("-PT100M") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs118.txt')

!

test_CastableAs119

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs119:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:string("true") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs119.txt')

!

test_CastableAs120

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs120:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(1999-05-31T13:20:00) castable as xs:dateTime:)
(:*******************************************************:)

xs:string("1999-05-31T13:20:00") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs120.txt')

!

test_CastableAs121

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs121:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(-1999-05-31T13:20:00+14:00) castable as xs:dateTime:)
(:*******************************************************:)

xs:string("-1999-05-31T13:20:00+14:00") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs121.txt')

!

test_CastableAs122

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs122:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(2000-01-16T00:00:00Z) castable as xs:dateTime:)
(:*******************************************************:)

xs:string("2000-01-16T00:00:00Z") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs122.txt')

!

test_CastableAs123

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs123:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:dateTime:)
(:*******************************************************:)

xs:string("true") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs123.txt')

!

test_CastableAs124

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs124:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(13:20:00-05:00) castable as xs:time:)
(:*******************************************************:)

xs:string("13:20:00-05:00") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs124.txt')

!

test_CastableAs125

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs125:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(13:20:02.123) castable as xs:time:)
(:*******************************************************:)

xs:string("13:20:02.123") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs125.txt')

!

test_CastableAs126

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs126:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(13:20:00Z) castable as xs:time:)
(:*******************************************************:)

xs:string("13:20:00Z") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs126.txt')

!

test_CastableAs127

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs127:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:time:)
(:*******************************************************:)

xs:string("true") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs127.txt')

!

test_CastableAs128

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs128:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(1999-05-31) castable as xs:date:)
(:*******************************************************:)

xs:string("1999-05-31") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs128.txt')

!

test_CastableAs129

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs129:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(-0012-12-03-05:00) castable as xs:date:)
(:*******************************************************:)

xs:string("-0012-12-03-05:00") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs129.txt')

!

test_CastableAs130

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs130:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(1999-05-31Z) castable as xs:date:)
(:*******************************************************:)

xs:string("1999-05-31Z") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs130.txt')

!

test_CastableAs131

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs131:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:date:)
(:*******************************************************:)

xs:string("true") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs131.txt')

!

test_CastableAs132

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs132:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(1999-05) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:string("1999-05") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs132.txt')

!

test_CastableAs133

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs133:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(-0012-12-05:00) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:string("-0012-12-05:00") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs133.txt')

!

test_CastableAs134

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs134:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(1999-05Z) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:string("1999-05Z") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs134.txt')

!

test_CastableAs135

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs135:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:string("true") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs135.txt')

!

test_CastableAs136

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs136:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(1999) castable as xs:gYear:)
(:*******************************************************:)

xs:string("1999") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs136.txt')

!

test_CastableAs137

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs137:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(-0012-05:00) castable as xs:gYear:)
(:*******************************************************:)

xs:string("-0012-05:00") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs137.txt')

!

test_CastableAs138

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs138:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(1999Z) castable as xs:gYear:)
(:*******************************************************:)

xs:string("1999Z") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs138.txt')

!

test_CastableAs139

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs139:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:gYear:)
(:*******************************************************:)

xs:string("true") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs139.txt')

!

test_CastableAs140

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs140:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(--05-31) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:string("--05-31") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs140.txt')

!

test_CastableAs141

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs141:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(--05-31+14:00) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:string("--05-31+14:00") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs141.txt')

!

test_CastableAs142

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs142:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(--05-31Z) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:string("--05-31Z") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs142.txt')

!

test_CastableAs143

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs143:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:string("true") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs143.txt')

!

test_CastableAs144

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs144:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(---31) castable as xs:gDay:)
(:*******************************************************:)

xs:string("---31") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs144.txt')

!

test_CastableAs145

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs145:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(---03-05:00) castable as xs:gDay:)
(:*******************************************************:)

xs:string("---03-05:00") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs145.txt')

!

test_CastableAs146

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs146:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(---31Z) castable as xs:gDay:)
(:*******************************************************:)

xs:string("---31Z") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs146.txt')

!

test_CastableAs147

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs147:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:gDay:)
(:*******************************************************:)

xs:string("true") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs147.txt')

!

test_CastableAs148

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs148:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(--05) castable as xs:gMonth:)
(:*******************************************************:)

xs:string("--05") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs148.txt')

!

test_CastableAs149

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs149:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(--12-05:00) castable as xs:gMonth:)
(:*******************************************************:)

xs:string("--12-05:00") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs149.txt')

!

test_CastableAs150

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs150:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(--05Z) castable as xs:gMonth:)
(:*******************************************************:)

xs:string("--05Z") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs150.txt')

!

test_CastableAs151

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs151:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:gMonth:)
(:*******************************************************:)

xs:string("true") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs151.txt')

!

test_CastableAs152

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs152:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(0.0) castable as xs:boolean:)
(:*******************************************************:)

xs:string("0.0") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs152.txt')

!

test_CastableAs153

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs153:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(0) castable as xs:boolean:)
(:*******************************************************:)

xs:string("0") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs153.txt')

!

test_CastableAs154

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs154:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:boolean:)
(:*******************************************************:)

xs:string("true") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs154.txt')

!

test_CastableAs155

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs155:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:base64Binary:)
(:*******************************************************:)

xs:string("true") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs155.txt')

!

test_CastableAs156

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs156:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(00000000) castable as xs:base64Binary:)
(:*******************************************************:)

xs:string("00000000") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs156.txt')

!

test_CastableAs157

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs157:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(D74D35D35D35) castable as xs:base64Binary:)
(:*******************************************************:)

xs:string("D74D35D35D35") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs157.txt')

!

test_CastableAs158

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs158:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:hexBinary:)
(:*******************************************************:)

xs:string("true") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs158.txt')

!

test_CastableAs159

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs159:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(010010101) castable as xs:hexBinary:)
(:*******************************************************:)

xs:string("010010101") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs159.txt')

!

test_CastableAs160

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs160:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(0fb7) castable as xs:hexBinary:)
(:*******************************************************:)

xs:string("0fb7") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs160.txt')

!

test_CastableAs161

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs161:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(D74D35D35D35) castable as xs:hexBinary:)
(:*******************************************************:)

xs:string("D74D35D35D35") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs161.txt')

!

test_CastableAs162

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs162:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(-0012-05:00) castable as xs:anyURI:)
(:*******************************************************:)

xs:string("http://www.example.com/~b%C3%A9b%C3%A9") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs162.txt')

!

test_CastableAs163

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs163:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(true) castable as xs:anyURI:)
(:*******************************************************:)

xs:string("true") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs163.txt')

!

test_CastableAs164

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs164:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:string(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:anyURI:)
(:*******************************************************:)

xs:string("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs164.txt')

!

test_CastableAs165

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs165:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:float(1e5) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:float("1e5") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs165.txt')

!

test_CastableAs166

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs166:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:float(-INF) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:float("-INF") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs166.txt')

!

test_CastableAs167

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs167:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:float(-0.0E0) castable as xs:string:)
(:*******************************************************:)

xs:float("-0.0E0") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs167.txt')

!

test_CastableAs168

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs168:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:float(NaN) castable as xs:string:)
(:*******************************************************:)

xs:float("NaN") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs168.txt')

!

test_CastableAs169

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs169:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:19-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:float:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs169.txt')

!

test_CastableAs170

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs170:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(-1.75e-3) castable as xs:float:)
(:*******************************************************:)

xs:float("-1.75e-3") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs170.txt')

!

test_CastableAs171

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs171:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(INF) castable as xs:float:)
(:*******************************************************:)

xs:float("INF") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs171.txt')

!

test_CastableAs172

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs172:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(-0.0E0) castable as xs:double:)
(:*******************************************************:)

xs:float("-0.0E0") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs172.txt')

!

test_CastableAs173

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs173:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(-INF) castable as xs:double:)
(:*******************************************************:)

xs:float("-INF") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs173.txt')

!

test_CastableAs174

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs174:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(-0.0E0) castable as xs:decimal:)
(:*******************************************************:)

xs:float("-0.0E0") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs174.txt')

!

test_CastableAs175

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs175:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:decimal:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs175.txt')

!

test_CastableAs176

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs176:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(1e5) castable as xs:decimal:)
(:*******************************************************:)

xs:float("1e5") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs176.txt')

!

test_CastableAs177

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs177:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(-1.75e-3) castable as xs:decimal:)
(:*******************************************************:)

xs:float("-1.75e-3") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs177.txt')

!

test_CastableAs178

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs178:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(-0.0E0) castable as xs:integer:)
(:*******************************************************:)

xs:float("-0.0E0") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs178.txt')

!

test_CastableAs179

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs179:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(1e5) castable as xs:integer:)
(:*******************************************************:)

xs:float("1e5") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs179.txt')

!

test_CastableAs180

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs180:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(INF) castable as xs:integer:)
(:*******************************************************:)

xs:float("INF") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs180.txt')

!

test_CastableAs181

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs181:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(-1.75e-3) castable as xs:duration:)
(:*******************************************************:)

xs:float("-1.75e-3") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs181.txt')

!

test_CastableAs182

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs182:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs182.txt')

!

test_CastableAs183

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs183:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs183.txt')

!

test_CastableAs184

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs184:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:dateTime:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs184.txt')

!

test_CastableAs185

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs185:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:time:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs185.txt')

!

test_CastableAs186

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs186:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:date:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs186.txt')

!

test_CastableAs187

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs187:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs187.txt')

!

test_CastableAs188

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs188:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:gYear:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs188.txt')

!

test_CastableAs189

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs189:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs189.txt')

!

test_CastableAs190

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs190:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:gDay:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs190.txt')

!

test_CastableAs191

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs191:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:gMonth:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs191.txt')

!

test_CastableAs192

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs192:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(-0.0E0) castable as xs:boolean:)
(:*******************************************************:)

xs:float("-0.0E0") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs192.txt')

!

test_CastableAs193

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs193:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(1e5) castable as xs:boolean:)
(:*******************************************************:)

xs:float("1e5") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs193.txt')

!

test_CastableAs194

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs194:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(-INF) castable as xs:boolean:)
(:*******************************************************:)

xs:float("-INF") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs194.txt')

!

test_CastableAs195

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs195:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(NaN) castable as xs:boolean:)
(:*******************************************************:)

xs:float("NaN") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs195.txt')

!

test_CastableAs196

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs196:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:base64Binary:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs196.txt')

!

test_CastableAs197

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs197:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:hexBinary:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs197.txt')

!

test_CastableAs198

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs198:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:float(5.4321E-100) castable as xs:anyURI:)
(:*******************************************************:)

xs:float("5.4321E-100") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs198.txt')

!

test_CastableAs199

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs199:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:double("1e5") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs199.txt')

!

test_CastableAs200

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs200:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(INF) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:double("INF") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs200.txt')

!

test_CastableAs201

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs201:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e8) castable as xs:string:)
(:*******************************************************:)

xs:double("1e8") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs201.txt')

!

test_CastableAs202

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs202:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(INF) castable as xs:string:)
(:*******************************************************:)

xs:double("INF") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs202.txt')

!

test_CastableAs203

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs203:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(-0.0E0) castable as xs:float:)
(:*******************************************************:)

xs:double("-0.0E0") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs203.txt')

!

test_CastableAs204

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs204:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(5.4321E-1001) castable as xs:float:)
(:*******************************************************:)

xs:double("5.4321E-1001") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs204.txt')

!

test_CastableAs205

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs205:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:float:)
(:*******************************************************:)

xs:double("1e5") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs205.txt')

!

test_CastableAs206

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs206:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(-1.75e-3) castable as xs:float:)
(:*******************************************************:)

xs:double("-1.75e-3") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs206.txt')

!

test_CastableAs207

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs207:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(NaN) castable as xs:float:)
(:*******************************************************:)

xs:double("NaN") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs207.txt')

!

test_CastableAs208

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs208:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:double:)
(:*******************************************************:)

xs:double("1e5") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs208.txt')

!

test_CastableAs209

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs209:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(INF) castable as xs:double:)
(:*******************************************************:)

xs:double("INF") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs209.txt')

!

test_CastableAs210

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs210:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(-0.0E0) castable as xs:decimal:)
(:*******************************************************:)

xs:double("-0.0E0") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs210.txt')

!

test_CastableAs211

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs211:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(5.4321E-1001) castable as xs:decimal:)
(:*******************************************************:)

xs:double("5.4321E-1001") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs211.txt')

!

test_CastableAs212

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs212:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(-1.75e-3) castable as xs:decimal:)
(:*******************************************************:)

xs:double("-1.75e-3") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs212.txt')

!

test_CastableAs213

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs213:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(INF) castable as xs:decimal:)
(:*******************************************************:)

xs:double("INF") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs213.txt')

!

test_CastableAs214

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs214:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(-0.0E0) castable as xs:integer:)
(:*******************************************************:)

xs:double("-0.0E0") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs214.txt')

!

test_CastableAs215

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs215:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:integer:)
(:*******************************************************:)

xs:double("1e5") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs215.txt')

!

test_CastableAs216

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs216:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(-1.75e-3) castable as xs:integer:)
(:*******************************************************:)

xs:double("-1.75e-3") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs216.txt')

!

test_CastableAs217

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs217:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(INF) castable as xs:integer:)
(:*******************************************************:)

xs:double("INF") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs217.txt')

!

test_CastableAs218

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs218:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(NaN) castable as xs:integer:)
(:*******************************************************:)

xs:double("NaN") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs218.txt')

!

test_CastableAs219

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs219:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:duration:)
(:*******************************************************:)

xs:double("1e5") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs219.txt')

!

test_CastableAs220

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs220:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:double("1e5") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs220.txt')

!

test_CastableAs221

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs221:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:double("1e5") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs221.txt')

!

test_CastableAs222

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs222:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:dateTime:)
(:*******************************************************:)

xs:double("1e5") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs222.txt')

!

test_CastableAs223

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs223:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:time:)
(:*******************************************************:)

xs:double("1e5") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs223.txt')

!

test_CastableAs224

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs224:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:date:)
(:*******************************************************:)

xs:double("1e5") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs224.txt')

!

test_CastableAs225

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs225:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:double("1e5") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs225.txt')

!

test_CastableAs226

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs226:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:gYear:)
(:*******************************************************:)

xs:double("1e5") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs226.txt')

!

test_CastableAs227

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs227:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:double("1e5") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs227.txt')

!

test_CastableAs228

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs228:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:gDay:)
(:*******************************************************:)

xs:double("1e5") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs228.txt')

!

test_CastableAs229

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs229:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:gMonth:)
(:*******************************************************:)

xs:double("1e5") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs229.txt')

!

test_CastableAs230

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs230:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:boolean:)
(:*******************************************************:)

xs:double("1e5") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs230.txt')

!

test_CastableAs231

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs231:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:base64Binary:)
(:*******************************************************:)

xs:double("1e5") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs231.txt')

!

test_CastableAs232

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs232:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:hexBinary:)
(:*******************************************************:)

xs:double("1e5") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs232.txt')

!

test_CastableAs233

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs233:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:double(1e5) castable as xs:anyURI:)
(:*******************************************************:)

xs:double("1e5") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs233.txt')

!

test_CastableAs234

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs234:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs234.txt')

!

test_CastableAs235

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs235:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:string:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs235.txt')

!

test_CastableAs236

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs236:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:float:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs236.txt')

!

test_CastableAs237

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs237:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:double:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs237.txt')

!

test_CastableAs238

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs238:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:decimal:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs238.txt')

!

test_CastableAs239

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs239:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:integer:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs239.txt')

!

test_CastableAs240

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs240:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(5.5432) castable as xs:integer:)
(:*******************************************************:)

xs:decimal("5.5432") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs240.txt')

!

test_CastableAs241

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs241:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:duration:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs241.txt')

!

test_CastableAs242

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs242:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs242.txt')

!

test_CastableAs243

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs243:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs243.txt')

!

test_CastableAs244

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs244:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:dateTime:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs244.txt')

!

test_CastableAs245

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs245:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:time:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs245.txt')

!

test_CastableAs246

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs246:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:date:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs246.txt')

!

test_CastableAs247

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs247:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs247.txt')

!

test_CastableAs248

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs248:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:gYear:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs248.txt')

!

test_CastableAs249

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs249:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs249.txt')

!

test_CastableAs250

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs250:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:gDay:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs250.txt')

!

test_CastableAs251

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs251:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:gMonth:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs251.txt')

!

test_CastableAs252

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs252:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:boolean:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs252.txt')

!

test_CastableAs253

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs253:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:base64Binary:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs253.txt')

!

test_CastableAs254

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs254:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:hexBinary:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs254.txt')

!

test_CastableAs255

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs255:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:decimal(-1.1234) castable as xs:anyURI:)
(:*******************************************************:)

xs:decimal("-1.1234") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs255.txt')

!

test_CastableAs256

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs256:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(1) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:integer("1") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs256.txt')

!

test_CastableAs257

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs257:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:string:)
(:*******************************************************:)

xs:integer("-100") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs257.txt')

!

test_CastableAs258

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs258:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:float:)
(:*******************************************************:)

xs:integer("-100") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs258.txt')

!

test_CastableAs259

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs259:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:double:)
(:*******************************************************:)

xs:integer("-100") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs259.txt')

!

test_CastableAs260

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs260:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:decimal:)
(:*******************************************************:)

xs:integer("-100") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs260.txt')

!

test_CastableAs261

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs261:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:integer:)
(:*******************************************************:)

xs:integer("-100") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs261.txt')

!

test_CastableAs262

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs262:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:duration:)
(:*******************************************************:)

xs:integer("-100") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs262.txt')

!

test_CastableAs263

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs263:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:integer("-100") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs263.txt')

!

test_CastableAs264

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs264:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:integer("-100") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs264.txt')

!

test_CastableAs265

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs265:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:dateTime:)
(:*******************************************************:)

xs:integer("-100") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs265.txt')

!

test_CastableAs266

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs266:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:time:)
(:*******************************************************:)

xs:integer("-100") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs266.txt')

!

test_CastableAs267

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs267:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:date:)
(:*******************************************************:)

xs:integer("-100") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs267.txt')

!

test_CastableAs268

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs268:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:integer("-100") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs268.txt')

!

test_CastableAs269

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs269:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:gYear:)
(:*******************************************************:)

xs:integer("-100") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs269.txt')

!

test_CastableAs270

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs270:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:integer("-100") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs270.txt')

!

test_CastableAs271

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs271:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:gDay:)
(:*******************************************************:)

xs:integer("-100") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs271.txt')

!

test_CastableAs272

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs272:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:gMonth:)
(:*******************************************************:)

xs:integer("-100") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs272.txt')

!

test_CastableAs273

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs273:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:boolean:)
(:*******************************************************:)

xs:integer("-100") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs273.txt')

!

test_CastableAs274

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs274:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:base64Binary:)
(:*******************************************************:)

xs:integer("-100") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs274.txt')

!

test_CastableAs275

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs275:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:hexBinary:)
(:*******************************************************:)

xs:integer("-100") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs275.txt')

!

test_CastableAs276

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs276:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:integer(-100) castable as xs:anyURI:)
(:*******************************************************:)

xs:integer("-100") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs276.txt')

!

test_CastableAs277

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs277:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs277.txt')

!

test_CastableAs278

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs278:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:string:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs278.txt')

!

test_CastableAs279

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs279:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:20-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:float:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs279.txt')

!

test_CastableAs280

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs280:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:double:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs280.txt')

!

test_CastableAs281

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs281:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:decimal:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs281.txt')

!

test_CastableAs282

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs282:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:integer:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs282.txt')

!

test_CastableAs283

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs283:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:duration:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs283.txt')

!

test_CastableAs284

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs284:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(PT10H) castable as xs:duration:)
(:*******************************************************:)

xs:duration("PT10H") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs284.txt')

!

test_CastableAs285

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs285:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs285.txt')

!

test_CastableAs286

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs286:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(PT10H) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:duration("PT10H") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs286.txt')

!

test_CastableAs287

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs287:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P24M) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:duration("P24M") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs287.txt')

!

test_CastableAs288

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs288:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs288.txt')

!

test_CastableAs289

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs289:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(PT10H) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:duration("PT10H") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs289.txt')

!

test_CastableAs290

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs290:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P24M) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:duration("P24M") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs290.txt')

!

test_CastableAs291

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs291:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:dateTime:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs291.txt')

!

test_CastableAs292

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs292:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:time:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs292.txt')

!

test_CastableAs293

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs293:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:date:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs293.txt')

!

test_CastableAs294

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs294:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs294.txt')

!

test_CastableAs295

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs295:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:gYear:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs295.txt')

!

test_CastableAs296

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs296:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs296.txt')

!

test_CastableAs297

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs297:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:gDay:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs297.txt')

!

test_CastableAs298

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs298:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:gMonth:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs298.txt')

!

test_CastableAs299

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs299:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:boolean:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs299.txt')

!

test_CastableAs300

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs300:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:base64Binary:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs300.txt')

!

test_CastableAs301

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs301:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:hexBinary:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs301.txt')

!

test_CastableAs302

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs302:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:duration(P1Y2M3DT10H30M23S) castable as xs:anyURI:)
(:*******************************************************:)

xs:duration("P1Y2M3DT10H30M23S") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs302.txt')

!

test_CastableAs303

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs303:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs303.txt')

!

test_CastableAs304

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs304:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:string:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs304.txt')

!

test_CastableAs305

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs305:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:float:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs305.txt')

!

test_CastableAs306

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs306:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:double:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs306.txt')

!

test_CastableAs307

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs307:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:decimal:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs307.txt')

!

test_CastableAs308

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs308:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:integer:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs308.txt')

!

test_CastableAs309

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs309:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:duration:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs309.txt')

!

test_CastableAs310

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs310:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs310.txt')

!

test_CastableAs311

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs311:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(-P21M) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:yearMonthDuration("-P21M") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs311.txt')

!

test_CastableAs312

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs312:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs312.txt')

!

test_CastableAs313

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs313:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:dateTime:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs313.txt')

!

test_CastableAs314

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs314:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:time:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs314.txt')

!

test_CastableAs315

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs315:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:date:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs315.txt')

!

test_CastableAs316

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs316:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs316.txt')

!

test_CastableAs317

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs317:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:gYear:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs317.txt')

!

test_CastableAs318

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs318:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs318.txt')

!

test_CastableAs319

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs319:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:gDay:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs319.txt')

!

test_CastableAs320

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs320:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:gMonth:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs320.txt')

!

test_CastableAs321

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs321:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:boolean:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs321.txt')

!

test_CastableAs322

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs322:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:base64Binary:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs322.txt')

!

test_CastableAs323

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs323:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:hexBinary:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs323.txt')

!

test_CastableAs324

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs324:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:yearMonthDuration(P1Y2M) castable as xs:anyURI:)
(:*******************************************************:)

xs:yearMonthDuration("P1Y2M") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs324.txt')

!

test_CastableAs325

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs325:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs325.txt')

!

test_CastableAs326

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs326:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(-PT100M) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:dayTimeDuration("-PT100M") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs326.txt')

!

test_CastableAs327

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs327:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:string:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs327.txt')

!

test_CastableAs328

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs328:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(-PT100M) castable as xs:string:)
(:*******************************************************:)

xs:dayTimeDuration("-PT100M") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs328.txt')

!

test_CastableAs329

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs329:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:float:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs329.txt')

!

test_CastableAs330

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs330:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:double:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs330.txt')

!

test_CastableAs331

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs331:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:decimal:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs331.txt')

!

test_CastableAs332

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs332:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:integer:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs332.txt')

!

test_CastableAs333

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs333:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:duration:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs333.txt')

!

test_CastableAs334

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs334:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(PT24H) castable as xs:duration:)
(:*******************************************************:)

xs:dayTimeDuration("PT24H") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs334.txt')

!

test_CastableAs335

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs335:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(-PT100M) castable as xs:duration:)
(:*******************************************************:)

xs:dayTimeDuration("-PT100M") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs335.txt')

!

test_CastableAs336

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs336:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs336.txt')

!

test_CastableAs337

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs337:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs337.txt')

!

test_CastableAs338

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs338:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P14D) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:dayTimeDuration("P14D") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs338.txt')

!

test_CastableAs339

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs339:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(-PT100M) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:dayTimeDuration("-PT100M") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs339.txt')

!

test_CastableAs340

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs340:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:dateTime:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs340.txt')

!

test_CastableAs341

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs341:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:time:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs341.txt')

!

test_CastableAs342

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs342:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:date:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs342.txt')

!

test_CastableAs343

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs343:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs343.txt')

!

test_CastableAs344

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs344:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:gYear:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs344.txt')

!

test_CastableAs345

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs345:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs345.txt')

!

test_CastableAs346

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs346:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:gDay:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs346.txt')

!

test_CastableAs347

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs347:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:gMonth:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs347.txt')

!

test_CastableAs348

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs348:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:boolean:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs348.txt')

!

test_CastableAs349

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs349:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:base64Binary:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs349.txt')

!

test_CastableAs350

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs350:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:hexBinary:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs350.txt')

!

test_CastableAs351

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs351:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dayTimeDuration(P3DT10H30M) castable as xs:anyURI:)
(:*******************************************************:)

xs:dayTimeDuration("P3DT10H30M") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs351.txt')

!

test_CastableAs352

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs352:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs352.txt')

!

test_CastableAs353

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs353:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dateTime(-1999-05-31T13:20:00+14:00) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs353.txt')

!

test_CastableAs354

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs354:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:string:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs354.txt')

!

test_CastableAs355

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs355:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:21-07:00:)
(:Purpose:Try xs:dateTime(-1999-05-31T13:20:00+14:00) castable as xs:string:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs355.txt')

!

test_CastableAs356

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs356:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:float:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs356.txt')

!

test_CastableAs357

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs357:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(2000-01-16T00:00:00Z) castable as xs:float:)
(:*******************************************************:)

xs:dateTime("2000-01-16T00:00:00Z") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs357.txt')

!

test_CastableAs358

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs358:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:decimal:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs358.txt')

!

test_CastableAs359

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs359:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:integer:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs359.txt')

!

test_CastableAs360

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs360:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:duration:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs360.txt')

!

test_CastableAs361

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs361:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs361.txt')

!

test_CastableAs362

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs362:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs362.txt')

!

test_CastableAs363

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs363:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:dateTime:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs363.txt')

!

test_CastableAs364

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs364:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:time:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs364.txt')

!

test_CastableAs365

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs365:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(-1999-05-31T13:20:00+14:00) castable as xs:time:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs365.txt')

!

test_CastableAs366

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs366:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:date:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs366.txt')

!

test_CastableAs367

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs367:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(-1999-05-31T13:20:00+14:00) castable as xs:date:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs367.txt')

!

test_CastableAs368

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs368:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs368.txt')

!

test_CastableAs369

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs369:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(-1999-05-31T13:20:00+14:00) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs369.txt')

!

test_CastableAs370

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs370:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:gYear:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs370.txt')

!

test_CastableAs371

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs371:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(-1999-05-31T13:20:00+14:00) castable as xs:gYear:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs371.txt')

!

test_CastableAs372

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs372:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs372.txt')

!

test_CastableAs373

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs373:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(-1999-05-31T13:20:00+14:00) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs373.txt')

!

test_CastableAs374

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs374:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:gDay:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs374.txt')

!

test_CastableAs375

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs375:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(-1999-05-31T13:20:00+14:00) castable as xs:gDay:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs375.txt')

!

test_CastableAs376

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs376:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:gMonth:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs376.txt')

!

test_CastableAs377

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs377:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(-1999-05-31T13:20:00+14:00) castable as xs:gMonth:)
(:*******************************************************:)

xs:dateTime("-1999-05-31T13:20:00+14:00") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs377.txt')

!

test_CastableAs378

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs378:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:boolean:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs378.txt')

!

test_CastableAs379

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs379:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:base64Binary:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs379.txt')

!

test_CastableAs380

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs380:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:hexBinary:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs380.txt')

!

test_CastableAs381

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs381:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:dateTime(1999-05-31T13:20:00) castable as xs:anyURI:)
(:*******************************************************:)

xs:dateTime("1999-05-31T13:20:00") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs381.txt')

!

test_CastableAs382

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs382:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs382.txt')

!

test_CastableAs383

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs383:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:string:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs383.txt')

!

test_CastableAs384

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs384:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:float:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs384.txt')

!

test_CastableAs385

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs385:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:double:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs385.txt')

!

test_CastableAs386

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs386:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:decimal:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs386.txt')

!

test_CastableAs387

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs387:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:integer:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs387.txt')

!

test_CastableAs388

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs388:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:duration:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs388.txt')

!

test_CastableAs389

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs389:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs389.txt')

!

test_CastableAs390

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs390:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs390.txt')

!

test_CastableAs391

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs391:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:dateTime:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs391.txt')

!

test_CastableAs392

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs392:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:time:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs392.txt')

!

test_CastableAs393

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs393:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:02.123) castable as xs:time:)
(:*******************************************************:)

xs:time("13:20:02.123") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs393.txt')

!

test_CastableAs394

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs394:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00Z) castable as xs:time:)
(:*******************************************************:)

xs:time("13:20:00Z") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs394.txt')

!

test_CastableAs395

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs395:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:date:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs395.txt')

!

test_CastableAs396

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs396:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs396.txt')

!

test_CastableAs397

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs397:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:gYear:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs397.txt')

!

test_CastableAs398

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs398:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs398.txt')

!

test_CastableAs399

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs399:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:gDay:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs399.txt')

!

test_CastableAs400

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs400:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:gMonth:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs400.txt')

!

test_CastableAs401

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs401:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:boolean:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs401.txt')

!

test_CastableAs402

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs402:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:base64Binary:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs402.txt')

!

test_CastableAs403

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs403:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:hexBinary:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs403.txt')

!

test_CastableAs404

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs404:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:time(13:20:00-05:00) castable as xs:anyURI:)
(:*******************************************************:)

xs:time("13:20:00-05:00") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs404.txt')

!

test_CastableAs405

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs405:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs405.txt')

!

test_CastableAs406

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs406:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(-0012-12-03-05:00) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:date("-0012-12-03-05:00") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs406.txt')

!

test_CastableAs407

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs407:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:string:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs407.txt')

!

test_CastableAs408

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs408:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(-0012-12-03-05:00) castable as xs:string:)
(:*******************************************************:)

xs:date("-0012-12-03-05:00") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs408.txt')

!

test_CastableAs409

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs409:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:float:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs409.txt')

!

test_CastableAs410

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs410:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:double:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs410.txt')

!

test_CastableAs411

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs411:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31Z) castable as xs:double:)
(:*******************************************************:)

xs:date("1999-05-31Z") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs411.txt')

!

test_CastableAs412

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs412:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:integer:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs412.txt')

!

test_CastableAs413

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs413:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:duration:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs413.txt')

!

test_CastableAs414

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs414:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs414.txt')

!

test_CastableAs415

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs415:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs415.txt')

!

test_CastableAs416

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs416:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:dateTime:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs416.txt')

!

test_CastableAs417

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs417:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:time:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs417.txt')

!

test_CastableAs418

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs418:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:date:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs418.txt')

!

test_CastableAs419

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs419:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(-0012-12-03-05:00) castable as xs:date:)
(:*******************************************************:)

xs:date("-0012-12-03-05:00") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs419.txt')

!

test_CastableAs420

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs420:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31Z) castable as xs:date:)
(:*******************************************************:)

xs:date("1999-05-31Z") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs420.txt')

!

test_CastableAs421

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs421:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs421.txt')

!

test_CastableAs422

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs422:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:gYear:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs422.txt')

!

test_CastableAs423

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs423:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(-0012-12-03-05:00) castable as xs:gYear:)
(:*******************************************************:)

xs:date("-0012-12-03-05:00") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs423.txt')

!

test_CastableAs424

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs424:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31Z) castable as xs:gYear:)
(:*******************************************************:)

xs:date("1999-05-31Z") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs424.txt')

!

test_CastableAs425

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs425:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs425.txt')

!

test_CastableAs426

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs426:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(-0012-12-03-05:00) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:date("-0012-12-03-05:00") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs426.txt')

!

test_CastableAs427

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs427:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31Z) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:date("1999-05-31Z") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs427.txt')

!

test_CastableAs428

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs428:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31Z) castable as xs:gDay:)
(:*******************************************************:)

xs:date("1999-05-31Z") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs428.txt')

!

test_CastableAs429

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs429:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(-0012-12-03-05:00) castable as xs:gMonth:)
(:*******************************************************:)

xs:date("-0012-12-03-05:00") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs429.txt')

!

test_CastableAs430

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs430:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31Z) castable as xs:gMonth:)
(:*******************************************************:)

xs:date("1999-05-31Z") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs430.txt')

!

test_CastableAs431

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs431:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:22-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:boolean:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs431.txt')

!

test_CastableAs432

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs432:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:base64Binary:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs432.txt')

!

test_CastableAs433

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs433:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:hexBinary:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs433.txt')

!

test_CastableAs434

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs434:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:date(1999-05-31) castable as xs:anyURI:)
(:*******************************************************:)

xs:date("1999-05-31") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs434.txt')

!

test_CastableAs435

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs435:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:gYearMonth("1999-05") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs435.txt')

!

test_CastableAs436

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs436:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05) castable as xs:string:)
(:*******************************************************:)

xs:gYearMonth("1999-05") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs436.txt')

!

test_CastableAs437

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs437:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05) castable as xs:float:)
(:*******************************************************:)

xs:gYearMonth("1999-05") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs437.txt')

!

test_CastableAs438

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs438:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05) castable as xs:double:)
(:*******************************************************:)

xs:gYearMonth("1999-05") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs438.txt')

!

test_CastableAs439

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs439:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:double:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs439.txt')

!

test_CastableAs440

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs440:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:decimal:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs440.txt')

!

test_CastableAs441

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs441:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:integer:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs441.txt')

!

test_CastableAs442

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs442:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:duration:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs442.txt')

!

test_CastableAs443

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs443:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs443.txt')

!

test_CastableAs444

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs444:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs444.txt')

!

test_CastableAs445

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs445:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:dateTime:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs445.txt')

!

test_CastableAs446

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs446:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:time:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs446.txt')

!

test_CastableAs447

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs447:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:date:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs447.txt')

!

test_CastableAs448

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs448:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:gYearMonth("1999-05") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs448.txt')

!

test_CastableAs449

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs449:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(-0012-12-05:00) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:gYearMonth("-0012-12-05:00") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs449.txt')

!

test_CastableAs450

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs450:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs450.txt')

!

test_CastableAs451

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs451:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:gYear:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs451.txt')

!

test_CastableAs452

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs452:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs452.txt')

!

test_CastableAs453

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs453:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:gDay:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs453.txt')

!

test_CastableAs454

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs454:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:gMonth:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs454.txt')

!

test_CastableAs455

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs455:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:boolean:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs455.txt')

!

test_CastableAs456

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs456:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:base64Binary:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs456.txt')

!

test_CastableAs457

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs457:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:hexBinary:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs457.txt')

!

test_CastableAs458

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs458:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYearMonth(1999-05Z) castable as xs:anyURI:)
(:*******************************************************:)

xs:gYearMonth("1999-05Z") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs458.txt')

!

test_CastableAs459

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs459:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs459.txt')

!

test_CastableAs460

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs460:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:string:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs460.txt')

!

test_CastableAs461

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs461:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:float:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs461.txt')

!

test_CastableAs462

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs462:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:double:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs462.txt')

!

test_CastableAs463

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs463:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:decimal:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs463.txt')

!

test_CastableAs464

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs464:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:integer:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs464.txt')

!

test_CastableAs465

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs465:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:duration:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs465.txt')

!

test_CastableAs466

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs466:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs466.txt')

!

test_CastableAs467

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs467:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:dateTime:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs467.txt')

!

test_CastableAs468

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs468:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:time:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs468.txt')

!

test_CastableAs469

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs469:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:date:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs469.txt')

!

test_CastableAs470

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs470:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs470.txt')

!

test_CastableAs471

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs471:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:gYear:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs471.txt')

!

test_CastableAs472

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs472:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(-0012-05:00) castable as xs:gYear:)
(:*******************************************************:)

xs:gYear("-0012-05:00") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs472.txt')

!

test_CastableAs473

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs473:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999Z) castable as xs:gYear:)
(:*******************************************************:)

xs:gYear("1999Z") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs473.txt')

!

test_CastableAs474

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs474:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs474.txt')

!

test_CastableAs475

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs475:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:gDay:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs475.txt')

!

test_CastableAs476

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs476:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:gMonth:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs476.txt')

!

test_CastableAs477

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs477:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:boolean:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs477.txt')

!

test_CastableAs478

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs478:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:base64Binary:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs478.txt')

!

test_CastableAs479

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs479:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:hexBinary:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs479.txt')

!

test_CastableAs480

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs480:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gYear(1999) castable as xs:anyURI:)
(:*******************************************************:)

xs:gYear("1999") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs480.txt')

!

test_CastableAs481

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs481:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs481.txt')

!

test_CastableAs482

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs482:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:string:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs482.txt')

!

test_CastableAs483

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs483:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:float:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs483.txt')

!

test_CastableAs484

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs484:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:double:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs484.txt')

!

test_CastableAs485

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs485:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:decimal:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs485.txt')

!

test_CastableAs486

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs486:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:integer:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs486.txt')

!

test_CastableAs487

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs487:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:duration:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs487.txt')

!

test_CastableAs488

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs488:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs488.txt')

!

test_CastableAs489

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs489:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs489.txt')

!

test_CastableAs490

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs490:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:dateTime:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs490.txt')

!

test_CastableAs491

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs491:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:time:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs491.txt')

!

test_CastableAs492

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs492:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:date:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs492.txt')

!

test_CastableAs493

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs493:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs493.txt')

!

test_CastableAs494

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs494:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:gYear:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs494.txt')

!

test_CastableAs495

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs495:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs495.txt')

!

test_CastableAs496

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs496:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--12-03-05:00) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:gMonthDay("--12-03-05:00") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs496.txt')

!

test_CastableAs497

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs497:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31Z) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:gMonthDay("--05-31Z") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs497.txt')

!

test_CastableAs498

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs498:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:gDay:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs498.txt')

!

test_CastableAs499

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs499:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:gMonth:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs499.txt')

!

test_CastableAs500

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs500:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:boolean:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs500.txt')

!

test_CastableAs501

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs501:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:base64Binary:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs501.txt')

!

test_CastableAs502

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs502:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:hexBinary:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs502.txt')

!

test_CastableAs503

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs503:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonthDay(--05-31) castable as xs:anyURI:)
(:*******************************************************:)

xs:gMonthDay("--05-31") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs503.txt')

!

test_CastableAs504

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs504:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs504.txt')

!

test_CastableAs505

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs505:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:string:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs505.txt')

!

test_CastableAs506

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs506:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:float:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs506.txt')

!

test_CastableAs507

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs507:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:double:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs507.txt')

!

test_CastableAs508

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs508:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:decimal:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs508.txt')

!

test_CastableAs509

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs509:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:integer:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs509.txt')

!

test_CastableAs510

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs510:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:duration:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs510.txt')

!

test_CastableAs511

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs511:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs511.txt')

!

test_CastableAs512

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs512:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs512.txt')

!

test_CastableAs513

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs513:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:dateTime:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs513.txt')

!

test_CastableAs514

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs514:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:time:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs514.txt')

!

test_CastableAs515

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs515:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:date:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs515.txt')

!

test_CastableAs516

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs516:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs516.txt')

!

test_CastableAs517

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs517:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:gYear:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs517.txt')

!

test_CastableAs518

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs518:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs518.txt')

!

test_CastableAs519

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs519:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:gDay:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs519.txt')

!

test_CastableAs520

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs520:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---03-05:00) castable as xs:gDay:)
(:*******************************************************:)

xs:gDay("---03-05:00") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs520.txt')

!

test_CastableAs521

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs521:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31Z) castable as xs:gDay:)
(:*******************************************************:)

xs:gDay("---31Z") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs521.txt')

!

test_CastableAs522

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs522:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:gMonth:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs522.txt')

!

test_CastableAs523

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs523:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:boolean:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs523.txt')

!

test_CastableAs524

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs524:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:base64Binary:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs524.txt')

!

test_CastableAs525

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs525:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:hexBinary:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs525.txt')

!

test_CastableAs526

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs526:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gDay(---31) castable as xs:anyURI:)
(:*******************************************************:)

xs:gDay("---31") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs526.txt')

!

test_CastableAs527

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs527:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs527.txt')

!

test_CastableAs528

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs528:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:string:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs528.txt')

!

test_CastableAs529

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs529:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:float:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs529.txt')

!

test_CastableAs530

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs530:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:double:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs530.txt')

!

test_CastableAs531

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs531:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:decimal:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs531.txt')

!

test_CastableAs532

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs532:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:integer:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs532.txt')

!

test_CastableAs533

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs533:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:duration:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs533.txt')

!

test_CastableAs534

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs534:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs534.txt')

!

test_CastableAs535

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs535:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs535.txt')

!

test_CastableAs536

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs536:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:dateTime:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs536.txt')

!

test_CastableAs537

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs537:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:time:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs537.txt')

!

test_CastableAs538

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs538:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:date:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs538.txt')

!

test_CastableAs539

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs539:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs539.txt')

!

test_CastableAs540

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs540:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:gYear:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs540.txt')

!

test_CastableAs541

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs541:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs541.txt')

!

test_CastableAs542

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs542:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:gDay:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs542.txt')

!

test_CastableAs543

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs543:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:gMonth:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs543.txt')

!

test_CastableAs544

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs544:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--12-05:00) castable as xs:gMonth:)
(:*******************************************************:)

xs:gMonth("--12-05:00") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs544.txt')

!

test_CastableAs545

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs545:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05Z) castable as xs:gMonth:)
(:*******************************************************:)

xs:gMonth("--05Z") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs545.txt')

!

test_CastableAs546

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs546:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:boolean:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs546.txt')

!

test_CastableAs547

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs547:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:base64Binary:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs547.txt')

!

test_CastableAs548

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs548:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:hexBinary:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs548.txt')

!

test_CastableAs549

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs549:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:gMonth(--05) castable as xs:anyURI:)
(:*******************************************************:)

xs:gMonth("--05") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs549.txt')

!

test_CastableAs550

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs550:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:boolean("true") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs550.txt')

!

test_CastableAs551

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs551:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:string:)
(:*******************************************************:)

xs:boolean("true") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs551.txt')

!

test_CastableAs552

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs552:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:float:)
(:*******************************************************:)

xs:boolean("true") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs552.txt')

!

test_CastableAs553

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs553:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:boolean(false) castable as xs:float:)
(:*******************************************************:)

xs:boolean("false") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs553.txt')

!

test_CastableAs554

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs554:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:double:)
(:*******************************************************:)

xs:boolean("true") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs554.txt')

!

test_CastableAs555

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs555:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:boolean(false) castable as xs:double:)
(:*******************************************************:)

xs:boolean("false") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs555.txt')

!

test_CastableAs556

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs556:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:decimal:)
(:*******************************************************:)

xs:boolean("true") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs556.txt')

!

test_CastableAs557

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs557:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:boolean(false) castable as xs:decimal:)
(:*******************************************************:)

xs:boolean("false") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs557.txt')

!

test_CastableAs558

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs558:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:integer:)
(:*******************************************************:)

xs:boolean("true") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs558.txt')

!

test_CastableAs559

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs559:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:23-07:00:)
(:Purpose:Try xs:boolean(false) castable as xs:integer:)
(:*******************************************************:)

xs:boolean("false") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs559.txt')

!

test_CastableAs560

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs560:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:duration:)
(:*******************************************************:)

xs:boolean("true") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs560.txt')

!

test_CastableAs561

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs561:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:boolean("true") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs561.txt')

!

test_CastableAs562

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs562:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:boolean("true") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs562.txt')

!

test_CastableAs563

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs563:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:dateTime:)
(:*******************************************************:)

xs:boolean("true") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs563.txt')

!

test_CastableAs564

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs564:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:time:)
(:*******************************************************:)

xs:boolean("true") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs564.txt')

!

test_CastableAs565

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs565:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:date:)
(:*******************************************************:)

xs:boolean("true") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs565.txt')

!

test_CastableAs566

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs566:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:boolean("true") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs566.txt')

!

test_CastableAs567

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs567:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:gYear:)
(:*******************************************************:)

xs:boolean("true") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs567.txt')

!

test_CastableAs568

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs568:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:boolean("true") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs568.txt')

!

test_CastableAs569

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs569:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:gDay:)
(:*******************************************************:)

xs:boolean("true") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs569.txt')

!

test_CastableAs570

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs570:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:gMonth:)
(:*******************************************************:)

xs:boolean("true") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs570.txt')

!

test_CastableAs571

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs571:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:boolean:)
(:*******************************************************:)

xs:boolean("true") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs571.txt')

!

test_CastableAs572

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs572:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(false) castable as xs:boolean:)
(:*******************************************************:)

xs:boolean("false") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs572.txt')

!

test_CastableAs573

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs573:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:base64Binary:)
(:*******************************************************:)

xs:boolean("true") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs573.txt')

!

test_CastableAs574

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs574:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:hexBinary:)
(:*******************************************************:)

xs:boolean("true") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs574.txt')

!

test_CastableAs575

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs575:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:boolean(true) castable as xs:anyURI:)
(:*******************************************************:)

xs:boolean("true") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs575.txt')

!

test_CastableAs576

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs576:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(01001010) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:base64Binary("01001010") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs576.txt')

!

test_CastableAs577

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs577:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(0FB7) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:base64Binary("0FB7") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs577.txt')

!

test_CastableAs578

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs578:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(01001010) castable as xs:string:)
(:*******************************************************:)

xs:base64Binary("01001010") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs578.txt')

!

test_CastableAs579

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs579:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(0FB7) castable as xs:string:)
(:*******************************************************:)

xs:base64Binary("0FB7") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs579.txt')

!

test_CastableAs580

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs580:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:float:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs580.txt')

!

test_CastableAs581

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs581:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:double:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs581.txt')

!

test_CastableAs582

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs582:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:decimal:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs582.txt')

!

test_CastableAs583

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs583:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:integer:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs583.txt')

!

test_CastableAs584

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs584:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:duration:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs584.txt')

!

test_CastableAs585

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs585:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs585.txt')

!

test_CastableAs586

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs586:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs586.txt')

!

test_CastableAs587

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs587:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:dateTime:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs587.txt')

!

test_CastableAs588

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs588:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:time:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs588.txt')

!

test_CastableAs589

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs589:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:date:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs589.txt')

!

test_CastableAs590

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs590:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs590.txt')

!

test_CastableAs591

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs591:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:gYear:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs591.txt')

!

test_CastableAs592

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs592:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs592.txt')

!

test_CastableAs593

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs593:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:gDay:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs593.txt')

!

test_CastableAs594

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs594:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:gMonth:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs594.txt')

!

test_CastableAs595

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs595:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:boolean:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs595.txt')

!

test_CastableAs596

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs596:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(01001010) castable as xs:base64Binary:)
(:*******************************************************:)

xs:base64Binary("01001010") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs596.txt')

!

test_CastableAs597

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs597:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(0FB7) castable as xs:base64Binary:)
(:*******************************************************:)

xs:base64Binary("0FB7") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs597.txt')

!

test_CastableAs598

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs598:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(00000000) castable as xs:hexBinary:)
(:*******************************************************:)

xs:base64Binary("00000000") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs598.txt')

!

test_CastableAs599

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs599:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:hexBinary:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs599.txt')

!

test_CastableAs600

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs600:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(aA+zZ/09) castable as xs:hexBinary:)
(:*******************************************************:)

xs:base64Binary("aA+zZ/09") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs600.txt')

!

test_CastableAs601

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs601:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(0FB7) castable as xs:hexBinary:)
(:*******************************************************:)

xs:base64Binary("0FB7") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs601.txt')

!

test_CastableAs602

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs602:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:base64Binary(10010101) castable as xs:anyURI:)
(:*******************************************************:)

xs:base64Binary("10010101") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs602.txt')

!

test_CastableAs603

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs603:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs603.txt')

!

test_CastableAs604

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs604:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:string:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs604.txt')

!

test_CastableAs605

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs605:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:float:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs605.txt')

!

test_CastableAs606

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs606:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:double:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs606.txt')

!

test_CastableAs607

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs607:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:decimal:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs607.txt')

!

test_CastableAs608

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs608:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:integer:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs608.txt')

!

test_CastableAs609

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs609:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:duration:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs609.txt')

!

test_CastableAs610

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs610:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs610.txt')

!

test_CastableAs611

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs611:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs611.txt')

!

test_CastableAs612

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs612:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:dateTime:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs612.txt')

!

test_CastableAs613

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs613:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:time:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs613.txt')

!

test_CastableAs614

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs614:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:date:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs614.txt')

!

test_CastableAs615

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs615:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs615.txt')

!

test_CastableAs616

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs616:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:gYear:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs616.txt')

!

test_CastableAs617

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs617:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs617.txt')

!

test_CastableAs618

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs618:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:gDay:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs618.txt')

!

test_CastableAs619

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs619:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:gMonth:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs619.txt')

!

test_CastableAs620

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs620:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:boolean:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs620.txt')

!

test_CastableAs621

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs621:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:base64Binary:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs621.txt')

!

test_CastableAs622

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs622:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(0fb7) castable as xs:base64Binary:)
(:*******************************************************:)

xs:hexBinary("0fb7") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs622.txt')

!

test_CastableAs623

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs623:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:hexBinary:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs623.txt')

!

test_CastableAs624

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs624:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(d74d35d35d35) castable as xs:hexBinary:)
(:*******************************************************:)

xs:hexBinary("d74d35d35d35") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs624.txt')

!

test_CastableAs625

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs625:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:hexBinary(D74D35D35D35) castable as xs:anyURI:)
(:*******************************************************:)

xs:hexBinary("D74D35D35D35") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs625.txt')

!

test_CastableAs626

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs626:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:untypedAtomic:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs626.txt')

!

test_CastableAs627

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs627:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:string:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs627.txt')

!

test_CastableAs628

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs628:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:float:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs628.txt')

!

test_CastableAs629

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs629:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:double:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:double
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs629.txt')

!

test_CastableAs630

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs630:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:decimal:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:decimal
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs630.txt')

!

test_CastableAs631

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs631:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:integer:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs631.txt')

!

test_CastableAs632

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs632:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:duration:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:duration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs632.txt')

!

test_CastableAs633

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs633:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:yearMonthDuration:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:yearMonthDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs633.txt')

!

test_CastableAs634

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs634:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:dayTimeDuration:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:dayTimeDuration
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs634.txt')

!

test_CastableAs635

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs635:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:dateTime:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:dateTime
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs635.txt')

!

test_CastableAs636

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs636:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:time:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:time
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs636.txt')

!

test_CastableAs637

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs637:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:date:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:date
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs637.txt')

!

test_CastableAs638

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs638:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:gYearMonth:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:gYearMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs638.txt')

!

test_CastableAs639

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs639:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:gYear:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:gYear
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs639.txt')

!

test_CastableAs640

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs640:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:gMonthDay:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:gMonthDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs640.txt')

!

test_CastableAs641

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs641:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:gDay:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:gDay
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs641.txt')

!

test_CastableAs642

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs642:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:gMonth:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:gMonth
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs642.txt')

!

test_CastableAs643

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs643:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:boolean:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs643.txt')

!

test_CastableAs644

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs644:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:base64Binary:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:base64Binary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs644.txt')

!

test_CastableAs645

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs645:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:hexBinary:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:hexBinary
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs645.txt')

!

test_CastableAs646

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs646:)
(:Written By:Joanne Tong:)
(:Date:2005-07-21T09:50:24-07:00:)
(:Purpose:Try xs:anyURI(http://www.ietf.org/rfc/rfc2396.txt) castable as xs:anyURI:)
(:*******************************************************:)

xs:anyURI("http://www.ietf.org/rfc/rfc2396.txt") castable as xs:anyURI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs646.txt')

!

test_CastableAs647

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs647:)
(:Written By:Carmelo Montanez:)
(:Date:2006-06-08:)
(:Purpose:Try string literal castable as xs:QName:)
(:*******************************************************:)

"ABC" castable as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs647.txt')

!

test_CastableAs648

    | query result |

    query := ' 
        (:*******************************************************:)
(:Test:CastableAs648:)
(:Written By:Carmelo Montanez:)
(:Date:2006-08-08:)
(:Purpose:Try variable castable as xs:QName:)
(:*******************************************************:)

let $var := "ABC"
return $var castable as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/exprSeqTypes/SeqExprCastable/CastableAs648.txt')

!

test_K2_SeqExprCastable_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-SeqExprCastable-1                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Testing castability to xs:QName where the cardinality is wrong. :)
(:*******************************************************:)
(QName("http://example.com/ANamespace", "ncname"),
 QName("http://example.com/ANamespace", "ncname2"),
 QName("http://example.com/ANamespace", "ncname3")) castable as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K2-SeqExprCastable-1.txt')

!

test_K2_SeqExprCastable_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-SeqExprCastable-2                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Testing castability to xs:QName where the cardinality is wrong(#2). :)
(:*******************************************************:)
(QName("http://example.com/ANamespace", "ncname"),
 QName("http://example.com/ANamespace", "ncname2"),
 QName("http://example.com/ANamespace", "ncname3")) castable as xs:QName?
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K2-SeqExprCastable-2.txt')

!

test_K_SeqExprCastable_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-1                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "+" nor "?" is allowed as a cardinality specifier in "castable as". :)
(:*******************************************************:)
"string" castable as xs:string*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-10                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified. :)
(:*******************************************************:)
"notation is abstract" castable as xs:NOTATION
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-11                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified. :)
(:*******************************************************:)
() castable as xs:NOTATION
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-12                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified. :)
(:*******************************************************:)
(xs:double(1), xs:double(2), xs:double(3))
		castable as xs:double*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-13                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified, leading to a syntax error. :)
(:*******************************************************:)
"string" castable as item()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-14                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified, leading to a syntax error. :)
(:*******************************************************:)
"string" castable as node()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-15                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified, leading to a syntax error. :)
(:*******************************************************:)
"string" castable as attribute()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-16                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified, leading to a syntax error. :)
(:*******************************************************:)
"string" castable as empty-sequence()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-17                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not(QName("", "lname") castable as xs:integer)`. :)
(:*******************************************************:)
not(QName("", "lname") castable as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-17.txt')

!

test_K_SeqExprCastable_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-18                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: When casting to xs:QName the source value can be a xs:QName value. :)
(:*******************************************************:)
QName("", "lname") castable as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-18.txt')

!

test_K_SeqExprCastable_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-19                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting an xs:string to xs:QName works.      :)
(:*******************************************************:)
"ncname" castable as xs:QName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-19.txt')

!

test_K_SeqExprCastable_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-2                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "+" nor "?" is allowed as a cardinality specifier in "castable as". :)
(:*******************************************************:)
"string" castable as xs:string+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-20                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting an empty sequence to xs:QName does not work. :)
(:*******************************************************:)
not(() castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-20.txt')

!

test_K_SeqExprCastable_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-21                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting an empty sequence to xs:QName? works. :)
(:*******************************************************:)
() castable as xs:QName?
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-21.txt')

!

test_K_SeqExprCastable_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-22                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: Casting an xs:untypedAtomic to xs:QName does not work. :)
(:*******************************************************:)
not(xs:untypedAtomic("ncname") castable as xs:QName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-22.txt')

!

test_K_SeqExprCastable_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-23                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not(("one", "two") castable as xs:string?)`. :)
(:*******************************************************:)
not(("one", "two") castable as xs:string?)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-23.txt')

!

test_K_SeqExprCastable_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-24                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not("string" castable as xs:boolean)`. :)
(:*******************************************************:)
not("string" castable as xs:boolean)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-24.txt')

!

test_K_SeqExprCastable_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-25                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `"true" castable as xs:boolean`. :)
(:*******************************************************:)
"true" castable as xs:boolean
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-25.txt')

!

test_K_SeqExprCastable_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-26                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(1) castable as xs:float`. :)
(:*******************************************************:)
xs:float(1) castable as xs:float
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-26.txt')

!

test_K_SeqExprCastable_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-27                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(1) castable as xs:untypedAtomic`. :)
(:*******************************************************:)
xs:float(1) castable as xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-27.txt')

!

test_K_SeqExprCastable_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-28                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `xs:float(1) castable as xs:string`. :)
(:*******************************************************:)
xs:float(1) castable as xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-28.txt')

!

test_K_SeqExprCastable_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-29                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not(xs:anyURI("example.com/") castable as xs:integer)`. :)
(:*******************************************************:)
not(xs:anyURI("example.com/") castable as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-29.txt')

!

test_K_SeqExprCastable_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-3                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "+" nor "?" is allowed as a cardinality specifier in "castable as". :)
(:*******************************************************:)
("one", "two") castable as xs:string+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-30                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not("three" castable as xs:float)`. :)
(:*******************************************************:)
not("three" castable as xs:float)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-30.txt')

!

test_K_SeqExprCastable_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-31                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not("three" castable as xs:integer)`. :)
(:*******************************************************:)
not("three" castable as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-31.txt')

!

test_K_SeqExprCastable_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-32                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not("three" castable as xs:decimal)`. :)
(:*******************************************************:)
not("three" castable as xs:decimal)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-32.txt')

!

test_K_SeqExprCastable_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-33                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not("three" castable as xs:double)`. :)
(:*******************************************************:)
not("three" castable as xs:double)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-33.txt')

!

test_K_SeqExprCastable_34

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-34                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not((1, 2, 3) castable as xs:integer)`. :)
(:*******************************************************:)
not((1, 2, 3) castable as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-34.txt')

!

test_K_SeqExprCastable_35

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-35                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not(() castable as xs:integer)`. :)
(:*******************************************************:)
not(() castable as xs:integer)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-35.txt')

!

test_K_SeqExprCastable_36

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-36                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `() castable as xs:integer?`. :)
(:*******************************************************:)
() castable as xs:integer?
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-36.txt')

!

test_K_SeqExprCastable_37

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-37                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `(1) castable as xs:integer?`. :)
(:*******************************************************:)
(1) castable as xs:integer?
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-37.txt')

!

test_K_SeqExprCastable_38

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-38                            :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: A test whose essence is: `not(("one", "two") castable as xs:string?)`. :)
(:*******************************************************:)
not(("one", "two") castable as xs:string?)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/seqExprTypes/SeqExprCastable/K-SeqExprCastable-38.txt')

!

test_K_SeqExprCastable_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-4                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: "+" nor "?" is allowed as a cardinality specifier in "castable as". :)
(:*******************************************************:)
"string" castable as xs:anyType*
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-5                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified. :)
(:*******************************************************:)
"string" castable as xs:anySimpleType
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-6                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified. :)
(:*******************************************************:)
"string" castable as xs:untyped
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-7                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified. :)
(:*******************************************************:)
"string" castable as xs:anyAtomicType
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-8                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified. :)
(:*******************************************************:)
"notation is abstract" castable as xs:NOTATION?
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_SeqExprCastable_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-SeqExprCastable-9                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:39+02:00                       :)
(: Purpose: An invalid type for "castable as" is specified. :)
(:*******************************************************:)
() castable as xs:NOTATION?
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
! !

!XQTSSeqExprCastableTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
