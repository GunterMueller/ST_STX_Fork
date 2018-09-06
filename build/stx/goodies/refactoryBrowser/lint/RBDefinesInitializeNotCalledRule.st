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

RBBlockLintRule subclass:#RBDefinesInitializeNotCalledRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBDefinesInitializeNotCalledRule class methodsFor:'documentation'!

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

!RBDefinesInitializeNotCalledRule methodsFor:'accessing'!

group
        ^ 'Bugs - Smalltalk/X'

    "Modified: / 10-09-2012 / 16:01:27 / cg"
!

name
        ^ 'Defines "initialize" but does not call it from "new"'

    "Modified: / 10-09-2012 / 16:08:47 / cg"
!

rationale
        ^ 'Checks that a class which defines "initialize" on the inst-side
also has a redefined "new" on the class side, which sends this message. 
This happens for imported Squeak code, which assumes that Behavior>>new automatically
calls #initialize. 
<br>This is not the case in Smalltalk/X (and some other Smalltalk dialects)'

    "Modified: / 10-09-2012 / 16:10:22 / cg"
!

resultClass
    "I will return the set of failing classes"

    ^ ClassEnvironment
! !

!RBDefinesInitializeNotCalledRule methodsFor:'running'!

checkClass: aContext 
    |cls ok|

    ((cls := aContext selectedClass theNonMetaclass) includesSelector: #initialize) ifTrue:[
        ok := false.
        cls theMetaclass withAllSuperclassesDo:[:eachMetaclass |
            #(new new: theOneAndOnlyInstance) do:[:sel |
                |m|

                m := eachMetaclass compiledMethodAt:sel.
                m notNil ifTrue:[
                    (m sendsAnySelector:#( #initialize #shouldNotImplement)) ifTrue:[ 
                        ok := true 
                    ].
                ].
            ].
        ].
        ok ifFalse:[ result addClass: cls ]
    ].

    "Modified: / 05-02-2017 / 01:28:13 / cg"
! !

!RBDefinesInitializeNotCalledRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

