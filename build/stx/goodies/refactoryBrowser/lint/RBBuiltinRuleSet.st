"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBLintRuleSet subclass:#RBBuiltinRuleSet
	instanceVariableNames:''
	classVariableNames:'BuiltinDefault BuiltinDefaultForSTX BuiltinDefaultForPortability
		BuiltinDefaultForVSEPortability BuiltinDefaultForSilence'
	poolDictionaries:''
	category:'Refactory-Lint'
!

!RBBuiltinRuleSet class methodsFor:'documentation'!

documentation
"
    some common useful builtin rulesets
"
! !

!RBBuiltinRuleSet class methodsFor:'accessing-rule sets'!

flushBuiltinDefault
"/    BuiltinDefault notNil ifTrue:[
"/        BuiltinDefault recursiveReinstantiate.
"/    ].
"/    BuiltinDefault := nil.

    self classVarNames 
        select:[:nm | nm startsWith:'Builtin'] 
        thenDo:[:eachName |
            |def|

            def := self classVarAt:eachName.
            def notNil ifTrue:[
                def recursiveReinstantiate.
                self classVarAt:eachName put:nil.
            ].    
        ].
!

rulesetBuiltinDefault
    "Return the 'Default' ruleset. 

     THIS IS NOT a default which user selected in preferences, 
     this is a default which is always present"

    BuiltinDefault isNil ifTrue:[ 
        "/ self projectDefinitionClass loadAllAutoloadedClasses.

        BuiltinDefault := 
            RBBuiltinRuleSet allRules
                name: 'Default (strict)';
                rejectAllTaggedAs: #broken;
                rejectAllTaggedAs: #stx;
                rejectAllTaggedAs: #obsolete;
                "/ rejectAllTaggedAs: #pharo;
                "/ rejectAllTaggedAs: #squeak;
                rejectAllTaggedAs: #dogmatic;
                rejectAllTaggedAs: #notSTX;
                rejectAllTaggedAs: #excludedByDefault;
                yourself
    ].
    ^ BuiltinDefault

    "
    BuiltinDefault := nil.
    "

    "Created: / 13-10-2014 / 22:18:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-10-2014 / 11:48:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rulesetBuiltinDefaultForPortability
    "Return the 'Default' ruleset used for portable Smalltalk programming.
     Includes all compatibility check rules, 
     which are usually otherwise not of interest to ST/X programmers"

    BuiltinDefaultForPortability isNil ifTrue:[ 
        "/ self projectDefinitionClass loadAllAutoloadedClasses.

        BuiltinDefaultForPortability := 
            RBBuiltinRuleSet allRules
                name: 'Default (Portability)';
                rejectAllTaggedAs: #broken;
                rejectAllTaggedAs: #obsolete;
                rejectAllTaggedAs: #dogmatic;
                rejectAllTaggedAs: #notSTX;
                rejectAllTaggedAs: #excludedByDefault;
                yourself
    ].
    ^ BuiltinDefaultForPortability

    "
     BuiltinDefaultForPortability := nil.
    "
!

rulesetBuiltinDefaultForSTX
    "Return the 'Default' ruleset used for ST/X programming.
     Excludes the EOL-comment and other compatibility rules, 
     which are usually not of interest to ST/X programmers"

    BuiltinDefaultForSTX isNil ifTrue:[ 
        "/ self projectDefinitionClass loadAllAutoloadedClasses.

        BuiltinDefaultForSTX := 
            RBBuiltinRuleSet allRules
                name: 'Default (ST/X)';
                rejectAllTaggedAs: #broken;
                rejectAllTaggedAs: #portability;
                rejectAllTaggedAs: #obsolete;
                rejectAllTaggedAs: #pharo;
                rejectAllTaggedAs: #squeak;
                rejectAllTaggedAs: #vse;
                rejectAllTaggedAs: #notSTX;
                rejectAllTaggedAs: #dogmatic;
                rejectAllTaggedAs: #excludedByDefault;
"/                rejectAllInGroup: 'Transformations';
                yourself
    ].
    ^ BuiltinDefaultForSTX

    "
     BuiltinDefaultForSTX := nil.
    "
!

rulesetBuiltinDefaultForSilence
    "Return an empty 'Default' ruleset.
     Includes no rule at all. 
     Set this to turn off checking while typing,
     without completely disabling smallsense"

    BuiltinDefaultForSilence isNil ifTrue:[ 
        BuiltinDefaultForSilence := 
            RBBuiltinRuleSet allRules
                name: 'Default (Silence)';
                rejectRules:[:r | true];
                yourself
    ].
    ^ BuiltinDefaultForSilence

    "
     BuiltinDefaultForSilence := nil.
    "
!

rulesetBuiltinDefaultForVSEPortability
    "Return the 'Default' ruleset used for VSE portable Smalltalk programming.
     This is an exept-internal rule, usually not of interest to other programmers."

    BuiltinDefaultForVSEPortability isNil ifTrue:[ 
        "/ self projectDefinitionClass loadAllAutoloadedClasses.

        BuiltinDefaultForVSEPortability := 
            RBBuiltinRuleSet allRules
                name: 'Default (VSE Portability)';
                rejectAllTaggedAs: #broken;
                rejectAllTaggedAs: #obsolete;
                rejectAllTaggedAs: #notSTX;
                rejectRules:[:e| (e isTaggedAs:#dogmatic) and:[ (e isTaggedAs:#vse) not]];
                rejectRules:[:e| (e isTaggedAs:#squeak) and:[ (e isTaggedAs:#vse) not]];
                rejectRules:[:e| (e isTaggedAs:#pharo) and:[ (e isTaggedAs:#vse) not]];
                rejectRules:[:e| (e isTaggedAs:#stx) and:[ (e isTaggedAs:#vse) not]];
                rejectAllTaggedAs: #excludedByDefault;
                yourself
    ].
    ^ BuiltinDefaultForVSEPortability

    "
     BuiltinDefaultForVSEPortability := nil.
    "
! !

!RBBuiltinRuleSet methodsFor:'copying'!

postDeepCopy
    super postDeepCopy.
    self changeClassTo: RBUserDefinedRuleSet

    "Created: / 24-11-2014 / 11:28:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBBuiltinRuleSet methodsFor:'displaying'!

displayString

    ^Text streamContents:
        [:s| | cnt |
        s nextPutAll: self name.
        s space.
        cnt := self ruleCount.
        cnt == 0 ifTrue:[s nextPutAll:(('[ no rules ') withColor: Color gray)].
        cnt == 1 ifTrue:[s nextPutAll:(('[ 1 rule ') withColor: Color gray)].
        cnt > 1 ifTrue:[s nextPutAll:(('[ ',cnt printString,' rules ') withColor: Color gray)].
        s nextPutAll:(('- built-in ]') withColor: Color gray).
    ]

    "Created: / 16-10-2014 / 10:36:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBBuiltinRuleSet methodsFor:'testing'!

isBuiltin
    ^ true

    "Created: / 16-10-2014 / 10:25:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBBuiltinRuleSet class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

