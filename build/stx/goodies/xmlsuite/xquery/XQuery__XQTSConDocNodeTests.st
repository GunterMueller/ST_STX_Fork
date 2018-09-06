"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSConDocNodeTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSConDocNodeTests methodsFor:'tests'!

test_Constr_docnode_adjtext_1

    | query result |

    query := ' 
        (: Name: Constr-docnode-adjtext-3 :)
(: Written by: Andreas Behm :)
(: Description: merge adjacent atomic values to text node :)

count((document {1, "string", 1,2e3})/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-adjtext-1.txt')

!

test_Constr_docnode_adjtext_2

    | query result |

    query := ' 
        (: Name: Constr-docnode-adjtext-2 :)
(: Written by: Andreas Behm :)
(: Description: merge adjacent atomic values and text nodes to text node :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

count((document {1, $input-context//text(), "string"})/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-adjtext-2.txt')

!

test_Constr_docnode_adjtext_3

    | query result |

    query := ' 
        (: Name: Constr-docnode-adjtext-3 :)
(: Written by: Andreas Behm :)
(: Description: merge adjacent atomic values between other nodes to text node :)

count((document {1, 2, <a/>, 3, 4, <b/>, 5, 6})/text())

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-adjtext-3.txt')

!

test_Constr_docnode_attr_1

    | query result |

    query := ' 
        (: Name: Constr-docnode-attr-1 :)
(: Written by: Andreas Behm :)
(: Description: attribute in document constructor :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

document {$input-context//@mark}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TreeEmpty'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_docnode_attr_2

    | query result |

    query := ' 
        (: Name: Constr-docnode-attr-2 :)
(: Written by: Andreas Behm :)
(: Description: attribute in document constructor :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

document {<a/>, $input-context//@mark}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TreeEmpty'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_docnode_attr_3

    | query result |

    query := ' 
        (: Name: Constr-docnode-attr-3 :)
(: Written by: Andreas Behm :)
(: Description: attribute in document constructor :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

document {<a/>, $input-context//@mark, <b/>}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'TreeEmpty'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_docnode_constrmod_1

    | query result |

    query := ' 
        (: Name: Constr-docnode-constrmod-1 :)
(: Written by: Andreas Behm :)
(: Description: strip IDREFS type :)

declare construction strip;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

fn:count(fn:data((document {$input-context//*:idrefs})/*))

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-constrmod-1.txt')

!

test_Constr_docnode_constrmod_2

    | query result |

    query := ' 
        (: Name: Constr-docnode-constrmod-2 :)
(: Written by: Andreas Behm :)
(: Description: preserve IDREFS type :)

declare construction preserve;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

fn:count(fn:data((document {$input-context//*:idrefs})/*))

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-constrmod-2.txt')

!

test_Constr_docnode_constrmod_3

    | query result |

    query := ' 
        (: Name: Constr-docnode-constrmod-3 :)
(: Written by: Andreas Behm :)
(: Description: strip decimal type :)

declare construction strip;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

(document {$input-context//*:decimal})/* cast as xs:integer

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_docnode_constrmod_4

    | query result |

    query := ' 
        (: Name: Constr-docnode-constrmod-4 :)
(: Written by: Andreas Behm :)
(: Description: preserve decimal type :)

declare construction preserve;

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

(document {$input-context//*:decimal})/* cast as xs:integer


      
'.

    self xqtsBind: 'input-context' toContentsOf: 'atomic'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-constrmod-4.txt')

!

test_Constr_docnode_data_1

    | query result |

    query := ' 
        (: Name: Constr-docnode-data-1 :)
(: Written by: Andreas Behm :)
(: Description: typed value of element :)

fn:data(document {"a", element a {}, "b"})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-data-1.txt')

!

test_Constr_docnode_doc_1

    | query result |

    query := ' 
        (: Name: Constr-docnode-doc-1 :)
(: Written by: Andreas Behm :)
(: Description: strip document nodes :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

document {$input-context, $input-context}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-doc-1.xml')

!

test_Constr_docnode_enclexpr_1

    | query result |

    query := ' 
        (: Name: Constr-docnode-enclexpr-1 :)
(: Written by: Andreas Behm :)
(: Description: empty computed element content :)

document {()}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-enclexpr-1.xml')

!

test_Constr_docnode_enclexpr_2

    | query result |

    query := ' 
        (: Name: Constr-docnode-enclexpr-2 :)
(: Written by: Andreas Behm :)
(: Description: atomic values in computed element content :)

document {1,"a",3.5,4e2}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-enclexpr-2.xml')

!

test_Constr_docnode_enclexpr_3

    | query result |

    query := ' 
        (: Name: Constr-docnode-enclexpr-3 :)
(: Written by: Andreas Behm :)
(: Description: atomic values and nodes in computed element content :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

document {1,$input-context//a,2,3,$input-context//comment(),4,5,$input-context//processing-instruction(),6,7,$input-context//text(),8}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-enclexpr-3.xml')

!

test_Constr_docnode_enclexpr_4

    | query result |

    query := ' 
        (: Name: Constr-docnode-enclexpr-4 :)
(: Written by: Andreas Behm :)
(: Description: empty string in element content :)

document {1, "", 2}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-enclexpr-4.xml')

!

test_Constr_docnode_nested_1

    | query result |

    query := ' 
        (: Name: Constr-docnode-nested-1 :)
(: Written by: Andreas Behm :)
(: Description: nested computed element constructors :)

document {1, document {2, document {document {()}, document {3}}, 4}}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-nested-1.xml')

!

test_Constr_docnode_nested_2

    | query result |

    query := ' 
        (: Name: Constr-docnode-nested-2 :)
(: Written by: Andreas Behm :)
(: Description: copy node tree into computed element constructor :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

document {$input-context/root}

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'DupNode'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-nested-2.xml')

!

test_Constr_docnode_nodeid_1

    | query result |

    query := ' 
        (: Name: Constr-docnode-nodeid-1 :)
(: Written by: Andreas Behm :)
(: Description: Copied element node has new node identity :)

for $x in <a/>,
    $y in document {$x}
return $y/a is $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-nodeid-1.txt')

!

test_Constr_docnode_nodeid_3

    | query result |

    query := ' 
        (: Name: Constr-docnode-nodeid-3 :)
(: Written by: Andreas Behm :)
(: Description: Copied comment node has new node identity :)

for $x in <!!--comment-->,
    $y in document {$x}
return $y/comment() is $x


'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-nodeid-3.txt')

    "Created: / 22-09-2009 / 20:57:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

test_Constr_docnode_nodeid_4

    | query result |

    query := ' 
        (: Name: Constr-docnode-nodeid-4 :)
(: Written by: Andreas Behm :)
(: Description: Copied pi node has new node identity :)

for $x in <?pi content?>,
    $y in document {$x}
return $y/processing-instruction() is $x

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-nodeid-4.txt')

!

test_Constr_docnode_nodeid_5

    | query result |

    query := ' 
        (: Name: Constr-docnode-nodeid-5 :)
(: Written by: Andreas Behm :)
(: Description: Copied text node has new node identity :)

for $x in <a>text</a>,
    $y in document {$x/text()}
return $y/text() is $x/text()

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-nodeid-5.txt')

!

test_Constr_docnode_parent_1

    | query result |

    query := ' 
        (: Name: Constr-docnode-parent-1 :)
(: Written by: Andreas Behm :)
(: Description: empty parent :)

count((document {()})/..)

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-parent-1.txt')

!

test_Constr_docnode_string_1

    | query result |

    query := ' 
        (: Name: Constr-docnode-string-1 :)
(: Written by: Andreas Behm :)
(: Description: string value of element :)

fn:string(document {"a", element a {}, "b"})

      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/ComputeCon/ConDocNode/Constr-docnode-string-1.txt')

! !

!XQTSConDocNodeTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
