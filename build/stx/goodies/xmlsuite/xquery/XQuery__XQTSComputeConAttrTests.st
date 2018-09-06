"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSComputeConAttrTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSComputeConAttrTests methodsFor:'tests'!

test_Constr_compattr_compname_1

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-1 :)
(: Written by: Andreas Behm :)
(: Description: empty computed name :)

element elem {attribute {()} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_10

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-10 :)
(: Written by: Andreas Behm :)
(: Description: string as name :)

element elem {attribute {"attr"} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-compname-10.xml')

!

test_Constr_compattr_compname_11

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-11 :)
(: Written by: Andreas Behm :)
(: Description: string as name :)

element elem {attribute {"attr", ()} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-compname-11.xml')

!

test_Constr_compattr_compname_12

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-12 :)
(: Written by: Andreas Behm :)
(: Description: string as name :)

element elem {attribute {(), "attr"} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-compname-12.xml')

!

test_Constr_compattr_compname_13

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-13 :)
(: Written by: Andreas Behm :)
(: Description: string with prefix as name :)

<elem xmlns:foo="http://www.example.com/foo">{element elem {attribute {"foo:attr"} {}}}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-compname-13.xml')

!

test_Constr_compattr_compname_14

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-14 :)
(: Written by: Andreas Behm :)
(: Description: string with undeclared prefix as name :)

element elem {attribute {"foo:attr"} {}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_15

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-15 :)
(: Written by: Andreas Behm :)
(: Description: untyped atomic as name :)

element elem {attribute {xs:untypedAtomic("attr")} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-compname-15.xml')

!

test_Constr_compattr_compname_16

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-16 :)
(: Written by: Andreas Behm :)
(: Description: untyped atomic with prefix as name :)

<elem xmlns:foo="http://www.example.com/foo">{attribute {xs:untypedAtomic("foo:attr")} {"text"}}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-compname-16.xml')

!

test_Constr_compattr_compname_17

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-17 :)
(: Written by: Andreas Behm :)
(: Description: untyped atomic with undeclared prefix as name :)

element elem {attribute {xs:untypedAtomic("foo:elem")} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_18

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-18 :)
(: Written by: Andreas Behm :)
(: Description: non-ncname string as name :)

element elem {attribute {"el em"} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_19

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-19 :)
(: Written by: Andreas Behm :)
(: Description: non-ncname untyped atomic as name :)

element elem {attribute {xs:untypedAtomic("el em")} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_2

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-2 :)
(: Written by: Andreas Behm :)
(: Description: two strings as name :)

element elem {attribute {"one", "two"} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_3

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-3 :)
(: Written by: Andreas Behm :)
(: Description: two untypedAtomic values as name :)

element elem {attribute {xs:untypedAtomic("one"), xs:untypedAtomic("two")} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_4

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-4 :)
(: Written by: Andreas Behm :)
(: Description: content of two nodes as name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {attribute {$input-context//a} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_5

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-5 :)
(: Written by: Andreas Behm :)
(: Description: two numeric values as name :)

element elem {attribute {1,2} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_6

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-6 :)
(: Written by: Andreas Behm :)
(: Description: numeric value as name :)

element elem {attribute {123} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_7

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-7 :)
(: Written by: Andreas Behm :)
(: Description: dataTime value as name :)

element elem {attribute {xs:dateTime("1999-05-31T13:20:00")} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_compname_8

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-8 :)
(: Written by: Andreas Behm :)
(: Description: NCName as name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {attribute {$input-context//*:NCName} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-compname-8.xml')

!

test_Constr_compattr_compname_9

    | query result |

    query := ' 
        (: Name: Constr-compattr-compname-9 :)
(: Written by: Andreas Behm :)
(: Description: QName as name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {attribute {xs:QName("aQname")} {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-compname-9.xml')

!

test_Constr_compattr_data_1

    | query result |

    query := ' 
        (: Name: Constr-compattr-data-1 :)
(: Written by: Andreas Behm :)
(: Description: typed value of element :)

fn:data(attribute attr {"a", element a {}, "b"})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-data-1.txt')

!

test_Constr_compattr_doc_1

    | query result |

    query := ' 
        (: Name: Constr-compattr-doc-1 :)
(: Written by: Andreas Behm :)
(: Description: strip document nodes :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {attribute attr {$input-context, $input-context}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-doc-1.xml')

!

test_Constr_compattr_enclexpr_1

    | query result |

    query := ' 
        (: Name: Constr-compattr-enclexpr-1 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - atomic values :)

element elem {attribute attr {1,"string",3.14,xs:float("1.2345e-2"),xs:dateTime("2002-04-02T12:00:00-01:00")}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-enclexpr-1.xml')

!

test_Constr_compattr_enclexpr_2

    | query result |

    query := ' 
        (: Name: Constr-compattr-enclexpr-2 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - nodes :)

element elem {attribute attr {<elem>123</elem>, (<elem attr="456"/>)/@attr, (<elem>789</elem>)/text()}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-enclexpr-2.xml')

!

test_Constr_compattr_enclexpr_3

    | query result |

    query := ' 
        (: Name: Constr-compattr-enclexpr-3 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - empty string :)

element elem {attribute attr {1,"",2}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-enclexpr-3.xml')

!

test_Constr_compattr_enclexpr_4

    | query result |

    query := ' 
        (: Name: Constr-compattr-enclexpr-4 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - empty node :)

element elem {attribute attr {1,<a/>,2}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-enclexpr-4.xml')

!

test_Constr_compattr_id_1

    | query result |

    query := ' 
        (: Name: Constr-compattr-id-1 :)
(: Written by: Andreas Behm :)
(: Description: attribute xml:id - content is ncname :)

element elem {attribute xml:id {"ncname"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-id-1.xml')

!

test_Constr_compattr_id_2

    | query result |

    query := ' 
        (: Name: Constr-compattr-id 2 :)
(: Written by: Andreas Behm :)
(: Description: attribute xml:id - content is to be further normalized :)

element elem {attribute xml:id {"    ab    c


d       "}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-id-2.xml')

!

test_Constr_compattr_name_1

    | query result |

    query := ' 
        (: Name: Constr-compattr-name-1 :)
(: Written by: Andreas Behm :)
(: Description: NCName for computed attribute constructor :)

element elem {attribute attr {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-name-1.xml')

!

test_Constr_compattr_name_2

    | query result |

    query := ' 
        (: Name: Constr-compattr-name-2 :)
(: Written by: Andreas Behm :)
(: Description: QName for computed attribute constructor :)

declare namespace foo="http://www.example.com/foo";
element elem {attribute foo:attr {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-name-2.xml')

!

test_Constr_compattr_name_3

    | query result |

    query := ' 
        (: Name: Constr-compelem-name-3 :)
(: Written by: Andreas Behm :)
(: Description: QName with undeclared prefix for computed attribute constructor :)

element elem {attribute foo:attr {"text"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compattr_parent_1

    | query result |

    query := ' 
        (: Name: Constr-compattr-parent-1 :)
(: Written by: Andreas Behm :)
(: Description: empty parent :)

count((attribute attr {})/..)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-parent-1.txt')

!

test_Constr_compattr_string_1

    | query result |

    query := ' 
        (: Name: Constr-compattr-string-1 :)
(: Written by: Andreas Behm :)
(: Description: string value of attribute :)

fn:string(attribute attr {"a", element a {}, "b"})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConAttr/Constr-compattr-string-1.txt')

!

test_constattrerr_1

    | query result |

    query := ' 
        (: Name: constattrerr-1 :)
(: Description: Evaluation of constructor function xs:QName for which the argument is not a literal.:)

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

attribute xmlns {}

      
'.

    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
! !

!XQTSComputeConAttrTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
