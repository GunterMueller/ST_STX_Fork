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

RBBlockLintRule subclass:#RBNoMethodCommentRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBNoMethodCommentRule class methodsFor:'documentation'!

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
! !

!RBNoMethodCommentRule methodsFor:'accessing'!

group
        ^ 'Guidelines'
!

name
        ^ 'No method comment'
!

rationale
    ^ 'Checks for methods that have no method comment.
A comment should be placed right after the method''s selector specification
(i.e. its name and arguments), before any local variable definitions or
any statements.
<P>
It should give a short note on what it does and what it returns (if it returns something useful).
<P>
To make things perfect, add another comment at the end, 
containing usage examples as ready-to-select-and-execute doIt expressions.'
! !

!RBNoMethodCommentRule methodsFor:'running'!

checkMethod: aContext
    |source tree class selector|

    class := aContext selectedClass.
    selector := aContext selector.
    
    "/ ignore some...
    class isMeta ifTrue:[
        (AbstractSourceCodeManager isVersionMethodSelector: selector) ifTrue:[^ self].
        ( #(copyright documentation examples) includes:selector) ifTrue:[^ self].
        class theNonMetaclass isSharedPool ifTrue:[
            selector == #initialize ifTrue:[^ self].
        ].    
    ].
    
    "a quick check, to avoid many parses (because parsing is very slow)"
    source := aContext compiledMethod source.
    source isNil ifTrue:[
        Transcript showCR:'Lint: no source for %1' with:aContext compiledMethod.
        ^ self.
    ].
    (source includes:$") ifTrue:[
        "/ parse and see where the comment is
        tree := aContext parseTree.
        tree isMethod ifTrue:[
            tree body commentsBefore notEmptyOrNil ifTrue:[^ self].
        ] ifFalse:[
            "/ mh - actually an error            
            self halt:('parse error in %1 » %2' bindWith:class name with:selector).
        ].
    ].

    result addClass:class selector:selector
! !

!RBNoMethodCommentRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

