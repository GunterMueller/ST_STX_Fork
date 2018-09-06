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

Annotation subclass:#LintRuleIgnoreAnnotation
	instanceVariableNames:'rule rationale author'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!

!LintRuleIgnoreAnnotation class methodsFor:'documentation'!

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

!LintRuleIgnoreAnnotation class methodsFor:'accessing'!

key
    ^#ignore:rationale:author:

    "Created: / 16-07-2017 / 13:35:55 / cg"
! !

!LintRuleIgnoreAnnotation methodsFor:'accessing'!

annotatesClass:aClass

    "Nothing to do"

    "Created: / 24-08-2010 / 20:34:26 / Jan Vrany <enter your email here>"
!

annotatesMethod:aMethod

    author isEmptyOrNil ifTrue:[self halt].

    "Nothing to do"

    "Created: / 24-08-2010 / 20:34:36 / Jan Vrany <enter your email here>"
    "Modified: / 04-08-2011 / 19:05:01 / cg"
!

author
    ^ author
!

author:something
    author := something.
!

key

    ^ self class key

    "Created: / 24-08-2010 / 20:35:50 / Jan Vrany <enter your email here>"
    "Modified: / 16-07-2017 / 13:36:04 / cg"
!

rationale
    ^ rationale
!

rationale:something
    rationale := something.
!

rule
    ^ rule
!

rule:something
    rule := something.
!

storeOn:aStream

    aStream nextPutAll: '(Annotation ignore: '.
    self rule storeOn: aStream.
    aStream nextPutAll: ' rationale: '.
    self rationale storeOn: aStream.
    aStream nextPutAll: ' author: '.
    self author storeOn: aStream.
    aStream nextPut: $)

    "Created: / 24-08-2010 / 20:39:45 / Jan Vrany <enter your email here>"
! !

!LintRuleIgnoreAnnotation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/LintRuleIgnoreAnnotation.st,v 1.3 2013-01-24 10:17:37 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/LintRuleIgnoreAnnotation.st,v 1.3 2013-01-24 10:17:37 vrany Exp $'
!

version_SVN
    ^ 'Id: LintRuleIgnoreAnnotation.st 24 2010-08-25 12:47:16Z vranyj1 '
! !

