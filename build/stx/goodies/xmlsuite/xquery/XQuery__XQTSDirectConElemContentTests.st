"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSDirectConElemContentTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSDirectConElemContentTests methodsFor:'tests'!

test_Constr_cont_adjtext_1

    | query result |

    query := ' 
        (: Name: Constr-cont-adjtext-1 :)
(: Written by: Andreas Behm :)
(: Description: single text node in element content :)

count((<elem>a{1,2,3}b</elem>)/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-adjtext-1.txt')

!

test_Constr_cont_adjtext_2

    | query result |

    query := ' 
        (: Name: Constr-cont-adjtext-2 :)
(: Written by: Andreas Behm :)
(: Description: two text nodes in element content :)

count((<elem>a{1,<a/>,3}b</elem>)/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-adjtext-2.txt')

!

test_Constr_cont_adjtext_3

    | query result |

    query := ' 
        (: Name: Constr-cont-adjtext-3 :)
(: Written by: Andreas Behm :)
(: Description: strip empty text node :)

count((<elem>{""}</elem>)/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-adjtext-3.txt')

!

test_Constr_cont_adjtext_4

    | query result |

    query := ' 
        (: Name: Constr-cont-adjtext-4 :)
(: Written by: Andreas Behm :)
(: Description: no text node for empty sequence constructed :)

count((<elem>{()}</elem>)/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-adjtext-4.txt')

!

test_Constr_cont_attr_1

    | query result |

    query := ' 
        (: Name: Constr-cont-attr-1 :)
(: Written by: Andreas Behm :)
(: Description: attribute node following atomic value :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{1, $input-context//west/@mark}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_attr_2

    | query result |

    query := ' 
        (: Name: Constr-cont-attr-2 :)
(: Written by: Andreas Behm :)
(: Description: attribute node following node :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem><a/>{$input-context//west/@mark}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_attr_3

    | query result |

    query := ' 
        (: Name: Constr-cont-attr-3 :)
(: Written by: Andreas Behm :)
(: Description: attribute node following empty sequence :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{()}{$input-context//west/@mark}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-attr-3.xml')

!

test_Constr_cont_attr_4

    | query result |

    query := ' 
        (: Name: Constr-cont-attr-4 :)
(: Written by: Andreas Behm :)
(: Description: attribute node following direct content :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{$input-context//west/@mark}x{$input-context//west/@west-attr-1}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_attr_5

    | query result |

    query := ' 
        (: Name: Constr-cont-attr-5 :)
(: Written by: Andreas Behm :)
(: Description: attributes in content :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{$input-context//west/@mark, $input-context//west/@west-attr-1}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-attr-5.xml')

!

test_Constr_cont_attr_6

    | query result |

    query := ' 
        (: Name: Constr-cont-attr-6 :)
(: Written by: Andreas Behm :)
(: Description: attributes direct and in content :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem mark="w0">{$input-context//west/@west-attr-1, $input-context//west/@west-attr-2}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-attr-6.xml')

!

test_Constr_cont_attr_7

    | query result |

    query := ' 
        (: Name: Constr-cont-attr-7 :)
(: Written by: Andreas Behm :)
(: Description: attribute in content with same name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{$input-context//west/@mark, $input-context//center/@mark}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_attr_8

    | query result |

    query := ' 
        (: Name: Constr-cont-attr-8 :)
(: Written by: Andreas Behm :)
(: Description: attributes direct and in content with same name :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem mark="w0">{$input-context//west/@west-attr-1, $input-context//west/@mark}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TopMany'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_baseuri_1

    | query result |

    query := ' 
        (: Name: Constr-cont-baseuri-1 :)
(: Written by: Andreas Behm :)
(: Description: base-uri through xml:base attribute :)

fn:base-uri(<elem xml:base="http://www.example.com"/>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-baseuri-1.txt')

!

test_Constr_cont_baseuri_2

    | query result |

    query := ' 
        (: Name: Constr-cont-baseuri-2 :)
(: Written by: Andreas Behm :)
(: Description: base-uri through parent :)

fn:base-uri((<elem xml:base="http://www.example.com"><a/></elem>)/a)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-baseuri-2.txt')

!

test_Constr_cont_baseuri_3

    | query result |

    query := ' 
        (: Name: Constr-cont-baseuri-3 :)
(: Written by: Andreas Behm :)
(: Description: base-uri through declaration :)

declare base-uri "http://www.example.com";
fn:base-uri(<elem/>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-baseuri-3.txt')

!

test_Constr_cont_charref_1

    | query result |

    query := ' 
        (: Name: Constr-cont-charref-1 :)
(: Written by: Andreas Behm :)
(: Description: character reference :)

<elem>&#x30;</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-charref-1.xml')

!

test_Constr_cont_charref_2

    | query result |

    query := ' 
        (: Name: Constr-cont-charref-2 :)
(: Written by: Andreas Behm :)
(: Description: invalid character reference :)

<elem>&#x0;</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_constrmod_1

    | query result |

    query := ' 
        (: Name: Constr-cont-constrmod-1 :)
(: Written by: Andreas Behm :)
(: Description: strip IDREFS type :)

declare construction strip;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

fn:count(fn:data(<elem>{$input-context//*:idrefs}</elem>/*))

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-constrmod-1.txt')

!

test_Constr_cont_constrmod_2

    | query result |

    query := ' 
        (: Name: Constr-cont-constrmod-2 :)
(: Written by: Andreas Behm :)
(: Description: preserve IDREFS type :)

declare construction preserve;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

fn:count(fn:data(<elem>{$input-context//*:idrefs}</elem>/*))

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-constrmod-2.txt')

!

test_Constr_cont_constrmod_3

    | query result |

    query := ' 
        (: Name: Constr-cont-constrmod-3 :)
(: Written by: Andreas Behm :)
(: Description: strip decimal type :)

declare construction strip;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{$input-context//*:decimal}</elem>/* cast as xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_constrmod_4

    | query result |

    query := ' 
        (: Name: Constr-cont-constrmod-4 :)
(: Written by: Andreas Behm :)
(: Description: preserve decimal type :)

declare construction preserve;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{$input-context//*:decimal}</elem>/* cast as xs:integer


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-constrmod-4.txt')

!

test_Constr_cont_constrmod_5

    | query result |

    query := ' 
        (: Name: Constr-cont-constrmod-5 :)
(: Written by: Andreas Behm :)
(: Description: strip IDREFS type in attribute :)

declare construction strip;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

fn:count(fn:data((<elem>{$input-context//*:idrefs/@*:attr}</elem>)/@*:attr))

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-constrmod-5.txt')

!

test_Constr_cont_constrmod_6

    | query result |

    query := ' 
        (: Name: Constr-cont-constrmod-6 :)
(: Written by: Andreas Behm :)
(: Description: preserve IDREFS type in attribute :)

declare construction preserve;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

fn:count(fn:data((<elem>{$input-context//*:idrefs/@*:attr}</elem>)/@*:attr))

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-constrmod-6.txt')

!

test_Constr_cont_constrmod_7

    | query result |

    query := ' 
        (: Name: Constr-cont-constrmod-7 :)
(: Written by: Andreas Behm :)
(: Description: strip decimal type in attribute :)

declare construction strip;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

(<elem>{$input-context//*:decimal/@*:attr}</elem>)/@*:attr cast as xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_constrmod_8

    | query result |

    query := ' 
        (: Name: Constr-cont-constrmod-8 :)
(: Written by: Andreas Behm :)
(: Description: preserve decimal type in attribute :)

declare construction preserve;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

(<elem>{$input-context//*:decimal/@*:attr}</elem>)/@*:attr cast as xs:integer


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-constrmod-8.txt')

!

test_Constr_cont_data_1

    | query result |

    query := ' 
        (: Name: Constr-cont- :)
(: Written by: Andreas Behm :)
(: Description: typed value of element :)

fn:data(<elem>a<a/>b</elem>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-data-1.txt')

!

test_Constr_cont_doc_1

    | query result |

    query := ' 
        (: Name: Constr-cont-doc-1 :)
(: Written by: Andreas Behm :)
(: Description: strip document nodes :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{$input-context, $input-context}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-doc-1.xml')

!

test_Constr_cont_document_1

    | query result |

    query := ' 
        (: Name: Constr-cont-document-1 :)
(: Written by: Andrew Eisenberg :)
(: Description: Check the merging of text nodes introduced by the contents of a document node :)
(: This test case was motivated by the resolution of Bug Report 3637 :)

count(<wrapper> {"abc", document {"def", <anode/>, "ghi"}, "jkl"} </wrapper>/node())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-document-1.txt')

!

test_Constr_cont_document_2

    | query result |

    query := ' 
        (: Name: Constr-cont-document-2 :)
(: Written by: Andrew Eisenberg :)
(: Description: Check the merging of text nodes introduced by the contents of a document node :)
(: This test case was motivated by the resolution of Bug Report 3637 :)

count(<wrapper>  abc {document {"def", <anode/>, "ghi"}} jkl </wrapper>/node())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-document-2.txt')

!

test_Constr_cont_enclexpr_1

    | query result |

    query := ' 
        (: Name: Constr-cont-enclexpr-1 :)
(: Written by: Andreas Behm :)
(: Description: 1 text node for enclosed expression with atomic values :)

count((<elem>{1,"a",3.5,4e2}</elem>)/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-enclexpr-1.txt')

!

test_Constr_cont_enclexpr_2

    | query result |

    query := ' 
        (: Name: Constr-cont-enclexpr-2 :)
(: Written by: Andreas Behm :)
(: Description: 1 text node for enclosed expression with atomic values :)

count((<elem>{1,"a",<a/>,3.5,4e2}</elem>)/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-enclexpr-2.txt')

!

test_Constr_cont_enclexpr_3

    | query result |

    query := ' 
        (: Name: Constr-cont-enclexpr-3 :)
(: Written by: Andreas Behm :)
(: Description: space between atomic values in enclosed expression :)

<elem>{1,"a",3.5,4e2}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-enclexpr-3.xml')

!

test_Constr_cont_enclexpr_4

    | query result |

    query := ' 
        (: Name: Constr-cont-enclexpr-4 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression with mix of atomic values and nodes :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{1,$input-context//a,2,3,$input-context//comment(),4,5,$input-context//processing-instruction(),6,7,$input-context//text(),8}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-enclexpr-4.xml')

!

test_Constr_cont_enclexpr_5

    | query result |

    query := ' 
        (: Name: Constr-cont-enclexpr-5 :)
(: Written by: Andreas Behm :)
(: Description: space between atomic values and empty string :)

<elem>{1, "", 2}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-enclexpr-5.xml')

!

test_Constr_cont_entref_1

    | query result |

    query := ' 
        (: Name: Constr-cont-entref-1 :)
(: Written by: Andreas Behm :)
(: Description: Pre-defined entity reference in element content :)

string-to-codepoints(<elem>&lt;</elem>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-entref-1.txt')

!

test_Constr_cont_entref_2

    | query result |

    query := ' 
        (: Name: Constr-cont-entref-2 :)
(: Written by: Andreas Behm :)
(: Description: Pre-defined entity reference in element content :)

string-to-codepoints(<elem>&gt;</elem>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-entref-2.txt')

!

test_Constr_cont_entref_3

    | query result |

    query := ' 
        (: Name: Constr-cont-entref-3 :)
(: Written by: Andreas Behm :)
(: Description: Pre-defined entity reference in element content :)

string-to-codepoints(<elem>&amp;</elem>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-entref-3.txt')

!

test_Constr_cont_entref_4

    | query result |

    query := ' 
        (: Name: Constr-cont-entref-4 :)
(: Written by: Andreas Behm :)
(: Description: Pre-defined entity reference in element content :)

string-to-codepoints(<elem>&quot;</elem>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-entref-4.txt')

!

test_Constr_cont_entref_5

    | query result |

    query := ' 
        (: Name: Constr-cont-entref-5 :)
(: Written by: Andreas Behm :)
(: Description: Pre-defined entity reference in element content :)

string-to-codepoints(<elem>&apos;</elem>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-entref-5.txt')

!

test_Constr_cont_eol_1

    | query result |

    query := ' 
        (: Name: Constr-cont-eol-1 :)
(: Written by: Andreas Behm :)
(: Description: end-of-line handling :)

<codepoints>{string-to-codepoints(<elem>1
2</elem>)}</codepoints>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-eol-1.xml')

!

test_Constr_cont_eol_2

    | query result |

    query := ' 
        (: Name: Constr-cont-eol-2 :)
(: Written by: Andreas Behm :)
(: Description: end-of-line handling :)

<codepoints>{string-to-codepoints(<elem>1
2</elem>) }</codepoints>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-eol-2.xml')

!

test_Constr_cont_eol_3

    | query result |

    query := ' 
        (: Name: Constr-cont-eol-3 :)
(: Written by: Andreas Behm :)
(: Description: end-of-line handling with character reference :)

<codepoints>{string-to-codepoints(<elem>&#xD;&#xA;</elem>)}</codepoints>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-eol-3.xml')

!

test_Constr_cont_eol_4

    | query result |

    query := ' 
        (: Name: Constr-cont-eol-4 :)
(: Written by: Andreas Behm :)
(: Description: end-of-line handling with character reference :)

<codepoints>{string-to-codepoints(<elem>&#xD;</elem>)}</codepoints>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-eol-4.xml')

!

test_Constr_cont_invalid_1

    | query result |

    query := ' 
        (: Name: Constr-cont-invalid-1 :)
(: Written by: Andreas Behm :)
(: Description: invalid character "{" in element content :)

<elem>{</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_invalid_2

    | query result |

    query := ' 
        (: Name: Constr-cont-invalid-2 :)
(: Written by: Andreas Behm :)
(: Description: invalid character "}" in element content :)

<elem>}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_invalid_3

    | query result |

    query := ' 
        (: Name: Constr-cont-invalid-3 :)
(: Written by: Andreas Behm :)
(: Description: invalid character "&lt;" in element content :)

<elem><</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_invalid_4

    | query result |

    query := ' 
        (: Name: Constr-cont-invalid-4 :)
(: Written by: Andreas Behm :)
(: Description: invalid character "&amp;" in element content :)

<elem>&</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_cont_nested_1

    | query result |

    query := ' 
        (: Name: Constr-cont-nested-1 :)
(: Written by: Andreas Behm :)
(: Description: nested element nodes :)

<elem><a><b/></a><a/><c/></elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nested-1.xml')

!

test_Constr_cont_nested_2

    | query result |

    query := ' 
        (: Name: Constr-cont-nested-2 :)
(: Written by: Andreas Behm :)
(: Description: nested pi nodes :)

<elem><?pi?><?pi content?></elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nested-2.xml')

!

test_Constr_cont_nested_5

    | query result |

    query := ' 
        (: Name: Constr-cont-nested-5 :)
(: Written by: Andreas Behm :)
(: Description: Copied node structure in element content :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<elem>{$input-context/root}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nested-5.xml')

!

test_Constr_cont_nodeid_1

    | query result |

    query := ' 
        (: Name: Constr-cont-nodeid-1 :)
(: Written by: Andreas Behm :)
(: Description: Copied element node has new node identity :)

for $x in <a/>,
    $y in <elem>{$x}</elem>
return $y/a is $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nodeid-1.txt')

!

test_Constr_cont_nodeid_2

    | query result |

    query := ' 
        (: Name: Constr-cont-nodeid-2 :)
(: Written by: Andreas Behm :)
(: Description: Copied attribute node has new node identity :)

for $x in <a b="b"/>,
    $y in <elem>{$x/@b}</elem>
return $y/@b is $x/@b

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nodeid-2.txt')

!

test_Constr_cont_nodeid_4

    | query result |

    query := ' 
        (: Name: Constr-cont- nodeid-4 :)
(: Written by: Andreas Behm :)
(: Description: Copied pi node has new node identity :)

for $x in <?pi content?>,
    $y in <elem>{$x}</elem>
return $y/processing-instruction() is $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nodeid-4.txt')

!

test_Constr_cont_nodeid_5

    | query result |

    query := ' 
        (: Name: Constr-cont-nodeid-5 :)
(: Written by: Andreas Behm :)
(: Description: Copied text node has new node identity :)

for $x in <a>text</a>,
    $y in <elem>{$x/text()}</elem>
return $y/text() is $x/text()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nodeid-5.txt')

!

test_Constr_cont_nsmode_1

    | query result |

    query := ' 
        (: Name: Constr-cont-nsmode-1 :)
(: Written by: Andreas Behm :)
(: Description: Copy-namespace mode preserve, inherit :)

declare copy-namespaces preserve, inherit;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<y xmlns:inherit="inherit">{$input-context}</y>/x/z

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'nsmode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nsmode-1.xml')

!

test_Constr_cont_nsmode_2

    | query result |

    query := ' 
        (: Name: Constr-cont-nsmode-2 :)
(: Written by: Andreas Behm :)
(: Description: Copy-namespace mode no-preserve, inherit :)

declare copy-namespaces no-preserve, inherit;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<y xmlns:inherit="inherit">{$input-context}</y>/x/z

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'nsmode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nsmode-2.xml')

!

test_Constr_cont_nsmode_3

    | query result |

    query := ' 
        (: Name: Constr-cont-nsmode-3 :)
(: Written by: Andreas Behm :)
(: Description: Copy-namespace mode preserve, no-inherit :)

declare copy-namespaces preserve, no-inherit;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<y xmlns:inherit="inherit">{$input-context}</y>/x/z

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'nsmode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nsmode-3.xml')

!

test_Constr_cont_nsmode_4

    | query result |

    query := ' 
        (: Name: Constr-cont-nsmode-4 :)
(: Written by: Andreas Behm :)
(: Description: Copy-namespace mode no-preserve, no-inherit :)

declare copy-namespaces no-preserve, no-inherit;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<y xmlns:inherit="inherit">{$input-context}</y>/x/z

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'nsmode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nsmode-4.xml')

!

test_Constr_cont_nsmode_5

    | query result |

    query := ' 
        (: Name: Constr-cont-nsmode-5 :)
(: Written by: Andreas Behm :)
(: Description: Copy namespace sensitive content :)

declare copy-namespaces no-preserve, inherit;
declare construction preserve;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<new>{ $input-context//*:QName }</new>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nsmode-5.txt')

!

test_Constr_cont_nsmode_6

    | query result |

    query := ' 
        (: Name: Constr-cont-nsmode-6 :)
(: Written by: Andreas Behm :)
(: Description: Copy namespace sensitive content :)

declare copy-namespaces no-preserve, no-inherit;
declare construction preserve;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

<new>{ $input-context//*:QName }</new>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-nsmode-6.txt')

!

test_Constr_cont_parent_1

    | query result |

    query := ' 
        (: Name: Constr-cont-parent-1 :)
(: Written by: Andreas Behm :)
(: Description: empty parent :)

count((<elem/>)/..)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-parent-1.txt')

!

test_Constr_cont_string_1

    | query result |

    query := ' 
        (: Name: Constr-cont- :)
(: Written by: Andreas Behm :)
(: Description: string value of element :)

fn:string(<elem>a<a/>b</elem>)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-string-1.txt')

!

test_Constr_cont_text_1

    | query result |

    query := ' 
        (: Name: Constr-cont-text-1 :)
(: Written by: Andreas Behm :)
(: Description: count text nodes for direct element content :)

count((<elem>text</elem>)/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-text-1.txt')

!

test_Constr_cont_uripres_1

    | query result |

    query := ' 
        (: Name: Constr-cont-uripres1 :)
(: Written by: Andreas Behm :)
(: Description: Preserve base uri for copied element nodes :)

for $x in <a xml:base="http://www.example.com/base1"><b/></a>,
    $y in <a xml:base="http://www.example.com/base2">{$x/b}</a>
return fn:base-uri($y/b)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/Constr-cont-uripres-1.txt')

!

test_K2_DirectConElemContent_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemContent-1                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Test that the typed value of element nodes is correct. :)
(:*******************************************************:)
data(<name>some text</name>) instance of xs:untypedAtomic
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/K2-DirectConElemContent-1.txt')

!

test_K2_DirectConElemContent_10

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemContent-10                      :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Test that the typed value of PI nodes is correct. :)
(:*******************************************************:)
data(<?target content?>) instance of xs:string
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/K2-DirectConElemContent-10.txt')

!

test_K2_DirectConElemContent_11

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemContent-11                      :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Test that the typed value of PI nodes is correct. :)
(:*******************************************************:)
not(data(<?target content?>) instance of xs:untypedAtomic)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/K2-DirectConElemContent-11.txt')

!

test_K2_DirectConElemContent_12

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemContent-12                      :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Test that the typed value of PI nodes is correct. :)
(:*******************************************************:)
<?target content?> instance of processing-instruction()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/K2-DirectConElemContent-12.txt')

!

test_K2_DirectConElemContent_13

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemContent-13                      :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Test that the typed value of PI nodes is correct. :)
(:*******************************************************:)
not(<?target content?> instance of xs:untypedAtomic)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/K2-DirectConElemContent-13.txt')

!

test_K2_DirectConElemContent_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemContent-2                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Test that the typed value of element nodes is correct. :)
(:*******************************************************:)
not(data(<name>some text</name>) instance of xs:string)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/K2-DirectConElemContent-2.txt')

!

test_K2_DirectConElemContent_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemContent-3                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Test that the typed value of element nodes is correct. :)
(:*******************************************************:)
<name>some, if(1) then else</name> instance of element()
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/K2-DirectConElemContent-3.txt')

!

test_K2_DirectConElemContent_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemContent-4                       :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Test that the typed of element nodes is correct. :)
(:*******************************************************:)
not(<name>some text</name> instance of xs:untypedAtomic)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemContent/K2-DirectConElemContent-4.txt')

! !

!XQTSDirectConElemContentTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
