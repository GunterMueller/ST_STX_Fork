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

RBTransformationRule subclass:#RBLoggingCodeReplaceRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBLoggingCodeReplaceRule class methodsFor:'documentation'!

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

!RBLoggingCodeReplaceRule methodsFor:'accessing'!

group
    ^ 'Transformations - Smalltalk/X'

    "Modified: / 01-03-2012 / 18:56:58 / cg"
!

name
    ^ 'Use Logger for logging'

    "Modified: / 15-09-2011 / 11:17:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-04-2012 / 13:13:36 / cg"
!

rationale
    ^ 'Transform <code><pre>    Transcript show: ''message''</pre></code> 
and <code><pre>    ''message'' infoPrintCR/errorPrintCR</pre></code> 
into sends to the new and more flexible message logger interface:
<code><pre>   Logger log:''message''</pre></code>
<P>
This rule is ignored in TestCase classes.'

    "Created: / 04-08-2011 / 19:24:07 / cg"
    "Modified: / 15-09-2011 / 11:22:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 19:30:31 / cg"
! !

!RBLoggingCodeReplaceRule methodsFor:'initialization'!

initialize
    super initialize.
    self rewriteRule 
        "/ these have been already changed to use the logger
"/        replace:'``@message infoPrintCR' with:'Logger info:``@message';
"/        replace:'``@message errorPrintCR' with:'Logger error:``@message';
"/
"/        replace:'``@message infoPrint' with:'Logger info:``@message';
"/        replace:'``@message errorPrint' with:'Logger error:``@message';

        replace:'Transcript  showCR:``@message' with:'Logger debug:``@message';        
        replace:'Transcript  show:``@message' with:'Logger debug:``@message';

        replace:'Transcript  showCR:``@message with:``@arg' with:'Logger debug:``@message with:``@arg';        
        replace:'Transcript  show:``@message with:``@arg' with:'Logger debug:``@message with:``@arg'

    "Modified (format): / 04-08-2011 / 19:27:13 / cg"
    "Modified: / 16-10-2014 / 00:57:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLoggingCodeReplaceRule methodsFor:'running'!

shouldIgnoreClass: aClass selector: selector
    aClass isTestCaseLike ifTrue:[^ true].
    ^ super shouldIgnoreClass:aClass selector:selector.
! !

!RBLoggingCodeReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

