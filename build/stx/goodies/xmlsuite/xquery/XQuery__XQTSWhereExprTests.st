"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSWhereExprTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSWhereExprTests methodsFor:'tests'!

test_K_WhereExpr_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-1                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for/where combination where the cardinality of the return statement is crucially affected by the binding sequence. :)
(:*******************************************************:)
(for $fo in (1, 2, 3) where $fo eq 3 return $fo) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/WhereExpr/K-WhereExpr-1.txt')

!

test_K_WhereExpr_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-10                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for/where expression combined with fn:boolean and xs:anyURI. :)
(:*******************************************************:)
for $i in (1, 2, current-time())[1] where xs:anyURI("example.com/") return true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/WhereExpr/K-WhereExpr-10.txt')

!

test_K_WhereExpr_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-11                                  :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for/where expression combined with fn:boolean and xs:anyURI. :)
(:*******************************************************:)
empty(for $i in (1, 2, current-time())[1] where xs:anyURI("") return true())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/WhereExpr/K-WhereExpr-11.txt')

!

test_K_WhereExpr_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-2                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Get the string value of the return statement of a for expression after being filtered by a where clause. :)
(:*******************************************************:)
string((for $fo in (1, 2, 3) where $fo eq 3 return $fo)) eq "3"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/WhereExpr/K-WhereExpr-2.txt')

!

test_K_WhereExpr_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-3                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A where clause containing a value which EBV cannot be extracted from. :)
(:*******************************************************:)
count((for $fo in (1, 2, 3) where xs:time("08:08:23Z") return $fo)) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_WhereExpr_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-4                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for/where expression combined with fn:count(). :)
(:*******************************************************:)
for $i in 1 where count(($i, 2, timezone-from-time(current-time()))) return true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/WhereExpr/K-WhereExpr-4.txt')

!

test_K_WhereExpr_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-5                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for expression binding to one single value, combined with a positive where clause. :)
(:*******************************************************:)
empty(for $i in 1 where false() return $i)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/WhereExpr/K-WhereExpr-5.txt')

!

test_K_WhereExpr_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-6                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for expression binding to one single value, combined with a negative where clause. :)
(:*******************************************************:)
(for $i in 1 where true() return $i) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/WhereExpr/K-WhereExpr-6.txt')

!

test_K_WhereExpr_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-7                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for expression binding to one single value, combined with a positive where clause. :)
(:*******************************************************:)
empty(for $i in 1 where (1, current-time())[1] treat as xs:integer eq 0 return $i)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/WhereExpr/K-WhereExpr-7.txt')

!

test_K_WhereExpr_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-8                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for expression binding to one single value, combined with a negative where clause. :)
(:*******************************************************:)
(for $i in 1 where (1, current-time())[1] treat as xs:integer eq 1 return $i) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/WhereExpr/K-WhereExpr-8.txt')

!

test_K_WhereExpr_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-WhereExpr-9                                   :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for/where expression combined with fn:boolean. :)
(:*******************************************************:)
for $i in (1, 2, current-time())[1] where fn:boolean($i treat as xs:integer) return true()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/WhereExpr/K-WhereExpr-9.txt')

!

test_WhereExpr001

    | query result |

    query := ' 
        (: Name: WhereExpr001 :)
(: Description: For+Where+Return - test existence of child elements in Where clause :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

if ( count( for $f in $input-context//* where $f/File return $f/File[1] ) = count( $input-context//File[1]) )
then <Same/>
else <notSame/>  


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr001.xml')

!

test_WhereExpr002

    | query result |

    query := ' 
        (: Name: WhereExpr002 :)
(: Description: For+Where+Return - error, variable in "Where" Expr hasn"t been defined :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context//Folder
where $folde/@name = "ABC"
return <folder/>


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_WhereExpr003

    | query result |

    query := ' 
        (: Name: WhereExpr003 :)
(: Description: For+Where+Return - using same predicate (as FLWOR003) in "Where" predicate :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $d in $input-context/MyComputer/Drive4
where $d/Folder[@id="128"]
return <FolderName>{$d/Folder/@name}</FolderName>


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr003.xml')

!

test_WhereExpr004

    | query result |

    query := ' 
        (: Name: WhereExpr004 :)
(: Description: For+Where+Return - filters in "Where" expr and in "In" expr using predicate :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $f in $input-context/MyComputer/Drive1/Folder[@creator="Mani"]/File
where $f/@creation_date="08/06/00"
return $f


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr004.xml')

!

test_WhereExpr005

    | query result |

    query := ' 
        (: Name: WhereExpr005 :)
(: Description: For+Where+Return - use always-false-predicate in "Where" expr :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<empty>
  { for $folder in $input-context/MyComputer/Drive2//Folder
    where 1 = 2
    return 
    <Folder>
    { $folder/FolderName/text() }
    </Folder> 
  }
</empty>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr005.xml')

!

test_WhereExpr006

    | query result |

    query := ' 
        (: Name: WhereExpr006 :)
(: Description: For+Where+Return - In the inner For+Where+Return, uses outer variable in "Where" expr :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context/MyComputer/Drive4//Folder
return 
<Folder>{ $folder/@name }{ for $file in $input-context/MyComputer/Drive4//File
                           where $file/@idref = $folder/@id
                           return 
                           <File>{ $file/@name }</File>
}</Folder>


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr006.xml')

!

test_WhereExpr007

    | query result |

    query := ' 
        (: Name: WhereExpr007 :)
(: Description: For+Where+Return - 2 iterations use "Where" to build relationship :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<fragment-result>{
	for $folder in $input-context/MyComputer/Drive3/Folder
	   ,$file in $input-context/MyComputer/Drive3/Folder/File
	where $folder/@id = $file/@idref
	return
	<Folder>
	 { $folder/@name, $folder/@id }
	 <file>{ $file/@idref, $file/FileName/text() }</file>
	</Folder>
}</fragment-result>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr007.xml')

!

test_WhereExpr008

    | query result |

    query := ' 
        (: Name: WhereExpr008 :)
(: Description: Test "where" expression with the empty sequence literal :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<empty>
{
for $file in ($input-context//Folder)[1]/File
where ()
return $file/FileName
}
</empty>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr008.xml')

!

test_WhereExpr009

    | query result |

    query := ' 
        (: Name: WhereExpr009 :)
(: Description: Test "where" expression returning a sequence with one or more nodes :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
where $file/SecurityObject/Denies/Deny/security/right
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr009.xml')

!

test_WhereExpr010

    | query result |

    query := ' 
        (: Name: WhereExpr010 :)
(: Description: Test "where" expression returning a sequence with multiple values :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
where data( $file/SecurityObject//right )
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_WhereExpr013

    | query result |

    query := ' 
        (: Name: WhereExpr013 :)
(: Description: Test "where" expression returning a sequence with a single boolean value :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
where $file/SecurityObject/Denies/Deny/security/right="Change"
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr013.xml')

!

test_WhereExpr014

    | query result |

    query := ' 
        (: Name: WhereExpr014 :)
(: Description: Test "where" expression returning a sequence with a constant boolean value :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
where true()
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr014.xml')

!

test_WhereExpr015

    | query result |

    query := ' 
        (: Name: WhereExpr015 :)
(: Description: Test "where" expression returning a sequence with a constant boolean value :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<empty>
{
for $file in ($input-context//Folder)[1]/File
where false()
return $file/FileName
}
</empty>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr015.xml')

!

test_WhereExpr016

    | query result |

    query := ' 
        (: Name: WhereExpr016 :)
(: Description: Test "where" clause based on a positional variable :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file at $offset in ($input-context//Folder)[1]/File
where $offset mod 2 = 1
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/WhereExpr016.xml')

!

test_WhereExpr017

    | query result |

    query := ' 
        (: Name: WhereExpr017 :)
(: Description: Attempt to use multiple expressions in a "where" clause :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
where true(), true()
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_WhereExpr018

    | query result |

    query := ' 
        (: Name: WhereExpr018 :)
(: Description: Use of undefined variable in "where" clause :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
where $undefined
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_WhereExpr019

    | query result |

    query := ' 
        (: Name: WhereExpr019 :)
(: Description: Typo on "where" clause :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
where_ true()
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_WhereExpr020

    | query result |

    query := ' 
        (: Name: WhereExpr019 :)
(: Description: Multiple "where" clauses :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
where true()
where false()
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_whereClause_1

    | query result |

    query := ' 
        (: Name: whereClause-1 :)
(: Description: use of where clause involving an "or" expression. Use fn:true():)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := (fn:true())
where $var or fn:true()
return
  $var or fn:true()
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-1.txt')

!

test_whereClause_10

    | query result |

    query := ' 
        (: Name: whereClause-10 :)
(: Description: use of where clause used with quantified expression (some keyword). :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := 1

where some $x in (1, 2) satisfies fn:string($var) = "1"
return
 fn:string($var )
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-10.txt')

!

test_whereClause_11

    | query result |

    query := ' 
        (: Name: whereClause-11 :)
(: Description: use of where clause used with quantified expression (every keyword). :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := 1

where every $x in (1, 1) satisfies fn:string($var) = "1"
return
 fn:string($var )
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-11.txt')

!

test_whereClause_2

    | query result |

    query := ' 
        (: Name: whereClause-2 :)
(: Description: use of where clause involving an "or" expression. Use fn:false():)
(: Use fn:not() :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := (fn:false())
where fn:not($var or fn:false())
return
  $var or fn:false()
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-2.txt')

!

test_whereClause_3

    | query result |

    query := ' 
        (: Name: whereClause-3 :)
(: Description: use of where clause involving an "or" ("and" operator) expression. Use fn:true():)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := (fn:true())
where $var and fn:true()
return
  $var and fn:true()
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-3.txt')

!

test_whereClause_4

    | query result |

    query := ' 
        (: Name: whereClause-4 :)
(: Description: use of where clause involving an "or" ("and" operator) expression. Use fn:false():)
(: Use fn:not() :)
(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := (fn:false())
where fn:not($var and fn:false())
return
  $var and fn:false()
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-4.txt')

!

test_whereClause_5

    | query result |

    query := ' 
        (: Name: whereClause-5 :)
(: Description: use of where clause with a typeswitch expression :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := 100
where typeswitch($var)
        case $i as xs:string
         return fn:false() 
        case $i as xs:integer
         return fn:true() 
        default
         return fn:false()
return
 $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-5.txt')

!

test_whereClause_6

    | query result |

    query := ' 
        (: Name: whereClause-6 :)
(: Description: use of where clause used with a string value and fn:string :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := "String"
where fn:string($var) = "String"
return
 $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-6.txt')

!

test_whereClause_7

    | query result |

    query := ' 
        (: Name: whereClause-7 :)
(: Description: use of where clause used with a string-length function. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := "String"
where fn:string-length($var) = 6
return
 fn:string-length($var)
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-7.txt')

!

test_whereClause_8

    | query result |

    query := ' 
        (: Name: whereClause-8 :)
(: Description: use of where clause used with a fn:count() function. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := 100
where fn:count(($var)) = 1
return
 fn:count(($var))
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-8.txt')

!

test_whereClause_9

    | query result |

    query := ' 
        (: Name: whereClause-9 :)
(: Description: use of where clause used with is comparator. :)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

let $var := <anElement>Some content</anElement>

where $var is $var
return
 $var is $var
      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/WhereExpr/whereClause-9.txt')

! !

!XQTSWhereExprTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
