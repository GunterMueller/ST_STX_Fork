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

RBLintRule subclass:#RBCompositeLintRule
	instanceVariableNames:'rules name source'
	classVariableNames:'RuleSetsUserDefined'
	poolDictionaries:''
	category:'Refactory-Lint'
!

!RBCompositeLintRule class methodsFor:'documentation'!

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

!RBCompositeLintRule class methodsFor:'instance creation'!

decodeFromLiteralArray:anArray
    "Create & return a new instance from information encoded in anArray.
      Redefined for faster creation."

    | rule |

    rule := self new.
    self assert: anArray second == #name:.
    rule name: anArray third.
    self assert: anArray fourth == #rules:.
    rule rules: (anArray fifth collect:[:ruleA|ruleA decodeAsLiteralArray]).
    ^rule

    "
        #(RBCompositeLintRule
            name: 'test'
            rules: (
                ( RBBadMessageRule )
            )
        ) decodeAsLiteralArray


    "

    "Created: / 27-02-2013 / 09:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rules: aCollection
	^ self new
		rules: aCollection;
		yourself
!

rules: aCollection name: aString
	^ self new
		rules: aCollection;
		name: aString;
		yourself
!

rulesFor: aRuleClass
        | rules |
        rules := OrderedCollection new:150.
        aRuleClass withAllSubclassesDo: [ :each |
                each isVisible
                        ifTrue: [ rules add: each new ] ].
        rules sort:[ :a :b | a name <= b name ].
        ^ rules asArray
!

rulesGroupedFor: aRuleClass
        | groups rules |
        groups := Dictionary new.
        (self rulesFor: aRuleClass) do: [ :each |
                (groups at: each group ifAbsentPut: [ OrderedCollection new ])
                        addLast: each ].
        rules := SortedCollection sortBlock: [ :a :b | a name <= b name ].
        groups keysAndValuesDo: [ :group :elements |
                rules add: (RBCompositeLintRule 
                        rules: elements asArray
                        name: group) ].
        ^ rules asArray
! !

!RBCompositeLintRule class methodsFor:'accessing'!

allBroken
    "Returns collection all rules tagged as broken. Those rules should not
     be used normally, this method is for debugging / rule fixing purposes only"

    ^(RBLintRule allSubclasses)
        select:[:ruleClass|ruleClass isBroken]
        thenCollect:[:ruleClass|ruleClass new]

    "Created: / 26-07-2012 / 14:23:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allRules
    ^ self 
        rules: (Array with: self lintChecks with: self transformations) 
        name: 'All checks'
!

lintChecks

    ^ self 
            rules: (self rulesGroupedFor: RBBasicLintRule) 
            name: 'Lint checks'

    "
        RBCompositeLintRule allRules
    "

    "Modified: / 25-08-2010 / 14:35:02 / Jan Vrany <enter your email here>"
!

transformations
	^ self rules: (self rulesGroupedFor: RBTransformationRule) name: 'Transformations'
! !

!RBCompositeLintRule class methodsFor:'accessing-rule sets'!

rulesets
    ^ OrderedCollection new
        addAll: self rulesetsBuiltin;
        addAll: self rulesetsUserDefined;
        yourself

    "Created: / 16-10-2014 / 11:51:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rulesetsBuiltin
    "Return a set of built-in rulesets. These rulesets are always present"

    ^ {
        RBBuiltinRuleSet rulesetBuiltinDefaultForSTX .
        RBBuiltinRuleSet rulesetBuiltinDefault .
        RBBuiltinRuleSet rulesetBuiltinDefaultForPortability .
        RBBuiltinRuleSet rulesetBuiltinDefaultForVSEPortability .
        RBBuiltinRuleSet rulesetBuiltinDefaultForSilence .
    }

    "Created: / 16-10-2014 / 10:44:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rulesetsUserDefined
    "Returns the user-defined rule sets as a collection of RBCompositeRule"
    
    RuleSetsUserDefined isNil ifTrue:[
        RuleSetsUserDefined := UserPreferences current smallLintRulesetsUserDefined
    ].
    ^ RuleSetsUserDefined

    "
     RBCompositeLintRule rulesets"

    "Created: / 27-02-2013 / 11:04:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-10-2014 / 10:41:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rulesetsUserDefined:aCollection 
    RuleSets := aCollection.
    UserPreferences current smallLintRulesetsUserDefined:aCollection

    "Created: / 27-02-2013 / 11:10:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-10-2014 / 08:11:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBCompositeLintRule methodsFor:'accessing'!

addRule:aRule
    rules isNil ifTrue:[
        rules := OrderedCollection with:aRule
    ] ifFalse:[
        rules := rules asOrderedCollection.
        rules add:aRule
    ].
!

changes
	^ rules gather: [ :each  | each changes ]
!

failedRules
    ^ (rules ? #()) inject:OrderedCollection new
        into:[:oc :each | 
            oc
                addAll:each failedRules;
                yourself
        ]

    "Modified: / 23-09-2011 / 15:25:16 / cg"
!

flatten
    ^OrderedCollection streamContents: [:s | self flattenOn:s]

    "Created: / 26-07-2012 / 14:17:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoInToolTip
    name isNil ifTrue:[
        ^ (rules collect:#infoInToolTip) asStringWith:Character cr
    ].
    ^ name
!

isClassScope
    "true if I am or contain only class-rules"

    ^ rules conform:[:eachRule | eachRule isClassScope]
!

isMixedScope
    "true if I contain both class-rules and method rules"

    |hasClassScope hasMethodScope|

    hasClassScope := hasMethodScope := false.
    rules do:[:eachRule | 
        eachRule isClassScope ifTrue:[
            hasClassScope := true.
        ] ifFalse:[
            hasMethodScope := true.
        ].
        (hasClassScope and:[hasMethodScope]) ifTrue:[^ true].
    ].
    ^ false.
!

name
    ^ name ? '* unnamed *'
!

name: aString
	name := aString
!

problemCount
	^ rules inject: 0 into: [ :count :each | count + each problemCount ]
!

rationale
    "in some situations, the same rule may be included multiple times;
     therefore, create a set first"

    |setOfRationales|

    setOfRationales :=
        rules 
            collect:[:each |
                (each isComposite 
                    ifTrue:['']
                    ifFalse:['<H4>',each name,'</H4>']) ,each rationale
            ]
            as:OrderedSet.

    ^ "/ '<H3>',self name,'</H3>',
      (setOfRationales asOrderedCollection asStringWith:(Character cr , '<HR>' , Character cr))
!

ruleCount
    rules isNil ifTrue:[ ^ 0 ].
    ^ rules sum:[:each | (each ifNil:0 ifNotNil:[each ruleCount])].
    "/ ^ rules inject: 0 into: [ :count :each | count + (each ifNil:0 ifNotNil:[each ruleCount]) ]

    "Modified: / 27-02-2013 / 11:33:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rules
        ^ rules ? #()
!

rules:  aCollection
    rules := aCollection

    "Modified: / 26-02-2013 / 20:35:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scope

    ^nil
!

severity
    "redefined to return the max of my rules' severities"

    |hasWarning|

    rules do:[:each |
        each == SeverityError ifTrue:[^ SeverityError].
        hasWarning := (each == SeverityWarning).
    ].
    ^ hasWarning 
        ifTrue:[SeverityWarning] 
        ifFalse:[SeverityInformation]
!

source
    "Return a filename or method that defines this rule or nil if it was
     not loaded from either one
    "
    ^ source

    "Modified (comment): / 27-02-2013 / 10:48:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source:aFilenameOrMethod
    source := aFilenameOrMethod.
! !

!RBCompositeLintRule methodsFor:'comparing'!

= anotherRule
    |myRules otherRules|

    self class == anotherRule class ifFalse:[ ^ false ].
    self name = anotherRule name ifFalse:[ ^ false ].

    myRules := self rules.
    otherRules := anotherRule rules.
    myRules size == otherRules size ifFalse:[ ^ false ].

    (myRules asSortedCollection:[:a :b | a name < b name]) 
    with: (otherRules asSortedCollection:[:a :b | a name < b name]) 
    do:[:my :other|
        my class == other class ifFalse:[ ^ false ].
        my isComposite ifTrue:[
            my = other ifFalse:[ ^ false ]
        ]
    ].

    ^true

    "Created: / 27-02-2013 / 11:22:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-10-2014 / 18:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    "/ cg: source is not used when comparing, so it should not be here
    ^name hash bitXor:("source hash bitXor:"rules size hash)

    "Created: / 27-02-2013 / 11:18:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBCompositeLintRule methodsFor:'converting'!

literalArrayEncoding
    ^Array 
        with: self class name
        with: #name: with: name
        with: #rules: with: (rules collect:[:r|r literalArrayEncoding]) asArray

    "
        RBBadMessageRule new literalArrayEncoding decodeAsLiteralArray
    "

    "Created: / 27-02-2013 / 09:15:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBCompositeLintRule methodsFor:'copying'!

postCopy
    rules := rules collect:[ :each | 
        each isComposite 
            ifTrue:[ each copy ]
            ifFalse: [ each class new ]  
    ].

    "Created: / 16-10-2014 / 23:28:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBCompositeLintRule methodsFor:'displaying'!

displayString

    ^Text streamContents:
        [:s| | cnt |
        s nextPutAll: self name.
        s space.
        cnt := self ruleCount.
        cnt == 0 ifTrue:[s nextPutAll:(('[ no rules ]') withColor: Color gray)].
        cnt == 1 ifTrue:[s nextPutAll:(('[ 1 rule ]') withColor: Color gray)].
        cnt > 1 ifTrue:[s nextPutAll:(('[ ',cnt printString,' rules ]') withColor: Color gray)].
    ]

    "Created: / 24-07-2010 / 15:40:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 16-10-2014 / 10:35:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBCompositeLintRule methodsFor:'enumerating'!

reject: aBlock
    <resource: #obsolete>
    "Recursively removes all rules that maches given criteria.
     Unlike Collection method, this method MODIFIES RECEIVER.
    "

    self obsoleteMethodWarning:'use rejectRules:'.  "/ because of the above note
    self rejectRules:aBlock
!

rejectAllDialectSpecific

    ^self rejectAllTaggedByAny: #( 
        #squeak
        #pharo
        #visualworks #vw
        #dolphin
        #cuis
        #vast
        #gemstone
    )

    "Created: / 06-09-2012 / 14:58:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rejectAllInGroup: group
    "Recursively removes all rules that are in a given group.
     This method modifies the receiver
    "

    self rejectRules:[:e|e group = group]
!

rejectAllTaggedAs: tag
    "Recursively removes all rules that are tagged by
     given tag. This method modifies the receiver
    "

    self rejectRules:[:e|e isTaggedAs: tag]

    "Created: / 26-07-2012 / 14:19:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rejectAllTaggedByAll: tags
    "Recursively removes all rules that are tagged by
     all of given tags. This method modifies the receiver
    "

    self rejectRules:[:e|e isTaggedByAny: tags]

    "Created: / 26-07-2012 / 14:08:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rejectAllTaggedByAny: tags
    "Recursively removes all rules that are tagged by
     any of given tags. This method modifies the receiver
    "

    self rejectRules:[:e|e isTaggedByAny: tags]

    "Created: / 26-07-2012 / 14:08:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rejectRules: aBlock
    "Recursively removes all rules which match the given criteria.
     Unlike Collection methods, this method MODIFIES THE RECEIVER.
    "

    rules := rules 
                reject:[:rule|
                    rule isComposite ifTrue:[
                        rule rejectRules: aBlock.
                        rule rules isEmptyOrNil.
                    ] ifFalse:[
                        aBlock value: rule
                    ]
                ]

    "Created: / 26-07-2012 / 13:46:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

select: aBlock
    <resource: #obsolete>
    "Recursively selects all rules that maches given criteria.
     Unlike Collection method, this method MODIFIES RECEIVER.
    "

    self obsoleteMethodWarning:'use selectRules:'.  "/ because of the above note
    ^self selectRules:aBlock
!

selectAllTaggedAs: tag
    "Recursively selects all rules that are tagged by
     given tag. This method modifies the receiver
    "

    self selectRules:[:e|e isTaggedAs: tag]

    "Created: / 26-07-2012 / 14:19:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectAllTaggedByAll: tags
    "Recursively select only rules that are tagged by
     all of given tags. This method modifies the receiver
    "

    self selectRules:[:e|e isTaggedByAny: tags]

    "Created: / 26-07-2012 / 14:09:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectAllTaggedByAny: tags
    "Recursively select only rules that are tagged by
     any of given tags. This method modifies the receiver
    "

    self select:[:e|e isTaggedByAny: tags]

    "Created: / 26-07-2012 / 14:10:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectRules: aBlock
    "Recursively selects all rules that maches given criteria.
     Unlike Collection method, this method MODIFIES RECEIVER.
    "

    ^self rejectRules:[:rule|(aBlock value: rule) not]

    "Created: / 26-07-2012 / 14:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBCompositeLintRule methodsFor:'initialization'!

recursiveInitialize
    "initialize myself (and if I am a composite rule, all the sub rules)."

    rules do: [ :each | each recursiveInitialize; resetResult ]
!

recursiveReinstantiate
    rules := rules collect: [ :each | each recursiveReinstantiate].
    ^ self.
!

resetResult
	rules do: [ :each | each resetResult ]
! !

!RBCompositeLintRule methodsFor:'private'!

failedClassesInto:aStream 
    self failedRules do:[:failedRule | 
        failedRule failedClassesInto:aStream
    ]

    "Created: / 10-01-2009 / 15:14:42 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 22-07-2009 / 14:41:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

failedMethodsInto:aStream 
    self failedRules do:[:failedRule | 
        failedRule failedMethodsInto:aStream
    ]

    "Created: / 08-01-2009 / 13:01:03 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 08-01-2009 / 23:49:30 / Jiri Bazant <bazanj2@fel.cvut.cz>"
!

flattenOn: stream

    (self rules ? #()) do:[:rule| rule notNil ifTrue:[rule flattenOn: stream]]

    "Created: / 21-07-2009 / 23:12:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-09-2011 / 15:25:04 / cg"
    "Modified: / 29-05-2014 / 15:53:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBCompositeLintRule methodsFor:'running'!

checkClass: aContext 
	rules do: [ :each | each checkClass: aContext ]
!

checkMethod: aContext 
	rules do: [ :each | each checkMethod: aContext ]
! !

!RBCompositeLintRule methodsFor:'testing'!

hasConflicts
	^ rules anySatisfy: [ :each | each hasConflicts ]
!

isBuiltin
    ^ false

    "Created: / 16-10-2014 / 10:24:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isComposite
	^ true
!

isEmpty
    ^ rules isEmptyOrNil or:[ rules allSatisfy: [ :each | each isEmpty ]]

    "Modified: / 01-03-2012 / 08:34:41 / cg"
!

isEmptyInTree
    "added due to the semantic confusion of isEmpty 
     (means both: has subitems AND has subitems with result !!)"

    ^ rules isEmptyOrNil or:[ rules allSatisfy: [ :each | each isEmptyInTree ]]

    "Created: / 01-03-2012 / 19:05:53 / cg"
!

isUserDefined
    ^ false

    "Created: / 16-10-2014 / 10:24:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBCompositeLintRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

