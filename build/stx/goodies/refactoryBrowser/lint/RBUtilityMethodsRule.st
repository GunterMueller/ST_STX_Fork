"{ Encoding: utf8 }"

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

RBBlockLintRule subclass:#RBUtilityMethodsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBUtilityMethodsRule class methodsFor:'documentation'!

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

!RBUtilityMethodsRule methodsFor:'accessing'!

group
	^ 'Miscellaneous'
!

name
	^ 'Utility methods'
!

rationale
        ^ 'Utility methods have one or more arguments and do no refer to self 
or an instance variable. 
These methods might be better defined as class methods or in some other (utility-)class,
to allow for better reuse.
<P>
But make sure that the method is not part of a protocol between components, 
which is required by other parts of the system (for example: query or hook methods).
Especially by as-yet unloaded packages.'

    "Modified: / 01-03-2012 / 11:32:17 / cg"
! !

!RBUtilityMethodsRule methodsFor:'private'!

subclassOf: aClass overrides: aSelector 
	^(aClass subclasses detect: 
			[:each | 
			(each includesSelector: aSelector)
				or: [self subclassOf: each overrides: aSelector]]
		ifNone: [nil]) notNil
!

utilityProtocols
	^ #('*utilit*')
! !

!RBUtilityMethodsRule methodsFor:'running'!

checkMethod: aContext 
	(aContext selectedClass isMeta or: 
		[ aContext selector numArgs == 0 or: 
			[ (aContext protocols 
				detect: 
					[ :each | 
					(self utilityProtocols 
						detect: [ :protocol | protocol match: each ]
						ifNone: [  ]) notNil ]
				ifNone: [  ]) notNil ] ]) ifFalse: 
		[ (self 
			subclassOf: aContext selectedClass
			overrides: aContext selector) ifFalse: 
			[ (aContext superMessages isEmpty and: [ aContext selfMessages isEmpty ]) ifTrue: 
				[ (aContext selectedClass allInstVarNames , aContext selectedClass allClassVarNames asArray , #('self' ) 
					detect: [ :each | aContext parseTree references: each ]
					ifNone: [  ]) isNil ifTrue: 
					[ result 
						addClass: aContext selectedClass
						selector: aContext selector ] ] ] ]
! !

!RBUtilityMethodsRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBUtilityMethodsRule.st,v 1.7 2015-03-02 13:55:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBUtilityMethodsRule.st,v 1.7 2015-03-02 13:55:08 cg Exp $'
!

version_SVN
    ^ '$Id: RBUtilityMethodsRule.st,v 1.7 2015-03-02 13:55:08 cg Exp $'
! !

