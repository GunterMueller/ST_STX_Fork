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

Object subclass:#SmalllintContext
	instanceVariableNames:'class selector parseTree literals literalSemaphore literalProcess
		selectors compiledMethod selfMessages superMessages messages
		allMessages explicitSourceCode'
	classVariableNames:'AccessLock LiteralsPerClass LiteralsSema LiteralsProcess
		AllLiterals AllSelectors AnyChangeSinceLastScan'
	poolDictionaries:''
	category:'Refactory-Lint'
!

!SmalllintContext class methodsFor:'documentation'!

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

!SmalllintContext class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
!

newNoCache
	^self basicNew
! !

!SmalllintContext class methodsFor:'utilities'!

computeLiterals
    |literals|

    AccessLock isNil ifTrue:[
        AccessLock := RecursionLock new.
    ].
    [
        AccessLock critical:[
            ((literals := AllLiterals) isNil 
            or:[ AnyChangeSinceLastScan
            or:[ LiteralsProcess notNil and:[LiteralsProcess isDead not]]]) ifTrue:[
                "/ must compute
                Smalltalk addDependent:self.

                LiteralsSema isNil ifTrue:[
                    LiteralsSema := Semaphore new.
                ].
                (AnyChangeSinceLastScan or:[(LiteralsProcess isNil or:[LiteralsProcess isDead])]) ifTrue:[
                    LiteralsProcess := 
                        [
                            "/ Transcript showCR:'start'.
                            [
                                AnyChangeSinceLastScan := false.
                                self primitiveComputeLiterals.
                                AnyChangeSinceLastScan
                            ] whileTrue.
                            LiteralsSema signalForAll.
                            "/ Transcript showCR:'done'.
                        ] fork.
                ] ifFalse:[
                    LiteralsSema signal.
                ].
            ] ifFalse:[
                LiteralsSema signal.
            ].
        ].
        LiteralsSema wait.
        literals := AllLiterals.
        literals isNil 
    ] whileTrue.
    ^ literals

    "
     self computeLiterals
    "
!

computeLiteralsForClass: aClass
        |litsPerClass selectors|

        AccessLock critical:[
            LiteralsPerClass isNil ifTrue:[
                LiteralsPerClass := Dictionary new.
            ].
            litsPerClass := LiteralsPerClass at:aClass name ifAbsent:[nil].
        ].
        selectors := aClass selectors.
        AccessLock critical:[
            AllSelectors addAll: selectors.
        ].
        litsPerClass isNil ifTrue:[
            "/ Transcript showCR:'start for ',aClass name.
            litsPerClass := Set new.
            selectors do:[:sel | 
                self computeLiteralsForSelector: sel in: aClass into:litsPerClass.
                "/ Processor yield
            ].
            AccessLock critical:[
                LiteralsPerClass at:aClass name put:litsPerClass.
            ].
            "/ Transcript showCR:'done for ',aClass name.
        ].
        AccessLock critical:[
            AllLiterals addAll:litsPerClass.
        ].
        ^ litsPerClass
!

computeLiteralsForLiteral: aLiteral into:aSet
        (aLiteral isSymbol or: [aLiteral isVariableBinding])
            ifTrue: [aSet add:aLiteral]
            ifFalse:[
                aLiteral isArray ifTrue: [
                    aLiteral do: [:each | self computeLiteralsForLiteral: each into:aSet]
                ]
            ]
!

computeLiteralsForMethod: aCompiledMethod into:aSet
        aCompiledMethod withAllBlockMethodsDo:[:each | 
            each literalsDo: [:literal | 
                self computeLiteralsForLiteral: literal into:aSet 
            ]
        ].
!

computeLiteralsForSelector: aSelector in: aClass into:aSet 
        | method |
        method := aClass compiledMethodAt: aSelector ifAbsent: [nil].
        method notNil ifTrue: [
            self computeLiteralsForMethod: method into:aSet
        ].

    "Modified: / 01-03-2012 / 14:36:31 / cg"
!

computeSelectors
    |selectors|

    AccessLock isNil ifTrue:[
        AccessLock := RecursionLock new.
    ].
    AccessLock critical:[
        ((selectors := AllSelectors) isNil 
        or:[ AnyChangeSinceLastScan
        or:[ LiteralsProcess notNil and:[LiteralsProcess isDead not]]]) ifTrue:[
            self computeLiterals.   "/ must compute
            selectors := AllSelectors.
        ].
    ].
    ^ selectors

    "
     self computeSelectors
    "
!

primitiveComputeLiterals
    AccessLock critical:[
        AllLiterals := IdentitySet new: 25000.
        AllLiterals addAll: self specialSelectors.
        AllSelectors := IdentitySet new.
    ].
    Smalltalk allBehaviorsDo: [:aClass | 
        self computeLiteralsForClass: aClass
    ].

    "Modified (format): / 26-11-2016 / 11:25:38 / cg"
!

specialSelectors
        RBParser isSmalltalkX ifTrue:[
            ^ #()
        ].
        ^(OpcodePool at: #SpecialSelectorDictionary) keys

    "Modified: / 4.2.2000 / 11:11:41 / cg"
!

update:something with:aParameter from:changedObject
    changedObject == Smalltalk ifTrue:[
        LiteralsPerClass notNil ifTrue:[
            AccessLock critical:[
                |changedClass ignore|

                LiteralsPerClass notNil ifTrue:[
                    ignore := false.

                    something == #methodInClass ifTrue:[
                        changedClass := aParameter at:1.
                    ].
                    something == #methodInClassRemoved ifTrue:[
                        changedClass := aParameter at:1.
                    ].
                    something == #newClass ifTrue:[
                        changedClass := aParameter
                    ].
                    ( #( #prePackageLoad #postPackageLoad #preClassLoad #postClassLoad #preLoad #postLoad
                         #aboutToAutoloadClass
                         #projectOrganization #organization #classVariables #classDefinition #currentChangeSet
                         #methodTrap
                    ) includes:something) ifTrue:[
                        ignore := true.
                    ].
                    ignore ifFalse:[
                        changedClass notNil ifTrue:[
                            LiteralsPerClass removeKey:changedClass name ifAbsent:[]
                        ] ifFalse:[
                            "/ for now, flush all; in the future, do a selectve flush
                            LiteralsPerClass removeAll.
                            self breakPoint:#cg.
                        ].
                        AnyChangeSinceLastScan := true.
                    ].
                ].
            ].
        ].
    ].
! !

!SmalllintContext methodsFor:'accessing'!

allMessages
        allMessages isNil ifTrue: [self computeMessages].
        ^allMessages

    "Created: / 07-04-2012 / 12:56:03 / cg"
!

compiledMethod
	^compiledMethod notNil
		ifTrue: [compiledMethod]
		ifFalse: [compiledMethod := class compiledMethodAt: selector]
!

explicitSourceCode:aString
    "to allow giving some arbitrary source to it
     (in case there is no method, as in an editor)"
     
    explicitSourceCode := aString
!

instVarNames
	^self selectedClass allInstVarNames
!

literals
    "/ new code: used cached data from class
    literals isNil ifTrue:[
        literals := self class computeLiterals.
    ].
    ^ literals

"/ old code
"/        |s|
"/
"/        (s := literalSemaphore) isNil
"/                ifTrue: 
"/                        [literals isNil ifTrue: 
"/                                        [self computeLiterals wait]]
"/                ifFalse: [s wait].
"/        ^literals

    "Modified: / 07-03-2012 / 18:09:53 / cg"
!

messages
	messages isNil ifTrue: [self computeMessages].
	^messages
!

parseTree
	^parseTree isNil
		ifTrue: [parseTree := self buildParseTree]
		ifFalse: [parseTree]
!

protocol
	^self selectedClass whichCategoryIncludesSelector: self selector
!

protocols
	^Array with: self protocol
!

selectedClass
	^class
!

selectedClass: anObject 
	class := anObject.
	self selector: nil
!

selector
	^selector
!

selector: anObject 
        selector := anObject.
        parseTree := compiledMethod := selfMessages := superMessages := messages := allMessages := nil
!

selectors
    "/ new code: used cached data from class
    literals isNil ifTrue:[
        literals := self class computeLiterals.
    ].
    ^ AllSelectors

"/ old code
"/        |s|
"/
"/        (s := literalSemaphore) isNil
"/                ifTrue: 
"/                        [selectors isNil ifTrue: 
"/                                        [self computeLiterals wait]]
"/                ifFalse: [s wait].
"/        ^selectors

    "Modified: / 07-03-2012 / 18:09:49 / cg"
!

selfMessages
	selfMessages isNil ifTrue: [self computeMessages].
	^selfMessages
!

sourceCode
    |mthd|
    
    explicitSourceCode notNil ifTrue:[^ explicitSourceCode].
    mthd := self compiledMethod.
    mthd isNil ifTrue:[
        Transcript showCR:'[SmalllintContext] warning: no source'.
        "/ ^ ''
    ].
    ^mthd source
!

superMessages
	superMessages isNil ifTrue: [self computeMessages].
	^superMessages
! !

!SmalllintContext methodsFor:'initialize-release'!

initialize
    "/ old code:
    "/ self computeLiterals
    "/ now using the common shared scanner on the class side
!

release
	literalProcess notNil ifTrue: [literalProcess terminate].
	super release
! !

!SmalllintContext methodsFor:'printing'!

printOn:aStream
    'SmalllintContext(' printOn:aStream. "/ 'class: ' printOn:aStream.
    class printOn:aStream. 
    '  ' printOn:aStream. "/' selector: ' printOn:aStream.
    selector printOn:aStream. 
    ')' printOn:aStream.

    "Modified: / 15-03-2016 / 14:25:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalllintContext methodsFor:'private'!

addLiteralsFor: aCompiledMethod
    <resource: #obsolete>
 
        "/ old code; now obsolete

        aCompiledMethod withAllBlockMethodsDo: 
                        [:each | 
                        each literalsDo: [:literal | self checkLiteral: literal]]
!

buildParseTree
        | tree |
        tree := self selectedClass parseTreeFor: self selector.
        tree isNil ifTrue: [^RBParser parseMethod: 'method'].
        ^tree
!

checkLiteral: aLiteral
    <resource: #obsolete>
 
        "/ old code; now obsolete

        (aLiteral isSymbol or: [aLiteral isVariableBinding])
                ifTrue: [literals add: aLiteral]
                ifFalse: 
                        [aLiteral isArray
                                ifTrue: [aLiteral do: [:each | self checkLiteral: each]]]
!

computeLiterals
        <resource: #obsolete>
        "/ old code; now obsolete

        |sema|

        sema := literalSemaphore := Semaphore new.
        literalProcess := [self primitiveComputeLiterals] fork.
        ^ sema

    "Modified: / 07-03-2012 / 18:07:48 / cg"
!

computeLiteralsForClass: aClass
    <resource: #obsolete>
 
        "/ old code; now obsolete

        (selectors addAll: aClass selectors) do: 
                        [:sel | 
                        self computeLiteralsForSelector: sel in: aClass.
                        Processor yield]
!

computeLiteralsForSelector: aSelector in: aClass
    <resource: #obsolete>
 
        "/ old code; now obsolete

        | method |
        method := aClass compiledMethodAt: aSelector ifAbsent: [nil].
        method notNil ifTrue: [
            self addLiteralsFor: method
        ]

    "Modified: / 01-03-2012 / 14:36:31 / cg"
!

computeMessages
    "/ cg: why was this marked as obsolete?
    "/ it is still used by SmalllintContext allMessages
    "/ <resource: #obsolete>

    | searcher |

    selfMessages := Set new.
    superMessages := Set new.
    messages := Set new.

    searcher := ParseTreeSearcher new.
    searcher
            matches: 'self `@message: ``@args'
                    do: [:aNode :answer | selfMessages add: aNode selector];
            matches: 'super `@message: ``@args'
                    do: [:aNode :answer | superMessages add: aNode selector];
            matches: '``@receiver `@message: ``@args'
                    do: [:aNode :answer | messages add: aNode selector].
    searcher executeTree: self parseTree initialAnswer: nil.

    "/ cg: messages should include self and super messages as well;
    "/ I add allMessages, just in case to avoid breaking some code which depends
    "/ on the sets being disjoint.
    "/ late note: yes it would (sentNotImplementedRule thinks them disjoint)
    allMessages := Set new.
    allMessages addAll: messages; addAll: selfMessages; addAll: superMessages.

    "Modified (comment): / 07-04-2012 / 12:57:28 / cg"
!

primitiveComputeLiterals
        <resource: #obsolete>
        "/ old code; now obsolete

        | semaphore |

        literals := IdentitySet new: 25000.
        literals addAll: self class specialSelectors.
        selectors := IdentitySet new.
        Smalltalk allBehaviorsDo: [:aClass | self computeLiteralsForClass: aClass].
        semaphore := literalSemaphore.
        literalSemaphore := nil.
        self signalProcesses: semaphore.
        ^literalProcess := nil
!

signalProcesses: aSemaphore 
	aSemaphore isNil ifTrue: [^self].
	[aSemaphore isEmpty] whileFalse: [aSemaphore signal]
! !

!SmalllintContext methodsFor:'testing'!

implements: aSelector 
	^self selectors includes: aSelector
!

includesBehaviorNamed: clsName

    | cls |
    cls := Smalltalk at: clsName asSymbol.
    ^cls notNil and:[self selectedClass includesBehavior: cls].

    "Created: / 05-08-2011 / 13:48:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isAbstract: aClass 
	^(aClass isMeta or: 
			[(self literals includes: aClass name)
				or: [self literals includes: (Smalltalk associationAt: aClass name)]])
		not
!

uses: anObject 
	^self literals includes: anObject
! !

!SmalllintContext class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

