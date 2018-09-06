"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSForExprWithoutTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSForExprWithoutTests methodsFor:'tests'!

test_ForExpr001

    | query result |

    query := ' 
        (: Name: ForExpr001 :)
(: Description: For+Return - to iterate a constant sequence :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $a in ("test", "test1", "test2")
return $a




      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr001.txt')

!

test_ForExpr002

    | query result |

    query := ' 
        (: Name: ForExpr002 :)
(: Description: For+Return - error, undefined variable in "IN" Expr :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $folder/File 
return <file name="{$folder/File/FileName}"/>


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExpr003

    | query result |

    query := ' 
        (: Name: ForExpr003 :)
(: Description: For+Return - use predicate in "IN" Expr :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $f in $input-context/MyComputer/Drive4/Folder[@id="128"]
return <FolderName>{$f/@name}</FolderName>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr003.xml')

!

test_ForExpr004

    | query result |

    query := ' 
        (: Name: ForExpr004 :)
(: Description: For+Return - use more than one predicates in "IN" Expr :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $f in $input-context/MyComputer/Drive1/Folder[@creator="Mani"]/File[@creation_date="08/06/00"]
return  <file>{$f/../@creator}{$f/@creation_date}</file>



      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr004.xml')

!

test_ForExpr005

    | query result |

    query := ' 
        (: Name: ForExpr005 :)
(: Description: For+Return - use sequence(security/right) as the predicate :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $f in $input-context/MyComputer//File[@creation_date="08/06/00"]/SecurityObject/Denies/Deny[security/right]
 return $f

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr005.xml')

!

test_ForExpr006

    | query result |

    query := ' 
        (: Name: ForExpr006 :)
(: Description: For+Return - 2 For will generate two iterations :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<fragment-result>{
	for $folder in $input-context/MyComputer/Drive3/Folder
	   ,$file in $input-context/MyComputer/Drive3/Folder/File
	return 
	<Folder>{ $folder/@name, $folder/@id }<file>{ $file/@idref }{ data($file/@name) }</file>
	</Folder>
}</fragment-result>


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr006.xml')

!

test_ForExpr007

    | query result |

    query := ' 
        (: Name: ForExpr007 :)
(: Description: For+Return - use special character in variable name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $AaBbCc.-_Dd in $input-context/MyComputer/Drive1/Folder
return $AaBbCc.-_Dd/FolderName

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr007.xml')

!

test_ForExpr008

    | query result |

    query := ' 
        (: Name: ForExpr008 :)
(: Description: For+Where+Return - use special characters in variable name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $AaBbCc.-_Dd in $input-context/MyComputer/Drive1/Folder
where $AaBbCc.-_Dd/@creator = "Mani"
return $AaBbCc.-_Dd/FolderName

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr008.xml')

!

test_ForExpr009

    | query result |

    query := ' 
        (: Name: ForExpr009 :)
(: Description: For+Return - error, use variable in it"s own declaration  :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $a in $a/*
return $a

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExpr010

    | query result |

    query := ' 
        (: Name: ForExpr010 :)
(: Description: FLWOR expression with multiple, interdependent variables :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context//Folder
	for $file in $folder//File
return 
<File folder="{$folder/FolderName}">{string($file/FileName[1])}</File>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr010.xml')

!

test_ForExpr011

    | query result |

    query := ' 
        (: Name: ForExpr011 :)
(: Description: FLWOR expression with multiple, interdependent variables :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context//Folder, $file in $folder//File
return 
<File folder="{$folder/FolderName}">{string($file/FileName[1])}</File>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr011.xml')

!

test_ForExpr012

    | query result |

    query := ' 
        (: Name: ForExpr012 :)
(: Description: Nested FLWOR expressions :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $fileName in 
	for $file in $input-context//Folder/File
	return $file/FileName
return string( $fileName )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr012.txt')

!

test_ForExpr013

    | query result |
    self halt: 'should be fixed'.
    query := ' 
        (: Name: ForExpr013 :)
(: Description: Multiple variables based off the same input context :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $fileName in $input-context//File/FileName, 
        $folderName in $input-context//Folder/FolderName
return ($folderName, $fileName)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr013.xml')

    "Modified: / 30-12-2009 / 12:58:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_ForExpr014

    | query result |

    query := ' 
        (: Name: ForExpr014 :)
(: Description: Incorrect syntax for nested loop. Multiple return statements at the same level :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $fileName in $input-context//File/FileName
	for $folderName in $input-context//Folder/FolderName
	return $folderName
return $fileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExpr015

    | query result |

    query := ' 
        (: Name: ForExpr015 :)
(: Description: Return expression contains nested for expression :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context//Folder
return 
	for $file in $folder/File
	return string( $file/FileName[1] )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr015.txt')

!

test_ForExpr016

    | query result |

    query := ' 
        (: Name: ForExpr016 :)
(: Description: Interate over nodes in document and constant sequence. Return value based on both :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context//Folder, 
	$index in (1, 2, 3)
return $folder/File[$index]/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr016.xml')

!

test_ForExpr017

    | query result |

    query := ' 
        (: Name: ForExpr017 :)
(: Description: Multiple return statements from single for expression :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context//Folder
return $folder
return $folder
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExpr018

    | query result |

    query := ' 
        (: Name: ForExpr018 :)
(: Description: Multiple in statements for single variable binding :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in in $input-context//Folder
return $folder

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExpr019

    | query result |

    query := ' 
        (: Name: ForExpr019 :)
(: Description: Multiple for statements for single variable binding :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for for $folder in $input-context//Folder
return $folder

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExpr020

    | query result |

    query := ' 
        (: Name: ForExpr020 :)
(: Description: Multiple variable bindings followed by a trailing , :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context//Folder, 
	$file in $folder/File,
return $file/FileName

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExpr021

    | query result |

    query := ' 
        (: Name: ForExpr021 :)
(: Description: Test order of iteration between two variables in the same "for" statement :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $i in (1, 2), $j in (3, 4)
return ($i, $j)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr021.txt')

!

test_ForExpr022

    | query result |

    query := ' 
        (: Name: ForExpr022 :)
(: Description: FLWOR expressions with positional variable :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file at $pos in ($input-context//Folder)[1]/File
return (string($file/FileName[1]), $pos)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr022.txt')

!

test_ForExpr023

    | query result |

    query := ' 
        (: Name: ForExpr023 :)
(: Description: Use positional variable in binding for new variable :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file at $pos in ($input-context//Folder)[1]/File, $pos2 in $pos+1
return (string($file/FileName[1]), $pos, $pos2)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr023.txt')

!

test_ForExpr024

    | query result |

    query := ' 
        (: Name: ForExpr024 :)
(: Description: Reuse existing variable name for positional variable :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file at $file in ($input-context//Folder)[1]/File
return (string($file/FileName[1]), $file)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExpr025

    | query result |

    query := ' 
        (: Name: ForExpr025 :)
(: Description: Redefine existing bound variable. Second binding overrides first :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File, $file in ($input-context//Folder)[2]/File
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr025.xml')

!

test_ForExpr026

    | query result |

    query := ' 
        (: Name: ForExpr026 :)
(: Description: Missing "in" :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file ($input-context//Folder)[1]/File
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExpr027

    | query result |

    query := ' 
        (: Name: ForExpr027 :)
(: Description: Wrong order for positional variable :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File at $pos
return (string($file/FileName[1]), $pos)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ForExpr028

    | query result |

    query := ' 
        (: Name: ForExpr028 :)
(: Description: FLWOR expression iterating over constructed XML :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $num in ( <one/>, <two/>, <three/> )
return $num
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr028.xml')

!

test_ForExpr029

    | query result |

    query := ' 
        (: Name: ForExpr029 :)
(: Description: Embedded FLOWR expression that binds same variable on boths expressions (two for clauses) :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $var in (1,2) for $var in (2,2) return $var * $var
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr029.txt')

!

test_ForExpr030

    | query result |

    query := ' 
        (: Name: ForExpr030 :)
(: Description: Embedded FLOWR expression that binds same variable on boths expressions (use commas) :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $var in (1,2), $var in (2,2) return $var * $var
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ForExpr/ForExpr030.txt')

!

test_ForExpr031

    | query result |

    query := ' 
        (: Name: ForExpr031 :)
(: Description: FLOWR expression that binds same variable on both ends of "at" :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)


for $var at $var in (1, 2) return $var * $var
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-1                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Syntactically invalid for-expression.        :)
(:*******************************************************:)
for $foo in 1, $bar in 2, $moo in 3, return 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-10                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `deep-equal((for $var in (1, 2, 3) return $var), (1, 2, 3))`. :)
(:*******************************************************:)
deep-equal((for $var in (1, 2, 3) return $var),
					  (1, 2, 3))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-10.txt')

!

test_K_ForExprWithout_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-11                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `deep-equal((2, 2), (for $foo in (1, 1) return 1 + $foo))`. :)
(:*******************************************************:)
deep-equal((2, 2), (for $foo in (1, 1) return 1 + $foo))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-11.txt')

!

test_K_ForExprWithout_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-12                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `4 eq (for $foo in 1, $bar in 2, $moo in 3 return 4)`. :)
(:*******************************************************:)
4 eq (for $foo in 1, $bar in 2, $moo in 3 return 4)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-12.txt')

!

test_K_ForExprWithout_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-13                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `3 eq (for $foo in 1 return for $bar in 2 return $bar + $foo)`. :)
(:*******************************************************:)
3 eq (for $foo in 1 return for $bar in 2 return $bar + $foo)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-13.txt')

!

test_K_ForExprWithout_14

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-14                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `3 eq (for $foo in 1 return for $bar in 2 return $bar + $foo)`. :)
(:*******************************************************:)
3 eq (for $foo in 1 return for $bar in 2 return $bar + $foo)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-14.txt')

!

test_K_ForExprWithout_15

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-15                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `3 eq (for $foo in 1, $foo in 3 return $foo)`. :)
(:*******************************************************:)
3 eq (for $foo in 1, $foo in 3 return $foo)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-15.txt')

!

test_K_ForExprWithout_16

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-16                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `8 eq (for $foo in 1, $foo in 3, $moo in 5 return $moo + $foo)`. :)
(:*******************************************************:)
8 eq (for $foo in 1, $foo in 3, $moo in 5 return $moo + $foo)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-16.txt')

!

test_K_ForExprWithout_17

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-17                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `6 eq (for $foo in 1, $foo in 3 return $foo + $foo)`. :)
(:*******************************************************:)
6 eq (for $foo in 1, $foo in 3 return $foo + $foo)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-17.txt')

!

test_K_ForExprWithout_18

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-18                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for variable binding to the empty sequence. :)
(:*******************************************************:)
empty(for $var in () return current-time())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-18.txt')

!

test_K_ForExprWithout_19

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-19                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for variable binding to the empty sequence. :)
(:*******************************************************:)
empty(for $var in () return 1)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-19.txt')

!

test_K_ForExprWithout_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-2                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Syntactically invalid for-expression.        :)
(:*******************************************************:)
for in 1 return 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_20

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-20                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for variable binding to the empty sequence, combined with value comparison. :)
(:*******************************************************:)
empty((for $var in () return current-time()))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-20.txt')

!

test_K_ForExprWithout_21

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-21                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for variable binding to the empty sequence, combined with value comparison. :)
(:*******************************************************:)
empty((for $var in () return 1) eq 1)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-21.txt')

!

test_K_ForExprWithout_22

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-22                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A for variable binding to the empty sequence, combined with value comparison. :)
(:*******************************************************:)
empty(for $var in subsequence((current-time(), 1), 4) return 1)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-22.txt')

!

test_K_ForExprWithout_23

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-23                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: An for-return expression which only is the binding variable. :)
(:*******************************************************:)
deep-equal(remove(for $var in (current-time(), 2, 3, 4) return $var, 1), (2, 3, 4))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-23.txt')

!

test_K_ForExprWithout_24

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-24                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(for $fn:name in (1, 1) return $fn:name) instance of xs:integer+`. :)
(:*******************************************************:)
(for $fn:name in (1, 1) return $fn:name) instance of xs:integer+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-24.txt')

!

test_K_ForExprWithout_25

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-25                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `(for $xs:name in (1, 1) return $xs:name) instance of xs:integer+`. :)
(:*******************************************************:)
(for $xs:name in (1, 1) return $xs:name) instance of xs:integer+
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-25.txt')

!

test_K_ForExprWithout_26

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-26                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
$NOTEXIST
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_27

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-27                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
$PREFIXNOTEXIST:NOTEXIST
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_28

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-28                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
$xs:NOTEXIST
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_29

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-29                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
1 + $NOTEXIST
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-3                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Syntactically invalid for-expression.        :)
(:*******************************************************:)
for return 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_30

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-30                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
1 + $prefix:NOTEXIST
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_31

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-31                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
1 + $xs:NOTEXIST
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_32

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-32                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
$NOTEXIST + 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_33

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-33                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
$PREFIXNOTEXIST:NOTEXIST + 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_34

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-34                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
$xs:NOTEXIST + 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_35

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-35                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $foo in 1 return $NOTEXIST
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_36

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-36                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $foo in (1, 2, $foo) return 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_37

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-37                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $foo in (1, $foo, 3) return 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_38

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-38                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $foo in ($foo, 2, 3) return 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_39

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-39                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $foo in $foo return 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-4                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Syntactically invalid for-expression.        :)
(:*******************************************************:)
for $a in 1 satisfies 4
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_40

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-40                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $foo in 1 return 
						$bar + (for $bar in 2 return $bar)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_41

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-41                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $a in (1, 2, 3), $b in (1, 2, 3, $b)
return $a, $b
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_42

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-42                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $a in (1, 2), $b in (1, 2), $c in (1, 2) return 1, $a
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_43

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-43                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $a in (1, 2) return 1, $a
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_44

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-44                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $a in (1, 2), $b in (1, 2), $c in (1, 2) return 1, $b
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_45

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-45                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Variable which is not in scope.              :)
(:*******************************************************:)
for $a in (1, 2), $b in (1, 2), $c in (1, 2) return 1, $c
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_46

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-46                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Type check: $foo is of type xs:string, which cannot be added to xs:integer 1. :)
(:*******************************************************:)
for $foo in "foo" return 1 + $foo
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_47

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-47                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A variable"s for expression causes type error in a value comparison. :)
(:*******************************************************:)
for $foo in ("a string", "another one") return
							1 + subsequence($foo, 1, 1)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K_ForExprWithout_48

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-48                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Parser test: variable names in a for expression that only exist of one character are valid. :)
(:*******************************************************:)
1 eq (for $a in 1 return $a)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-48.txt')

!

test_K_ForExprWithout_49

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-49                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: For-expression involving a simple return statement that in some implementations trigger optimization paths. :)
(:*******************************************************:)
deep-equal((for $fo in trace((1, 2, 3), "msg") return $fo), (1, 2, 3))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-49.txt')

!

test_K_ForExprWithout_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-5                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `deep-equal(1 to 5, (for $i in (1,2,3,4,5) return $i))`. :)
(:*******************************************************:)
deep-equal(1 to 5, (for $i in (1,2,3,4,5) return $i))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-5.txt')

!

test_K_ForExprWithout_50

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-50                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Ensure scanners/parsers accept small QNames in for-expressions. :)
(:*******************************************************:)
1 eq (for $a in 1 return $a)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-50.txt')

!

test_K_ForExprWithout_51

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-51                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Ensure scanners/parsers accept small QNames in for-expressions(#2). :)
(:*******************************************************:)
1 eq (for $xs:a in 1 return $xs:a)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-51.txt')

!

test_K_ForExprWithout_52

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-52                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A binding in a for-expression shadows global variables. :)
(:*******************************************************:)
declare variable $i := false();
declare variable $t := false();
deep-equal(
for $i in (true(), true()), $t in (true(), true()) return ($i, $t),
(true(), true(), true(), true(), true(), true(), true(), true()))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-52.txt')

!

test_K_ForExprWithout_53

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-53                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Ensure the correct variable is used in an for-expression whose return sequence is only a variable reference. :)
(:*******************************************************:)

		   declare variable $my := 3;

		   (for $i in 1 return $my) eq 3
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-53.txt')

!

test_K_ForExprWithout_54

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-54                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Ensure the correct variable is used in an for-expression whose return sequence is only a variable reference(#2). :)
(:*******************************************************:)

		   declare variable $i := 3;

		   (for $i in 1 return $i) eq 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-54.txt')

!

test_K_ForExprWithout_55

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-55                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Apply fn:count() to a for-expression.        :)
(:*******************************************************:)
count(for $i in (1, 2, current-time()) return ($i, $i)) eq 6
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-55.txt')

!

test_K_ForExprWithout_56

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-56                             :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: Apply fn:count() to a for-expression(#2).    :)
(:*******************************************************:)
count(for $i in (1, 2, timezone-from-time(current-time())) return ($i, $i)) eq 6
or
count(for $i in (1, 2, timezone-from-time(current-time())) return ($i, $i)) eq 4

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-56.txt')

!

test_K_ForExprWithout_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-6                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `3 eq (for $foo in 1 return 3)`. :)
(:*******************************************************:)
3 eq (for $foo in 1 return 3)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-6.txt')

!

test_K_ForExprWithout_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-7                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `1 eq (for $foo in 1 return $foo)`. :)
(:*******************************************************:)
1 eq (for $foo in 1 return $foo)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-7.txt')

!

test_K_ForExprWithout_8

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-8                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `2 eq (for $foo in 1 return $foo + 1)`. :)
(:*******************************************************:)
2 eq (for $foo in 1 return $foo + 1)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-8.txt')

!

test_K_ForExprWithout_9

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K-ForExprWithout-9                              :)
(: Written by: Frans Englich                             :)
(: Date: 2006-10-05T18:29:37+02:00                       :)
(: Purpose: A test whose essence is: `3 eq (for $foo in 1 return for $foo in 3 return $foo)`. :)
(:*******************************************************:)
3 eq (for $foo in 1 return
					for $foo in 3 return $foo)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWOR/ForExpr/ForExprWithout/K-ForExprWithout-9.txt')

! !

!XQTSForExprWithoutTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
