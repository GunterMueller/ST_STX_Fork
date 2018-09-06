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
"{ Package: 'stx:goodies/refactoryBrowser/lint/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#SmalllintTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Tests'
!

!SmalllintTests class methodsFor:'documentation'!

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
!

documentation
"
    Some old tests written by CTU students. Weak, this class is to be removed.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SmalllintTests methodsFor:'testing'!

test01
    |myRules composite myEnvironment|

    myRules := OrderedCollection new.
    myRules
        addFirst:RBEqualNotUsedRule new;
        addFirst:RBUnreferencedVariablesRule new;
        addFirst:RBFileBlocksRule new.
    composite := RBCompositeLintRule new.
    composite rules:myRules.
    myEnvironment := ClassEnvironment new.
    myEnvironment
        addClass:SmalllintTestsMock01;
        addClass:SmalllintTestsMock02.
    SmalllintChecker runRule: composite onEnvironment: myEnvironment.
    self assert:composite isNil = false.
    self assert:composite problemCount = 4.
    self assert:(composite failedRules) size = 2.

    "Created: / 19-11-2008 / 13:59:28 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 26-11-2008 / 14:10:09 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 15-12-2008 / 18:52:50 / Josef Grega <gregaj1@fel.cvut.cz>"
    "Modified: / 16-12-2008 / 15:19:53 / bazantj <enter your email here>"
    "Modified: / 25-07-2012 / 11:49:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test03
    | myEnvironment composite|

    myEnvironment := ClassEnvironment new.
    myEnvironment addClass: SmalllintTestsMock01.
    composite := RBCompositeLintRule allRules.

    SmalllintChecker runRule: composite onEnvironment: myEnvironment.

    self assert: composite problemCount = 14.
    self assert: (composite failedRules) size = 8

    "Created: / 26-11-2008 / 14:55:51 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 15-12-2008 / 19:00:58 / Josef Grega <gregaj1@fel.cvut.cz>"
    "Modified: / 20-12-2008 / 15:19:52 / bazantj <enter your email here>"
    "Modified: / 15-01-2009 / 08:09:17 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 25-07-2012 / 12:08:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalllintTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

