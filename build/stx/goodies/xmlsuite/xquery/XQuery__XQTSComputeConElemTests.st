"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSComputeConElemTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSComputeConElemTests methodsFor:'tests'!

test_Constr_compelem_adjtext_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-adjtext-3 :)
(: Written by: Andreas Behm :)
(: Description: merge adjacent atomic values to text node :)

count((element elem {1, "string", 1,2e3})/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-adjtext-1.txt')

!

test_Constr_compelem_adjtext_2

    | query result |

    query := ' 
        (: Name: Constr-compelem-adjtext-2 :)
(: Written by: Andreas Behm :)
(: Description: merge adjacent atomic values and text nodes to text node :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

count((element elem {1, $input-context//text(), "string"})/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-adjtext-2.txt')

!

test_Constr_compelem_adjtext_3

    | query result |

    query := ' 
        (: Name: Constr-compelem-adjtext-3 :)
(: Written by: Andreas Behm :)
(: Description: merge adjacent atomic values between other nodes to text node :)

count((element elem {1, 2, <a/>, 3, 4, <b/>, 5, 6})/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-adjtext-3.txt')

!

test_Constr_compelem_attr_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-attr-1 :)
(: Written by: Andreas Behm :)
(: Description: attribute node following atomic value :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {1, $input-context//west/@mark}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_attr_2

    | query result |

    query := ' 
        (: Name: Constr-compelem-attr-2 :)
(: Written by: Andreas Behm :)
(: Description: attribute node following node :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {element a {}, $input-context//west/@mark}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_attr_3

    | query result |

    query := ' 
        (: Name: Constr-compelem-attr-3 :)
(: Written by: Andreas Behm :)
(: Description: attributes in content :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {$input-context//west/@mark, $input-context//west/@west-attr-1}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-attr-3.xml')

!

test_Constr_compelem_attr_4

    | query result |

    query := ' 
        (: Name: Constr-compelem-attr-4 :)
(: Written by: Andreas Behm :)
(: Description: attribute in content with same name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {$input-context//west/@mark, $input-context//center/@mark}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_baseuri_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-baseuri-1 :)
(: Written by: Andreas Behm :)
(: Description: base-uri through xml:base attribute :)

fn:base-uri(element elem {attribute xml:base {"http://www.example.com"}})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-baseuri-1.txt')

!

test_Constr_compelem_baseuri_2

    | query result |

    query := ' 
        (: Name: Constr-compelem-baseuri-2 :)
(: Written by: Andreas Behm :)
(: Description: base-uri through parent :)

fn:base-uri((<elem xml:base="http://www.example.com">{element a {}}</elem>)/a)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-baseuri-2.txt')

!

test_Constr_compelem_baseuri_3

    | query result |

    query := ' 
        (: Name: Constr-compelem-baseuri-3 :)
(: Written by: Andreas Behm :)
(: Description: base-uri through declaration :)

declare base-uri "http://www.example.com";
fn:base-uri(element elem {})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-baseuri-3.txt')

!

test_Constr_compelem_compname_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-1 :)
(: Written by: Andreas Behm :)
(: Description: empty computed name :)

element {()} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_10

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-10 :)
(: Written by: Andreas Behm :)
(: Description: string as name :)

element {"elem"} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-compname-10.xml')

!

test_Constr_compelem_compname_11

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-11 :)
(: Written by: Andreas Behm :)
(: Description: string as name :)

element {"elem", ()} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-compname-11.xml')

!

test_Constr_compelem_compname_12

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-12 :)
(: Written by: Andreas Behm :)
(: Description: string as name :)

element {(), "elem"} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-compname-12.xml')

!

test_Constr_compelem_compname_13

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-13 :)
(: Written by: Andreas Behm :)
(: Description: string with prefix as name :)

<elem xmlns:foo="http://www.example.com/foo">{element {"foo:elem"} {"text"}}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-compname-13.xml')

!

test_Constr_compelem_compname_14

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-14 :)
(: Written by: Andreas Behm :)
(: Description: string with undeclared prefix as name :)

element {"foo:elem"} {}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_15

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-15 :)
(: Written by: Andreas Behm :)
(: Description: untyped atomic as name :)

element {xs:untypedAtomic("elem")} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-compname-15.xml')

!

test_Constr_compelem_compname_16

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-16 :)
(: Written by: Andreas Behm :)
(: Description: untyped atomic with prefix as name :)

<elem xmlns:foo="http://www.example.com/foo">{element {xs:untypedAtomic("foo:elem")} {"text"}}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-compname-16.xml')

!

test_Constr_compelem_compname_17

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-17 :)
(: Written by: Andreas Behm :)
(: Description: untyped atomic with undeclared prefix as name :)

element {xs:untypedAtomic("foo:elem")} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_18

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-18 :)
(: Written by: Andreas Behm :)
(: Description: non-ncname string as name :)

element {"el em"} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_19

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-19 :)
(: Written by: Andreas Behm :)
(: Description: non-ncname untyped atomic as name :)

element {xs:untypedAtomic("el em")} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_2

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-2 :)
(: Written by: Andreas Behm :)
(: Description: two strings as name :)

element {"one", "two"} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_3

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-3 :)
(: Written by: Andreas Behm :)
(: Description: two untypedAtomic values as name :)

element {xs:untypedAtomic("one"), xs:untypedAtomic("two")} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_4

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-4 :)
(: Written by: Andreas Behm :)
(: Description: content of two nodes as name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element {$input-context//a} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_5

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-5 :)
(: Written by: Andreas Behm :)
(: Description: two numeric values as name :)

element {1,2} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_6

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-6 :)
(: Written by: Andreas Behm :)
(: Description: numeric value as name :)

element {123} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_7

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-7 :)
(: Written by: Andreas Behm :)
(: Description: dataTime value as name :)

element {xs:dateTime("1999-05-31T13:20:00")} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_compname_8

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-8 :)
(: Written by: Andreas Behm :)
(: Description: NCName as name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element {$input-context//*:NCName} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-compname-8.xml')

!

test_Constr_compelem_compname_9

    | query result |

    query := ' 
        (: Name: Constr-compelem-compname-9 :)
(: Written by: Andreas Behm :)
(: Description: QName as name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element {xs:QName("aQname")} {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-compname-9.xml')

!

test_Constr_compelem_constrmod_3

    | query result |

    query := ' 
        (: Name: Constr-compelem-constrmod-3 :)
(: Written by: Andreas Behm :)
(: Description: strip decimal type :)

declare construction strip;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

(element elem {xs:decimal($input-context//decimal[1])}) cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomicns'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_constrmod_4

    | query result |

    query := ' 
        (: Name: Constr-compelem-constrmod-4 :)
(: Written by: Andreas Behm :)
(: Description: preserve decimal type :)

declare construction preserve;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

(element elem {xs:decimal($input-context//decimal[1])}) cast as xs:integer
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomicns'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-constrmod-4.txt')

!

test_Constr_compelem_constrmod_7

    | query result |

    query := ' 
        (: Name: Constr-compelem-constrmod-7 :)
(: Written by: Andreas Behm :)
(: Description: strip decimal type in attribute :)

declare construction strip;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

(element elem {$input-context//*:decimal/@*:attr})/@*:attr cast as xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomicns'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_constrmod_8

    | query result |

    query := ' 
        (: Name: Constr-compelem-constrmod-8 :)
(: Written by: Andreas Behm :)
(: Description: preserve decimal type in attribute :)

declare construction preserve;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

(element elem {xs:decimal($input-context//*:decimal[1]/@*:attr)}) cast as xs:integer


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomicns'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-constrmod-8.txt')

!

test_Constr_compelem_data_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-data-1 :)
(: Written by: Andreas Behm :)
(: Description: typed value of element :)

fn:data(element elem {"a", element a {}, "b"})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-data-1.txt')

!

test_Constr_compelem_doc_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-doc-1 :)
(: Written by: Andreas Behm :)
(: Description: strip document nodes :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {$input-context, $input-context}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-doc-1.xml')

!

test_Constr_compelem_enclexpr_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-enclexpr-1 :)
(: Written by: Andreas Behm :)
(: Description: empty computed element content :)

element elem {}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-enclexpr-1.xml')

!

test_Constr_compelem_enclexpr_2

    | query result |

    query := ' 
        (: Name: Constr-compelem-enclexpr-2 :)
(: Written by: Andreas Behm :)
(: Description: atomic values in computed element content :)

element elem {1,"a",3.5,4e2}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-enclexpr-2.xml')

!

test_Constr_compelem_enclexpr_3

    | query result |

    query := ' 
        (: Name: Constr-compelem-enclexpr-3 :)
(: Written by: Andreas Behm :)
(: Description: atomic values and nodes in computed element content :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {1,$input-context//a,2,3,$input-context//comment(),4,5,$input-context//processing-instruction(),6,7,$input-context//text(),8}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-enclexpr-3.xml')

!

test_Constr_compelem_enclexpr_4

    | query result |

    query := ' 
        (: Name: Constr-compelem-enclexpr-4 :)
(: Written by: Andreas Behm :)
(: Description: empty string in element content :)

element elem {1, "", 2}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-enclexpr-4.xml')

!

test_Constr_compelem_name_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-name-1 :)
(: Written by: Andreas Behm :)
(: Description: NCName for computed element constructor :)

element elem {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-name-1.xml')

!

test_Constr_compelem_name_2

    | query result |

    query := ' 
        (: Name: Constr-compelem-name-2 :)
(: Written by: Andreas Behm :)
(: Description: QName for computed element constructor :)

declare namespace foo="http://www.example.com/foo";
element foo:elem {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-name-2.xml')

!

test_Constr_compelem_name_3

    | query result |

    query := ' 
        (: Name: Constr-compelem-name-3 :)
(: Written by: Andreas Behm :)
(: Description: QName with undeclared prefix for computed element constructor :)

element foo:elem {"text"}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_compelem_nested_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-nested-1 :)
(: Written by: Andreas Behm :)
(: Description: nested computed element constructors :)

element elem {1, element a {2, element b {element c {}, element d {3}}, 4}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-nested-1.xml')

!

test_Constr_compelem_nested_2

    | query result |

    query := ' 
        (: Name: Constr-compelem-nested-2 :)
(: Written by: Andreas Behm :)
(: Description: copy node tree into computed element constructor :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

element elem {}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-nested-2.xml')

!

test_Constr_compelem_nodeid_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-nodeid-1 :)
(: Written by: Andreas Behm :)
(: Description: Copied element node has new node identity :)

for $x in <a/>,
    $y in element elem {$x}
return $y/a is $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-nodeid-1.txt')

!

test_Constr_compelem_nodeid_2

    | query result |

    query := ' 
        (: Name: Constr-compelem-nodeid-2 :)
(: Written by: Andreas Behm :)
(: Description: Copied attribute node has new node identity :)

for $x in <a b="b"/>,
    $y in element elem {$x/@b}
return $y/@b is $x/@b

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-nodeid-2.txt')

!

test_Constr_compelem_nodeid_4

    | query result |

    query := ' 
        (: Name: Constr-compelem-nodeid-4 :)
(: Written by: Andreas Behm :)
(: Description: Copied pi node has new node identity :)

for $x in <?pi content?>,
    $y in element elem {$x}
return $y/processing-instruction() is $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-nodeid-4.txt')

!

test_Constr_compelem_nodeid_5

    | query result |

    query := ' 
        (: Name: Constr-compelem-nodeid-5 :)
(: Written by: Andreas Behm :)
(: Description: Copied text node has new node identity :)

for $x in <a>text</a>,
    $y in element elem {$x/text()}
return $y/text() is $x/text()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-nodeid-5.txt')

!

test_Constr_compelem_parent_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-parent-1 :)
(: Written by: Andreas Behm :)
(: Description: empty parent :)

count((element elem {})/..)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-parent-1.txt')

!

test_Constr_compelem_string_1

    | query result |

    query := ' 
        (: Name: Constr-compelem-string-1 :)
(: Written by: Andreas Behm :)
(: Description: string value of element :)

fn:string(element elem {"a", element a {}, "b"})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ComputeConElem/Constr-compelem-string-1.txt')

! !

!XQTSComputeConElemTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
