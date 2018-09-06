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

RBLintRule subclass:#RBTransformationRule
	instanceVariableNames:'rewriteRule builder class'
	classVariableNames:'RecursiveSelfRule'
	poolDictionaries:''
	category:'Refactory-Lint'
!

!RBTransformationRule class methodsFor:'documentation'!

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

!RBTransformationRule class methodsFor:'accessing'!

recursiveSelfRule
    RecursiveSelfRule isNil ifTrue:[
        RecursiveSelfRule := ParseTreeSearcher new.
        RecursiveSelfRule 
                matchesAnyMethodOf: #(
                        '`@methodName: `@args | `@temps | self `@methodName: `@args1' 
                        '`@methodName: `@args | `@temps | ^ self `@methodName: `@args1')
                do: [ :node :answer | true ].
        ^ RecursiveSelfRule
    ].

    ^ RecursiveSelfRule

    "Modified: / 14-07-2011 / 00:04:51 / cg"
! !

!RBTransformationRule class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == RBTransformationRule.
! !

!RBTransformationRule class methodsFor:'testing'!

isVisible
    ^ (self name ~= #RBTransformationRule) and:[self isBroken not]

    "Modified: / 26-07-2012 / 13:42:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 16-11-2016 / 17:21:01 / cg"
! !

!RBTransformationRule methodsFor:'accessing'!

changes
    ^builder notNil ifTrue:[builder changes] ifFalse:[#()]

    "Modified: / 31-01-2012 / 22:21:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isClassScope
    "true if I am or contain only class-rules"

    ^ false
!

nameOfFix
    ^ 'Rewrite the code'
!

problemCount
    builder isNil ifTrue:[^ 0].
    ^ builder problemCount

    "Modified: / 19-11-2016 / 18:56:51 / cg"
!

result
	| environment |
	environment := ParseTreeEnvironment new.
	environment matcher: self rewriteRule.
	environment label: self name.
	self changes do: [ :change |
		(change isKindOf: AddMethodChange)
			ifTrue: [ environment addClass: change changeClass selector: change selector ] ].
	^ environment
!

rewriteRule
	^ rewriteRule
!

scope

    ^'method check'
! !

!RBTransformationRule methodsFor:'converting'!

skippedInLiteralEncoding

    ^super skippedInLiteralEncoding , #( rewriteRule builder class )

    "Created: / 27-02-2013 / 09:34:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBTransformationRule methodsFor:'initialization'!

initialize
        super initialize.
        rewriteRule := ParseTreeSourceRewriter new

    "Modified: / 16-10-2014 / 01:01:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBTransformationRule methodsFor:'private'!

failedClassesInto:aStream 
    |result|
    
    (result := self result) notNil ifTrue:[
        result classesInto:aStream.
    ].

    "Created: / 10-01-2009 / 15:14:23 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 13-01-2009 / 16:53:28 / Jiri Bazant <bazanj2@fel.cvut.cz>"
!

failedMethodsInto:aStream 
    self result isNil ifFalse:[
        self result methodsInto:aStream.
    ].

    "Created: / 08-01-2009 / 09:46:48 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 12-01-2009 / 23:19:05 / Jiri Bazant <bazanj2@fel.cvut.cz>"
! !

!RBTransformationRule methodsFor:'running'!

checkMethod: aContext 
    self checkMethodReturningReplacements:aContext
!

checkMethod: aContext keepReplacements:keepReplacements
    "a special entry for smallLint, which wants to keep the replacements in order
     to be able to show what it is going to do in the quick-fix popup window."
     
    |tree|

    (rewriteRule canMatchMethod: aContext compiledMethod) ifFalse: [ 
        ^ self 
    ].
    class := aContext selectedClass.
    (rewriteRule executeTree: aContext parseTree) ifTrue: [
        tree := rewriteRule tree.
        (self class recursiveSelfRule executeTree: tree initialAnswer: false) ifFalse: [ 
            | source |

            source := rewriteRule isRewritingOriginalSource 
                        ifTrue:[tree source]
                        ifFalse:[tree formattedCode].
            builder compile: source in: class classified: aContext protocol 
        ] 
    ].
    keepReplacements ifFalse:[
        rewriteRule forgetReplacements
    ].    

    "Modified: / 01-03-2013 / 11:54:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethodReturningReplacements: aContext
    "a special entry for smallLint, which wants to keep the replacements in order
     to be able to show what it is going to do in the quick-fix popup window."
     
    |tree replacements selectedClass|

    selectedClass := aContext selectedClass.
    (self shouldIgnoreClass:selectedClass selector:aContext selector) ifTrue:[^ nil].
    "/ (self shouldIgnoreMethod:aContext) ifTrue:[^ nil]. -- not needed; same as above
    
    (rewriteRule canMatchMethod: aContext compiledMethod) ifFalse: [ 
        ^ nil 
    ].

    class := selectedClass.

    (rewriteRule executeTree: aContext parseTree) ifTrue: [
        tree := rewriteRule tree.
        (self class recursiveSelfRule executeTree: tree initialAnswer: false) ifFalse: [ 
            | source |

            source := rewriteRule isRewritingOriginalSource 
                        ifTrue:[tree source]
                        ifFalse:[tree formattedCode].
            builder compile: source in: class classified: aContext protocol 
        ] 
    ].
    replacements := rewriteRule replacements.
    rewriteRule forgetReplacements.
    ^ replacements    

    "Modified: / 01-03-2013 / 11:54:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forgetReplacements
    rewriteRule forgetReplacements
!

replacements
    ^ rewriteRule replacements
!

resetResult
	builder := CompositeRefactoryChange named: self name
! !

!RBTransformationRule methodsFor:'testing'!

hasConflicts
	^ true
!

isEmpty
        ^ builder isNil or:[builder changes isEmpty]
!

isTransformation
        ^ true
! !

!RBTransformationRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

