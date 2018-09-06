"
 Copyright (C) 2016 Claus Gittinger

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

RBTransformationRule subclass:#RBFileOpenCloseToReadingFileRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBFileOpenCloseToReadingFileRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2016 Claus Gittinger

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
!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^ #( 
        stx         "/ code is Smalltalk/X specific
    )
! !

!RBFileOpenCloseToReadingFileRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
    ^ '"filename open...close" -> "filename readingFileDo:[...]"'
!

rationale
    "/ 'Rewrite "<code>detect:ifNone:</code>" into "<code>contains:</code>"'
    ^ 'Code like: 
<code><pre>    s := aFilename readStream.
    ... do something with s ...
    s close</pre></code> 
is better written as<code><pre>    aFilename readingFileDo:[:s |
        ... do something with s ...
    ]</pre></code>
<p>The later ensures that the file is closed in case of an an unwind (i.e. error),
and also makes the stream variable "s" local, so that it is only visible while having
a defined value.'
!

severity
        ^ SeverityInformation
! !

!RBFileOpenCloseToReadingFileRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                replace: '
                        | `@temps1 `stream `@temps2 |
                        ``@.Statements1.
                        `stream := `@file readStream.
                        ``@.StreamStatements.
                        `stream close.
                        ``@.Statements2.'
                with: '
                        | `@temps1 `@temps2 |
                        ``@.Statements1.
                      `@file readingFileDo:[:`stream |
                              ``@.StreamStatements.
                      ].
                        ``@.Statements2.'
!

test
    "test method - should be found by this rule"
    
    |s l|
    
    s := 'foo' asFilename readStream.
    l := s nextLine.
    s close.
    ^ l
! !

!RBFileOpenCloseToReadingFileRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

