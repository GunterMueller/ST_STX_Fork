"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSDirectConElemAttrTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSDirectConElemAttrTests methodsFor:'tests'!

test_Constr_attr_charref_1

    | query result |

    query := ' 
        (: Name: Constr-attr-charref-1 :)
(: Written by: Andreas Behm :)
(: Description: character references in attribute content :)

<elem attr="&#x30;&#x31;&#x32;"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-charref-1.xml')

!

test_Constr_attr_content_2

    | query result |

    query := ' 
        (: Name: Constr-attr-content-2 :)
(: Written by: Andreas Behm :)
(: Description: Illegal attribute content "{" :)

<elem attr="{"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_attr_content_3

    | query result |

    query := ' 
        (: Name: Constr-attr-content-3 :)
(: Written by: Andreas Behm :)
(: Description: Illegal attribute content "}" :)

<elem attr="}"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_attr_content_4

    | query result |

    query := ' 
        (: Name: Constr-attr-content-4 :)
(: Written by: Andreas Behm :)
(: Description: Illegal attribute content "<" :)

<elem attr="<"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_attr_content_5

    | query result |

    query := ' 
        (: Name: Constr-attr-content-5 :)
(: Written by: Andreas Behm :)
(: Description: Illegal attribute content "&" :)

<elem attr="&"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_attr_distnames_1

    | query result |

    query := ' 
        (: Name: Constr-attr-distnames-1 :)
(: Written by: Andreas Behm :)
(: Description: attributes with identical local names :)

<elem attr="val1" attr="val2" attr2="val3"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_attr_distnames_2

    | query result |

    query := ' 
        (: Name: Constr-attr-distnames-2 :)
(: Written by: Andreas Behm :)
(: Description: attributes with identical local names :)

<elem attr="val1" attr2="val2" attr="val3"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_attr_distnames_3

    | query result |

    query := ' 
        (: Name: Constr-attr-distnames-3 :)
(: Written by: Andreas Behm :)
(: Description: attributes with identical local names :)

<elem attr1="val1" attr="val2" attr2="val3" attr="val4" attr3="val5"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_attr_distnames_4

    | query result |

    query := ' 
        (: Name: Constr-attr-distnames-4 :)
(: Written by: Andreas Behm :)
(: Description: attributes with identical local name and URI :)

<elem xmlns:foo="http://www.w3.org/XQueryTest/Construct" xmlns:bar="http://www.w3.org/XQueryTest/Construct" foo:attr="val1" bar:attr="val2"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_attr_enclexpr_1

    | query result |

    query := ' 
        (: Name: Constr-attr-enclexpr-1 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - atomic values :)

<elem attr="{1,"string",3.14,xs:float("1.2345e-2"),xs:dateTime("2002-04-02T12:00:00-01:00")}"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-enclexpr-1.xml')

!

test_Constr_attr_enclexpr_2

    | query result |

    query := ' 
        (: Name: Constr-attr-enclexpr-2 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - nodes :)

<elem attr="{<elem>123</elem>, (<elem attr="456"/>)/@attr, (<elem>789</elem>)/text()}"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-enclexpr-2.xml')

!

test_Constr_attr_enclexpr_3

    | query result |

    query := ' 
        (: Name: Constr-attr-enclexpr-3 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - empty string :)

<elem attr="{1,"",2}"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-enclexpr-3.xml')

!

test_Constr_attr_enclexpr_4

    | query result |

    query := ' 
        (: Name: Constr-attr-enclexpr-4 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - empty node :)

<elem attr="{1,<a/>,2}"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-enclexpr-4.xml')

!

test_Constr_attr_enclexpr_5

    | query result |

    query := ' 
        (: Name: Constr-attr-enclexpr-5 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - mix direct content and enclosed expressions :)

<elem attr="123{456}"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-enclexpr-5.xml')

!

test_Constr_attr_enclexpr_6

    | query result |

    query := ' 
        (: Name: Constr-attr-enclexpr-6 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - mix direct content and enclosed expressions :)

<elem attr="{123}456"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-enclexpr-6.xml')

!

test_Constr_attr_enclexpr_7

    | query result |

    query := ' 
        (: Name: Constr-attr-enclexpr-7 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in attribute content - mix direct content and enclosed expressions :)

<elem attr="1{2,3}{4,5}6{<a>7</a>}{<a>8</a>}9"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-enclexpr-7.xml')

!

test_Constr_attr_entref_1

    | query result |

    query := ' 
        (: Name: Constr-attr-entref-1 :)
(: Written by: Andreas Behm :)
(: Description: entity references in attribute content :)

<elem attr="&amp;&lt;&gt;"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-entref-1.xml')

!

test_Constr_attr_entref_2

    | query result |

    query := ' 
        (: Name: Constr-attr-entref-2 :)
(: Written by: Andreas Behm :)
(: Description: entity references in attribute content :)

fn:string-length(string((<elem attr="&amp;&lt;&gt;"/>)/@attr))
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-entref-2.txt')

!

test_Constr_attr_id_1

    | query result |

    query := ' 
        (: Name: Constr-attr-id-1 :)
(: Written by: Andreas Behm :)
(: Description: attribute xml:id - content is ncname :)

<elem xml:id="ncname"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-id-1.xml')

!

test_Constr_attr_id_2

    | query result |

    query := ' 
        (: Name: Constr-attr-id 2 :)
(: Written by: Andreas Behm :)
(: Description: attribute xml:id - content is to be further normalized :)

<elem xml:id="    a{"b    c


d","        "}"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-id-2.xml')

!

test_Constr_attr_nsdecl_1

    | query result |

    query := ' 
        (: Name: Constr-attr-nsdecl-1 :)
(: Written by: Andreas Behm :)
(: Description: namespace declaration does not count as attribute :)

fn:count((<elem xmlns:foo="uri"/>)/@*)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-nsdecl-1.txt')

!

test_Constr_attr_nsdecl_2

    | query result |

    query := ' 
        (: Name: Constr-attr-nsdecl-2 :)
(: Written by: Andreas Behm :)
(: Description: namespace default declaration does not count as attribute :)

fn:count((<elem xmlns="uri"/>)/@*)
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-nsdecl-2.txt')

!

test_Constr_attr_nspre_1

    | query result |

    query := ' 
        (: Name: Constr-attr-nspre-1 :)
(: Written by: Andreas Behm :)
(: Description: attribute prefix declared in prolog :)

declare namespace foo="http://www.w3.org/XQueryTest/Construct"; 
<elem foo:attr="value"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-nspre-1.xml')

!

test_Constr_attr_nspre_2

    | query result |

    query := ' 
        (: Name: Constr-attr-nspre-2 :)
(: Written by: Andreas Behm :)
(: Description: attribute prefix declared in parent element :)

<elem xmlns:foo="http://www.w3.org/XQueryTest/Construct"><child foo:attr="value"/></elem>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-nspre-2.xml')

!

test_Constr_attr_nsprein_1

    | query result |

    query := ' 
        (: Name: Constr-attr-nsprein-1 :)
(: Written by: Andreas Behm :)
(: Description: attribute prefix declared in same element before :)

<elem xmlns:foo="http://www.w3.org/XQueryTest/Construct" foo:attr="value"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-nsprein-1.xml')

!

test_Constr_attr_nsprein_2

    | query result |

    query := ' 
        (: Name: Constr-attr-nsprein-2 :)
(: Written by: Andreas Behm :)
(: Description: attribute prefix declared in same element after :)

<elem foo:attr="value" xmlns:foo="http://www.w3.org/XQueryTest/Construct"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-nsprein-2.xml')

!

test_Constr_attr_parent_1

    | query result |

    query := ' 
        (: Name: Constr-attr-parent-1 :)
(: Written by: Andreas Behm :)
(: Description: Attribute parent element :)

for $x in <elem attr="value"/> return $x is $x/@attr/..
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-parent-1.txt')

!

test_Constr_attr_syntax_1

    | query result |

    query := ' 
        (: Name: Constr-attr-syntax-1 :)
(: Written by: Andreas Behm :)
(: Description: Single attribute :)

<elem attr="value"/>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-syntax-1.xml')

!

test_Constr_attr_syntax_10

    | query result |

    query := ' 
        (: Name: Constr-attr-syntax-10 :)
(: Written by: Andreas Behm :)
(: Description: Whitespace after last attribute :)

<elem attr="value"              

          

    />
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-syntax-10.xml')

!

test_Constr_attr_syntax_2

    | query result |

    query := ' 
        (: Name: Constr-attr-syntax-2 :)
(: Written by: Andreas Behm :)
(: Description: Multiple attributes :)

<elem attr1="val1" attr2="val2" attr3="val3"/>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-syntax-2.xml')

!

test_Constr_attr_syntax_3

    | query result |

    query := ' 
        (: Name: Constr-attr-syntax-3 :)
(: Written by: Andreas Behm :)
(: Description: Single quotes for attribute :)

<elem attr="value"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-syntax-3.xml')

!

test_Constr_attr_syntax_4

    | query result |

    query := ' 
        (: Name: Constr-attr-syntax-4 :)
(: Written by: Andreas Behm :)
(: Description: Escaped single quote :)

<elem attr=""""/>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-syntax-4.xml')

!

test_Constr_attr_syntax_5

    | query result |

    query := ' 
        (: Name: Constr-attr-syntax-5 :)
(: Written by: Andreas Behm :)
(: Description: Escaped double quote :)

<elem attr=""""/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-syntax-5.xml')

!

test_Constr_attr_syntax_6

    | query result |

    query := ' 
        (: Name: Constr-attr-syntax-6 :)
(: Written by: Andreas Behm :)
(: Description: Mismatched quotes :)

<elem attr="value"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_attr_syntax_7

    | query result |

    query := ' 
        (: Name: Constr-attr-syntax-7 :)
(: Written by: Andreas Behm :)
(: Description: Mismatched quotes :)

<elem attr="value"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_attr_syntax_8

    | query result |

    query := ' 
        (: Name: Constr-attr-syntax-8 :)
(: Written by: Andreas Behm :)
(: Description: Whitespace between attributes :)

<elem           

        attr1="val1"             

        

          attr2="val2"/>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-syntax-8.xml')

!

test_Constr_attr_syntax_9

    | query result |

    query := ' 
        (: Name: Constr-attr-syntax-9 :)
(: Written by: Andreas Behm :)
(: Description: Whitespace in attribute definition :)

<elem attr       

        

 =              


         

   "value"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-syntax-9.xml')

!

test_Constr_attr_ws_1

    | query result |

    query := ' 
        (: Name: Constr-attr-ws-1 :)
(: Written by: Andreas Behm :)
(: Description: Attribute normalization line feed :)

<elem attr="
"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-ws-1.xml')

!

test_Constr_attr_ws_2

    | query result |

    query := ' 
        (: Name: Constr-attr-ws-2 :)
(: Written by: Andreas Behm :)
(: Description: Attribute normalization tab :)

<elem attr="	"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-ws-2.xml')

!

test_Constr_attr_ws_3

    | query result |

    query := ' 
        (: Name: Constr-attr-ws-3 :)
(: Written by: Andreas Behm :)
(: Description: Attribute normalization char ref &#xd; :)

<elem attr="&#xd;"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-ws-3.xml')

!

test_Constr_attr_ws_4

    | query result |

    query := ' 
        (: Name: Constr-attr-ws-4 :)
(: Written by: Andreas Behm :)
(: Description: Attribute normalization char ref &#xa; :)

<elem attr="&#xa;"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-ws-4.xml')

!

test_Constr_attr_ws_5

    | query result |

    query := ' 
        (: Name: Constr-attr-ws-5 :)
(: Written by: Andreas Behm :)
(: Description: Attribute normalization char ref &#x9; :)

<elem attr="&#x9;"/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/Constr-attr-ws-5.xml')

!

test_K2_DirectConElemAttr_1

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemAttr-1                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Comments cannot appear inside direct element constructors. :)
(:*******************************************************:)
<ncname (:a misplaced comment:)/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K2_DirectConElemAttr_2

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemAttr-2                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Comments cannot appear inside direct element constructors. :)
(:*******************************************************:)
<(:a misplaced comment:)ncname/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K2_DirectConElemAttr_3

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemAttr-3                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Space is not allowed between "<" and the element name. :)
(:*******************************************************:)
< ncname/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K2_DirectConElemAttr_4

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemAttr-4                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Space is not allowed between "</" and the element name. :)
(:*******************************************************:)
<ncname></ ncname>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K2_DirectConElemAttr_5

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemAttr-5                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Comments are not allowed where whitespace is, in direct element constructors. :)
(:*******************************************************:)
<ncname></ncname (:a misplaced comment:) >
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_K2_DirectConElemAttr_6

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemAttr-6                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: Whitespace is allowed in the end tag after the QName. :)
(:*******************************************************:)
<ncname>content</ncname       > = "content"
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/DirectConElemAttr/K2-DirectConElemAttr-6.txt')

!

test_K2_DirectConElemAttr_7

    | query result |

    query := ' 
        (:*******************************************************:)
(: Test: K2-DirectConElemAttr-7                          :)
(: Written by: Frans Englich                             :)
(: Date: 2006-08-04T17:13:26Z                            :)
(: Purpose: XML tags must be balanced.                   :)
(:*******************************************************:)
<ncname></ncnameNOTBALANCED>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
! !

!XQTSDirectConElemAttrTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
