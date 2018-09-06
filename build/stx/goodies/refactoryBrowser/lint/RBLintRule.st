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

Object subclass:#RBLintRule
	instanceVariableNames:''
	classVariableNames:'SeverityInformation SeverityWarning SeverityError'
	poolDictionaries:''
	category:'Refactory-Lint'
!

RBLintRule class instanceVariableNames:'protoInstance'

"
 No other class instance variables are inherited by this class.
"
!

!RBLintRule class methodsFor:'documentation'!

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
    RBLintRule is a base class for SmallLint check rule. 
    Each individual rule is a separate class. TBW

    == Tags ==
    Each rule may is tagged by number of tags (symbols). Applications may/may not
    use/recognize those tags. Meaning of the tags is given by convention only.
    To tag a rule, create a class method [RuleClass class]>>tagsBasic if it does not
    exist and put your tag there. NEVER override #tags.

    Some commonly used tags:

      general:

        #broken     rule is broken, does not work and should not be at all used

        #good       rule is good (ensures good code or style, has very little false-positives
                    ...), it is highly recommended to use it.

        #stc        rule that checks for known STC bugs/limitations. 
                    Code marked by #stc-tagged rules 
                    won't be compiled properly or not at all by stc.

        #projectchecker 
                    rule that is run by project checker to check code before commit

      portability tags:

        #portability    rule that detects 'less likely portable' code

        #squeak         checks for Squeak specific code, should not be used in ST/X
        #pharo          checks for Pharo specific code, should not be used in ST/X
        #vse            checks for VSE (visual smalltalk enterprise) specific code, should not be used in ST/X
        #stx            checks for Smalltalk/X specific code
        #notSTX         checks which do not work correctly in ST/X, should not be used in ST/X

      ... add more when it make sense ...

    Having a RBCompositeChange at hand, you may use rejectAllTagged*/selectAllTagged* methods
    to select/remove rules with particular tags. Example:

        1) From all rules, selects only those tagged by #squeak

            RBCompositeLintRule allRules selectAllTaggedAs: #squeak

        2) From all rules, remove all tagged by either #squeak or #pharo

            RBCompositeLintRule allRules rejectAllTaggedByAny: #( squeak pharo )

    [author:]
        RefactoryBrowser team (original version of lint)
        Squeak/Pharo team (this code is ported from Pharo)

        Jan Vrany <jan.vrany@fit.cvut.cz> (Smalltalk/X, rule tweaks)
        Claus Gittinger <cg@exept.de> (Smalltalk/X, rule tweaks)

    [instance variables:]

    [class variables:]

    [see also:]
        RBCompositeRule (category enumerating in particular)

"
! !

!RBLintRule class methodsFor:'initialization'!

initialize
    SeverityInformation := #information.
    SeverityWarning := #warning.
    SeverityError := #error.
! !

!RBLintRule class methodsFor:'instance creation'!

new
    "return an initialized instance."

    ^ self basicNew initialize.
! !

!RBLintRule class methodsFor:'accessing'!

severityError
    ^ SeverityError
!

severityInformation
    ^ SeverityInformation
!

severityWarning
    ^ SeverityWarning
!

tags
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    "NEVER OVERRIDE this method, put your tags to tagsBasic!!!!!!
     This method is meant as an extension point, so in the future
     other packages may add their own tags to rules without overwriting
     method"    

    ^self tagsBasic

    "Created: / 25-07-2012 / 14:10:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#(  )

    "Created: / 25-07-2012 / 14:33:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLintRule class methodsFor:'automatic reinitialization'!

addSelector:sel withMethod:aMethod
    "cg: I am tired of my changes having no effect on those cached
     existing instances. Therefore, intercept the change here, and
     reinitialize existing instances..."

    super addSelector:sel withMethod:aMethod.
    sel == #initialize ifTrue:[
        self allSubInstancesDo:[:each |
            each initialize
        ]
    ].
! !

!RBLintRule class methodsFor:'changes'!

changed:aParameter with:anArgument
    "/ whenever anything changes in myself (method changed),
    "/ flush the protoType

    protoInstance := nil.
    ^ super changed:aParameter with:anArgument
! !

!RBLintRule class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == RBLintRule.
!

isTaggedAs: tag
    "Return true, if the rule is tagged by given tag"

    ^self tags includes: tag

    "Created: / 26-07-2012 / 13:49:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLintRule class methodsFor:'testing'!

isBroken
    "Return true, if the rule is 'broken', i.e., if
     it is known it does not work/is buggy"

    ^self isTaggedAs: #broken

    "Created: / 26-07-2012 / 13:41:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTaggedByAll: tags
    "Return true, if the ruleis tagged by ALL of the given tags"

    ^self tags includesAll: tags.

    "Created: / 26-07-2012 / 13:51:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTaggedByAny: tags
    "Return true, if the ruleis tagged by ANY of the given tags"

    ^self tags includesAny: tags.

    "Created: / 26-07-2012 / 13:51:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isVisible
	"Answer true if the class should be visible in the GUI."

	^ false
! !

!RBLintRule methodsFor:'accessing'!

addFixesForClass:aClassOrNil selector:aSelectorOrNil to:fixer 
    "Adds all possible code fixes to given quick fixer.
     Default is to do nothing, meaning that there are
     no quickfixes available"

    | changes filteredChanges |

    changes := self changes.
    changes isEmptyOrNil ifTrue:[^ self].
 
    filteredChanges := changes.
    aClassOrNil notNil ifTrue:[
        filteredChanges := filteredChanges select:[:chg | chg changeClass == aClassOrNil]
    ].    
    aSelectorOrNil notNil ifTrue:[
        filteredChanges := filteredChanges select:[:chg | chg selector = aSelectorOrNil].
    ].    
    filteredChanges isEmptyOrNil ifTrue:[^ self].
    
    fixer fix
        rule: self;
        label:self nameOfFix ;
        action: [
            fixer apply: ((CompositeRefactoryChange new changes:filteredChanges) name: self name)
                         "/ ((ChangeSet withAll:filteredChanges) name: self name)
        ].
!

addPossibleFixesTo: fixer
    | changes |

    changes := self changes.
    changes notEmptyOrNil ifTrue:[
        fixer fix
            label:(self nameOfFix);
            action: [ 
                fixer apply: ((ChangeSet withAll:changes) name: self name)
            ].
    ]

    "Created: / 01-02-2012 / 12:11:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 17-10-2014 / 00:42:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changes
	^ #()
!

failedClasses
    |s|

    s := OrderedCollection new.
    self failedClassesInto:s.
    ^ s asArray

    "Created: / 22-07-2009 / 14:18:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-10-2009 / 16:36:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

failedMethods
    |s|

    s := OrderedSet new .
    self failedMethodsInto:s.
    s := s select:[:el | el notNil].
    ^ s asArray

    "Created: / 22-07-2009 / 14:18:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-10-2009 / 16:36:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2011 / 19:30:10 / cg"
!

failedMethodsInAnyOf: classes meta: meta

    | klasses |
    klasses := meta 
                ifTrue:[classes collect:[:cls|cls theMetaclass]]
                ifFalse:[classes collect:[:cls|cls theNonMetaclass]].

    ^self failedMethods select:
        [:mth|klasses includes: mth mclass].

    "Created: / 02-02-2010 / 21:45:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flattened

    | s |
    s := (OrderedCollection new: 16) writeStream.
    self flattenOn: s.
    ^s contents.

    "Created: / 21-07-2009 / 23:13:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-07-2009 / 15:47:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

forgetReplacements
    "/ intentionally let blank
!

group
        ^ '' "/ String new
!

infoInToolTip
    "by default, show the name and the group of the rule in the tooltip;
     redefined by some, to show more detail.
     But it should only be one line per rule"
     
    ^ self name allBold, ' ( ',self group allItalic,' )'
!

isClassScope
    "true if I am or contain only class-rules"

    ^self subclassResponsibility
!

isMixedScope
    "true if I contain both class-rules and method rules"
    
    "only to be redefined in Composite rules"
    
    ^ false
!

name
	self subclassResponsibility
!

nameOfFix
    ^ 'Rewrite the code'
!

problemCount
	self subclassResponsibility
!

rationale
        ^ '' "/ String new
!

rationaleWithAnchor
    "return the rationale string plus an anchor to browse the rule class"
    
    self isComposite ifTrue:[^ self rationale].

    ^ '
<b>',self name,'</b> (<I>',self group,'</I>)
<p>', 
self rationale,
'<p>
Class: <A ACTION="',self className,' browse">',self className,'</A>'

    "Created: / 01-03-2012 / 20:58:43 / cg"
!

rationaleWithAnchorForClass:aClass
    "fallback here: same as rationaleWithAnchor
     Can be redefined to return class-specific rationale text in the smallLint viewer"
    
    ^ self rationaleWithAnchor
!

rationaleWithAnchorForMethod:aMethod
    "fallback here: same as rationaleWithAnchor
     Can be redefined to return method-specific rationale text in the smallLint viewer"
    
    ^ self rationaleWithAnchor
!

result
        self subclassResponsibility
!

resultClass
    "return the class of the environment I return;
     typically one of SelectorEnvironment, VariableEnvironment or ClassEnvironment"
     
    self subclassResponsibility
!

ruleCount

    ^1

    "Created: / 24-07-2010 / 15:38:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scope

    ^self subclassResponsibility
!

severity
    "redefine to return one of:
        SeverityInformation
        SeverityError
        SeverityWarning (no need to redefine - except for documentation)
    "
    
    ^SeverityWarning

    "Created: / 14-03-2011 / 14:11:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severityAsInteger
    "return an integer to compare severities (useful for sorting by severity)."

    |severity|

    severity := self severity.
    severity == #error ifTrue:[
        ^ 100
    ].
    severity == #warning ifTrue:[
        ^ 50
    ].
    severity == #information ifTrue:[
        ^ 10
    ].
    ^ 0    
! !

!RBLintRule methodsFor:'converting'!

literalArrayEncoding
    ^Array with: self class name

    "Created: / 27-02-2013 / 22:44:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLintRule methodsFor:'displaying'!

displayString

    ^Text streamContents:
        [:s|
            | scope group |
            s nextPutAll: self name.

            (group := self group) notEmptyOrNil ifTrue:[
                s nextPutAll:((' (in ', group , ')') withColor: Color gray)
            ].
            (scope := self scope) notNil ifTrue:[
                s nextPutAll:((' [', scope , ']') withColor: Color gray)
            ].
        ]

    "Created: / 02-02-2010 / 20:21:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 16:51:50 / cg"
! !

!RBLintRule methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)

    "/ super initialize.   -- commented since inherited method does nothing
!

recursiveInitialize
    "initialize myself (and if I am a composite rule, all the sub rules)."

    self initialize
!

recursiveReinstantiate
    "initialize myself (and if I am a composite rule, all the sub rules)."

    ^ (Smalltalk classNamed:self class name) new initialize
! !

!RBLintRule methodsFor:'printing'!

printOn: aStream 
	super printOn: aStream.
	self name isNil 
		ifFalse: [ aStream nextPutAll: ' name: '; print: self name ]
! !

!RBLintRule methodsFor:'private'!

addClass:class selector:selector to:result 

    (self shouldIgnoreClass: class selector: selector) ifFalse:[
        result 
            addClass:class
            selector:selector
    ]

    "Created: / 24-08-2010 / 21:28:19 / Jan Vrany <enter your email here>"
!

failedClassesInto:arg 
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 10-01-2009 / 15:13:54 / Jiri Bazant <bazanj2@fel.cvut.cz>"
!

failedMethodsInto:arg 
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 08-01-2009 / 09:46:53 / Jiri Bazant <bazanj2@fel.cvut.cz>"
!

failedRules
	^self isEmpty
		ifTrue: [#()]
		ifFalse: [Array with: self]
!

flattenOn: stream

    ^stream nextPut: self.

    "Created: / 21-07-2009 / 23:11:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

genericPatternForSelector: aSymbol
    ^ String streamContents: [ :stream |
        aSymbol keywords keysAndValuesDo: [ :index :value |
            stream space; nextPutAll: value.
            aSymbol last = $: ifTrue: [ 
                stream space; nextPutAll: '`@object'; print: index 
            ] 
        ] 
    ]
! !

!RBLintRule methodsFor:'redefinable utilities'!

resultSelectionIntervalsForSource:sourceString tree:aTree in: aClass do:aBlock
    "evaluate aBlock for all text-intervals (use by the highlighter to underwave
     affected code fragments)"
     
    |result|

    (result := self result) notNil ifTrue:[
        result selectionIntervalsForSource:sourceString tree:aTree rule:self in: aClass do:aBlock
    ].

    "Created: / 02-12-2014 / 11:14:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceIntervalForNode:aNode inTree:aParseTree source:fullSource
    "redefinable to only return a partial interval for source code highlighting
     (underwaving).
     This is useful to avoid highlighting complete blocks or huge pieces of code,
     if only the selector of the sending message is wrong..
     For example: RBNotEliminationRule"

    ^ aNode sourceInterval
! !

!RBLintRule methodsFor:'running'!

checkClass: aContext
!

checkMethod: aContext
!

checkMethodReturningReplacements: aContext
    ^ self checkMethod:aContext
!

resetResult
!

run
	^ SmalllintChecker runRule: self
!

runOnEnvironment: anEnvironment 
	^ SmalllintChecker runRule: self onEnvironment: anEnvironment
!

shouldIgnoreClass: class selector: selector
    "true if a method should not be checked by this rule.
     Here, it is checked if:
        - the method exists
        - it has an 'ignore:<name> rationale: author:>> - annotation,
          where <name> matches my name.
          eg, an annotation like:
          <ignore: RBMissingTranslationsRule rationale:'does not make sense here' author:'cg'>
    "
        
    | m |

    m := class compiledMethodAt: selector.
    m isNil ifTrue:[ ^ false ].
    m 
        annotationsAt: #ignore:rationale:author 
        do:[:ann|
            (ann rule = self name 
              or:[ann rule == self class name]
            ) ifTrue:[^true]
        ].
    ^false.

    "Created: / 24-08-2010 / 21:30:46 / Jan Vrany <enter your email here>"
    "Modified: / 03-03-2013 / 11:25:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldIgnoreMethod: aContext

    ^self shouldIgnoreClass: aContext selectedClass selector: aContext selector

    "Created: / 24-08-2010 / 20:48:14 / Jan Vrany <enter your email here>"
! !

!RBLintRule methodsFor:'testing'!

hasConflicts
	^ false
!

isBroken
   ^self class isBroken

    "Created: / 26-07-2012 / 13:48:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isComposite
	^ false
!

isEmpty
	self subclassResponsibility
!

isEmptyInTree
    "added due to the semantic confusion of isEmpty 
     (means both: has subitems AND has subitems with result !!)"

    ^ false

    "Created: / 01-03-2012 / 19:05:01 / cg"
!

isLintChecksGroupParent
    "still bad, but better than comparing in the browser..."

    ^ self name = 'Lint checks'

    "Created: / 07-03-2012 / 20:11:53 / cg"
!

isSqueakBugsGroupParent
    "still bad, but better than comparing in the browser..."

    ^ self name = 'Bugs - Squeak'

    "Created: / 07-03-2012 / 20:12:29 / cg"
!

isTaggedAs: tag
   ^self class isTaggedAs: tag

    "Created: / 26-07-2012 / 13:50:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTaggedByAll: tags
    "Return true, if the ruleis tagged by ALL of the given tags"

    ^self class isTaggedByAny: tags

    "Created: / 26-07-2012 / 13:51:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTaggedByAny: tags
    "Return true, if the ruleis tagged by ANY of the given tags"

    ^self class isTaggedByAny: tags

    "Created: / 26-07-2012 / 13:51:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTransformation
        ^ false
! !

!RBLintRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


RBLintRule initialize!
