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

RBBlockLintRule subclass:#RBUnpackagedCodeRule
	instanceVariableNames:'packages package'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBUnpackagedCodeRule class methodsFor:'documentation'!

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

!RBUnpackagedCodeRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
	^ 'Unpackaged code'
!

rationale
        ^ 'Code that is not contained in a package is not versioned.
<P>This is not actually a problem, as you will be asked again, when attempting to check
the class into the source code repository.'

    "Modified: / 17-04-2010 / 11:46:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 12:19:02 / cg"
! !

!RBUnpackagedCodeRule methodsFor:'private'!

packageSatisfying: aBlock
	"Answer the first package satisfying aBlock or nil. This method assumes that it is likely that the last matching package matches the given condition again and thus it tries that one first."

	(package notNil and: [ aBlock value: package ])
		ifTrue: [ ^ package ].
	packages do: [ :info |
		(aBlock value: info)
			ifTrue: [ ^ package := info ] ].
	^ nil
! !

!RBUnpackagedCodeRule methodsFor:'running'!

checkClass: aContext
    | cls defaultPackage rslt|

    defaultPackage := PackageId noProjectID.

    cls := aContext selectedClass.
    rslt := self result.

    cls package == defaultPackage ifTrue: [ 
        rslt addClass: cls
    ].

    cls methodDictionary do: [:mth|
        mth package == defaultPackage ifTrue: [
            rslt addClass: cls selector: mth selector
        ]
    ].

    cls theMetaclass methodDictionary do: [:mth|
        mth package == defaultPackage ifTrue: [
            rslt addClass: cls theMetaclass selector: mth selector
        ]
    ].
!

checkMethod: aContext

    (aContext compiledMethod package == PackageId noProjectID)
        ifTrue: [ self result addClass: aContext selectedClass selector: aContext selector ]
! !

!RBUnpackagedCodeRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

