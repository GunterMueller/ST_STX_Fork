"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSAllString
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSAllString methodsFor:'tests'!

test_K2_EndsWithFunc_1

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-EndsWithFunc-1                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two values returned from fn:lower-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("b string", current-time(), string(<e>content</e>))[1] treat as xs:string;
ends-with(lower-case($vA), lower-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K2-EndsWithFunc-1.txt')

    "Created: / 11-05-2013 / 19:17:54 / jirka"
!

test_K2_EndsWithFunc_10

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-10                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `not(ends-with ((), "a string"))`. :)
(:*******************************************************:)
not(ends-with ((), "a string"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K2-EndsWithFunc-10.txt')

    "Created: / 11-05-2013 / 22:49:19 / houzvjir@fel.cvut.cz"
!

test_K2_EndsWithFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-EndsWithFunc-2                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two values returned from fn:upper-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("b string", current-time(), string(<e>content</e>))[1] treat as xs:string;
ends-with(upper-case($vA), upper-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K2-EndsWithFunc-2.txt')

    "Created: / 11-05-2013 / 19:18:29 / jirka"
!

test_K2_EndsWithFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-EndsWithFunc-3                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two non-matching values returned from fn:lower-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("no match", current-time(), string(<e>content</e>))[1] treat as xs:string;
ends-with(lower-case($vA), lower-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K2-EndsWithFunc-3.txt')

    "Created: / 11-05-2013 / 19:18:41 / jirka"
!

test_K2_EndsWithFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-EndsWithFunc-4                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two non-matching values returned from fn:upper-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("no match", current-time(), string(<e>content</e>))[1] treat as xs:string;
ends-with(upper-case($vA), upper-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K2-EndsWithFunc-4.txt')

    "Created: / 11-05-2013 / 19:18:53 / jirka"
!

test_K2_EndsWithFunc_5

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-EndsWithFunc-5                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two non-matching values returned from fn:lower-case() and fn:upper-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("b string", current-time(), string(<e>content</e>))[1] treat as xs:string;
ends-with(upper-case($vA), lower-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K2-EndsWithFunc-5.txt')

    "Created: / 11-05-2013 / 19:19:03 / jirka"
!

test_K2_EndsWithFunc_6

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-EndsWithFunc-6                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two non-matching values returned from fn:lower-case() and fn:upper-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("b string", current-time(), string(<e>content</e>))[1] treat as xs:string;
ends-with(lower-case($vA), upper-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K2-EndsWithFunc-6.txt')

    "Created: / 11-05-2013 / 19:19:31 / jirka"
!

test_K2_EndsWithFunc_7

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-7                                :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `not(ends-with("tattoo", "atto"))`. :)
(:*******************************************************:)
not(ends-with("tattoo", "atto"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K2-EndsWithFunc-7.txt')

    "Created: / 11-05-2013 / 22:47:55 / houzvjir@fel.cvut.cz"
!

test_K2_EndsWithFunc_8

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-8                                :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `not(ends-with("tattoo", "atto"))`. :)
(:*******************************************************:)
not(ends-with("tattoo", "atto"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K2-EndsWithFunc-8.txt')

    "Created: / 11-05-2013 / 22:48:21 / houzvjir@fel.cvut.cz"
!

test_K2_EndsWithFunc_9

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-9                                :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `ends-with((), ())`. :)
(:*******************************************************:)
ends-with((), ())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K2-EndsWithFunc-9.txt')

    "Created: / 11-05-2013 / 22:48:53 / houzvjir@fel.cvut.cz"
!

test_K2_StartsWithFunc_1

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-StartsWithFunc-1                             :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two values returned from fn:lower-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("b string", current-time(), string(<e>content</e>))[1] treat as xs:string;
starts-with(lower-case($vA), lower-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K2-StartsWithFunc-1.txt')

    "Created: / 11-05-2013 / 23:04:18 / houzvjir@fel.cvut.cz"
!

test_K2_StartsWithFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-StartsWithFunc-2                             :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two values returned from fn:upper-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("b string", current-time(), string(<e>content</e>))[1] treat as xs:string;
starts-with(upper-case($vA), upper-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K2-StartsWithFunc-2.txt')

    "Created: / 11-05-2013 / 23:05:02 / houzvjir@fel.cvut.cz"
!

test_K2_StartsWithFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-StartsWithFunc-3                             :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two non-matching values returned from fn:lower-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("no match", current-time(), string(<e>content</e>))[1] treat as xs:string;
starts-with(lower-case($vA), lower-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K2-StartsWithFunc-3.txt')

    "Created: / 11-05-2013 / 23:05:31 / houzvjir@fel.cvut.cz"
!

test_K2_StartsWithFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-StartsWithFunc-4                             :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two non-matching values returned from fn:upper-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("no match", current-time(), string(<e>content</e>))[1] treat as xs:string;
starts-with(upper-case($vA), upper-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K2-StartsWithFunc-4.txt')

    "Created: / 11-05-2013 / 23:05:57 / houzvjir@fel.cvut.cz"
!

test_K2_StartsWithFunc_5

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-StartsWithFunc-5                             :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two non-matching values returned from fn:lower-case() and fn:upper-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("b string", current-time(), string(<e>content</e>))[1] treat as xs:string;
starts-with(upper-case($vA), lower-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K2-StartsWithFunc-5.txt')

    "Created: / 11-05-2013 / 23:06:26 / houzvjir@fel.cvut.cz"
!

test_K2_StartsWithFunc_6

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K2-StartsWithFunc-6                             :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:21+01:00                       :)
(: Purpose: Compare two non-matching values returned from fn:lower-case() and fn:upper-case(). :)
(:*******************************************************:)
declare variable $vA as xs:string := ("B STRING", current-time(), string(<e>content</e>))[1] treat as xs:string;
declare variable $vB as xs:string := ("b string", current-time(), string(<e>content</e>))[1] treat as xs:string;
starts-with(lower-case($vA), upper-case($vB))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K2-StartsWithFunc-6.txt')

    "Created: / 11-05-2013 / 23:06:51 / houzvjir@fel.cvut.cz"
!

test_K_EndsWithFunc_1

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-1                                :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `ends-with()`.      :)
(:*******************************************************:)
ends-with()
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K-EndsWithFunc-1.txt')

    "Created: / 11-05-2013 / 22:40:33 / houzvjir@fel.cvut.cz"
!

test_K_EndsWithFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-2                                :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `ends-with(())`.    :)
(:*******************************************************:)
ends-with(())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K-EndsWithFunc-2.txt')

    "Created: / 11-05-2013 / 22:42:18 / houzvjir@fel.cvut.cz"
!

test_K_EndsWithFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-3                                :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `ends-with((), (), "http://www.w3.org/2005/xpath-functions/collation/codepoint", "wrong param")`. :)
(:*******************************************************:)
ends-with((), (),
                        "http://www.w3.org/2005/xpath-functions/collation/codepoint",
                        "wrong param")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K-EndsWithFunc-3.txt')

    "Created: / 11-05-2013 / 22:42:45 / houzvjir@fel.cvut.cz"
!

test_K_EndsWithFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-4                                :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `ends-with("a string", "a string", "http://www.example.com/COLLATION/NOT/SUPPORTED")`. :)
(:*******************************************************:)
ends-with("a string", "a string",
                        "http://www.example.com/COLLATION/NOT/SUPPORTED")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K-EndsWithFunc-4.txt')

    "Created: / 11-05-2013 / 22:43:19 / houzvjir@fel.cvut.cz"
!

test_K_EndsWithFunc_5

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-5                                :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `ends-with("foo", "foo", "http://www.w3.org/2005/xpath-functions/collation/codepoint")`. :)
(:*******************************************************:)
ends-with("foo", "foo",
                        "http://www.w3.org/2005/xpath-functions/collation/codepoint")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K-EndsWithFunc-5.txt')

    "Created: / 11-05-2013 / 22:43:41 / houzvjir@fel.cvut.cz"
!

test_K_EndsWithFunc_6

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-6                                :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `ends-with("tattoo", "tattoo")`. :)
(:*******************************************************:)
ends-with("tattoo", "tattoo")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K-EndsWithFunc-6.txt')

    "Created: / 11-05-2013 / 22:44:09 / houzvjir@fel.cvut.cz"
!

test_K_EndsWithFunc_7

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-EndsWithFunc-7                                :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `not(ends-with("tattoo", "atto"))`. :)
(:*******************************************************:)
not(ends-with("tattoo", "atto"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/K-EndsWithFunc-7.txt')

    "Created: / 11-05-2013 / 22:47:14 / houzvjir@fel.cvut.cz"
!

test_K_LowerCaseFunc_1

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-LowerCaseFunc-1                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `lower-case()`.     :)
(:*******************************************************:)
lower-case()
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/K-LowerCaseFunc-1.txt')

    "Created: / 11-05-2013 / 19:20:24 / jirka"
!

test_K_LowerCaseFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-LowerCaseFunc-2                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `lower-case("string", "wrong param")`. :)
(:*******************************************************:)
lower-case("string", "wrong param")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/K-LowerCaseFunc-2.txt')

    "Created: / 11-05-2013 / 19:20:33 / jirka"
!

test_K_LowerCaseFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-LowerCaseFunc-3                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `lower-case(()) eq ""`. :)
(:*******************************************************:)
lower-case(()) eq ""
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/K-LowerCaseFunc-3.txt')

    "Created: / 11-05-2013 / 19:20:41 / jirka"
!

test_K_LowerCaseFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-LowerCaseFunc-4                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `upper-case("abCd0") eq "ABCD0"`. :)
(:*******************************************************:)
upper-case("abCd0") eq "ABCD0"
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/K-LowerCaseFunc-4.txt')

    "Created: / 11-05-2013 / 19:20:54 / jirka"
!

test_K_StartsWithFunc_1

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-1                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `starts-with()`.    :)
(:*******************************************************:)
starts-with()
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-1.txt')

    "Created: / 11-05-2013 / 23:08:00 / houzvjir@fel.cvut.cz"
!

test_K_StartsWithFunc_10

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-10                             :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `starts-with("a string", ())`. :)
(:*******************************************************:)
starts-with("a string", ())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-10.txt')

    "Created: / 11-05-2013 / 23:13:32 / houzvjir@fel.cvut.cz"
!

test_K_StartsWithFunc_11

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-11                             :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `not(starts-with("", "a string"))`. :)
(:*******************************************************:)
not(starts-with("", "a string"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-11.txt')

    "Created: / 11-05-2013 / 23:13:58 / houzvjir@fel.cvut.cz"
!

test_K_StartsWithFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-2                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `starts-with(())`.  :)
(:*******************************************************:)
starts-with(())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-2.txt')

    "Created: / 11-05-2013 / 23:08:57 / houzvjir@fel.cvut.cz"
!

test_K_StartsWithFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-3                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `starts-with((), (), "http://www.w3.org/2005/xpath-functions/collation/codepoint", "wrong param")`. :)
(:*******************************************************:)
starts-with((), (),
                        "http://www.w3.org/2005/xpath-functions/collation/codepoint",
                        "wrong param")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-3.txt')

    "Created: / 11-05-2013 / 23:09:26 / houzvjir@fel.cvut.cz"
!

test_K_StartsWithFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-4                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `starts-with("a string", "a string", "http://www.example.com/COLLATION/NOT/SUPPORTED")`. :)
(:*******************************************************:)
starts-with("a string", "a string",
                        "http://www.example.com/COLLATION/NOT/SUPPORTED")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-4.txt')

    "Created: / 11-05-2013 / 23:09:57 / houzvjir@fel.cvut.cz"
!

test_K_StartsWithFunc_5

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-5                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `starts-with("foo", "foo", "http://www.w3.org/2005/xpath-functions/collation/codepoint")`. :)
(:*******************************************************:)
starts-with("foo", "foo",
                        "http://www.w3.org/2005/xpath-functions/collation/codepoint")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-5.txt')

    "Created: / 11-05-2013 / 23:10:29 / houzvjir@fel.cvut.cz"
!

test_K_StartsWithFunc_6

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-6                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `starts-with("foo", "foo")`. :)
(:*******************************************************:)
starts-with("foo", "foo")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-6.txt')

    "Created: / 11-05-2013 / 23:10:49 / houzvjir@fel.cvut.cz"
!

test_K_StartsWithFunc_7

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-7                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `starts-with("tattoo", "tat")`. :)
(:*******************************************************:)
starts-with("tattoo", "tat")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-7.txt')

    "Created: / 11-05-2013 / 23:11:19 / houzvjir@fel.cvut.cz"
!

test_K_StartsWithFunc_8

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-8                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `not(starts-with("tattoo", "att"))`. :)
(:*******************************************************:)
not(starts-with("tattoo", "att"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-8.txt')

    "Created: / 11-05-2013 / 23:11:55 / houzvjir@fel.cvut.cz"
!

test_K_StartsWithFunc_9

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StartsWithFunc-9                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `starts-with((), ())`. :)
(:*******************************************************:)
starts-with((), ())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/K-StartsWithFunc-9.txt')

    "Created: / 11-05-2013 / 23:13:03 / houzvjir@fel.cvut.cz"
!

test_K_StringLengthFunc_1

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StringLengthFunc-1                            :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `string-length("a string", "wrong param")`. :)
(:*******************************************************:)
string-length("a string", "wrong param")

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/K-StringLengthFunc-1.txt')

    "Created: / 12-05-2013 / 13:23:40 / houzvjir@fel.cvut.cz"
!

test_K_StringLengthFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StringLengthFunc-2                            :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `string-length("ebv") eq 3`. :)
(:*******************************************************:)
string-length("ebv") eq 3

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/K-StringLengthFunc-2.txt')

    "Created: / 12-05-2013 / 13:26:55 / houzvjir@fel.cvut.cz"
!

test_K_StringLengthFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StringLengthFunc-3                            :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `string-length("ebv") instance of xs:integer`. :)
(:*******************************************************:)
string-length("ebv") instance of xs:integer

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/K-StringLengthFunc-3.txt')

    "Created: / 12-05-2013 / 13:27:37 / houzvjir@fel.cvut.cz"
!

test_K_StringLengthFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StringLengthFunc-4                            :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `string-length(()) eq 0`. :)
(:*******************************************************:)
string-length(()) eq 0

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/K-StringLengthFunc-4.txt')

    "Created: / 12-05-2013 / 13:28:04 / houzvjir@fel.cvut.cz"
!

test_K_StringLengthFunc_5

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StringLengthFunc-5                            :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `string-length("") eq 0`. :)
(:*******************************************************:)
string-length("") eq 0

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/K-StringLengthFunc-5.txt')

    "Created: / 12-05-2013 / 13:28:25 / houzvjir@fel.cvut.cz"
!

test_K_StringLengthFunc_6

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StringLengthFunc-6                            :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `string-length(()) instance of xs:integer`. :)
(:*******************************************************:)
string-length(()) instance of xs:integer

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/K-StringLengthFunc-6.txt')

    "Created: / 12-05-2013 / 13:28:58 / houzvjir@fel.cvut.cz"
!

test_K_StringLengthFunc_7

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StringLengthFunc-7                            :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `if(false()) then string-length() else true()`. :)
(:*******************************************************:)
if(false()) then string-length() else true()

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/K-StringLengthFunc-7.txt')

    "Created: / 12-05-2013 / 13:30:00 / houzvjir@fel.cvut.cz"
!

test_K_StringLengthFunc_8

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-StringLengthFunc-8                            :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `string-length("Harp not on that string, madam; that is past.") eq 45`. :)
(:*******************************************************:)
string-length("Harp not on that string, madam; that is past.")
                        eq 45

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/K-StringLengthFunc-8.txt')

    "Created: / 12-05-2013 / 13:30:33 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_1

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-1                          :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after()`. :)
(:*******************************************************:)
substring-after()
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-1.txt')

    "Created: / 11-05-2013 / 23:19:25 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_10

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-10                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after("a string", ()) eq "a string"`. :)
(:*******************************************************:)
substring-after("a string", ()) eq "a string"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-10.txt')

    "Created: / 11-05-2013 / 23:20:31 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_11

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-11                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after("a string", "not in other") eq ""`. :)
(:*******************************************************:)
substring-after("a string", "not in other") eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-11.txt')

    "Created: / 11-05-2013 / 23:21:03 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-2                          :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after(())`. :)
(:*******************************************************:)
substring-after(())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-2.txt')

    "Created: / 11-05-2013 / 23:21:32 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-3                          :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after((), (), "http://www.w3.org/2005/xpath-functions/collation/codepoint", "wrong param")`. :)
(:*******************************************************:)
substring-after((), (),
                        "http://www.w3.org/2005/xpath-functions/collation/codepoint",
                        "wrong param")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-3.txt')

    "Created: / 11-05-2013 / 23:22:26 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-4                          :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after("a string", "a string", "http://www.example.com/COLLATION/NOT/SUPPORTED")`. :)
(:*******************************************************:)
substring-after("a string", "a string",
                        "http://www.example.com/COLLATION/NOT/SUPPORTED")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-4.txt')

    "Created: / 11-05-2013 / 23:22:55 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_5

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-5                          :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after("foo", "fo", "http://www.w3.org/2005/xpath-functions/collation/codepoint") eq "o"`. :)
(:*******************************************************:)
substring-after("foo", "fo",
                        "http://www.w3.org/2005/xpath-functions/collation/codepoint") eq "o"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-5.txt')

    "Created: / 11-05-2013 / 23:23:21 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_6

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-6                          :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after("tattoo", "tat") eq "too"`. :)
(:*******************************************************:)
substring-after("tattoo", "tat") eq "too"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-6.txt')

    "Created: / 11-05-2013 / 23:23:45 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_7

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-7                          :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after("tattoo", "tattoo") eq ""`. :)
(:*******************************************************:)
substring-after("tattoo", "tattoo") eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-7.txt')

    "Created: / 11-05-2013 / 23:24:20 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_8

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-8                          :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after("abcdefgedij", "def") eq "gedij"`. :)
(:*******************************************************:)
substring-after("abcdefgedij", "def") eq "gedij"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-8.txt')

    "Created: / 11-05-2013 / 23:24:43 / houzvjir@fel.cvut.cz"
!

test_K_SubstringAfterFunc_9

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringAfterFunc-9                          :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-after((), ()) eq ""`. :)
(:*******************************************************:)
substring-after((), ()) eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/K-SubstringAfterFunc-9.txt')

    "Created: / 11-05-2013 / 23:25:06 / houzvjir@fel.cvut.cz"
!

test_K_SubstringBeforeFunc_1

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringBeforeFunc-1                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-before()`. :)
(:*******************************************************:)
substring-before()
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/K-SubstringBeforeFunc-1.txt')

    "Created: / 12-05-2013 / 08:04:40 / houzvjir@fel.cvut.cz"
!

test_K_SubstringBeforeFunc_10

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringBeforeFunc-10                        :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-before("a string", "not in other") eq ""`. :)
(:*******************************************************:)
substring-before("a string", "not in other") eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/K-SubstringBeforeFunc-10.txt')

    "Created: / 12-05-2013 / 08:05:55 / houzvjir@fel.cvut.cz"
!

test_K_SubstringBeforeFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringBeforeFunc-2                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-before(())`. :)
(:*******************************************************:)
substring-before(())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/K-SubstringBeforeFunc-2.txt')

    "Created: / 12-05-2013 / 08:07:17 / houzvjir@fel.cvut.cz"
!

test_K_SubstringBeforeFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringBeforeFunc-3                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-before((), (), "http://www.w3.org/2005/xpath-functions/collation/codepoint", "wrong param")`. :)
(:*******************************************************:)
substring-before((), (),
                        "http://www.w3.org/2005/xpath-functions/collation/codepoint",
                        "wrong param")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/K-SubstringBeforeFunc-3.txt')

    "Created: / 12-05-2013 / 08:07:49 / houzvjir@fel.cvut.cz"
!

test_K_SubstringBeforeFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringBeforeFunc-4                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-before("a string", "a string", "http://www.example.com/COLLATION/NOT/SUPPORTED")`. :)
(:*******************************************************:)
substring-before("a string", "a string",
                        "http://www.example.com/COLLATION/NOT/SUPPORTED")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/K-SubstringBeforeFunc-4.txt')

    "Created: / 12-05-2013 / 08:08:32 / houzvjir@fel.cvut.cz"
!

test_K_SubstringBeforeFunc_5

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringBeforeFunc-5                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-before("foo", "oo", "http://www.w3.org/2005/xpath-functions/collation/codepoint") eq "f"`. :)
(:*******************************************************:)
substring-before("foo", "oo",
                        "http://www.w3.org/2005/xpath-functions/collation/codepoint") eq "f"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/K-SubstringBeforeFunc-5.txt')

    "Created: / 12-05-2013 / 08:09:01 / houzvjir@fel.cvut.cz"
!

test_K_SubstringBeforeFunc_6

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringBeforeFunc-6                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-before("tattoo", "attoo") eq "t"`. :)
(:*******************************************************:)
substring-before("tattoo", "attoo") eq "t"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/K-SubstringBeforeFunc-6.txt')

    "Created: / 12-05-2013 / 08:09:52 / houzvjir@fel.cvut.cz"
!

test_K_SubstringBeforeFunc_7

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringBeforeFunc-7                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-before("tattoo", "tatto") eq ""`. :)
(:*******************************************************:)
substring-before("tattoo", "tatto") eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/K-SubstringBeforeFunc-7.txt')

    "Created: / 12-05-2013 / 08:11:21 / houzvjir@fel.cvut.cz"
!

test_K_SubstringBeforeFunc_8

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringBeforeFunc-8                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-before((), ()) eq ""`. :)
(:*******************************************************:)
substring-before((), ()) eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/K-SubstringBeforeFunc-8.txt')

    "Created: / 12-05-2013 / 08:11:51 / houzvjir@fel.cvut.cz"
!

test_K_SubstringBeforeFunc_9

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringBeforeFunc-9                         :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring-before("a string", "") eq ""`. :)
(:*******************************************************:)
substring-before("a string", "") eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/K-SubstringBeforeFunc-9.txt')

    "Created: / 12-05-2013 / 08:12:18 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_1

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-1                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `sub-string("a string")`. :)
(:*******************************************************:)
sub-string("a string")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-1.txt')

    "Created: / 11-05-2013 / 22:19:59 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_10

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-10                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring("12345", 0 div 0E0, 3) eq ""`. :)
(:*******************************************************:)
substring("12345", 0 div 0E0, 3) eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-10.txt')

    "Created: / 11-05-2013 / 22:27:49 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_11

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-11                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring("12345", 1, 0 div 0E0) eq ""`. :)
(:*******************************************************:)
substring("12345", 1, 0 div 0E0) eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-11.txt')

    "Created: / 11-05-2013 / 22:28:13 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_12

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-12                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring("12345", -3, 5) eq "1"`. :)
(:*******************************************************:)
substring("12345", -3, 5) eq "1"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-12.txt')

    "Created: / 11-05-2013 / 22:28:46 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_13

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-13                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring("12345", -42, 1 div 0E0) eq "12345"`. :)
(:*******************************************************:)
substring("12345", -42, 1 div 0E0) eq "12345"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-13.txt')

    "Created: / 11-05-2013 / 22:29:18 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_14

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-14                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring("12345", -1 div 0E0, 1 div 0E0) eq ""`. :)
(:*******************************************************:)
substring("12345", -1 div 0E0, 1 div 0E0) eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-14.txt')

    "Created: / 11-05-2013 / 22:29:44 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_15

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-15                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring("12345", 5, -3) eq ""`. :)
(:*******************************************************:)
substring("12345", 5, -3) eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-15.txt')

    "Created: / 11-05-2013 / 22:30:09 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-2                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `sub-string("a string", 1, 2, "wrong param")`. :)
(:*******************************************************:)
sub-string("a string", 1, 2, "wrong param")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-2.txt')

    "Created: / 11-05-2013 / 22:21:40 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-3                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring((), 1, 2) eq ""`. :)
(:*******************************************************:)
substring((), 1, 2) eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-3.txt')

    "Created: / 11-05-2013 / 22:21:59 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-4                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring((), 1) eq ""`. :)
(:*******************************************************:)
substring((), 1) eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-4.txt')

    "Created: / 11-05-2013 / 22:24:07 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_5

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-5                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring("12345", 1.5, 2.6) eq "234"`. :)
(:*******************************************************:)
substring("12345", 1.5, 2.6) eq "234"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-5.txt')

    "Created: / 11-05-2013 / 22:24:30 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_6

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-6                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring((), 1, 3) eq ""`. :)
(:*******************************************************:)
substring((), 1, 3) eq ""
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-6.txt')

    "Created: / 11-05-2013 / 22:25:00 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_7

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-7                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring("motor car", 6) eq " car"`. :)
(:*******************************************************:)
substring("motor car", 6) eq " car"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-7.txt')

    "Created: / 11-05-2013 / 22:25:37 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_8

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-8                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring("12345", 0, 3) eq "12"`. :)
(:*******************************************************:)
substring("12345", 0, 3) eq "12"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-8.txt')

    "Created: / 11-05-2013 / 22:26:01 / houzvjir@fel.cvut.cz"
!

test_K_SubstringFunc_9

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-SubstringFunc-9                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `substring("metadata", 4, 3) eq "ada"`. :)
(:*******************************************************:)
substring("metadata", 4, 3) eq "ada"
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/K-SubstringFunc-9.txt')

    "Created: / 11-05-2013 / 22:26:20 / houzvjir@fel.cvut.cz"
!

test_K_TranslateFunc_1

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-TranslateFunc-1                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `translate()`.      :)
(:*******************************************************:)
translate()
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/K-TranslateFunc-1.txt')

    "Created: / 13-05-2013 / 13:56:24 / houzvjir@fel.cvut.cz"
!

test_K_TranslateFunc_10

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-TranslateFunc-10                              :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `translate("--aaa--","abc-","ABC") eq "AAA"`. :)
(:*******************************************************:)
translate("--aaa--","abc-","ABC") eq "AAA"
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/K-TranslateFunc-10.txt')

    "Created: / 13-05-2013 / 14:01:12 / houzvjir@fel.cvut.cz"
!

test_K_TranslateFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-TranslateFunc-2                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `translate("string", "map string")`. :)
(:*******************************************************:)
translate("string", "map string")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/K-TranslateFunc-2.txt')

    "Created: / 13-05-2013 / 13:57:18 / houzvjir@fel.cvut.cz"
!

test_K_TranslateFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-TranslateFunc-3                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `translate("arg", "map string", "transString", "wrong param")`. :)
(:*******************************************************:)
translate("arg", "map string",
                                                             "transString", "wrong param")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/K-TranslateFunc-3.txt')

    "Created: / 13-05-2013 / 13:57:42 / houzvjir@fel.cvut.cz"
!

test_K_TranslateFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-TranslateFunc-4                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `translate("--aaa--","-","") eq "aaa"`. :)
(:*******************************************************:)
translate("--aaa--","-","") eq "aaa"
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/K-TranslateFunc-4.txt')

    "Created: / 13-05-2013 / 13:58:13 / houzvjir@fel.cvut.cz"
!

test_K_TranslateFunc_5

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-TranslateFunc-5                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `translate("--aaa--","bbb++","") eq "--aaa--"`. :)
(:*******************************************************:)
translate("--aaa--","bbb++","") eq "--aaa--"
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/K-TranslateFunc-5.txt')

    "Created: / 13-05-2013 / 13:58:38 / houzvjir@fel.cvut.cz"
!

test_K_TranslateFunc_6

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-TranslateFunc-6                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `translate("argstr", "", "matrs") eq "argstr"`. :)
(:*******************************************************:)
translate("argstr", "", "matrs") eq "argstr"
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/K-TranslateFunc-6.txt')

    "Created: / 13-05-2013 / 13:58:57 / houzvjir@fel.cvut.cz"
!

test_K_TranslateFunc_7

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-TranslateFunc-7                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `translate((), "map", "trans") eq ""`. :)
(:*******************************************************:)
translate((), "map", "trans") eq ""
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/K-TranslateFunc-7.txt')

    "Created: / 13-05-2013 / 13:59:17 / houzvjir@fel.cvut.cz"
!

test_K_TranslateFunc_8

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-TranslateFunc-8                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `translate("abcdabc", "abc", "AB") eq "ABdAB"`. :)
(:*******************************************************:)
translate("abcdabc", "abc", "AB") eq "ABdAB"
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/K-TranslateFunc-8.txt')

    "Created: / 13-05-2013 / 13:59:48 / houzvjir@fel.cvut.cz"
!

test_K_TranslateFunc_9

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-TranslateFunc-9                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `translate("bar","abc","ABC") eq "BAr"`. :)
(:*******************************************************:)
translate("bar","abc","ABC") eq "BAr"
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/K-TranslateFunc-9.txt')

    "Created: / 13-05-2013 / 14:00:07 / houzvjir@fel.cvut.cz"
!

test_K_UpperCaseFunc_1

    | query result |

    query := ' 
(: Name: fn-upper-case-1 :)
(: Description: Evaluation of upper-case function as per example 1 (for this function) :)
(: from the F&O specs.   :)

fn:upper-case("ABc!!D") 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UppeerCaseFunc/K-UpperCaseFunc-1.txt')

    "Created: / 11-05-2013 / 19:21:04 / jirka"
!

test_K_UpperCaseFunc_2

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-UpperCaseFunc-2                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `upper-case("string", "wrong param")`. :)
(:*******************************************************:)
upper-case("string", "wrong param")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UppeerCaseFunc/K-UpperCaseFunc-2.txt')

    "Created: / 11-05-2013 / 22:13:02 / houzvjir@fel.cvut.cz"
!

test_K_UpperCaseFunc_3

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-UpperCaseFunc-3                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `upper-case(()) eq ""`. :)
(:*******************************************************:)
upper-case(()) eq ""
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UppeerCaseFunc/K-UpperCaseFunc-3.txt')

    "Created: / 11-05-2013 / 22:14:15 / houzvjir@fel.cvut.cz"
!

test_K_UpperCaseFunc_4

    | query result |

    query := ' 
(:*******************************************************:)
(: Test: K-UpperCaseFunc-4                               :)
(: Written by: Frans Englich                             :)
(: Date: 2007-11-22T11:31:22+01:00                       :)
(: Purpose: A test whose essence is: `lower-case("ABc!!D") eq "abc!!d"`. :)
(:*******************************************************:)
lower-case("ABc!!D") eq "abc!!d"
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UppeerCaseFunc/K-UpperCaseFunc-4.txt')

    "Created: / 11-05-2013 / 22:14:38 / houzvjir@fel.cvut.cz"
!

test_fn_ends_with2args_1

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: ends-with2args-1                                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "ends-with" function            :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string(lower bound)                         :)
(:$arg2 = xs:string(lower bound)                         :)
(:*******************************************************:)

fn:ends-with(xs:string("This is a characte"),xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with2args-1.txt')

    "Created: / 11-05-2013 / 22:35:13 / houzvjir@fel.cvut.cz"
!

test_fn_ends_with2args_2

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: ends-with2args-2                                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "ends-with" function            :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string(mid range)                           :)
(:$arg2 = xs:string(lower bound)                         :)
(:*******************************************************:)

fn:ends-with(xs:string("This is a characte"),xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with2args-2.txt')

    "Created: / 11-05-2013 / 22:36:19 / houzvjir@fel.cvut.cz"
!

test_fn_ends_with2args_3

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: ends-with2args-3                                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "ends-with" function            :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string(upper bound)                         :)
(:$arg2 = xs:string(lower bound)                         :)
(:*******************************************************:)

fn:ends-with(xs:string("This is a characte"),xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with2args-3.txt')

    "Created: / 11-05-2013 / 22:36:55 / houzvjir@fel.cvut.cz"
!

test_fn_ends_with2args_4

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: ends-with2args-4                                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "ends-with" function            :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string(lower bound)                         :)
(:$arg2 = xs:string(mid range)                           :)
(:*******************************************************:)

fn:ends-with(xs:string("This is a characte"),xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with2args-4.txt')

    "Created: / 11-05-2013 / 22:37:23 / houzvjir@fel.cvut.cz"
!

test_fn_ends_with2args_5

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: ends-with2args-5                                  :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "ends-with" function            :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string(lower bound)                         :)
(:$arg2 = xs:string(upper bound)                         :)
(:*******************************************************:)

fn:ends-with(xs:string("This is a characte"),xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with2args-5.txt')

    "Created: / 11-05-2013 / 22:38:04 / houzvjir@fel.cvut.cz"
!

test_fn_ends_with_1

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-1                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = ""                                             :)
(:*******************************************************:)

fn:ends-with("","")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-1.txt')

    "Created: / 11-05-2013 / 19:21:47 / jirka"
    "Modified: / 18-05-2013 / 10:15:04 / houzvjir@fel.cvut.cz"
!

test_fn_ends_with_10

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-10                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = " "                                            :)
(:$arg2 = " AAAAABBBBB"                                  :)
(:*******************************************************:)

fn:ends-with(" ","AAAAABBBBB")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-10.txt')

    "Created: / 11-05-2013 / 19:21:58 / jirka"
!

test_fn_ends_with_11

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-11                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(:using it as a argument of a fn:not - returns false     :)
(:*******************************************************:)

fn:not(fn:ends-with("A","A"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-11.txt')

    "Created: / 11-05-2013 / 19:22:22 / jirka"
!

test_fn_ends_with_12

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-12                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(:using it as a argument of a fn:not - returns true      :)
(:*******************************************************:)

fn:not(fn:ends-with("A","B"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-12.txt')

    "Created: / 11-05-2013 / 19:22:42 / jirka"
!

test_fn_ends_with_13

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-13                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string("A")                                 :)
(:$arg2 = "A"                                            :)
(:*******************************************************:)

fn:ends-with(xs:string("A"),"A")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-13.txt')

    "Created: / 11-05-2013 / 19:22:57 / jirka"
!

test_fn_ends_with_14

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-14                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A"                                            :)
(:$arg2 = xs:string("A")                                 :)
(:*******************************************************:)

fn:ends-with("A",xs:string("A"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-14.txt')

    "Created: / 11-05-2013 / 19:23:10 / jirka"
!

test_fn_ends_with_15

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-15                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A"                                            :)
(:$arg2 = "a"                                            :)
(:*******************************************************:)

fn:ends-with("A","a")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-15.txt')

    "Created: / 11-05-2013 / 19:23:20 / jirka"
!

test_fn_ends_with_16

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-16                                  :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function            :)
(: with the arguments set as follows:                    :)
(:$arg1 = "a"                                            :)
(:$arg2 = "A"                                            :)
(:*******************************************************:)

fn:ends-with("a","A")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-16.txt')

    "Created: / 11-05-2013 / 19:23:37 / jirka"
!

test_fn_ends_with_2

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-2                                   :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function            :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:ends-with("","A Character String")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-2.txt')

    "Created: / 11-05-2013 / 19:23:52 / jirka"
    "Modified: / 18-05-2013 / 13:22:13 / houzvjir@fel.cvut.cz"
!

test_fn_ends_with_3

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-3                                   :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function            :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:ends-with("A Character String","")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-3.txt')

    "Created: / 11-05-2013 / 19:24:08 / jirka"
!

test_fn_ends_with_4

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-4                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = ()                                             :)
(:$arg2 = ""                                             :)
(:*******************************************************:)

fn:ends-with((),"")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-4.txt')

    "Created: / 11-05-2013 / 19:24:29 / jirka"
!

test_fn_ends_with_5

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-5                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = ()                                             :)
(:*******************************************************:)

fn:ends-with("",())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-5.txt')

    "Created: / 11-05-2013 / 19:24:42 / jirka"
!

test_fn_ends_with_6

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-6                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A Character String"                           :)
(:$arg2 = ()                                             :)
(:*******************************************************:)

fn:ends-with("A Character String",())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-6.txt')

    "Created: / 11-05-2013 / 19:24:53 / jirka"
!

test_fn_ends_with_7

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-7                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = ()                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:ends-with((),"A Character String")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-7.txt')

    "Created: / 11-05-2013 / 19:25:02 / jirka"
!

test_fn_ends_with_8

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-8                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "AAAAABBBBBCCCCC"                              :)
(:$arg2 = "BBBBB"                                        :)
(:*******************************************************:)

fn:ends-with("AAAAABBBBBCCCCC","BBBBB")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-8.txt')

    "Created: / 11-05-2013 / 19:25:12 / jirka"
!

test_fn_ends_with_9

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-ends-with-9                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "ends-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "AAAAABBBBB"                                   :)
(:$arg2 = " "                                            :)
(:*******************************************************:)

fn:ends-with("AAAAABBBBB"," ")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/EndsWithFunc/fn-ends-with-9.txt')

    "Created: / 11-05-2013 / 19:25:21 / jirka"
!

test_fn_lower_case_1

    | query result |

    query := ' 
(: Name: fn-lower-case-1 :)
(: Description: Evaluation of lower-case function as per example 1 (for this function) :)
(: from the F&O specs.   :)

fn:lower-case("ABc!!D")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-1.txt')

    "Created: / 11-05-2013 / 19:32:03 / jirka"
!

test_fn_lower_case_10

    | query result |

    query := ' 
(: Name: fn-lower-case-10 :)
(: Description: Evaluation of lower-case function with argument set to "*****":)

fn:lower-case("*****") 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-10.txt')

    "Created: / 11-05-2013 / 19:32:27 / jirka"
!

test_fn_lower_case_11

    | query result |

    query := ' 
(: Name: fn-lower-case-11 :)
(: Description: Evaluation of lower-case function with argument set to another lower-case function:)

fn:lower-case(lower-case("zzzzz")) 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-11.txt')

    "Created: / 11-05-2013 / 19:32:45 / jirka"
!

test_fn_lower_case_12

    | query result |

    query := ' 
(: Name: fn-lower-case-12 :)
(: Description: Evaluation of lower-case function as an argument to the "fn:boolean" function:)

fn:boolean(fn:lower-case("abcde")) 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-12.txt')

    "Created: / 11-05-2013 / 19:32:58 / jirka"
!

test_fn_lower_case_13

    | query result |

    query := ' 
(: Name: fn-lower-case-13 :)
(: Description: Evaluation of lower-case function as an argument to the "fn:concat" function:)

fn:concat(fn:lower-case("abcde"), fn:lower-case("fghi")) 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-13.txt')

    "Created: / 11-05-2013 / 19:33:12 / jirka"
!

test_fn_lower_case_14

    | query result |

    query := ' 
(: Name: fn-lower-case-14 :)
(: Description: Evaluation of lower-case function as an argument to the "fn:not" function:)

fn:not(fn:lower-case("abcde")) 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-14.txt')

    "Created: / 11-05-2013 / 19:33:25 / jirka"
!

test_fn_lower_case_15

    | query result |

    query := ' 
(: Name: fn-lower-case-15 :)
(: Description: Evaluation of lower-case function with argument set to "%$#@!!":)

fn:lower-case("%$#@!!") 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-15.txt')

    "Created: / 11-05-2013 / 19:33:35 / jirka"
!

test_fn_lower_case_16

    | query result |

    query := ' 
(: Name: fn-lower-case-16 :)
(: Description: Evaluation of lower-case function with argument set to "lower-case":)

fn:lower-case("lower-case") 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-16.txt')

    "Created: / 11-05-2013 / 19:33:49 / jirka"
!

test_fn_lower_case_17

    | query result |

    query := ' 
(: Name: fn-lower-case-17 :)
(: Description: Evaluation of lower-case function as part of a boolean expression:)

fn:lower-case("abc") and fn:lower-case("abc")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-17.txt')

    "Created: / 11-05-2013 / 19:34:02 / jirka"
!

test_fn_lower_case_2

    | query result |

    query := ' 
(: Name: fn-lower-case-2 :)
(: Description: Evaluation of lower-case function using the empty sequence :)
(: Uses the count function to avoid empty file.   :)

fn:count(fn:lower-case(())) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-2.txt')

    "Created: / 11-05-2013 / 19:34:15 / jirka"
!

test_fn_lower_case_3

    | query result |

    query := ' 
(: Name: fn-lower-case-3 :)
(: Description: Evaluation of lower-case function that uses only numbers as part of argument:)
(: Use of count function to avoid empty file. :)

fn:lower-case("12345") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-3.txt')

    "Created: / 11-05-2013 / 19:34:27 / jirka"
!

test_fn_lower_case_4

    | query result |

    query := ' 
(: Name: fn-lower-case-4 :)
(: Description: Evaluation of lower-case function that uses both numbers and letters as part of argument:)

fn:lower-case("12345abcd") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-4.txt')

    "Created: / 11-05-2013 / 19:34:41 / jirka"
!

test_fn_lower_case_5

    | query result |

    query := ' 
(: Name: fn-lower-case-5 :)
(: Description: Evaluation of lower-case function that uses only upper case letters as part of argument:)

fn:lower-case("ABCD") 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-5.txt')

    "Created: / 11-05-2013 / 19:34:52 / jirka"
!

test_fn_lower_case_6

    | query result |

    query := ' 
(: Name: fn-lower-case-6 :)
(: Description: Evaluation of lower-case function that uses only lower case letters as part of argument:)

fn:lower-case("abcde") 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-6.txt')

    "Created: / 11-05-2013 / 19:35:04 / jirka"
!

test_fn_lower_case_7

    | query result |

    query := ' 
(: Name: fn-lower-case-7 :)
(: Description: Evaluation of lower-case function that uses both upper and lower case letters as part of argument:)

fn:lower-case("ABCDEabcde") 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-7.txt')

    "Created: / 11-05-2013 / 19:35:15 / jirka"
!

test_fn_lower_case_8

    | query result |

    query := ' 
(: Name: fn-lower-case-8 :)
(: Description: Evaluation of lower-case function that uses the empty string as part of argument:)
(: Uses "fn:count" to avoid the empty file  :)

fn:count(fn:lower-case(""))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-8.txt')

    "Created: / 11-05-2013 / 19:35:26 / jirka"
!

test_fn_lower_case_9

    | query result |

    query := ' 
(: Name: fn-lower-case-9 :)
(: Description: Evaluation of lower-case function that uses the "upper-case" as part of argument:)

fn:lower-case(upper-case("AbcDH")) 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case-9.txt')

    "Created: / 11-05-2013 / 19:35:41 / jirka"
!

test_fn_lower_case_largs_1

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: lower-case1args-1                                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:47 GMT-05:00 2004                :)
(:Purpose: Evaluates The "lower-case" function           :)
(: with the arguments set as follows:                    :)
(:$arg = xs:string(lower bound)                          :)
(:*******************************************************:)

fn:lower-case(xs:string("This is a characte"))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case1args-1.txt')

    "Created: / 11-05-2013 / 19:35:54 / jirka"
!

test_fn_lower_case_largs_2

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: lower-case1args-2                                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:47 GMT-05:00 2004                :)
(:Purpose: Evaluates The "lower-case" function           :)
(: with the arguments set as follows:                    :)
(:$arg = xs:string(mid range)                            :)
(:*******************************************************:)

fn:lower-case(xs:string("This is a characte"))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case1args-2.txt')

    "Created: / 11-05-2013 / 19:36:18 / jirka"
!

test_fn_lower_case_largs_3

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: lower-case1args-3                                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:47 GMT-05:00 2004                :)
(:Purpose: Evaluates The "lower-case" function           :)
(: with the arguments set as follows:                    :)
(:$arg = xs:string(upper bound)                          :)
(:*******************************************************:)

fn:lower-case(xs:string("This is a characte"))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/LowerCaseFunc/fn-lower-case1args-3.txt')

    "Created: / 11-05-2013 / 19:36:50 / jirka"
!

test_fn_matches_1

    | query result |

    query := ' 
(: Name: fn-matches-1 :)
(: Description: Evaluation of matches function as per example 1 (for this function) :)


fn:matches("abracadabra", "bra")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-1.txt')

    "Created: / 11-05-2013 / 19:25:37 / jirka"
!

test_fn_matches_10

    | query result |

    query := ' 
(: Name: fn-matches-10 :)
(: Description: Evaluation of matches function with pattern set to "\{" for an input string that contains "}". :)

fn:matches("abracadabra{abracadabra", "\{")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-10.txt')

    "Created: / 11-05-2013 / 19:25:50 / jirka"
!

test_fn_matches_11

    | query result |

    query := ' 
(: Name: fn-matches-11 :)
(: Description: Evaluation of matches function with pattern set to "\}" for an input string that contains "}". :)

fn:matches("abracadabra}abracadabra", "\}")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-11.txt')

    "Created: / 11-05-2013 / 19:26:02 / jirka"
!

test_fn_matches_12

    | query result |

    query := ' 
(: Name: fn-matches-12 :)
(: Description: Evaluation of matches function with pattern set to "\(" for an input string that contains "(". :)

fn:matches("abracadabra(abracadabra", "\(")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-12.txt')

    "Created: / 11-05-2013 / 19:26:11 / jirka"
!

test_fn_matches_13

    | query result |

    query := ' 
(: Name: fn-matches-13 :)
(: Description: Evaluation of matches function with pattern set to "\)" for an input string that contains ")". :)

fn:matches("abracadabra)abracadabra", "\)")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-13.txt')

    "Created: / 11-05-2013 / 19:26:22 / jirka"
!

test_fn_matches_14

    | query result |

    query := ' 
(: Name: fn-matches-14 :)
(: Description: Evaluation of matches function with pattern set to "\[" for an input string that contains "[". :)

fn:matches("abracadabra[abracadabra", "\[")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-14.txt')

    "Created: / 11-05-2013 / 19:26:33 / jirka"
!

test_fn_matches_15

    | query result |

    query := ' 
(: Name: fn-matches-15 :)
(: Description: Evaluation of matches function with pattern set to "\]" for an input string that contains "]". :)

fn:matches("abracadabra]abracadabra", "\]")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-15.txt')

    "Created: / 11-05-2013 / 19:26:42 / jirka"
!

test_fn_matches_16

    | query result |

    query := ' 
(: Name: fn-matches-16 :)
(: Description: Evaluation of matches function with pattern set to "\-" for an input string that contains "-". :)

fn:matches("abracadabra-abracadabra", "\-")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-16.txt')

    "Created: / 11-05-2013 / 19:26:51 / jirka"
!

test_fn_matches_17

    | query result |

    query := ' 
(: Name: fn-matches-17 :)
(: Description: Evaluation of matches function with pattern set to "\." for an input string that contains ".". :)

fn:matches("abracadabra.abracadabra", "\.")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-17.txt')

    "Created: / 11-05-2013 / 19:27:00 / jirka"
!

test_fn_matches_18

    | query result |

    query := ' 
(: Name: fn-matches-18 :)
(: Description: Evaluation of matches function with pattern set to "\|" for an input string that contains "|". :)

fn:matches("abracadabra|abracadabra", "\|")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-18.txt')

    "Created: / 11-05-2013 / 19:27:09 / jirka"
!

test_fn_matches_19

    | query result |

    query := ' 
(: Name: fn-matches-19 :)
(: Description: Evaluation of matches function with pattern set to "\\" for an input string that contains "\". :)

fn:matches("abracadabra\abracadabra", "\\")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-19.txt')

    "Created: / 11-05-2013 / 19:27:18 / jirka"
!

test_fn_matches_2

    | query result |

    query := ' 
(: Name: fn-matches-2 :)
(: Description: Evaluation of matches function as per example 2 (for this function).  Pattern set to "^a.*a$". :)


fn:matches("abracadabra", "^a.*a$")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-2.txt')

    "Created: / 11-05-2013 / 19:27:29 / jirka"
!

test_fn_matches_20

    | query result |

    query := ' 
(: Name: fn-matches-20 :)
(: Description: Evaluation of matches function with pattern set to "\t" for an input string that contains the tab character. :)

fn:matches("abracadabra abracadabra", "\t")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-20.txt')

    "Created: / 11-05-2013 / 19:27:46 / jirka"
!

test_fn_matches_21

    | query result |

    query := ' 
(: Name: fn-matches-21 :)
(: Description: Evaluation of matches function with pattern set to "\n" for an input string that contains the newline character. :)

fn:matches("abracadabra
abracadabra", "\n")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-21.txt')

    "Created: / 11-05-2013 / 19:28:08 / jirka"
!

test_fn_matches_22

    | query result |

    query := ' 
(: Name: fn-matches-22 :)
(: Description: Evaluation of matches function with pattern set to "aa{1}" (exact quantity) for an input string that contains the "aa" string. :)

fn:matches("abracadabraabracadabra", "aa{1}")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-22.txt')

    "Created: / 11-05-2013 / 19:28:20 / jirka"
!

test_fn_matches_23

    | query result |

    query := ' 
(: Name: fn-matches-23 :)
(: Description: Evaluation of matches function with pattern set to "aa{1,}" (min quantity) for an input string that contains the "aa" string twice. :)

fn:matches("abracadabraabracadabraabracadabra", "aa{1,}")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-23.txt')

    "Created: / 11-05-2013 / 19:28:31 / jirka"
!

test_fn_matches_24

    | query result |

    query := ' 
(: Name: fn-matches-24 :)
(: Description: Evaluation of matches function with pattern set to "aa{1,2}" (range quantity) for an input string that contains the "aa" string twice. :)

fn:matches("abracadabraabracadabraabracadabra", "aa{1,2}")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-24.txt')

    "Created: / 11-05-2013 / 19:28:40 / jirka"
!

test_fn_matches_25

    | query result |

    query := ' 
(: Name: fn-matches-25 :)
(: Description: Evaluation of matches function with invalid regular expression :)


fn:matches("abracadabra", "**%%")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-25.txt')

    "Created: / 11-05-2013 / 19:28:47 / jirka"
!

test_fn_matches_26

    | query result |

    query := ' 
(: Name: fn-matches-26 :)
(: Description: Check for the correct behavior of ^ and $ in multi-line mode :)
(: This test case was motivated by the resolution of Bug Report 4543 :)


fn:matches("abcd&#x0a;defg&#x0a;", "^$", "m")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-26.txt')

    "Created: / 11-05-2013 / 19:28:57 / jirka"
!

test_fn_matches_27

    | query result |

    query := ' 
(: Name: fn-matches-27 :)
(: Description: Check for the correct behavior of ^ and $ in multi-line mode :)
(: This test case was motivated by the resolution of Bug Report 4543 :)


fn:matches("&#x0a;abcd&#x0a;defg&#x0a;", "^$", "m")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-27.txt')

    "Created: / 11-05-2013 / 19:29:08 / jirka"
!

test_fn_matches_28

    | query result |

    query := ' 
(: Name: fn-matches-28 :)
(: Description: Check for the correct behavior of ^ and $ in multi-line mode :)
(: This test case was motivated by the resolution of Bug Report 4543 :)


fn:matches("abcd&#x0a;&#x0a;defg&#x0a;", "^$", "m")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-28.txt')

    "Created: / 11-05-2013 / 19:29:16 / jirka"
!

test_fn_matches_29

    | query result |

    query := ' 
(: Name: fn-matches-29 :)
(: Description: 2-digits not treated as a back-reference :)
(: See erratum FO.E24 :)


fn:matches("#abc#1", "^(#)abc\11$")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-29.txt')

    "Created: / 11-05-2013 / 19:29:24 / jirka"
!

test_fn_matches_3

    | query result |

    query := ' 
(: Name: fn-matches-3 :)
(: Description: Evaluation of matches function as per example 3 (for this function).  Pattern set to "^bra" :)

fn:matches("abracadabra", "^bra") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-3.txt')

    "Created: / 11-05-2013 / 19:29:34 / jirka"
!

test_fn_matches_30

    | query result |

    query := ' 
(: Name: fn-matches-30 :)
(: Description: 2-digits treated as a back-reference :)
(: See erratum FO.E24 :)


fn:matches("#abcdefghijklmnopq#1", "^(#)(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n)(o)(p)(q)\11$")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-30.txt')

    "Created: / 11-05-2013 / 19:29:42 / jirka"
!

test_fn_matches_31

    | query result |

    query := ' 
xquery version "1.1";

(: Name: fn-matches-31 :)
(: Description: Evaluation of matches function with non-capturing groups (allowed in XQuery 1.1 :)


fn:matches("abracadabra", "(?:abra(?:cad)?)*")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-31.txt')

    "Created: / 11-05-2013 / 19:29:55 / jirka"
!

test_fn_matches_32

    | query result |

    query := ' 
xquery version "1.1";

(: Name: fn-matches-32 :)
(: Description: Evaluation of matches function with "q" flag (allowed in XQuery 1.1 :)


fn:matches("abracadabra", "(?:abra(?:cad)?)*", "q")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-32.txt')

    "Created: / 11-05-2013 / 19:30:06 / jirka"
!

test_fn_matches_33

    | query result |

    query := ' 
xquery version "1.1";
(: Name: fn-matches-33 :)
(: Description: Evaluation of matches function with "q" flag (allowed in XQuery 1.1 :)


fn:matches("x[y-z]", "x[y-z]", "q")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-33.txt')

    "Created: / 11-05-2013 / 19:30:15 / jirka"
!

test_fn_matches_34

    | query result |

    query := ' 
xquery version "1.1";

(: Name: fn-matches-33 :)
(: Description: Evaluation of matches function with "q" and "i" flags (allowed in XQuery 1.1 :)


fn:matches("x[Y-z]", "X[y-Z]", "qi")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-34.txt')

    "Created: / 11-05-2013 / 19:30:24 / jirka"
!

test_fn_matches_4

    | query result |

    query := ' 
(: Name: fn-matches-4 :)
(: Description: Test that calling the function with flags set to the empty string is the same as ommiting the flags.:)

fn:concat(fn:matches("abracadabra", "^bra"),fn:matches("abracadabra", "^bra", ""))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-4.txt')

    "Created: / 11-05-2013 / 19:30:34 / jirka"
!

test_fn_matches_5

    | query result |

    query := ' 
(: Name: fn-matches-5 :)
(: Description: Evaluate the fn:mathes function with the input string set to the empty sequence.:)
(: fn:count used to avoid empty file.   :)

fn:count(fn:matches("()", "^bra"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-5.txt')

    "Created: / 11-05-2013 / 19:30:43 / jirka"
!

test_fn_matches_6

    | query result |

    query := ' 
(: Name: fn-matches-6 :)
(: Description: Evaluation of matches function with pattern set to "\^". :)

fn:matches("abracadabra^abracadabra", "\^")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-6.txt')

    "Created: / 11-05-2013 / 19:30:52 / jirka"
!

test_fn_matches_7

    | query result |

    query := ' 
(: Name: fn-matches-7 :)
(: Description: Evaluation of matches function with pattern set to "\?" for an input string that contains "?". :)

fn:matches("abracadabra?abracadabra", "\?")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-7.txt')

    "Created: / 11-05-2013 / 19:31:05 / jirka"
!

test_fn_matches_8

    | query result |

    query := ' 
(: Name: fn-matches-8 :)
(: Description: Evaluation of matches function with pattern set to "\*" for an input string that contains "*". :)

fn:matches("abracadabra*abracadabra", "\*")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-8.txt')

    "Created: / 11-05-2013 / 19:31:16 / jirka"
!

test_fn_matches_9

    | query result |

    query := ' 
(: Name: fn-matches-9 :)
(: Description: Evaluation of matches function with pattern set to "\+" for an input string that contains "+". :)

fn:matches("abracadabra+abracadabra", "\+")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/MatchStringFunc/MatchesFunc/fn-matches-9.txt')

    "Created: / 11-05-2013 / 19:31:28 / jirka"
!

test_fn_starts_with2args_1

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: starts-with2args-1                                :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string(lower bound)                         :)
(:$arg2 = xs:string(lower bound)                         :)
(:*******************************************************:)

fn:starts-with(xs:string("This is a characte"),xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with2args-1.txt')

    "Created: / 11-05-2013 / 22:59:43 / houzvjir@fel.cvut.cz"
!

test_fn_starts_with2args_2

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: starts-with2args-2                                :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string(mid range)                           :)
(:$arg2 = xs:string(lower bound)                         :)
(:*******************************************************:)

fn:starts-with(xs:string("This is a characte"),xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with2args-2.txt')

    "Created: / 11-05-2013 / 23:00:30 / houzvjir@fel.cvut.cz"
!

test_fn_starts_with2args_3

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: starts-with2args-3                                :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string(upper bound)                         :)
(:$arg2 = xs:string(lower bound)                         :)
(:*******************************************************:)

fn:starts-with(xs:string("This is a characte"),xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with2args-3.txt')

    "Created: / 11-05-2013 / 23:01:10 / houzvjir@fel.cvut.cz"
!

test_fn_starts_with2args_4

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: starts-with2args-4                                :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string(lower bound)                         :)
(:$arg2 = xs:string(mid range)                           :)
(:*******************************************************:)

fn:starts-with(xs:string("This is a characte"),xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with2args-4.txt')

    "Created: / 11-05-2013 / 23:01:41 / houzvjir@fel.cvut.cz"
!

test_fn_starts_with2args_5

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: starts-with2args-5                                :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string(lower bound)                         :)
(:$arg2 = xs:string(upper bound)                         :)
(:*******************************************************:)

fn:starts-with(xs:string("This is a characte"),xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with2args-5.txt')

    "Created: / 11-05-2013 / 23:02:08 / houzvjir@fel.cvut.cz"
!

test_fn_starts_with_1

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-1                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = ""                                             :)
(:*******************************************************:)

fn:starts-with("","")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-1.txt')

    "Created: / 11-05-2013 / 19:37:01 / jirka"
!

test_fn_starts_with_10

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-10                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = " "                                            :)
(:$arg2 = " AAAAABBBBB"                                  :)
(:*******************************************************:)

fn:starts-with(" ","AAAAABBBBB")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-10.txt')

    "Created: / 11-05-2013 / 19:37:15 / jirka"
!

test_fn_starts_with_11

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-11                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(:using it as a argument of a fn:not - returns false     :)
(:*******************************************************:)

fn:not(fn:starts-with("A","A"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-11.txt')

    "Created: / 11-05-2013 / 19:37:25 / jirka"
!

test_fn_starts_with_12

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-12                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(:using it as a argument of a fn:not - returns true      :)
(:*******************************************************:)

fn:not(fn:starts-with("A","B"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-12.txt')

    "Created: / 11-05-2013 / 19:37:36 / jirka"
!

test_fn_starts_with_13

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-13                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string("A")                                 :)
(:$arg2 = "A"                                            :)
(:*******************************************************:)

fn:starts-with(xs:string("A"),"A")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-13.txt')

    "Created: / 11-05-2013 / 19:37:45 / jirka"
!

test_fn_starts_with_14

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-14                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A"                                            :)
(:$arg2 = xs:string("A")                                 :)
(:*******************************************************:)

fn:starts-with("A",xs:string("A"))'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-14.txt')

    "Created: / 11-05-2013 / 19:37:56 / jirka"
!

test_fn_starts_with_15

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-15                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A"                                            :)
(:$arg2 = "a"                                            :)
(:*******************************************************:)

fn:starts-with("A","a")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-15.txt')

    "Created: / 11-05-2013 / 19:38:05 / jirka"
!

test_fn_starts_with_16

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-16                                :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "a"                                            :)
(:$arg2 = "A"                                            :)
(:*******************************************************:)

fn:starts-with("a","A")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-16.txt')

    "Created: / 11-05-2013 / 19:38:14 / jirka"
!

test_fn_starts_with_2

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-2                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:starts-with("","A Character String")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-2.txt')

    "Created: / 11-05-2013 / 19:38:23 / jirka"
!

test_fn_starts_with_3

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-3                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:starts-with("A Character String","")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-3.txt')

    "Created: / 11-05-2013 / 19:38:38 / jirka"
!

test_fn_starts_with_4

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-4                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = ()                                             :)
(:$arg2 = ""                                             :)
(:*******************************************************:)

fn:starts-with((),"")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-4.txt')

    "Created: / 11-05-2013 / 19:38:48 / jirka"
!

test_fn_starts_with_5

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-5                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = ()                                             :)
(:*******************************************************:)

fn:starts-with("",())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-5.txt')

    "Created: / 11-05-2013 / 19:39:11 / jirka"
!

test_fn_starts_with_6

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-6                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A Character String"                           :)
(:$arg2 = ()                                             :)
(:*******************************************************:)

fn:starts-with("A Character String",())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-6.txt')

    "Created: / 11-05-2013 / 19:39:24 / jirka"
!

test_fn_starts_with_7

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-7                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = ()                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:starts-with((),"A Character String")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-7.txt')

    "Created: / 11-05-2013 / 19:39:31 / jirka"
!

test_fn_starts_with_8

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-8                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "AAAAABBBBBCCCCC"                              :)
(:$arg2 = "BBBBB"                                        :)
(:*******************************************************:)

fn:starts-with("AAAAABBBBBCCCCC","BBBBB")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-8.txt')

    "Created: / 11-05-2013 / 19:39:40 / jirka"
!

test_fn_starts_with_9

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-starts-with-9                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "starts-with" function          :)
(: with the arguments set as follows:                    :)
(:$arg1 = "AAAAABBBBB"                                   :)
(:$arg2 = " "                                            :)
(:*******************************************************:)

fn:starts-with("AAAAABBBBB"," ")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/StartsWithFunc/fn-starts-with-9.txt')

    "Created: / 11-05-2013 / 19:39:51 / jirka"
    "Modified: / 12-05-2013 / 12:40:40 / houzvjir@fel.cvut.cz"
!

test_fn_string_length1args_1

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: string-length1args-1                              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "string-length" function        :)
(: with the arguments set as follows:                    :)
(:$arg = xs:string(lower bound)                          :)
(:*******************************************************:)

fn:string-length(xs:string("This is a characte"))

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length1args-1.txt')

    "Created: / 12-05-2013 / 13:18:59 / houzvjir@fel.cvut.cz"
!

test_fn_string_length1args_2

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: string-length1args-2                              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "string-length" function        :)
(: with the arguments set as follows:                    :)
(:$arg = xs:string(mid range)                            :)
(:*******************************************************:)

fn:string-length(xs:string("This is a characte"))

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length1args-2.txt')

    "Created: / 12-05-2013 / 13:21:24 / houzvjir@fel.cvut.cz"
!

test_fn_string_length1args_3

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: string-length1args-3                              :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:46 GMT-05:00 2004                :)
(:Purpose: Evaluates The "string-length" function        :)
(: with the arguments set as follows:                    :)
(:$arg = xs:string(upper bound)                          :)
(:*******************************************************:)

fn:string-length(xs:string("This is a characte"))

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length1args-3.txt')

    "Created: / 12-05-2013 / 13:22:16 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_1

    | query result |

    query := ' 
(: Name: fn-string-length-1 :)
(: Description: Evaluation of string-length function as per example 1 (for this function) :)
(: from the F&O specs.   :)

fn:string-length("Harp not on that string, madam; that is past.")  
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-1.txt')

    "Created: / 12-05-2013 / 12:20:28 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 13:14:03 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_10

    | query result |

    query := ' 
(: Name: fn-string-length-10 :)
(: Description: Evaluation of string-length function with argument set to "*****":)

fn:string-length("*****") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-10.txt')

    "Created: / 12-05-2013 / 12:55:05 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_11

    | query result |

    query := ' 
(: Name: fn-string-length-11 :)
(: Description: Evaluation of string-length function as part of an addition operation:)

fn:string-length("zzzzz") + fn:string-length("zzzzz")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-11.txt')

    "Created: / 12-05-2013 / 12:56:04 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_12

    | query result |

    query := ' 
(: Name: fn-string-length-12 :)
(: Description: Evaluation of string-length function as an argument to the "fn:boolean" function:)

fn:boolean(fn:string-length("abcde")) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-12.txt')

    "Created: / 12-05-2013 / 12:56:28 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_13

    | query result |

    query := ' 
(: Name: fn-string-length-13 :)
(: Description: Evaluation of string-length function as an argument to the "fn:concat" function:)

fn:concat(fn:string-length("abcde"), fn:string-length("fghi")) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-13.txt')

    "Created: / 12-05-2013 / 12:56:49 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_14

    | query result |

    query := ' 
(: Name: fn-string-length-14 :)
(: Description: Evaluation of string-length function as an argument to the "fn:not" function:)

fn:not(fn:string-length("abcde")) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-14.txt')

    "Created: / 12-05-2013 / 12:57:14 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_15

    | query result |

    query := ' 
(: Name: fn-string-length-15 :)
(: Description: Evaluation of string-length function with argument set to "%$#@!!":)

fn:string-length("%$#@!!") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-15.txt')

    "Created: / 12-05-2013 / 12:57:40 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_16

    | query result |

    query := ' 
(: Name: fn-string-length-16 :)
(: Description: Evaluation of string-length function with argument set to "string-length":)

fn:string-length("string-length") '.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-16.txt')

    "Created: / 12-05-2013 / 12:58:18 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_17

    | query result |

    query := ' 
(: Name: fn-string-length-17 :)
(: Description: Evaluation of string-length function as part of a boolean expression:)

fn:string-length("abc") and fn:string-length("abc")'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-17.txt')

    "Created: / 12-05-2013 / 13:00:38 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_18

    | query result |

    query := ' 
(: Name: fn-string-length-18 :)
(: Description: Evaluation of string-length function with no argument and no context item defined. :)

declare namespace eg = "http://example.org";

declare function eg:noContextFunction()
 {
   fn:string-length()
};

eg:noContextFunction()
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-18.txt')

    "Created: / 12-05-2013 / 13:01:17 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_19

    | query result |

    query := ' 
(:*******************************************************:)
(: Name: fn-string-length-19                             :)
(: Written By: Nicolae Brinza                            :)
(: Description: Evaluation of string-length function with:)
(: an argument that is a sequence of more than one item  :)

(: insert-start :)
declare variable $input-context external;
(: insert-end :)

fn:string-length( $input-context//location )

'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-19.txt')

    "Created: / 12-05-2013 / 13:17:04 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_2

    | query result |

    query := ' 
(: Name: fn-string-length-2 :)
(: Description: Evaluation of string-length function using the empty sequence :)

fn:string-length(())
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-2.txt')

    "Created: / 12-05-2013 / 12:39:09 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 13:22:27 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_3

    | query result |

    query := ' 
(: Name: fn-string-length-3 :)
(: Description: Evaluation of string-length function that uses only numbers as part of argument:)

fn:string-length("12345") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-3.txt')

    "Created: / 12-05-2013 / 12:44:33 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 13:15:36 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_4

    | query result |

    query := ' 
(: Name: fn-string-length-4 :)
(: Description: Evaluation of string-length function that uses both numbers and letters as part of argument:)

fn:string-length("12345abcd") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-4.txt')

    "Created: / 12-05-2013 / 12:51:52 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 13:16:12 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_5

    | query result |

    query := ' 
(: Name: fn-string-length-5 :)
(: Description: Evaluation of string-length function that uses only upper case letters as part of argument:)

fn:string-length("ABCD") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-5.txt')

    "Created: / 12-05-2013 / 12:52:46 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 13:16:33 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_6

    | query result |

    query := ' 
(: Name: fn-string-length-6 :)
(: Description: Evaluation of string-length function that uses only lower case letters as part of argument:)

fn:string-length("abcde") '.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-6.txt')

    "Created: / 12-05-2013 / 12:53:10 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 13:16:46 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_7

    | query result |

    query := ' 
(: Name: fn-string-length-7 :)
(: Description: Evaluation of string-length function that uses both upper and lower case letters as part of argument:)

fn:string-length("ABCDEabcde") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-7.txt')

    "Created: / 12-05-2013 / 12:53:44 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 13:17:05 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_8

    | query result |

    query := ' 
(: Name: fn-string-length-8 :)
(: Description: Evaluation of string-length function that uses the empty string as part of argument:)

fn:string-length("")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-8.txt')

    "Created: / 12-05-2013 / 12:54:22 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 13:17:18 / houzvjir@fel.cvut.cz"
!

test_fn_string_length_9

    | query result |

    query := ' 
(: Name: fn-string-length-9 :)
(: Description: Evaluation of string-length function that uses the "string" as part of argument:)

fn:string-length(fn:string("AbcDH"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.

    result  := interpreter evaluate: query.

    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/StringLengthFunc/fn-string-length-9.txt')

    "Created: / 12-05-2013 / 12:54:32 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 13:18:26 / houzvjir@fel.cvut.cz"
!

test_fn_substring_1

    | query result |

    query := ' 
(: Name: fn-substring-1 :)
(: Description: Evaluation of substring function as per example 1 (for this function) :)
(: from the F&O specs.   :)

fn:substring("motor car", 6)
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-1.txt')

    "Created: / 09-05-2013 / 14:11:02 / houzvjir@fel.cvut.cz"
!

test_fn_substring_10

    | query result |

    query := ' 
(: Name: fn-substring-10 :)
(: Description: Evaluation of substring function as per example 10 (for this function) :)
(: from the F&O specs.   :)

fn:substring("12345", -42, 1 div 0E0) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-10.txt')

    "Created: / 09-05-2013 / 14:16:11 / houzvjir@fel.cvut.cz"
!

test_fn_substring_11

    | query result |

    query := ' 
(: Name: fn-substring-11 :)
(: Description: Evaluation of substring function as per example 11 (for this function) :)
(: from the F&O specs. Use "fn:count" to avoid empty file. :)

fn:count(fn:substring("12345", -1 div 0E0, 1 div 0E0))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-11.txt')

    "Created: / 09-05-2013 / 14:16:33 / houzvjir@fel.cvut.cz"
!

test_fn_substring_12

    | query result |

    query := ' 
(: Name: fn-substring-12 :)
(: Description: Evaluation of substring function, where the source string is the empty string :)
(: Use "fn:count" to avoid empty file. :)

fn:count(fn:substring("",0))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-12.txt')

    "Created: / 09-05-2013 / 14:17:07 / houzvjir@fel.cvut.cz"
!

test_fn_substring_13

    | query result |

    query := ' 
(: Name: fn-substring-13 :)
(: Description: Evaluation of substring function, as an argument to an "fn:boolean" function" :)

fn:boolean(fn:substring("ABC",1))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-13.txt')

    "Created: / 09-05-2013 / 14:17:30 / houzvjir@fel.cvut.cz"
!

test_fn_substring_14

    | query result |

    query := ' 
(: Name: fn-substring-14 :)
(: Description: Evaluation of substring function, as an argument to an "fn:not" function" :)

fn:not(fn:substring("ABC",1))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-14.txt')

    "Created: / 09-05-2013 / 14:17:57 / houzvjir@fel.cvut.cz"
!

test_fn_substring_15

    | query result |

    query := ' 
(: Name: fn-substring-15 :)
(: Description: Evaluation of substring function, as an argument to another "fn:substring" function" :)

fn:substring(fn:substring("ABCDE",1),1)
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-15.txt')

    "Created: / 09-05-2013 / 14:18:17 / houzvjir@fel.cvut.cz"
!

test_fn_substring_16

    | query result |

    query := ' 
(: Name: fn-substring-16 :)
(: Description: Evaluation of substring function, where the source string is the string "substring".:)

fn:substring("substring",1)
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-16.txt')

    "Created: / 09-05-2013 / 14:18:36 / houzvjir@fel.cvut.cz"
!

test_fn_substring_17

    | query result |

    query := ' 
(: Name: fn-substring-17 :)
(: Description: Evaluation of substring function as an argument to a concat function.:)

fn:concat(fn:substring("ABC",1),"DEF")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-17.txt')

    "Created: / 09-05-2013 / 14:18:54 / houzvjir@fel.cvut.cz"
!

test_fn_substring_18

    | query result |

    query := ' 
(: Name: fn-substring-18:)
(: Description: Evaluation of substring function as an argument to a contains function.:)

fn:contains(fn:substring("ABCDEF",1),"DEF")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-18.txt')

    "Created: / 09-05-2013 / 14:19:12 / houzvjir@fel.cvut.cz"
!

test_fn_substring_19

    | query result |

    query := ' 
(: Name: fn-substring-19:)
(: Description: Evaluation of substring function using the special chracter "!!@#$%^&*()".:)

fn:substring("!!@#$%^*()",1)
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-19.txt')

    "Created: / 09-05-2013 / 14:19:34 / houzvjir@fel.cvut.cz"
!

test_fn_substring_2

    | query result |

    query := ' 
(: Name: fn-substring-2 :)
(: Description: Evaluation of substring function as per example 2 (for this function) :)
(: from the F&O specs.   :)

fn:substring("metadata", 4, 3)
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-2.txt')

    "Created: / 09-05-2013 / 14:12:01 / houzvjir@fel.cvut.cz"
!

test_fn_substring_20

    | query result |

    query := ' 
(: Name: fn-substring-20:)
(: Description: Evaluation of substring function, where the start location uses a "double" constructor.:)

fn:substring("ABCD",xs:double(1))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-20.txt')

    "Created: / 09-05-2013 / 14:20:08 / houzvjir@fel.cvut.cz"
!

test_fn_substring_21

    | query result |

    query := ' 
(: Name: fn-substring-21:)
(: Description: Evaluation of substring function, where the starting locatin is an addition expression. :)

fn:substring("ABCDE",1+1)
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-21.txt')

    "Created: / 09-05-2013 / 14:20:33 / houzvjir@fel.cvut.cz"
!

test_fn_substring_3

    | query result |

    query := ' 
(: Name: fn-substring-3 :)
(: Description: Evaluation of substring function as per example 3 (for this function) :)
(: from the F&O specs.   :)

fn:substring("12345", 1.5, 2.6)
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-3.txt')

    "Created: / 09-05-2013 / 14:12:22 / houzvjir@fel.cvut.cz"
!

test_fn_substring_4

    | query result |

    query := ' 
(: Name: fn-substring-4 :)
(: Description: Evaluation of substring function as per example 4 (for this function) :)
(: from the F&O specs.   :)

fn:substring("12345", 0, 3)
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-4.txt')

    "Created: / 09-05-2013 / 14:13:09 / houzvjir@fel.cvut.cz"
!

test_fn_substring_5

    | query result |

    query := ' 
(: Name: fn-substring-5 :)
(: Description: Evaluation of substring function as per example 5 (for this function) :)
(: from the F&O specs.  Use "fn:count" to avoid empty file. :)

fn:count(fn:substring("12345", 5, -3))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-5.txt')

    "Created: / 09-05-2013 / 14:13:52 / houzvjir@fel.cvut.cz"
!

test_fn_substring_6

    | query result |

    query := ' 
(: Name: fn-substring-6 :)
(: Description: Evaluation of substring function as per example 6 (for this function) :)
(: from the F&O specs.   :)

fn:substring("12345", -3, 5)
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-6.txt')

    "Created: / 09-05-2013 / 14:14:28 / houzvjir@fel.cvut.cz"
!

test_fn_substring_7

    | query result |

    query := ' 
(: Name: fn-substring-7 :)
(: Description: Evaluation of substring function as per example 7 (for this function) :)
(: from the F&O specs.  Use "fn:count" to avoid empty file. :)

fn:count(fn:substring("12345", 0 div 0E0, 3))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-7.txt')

    "Created: / 09-05-2013 / 14:14:55 / houzvjir@fel.cvut.cz"
!

test_fn_substring_8

    | query result |

    query := ' 
(: Name: fn-substring-8 :)
(: Description: Evaluation of substring function as per example 8 (for this function) :)
(: from the F&O specs. Use "fn:count" to avoid empty file. :)

fn:count(fn:substring("12345", 1, 0 div 0E0))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-8.txt')

    "Created: / 09-05-2013 / 14:15:22 / houzvjir@fel.cvut.cz"
!

test_fn_substring_9

    | query result |

    query := ' 
(: Name: fn-substring-9 :)
(: Description: Evaluation of substring function as per example 9 (for this function) :)
(: from the F&O specs. Use "fn:count" to avoid empty file. :)

fn:count(fn:substring((), 1, 3))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/SubstringFunc/fn-substring-9.txt')

    "Created: / 09-05-2013 / 14:15:44 / houzvjir@fel.cvut.cz"
!

test_fn_substring_after_1

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-1                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = ""                                             :)
(:*******************************************************:)

fn:count(fn:substring-after("",""))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-1.txt')

    "Created: / 11-05-2013 / 19:40:00 / jirka"
!

test_fn_substring_after_10

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-10                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = " "                                            :)
(:$arg2 = " AAAAABBBBB"                                  :)
(:*******************************************************:)

fn:count(fn:substring-after(" ","AAAAABBBBB"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-10.txt')

    "Created: / 11-05-2013 / 19:40:16 / jirka"
!

test_fn_substring_after_11

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-11                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(:using it as a argument of a fn:not - returns true      :)
(:*******************************************************:)

fn:not(fn:substring-after("A","A"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-11.txt')

    "Created: / 11-05-2013 / 19:40:26 / jirka"
!

test_fn_substring_after_12

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-12                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(:using it as a argument of a fn:not - returns true      :)
(:*******************************************************:)

fn:not(fn:substring-after("A","B"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-12.txt')

    "Created: / 11-05-2013 / 19:40:34 / jirka"
!

test_fn_substring_after_13

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-13                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string("A")                                 :)
(:$arg2 = "A"                                            :)
(:*******************************************************:)

fn:count(fn:substring-after(xs:string("A"),"A"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-13.txt')

    "Created: / 11-05-2013 / 19:40:41 / jirka"
!

test_fn_substring_after_14

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-14                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A"                                            :)
(:$arg2 = xs:string("A")                                 :)
(:*******************************************************:)

fn:count(fn:substring-after("A",xs:string("A")))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-14.txt')

    "Created: / 11-05-2013 / 19:40:49 / jirka"
!

test_fn_substring_after_15

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-15                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A"                                            :)
(:$arg2 = "a"                                            :)
(:*******************************************************:)

fn:count(fn:substring-after("A","a"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-15.txt')

    "Created: / 11-05-2013 / 19:40:58 / jirka"
!

test_fn_substring_after_16

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-16                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "a"                                            :)
(:$arg2 = "A"                                            :)
(:*******************************************************:)

fn:count(fn:substring-after("a","A"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-16.txt')

    "Created: / 11-05-2013 / 19:41:07 / jirka"
!

test_fn_substring_after_17

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-17                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Mon Jun 1, 2005                                  :)
(:Purpose: Evaluates The "substring-after" function      :)
(: with the arguments set as follows:                    :)
(:$arg1 = "substring-after"                              :)
(:$arg2 = "substring-after"                              :)
(:*******************************************************:)

fn:count(fn:substring-after("substring-after","substring-after"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-17.txt')

    "Created: / 11-05-2013 / 19:41:26 / jirka"
!

test_fn_substring_after_18

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-18                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Mon Jun 1, 2005                                  :)
(:Purpose: Evaluates The "substring-after" function      :)
(: with the arguments set as follows:                    :)
(:$arg1 = "substring-aftersubstring-after"               :)
(:$arg2 = "substring-after"                              :)
(:*******************************************************:)

fn:substring-after("substring-aftersubstring-after","substring-after")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-18.txt')

    "Created: / 11-05-2013 / 19:41:52 / jirka"
!

test_fn_substring_after_19

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-19                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Mon Jun 1, 2005                                  :)
(:Purpose: Evaluates The "substring-after" function      :)
(: with the arguments set as follows:                    :)
(:$arg1 = "****"                                         :)
(:$arg2 = "***"                                          :)
(:*******************************************************:)

fn:substring-after("****","***")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-19.txt')

    "Created: / 11-05-2013 / 19:42:11 / jirka"
!

test_fn_substring_after_2

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-2                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:count(fn:substring-after("","A Character String"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-2.txt')

    "Created: / 11-05-2013 / 19:42:20 / jirka"
!

test_fn_substring_after_20

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-20                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Mon Jun 1, 2005                                  :)
(:Purpose: Evaluates The "substring-after" function      :)
(: with the arguments set as follows:                    :)
(:$arg1 = "12345"                                        :)
(:$arg2 = "1234"                                         :)
(:*******************************************************:)

fn:substring-after("12345","1234")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-20.txt')

    "Created: / 11-05-2013 / 19:42:30 / jirka"
!

test_fn_substring_after_21

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-21                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Mon Jun 1, 2005                                  :)
(:Purpose: Evaluates The "substring-after" function      :)
(: with the arguments set as follows:                    :)
(:$arg1 = "substring-after                               :)
(:$arg2 = "refta-gnirtsbus                               :)
(:("substring-after" backwards)                          :)
(:*******************************************************:)

count(fn:substring-after("substring-after","refta-gnirtsbus"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-21.txt')

    "Created: / 11-05-2013 / 19:42:40 / jirka"
!

test_fn_substring_after_3

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-3                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:count(fn:substring-after("A Character String",""))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-3.txt')

    "Created: / 11-05-2013 / 19:42:47 / jirka"
!

test_fn_substring_after_4

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-4                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ()                                             :)
(:$arg2 = ""                                             :)
(:*******************************************************:)

fn:count(fn:substring-after((),""))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-4.txt')

    "Created: / 11-05-2013 / 19:42:55 / jirka"
!

test_fn_substring_after_5

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-5                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = ()                                             :)
(:*******************************************************:)

fn:count(fn:substring-after("",()))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-5.txt')

    "Created: / 11-05-2013 / 19:43:05 / jirka"
!

test_fn_substring_after_6

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-6                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A Character String"                           :)
(:$arg2 = ()                                             :)
(:*******************************************************:)

fn:count(fn:substring-after("A Character String",()))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-6.txt')

    "Created: / 11-05-2013 / 19:43:14 / jirka"
!

test_fn_substring_after_7

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-7                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ()                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:count(fn:substring-after((),"A Character String"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-7.txt')

    "Created: / 11-05-2013 / 19:43:22 / jirka"
!

test_fn_substring_after_8

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-8                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "AAAAABBBBBCCCCC"                              :)
(:$arg2 = "BBBBB"                                        :)
(:*******************************************************:)

fn:substring-after("AAAAABBBBBCCCCC","BBBBB")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-8.txt')

    "Created: / 11-05-2013 / 19:43:31 / jirka"
!

test_fn_substring_after_9

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-after-9                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-after" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "AAAAABBBBB"                                   :)
(:$arg2 = " "                                            :)
(:*******************************************************:)

count(fn:substring-after("AAAAABBBBB"," "))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringAfterFunc/fn-substring-after-9.txt')

    "Created: / 11-05-2013 / 19:43:41 / jirka"
!

test_fn_substring_before_1

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-1                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = ""                                             :)
(:*******************************************************:)

fn:count(fn:substring-before("",""))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-1.txt')

    "Created: / 11-05-2013 / 19:43:51 / jirka"
!

test_fn_substring_before_10

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-10                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = " "                                            :)
(:$arg2 = " AAAAABBBBB"                                  :)
(:*******************************************************:)

fn:count(fn:substring-before(" ","AAAAABBBBB"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-10.txt')

    "Created: / 11-05-2013 / 19:44:00 / jirka"
!

test_fn_substring_before_11

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-11                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(:using it as a argument of a fn:not - returns true      :)
(:*******************************************************:)

fn:not(fn:substring-before("A","A"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-11.txt')

    "Created: / 11-05-2013 / 19:44:09 / jirka"
!

test_fn_substring_before_12

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-12                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(:using it as a argument of a fn:not - returns true      :)
(:*******************************************************:)

fn:not(fn:substring-before("A","B"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-12.txt')

    "Created: / 11-05-2013 / 19:44:18 / jirka"
!

test_fn_substring_before_13

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-13                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = xs:string("A")                                 :)
(:$arg2 = "A"                                            :)
(:*******************************************************:)

fn:count(fn:substring-before(xs:string("A"),"A"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-13.txt')

    "Created: / 11-05-2013 / 19:44:37 / jirka"
!

test_fn_substring_before_14

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-14                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A"                                            :)
(:$arg2 = xs:string("A")                                 :)
(:*******************************************************:)

fn:count(fn:substring-before("A",xs:string("A")))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-14.txt')

    "Created: / 11-05-2013 / 19:44:48 / jirka"
!

test_fn_substring_before_15

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-15                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A"                                            :)
(:$arg2 = "a"                                            :)
(:*******************************************************:)

fn:count(fn:substring-before("A","a"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-15.txt')

    "Created: / 11-05-2013 / 19:44:56 / jirka"
!

test_fn_substring_before_16

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-16                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "a"                                            :)
(:$arg2 = "A"                                            :)
(:*******************************************************:)

fn:count(fn:substring-before("a","A"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-16.txt')

    "Created: / 11-05-2013 / 19:45:04 / jirka"
!

test_fn_substring_before_17

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-17                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Mon Jun 1, 2005                                  :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "substring-before"                             :)
(:$arg2 = "substring-before"                             :)
(:*******************************************************:)

fn:count(fn:substring-before("substring-before","substring-before"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-17.txt')

    "Created: / 11-05-2013 / 19:45:14 / jirka"
!

test_fn_substring_before_18

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-18                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Mon Jun 1, 2005                                  :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "substring-beforesubstring-before"             :)
(:$arg2 = "substring-before"                             :)
(:*******************************************************:)

fn:count(fn:substring-before("substring-beforesubstring-before","substring-before"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-18.txt')

    "Created: / 11-05-2013 / 19:45:23 / jirka"
!

test_fn_substring_before_19

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-19                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Mon Jun 1, 2005                                  :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "****"                                         :)
(:$arg2 = "***"                                          :)
(:*******************************************************:)

fn:count(fn:substring-before("****","***"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-19.txt')

    "Created: / 11-05-2013 / 19:45:32 / jirka"
!

test_fn_substring_before_2

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-2                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:count(fn:substring-before("","A Character String"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-2.txt')

    "Created: / 11-05-2013 / 19:45:57 / jirka"
!

test_fn_substring_before_20

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-20                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Mon Jun 1, 2005                                  :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "12345"                                        :)
(:$arg2 = "2345"                                         :)
(:*******************************************************:)

fn:substring-before("12345","2345")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-20.txt')

    "Created: / 11-05-2013 / 19:46:06 / jirka"
!

test_fn_substring_before_21

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-21                           :)
(:Written By: Carmelo Montanez                           :)
(:Date: Mon Jun 1, 2005                                  :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "substring-before                              :)
(:$arg2 = "erofeb-gnirtsbus                              :)
(:("substring-before" backwards)                         :)
(:*******************************************************:)

count(fn:substring-before("substring-before","erofeb-gnirtsbus"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-21.txt')

    "Created: / 11-05-2013 / 19:46:34 / jirka"
!

test_fn_substring_before_3

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-3                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:count(fn:substring-before("A Character String",""))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-3.txt')

    "Created: / 11-05-2013 / 19:46:44 / jirka"
!

test_fn_substring_before_4

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-4                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ()                                             :)
(:$arg2 = ""                                             :)
(:*******************************************************:)

fn:count(fn:substring-before((),""))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-4.txt')

    "Created: / 11-05-2013 / 19:46:53 / jirka"
!

test_fn_substring_before_5

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-5                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ""                                             :)
(:$arg2 = ()                                             :)
(:*******************************************************:)

fn:count(fn:substring-before("",()))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-5.txt')

    "Created: / 11-05-2013 / 19:47:02 / jirka"
!

test_fn_substring_before_6

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-6                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "A Character String"                           :)
(:$arg2 = ()                                             :)
(:*******************************************************:)

fn:count(fn:substring-before("A Character String",()))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-6.txt')

    "Created: / 11-05-2013 / 19:47:12 / jirka"
!

test_fn_substring_before_7

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-7                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = ()                                             :)
(:$arg2 = "A Character String"                           :)
(:*******************************************************:)

fn:count(fn:substring-before((),"A Character String"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-7.txt')

    "Created: / 11-05-2013 / 19:47:20 / jirka"
!

test_fn_substring_before_8

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-8                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "AAAAABBBBBCCCCC"                              :)
(:$arg2 = "BBBBB"                                        :)
(:*******************************************************:)

fn:substring-before("AAAAABBBBBCCCCC","BBBBB")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-8.txt')

    "Created: / 11-05-2013 / 19:47:29 / jirka"
!

test_fn_substring_before_9

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: fn-substring-before-9                            :)
(:Written By: Carmelo Montanez                           :)
(:Date: Fri May 27, 2005                                 :)
(:Purpose: Evaluates The "substring-before" function     :)
(: with the arguments set as follows:                    :)
(:$arg1 = "AAAAABBBBB"                                   :)
(:$arg2 = " "                                            :)
(:*******************************************************:)

count(fn:substring-before("AAAAABBBBB"," "))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/SubstringStringFunc/SubstringBeforeFunc/fn-substring-before-9.txt')

    "Created: / 11-05-2013 / 19:47:38 / jirka"
!

test_fn_translate_1

    | query result |

    query := ' 
(: Name: fn-translate-1 :)
(: Description: Simple test of translate function as per example one for this function from the F andO specs.:)

fn:translate("bar","abc","ABC") 
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-1.txt')

    "Created: / 13-05-2013 / 13:44:54 / houzvjir@fel.cvut.cz"
!

test_fn_translate_10

    | query result |

    query := ' 
(: Name: fn-translate-11 :)
(: Description: Evaluation of translate function as an argument to the "fn:string" function.:)

fn:string(fn:translate("ABC", "ABC", "ABC"))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-10.txt')

    "Created: / 13-05-2013 / 13:49:39 / houzvjir@fel.cvut.cz"
!

test_fn_translate_11

    | query result |

    query := ' 
(: Name: fn-translate-11 :)
(: Description: Evaluation of translate function as an argument to the "fn:string" function.:)

fn:string(fn:translate("ABC", "ABC", "ABC"))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-11.txt')

    "Created: / 13-05-2013 / 13:50:24 / houzvjir@fel.cvut.cz"
!

test_fn_translate_12

    | query result |

    query := ' 
(: Name: fn-translate-12 :)
(: Description: Evaluation of translate function as an argument to the "fn:string-length" function.:)

fn:string-length(fn:translate("ABC","ABC","ABC"))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-12.txt')

    "Created: / 13-05-2013 / 13:50:45 / houzvjir@fel.cvut.cz"
!

test_fn_translate_13

    | query result |

    query := ' 
(: Name: fn-translate-13 :)
(: Description: Evaluation of translate function as an argument to the "xs:decimal" constructor function.:)

xs:decimal(fn:translate("123","123","123"))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-13.txt')

    "Created: / 13-05-2013 / 13:51:12 / houzvjir@fel.cvut.cz"
!

test_fn_translate_14

    | query result |

    query := ' 
(: Name: fn-translate-14 :)
(: Description: Evaluation of translate function as an argument to the "xs:integer" constructor function.:)

xs:integer(fn:translate("123","123","123"))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-14.txt')

    "Created: / 13-05-2013 / 13:51:41 / houzvjir@fel.cvut.cz"
!

test_fn_translate_15

    | query result |

    query := ' 
(: Name: fn-translate-15 :)
(: Description: Evaluation of translate function as an argument to the "xs:float" constructor function.:)

xs:float(fn:translate("123","123","123"))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-15.txt')

    "Created: / 13-05-2013 / 13:52:01 / houzvjir@fel.cvut.cz"
!

test_fn_translate_16

    | query result |

    query := ' 
(: Name: fn-translate-16 :)
(: Description: Evaluation of translate function as an argument to the "xs:double" constructor function.:)

xs:double(fn:translate("123","123","123"))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-16.txt')

    "Created: / 13-05-2013 / 13:52:17 / houzvjir@fel.cvut.cz"
!

test_fn_translate_2

    | query result |

    query := ' 
(: Name: fn-translate-2 :)
(: Description: Simple test of translate function as per example two for this function from the F andO specs.:)

fn:translate("--aaa--","abc-","ABC")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-2.txt')

    "Created: / 13-05-2013 / 13:45:24 / houzvjir@fel.cvut.cz"
!

test_fn_translate_3

    | query result |

    query := ' 
(: Name: fn-translate-3 :)
(: Description: Simple test of translate function as per example three for this function from the F andO specs.:)

fn:translate("abcdabc", "abc", "AB")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-3.txt')

    "Created: / 13-05-2013 / 13:46:03 / houzvjir@fel.cvut.cz"
!

test_fn_translate_4

    | query result |

    query := ' 
(: Name: fn-translate-4 :)
(: Description: Evaluation of translate function.  Translate lower case letters to upper case letters.:)

fn:translate("acdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz", "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-4.txt')

    "Created: / 13-05-2013 / 13:46:22 / houzvjir@fel.cvut.cz"
!

test_fn_translate_5

    | query result |

    query := ' 
(: Name: fn-translate-5 :)
(: Description: Evaluation of translate function.  Translate upper case letters to lower case letters.:)

fn:translate("ABCDEFGHIJKLMNOPQRSTUVWXYZ","ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-5.txt')

    "Created: / 13-05-2013 / 13:47:02 / houzvjir@fel.cvut.cz"
!

test_fn_translate_6

    | query result |

    query := ' 
(: Name: fn-translate-6 :)
(: Description: Evaluation of translate function, where all three arguments are the zero length string.:)
(: Use fn;count to avoid empty file. :)

fn:count(fn:translate("","",""))
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-6.txt')

    "Created: / 13-05-2013 / 13:47:22 / houzvjir@fel.cvut.cz"
!

test_fn_translate_7

    | query result |

    query := ' 
(: Name: fn-translate-7 :)
(: Description: Evaluation of translate function, where the first and third arguments are the same (letters).:)

fn:translate("ABC", "ABC", "ABC")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-7.txt')

    "Created: / 13-05-2013 / 13:48:03 / houzvjir@fel.cvut.cz"
!

test_fn_translate_8

    | query result |

    query := ' 
(: Name: fn-translate-8 :)
(: Description: Evaluation of translate function, where all arguments are the same (numbers).:)

fn:translate("123", "123", "123")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-8.txt')

    "Created: / 13-05-2013 / 13:48:55 / houzvjir@fel.cvut.cz"
!

test_fn_translate_9

    | query result |

    query := ' 
(: Name: fn-translate-9 :)
(: Description: Evaluation of translate function, there is a mixture of numbers and letters.:)

fn:translate("123ABC", "123ABC", "123ABC")
'.
    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/TranslateFunc/fn-translate-9.txt')

    "Created: / 13-05-2013 / 13:49:17 / houzvjir@fel.cvut.cz"
!

test_fn_upper_case1args_1

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: upper-case1args-1                                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:47 GMT-05:00 2004                :)
(:Purpose: Evaluates The "upper-case" function           :)
(: with the arguments set as follows:                    :)
(:$arg = xs:string(lower bound)                          :)
(:*******************************************************:)

fn:upper-case(xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case1args-1.txt')

    "Created: / 11-05-2013 / 22:05:38 / houzvjir@fel.cvut.cz"
!

test_fn_upper_case1args_2

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: upper-case1args-2                                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:47 GMT-05:00 2004                :)
(:Purpose: Evaluates The "upper-case" function           :)
(: with the arguments set as follows:                    :)
(:$arg = xs:string(mid range)                            :)
(:*******************************************************:)

fn:upper-case(xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case1args-2.txt')

    "Created: / 11-05-2013 / 22:04:23 / houzvjir@fel.cvut.cz"
!

test_fn_upper_case1args_3

    | query result |

    query := ' 
(:*******************************************************:)
(:Test: upper-case1args-3                                 :)
(:Written By: Carmelo Montanez                            :)
(:Date: Fri Dec 10 10:15:47 GMT-05:00 2004                :)
(:Purpose: Evaluates The "upper-case" function           :)
(: with the arguments set as follows:                    :)
(:$arg = xs:string(upper bound)                          :)
(:*******************************************************:)

fn:upper-case(xs:string("This is a characte"))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case1args-3.txt')

    "Created: / 11-05-2013 / 22:07:17 / houzvjir@fel.cvut.cz"
!

test_fn_upper_case_1

    | query result |

    query := ' 
(: Name: fn-upper-case-1 :)
(: Description: Evaluation of upper-case function as per example 1 (for this function) :)
(: from the F&O specs.   :)

fn:upper-case("ABc!!D") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-1.txt')

    "Created: / 11-05-2013 / 19:47:46 / jirka"
!

test_fn_upper_case_10

    | query result |

    query := ' 
(: Name: fn-upper-case-10 :)
(: Description: Evaluation of upper-case function with argument set to "*****":)

fn:upper-case("*****") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-10.txt')

    "Created: / 11-05-2013 / 19:47:54 / jirka"
!

test_fn_upper_case_11

    | query result |

    query := ' 
(: Name: fn-upper-case-11 :)
(: Description: Evaluation of upper-case function with argument set to another upper case function:)

fn:upper-case(upper-case("zzzzz")) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-11.txt')

    "Created: / 11-05-2013 / 19:48:03 / jirka"
!

test_fn_upper_case_12

    | query result |

    query := ' 
(: Name: fn-upper-case-12 :)
(: Description: Evaluation of upper-case function as an argument to the "fn:boolean" function:)

fn:boolean(fn:upper-case("abcde")) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-12.txt')

    "Created: / 11-05-2013 / 19:48:15 / jirka"
!

test_fn_upper_case_13

    | query result |

    query := ' 
(: Name: fn-upper-case-13 :)
(: Description: Evaluation of upper-case function as an argument to the "fn:concat" function:)

fn:concat(fn:upper-case("abcde"), fn:upper-case("fghi")) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-13.txt')

    "Created: / 11-05-2013 / 19:48:26 / jirka"
!

test_fn_upper_case_14

    | query result |

    query := ' 
(: Name: fn-upper-case-14 :)
(: Description: Evaluation of upper-case function as an argument to the "fn:not" function:)

fn:not(fn:upper-case("abcde")) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-14.txt')

    "Created: / 11-05-2013 / 19:48:49 / jirka"
!

test_fn_upper_case_15

    | query result |

    query := ' 
(: Name: fn-upper-case-15 :)
(: Description: Evaluation of upper-case function with argument set to "%$#@!!":)

fn:upper-case("%$#@!!") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-15.txt')

    "Created: / 11-05-2013 / 19:49:11 / jirka"
!

test_fn_upper_case_16

    | query result |

    query := ' 
(: Name: fn-upper-case-16 :)
(: Description: Evaluation of upper-case function with argument set to "upper-case":)

fn:upper-case("upper-case") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-16.txt')

    "Created: / 11-05-2013 / 19:49:31 / jirka"
!

test_fn_upper_case_17

    | query result |

    query := ' 
(: Name: fn-upper-case-17 :)
(: Description: Evaluation of upper-case function as part of a boolean expression:)

fn:upper-case("abc") and fn:upper-case("abc")
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-17.txt')

    "Created: / 11-05-2013 / 19:49:40 / jirka"
!

test_fn_upper_case_2

    | query result |

    query := ' 
(: Name: fn-upper-case-2 :)
(: Description: Evaluation of upper-case function using the empty sequence :)
(: Uses the count function to avoid empty file.   :)

fn:count(fn:upper-case(())) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-2.txt')

    "Created: / 11-05-2013 / 19:49:49 / jirka"
!

test_fn_upper_case_3

    | query result |

    query := ' 
(: Name: fn-upper-case-3 :)
(: Description: Evaluation of upper-case function that uses only numbers as part of argument:)
(: Use of count function to avoid empty file. :)
fn:upper-case("12345") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-3.txt')

    "Created: / 11-05-2013 / 19:49:57 / jirka"
!

test_fn_upper_case_4

    | query result |

    query := ' 
(: Name: fn-upper-case-4 :)
(: Description: Evaluation of upper-case function that uses both numbers and letters as part of argument:)

fn:upper-case("12345abcd") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-4.txt')

    "Created: / 11-05-2013 / 19:50:06 / jirka"
!

test_fn_upper_case_5

    | query result |

    query := ' 
(: Name: fn-upper-case-5 :)
(: Description: Evaluation of upper-case function that uses only upper case letters as part of argument:)

fn:upper-case("ABCD") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-5.txt')

    "Created: / 11-05-2013 / 19:50:13 / jirka"
!

test_fn_upper_case_6

    | query result |

    query := ' 
(: Name: fn-upper-case-6 :)
(: Description: Evaluation of upper-case function that uses only lower case letters as part of argument:)

fn:upper-case("abcde") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-6.txt')

    "Created: / 11-05-2013 / 19:50:22 / jirka"
!

test_fn_upper_case_7

    | query result |

    query := ' 
(: Name: fn-upper-case-7 :)
(: Description: Evaluation of upper-case function that uses both upper and lower case letters as part of argument:)

fn:upper-case("ABCDEabcde") 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-7.txt')

    "Created: / 11-05-2013 / 19:50:30 / jirka"
!

test_fn_upper_case_8

    | query result |

    query := ' 
(: Name: fn-upper-case-8 :)
(: Description: Evaluation of upper-case function that uses the empty string as part of argument:)
(: Uses "fn:count" to avoid the empty file  :)

fn:count(fn:upper-case(""))
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-8.txt')

    "Created: / 11-05-2013 / 19:50:41 / jirka"
!

test_fn_upper_case_9

    | query result |

    query := ' 
(: Name: fn-upper-case-9 :)
(: Description: Evaluation of upper-case function that uses the "lower-case" as part of argument:)

fn:upper-case(lower-case("AbcDH")) 
'.

    self xqtsBind: 'input-context' toContentsOf: 'emptydoc'.


    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'Functions/AllStringFunc/GeneralStringFunc/UpperCaseFunc/fn-upper-case-9.txt')

    "Created: / 11-05-2013 / 21:34:31 / houzvjir@fel.cvut.cz"
! !

!XQTSAllString class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !
