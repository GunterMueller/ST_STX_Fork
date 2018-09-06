"
 Copyright (C) 2011-2013 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBTransformationRule subclass:#RBFindFirstToContainsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBFindFirstToContainsRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2011-2013 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
! !

!RBFindFirstToContainsRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
    ^ '"findFirst:" / "findLast:" / "findString:" -> "contains:", "indexOf:" or "lastIndexOf:"'
!

rationale
    ^ 'Rewrite 
"<code>findFirst:</code>" into "<code>contains:</code>" or "<code>indexOf:</code>".
<br>
Also, if possible, "<code>findString:</code>" isReplaced by "<code>includesString:</code>",
"<code>findString:</code>" with a single-character string to "<code>indexOf:</code>"
and  "<code>findLast:</code>" by "<code>lastIndexOf:</code>".'
!

severity
        ^ SeverityInformation
! !

!RBFindFirstToContainsRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                replace: '(``@collection findFirst: [:`each | | `@temps | ``@.Statements]) ~~ 0'
                with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

                replace: '(``@collection findFirst: [:`each | | `@temps | ``@.Statements]) ~= 0'
                with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

                replace: '(``@collection findFirst: [:`each | | `@temps | ``@.Statements]) == 0'
                with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

                replace: '(``@collection findFirst: [:`each | | `@temps | ``@.Statements]) = 0'
                with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

                replace: '(``@collection findString: `@string) = 0'
                with: '(``@collection includesString: `@string) not';

                replace: '(``@collection findString: `@string) == 0'
                with: '(``@collection includesString: `@string) not';

                replace: '(``@collection findString: `@string) ~= 0'
                with: '(``@collection includesString: `@string)';

                replace: '(``@collection findString: `@string) ~~ 0'
                with: '(``@collection includesString: `@string)';

                replace: '(``@collection findString: `@string) = 1'
                with: '(``@collection startsWith: `@string)';

                replace: '(``@collection findString: `@string) == 1'
                with: '(``@collection startsWith: `@string)';

                replace: '(``@collection findString: `@string) ~= 1'
                with: '(``@collection startsWith: `@string) not';

                replace: '(``@collection findString: `@string) ~~ 1'
                with: '(``@collection startsWith: `@string) not';

                replace: '(``@collection findString: `''.'')'
                with: '(``@collection indexOf: `@char)'
                when: [ :node :owner|
                    |firstChar|
                    "/ trick: misuse the when-condition block to add the extracted character to the search environment.
                    firstChar := node arguments first value at:1.
                    owner context at:(RBPatternVariableNode named:'`@char') 
                                 put:(RBLiteralNode value:firstChar).
                    true
                ];

                replace: '(``@collection findString: `''.'' startingAt: `@start)'
                with: '(``@collection indexOf: `@char startingAt: `@start)'
                when: [ :node :owner|
                    |firstChar|
                    "/ trick: misuse the when-condition block to add the extracted character to the search environment.
                    firstChar := node arguments first value at:1.
                    owner context at:(RBPatternVariableNode named:'`@char') put:(RBLiteralNode value:firstChar).
                    true
                ];

                replace: '(``@collection findFirst: [:`each | `each = `@expr])'
                with: '(``@collection indexOf: `@expr)'
                when: [ :node :owner|
                    |searchColl|

                    searchColl := owner context at:(RBPatternVariableNode named:'`@expr') ifAbsent:nil.
                    searchColl notNil and:[searchColl isLiteral]
                ];

                replace: '(``@collection findFirst: [:`each | `each == `@expr])'
                with: '(``@collection identityIndexOf: `@expr)'
                when: [ :node :owner|
                    |searchColl|

                    searchColl := owner context at:(RBPatternVariableNode named:'`@expr') ifAbsent:nil.
                    searchColl notNil and:[searchColl isLiteral]
                ];

                replace: '(``@collection findFirst: [:`each | `@searchColl includes: `each])'
                with: '(``@collection indexOfAny: `@searchColl)'
                when: [ :node :owner|
                    |searchColl|

                    searchColl := owner context at:(RBPatternVariableNode named:'`@searchColl') ifAbsent:nil.
                    searchColl notNil and:[searchColl isLiteralString]
                ];

                replace: '(``@collection findLast: [:`each | `each = `@expr])'
                with: '(``@collection lastIndexOf: `@expr)'
                when: [ :node :owner|
                    |searchColl|

                    searchColl := owner context at:(RBPatternVariableNode named:'`@expr') ifAbsent:nil.
                    searchColl notNil and:[searchColl isLiteral]
                ];

                replace: '(``@collection findLast: [:`each | `each = `@expr] ifNone: [0])'
                with: '(``@collection lastIndexOf: `@expr)'
                when: [ :node :owner|
                    |searchColl|

                    searchColl := owner context at:(RBPatternVariableNode named:'`@expr') ifAbsent:nil.
                    searchColl notNil and:[searchColl isLiteral]
                ];

                replace: '(``@collection findLast: [:`each | `each == `@expr])'
                with: '(``@collection lastIdentityIndexOf: `@expr)'
                when: [ :node :owner|
                    |searchColl|

                    searchColl := owner context at:(RBPatternVariableNode named:'`@expr') ifAbsent:nil.
                    searchColl notNil and:[searchColl isLiteral]
                ];

                replace: '(``@collection findLast: [:`each | `each == `@expr] ifNone: [0])'
                with: '(``@collection lastIdentityIndexOf: `@expr)'
                when: [ :node :owner|
                    |searchColl|

                    searchColl := owner context at:(RBPatternVariableNode named:'`@expr') ifAbsent:nil.
                    searchColl notNil and:[searchColl isLiteral]
                ]
! !

!RBFindFirstToContainsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

