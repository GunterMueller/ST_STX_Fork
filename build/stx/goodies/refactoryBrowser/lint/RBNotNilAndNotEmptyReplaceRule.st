"
 Copyright (C) 2014 Claus Gittinger 

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

RBTransformationRule subclass:#RBNotNilAndNotEmptyReplaceRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBNotNilAndNotEmptyReplaceRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2014 Claus Gittinger 

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

!RBNotNilAndNotEmptyReplaceRule methodsFor:'accessing'!

group
    ^ 'Transformations - Smalltalk/X'
!

name
    ^ '"notNil and: notEmpty" -> "notEmptyOrNil"'
!

rationale
    ^ 'Transform "<code>expr notNil and:[ expr notEmpty ]</code>" to "<code>expr notEmptyOrNil</code>".'
! !

!RBNotNilAndNotEmptyReplaceRule methodsFor:'initialization'!

initialize
    super initialize.
    self rewriteRule 
        replace:'`var notNil and:[ `var notEmpty ] ' with:'`var notEmptyOrNil';
        replace:'`var ~~ nil and:[ `var notEmpty ] ' with:'`var notEmptyOrNil';
        replace:'`var notNil and:[ `var isEmpty not ] ' with:'`var notEmptyOrNil';
        replace:'`var ~~ nil and:[ `var isEmpty not ] ' with:'`var notEmptyOrNil';

        replace:'`var isNil or:[ `var isEmpty ] ' with:'`var emptyOrNil';
        replace:'`var == nil or:[ `var isEmpty ] ' with:'`var emptyOrNil';

        replace:'(`var := `@expr) notNil and:[ `var notEmpty ] ' with:'(`var := `@expr) notEmptyOrNil';
        replace:'(`var := `@expr) ~~ nil and:[ `var notEmpty ] ' with:'(`var := `@expr) notEmptyOrNil';
        replace:'(`var := `@expr) notNil and:[ `var isEmpty not ] ' with:'(`var := `@expr) notEmptyOrNil';
        replace:'(`var := `@expr) ~~ nil and:[ `var isEmpty not ] ' with:'(`var := `@expr) notEmptyOrNil';
        replace:'(`var := `@expr) isNil or:[ `var isEmpty ] ' with:'(`var := `@expr) emptyOrNil';
        replace:'(`var := `@expr) == nil or:[ `var isEmpty ] ' with:'(`var := `@expr) emptyOrNil'.
! !

!RBNotNilAndNotEmptyReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBNotNilAndNotEmptyReplaceRule.st,v 1.2 2015-02-23 17:10:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBNotNilAndNotEmptyReplaceRule.st,v 1.2 2015-02-23 17:10:47 cg Exp $'
! !

