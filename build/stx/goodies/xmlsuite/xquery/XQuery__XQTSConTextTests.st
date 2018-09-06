"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSConTextTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSConTextTests methodsFor:'tests'!

test_Constr_text_adjtext_1

    | query result |

    query := ' 
        (: Name: Constr-text-adjtext-1 :)
(: Written by: Andreas Behm :)
(: Description: merge adjacent text nodes :)

count(<elem>{text {"te"}, text {"xt"}}</elem>/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-adjtext-1.txt')

!

test_Constr_text_adjtext_2

    | query result |

    query := ' 
        (: Name: Constr-text-adjtext-2 :)
(: Written by: Andreas Behm :)
(: Description: merge adjacent text nodes :)

count(document {text {"te"}, text {"xt"}}/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-adjtext-2.txt')

!

test_Constr_text_count_1

    | query result |

    query := ' 
        (: Name: Constr-text-count-1 :)
(: Written by: Andreas Behm :)
(: Description: count text nodes :)

count(text {""})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-count-1.txt')

!

test_Constr_text_count_2

    | query result |

    query := ' 
        (: Name: Constr-text-count-2 :)
(: Written by: Andreas Behm :)
(: Description: count text nodes :)

count(text {()})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-count-2.txt')

!

test_Constr_text_count_3

    | query result |

    query := ' 
        (: Name: Constr-text-count-3 :)
(: Written by: Andreas Behm :)
(: Description: count text nodes :)

count(element elem {text {""}}/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-count-3.txt')

!

test_Constr_text_count_4

    | query result |

    query := ' 
        (: Name: Constr-text-count-4 :)
(: Written by: Andreas Behm :)
(: Description: count text nodes :)

count(document {text {""}}/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-count-4.txt')

!

test_Constr_text_count_5

    | query result |

    query := ' 
        (: Name: Constr-text-count-5 :)
(: Written by: Andreas Behm :)
(: Description: count text nodes :)

count(<a>{text {""}}<b/>{text {""}}<b/>{text {""}}</a>/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-count-5.txt')

!

test_Constr_text_count_6

    | query result |

    query := ' 
        (: Name: Constr-text-count-6 :)
(: Written by: Andreas Behm :)
(: Description: count text nodes :)

count(document {text {""},<b/>,text {""},<b/>,text {""}}/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-count-6.txt')

!

test_Constr_text_data_1

    | query result |

    query := ' 
        (: Name: Constr-text-data-1 :)
(: Written by: Andreas Behm :)
(: Description: typed value of text node :)

fn:data(text {"a", element a {}, "b"})


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-data-1.txt')

!

test_Constr_text_doc_1

    | query result |

    query := ' 
        (: Name: Constr-text-doc-1 :)
(: Written by: Andreas Behm :)
(: Description: strip document nodes :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

text {$input-context, $input-context}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-doc-1.txt')

!

test_Constr_text_enclexpr_1

    | query result |

    query := ' 
        (: Name: Constr-text-enclexpr-1 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in text node - atomic values :)

text {1,"string",3.14,xs:float("1.2345e-2"),xs:dateTime("2002-04-02T12:00:00-01:00")}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-enclexpr-1.txt')

!

test_Constr_text_enclexpr_2

    | query result |

    query := ' 
        (: Name: Constr-text-enclexpr-2 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in text node - nodes :)

text {<elem>123</elem>, (<elem attr="456"/>)/@attr, (<elem>789</elem>)/text()}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-enclexpr-2.txt')

!

test_Constr_text_enclexpr_3

    | query result |

    query := ' 
        (: Name: Constr-text-enclexpr-3 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in text node - empty string :)

text {1,"",2}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-enclexpr-3.txt')

!

test_Constr_text_enclexpr_4

    | query result |

    query := ' 
        (: Name: Constr-text-enclexpr-4 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in text node - empty node :)

text {1,<a/>,2}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-enclexpr-4.txt')

!

test_Constr_text_enclexpr_5

    | query result |

    query := ' 
        (: Name: Constr-text-enclexpr-5 :)
(: Written by: Andreas Behm :)
(: Description: enclosed expression in text node - nodes :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

text {$input-context/root}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-enclexpr-5.txt')

!

test_Constr_text_nested_1

    | query result |

    query := ' 
        (: Name: Constr-text-nested-1 :)
(: Written by: Andreas Behm :)
(: Description: nested text node constructor :)

text {text {"one", text {"two"}}, "three", text {"four"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-nested-1.txt')

!

test_Constr_text_nested_2

    | query result |

    query := ' 
        (: Name: Constr-text-nested-2 :)
(: Written by: Andreas Behm :)
(: Description: nested text nodes in element constructor :)

<elem>{text {"one"}}<a>{text {"two"}}</a>{text {"three"}}</elem>

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-nested-2.xml')

!

test_Constr_text_nested_3

    | query result |

    query := ' 
        (: Name: Constr-text-nested-3 :)
(: Written by: Andreas Behm :)
(: Description: nested text nodes in element constructor :)

document {text {"one"}, <a/>, text {"two"}, <b/>, text {"three"}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-nested-3.xml')

!

test_Constr_text_parent_1

    | query result |

    query := ' 
        (: Name: Constr-text-parent-1 :)
(: Written by: Andreas Behm :)
(: Description: empty parent :)

count((text {"text"})/..)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-parent-1.txt')

!

test_Constr_text_string_1

    | query result |

    query := ' 
        (: Name: Constr-text-string-1 :)
(: Written by: Andreas Behm :)
(: Description: string value of text node :)

fn:string(text {"a", element a {}, "b"})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConText/Constr-text-string-1.txt')

! !

!XQTSConTextTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
