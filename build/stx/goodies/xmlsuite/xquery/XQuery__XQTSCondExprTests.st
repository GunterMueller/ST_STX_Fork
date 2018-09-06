"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSCondExprTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSCondExprTests methodsFor:'tests'!

test_CondExpr002

    | query result |

    query := ' 
        (: Name: CondExpr002 :)
(: Description: Simple if expression where boolean is a constant true :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

if (fn:true()) then
    <elem1/>
else
    <elem2/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr002.xml')

!

test_CondExpr003

    | query result |

    query := ' 
        (: Name: CondExpr003 :)
(: Description: Simple if expression where boolean is a constant false :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

if (fn:false()) then
    <elem1/>
else
    <elem2/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr003.xml')

!

test_CondExpr004

    | query result |

    query := ' 
        (: Name: CondExpr004 :)
(: Description: Node set from a path expression as test condition :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

if ($input-context//CompanyName) then
    <elem1/>
else
    <elem2/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'nw_Customers'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr004.xml')

!

test_CondExpr005

    | query result |

    query := ' 
        (: Name: CondExpr005 :)
(: Description: Empty node set from a path expression as test condition :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

if ($input-context//NodeDoesNotExist) then
    <elem1/>
else
    <elem2/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'nw_Customers'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr005.xml')

!

test_CondExpr007

    | query result |

    query := ' 
        (: Name: CondExpr007 :)
(: Description: else-expr has another if expression :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

if ($input-context//MissingNode) then                 
     <elem3/>
else
         if ($input-context/Root/Customers[@CustomerID="ALFKI"]//Country = "Germany") then
                 <elem1/>
         else
                 <elem2/>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'nw_Customers'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr007.xml')

!

test_CondExpr008

    | query result |

    query := ' 
        (: Name: CondExpr008 :)
(: Description: and-expression in test expression :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

if ( $input-context/Root/Customers[1]/@CustomerID = "ALFKI" and $input-context/Root/Customers[1]/FullAddress/City = "Berlin")
then                 
     <PASS/>
else
      <FAIL/>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'nw_Customers'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr008.xml')

!

test_CondExpr009

    | query result |

    query := ' 
        (: Name: CondExpr009 :)
(: Description: or-expression in test expression :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

if  ($input-context/Root/Customers[1]/@CustomerID = "ALFKI" or $input-context/Root/Customers[1]/FullAddress/City = "Non-Existent")
then                 
     <PASS/>
else
      <FAIL/>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'nw_Customers'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr009.xml')

!

test_CondExpr012

    | query result |

    query := ' 
        (: FileName: CondExpr012 :)
(: Description: Adapted from example in spec; test expression is a relational expression :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<out>{ if ($input-context/doc/widget1/@unit-cost = $input-context/doc/widget2/@unit-cost)
     then $input-context/doc/widget1/@name else $input-context/doc/widget2/@name }</out>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'xq311A'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr012.xml')

!

test_CondExpr016

    | query result |

    query := ' 
        (: FileName: CondExpr016 :)
(: Purpose: if where branches return different valid types :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

($input-context//Folder)[1]/File[ if ( ./@name="File00000000000" ) then 2 else true() ]/FileName

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr016.xml')

!

test_CondExpr017

    | query result |

    query := ' 
        (: FileName: CondExpr017 :)
(: Purpose: if where branches return different valid types :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return
	if( $file/FileName="File00000000000" )
	then $file/FileName
	else data( $file/FileName )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr017.xml')

!

test_CondExpr018

    | query result |

    query := ' 
        (: FileName: CondExpr018 :)
(: Purpose: if where branches return different valid types :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return
	if( $file/FileName="File00000000004" )
	then 1
	else data( $file/FileName )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/CondExpr018.txt')

!

test_CondExpr019

    | query result |

    query := ' 
        (: FileName: CondExpr019 :)
(: Purpose: Test with test expression not contained in ( ... ) :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

if $input-context//File[1]
then "true"
else "false"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_CondExpr_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-1                                    :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(if(2) then 1 else 0) eq 1`. :)
(:*******************************************************:)
(if(2) then 1 else 0) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-1.txt')

!

test_K_CondExpr_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-10                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An if-test applied on fn:count().            :)
(:*******************************************************:)
if(count((1, 2, 3, current-time(), 4))) then true() else 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-10.txt')

!

test_K_CondExpr_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-11                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An if-test applied on fn:count() combined with fn:not(). :)
(:*******************************************************:)
if(not(count(remove((1, 2, 3, current-time()), 1)))) then 3 else true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-11.txt')

!

test_K_CondExpr_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-12                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: if-then clause combined with fn:boolean().   :)
(:*******************************************************:)
if(boolean((1, 2, 3, current-time())[1] treat as xs:integer)) then true() else 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-12.txt')

!

test_K_CondExpr_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-2                                    :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `if(()) then false() else true()`. :)
(:*******************************************************:)
if(()) then false() else true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-2.txt')

!

test_K_CondExpr_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-3                                    :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An expression involving the if expression that trigger certain optimization paths in some implementations. :)
(:*******************************************************:)
(if((1, current-time())[1] treat as xs:integer) then true() else false()) eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-3.txt')

!

test_K_CondExpr_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-4                                    :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An expression involving the if expression that trigger certain optimization paths in some implementations(#2). :)
(:*******************************************************:)
(if(boolean((1, current-time())[1] treat as xs:integer)) then true() else false()) eq true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-4.txt')

!

test_K_CondExpr_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-5                                    :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An expression involving the if expression that trigger certain optimization paths in some implementations(#2). :)
(:*******************************************************:)
if((1, 2, 3, hours-from-time(current-time()))[1])
		then true() else false()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-5.txt')

!

test_K_CondExpr_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-6                                    :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An expression involving the if expression that trigger certain optimization paths in some implementations(#3). :)
(:*******************************************************:)
string(if(boolean((1, current-time())[1] treat as xs:integer)) then true() else false()) eq "true"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-6.txt')

!

test_K_CondExpr_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-7                                    :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An if-test which EBV cannot be extracted from. :)
(:*******************************************************:)
(if(current-time()) then 1 else 0) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_CondExpr_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-8                                    :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An if-test which EBV cannot be extracted from. :)
(:*******************************************************:)
1 eq (if(xs:anyURI("example.com/")) then 1 else 0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-8.txt')

!

test_K_CondExpr_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-CondExpr-9                                    :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An if-test which EBV cannot be extracted from. :)
(:*******************************************************:)
0 eq (if(xs:anyURI("")) then 1 else 0)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/CondExpr/K-CondExpr-9.txt')

! !

!XQTSCondExprTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
