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

RBBlockLintRule subclass:#RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule
	instanceVariableNames:'matcher'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule class methodsFor:'documentation'!

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

!RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
	^ 'Literal array contains a #true, #false, or #nil but the source doesn''t.'
!

rationale
        ^ 'With ANSI changes, "<code>#(true false nil)</code>" now is equal to 
"<code>{true. false. nil}</code>" not "<code>{#true. #false. #nil}</code>" as it used to be in ST80.
<P>Notice: the ST/X behavior has always been the same as the new ANSI behavior,
so this is usually only a potential bug, when porting old VW, V''Age or Squeak code to ST/X.'

    "Modified: / 01-03-2012 / 12:26:01 / cg"
! !

!RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule methodsFor:'initialization'!

initialize
    super initialize.
    matcher := ParseTreeSearcher new.
    matcher 
        matches:'`{ :n | n isLiteral and: [ n value isKindOf: Array ] }'
        do:[:aNode :answer | 
            answer
                addAll:(self literalTrueFalseOrNilSymbolsIn:aNode value);
                yourself
        ]
! !

!RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule methodsFor:'private'!

literalTrueFalseOrNilSymbolsIn: aLiteral 
        | retval |
        aLiteral isArray ifFalse: [^#()].
        retval := OrderedCollection withAll: (aLiteral select: [:ea | ea isSymbol and: [#(#true #false #nil ) includes: ea]]).
        aLiteral do: [ :each | retval addAll: (self literalTrueFalseOrNilSymbolsIn: each) ].
        ^retval.
! !

!RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule methodsFor:'running'!

checkMethod: aContext 
	| compiledLits parsedLits |
	compiledLits := aContext compiledMethod allLiterals
		inject: OrderedCollection new
		into: [ :collection :literal |
			collection
				addAll: (self literalTrueFalseOrNilSymbolsIn: literal);
				yourself ].
	compiledLits size > 0 ifTrue: [ 
		parsedLits := OrderedCollection new.
		matcher 
			executeTree: aContext parseTree
			initialAnswer: parsedLits.
		compiledLits size ~= parsedLits size ifTrue: [
			result 
				addClass: aContext selectedClass
				selector: aContext selector ] ]
! !

!RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

