"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSForExprWithTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSForExprWithTests methodsFor:'tests'!

test_ForExprType001

    | query result |

    query := ' 
        (: Name: ForExprType001 :)
(: Description: FLWOR expressions with type declaration (element type) :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file as element(File,xs:untyped) in ($input-context//Folder)[1]/File
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType001.xml')

!

test_ForExprType002

    | query result |

    query := ' 
        (: Name: ForExprType002 :)
(: Description: FLWOR expressions with type declaration (attribute type) :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $fileName as attribute(name,xs:untypedAtomic) in ($input-context//Folder)[1]/File/@name
return data($fileName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType002.txt')

!

test_ForExprType003

    | query result |

    query := ' 
        (: Name: ForExprType003 :)
(: Description: FLWOR expressions with type declaration (PI type) :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $PI as processing-instruction() in $input-context//processing-instruction()
return $PI
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType003.xml')

!

test_ForExprType004

    | query result |

    query := ' 
        (: Name: ForExprType004 :)
(: Description: FLWOR expressions with type declaration (comment type) :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $comment as comment() in $input-context//comment()
return $comment
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType004.xml')

!

test_ForExprType005

    | query result |

    query := ' 
        (: Name: ForExprType005 :)
(: Description: FLWOR expressions with type declaration (simple type) :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $int as xs:int in (xs:int(1), xs:int(2))
return $int
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType005.txt')

!

test_ForExprType006

    | query result |

    query := ' 
        (: Name: ForExprType006 :)
(: Description: Wrong type in type declaration :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $int as xs:string in (xs:int(1), xs:int(2))
return $int
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType007

    | query result |

    query := ' 
        (: Name: ForExprType007 :)
(: Description: Wrong order for type declaration :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File as element(Folder,xs:untypedAny)
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType008

    | query result |

    query := ' 
        (: Name: ForExprType008 :)
(: Description: Wrong order for positional and typing parts of FLWOR expression :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file at $pos as element(Folder,xs:untyped) in ($input-context//Folder)[1]/File
return (string($file/FileName[1]), $pos)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType009

    | query result |

    query := ' 
        (: Name: ForExprType009 :)
(: Description: FLWOR with type expression matching a user defined type :)

declare namespace xqt="http://www.w3.org/XQueryTestOrderBy";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $num as element(xqt:NegativeNumbers) in $input-context/xqt:DataValues/xqt:NegativeNumbers
return $num
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'orderData'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType009.xml')

!

test_ForExprType011

    | query result |

    query := ' 
        (: Name: ForExprType011 :)
(: Description: FLWOR with type expression referencing an unknown type :)

declare namespace xqt="http://www.w3.org/XQueryTestOrderBy";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $num as xs:undefinedType in data( $input-context/xqt:DataValues/xqt:NegativeNumbers/xqt:orderData )
return $num
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'orderData'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType012

    | query result |

    query := ' 
        (: Name: ForExprType012 :)
(: Description: Missing type declaration on type expression :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file as in (//Folder)[1]/File
return $file
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType013

    | query result |

    query := ' 
        (: Name: ForExprType013 :)
(: Description: Type declaration containing multiple "as" keywords :)

declare namespace xqt="http://www.w3.org/XQueryTestOrderBy";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $num as xs:decimal as xs:decimal in data( $input-context/xqt:DataValues/xqt:NegativeNumbers/xqt:orderData )
return $num

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'orderData'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType014

    | query result |

    query := ' 
        (: Name: ForExprType014 :)
(: Description: Type expression value is void. This will never match anything bound to a variable by a FLWOR statement :)

declare namespace xqt="http://www.w3.org/XQueryTestOrderBy";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $num as empty-sequence() in data( $input-context/xqt:DataValues/xqt:NegativeNumbers/xqt:orderData )
return $num

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'orderData'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType015

    | query result |

    query := ' 
        (: Name: ForExprType015 :)
(: Description: Type declaration is a super type :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $num as xs:decimal in (xs:integer(1), xs:integer(2), xs:integer(3))
return $num

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType015.txt')

!

test_ForExprType016

    | query result |

    query := ' 
        (: Name: ForExprType016 :)
(: Description: Type declaration is a super type of the union type bound to the variable :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $num as xs:decimal in (xs:integer(1), xs:decimal(2), xs:integer(3))
return $num

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType016.txt')

!

test_ForExprType017

    | query result |

    query := ' 
        (: Name: ForExprType017 :)
(: Description: Bound sequence is a union type containing a single instance that does not match the type declaration :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $num as xs:double in (xs:int("1"), xs:integer("2"), xs:string("3"))
return $num

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType018

    | query result |

    query := ' 
        (: Name: ForExprType018 :)
(: Description: Match a "node" type :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file as node() in ($input-context//Folder)[1]/File
return $file/FileName

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType018.xml')

!

test_ForExprType019

    | query result |

    query := ' 
        (: Name: ForExprType019 :)
(: Description: Match a text node type :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $fileName as text() in ($input-context//Folder)[1]/File/FileName/text()
return string( $fileName )

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType019.txt')

!

test_ForExprType020

    | query result |

    query := ' 
        (: Name: ForExprType020 :)
(: Description: Match a "item" type :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $fileName as item() in data( ($input-context//Folder)[1]/File/FileName )
return $fileName


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType020.txt')

!

test_ForExprType021

    | query result |

    query := ' 
        (: Name: ForExprType021 :)
(: Description: Match a "document" type :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $doc as document-node() in $input-context
return count( $doc )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType021.txt')

!

test_ForExprType022

    | query result |

    query := ' 
        (: Name: ForExprType022 :)
(: Description: FLWOR expressions with type declaration (attribute type). Simple attribute wildcard :)

(: insert-start :)
declare default element namespace "http://typedecl";

declare variable $input-context external;
(: insert-end :)

for $test as attribute(*) in ( $input-context/root/InterleaveType2/@integer, $input-context/root/InterleaveType2/@decimal )
return data( $test )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'SpecialTypes'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType022.txt')

!

test_ForExprType023

    | query result |

    query := ' 
        (: Name: ForExprType023 :)
(: Description: FLWOR expressions with type declaration (attribute type). Simple attribute name test (no type) :)

(: insert-start :)
declare default element namespace "http://typedecl";

declare variable $input-context external;
(: insert-end :)

for $test as attribute(integer) in ( $input-context/root/InterleaveType2/@integer )
return data( $test )

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'SpecialTypes'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType023.txt')

!

test_ForExprType024

    | query result |

    query := ' 
        (: Name: ForExprType024 :)
(: Description: FLWOR expressions with type declaration (attribute type). anySimpleType attribute :)

(: insert-start :)
declare default element namespace "http://typedecl";

declare variable $input-context external;
(: insert-end :)

for $test as attribute(att, xs:anySimpleType) in $input-context/root/anyAtomicType/@att
return data( $test )

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'SpecialTypes'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType024.txt')

!

test_ForExprType028

    | query result |

    query := ' 
        (: Name: ForExprType028 :)
(: Description: FLWOR expressions with type declaration. Value subtype promotion: Numeric based types -> integer :)

for $test as xs:integer in ( xs:byte("1"), xs:long("10000"), xs:negativeInteger("-10"), xs:short("100"), xs:positiveInteger("100"), xs:nonNegativeInteger("100") )
return $test

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType028.txt')

!

test_ForExprType029

    | query result |

    query := ' 
        (: Name: ForExprType029 :)
(: Description: FLWOR expressions with type declaration. Value subtype promotion: Numeric based types -> decimal :)

for $test as xs:decimal in ( xs:integer("100"), xs:short("1"), xs:int("10000"), xs:nonPositiveInteger("-10"), xs:unsignedShort("100"), xs:positiveInteger("100"), xs:nonNegativeInteger("100") )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType029.txt')

!

test_ForExprType030

    | query result |

    query := ' 
        (: Name: ForExprType030 :)
(: Description: FLWOR expressions with type declaration. Value subtype promotion: String based types -> normalizedString :)

for $test as xs:normalizedString in ( xs:language("en-US"), xs:NCName("foobar"), xs:NMTOKEN("token1"), xs:ENTITY("entity1") )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType030.txt')

!

test_ForExprType031

    | query result |

    query := ' 
        (: Name: ForExprType031 :)
(: Description: FLWOR expressions with type declaration. Value subtype promotion: Time based types -> anyAtomicType :)

for $test as xs:anyAtomicType in ( xs:duration("P0Y1347M0D"), xs:dateTime("1999-05-31T13:20:00-05:00"), xs:time("13:00:00-05:00"), xs:date("1999-05-10Z"), xs:gYearMonth("2002-03"), xs:gYear("1999"), xs:gMonthDay("--05-10"), xs:gDay("---10"), xs:gMonth("--05") )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType031.txt')

!

test_ForExprType032

    | query result |

    query := ' 
        (: Name: ForExprType032 :)
(: Description: FLWOR expressions with type declaration. Value based subtype promotion: 2nd level derived types :)

for $test as xs:anyAtomicType in ( xs:boolean("true"), xs:base64Binary("abcd"), xs:hexBinary("1234"), xs:float("5.7"), xs:double("7.5"), xs:anyURI("http://foo") )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType032.txt')

!

test_ForExprType033

    | query result |

    query := ' 
        (: Name: ForExprType033 :)
(: Description: FLWOR expressions with type declaration. Value based subtype promotion: Types from all levels :)

for $test as xs:anyAtomicType in ( xs:unsignedByte("10"), xs:short("20"), xs:positiveInteger("30"), xs:nonPositiveInteger("-40"), xs:decimal("5.5"), xs:ENTITY("entity1"), xs:NCName("foobar"), xs:language("en-US"), xs:string("foobar"), xs:hexBinary("ffff"), xs:gYear("1999") )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType033.txt')

!

test_ForExprType034

    | query result |

    query := ' 
        (: Name: ForExprType034 :)
(: Description: FLWOR expressions with type declaration. Value based subtype promotion: numeric literal values -> double :)

for $test as xs:decimal in ( 1, 0.3 )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType034.txt')

!

test_ForExprType035

    | query result |

    query := ' 
        (: Name: ForExprType035 :)
(: Description: FLWOR expressions with type declaration. Value based subtype promotion: string and numeric literal values -> anyAtomicType :)

for $test as xs:anyAtomicType in ( 1, "string", 1e2, 0.3 )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType035.txt')

!

test_ForExprType036

    | query result |

    query := ' 
        (: Name: ForExprType036 :)
(: Description: FLWOR expressions with type declaration (element type). Simple element wildcard :)

(: insert-start :)
declare default element namespace "http://typedecl";

declare variable $input-context external;
(: insert-end :)

for $test as element(*) in $input-context/root/InterleaveType/*
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'SpecialTypes'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType036.xml')

!

test_ForExprType045

    | query result |

    query := ' 
        (: Name: ForExprType045 :)
(: Description: FLWOR expressions with type declaration. Unknown Type :)

for $test as xs:unknownType in ( 1, 2, 3)
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'SpecialTypes'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType046

    | query result |

    query := ' 
        (: Name: ForExprType046 :)
(: Description: FLWOR expressions with type declaration. Attempt to promote xs:decimal | xs:double | xs:integer - no common subtype :)

for $test as xs:double in ( 1, 1e2, 0.3 )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'SpecialTypes'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType047

    | query result |

    query := ' 
        (: Name: ForExprType047 :)
(: Description: FLWOR expressions with type declaration. Test matching no atomic simple types :)

for $test as xs:NMTOKENS in ( xs:NMTOKEN("ab"), xs:NMTOKEN("cd") )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'SpecialTypes'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType054

    | query result |

    query := ' 
        (: Name: ForExprType054 :)
(: Description: FLWOR expressions with type declaration. Type declaration matching item() values :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as item() in data( ($input-context//fs:Folder)[1]/fs:File/fs:FileName )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType054.txt')

!

test_ForExprType055

    | query result |

    query := ' 
        (: Name: ForExprType055 :)
(: Description: FLWOR expressions with type declaration. Type declaration matching node() values :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as node() in ($input-context//fs:Folder)[1]/fs:File
return $test/fs:FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType055.xml')

!

test_ForExprType056

    | query result |

    query := ' 
        (: Name: ForExprType056 :)
(: Description: FLWOR expressions with type declaration. Type declaration matching a document node :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as document-node() in $input-context
return ($test//fs:Folder)[1]/fs:FolderName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType056.xml')

!

test_ForExprType057

    | query result |

    query := ' 
        (: Name: ForExprType057 :)
(: Description: FLWOR expressions with type declaration. Type declaration matcing text nodes :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as text() in ($input-context//fs:Folder)[1]/fs:File/fs:FileName/text()
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType057.txt')

!

test_ForExprType058

    | query result |

    query := ' 
        (: Name: ForExprType058 :)
(: Description: FLWOR expressions with type declaration. Type declaration matcing XML comment nodes :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as comment() in ($input-context//fs:Folder)[1]/comment()
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType058.xml')

!

test_ForExprType059

    | query result |

    query := ' 
        (: Name: ForExprType059 :)
(: Description: FLWOR expressions with type declaration. Type declaration matcing PI nodes :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as processing-instruction() in ($input-context//fs:Folder)[1]//processing-instruction()
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType059.txt')

!

test_ForExprType060

    | query result |

    query := ' 
        (: Name: ForExprType060 :)
(: Description: FLWOR expressions with type declaration. Type declaration matcing named PI nodes :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as processing-instruction("filesystem") in ($input-context//fs:Folder)[1]//processing-instruction()
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType060.txt')

!

test_ForExprType061

    | query result |

    query := ' 
        (: Name: ForExprType061 :)
(: Description: FLWOR expressions with type declaration. Type declaration matcing PI nodes - no matching PI found :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as processing-instruction("unknown") in ($input-context//fs:Folder)[1]//processing-instruction()
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType062

    | query result |

    query := ' 
        (: Name: ForExprType062 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of item() on a set of nodes :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as item() in ($input-context//fs:Folder)[1]/fs:File/fs:FileName
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExprType/ForExprType062.xml')

!

test_ForExprType063

    | query result |

    query := ' 
        (: Name: ForExprType063 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of node() on a set of items :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as node() in data( ($input-context//fs:Folder)[1]/fs:File/fs:FileName )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType064

    | query result |

    query := ' 
        (: Name: ForExprType064 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of text() on a set of element nodes :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as text() in ($input-context//fs:Folder)[1]/fs:File/fs:FileName
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType065

    | query result |

    query := ' 
        (: Name: ForExprType065 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of text() on a set of values :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as text() in data( ($input-context//fs:Folder)[1]/fs:File/fs:FileName )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType066

    | query result |

    query := ' 
        (: Name: ForExprType066 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of comment() on a set of element nodes :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as comment() in ($input-context//fs:Folder)[1]/fs:File/fs:FileName
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType067

    | query result |

    query := ' 
        (: Name: ForExprType067 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of comment() on a set of values :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as comment() in data( ($input-context//fs:Folder)[1]/fs:File/fs:FileName )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType068

    | query result |

    query := ' 
        (: Name: ForExprType068 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of processing-instruction() on a set of element nodes :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as processing-instruction() in ($input-context//fs:Folder)[1]/fs:File/fs:FileName
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType069

    | query result |

    query := ' 
        (: Name: ForExprType069 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of processing-instruction() on a set of values :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as processing-instruction() in data( ($input-context//fs:Folder)[1]/fs:File/fs:FileName )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType070

    | query result |

    query := ' 
        (: Name: ForExprType070 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of processing-instruction() with name specifier, on a set of element nodes :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as processing-instruction("foo") in ($input-context//fs:Folder)[1]/fs:File/fs:FileName
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType071

    | query result |

    query := ' 
        (: Name: ForExprType071 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of processing-instruction() with name specifier, on a set of values :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as processing-instruction("foo") in data( ($input-context//fs:Folder)[1]/fs:File/fs:FileName )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType072

    | query result |

    query := ' 
        (: Name: ForExprType072 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of document-node() on a set of element nodes :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as document-node() in ($input-context//fs:Folder)[1]/fs:File/fs:FileName
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExprType073

    | query result |

    query := ' 
        (: Name: ForExprType073 :)
(: Description: FLWOR expressions with type declaration. Attempt type declaration of document-node() on a set of values :)

declare namespace fs="http://www.example.com/filesystem";

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $test as document-node() in data( ($input-context//fs:Folder)[1]/fs:File/fs:FileName )
return $test
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx_NS'.

     

    self shouldRaiseError: [interpreter evaluate: query].
! !

!XQTSForExprWithTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
