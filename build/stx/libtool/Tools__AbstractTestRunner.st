"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ApplicationModel subclass:#AbstractTestRunner
	instanceVariableNames:''
	classVariableNames:'NotRunColor PassedColor FailureColor ErrorColor
		CurrentlyRunningColor'
	poolDictionaries:''
	category:'SUnit-UI'
!

!AbstractTestRunner class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!AbstractTestRunner class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    CurrentlyRunningColor   := Color yellow.
    NotRunColor             := Color redByte:145 greenByte:145 blueByte:145.
    PassedColor             := Color redByte:92 greenByte:166 blueByte:92.
    FailureColor            := Color redByte:194 greenByte:110 blueByte:110.
    ErrorColor              := FailureColor

    "Modified: / 15-03-2010 / 21:59:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 14:12:34 / cg"
! !

!AbstractTestRunner class methodsFor:'accessing'!

currentlyRunningColor
    ^ CurrentlyRunningColor

    "Created: / 05-07-2011 / 14:12:04 / cg"
!

errorColor
    ^ ErrorColor

    "Created: / 07-02-2010 / 14:43:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2010 / 21:53:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

failedColor
    ^ FailureColor

    "Modified: / 15-03-2010 / 21:53:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notRunColor
    ^ NotRunColor

    "Created: / 15-03-2010 / 09:55:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2010 / 21:53:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

passedColor
    ^ PassedColor

    "Modified: / 15-03-2010 / 21:54:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractTestRunner methodsFor:'private'!

buildSuiteFromClass:testCaseCls

    ^testCaseCls asTestCase buildSuite

    "Modified: / 04-03-2011 / 08:22:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTestCaseLike:cls 

    ^cls isTestCaseLike

    "Modified: / 28-02-2011 / 21:31:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractTestRunner methodsFor:'utilities'!

suiteNameFromClasses: classes
    |numClasses|

    (numClasses := classes size) == 1 ifTrue:
        [^classes anyOne nameWithoutPrefix].
    numClasses == 2 ifTrue:
        [^String streamContents:
            [:s|classes 
                do:[:cls|s nextPutAll: cls nameWithoutPrefix]
                separatedBy:[s nextPutAll:' & ']]].

    ^numClasses printString , ' test cases'.

    "Created: / 15-03-2010 / 13:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

suiteNameFromMethods: methods
    |numMethods|

    (numMethods := methods size) == 1 ifTrue:[^ methods anyOne selector].

    ^numMethods printString , ' tests from ' ,
        (self suiteNameFromClasses: 
            (methods 
                collect:[:m|m mclass] 
                thenSelect:[:c | c notNil]) asSet)

    "Created: / 15-03-2010 / 13:22:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

suiteNameFromProtocols: protocols
    |numProtocols|

    (numProtocols := protocols size) == 0 ifTrue:[
        ^'tests'
    ].
    numProtocols == 1 ifTrue:[
        protocols anyOne notNil ifTrue:[
            ^'category "', protocols anyOne , '"'
        ] ifFalse:[
            ^'tests'
        ]
    ].    
    ^numProtocols printString , ' categories'

    "Created: / 15-03-2010 / 13:22:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-10-2011 / 22:59:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractTestRunner class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__AbstractTestRunner.st,v 1.12 2013-05-21 20:21:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__AbstractTestRunner.st,v 1.12 2013-05-21 20:21:26 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__AbstractTestRunner.st,v 1.12 2013-05-21 20:21:26 cg Exp $'
! !


AbstractTestRunner initialize!
