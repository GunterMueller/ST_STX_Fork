"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

RBTransformationRule subclass:#RBDetectIfNoneRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBDetectIfNoneRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

!RBDetectIfNoneRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
    ^ '"detect:ifNone:" -> "contains:"'

    "Modified: / 04-08-2011 / 17:45:21 / cg"
!

rationale
    "/ 'Rewrite "<code>detect:ifNone:</code>" into "<code>contains:</code>"'
    ^ 'Code like: 
<code><pre>    (aCollection detect: [:each | ''some condition''] ifNone: [nil]) ~= nil</pre></code> 
can be simplified to <code><pre>    aCollection contains: [:each | ''some condition'']</pre></code>
<p>Not only is the "<code>contains:</code>" variant shorter, it better signifies what the code is doing.'

    "Created: / 01-03-2012 / 19:02:28 / cg"
!

severity
        ^ SeverityInformation
! !

!RBDetectIfNoneRule methodsFor:'initialization'!

initialize
    super initialize.
    self rewriteRule
        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) isNil'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) = nil'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) == nil'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) notNil'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) ~= nil'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) ~~ nil'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        "/ cg more like this...
        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: []) isNil'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: []) = nil'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: []) == nil'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: []) notNil'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: []) ~= nil'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: []) ~~ nil'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: nil) isNil'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: nil) = nil'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: nil) == nil'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: nil) notNil'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: nil) ~= nil'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: nil) ~~ nil'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        "/ cg: questionable
        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [0]) ~= 0'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [0]) ~~ 0'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [0]) = 0'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [0]) == 0'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: 0) ~= 0'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: 0) ~~ 0'
        with: '``@collection contains: [:`each | | `@temps | ``@.Statements]';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: 0) = 0'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not';

        replace: '(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: 0) == 0'
        with: '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not'.

    "Modified: / 19-11-2016 / 18:37:27 / cg"
! !

!RBDetectIfNoneRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

