"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSDirectConElemTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSDirectConElemTests methodsFor:'tests'!

test_Constr_elem_curlybr_1

    | query result |

    query := ' 
        (: Name: Constr-elem-curlybr-1 :)
(: Written by: Andreas Behm :)
(: Description: Element constructor with open curly brace :)

<elem>{{</elem>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/Constr-elem-curlybr-1.xml')

!

test_Constr_elem_curlybr_2

    | query result |

    query := ' 
        (: Name: Constr-elem-curlybr-2 :)
(: Written by: Andreas Behm :)
(: Description: Element constructor with closing curly brace :)

<elem>}}</elem>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/Constr-elem-curlybr-2.xml')

!

test_Constr_elem_curlybr_3

    | query result |

    query := ' 
        (: Name: Constr-elem-curlybr-3 :)
(: Written by: Andreas Behm :)
(: Description: Character reference for open curly brace :)

<elem>&#x7b;</elem>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/Constr-elem-curlybr-3.xml')

!

test_Constr_elem_curlybr_4

    | query result |

    query := ' 
        (: Name: Constr-elem-curlybr-4 :)
(: Written by: Andreas Behm :)
(: Description: Character reference for closing curly brace :)

<elem>&#x7d;</elem>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/Constr-elem-curlybr-4.xml')

!

test_Constr_elem_curlybr_5

    | query result |

    query := ' 
        (: Name: Constr-elem-curlybr-5 :)
(: Written by: Andreas Behm :)
(: Description: Single open curly brace :)

<elem>{</elem>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_elem_curlybr_6

    | query result |

    query := ' 
        (: Name: Constr-elem-curlybr-6 :)
(: Written by: Andreas Behm :)
(: Description: Single closing curly brace :)

<elem>}</elem>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_elem_empty_1

    | query result |

    query := ' 
        (: Name: Constr-elem-empty-1 :)
(: Written by: Andreas Behm :)
(: Description: Empty element constructor :)

<elem/>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/Constr-elem-empty-1.xml')

!

test_Constr_elem_empty_2

    | query result |

    query := ' 
        (: Name: Constr-elem-empty-2 :)
(: Written by: Andreas Behm :)
(: Description: Empty element constructor with closing tag :)

<elem></elem>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/Constr-elem-empty-2.xml')

!

test_Constr_elem_empty_3

    | query result |

    query := ' 
        (: Name: Constr-elem-empty-3 :)
(: Written by: Andreas Behm :)
(: Description: Number of child nodes for empty element :)

fn:count((<elem/>)/node())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/Constr-elem-empty-3.txt')

!

test_Constr_elem_empty_4

    | query result |

    query := ' 
        (: Name: Constr-elem-empty-4 :)
(: Written by: Andreas Behm :)
(: Description: Number of child nodes for empty element :)

fn:count((<elem></elem>)/node())
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/Constr-elem-empty-4.txt')

!

test_Constr_elem_empty_5

    | query result |

    query := ' 
        (: Name: Constr-elem-empty-5 :)
(: Written by: Andreas Behm :)
(: Description: Whitespace in element constructor :)

<elem                    


  />
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Expressions/Construct/DirectConElem/Constr-elem-empty-5.xml')

!

test_Constr_elem_matchtag_1

    | query result |

    query := ' 
        (: Name: Constr-elem-matchtag-1 :)
(: Written by: Andreas Behm :)
(: Description: Begin tag matches end tag :)

<elem></elemother>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
!

test_Constr_elem_matchtag_2

    | query result |

    query := ' 
        (: Name: Constr-elem-matchtag-2 :)
(: Written by: Andreas Behm :)
(: Description: Begin tag matches end tag with namespace prefix :)

<foo:elem xmlns:foo="http://www.w3.org/XQueryTest/Construct" xmlns:bar="http://www.w3.org/XQueryTest/Construct"></bar:elem>
      
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

     

    self shouldRaiseError: [interpreter evaluate: query].
! !

!XQTSDirectConElemTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
