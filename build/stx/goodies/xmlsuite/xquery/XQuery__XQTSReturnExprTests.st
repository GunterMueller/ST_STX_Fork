"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSReturnExprTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSReturnExprTests methodsFor:'tests'!

test_ReturnExpr001

    | query result |

    query := ' 
        (: Name: ReturnExpr001 :)
(: Description: For+Return - use element"s text to construct new element :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context/MyComputer/Drive2//Folder
return 
<newFolder>{ $folder/FolderName/text() }</newFolder>


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr001.xml')

!

test_ReturnExpr002

    | query result |

    query := ' 
        (: Name: ReturnExpr002 :)
(: Description: For+Return - use existing attribute to generate new attribute for new element :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context/MyComputer/Drive2//Folder
return 
<newFolder>{ $folder/@name, $folder/FolderName/text() }</newFolder>


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr002.xml')

!

test_ReturnExpr003

    | query result |

    query := ' 
        (: Name: ReturnExpr003 :)
(: Description: For+Return - one For+Return expr contains another one For+Return expr :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context/MyComputer/Drive1/Folder[1]
return 
<folder1>
  {$folder/FolderName}
  <files>
  { for $file in $folder/File
      return $file/FileName
  }
  </files>
</folder1>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr003.xml')

!

test_ReturnExpr004

    | query result |

    query := ' 
        (: Name: ReturnExpr004 :)
(: Description: For+Where+Return - filters in "Where" expr and in "Return" expr using predicate :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $f in $input-context/MyComputer//File
where $f/@creation_date="08/06/00"
return $f/SecurityObject/Denies/Deny[security/right]

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr004.xml')

!

test_ReturnExpr005

    | query result |

    query := ' 
        (: Name: ReturnExpr005 :)
(: Description: FLWOR expression returns selected element nodes :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr005.xml')

!

test_ReturnExpr006

    | query result |

    query := ' 
        (: Name: ReturnExpr006 :)
(: Description: FLWOR expression returns selected values :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return data( $file/FileName )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr006.txt')

!

test_ReturnExpr007

    | query result |

    query := ' 
        (: Name: ReturnExpr007 :)
(: Description: FLWOR expression return parent of select nodes :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return $file/parent::Folder/FolderName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr007.xml')

!

test_ReturnExpr008

    | query result |

    query := ' 
        (: Name: ReturnExpr008 :)
(: Description: FLWOR expression returns constant value, independent of input bindings :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr008.txt')

!

test_ReturnExpr009

    | query result |

    query := ' 
        (: Name: ReturnExpr009 :)
(: Description: FLWOR expression returns node from document, independent of input bindings :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return ($input-context//FileName)[1]
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr009.xml')

!

test_ReturnExpr010

    | query result |

    query := ' 
        (: Name: ReturnExpr010 :)
(: Description: FLWOR expression returns empty sequence literal :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<empty>
{
for $file in ($input-context//Folder)[1]/File
return ()
}
</empty>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr010.xml')

!

test_ReturnExpr011

    | query result |

    query := ' 
        (: Name: ReturnExpr011 :)
(: Description: FLWOR expression returns a constructed sequence :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $folder in $input-context//Folder, $file in $folder/File
return ( $folder/FolderName, $file/FileName )
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr011.xml')

!

test_ReturnExpr012

    | query result |

    query := ' 
        (: Name: ReturnExpr012 :)
(: Description: Multiple return statements :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return $file 
return $file
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ReturnExpr013

    | query result |

    query := ' 
        (: Name: ReturnExpr013 :)
(: Description: Missing "return" statement in FLWOR expression :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ReturnExpr014

    | query result |

    query := ' 
        (: Name: ReturnExpr014 :)
(: Description: FLWOR expression return statement depends on undefined variable :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return $undefined
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ReturnExpr015

    | query result |

    query := ' 
        (: Name: ReturnExpr015 :)
(: Description: Variable bound to value from return statement :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in
	for $folder in ($input-context//Folder)[1]
	return $folder/File
return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr015.xml')

!

test_ReturnExpr016

    | query result |

    query := ' 
        (: Name: ReturnExpr016 :)
(: Description: Return value of positional variable :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file at $offset in ($input-context//Folder)[1]/File
return
<File>{ $file/@name }{ attribute offset{ $offset }}</File>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr016.xml')

!

test_ReturnExpr017

    | query result |

    query := ' 
        (: Name: ReturnExpr017 :)
(: Description: Apply arithmetic operator inside "return" statement :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return ($file/Stream/StreamSize)[1] + 1
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr017.txt')

!

test_ReturnExpr018

    | query result |

    query := ' 
        (: Name: ReturnExpr018 :)
(: Description: Apply comparison operator inside "return" statement :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return ($file/Stream/StreamSize)[1] > 1004
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr018.txt')

!

test_ReturnExpr019

    | query result |

    query := ' 
        (: Name: ReturnExpr019 :)
(: Description: Multiple "return" statements :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return return $file/FileName
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_ReturnExpr020

    | query result |

    query := ' 
        (: Name: ReturnExpr020 :)
(: Description: "return" expression containing a typed value constructor function :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

for $file in ($input-context//Folder)[1]/File
return xs:string( data( $file/FileName[1] ))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'fsx'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/FLWORExpr/ReturnExpr/ReturnExpr020.txt')

! !

!XQTSReturnExprTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
