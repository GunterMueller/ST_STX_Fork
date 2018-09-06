"
 COPYRIGHT (c) 2002 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#DoWhatIMeanSupport
	instanceVariableNames:'tree tokens languageOrNil classOrNil methodOrNil contextOrNil
		instanceOrNil codeView rememberedScopeNodes rememberedNodes
		codeAspect'
	classVariableNames:'LastSource LastParseTree LastScanTokens LastChoices
		LastCompletedSelectors Verbose'
	poolDictionaries:''
	category:'System-Support'
!

Array variableSubclass:#InputCompletionResult
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DoWhatIMeanSupport
!

!DoWhatIMeanSupport class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Attention: this is currently being rewritten and refactored.
    Don't get mad at the ugly (and duplicate) code.
    Will cleanup when finished.

    misc collected UI support (functional)
    These used to be in the Smalltalk and SystemBrowser class;
    however, they are only needed for programmers, and some of the stuff is useful in multiple
    places.
    Therefore it is:
	1) not needed for standalone executables
	2) published here to avoid multiple implementations

    [author:]
	Claus Gittinger (cg@exept.de)

"
! !

!DoWhatIMeanSupport class methodsFor:'code completion'!

codeCompletionFor: aspect language: languageOrNil method:methodOrNil orClass:classOrNil context:contextOrNil codeView:codeView into:actionBlock
    "aspect is so-called code-aspect symbol saying what's edited - #method, #expression, #classDefinition...
     contextOrNil is the current context, if this is called from the debugger;
     nil, if called from the browser.
     If nonNil, we can make better guesses, 
     because we actually know what a variable's type is."

    ^ self new
        codeCompletionFor: aspect
        language: languageOrNil
        method:methodOrNil orClass:classOrNil
        context:contextOrNil
        codeView:codeView into:actionBlock

    "Created: / 27-09-2013 / 10:19:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeCompletionForLanguage: languageOrNil class: classOrNil context:contextOrNil codeView:codeView
    "contextOrNil is the current context, if this is called from the debugger;
     nil, if called from the browser.
     If nonNil, we can make better guesses, 
     because we actually know what a variable's type is."

    ^ self new
        codeCompletionForLanguage: languageOrNil 
        class:classOrNil 
        context:contextOrNil 
        codeView:codeView

    "Created: / 18-09-2013 / 13:34:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DoWhatIMeanSupport class methodsFor:'code completion - obsolete'!

codeCompletionForClass:classOrNil context:contextOrNil codeView:codeView
    <resource: #obsolete>
    "contextOrNil is the current context, if this is called from the debugger;
     nil, if called from the browser.
     If nonNil, we can make better guesses, because we actually know what a variable's type is.
     This is not yet done, sigh"

    ^ self
	codeCompletionForLanguage: nil class:classOrNil context:contextOrNil codeView:codeView

    "Modified: / 18-09-2013 / 13:34:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeCompletionForMethod:methodOrNil orClass:classOrNil context:contextOrNil codeView:codeView into:actionBlock
    <resource: #obsolete>
    "contextOrNil is the current context, if this is called from the debugger;
     nil, if called from the browser.
     If nonNil, we can make better guesses, because we actually know what a variable's type is.
     This is not yet done, sigh"

    ^ self new
	codeCompletionForMethod:methodOrNil orClass:classOrNil
	context:contextOrNil
	codeView:codeView into:actionBlock
! !

!DoWhatIMeanSupport class methodsFor:'code completion-helpers'!

findNodeForInterval:interval in:source
    "utility"
    
    |tree node remember|

    interval isEmpty ifTrue: [^ nil].
    RBParser isNil ifTrue: [^ nil].

    source = LastSource ifTrue:[
        tree := LastParseTree.
    ] ifFalse:[
        remember := true.    
        LastSource := LastParseTree := nil.
        tree := RBParser
                parseMethod:source
                onError:
                    [:str :err ":nodesSoFar" |
                        "/ Transcript showCR:'Parse-Error: ',str.
                        nil
                    ].

        tree isNil ifTrue:[
            "/ try to parse as an expression
            tree := RBParser
                    parseExpression:source
                    onError:
                        [:str :err ":nodesSoFar" |
                            "Transcript showCR:'Parse-Error: ',str."
                            nil
                        ].

            tree isNil ifTrue:[
                "/ try to parse the selected text alone as expression
                remember := false.    
                tree := RBParser
                    parseExpression:(source copyFrom:interval start to:(interval stop min:source size))
                    onError:
                        [:str :err ":nodesSoFar" |
                            "Transcript showCR:'Parse-Error: ',str."
                            nil
                        ].         
                ^ tree
            ].
        ].
        remember ifTrue:[ 
            LastSource := source.
            LastParseTree := tree.
        ].
    ].

    Error handle:[:ex |
    ] do:[ 
        node := tree whichNodeIsContainedBy:interval.
    ].
    node isNil ifTrue: [
        node := tree bestNodeFor: interval.
        node isNil ifTrue: [
            node := self findNodeIn:tree forInterval:interval
        ].
    ].
    ^ node

    "Modified: / 06-07-2011 / 12:42:53 / cg"
!

findNodeForInterval:interval in:source allowErrors:allowErrors
    ^ self new findNodeForInterval:interval in:source allowErrors:allowErrors
!

findNodeForInterval:interval in:source allowErrors:allowErrors mustBeMethod:mustBeMethod
    "if mustBeMethod is true, do not try a regular expression (as in a workspace)."

    ^ self new
	findNodeForInterval:interval in:source allowErrors:allowErrors mustBeMethod:mustBeMethod
!

findNodeForInterval:interval inParseTree:parseTree
    ^ self new findNodeForInterval:interval inParseTree:parseTree
!

findNodeIn:aTree forInterval:anInterval
    "utility"
    
    |nodeFound wouldReturn|

    anInterval isEmpty ifTrue:[^nil].

    nodeFound := nil.
    aTree nodesDo:[:eachNode |
        (eachNode intersectsInterval:anInterval) ifTrue:[
            (nodeFound isNil or:[nodeFound == eachNode parent]) ifTrue:[
                nodeFound := eachNode
            ] ifFalse:[
                (nodeFound parent == eachNode parent
                and:[ eachNode start >= nodeFound start
                      and:[ eachNode stop <= nodeFound stop ] ]) ifTrue:[
                ] ifFalse:[
                    (nodeFound parent notNil
                    and:[nodeFound parent isCascade and:[eachNode parent isCascade]]) ifFalse:[^ nil]
                ]
            ]
        ] ifFalse:[
            nodeFound notNil ifTrue:[
                "/ already found one - beyond that one; leave
                wouldReturn notNil ifTrue:[wouldReturn := nodeFound].
            ]
        ].
    ].
"/ (wouldReturn notNil and:[wouldReturn ~~ node]) ifTrue:[self halt].
    ^ nodeFound

    "Modified: / 20-11-2006 / 12:31:12 / cg"
! !

!DoWhatIMeanSupport class methodsFor:'input completion support'!

classCategoryCompletion:aPartialCategory inEnvironment:anEnvironment
    "given a partial class category name, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching categories"

    |matches best lcName|

    matches := IdentitySet new.

    "/ search for exact match
    anEnvironment allClassesDo:[:aClass |
	|category|

	category := aClass category.
	(category notNil and:[category startsWith:aPartialCategory]) ifTrue:[
	    matches add:category
	]
    ].
    matches isEmpty ifTrue:[
	"/ search for case-ignoring match
	lcName := aPartialCategory asLowercase.
	anEnvironment allClassesDo:[:aClass |
	    |category|

	    category := aClass category.
	    (category notNil and:[category asLowercase startsWith:lcName]) ifTrue:[
		matches add:category
	    ].
	].
    ].

    matches isEmpty ifTrue:[
	^ Array with:aPartialCategory with:(Array with:aPartialCategory)
    ].
    matches size == 1 ifTrue:[
	^ Array with:matches first with:(matches asArray)
    ].
    matches := matches asSortedCollection.
    best := matches longestCommonPrefix.
    ^ Array with:best with:matches asArray

    "
     Smalltalk classCategoryCompletion:'Sys'
     Smalltalk classCategoryCompletion:'System'
     Smalltalk classCategoryCompletion:'System-BinaryStorage'
    "

    "Created: / 10-08-2006 / 13:06:45 / cg"
!

classNameEntryCompletionBlock
    "this block can be used in a dialog to perform className completion"

    ^ self entryCompletionBlockFor:#'classnameCompletion:inEnvironment:'

    "Modified: / 10-08-2006 / 13:22:02 / cg"
!

classnameCompletion:aPartialClassName filter:filterBlock inEnvironment:anEnvironment
    "given a partial classname, return an array consisting of
     2 entries: 1st: the best (longest) match
                2nd: collection consisting of matching names"

    |searchName matches matchedNamesWithoutPrefix ignCaseMatches best isMatchString cls nsPrefix
     others lcSearchName tryToMatch idx words w1 w2 rslt bestMatch matchesForLongestPrefix|

    (words := aPartialClassName asCollectionOfWords) size > 1 ifTrue:[
        w1 := words first.
        w2 := words second.
        rslt := self classnameCompletion:w1 filter:filterBlock inEnvironment:anEnvironment.
        bestMatch := rslt first.
        matches := rslt second.
        ('class' copyTo:(w2 size min:5)) = w2 ifTrue:[
            matches := matches collect:[:m | m , ' class'].
            bestMatch := bestMatch , ' class'.
        ].
        ^ InputCompletionResult bestName:bestMatch matchingNames:matches
    ].

    (aPartialClassName startsWith:'Smalltalk::') ifTrue:[
        nsPrefix := 'Smalltalk::'.
        searchName := aPartialClassName withoutPrefix:'Smalltalk::'
    ] ifFalse:[
        nsPrefix := ''.
        searchName := aPartialClassName.
    ].

    searchName := searchName asUppercaseFirst.
    lcSearchName := searchName asLowercase.

    isMatchString := searchName includesMatchCharacters.
    (searchName size > 2 
        and:[ searchName first = $* 
        and:[ searchName last = $* ]]
    ) ifTrue:[
        isMatchString := false.
        searchName := searchName unquote:$*.
    ].
    
    searchName isEmpty ifTrue:[
        matches := Smalltalk allClassesForWhich:filterBlock.
        ^ InputCompletionResult bestName:searchName matchingNames:#()
    ].

    matches := OrderedCollection new.
    matchedNamesWithoutPrefix := Set new.
    ignCaseMatches := OrderedCollection new.
    others := OrderedCollection new.

    tryToMatch :=
        [:className :fullClassName|
            |addIt|

            isMatchString ifTrue:[
                addIt := searchName match:className
            ] ifFalse:[
                addIt := className includesString:searchName.
            ].
            addIt ifTrue:[
                matches add:(nsPrefix , fullClassName).
                matchedNamesWithoutPrefix add:className.
            ] ifFalse:[
                "/ try ignoring case

                isMatchString ifTrue:[
                    addIt := searchName match:className caseSensitive:false
                ] ifFalse:[
                    addIt := className includesString:lcSearchName caseSensitive:false.
                    addIt ifFalse:[
                        others add:className
                    ]
                ].
                addIt ifTrue:[
                    ignCaseMatches add:(nsPrefix , fullClassName).
                    matchedNamesWithoutPrefix add:className.
                ].
            ].
            addIt
        ].

    anEnvironment allClassesForWhich:filterBlock do:[:aClass |
        |addIt fullClassName classNameWithoutPrefix|

        aClass isMeta ifFalse:[
            fullClassName := aClass name.
            classNameWithoutPrefix := aClass nameWithoutPrefix.

            addIt := tryToMatch value:fullClassName value:fullClassName.
            addIt ifFalse:[
                classNameWithoutPrefix ~~ fullClassName ifTrue:[
                    tryToMatch value:classNameWithoutPrefix value:fullClassName.
                ].
            ].
        ]
    ].

"/    matches isEmpty ifTrue:[
"/        matches := ignCaseMatches.
"/    ].
    matches := matches , ignCaseMatches.

"/    matches isEmpty ifTrue:[
"/        matches := ignCaseMatches.
"/
"/"/    matches isEmpty ifTrue:[
"/"/        | nearBy |
"/"/        nearBy := SortedCollection new sortBlock:[:a :b | a key < b key].
"/"/        others do:[:className |
"/"/            |lcClassName dist cmpName|
"/"/
"/"/            lcClassName := className asLowercase.
"/"/            dist := lcClassName levenshteinTo:lcSearchName s:9 k:1 c:0 i:9 d:2.
"/"/
"/"/            cmpName := lcClassName copyTo:(lcSearchName size min:lcClassName size).
"/"/            dist := dist min:(cmpName levenshteinTo:lcSearchName s:9 k:1 c:0 i:9 d:2).
"/"/            cmpName := lcClassName copyTo:(lcSearchName size + 1 min:lcClassName size).
"/"/            dist := dist min:(cmpName levenshteinTo:lcSearchName s:9 k:1 c:0 i:9 d:2).
"/"/            dist < 4 ifTrue:[
"/"/                nearBy add:( dist -> (nsPrefix , className) ).
"/"/            ]
"/"/        ].
"/"/        matches := nearBy collect:[:eachPair | eachPair value].
"/"/    ].
"/    ].

    matches isEmpty ifTrue:[
        ^ InputCompletionResult bestName:searchName matchingNames:(Array with:searchName)
    ].

    matches size == 1 ifTrue:[
        best := matches first.
        ^ InputCompletionResult bestName:best matchingNames:(matches asArray)
    ].

    matches
        sort:[:name1 :name2 |
            "name1 comes before:name2 iff"
            ((name2 includes:$:) and:[(name1 includes:$:) not])
            or:[ ((name1 includes:$:) == (name2 includes:$:))
                  and:[ (name1 size < name2 size)
                        or: [ name1 < name2 ]]
               ]
        ].

    isMatchString ifTrue:[
        best := searchName.
    ] ifFalse:[
        matchesForLongestPrefix := matches select:[:m | m asLowercase startsWith:lcSearchName].
        best := ignCaseMatches isEmpty
                    ifTrue:[ matchesForLongestPrefix longestCommonPrefix ]
                    ifFalse:[ matchesForLongestPrefix longestCommonPrefixCaseSensitive:false ].

        best size < aPartialClassName size "best size == 0" ifTrue:[
            best := matchedNamesWithoutPrefix longestCommonPrefix.
        ].
        best size == 0 ifTrue:[
            "if tried again, return next match"
            idx := ((matches indexOf:aPartialClassName) + 1) \\ matches size.
            idx ~~ 1 ifTrue:[
                ^ InputCompletionResult bestName:(matches at:idx) matchingNames:(matches asArray)
            ].
        ].
        best size < aPartialClassName size ifTrue:[
            best := aPartialClassName.
        ].
    ].

    cls := anEnvironment classNamed:best.
    (cls isBehavior and:[cls isNameSpace]) ifTrue:[
        (matches conform:[:each | each = best
                                 or:[each startsWith:(best , '::')]])
        ifTrue:[
            best := best , '::'
        ].
    ].
    ^ InputCompletionResult bestName:best matchingNames:matches asArray

    "
     Smalltalk classnameCompletion:'Arr'
     Smalltalk classnameCompletion:'Arra'
     Smalltalk classnameCompletion:'arra'
     Smalltalk classnameCompletion:'*rray'
    "

    "Created: / 10-08-2006 / 13:01:08 / cg"
!

classnameCompletion:aPartialClassName inEnvironment:anEnvironment
    "given a partial classname, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching names"

    ^ self
	classnameCompletion:aPartialClassName
	filter:[:cls | true]
	inEnvironment:anEnvironment

    "
     self classnameCompletion:'Arr'   inEnvironment:Smalltalk
     self classnameCompletion:'Arra'  inEnvironment:Smalltalk
     self classnameCompletion:'arra'  inEnvironment:Smalltalk
     self classnameCompletion:'*rray' inEnvironment:Smalltalk
    "

    "Created: / 24-11-1995 / 17:24:45 / cg"
    "Modified: / 10-08-2006 / 13:01:30 / cg"
!

entryCompletionBlockFor:completionSelector
    "this block can be used in a dialog to perform className completion"

    ^ [:contents :field  |
	  |s what m|

	  s := contents withoutSpaces.
	  field topView withCursor:(Cursor questionMark) do:[
	      what := self perform:completionSelector with:s with:Smalltalk.
	  ].

	  field contents:(what first).
	  (what at:2) size ~~ 1 ifTrue:[
	      UserPreferences current beepInEditor ifTrue:[
		field device beep
	      ]
	  ]
      ].

    "Created: / 10-08-2006 / 13:21:37 / cg"
!

globalNameCompletion:aPartialGlobalName inEnvironment:anEnvironment
    "given a partial globalName, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching names"

    ^ self globalNameCompletion:aPartialGlobalName inEnvironment:anEnvironment match:true

    "
     Smalltalk globalnameCompletion:'Arr'
     Smalltalk globalnameCompletion:'Arra'
     Smalltalk globalnameCompletion:'arra'
     Smalltalk globalnameCompletion:'*rray'
    "

    "Created: / 10-08-2006 / 13:06:23 / cg"
!

globalNameCompletion:aPartialGlobalName inEnvironment:anEnvironment match:doMatch
    "given a partial globalName, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching names"

    |searchName matches ignCaseMatches best isMatchString|

    searchName := aPartialGlobalName.
    searchName isEmpty ifTrue:[
	^ Array with:searchName with:#()
    ].

    (searchName at:1) isLowercase ifTrue:[
	searchName := searchName copy asUppercaseFirst
    ].

    isMatchString := doMatch and:[ searchName includesMatchCharacters ].
    matches := OrderedCollection new.
    ignCaseMatches := OrderedCollection new.
    anEnvironment keysDo:[:aGlobalName |
	| addIt|

	isMatchString ifTrue:[
	    addIt := searchName match:aGlobalName
	] ifFalse:[
	    addIt := aGlobalName startsWith:searchName
	].
	addIt ifTrue:[
	    matches add:aGlobalName
	] ifFalse:[
	    "/ try ignoring case
	    isMatchString ifTrue:[
		addIt := searchName match:aGlobalName caseSensitive:false
	    ] ifFalse:[
		addIt := aGlobalName asLowercase startsWith:searchName asLowercase
	    ].
	    addIt ifTrue:[
		ignCaseMatches add:aGlobalName
	    ]
	]
    ].

    matches isEmpty ifTrue:[
	matches := ignCaseMatches
    ].

    matches isEmpty ifTrue:[
	^ Array with:searchName with:(Array with:searchName)
    ].
    matches size == 1 ifTrue:[
	^ Array with:matches first with:(matches asArray)
    ].
    matches := matches asSortedCollection.
    isMatchString ifTrue:[
	best := searchName.
    ] ifFalse:[
	best := matches longestCommonPrefix.
    ].
    ^ Array with:best with:matches asArray

    "
     Smalltalk globalnameCompletion:'Arr'
     Smalltalk globalnameCompletion:'Arra'
     Smalltalk globalnameCompletion:'arra'
     Smalltalk globalnameCompletion:'*rray'
    "

    "Created: / 10-08-2006 / 13:06:23 / cg"
!

methodProtocolCompletion:aPartialProtocolName inEnvironment:anEnvironment
    "given a partial method protocol name, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching protocols"

    |matches best lcName|

    matches := IdentitySet new.

    "/ search for exact match
    anEnvironment allMethodsWithSelectorDo:[:eachMethod :eachSelector |
	|protocol|

	protocol := eachMethod category.
	(protocol notNil and:[protocol startsWith:aPartialProtocolName]) ifTrue:[
	    matches add:protocol
	].
    ].
    matches isEmpty ifTrue:[
	"/ search for case-ignoring match
	lcName := aPartialProtocolName asLowercase.
	anEnvironment allMethodsWithSelectorDo:[:eachMethod :eachSelector |
	    |protocol|

	    protocol := eachMethod category.
	    (protocol notNil and:[protocol asLowercase startsWith:lcName]) ifTrue:[
		matches add:protocol
	    ].
	].
    ].

    matches isEmpty ifTrue:[
	^ Array with:aPartialProtocolName with:(Array with:aPartialProtocolName)
    ].
    matches size == 1 ifTrue:[
	^ Array with:matches first with:(matches asArray)
    ].
    matches := matches asSortedCollection.
    best := matches longestCommonPrefix.
    ^ Array with:best with:matches asArray

    "
     Smalltalk methodProtocolCompletion:'doc'
     Smalltalk methodProtocolCompletion:'docu'
     Smalltalk methodProtocolCompletion:'documenta'
    "

    "Created: / 10-08-2006 / 13:05:27 / cg"
    "Modified: / 16-03-2011 / 12:30:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpaceCompletion:aPartialClassName inEnvironment:anEnvironment
    "given a partial name, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching names"

    ^ self
	classnameCompletion:aPartialClassName
	filter:[:cls | cls isNameSpace]
	inEnvironment:anEnvironment

    "
     DoWhatIMeanSupport nameSpaceCompletion:'To'  inEnvironment:Smalltalk
    "

    "Created: / 10-08-2006 / 13:02:16 / cg"
!

packageCompletion:aPartialPackage inEnvironment:anEnvironment
    "given a partial package name, return an array consisting of
     2 entries: 1st: the best (longest) match
                2nd: collection consisting of matching packages"

    |matches best lcName|

    matches := Smalltalk allPackageIDs
        select:[:package | package startsWith:aPartialPackage].

    matches isEmpty ifTrue:[
        "/ search for case-ignoring match
        lcName := aPartialPackage asLowercase.
        anEnvironment allClassesDo:[:aClass |
            |package|

            package := aClass package.
            (package notNil and:[package asLowercase startsWith:lcName]) ifTrue:[
                matches add:package
            ].
        ].
    ].

    matches isEmpty ifTrue:[
        ^ Array with:aPartialPackage with:(Array with:aPartialPackage)
    ].
    matches size == 1 ifTrue:[
        ^ Array with:matches first with:(matches asArray)
    ].
    matches := matches asSortedCollection.
    best := matches longestCommonPrefix.
    ^ Array with:best with:matches asArray

    "
     DoWhatIMeanSupport packageCompletion:'stx:' inEnvironment:Smalltalk
     DoWhatIMeanSupport packageCompletion:'stx:libw' inEnvironment:Smalltalk
    "

    "Created: / 10-08-2006 / 13:05:07 / cg"
!

packageNameEntryCompletionBlock
    "this block can be used in a dialog to perform className completion"

    ^ self entryCompletionBlockFor:#'packageCompletion:inEnvironment:'

    "Created: / 10-08-2006 / 13:22:31 / cg"
!

poolnameCompletion:aPartialClassName inEnvironment:anEnvironment
    "given a partial poolname, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching names"

    ^ self
	classnameCompletion:aPartialClassName
	filter:[:cls | cls isSharedPool]
	inEnvironment:anEnvironment

    "
     self poolnameCompletion:'Win' inEnvironment:Smalltalk
     self poolnameCompletion:'Z'   inEnvironment:Smalltalk
     self poolnameCompletion:'a'   inEnvironment:Smalltalk
    "
!

resourceCompletion:aPartialResourceName inEnvironment:anEnvironment match:doMatch ignoreCase:ignoreCase
    "given a partial resource name, return an array consisting of
     2 entries: 1st: the longest match
		2nd: collection consisting of matching defined resources"

    |matches best lcSym isMatch|

    matches := IdentitySet new.

    isMatch := doMatch and:[aPartialResourceName includesMatchCharacters].

    anEnvironment allMethodsWithSelectorDo:[:eachMethod :eachSelector |
	eachMethod hasResource ifTrue:[
	    eachMethod resources keysDo:[:eachResourceName |
		(isMatch
		    ifTrue:[ (aPartialResourceName match:eachResourceName caseSensitive:ignoreCase not) ]
		    ifFalse:[ ignoreCase
				ifTrue:[ (eachResourceName asLowercase startsWith:aPartialResourceName asLowercase) ]
				ifFalse:[ (eachResourceName startsWith:aPartialResourceName) ] ]
		) ifTrue:[
		    matches add:eachResourceName
		].
	    ].
	].
    ].
    (matches isEmpty and:[ignoreCase not]) ifTrue:[
	"/ search for case-ignoring match
	lcSym := aPartialResourceName asLowercase.
	anEnvironment allMethodsWithSelectorDo:[:eachMethod :eachSelector |
	    eachMethod hasResource ifTrue:[
		eachMethod resources keysDo:[:eachResourceName |
		    (isMatch
			ifTrue:[ (aPartialResourceName match:eachResourceName caseSensitive:false) ]
			ifFalse:[ (eachResourceName asLowercase startsWith:lcSym) ])
		     ifTrue:[
			matches add:eachResourceName
		    ].
		].
	    ].
	].
    ].

    matches isEmpty ifTrue:[
	^ Array with:aPartialResourceName with:#()
    ].
    matches size == 1 ifTrue:[
	^ Array with:matches first with:(matches asArray)
    ].
    matches := matches asSortedCollection.
    best := matches longestCommonPrefix.
    ^ Array with:best with:matches asArray

    "
     DoWhatIMeanSupport resourceCompletion:'*debug*' inEnvironment:Smalltalk match:true ignoreCase:false
     DoWhatIMeanSupport resourceCompletion:'context' inEnvironment:Smalltalk match:true ignoreCase:false
     DoWhatIMeanSupport resourceCompletion:'key' inEnvironment:Smalltalk match:true ignoreCase:false
     DoWhatIMeanSupport resourceCompletion:'cont' inEnvironment:Smalltalk match:true ignoreCase:false
    "

    "Created: / 06-07-2011 / 12:04:41 / cg"
!

selectorCompletion:aPartialSymbolName inEnvironment:anEnvironment
    "given a partial selector, return an array consisting of
     2 entries: 1st: the longest match
		2nd: collection consisting of matching implemented selectors"

    ^ self selectorCompletion:aPartialSymbolName inEnvironment:anEnvironment match:false
!

selectorCompletion:aPartialSymbolName inEnvironment:anEnvironment match:doMatch
    "given a partial selector, return an array consisting of
     2 entries: 1st: the longest match
		2nd: collection consisting of matching implemented selectors"

    ^ self
	selectorCompletion:aPartialSymbolName
	inEnvironment:anEnvironment
	match:doMatch
	ignoreCase:false

    "
     DoWhatIMeanSupport selectorCompletion:'inst*p' inEnvironment:Smalltalk match:true
     DoWhatIMeanSupport selectorCompletion:'inst*pl' inEnvironment:Smalltalk match:true
     DoWhatIMeanSupport selectorCompletion:'at:p' inEnvironment:Smalltalk match:true
     DoWhatIMeanSupport selectorCompletion:'nextP' inEnvironment:Smalltalk match:true
     DoWhatIMeanSupport selectorCompletion:'nextp' inEnvironment:Smalltalk match:true
    "

    "Modified: / 07-06-1996 / 08:44:33 / stefan"
    "Modified: / 26-10-2010 / 20:30:27 / cg"
!

selectorCompletion:aPartialSymbolName inEnvironment:anEnvironment match:doMatch ignoreCase:ignoreCase
    "given a partial selector, return an array consisting of
     2 entries: 1st: the longest match
		2nd: collection consisting of matching implemented selectors"

    |matches best lcSym isMatch|

    matches := IdentitySet new.

    isMatch := doMatch and:[aPartialSymbolName includesMatchCharacters].

    anEnvironment allMethodsWithSelectorDo:[:eachMethod :eachSelector |
	(isMatch
	    ifTrue:[ (aPartialSymbolName match:eachSelector caseSensitive:ignoreCase not) ]
	    ifFalse:[ ignoreCase
			ifTrue:[ (eachSelector asLowercase startsWith:aPartialSymbolName asLowercase) ]
			ifFalse:[ (eachSelector startsWith:aPartialSymbolName) ] ])
	 ifTrue:[
	    matches add:eachSelector
	].
    ].
    (matches isEmpty and:[ignoreCase not]) ifTrue:[
	"/ search for case-ignoring match
	lcSym := aPartialSymbolName asLowercase.
	anEnvironment allMethodsWithSelectorDo:[:eachMethod :eachSelector |
	    (isMatch
		ifTrue:[ (aPartialSymbolName match:eachSelector caseSensitive:false) ]
		ifFalse:[ (eachSelector asLowercase startsWith:lcSym) ])
	     ifTrue:[
		matches add:eachSelector
	    ].
	].
    ].

    matches isEmpty ifTrue:[
	^ Array with:aPartialSymbolName with:#() "/ (Array with:aPartialSymbolName)
    ].
    matches size == 1 ifTrue:[
	^ Array with:matches first with:(matches asArray)
    ].
    matches := matches asSortedCollection.
    best := matches longestCommonPrefix.
    ^ Array with:best with:matches asArray

    "
     DoWhatIMeanSupport selectorCompletion:'inst*p' inEnvironment:Smalltalk match:true
     DoWhatIMeanSupport selectorCompletion:'inst*pl' inEnvironment:Smalltalk match:true
     DoWhatIMeanSupport selectorCompletion:'at:p' inEnvironment:Smalltalk match:true
     DoWhatIMeanSupport selectorCompletion:'nextP' inEnvironment:Smalltalk match:true
     DoWhatIMeanSupport selectorCompletion:'nextp' inEnvironment:Smalltalk match:true
    "

    "Modified: / 07-06-1996 / 08:44:33 / stefan"
    "Created: / 26-10-2010 / 20:30:06 / cg"
! !

!DoWhatIMeanSupport class methodsFor:'rename support'!

goodRenameDefaultFor:oldName lastOld:lastOldName lastNew:lastNewName
    "generate a reasonable default for a rename operation.
     (used for rename category etc.)"

    |prefix suffix lastNewSize lastOldSize left right inserted deleted tryAgain|

    lastNewName isNil ifTrue:[ ^ nil].

    lastNewSize := lastNewName size.
    lastOldSize := lastOldName size.

    (lastNewName endsWith:lastOldName) ifTrue:[
        "last rename was
            'foo' -> 'Xfoo'
         then, a good default for
            'bar' would be 'Xbar'
        "
        prefix := lastNewName copyTo:(lastNewSize - lastOldSize).
        ^ (prefix , oldName).
    ].
    (lastOldName endsWith:lastNewName) ifTrue:[
        "last rename was
            'Xfoo' -> 'foo'
         then, a good default for
            'Xbar' would be 'bar'
        "
        prefix := lastOldName copyTo:(lastOldSize - lastNewSize).
        (oldName startsWith:prefix) ifTrue:[
            ^ (oldName copyFrom:prefix size+1).
        ]
    ].
    (lastOldName asLowercase = lastNewName asLowercase) ifTrue:[
        (lastOldName first ~= lastNewName first) ifTrue:[
            (lastOldName first isLowercase = oldName first isLowercase) ifTrue:[
                "last rename was
                    'xfoo' -> 'Xfoo'
                 then, a good default for
                    'xbar' would be 'Xbar'
                "
                lastOldName first isLowercase ifTrue:[
                    ^ oldName asUppercaseFirst "oldName first asUppercase asString , (oldName copyFrom:2)".
                ] ifFalse:[
                    ^ oldName asLowercaseFirst "oldName first asLowercase asString , (oldName copyFrom:2)".
                ]
            ]
        ].
    ].
    (lastOldName withoutSeparators = lastNewName) ifTrue:[
        "last rename was
            '  foo   ' -> 'foo'
         then, a good default for
            '  bar   ' would be 'bar'
        "
        ^ oldName withoutSeparators.
    ].
    (lastNewName startsWith:lastOldName) ifTrue:[
        "last rename was
            'foo' -> 'fooX'
         then, a good default for
            'bar' would be 'barX'
        "
        suffix := lastNewName copyLast:(lastNewSize - lastOldSize).
        ^ (oldName , suffix).
    ].
    (lastOldName startsWith:lastNewName) ifTrue:[
        "last rename was
            'fooX' -> 'foo'
         then, a good default for
            'barX' would be 'bar'
        "
        suffix := lastOldName copyLast:(lastOldSize - lastNewSize).
        (oldName endsWith:suffix) ifTrue:[
            ^ (oldName copyButLast:suffix size).
        ]
    ].

    prefix := lastOldName commonPrefixWith:lastNewName.
    suffix := lastOldName commonSuffixWith:lastNewName.

    (prefix size > 0) ifTrue:[
        (suffix size > 0) ifTrue:[

            prefix := prefix copyTo:(((lastNewName size - suffix size) min:(lastOldName size - suffix size)) min:prefix size).

            "last rename was
                'fooR' -> 'fooXR'
             then, a good default for
                'barR' would be 'barXR'
            "
            left := lastOldName copyTo:prefix size.
            right := lastOldName copyLast:suffix size.
            lastNewSize > lastOldSize ifTrue:[
                inserted := (lastNewName copyFrom:(left size + 1)) copyButLast:(right size).
                inserted size > 0 ifTrue:[
                    (oldName startsWith:prefix) ifTrue:[
                        ^ oldName copyWithAll:inserted insertedAfterIndex:prefix size
                    ].
                ].
            ].
            (oldName string endsWith:suffix string) ifTrue:[
                deleted := (lastOldName string copyFrom:(prefix size + 1)) copyButLast:(suffix size).
                (oldName size-suffix size-deleted size + 1) >= 1 ifTrue:[
                    ((oldName copyFrom:oldName size-suffix size-deleted size + 1) copyTo:deleted size) = deleted ifTrue:[
                        "last rename was
                            'fooXR' -> 'fooR'
                         then, a good default for
                            'barXS' would be 'barS'
                        "
                        ^ (oldName copyTo:oldName size-suffix size-deleted size) , suffix
                    ]
                ]
            ]
        ].

        (oldName endsWith:(lastOldName copyFrom:prefix size+1)) ifTrue:[
            "last rename was
                'fooX' -> 'fooY'
             then, a good default for
                'barX' would be 'barY'
            "
            left := oldName copyButLast:(lastOldName copyFrom:prefix size+1) size.
            right := lastNewName copyFrom:prefix size+1.
            ^ left , right
        ]
    ].

    suffix size > 0 ifTrue:[
        |prefix2|

        "last rename was:
            'fooSUFF1' -> 'barSUFF1'
         then, a good default for
            'fooSUFF2' -> 'barSUFF2'
        "
        prefix := lastOldName copyTo:(lastOldName size - suffix size).  "/ the foo
        (oldName startsWith:prefix) ifTrue:[
            prefix2 := lastNewName copyTo:(lastNewName size - suffix size). "/ the bar
            ^ prefix2,(oldName copyFrom:(prefix size+1)).
        ].
    ].

    "/ was there something stripped at the end?
    suffix := oldName commonSuffixWith:lastOldName.
    (suffix size > 0) ifTrue:[
        ^ self
            goodRenameDefaultFor:(oldName copyButLast:suffix size)
            lastOld:(lastOldName copyButLast:suffix size)
            lastNew:lastNewName.
    ].
    ^ nil

    "
     self goodRenameDefaultFor:'bar' lastOld:'foo' lastNew:'fooXX'
     self goodRenameDefaultFor:'bar' lastOld:'foo' lastNew:'XXfoo'

     self goodRenameDefaultFor:'barXX' lastOld:'fooXX' lastNew:'foo'
     self goodRenameDefaultFor:'XXbar' lastOld:'XXfoo' lastNew:'foo'

     self goodRenameDefaultFor:'barXX' lastOld:'fooXX' lastNew:'fooYY'
     self goodRenameDefaultFor:'XXbar' lastOld:'XXfoo' lastNew:'foo'

     self goodRenameDefaultFor:'bar2' lastOld:'foo1' lastNew:'foo01'
     self goodRenameDefaultFor:'barXY' lastOld:'fooXY' lastNew:'fooY'
     self goodRenameDefaultFor:'bar' lastOld:'foo' lastNew:'fXoo'
     self goodRenameDefaultFor:'bar' lastOld:'foo' lastNew:'fXXXoo'
     self goodRenameDefaultFor:'bar' lastOld:'foo' lastNew:'foXXXo'

     self goodRenameDefaultFor:'bar001' lastOld:'foo001' lastNew:'foo002_001'
     self goodRenameDefaultFor:'CoastCore-CSFoo' lastOld:'CoastCore-CSBar' lastNew:'Coast-Core-CSBar'

     self goodRenameDefaultFor:'mti.odt2.level1HeadlineStyle'
                       lastOld:'mti.odt2.level1HeadlineMatchPattern'
                       lastNew:'Key_odt2_level1HeadlineMatchPattern'
    "

    "Modified: / 24-07-2011 / 11:06:03 / cg"
!

goodRenameDefaultForFile:oldName lastOld:lastOldName lastNew:lastNewName
    "generate a reasonable default for a file rename operation.
     (Try to rename multiple files in the new fileBrowser,
     to see what this is doing)"

    |prefix suffix t
     lastOldWOSuffix lastNewWOSuffix oldWOSuffix lastOldRest oldRest lastNewRest
     lastRemoved lastInserted default|

    default := self goodRenameDefaultFor:oldName lastOld:lastOldName lastNew:lastNewName.
    default notNil ifTrue:[ ^ default].

    lastOldWOSuffix := lastOldName asFilename nameWithoutSuffix.
    lastNewWOSuffix := lastNewName asFilename nameWithoutSuffix.
    oldWOSuffix := oldName asFilename nameWithoutSuffix.

    "/ suffix change ?
    lastOldWOSuffix = lastNewWOSuffix ifTrue:[
	lastOldName asFilename suffix ~= lastNewName asFilename suffix ifTrue:[
	    ^ (oldName asFilename withSuffix:(lastNewName asFilename suffix)) pathName
	].
    ].

    default := self goodRenameDefaultFor:oldWOSuffix lastOld:lastOldWOSuffix lastNew:lastNewWOSuffix.
    default notNil ifTrue:[
	lastOldRest := lastOldName copyFrom:lastOldWOSuffix size + 1.
	lastNewRest := lastNewName copyFrom:lastNewWOSuffix size + 1.
	oldRest := oldName copyFrom:oldWOSuffix size + 1.

	^ default , lastNewRest
    ].

    prefix := lastOldWOSuffix commonPrefixWith:oldWOSuffix.
    (lastNewWOSuffix startsWith:prefix) ifTrue:[
	lastOldRest := lastOldWOSuffix copyFrom:prefix size + 1.
	lastNewRest := lastNewWOSuffix copyFrom:prefix size + 1.
	oldRest := oldWOSuffix copyFrom:prefix size + 1.

	(lastNewRest endsWith:lastOldRest) ifTrue:[
	    t := lastNewRest copyButLast:lastOldRest size.
	    ^ ((prefix , t , oldRest) asFilename withSuffix:oldName asFilename suffix) name
	].
    ].

    suffix := lastOldWOSuffix commonSuffixWith:lastNewWOSuffix.
    suffix size > 0 ifTrue:[
	"/ last change changed something at the beginning
	prefix := oldWOSuffix commonPrefixWith:lastOldWOSuffix.
	prefix size > 0 ifTrue:[
	    "/ this name starts with the same characters
	    lastRemoved := lastOldWOSuffix copyButLast:suffix size.
	    lastInserted := lastNewWOSuffix copyButLast:suffix size.
	    (lastRemoved startsWith:lastInserted) ifTrue:[
		oldWOSuffix size >= lastInserted size ifTrue:[
		    ^ (oldWOSuffix copyTo:lastInserted size) , (oldName copyFrom:lastRemoved size + 1)
		]
	    ].
	    ^ lastInserted , (oldName copyFrom:lastRemoved size + 1)
	].
    ].

    ^ nil

    "Modified: / 07-11-2006 / 13:58:39 / cg"
! !

!DoWhatIMeanSupport class methodsFor:'typing distance'!

isKey:k1 nextTo:k2
    "return true, if k1 and k2 are adjacent keys on the keyboard.
     This is used to specially priorize plausible typing errors of adjacent keys.
     CAVEAT: hard coded us-, german and french keyboards here; data should come from somewhere else."

    ^ self isKey:k1 nextTo:k2 onKeyboard:(self keyboard)

    "
     self isKey:$a nextTo:$a
     self isKey:$a nextTo:$s
     self isKey:$a nextTo:$q
     self isKey:$a nextTo:$w
     self isKey:$a nextTo:$z
     self isKey:$a nextTo:$x
    "

    "Modified: / 16-01-2008 / 17:17:31 / cg"
!

isKey:k1 nextTo:k2 onKeyboard:keys
    "return true, if k1 and k2 are adjacent keys on the keyboard defined by keys.
     This is used to specially priorize plausible typing errors of adjacent keys.
     (typo checker uses a modified levenshtein, 
      in which keys next to each other are valued differently)"

    |row1 row2 col1 col2|

    row1 := keys findFirst:[:eachRow | col1 := eachRow indexOf:k1. col1 ~~ 0].
    row1 == 0 ifTrue:[^ false].
    row2 := keys findFirst:[:eachRow | col2 := eachRow indexOf:k2. col2 ~~ 0].
    row2 == 0 ifTrue:[^ false].

    ^ (row1-row2) abs <= 1 and:[(col1-col2) abs <= 1]

    "
     self isKey:$a nextTo:$q
     self isKey:$a nextTo:$x
    "

    "Modified (comment): / 01-05-2016 / 12:19:24 / cg"
!

keyboard
    "the keyboard layout
     (useful to figure out which keys are nearby a key, to find possible typing errors)
     CAVEAT: hard coded us-, german and french keyboards here; data should come from somewhere else."

    |lang|

    lang := UserPreferences current language.
    lang == #de ifTrue:[
	^ #(
	       '1234567890-'
	       '*qwertzuiop'
	       '**asdfghjkl:'
	       '***yxcvbnm'
	).
    ].

    lang == #fr ifTrue:[
	^ #(
	       '1234567890'
	       '*azertyuiop'
	       '**qsdfghjklm'
	       '***wxcvbn,'
	).
    ].

    ^ #(
	   '1234567890-'
	   '*qwertyuiop'
	   '**asdfghjkl:'
	   '***zxcvbnm'
    ).

    "
     self keyboard
    "

    "Created: / 16-01-2008 / 17:17:13 / cg"
! !

!DoWhatIMeanSupport methodsFor:'code completion'!

codeCompletionFor: codeAspectArg language: languageOrNilArg method:methodOrNilArg orClass:classOrNilArg context:contextOrNilArg codeView:codeViewArg into:actionBlock
    "provide code completion information by analyzing what the editing state is in codeViewArg
     (cursor position, characters around cursor etc.) and calling back into actionBlock, passing
     the info as argument. 
     The interface has been defined in that way 
     (and tight coupling with internals of the editor) because
        1) the completer needs to know about the text around the cursor position
        2) the edit operation for completion may be non-trivial
           (although not yet fully implemented, non-local rewrite procedures may and will be added in the future
     For example, in many situations, both a completion of a unary selector before the cursor,
     or adding another keyword part after the cursor is possible.
     Thus, this provides a list of completions PLUS a list of edit operations (as per completion), to
     perform the completion.
     The caller has to open a dialog, providing the suggestions, and perform the corresponding edit operation.
     An additional array containing a textual description for each suggestion is also provided, which could
     be shown as info or appended to the suggestions (such as 'complete variable', 'complete keyword', etc.

     ContextOrNil is the current context, if this is called from the debugger;
     or nil, if called from the browser.
     If nonNil, we can make better guesses, because we actually know what a variable's type is"

    | language |

    codeAspect := codeAspectArg.

    languageOrNilArg notNil ifTrue:[
        language := languageOrNilArg
    ] ifFalse:[
        contextOrNilArg notNil ifTrue:[
            | method |

            method := contextOrNilArg method.
            method notNil ifTrue:[
                language := method programmingLanguage
            ] ifFalse:[
                contextOrNilArg isJavaContext ifTrue:[
                    language := (Smalltalk at:#JavaLanguage) instance
                ] ifFalse:[
                    language := SmalltalkLanguage instance.
                ].
            ].
        ] ifFalse:[
            methodOrNilArg notNil ifTrue:[
                language := methodOrNilArg programmingLanguage
            ] ifFalse:[
                classOrNilArg notNil ifTrue:[
                    language := classOrNilArg programmingLanguage
                ]
            ]
        ].
    ].

    language notNil ifTrue:[
        language isSmalltalk ifTrue:[
            ^self codeCompletionForSmalltalkMethod: methodOrNilArg orClass: classOrNilArg context: contextOrNilArg codeView: codeViewArg into: actionBlock
        ].
        language isSTXJavaScript ifTrue:[
            ^self codeCompletionForJavascriptMethod: methodOrNilArg orClass: classOrNilArg context: contextOrNilArg codeView: codeViewArg into: actionBlock
        ].
    ].

    "/ No completion support for given language
    "/ self breakPoint: #cg.

    "Created: / 27-09-2013 / 10:21:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2015 / 07:36:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeCompletionForLanguage: languageOrNil class: classOrNilArg context:contextOrNilArg codeView:codeViewArg
    "going to become OBSOLETE; migrating to use the the new 'xxx: into:' protocol.
     contextOrNil is the current context, if this is called from the debugger;
     nil, if called from the browser.
     If nonNil, we can make better guesses, 
     because we actually know what a variable's type is."

    | language |

    languageOrNil notNil ifTrue:[
        language := languageOrNil
    ] ifFalse:[
        contextOrNilArg notNil ifTrue:[
            language := contextOrNilArg method programmingLanguage.
        ] ifFalse:[
            classOrNilArg notNil ifTrue:[
                language := classOrNilArg programmingLanguage.
            ]
        ].
    ].

    language notNil ifTrue:[
        language isSmalltalk ifTrue:[
            classOrNil := classOrNilArg.
            contextOrNil := contextOrNilArg.
            ^self codeCompletionForSmalltalkClass: classOrNil context: contextOrNil codeView: codeViewArg
        ].
    ].

    "/ No completion support for given language
    self breakPoint: #cg.
    self breakPoint: #jv.

    "Created: / 18-09-2013 / 13:49:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setClass: classOrNilArg andContext:contextOrNilArg
    classOrNil := classOrNilArg.
    contextOrNil := contextOrNilArg.
!

setSelf: instanceOrNilArg 
    instanceOrNil := instanceOrNilArg.
! !

!DoWhatIMeanSupport methodsFor:'code completion - JavaScript'!

codeCompletionForJavascriptMethod:methodOrNilArg orClass:classOrNilArg context:contextOrNilArg codeView:codeViewArg into:actionBlock
    "provide code completion information by analyzing what the editing state is in codeViewArg
     (cursor position, characters around cursor etc.) and calling back into actionBlock, passing
     the info as argument. 
     The interface has been defined in that way 
     (and tight coupling with internals of the editor) because
        1) the completer needs to know about the text around the cursor position
        2) the edit operation for completion may be non-trivial
           (although not yet fully implemented, non-local rewrite procedures may and will be added in the future
     For example, in many situations, both a completion of a unary selector before the cursor,
     or adding another keyword part after the cursor is possible.
     Thus, this provides a list of completions PLUS a list of edit operations (as per completion), to
     perform the completion.
     The caller has to open a dialog, providing the suggestions, and perform the corresponding edit operation.
     An additional array containing a textual description for each suggestion is also provided, which could
     be shown as info or appended to the suggestions (such as 'complete variable', 'complete keyword', etc.

     ContextOrNil is the current context, if this is called from the debugger;
     or nil, if called from the browser.
     If nonNil, we can make better guesses, because we actually know what a variable's type is"

    languageOrNil := (Smalltalk at:#STXJavaScriptLanguage) instance.
    methodOrNil := methodOrNilArg.
    classOrNil := classOrNilArg.
    codeView := codeViewArg.
    contextOrNil := contextOrNilArg.

    (Smalltalk at:#STXJavaScriptLanguage) notNil ifTrue:[
        (Smalltalk at:#STXJavaScriptLanguage) new
           completeForMethod: methodOrNil class: classOrNil context: contextOrNil codeView: codeView into: actionBlock.
    ].

    self information:'Not yet supported'.

    "Created: / 18-09-2013 / 16:24:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2015 / 07:37:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DoWhatIMeanSupport methodsFor:'code completion - Smalltalk'!

codeCompletionForSmalltalkClass: classOrNilArg context:contextOrNilArg codeView:codeViewArg

    "OBSOLETE; migrating to use the the new 'xxx: into:' protocol.
     contextOrNil is the current context, if this is called from the debugger;
     nil, if called from the browser.
     If nonNil, we can make better guesses, because we actually know what a variable's type is.
     This is not yet done, sigh"

    |crsrPos char interval source node parent checkedNode instanceOrNilArg
     forceNewMessageSend classOfReceiver prevChar|

    languageOrNil := SmalltalkLanguage instance.
    classOrNil := classOrNilArg.
    codeView := codeViewArg.

    crsrPos := codeView characterPositionOfCursor"-1".
    char := codeView characterAtCharacterPosition:crsrPos.
    "/ Transcript show:crsrPos; show:' '; showCR:char.
    [crsrPos > 1 and:[char isSeparator or:['.' includes:char]]] whileTrue:[
        crsrPos := crsrPos - 1.
        char := codeView characterAtCharacterPosition:crsrPos.
    ].

    interval := codeView selectedInterval.
    "/ Transcript show:'iv: '; showCR:interval.
    interval isEmpty ifTrue:[
        interval := crsrPos"-1" to:crsrPos.
        "/ Transcript show:'iv2: '; showCR:interval.
    ].

    source := codeView contentsAsString string.
    source := source copyTo:crsrPos.

    "/ this is too naive and stupid; if there is a syntactic error,
    "/ we will not find a node for a long time (stepping back more and more,
    "/ until reaching the beginning). This leads to a thousand and more times reparsing
    "/ without any progress.
    "/ TODO: do it vice-versa, in that the parser does a callOut for every node generated
    "/ as it parses the code. Stop, when the interval is hit.
    "/ that will also work for syntactic incorrect source code.
    classOrNil notNil ifTrue:[
        node := self findNodeForInterval:interval in:source allowErrors:true mustBeMethod:true.
        "/ Transcript show:'nd1: '; showCR:node.
    ].
    node isNil ifTrue:[
        node := self findNodeForInterval:interval in:source allowErrors:true mustBeMethod:false.
        "/ Transcript show:'nd2 try: '; showCR:node.
        node isNil ifTrue:[
            "/ Transcript showCR:'No parseNode found (syntax error before or in comment?)'.
            self breakPoint:#cg.
            "/ self information:'No parseNode found (syntax error before or in comment?)'.
            ^ self.
        ]
    ].

    forceNewMessageSend := false.

    "/ if there a separator between the variable's name and the cursor position...
    prevChar := codeView characterBeforeCursor.
    (prevChar isSeparator or:[ ')}]''' includes:prevChar ]) ifTrue:[
        (node isVariable
            and:[ (parent := node parent) notNil
            and:[ parent isMessage ]]
        ) ifTrue:[
            "/ completion after a variable node...
            parent isKeyword ifTrue:[
                "/ and it is a keyword message, we complete the keyword message instead
                node := parent.
            ] ifFalse:[
                "/ otherwise, a unary message is probably intended to be sent to the variable.
                "/ (however, no character is available to determine what is useful)
                forceNewMessageSend := true.
            ].
        ] ifFalse:[
            (node isMessage and:[node isUnary]) ifTrue:[
                "/ expanding <rcvr> foo |<- cursor here (i.e. a space after foo)
                "/
                forceNewMessageSend := true.
"/                "/ can we see what we get from foo?
"/                classOfReceiver := self
"/                                    classOfReceiver:node receiver
"/                                    inClass:classOrNil instance:instanceOrNil context:contextOrNil.
"/                classOfReceiver notNil ifTrue:[
"/                    |mthd|
"/
"/                    mthd := classOfReceiver lookupMethodFor:node selector.
"/                    mthd notNil ifTrue:[
"/                        self halt.
"/                        (ParseTreeSearcher isDefinitelyGetterMethod:mthd) ifTrue:[
"/                            forceNewMessageSend := true.
"/                        ]
"/                    ]
"/                ].
            ]
        ]
    ].

    forceNewMessageSend ifTrue:[
        "/ completion with nothing to start (right after a variable)
        "/ see what the variable can understand and present the most useful stuff (very thin ice here)
        classOfReceiver := self classOfNode:node.
        classOfReceiver isNil ifTrue:[
            "/ it does not make sense to offer anything, if we don't have any idea of what this
            "/ will be...
            Screen current beep.
        ] ifFalse:[
            |superClass possible choice|

            possible := classOfReceiver selectors.
            superClass := classOfReceiver superclass.
            [superClass notNil "and:[(possible size + superClass selectors size) < 500]"] whileTrue:[
                possible := possible,superClass selectors.
                superClass := superClass superclass.
            ].
            possible := possible copy sort.
            choice := self askUserForCompletion:('Message to "%1"' bindWith:node formattedCode) for:codeView from:possible.
            choice isNil ifTrue:[
                Screen current beep.
                ^ self
            ].

            codeView
                undoableDo:[
                    codeView insertStringAtCursor:choice
                ]
                info:'Completion'.
        ].
        ^ self
    ].

    node isVariable ifTrue:[
        self codeCompletionForVariable:node inClass:classOrNil codeView:codeView.
        ^ self.
    ].
    node isLiteral ifTrue:[
        node value isSymbol ifTrue:[
            self codeCompletionForLiteralSymbol:node inClass:classOrNil codeView:codeView.
            ^ self.
        ].
        ^ self "/ huh - strings or what?
    ].

    checkedNode := node.
    [checkedNode notNil] whileTrue:[
        checkedNode isMessage ifTrue:[
            "/ completion in a message-send
            contextOrNilArg notNil ifTrue:[
"/                |rcvrNode idx rcvr val|
"/
"/                (rcvrNode := checkedNode receiver) isVariable ifTrue:[
"/                    rcvrNode isSelf ifTrue:[
"/                        classOrNil := contextOrNil receiver class.
"/                    ] ifFalse:[
"/                        (idx := contextOrNil argAndVarNames indexOf:rcvrNode name) ~~ 0 ifTrue:[
"/                            val := contextOrNil argsAndVars at:idx.
"/                            classOrNil := val class.
"/                        ] ifFalse:[
"/                            (idx := contextOrNil receiver class allInstVarNames indexOf:rcvrNode name) ~~ 0 ifTrue:[
"/                                val := contextOrNil receiver instVarNamed:rcvrNode name.
"/                                classOrNil := val class.
"/                            ]
"/                        ]
"/                    ]
"/                ].
                instanceOrNilArg := contextOrNilArg receiver
            ].
            self
                codeCompletionForMessage:checkedNode
                inClass:classOrNil instance:instanceOrNilArg
                context:contextOrNilArg codeView:codeView.
            ^ self
        ].
        checkedNode isMethod ifTrue:[
            "/ completion in a method's selector pattern
            self codeCompletionForMethodSpec:checkedNode.
            ^ self.
        ].
        checkedNode := checkedNode parent.
    ].

    self information:'Node is neither variable nor message.'.

    "Created: / 18-09-2013 / 15:25:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeCompletionForSmalltalkMethod:methodOrNilArg orClass:classOrNilArg context:contextOrNilArg codeView:codeViewArg into:actionBlock
    "provide code completion information by analyzing what the editing state is in codeViewArg
     (cursor position, characters around cursor etc.) and calling back into actionBlock, passing
     the info as argument. 
     The interface has been defined in that way 
     (and tight coupling with internals of the editor) because
        1) the completer needs to know about the text around the cursor position
        2) the edit operation for completion may be non-trivial
           (although not yet fully implemented, non-local rewrite procedures may and will be added in the future
     For example, in many situations, both a completion of a unary selector before the cursor,
     or adding another keyword part after the cursor is possible.
     Thus, this provides a list of completions PLUS a list of edit operations (as per completion), 
     to perform the completion.
     The caller has to open a dialog, providing the suggestions, and perform the corresponding edit operation.
     An additional array containing a textual description for each suggestion is also provided, which could
     be shown as info or appended to the suggestions (such as 'complete variable', 'complete keyword', etc.

     ContextOrNil is the current context, if this is called from the debugger;
     or nil, if called from the browser.
     If nonNil, we can make better guesses, because we actually know what a variable's type is"

    |crsrPos char interval i source partialSource cursorLineSource
     suggestions actions title suggestionCollector|

    languageOrNil := SmalltalkLanguage instance.
    methodOrNil := methodOrNilArg.
    classOrNil := classOrNilArg.
    codeView := codeViewArg.
    contextOrNil := contextOrNilArg.

"/    classOrNil isNil ifTrue:[
"/        self information:'No class'.
"/        ^ self.
"/    ].

    crsrPos := codeView characterPositionOfCursor.
    char := codeView characterAtCharacterPosition:(crsrPos-1 max:1).
    [crsrPos > 1 and:[char isSeparator "or:['.' includes:char]"]] whileTrue:[
        crsrPos := crsrPos - 1.
        char := codeView characterAtCharacterPosition:crsrPos.
    ].
    char == $. ifTrue:[
        "/ either at end of statement or after a character constant
        crsrPos == 1 ifTrue:[^ self].
        (codeView characterAtCharacterPosition:crsrPos-1) == $$ ifFalse:[^ self].
    ].

    suggestionCollector :=
        [:listOfSuggestions :listOfActionsOrBlock :titleWhenAsking |
            "/ may be called multiple times!!
            suggestions isNil ifTrue:[
                suggestions := listOfSuggestions.
                actions := listOfActionsOrBlock.
                title := titleWhenAsking.
            ] ifFalse:[    
                suggestions := suggestions asOrderedCollection.
                actions isBlock ifTrue:[
                    actions := Array new:suggestions size withAll:actions.
                ].
                actions := actions asOrderedCollection.
                
                suggestions addAll:listOfSuggestions.
                listOfActionsOrBlock isBlock ifTrue:[
                    actions addAll:(Array new:listOfSuggestions size withAll:listOfActionsOrBlock).
                ] ifFalse:[
                    actions addAll:listOfActionsOrBlock.
                ].    
                title := titleWhenAsking.
            ].
        ].
        
    interval := crsrPos-1 to:crsrPos.

    source := codeView contentsAsString string.
    partialSource := source copyTo:crsrPos.

    methodOrNilArg isNil ifTrue:[
        (partialSource endsWith:Character cr) ifTrue:[
            partialSource := partialSource copyButLast.
        ].    
        "/ first try parsing the current cursor line.
        "/ this helps doIts in a workspace, where additional garbage is often before the actual expression to be evaluated
        (i := partialSource lastIndexOf:Character cr) ~~ 0 ifTrue:[
            "/ because cursorPositions and node-positions are required elsewhere to be correct,
            "/ I cannot just snip off the line and parse that one alone (later corrections will do so at wrong position).
            "/ Instead, create a copy of the whole source, with the stuff before the cursor line being blanked out.
            "/ However, because somewhere else, we fetch characters from the codeView using the index,
            "/ we must preserve the line structure (i.e. keep crs).
            cursorLineSource := partialSource copy.
            1 to:i do:[:pos | 
                (cursorLineSource at:pos) ~= Character cr ifTrue:[
                    cursorLineSource at:pos put:Character space.
                ]
            ].    
            self
                tryCodeCompletionWithSource:cursorLineSource nodeInterval:interval
                at:crsrPos mustBeExpression:true
                into:suggestionCollector.
        ].
    ].
    
"/    suggestions isEmptyOrNil ifTrue:[
"/        "/ try parsing the partial source (from beginning up to the cursor)
"/        self
"/            tryCodeCompletionWithSource:partialSource nodeInterval:interval
"/            at:crsrPos mustBeExpression:(classOrNilArg isNil and:[methodOrNilArg isNil])
"/            into:suggestionCollector.
"/    ].

    suggestions isEmptyOrNil ifTrue:[
        "/ try parsing the whole source
        self
            tryCodeCompletionWithSource:source nodeInterval:interval
            at:crsrPos mustBeExpression:false
            into:suggestionCollector
    ].
    
    suggestions isNil ifTrue:[
        "/ try parsing the partial source (from beginning up to the cursor)
        self
            tryCodeCompletionWithSource:partialSource nodeInterval:interval
            at:crsrPos mustBeExpression:(classOrNilArg isNil and:[methodOrNilArg isNil])
            into:suggestionCollector.
    ].
    
    suggestions isEmptyOrNil ifTrue:[
        "/ nothing found
        ^ self
    ].    
    actionBlock value:suggestions value:actions value:title.

    "Created: / 18-09-2013 / 15:25:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DoWhatIMeanSupport methodsFor:'code completion - obsolete'!

codeCompletionForClass:classOrNilArg context:contextOrNil codeView:codeViewArg
    <resource: #obsolete>
    "OBSOLETE; migrating to use the the new 'xxx: into:' protocol.
     contextOrNil is the current context, if this is called from the debugger;
     nil, if called from the browser.
     If nonNil, we can make better guesses, because we actually know what a variable's type is.
     This is not yet done, sigh"

    ^self codeCompletionForLanguage: nil class:classOrNilArg context:contextOrNil codeView:codeViewArg

    "Modified: / 04-07-2006 / 18:48:26 / fm"
    "Modified: / 28-08-2013 / 17:15:25 / cg"
    "Modified: / 18-09-2013 / 14:15:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeCompletionForMethod:methodOrNilArg orClass:classOrNilArg context:contextOrNilArg codeView:codeViewArg into:actionBlock
    <resource: #obsolete>
    ^ self
	codeCompletionForSmalltalkMethod:methodOrNilArg orClass:classOrNilArg context:contextOrNilArg codeView:codeViewArg into:actionBlock
! !

!DoWhatIMeanSupport methodsFor:'code completion-helpers'!

askUserForCompletion:what for:codeView at:position from:allTheBest
    |list choice lastChoice|

    "/ cg: until the new stuff works,...
    ^ self old_askUserForCompletion:what for:codeView from:allTheBest.

"/    allTheBest isEmpty ifTrue:[
"/        ^ nil
"/    ].
"/    allTheBest size == 1 ifTrue:[
"/        ^ allTheBest first
"/    ].
"/    list := allTheBest.
"/    LastChoices notNil ifTrue:[
"/        lastChoice := LastChoices at:what ifAbsent:nil.
"/        lastChoice notNil ifTrue:[
"/            list := { lastChoice allBold } , (list copyWithout:lastChoice).
"/        ].
"/    ].
"/    choice := Tools::CodeCompletionMenu
"/                openFor:codeView
"/                at:position
"/                with:allTheBest.
"/    LastChoices isNil ifTrue:[
"/        LastChoices := Dictionary new.
"/    ].
"/    LastChoices at:what put:choice.
"/    ^ choice string

    "Created: / 16-02-2010 / 10:09:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-08-2013 / 16:41:35 / cg"
!

askUserForCompletion:what for:codeView from:allTheBest
    |list resources choice lastChoice|

    allTheBest isEmpty ifTrue:[ ^ nil ].
    allTheBest size == 1 ifTrue:[ ^ allTheBest first ].

    list := allTheBest.
    LastChoices notNil ifTrue:[
	lastChoice := LastChoices at:what ifAbsent:nil.
	lastChoice notNil ifTrue:[
	    list := {lastChoice. nil. } , (list copyWithout:lastChoice).
	].
    ].

    list size < 30 ifTrue:[
	|menu idx exitKey|

	menu := PopUpMenu labels:list.
	menu hideOnKeyFilter:[:key | |hide|
		hide := ( #( CursorDown CursorUp Escape Return ) includes: key) not.
		hide ifTrue:[
		    exitKey := key.
		].
		hide].

	idx := menu startUp.
	idx == 0 ifTrue:[
	    exitKey notNil ifTrue:[
		codeView keyPress:exitKey x:0 y:0.
	    ].
	    ^ nil
	].
	choice := list at:idx.
    ] ifFalse:[
	resources := codeView application isNil
			ifTrue:[ codeView resources]
			ifFalse:[ codeView application resources ].

	choice := Dialog
	   choose:(resources string:'Choose ',what)
	   fromList:list
	   lines:20
	   title:(resources string:'Code completion').
	choice isNil ifTrue:[^ nil].
    ].

    LastChoices isNil ifTrue:[
	LastChoices := Dictionary new.
    ].
    LastChoices at:what put:choice.
    ^ choice

    "Created: / 10-11-2006 / 14:00:53 / cg"
!

codeCompletionForBlockArgument:node into:actionBlock
!

codeCompletionForLiteralSymbol:nodeOrNil element:tokenOrNil considerAll:considerAll into:actionBlock
    "looking for all symbols is way too much and inprecise;
     experiment: only present symbols which are used by the class,
     and classes in that class category, or at least: implemented as method.
     We'll see..."

    |sym possibleCompletions longest editAction start stop addSymbol
     parentSelector parent symbolSelectorClass|

    "/ Transcript show:'lit in '; show:methodOrNil; show:' / '; showCR:classOrNil.

    start := (nodeOrNil ? tokenOrNil) start.
    stop := (nodeOrNil ? tokenOrNil) stop.
    (codeView characterAtCharacterPosition:stop) == $' ifTrue:[
        ^ self.
    ].

    sym := (nodeOrNil ? tokenOrNil) value.
    possibleCompletions := Set new.

    addSymbol :=
        [:aSymbol |
            (aSymbol startsWith:sym) ifTrue:[
                (aSymbol = sym) ifFalse:[
                    possibleCompletions add:aSymbol
                ].
            ].
        ].

    (nodeOrNil notNil
    and:[ (parent := nodeOrNil parent) notNil
    and:[ parent isMessage ]]) ifTrue:[
        parentSelector := parent selector.
        ( #( perform: perform:ifNotUnderstood: ) includes: parentSelector) ifTrue:[
            symbolSelectorClass := self classOfNode:parent receiver.
        ].
        ( #( #'onChangeSend:' ) includes: parentSelector) ifTrue:[
            "/ assume that send-target will be self.
            (methodOrNil notNil and:[ methodOrNil selector notNil and:[ methodOrNil selector isUnarySelector ]]) ifTrue:[
                addSymbol value:(methodOrNil selector,'Changed').
            ].
            symbolSelectorClass := classOrNil.
        ].
        ( #( #'onChangeSend:to:' ) includes: parentSelector) ifTrue:[
            symbolSelectorClass := self classOfNode:parent arguments second.
        ].
        
        "/ actually, I found that this gives good suggestions.
        symbolSelectorClass isNil ifTrue:[
            symbolSelectorClass := classOrNil.
        ].
        
        symbolSelectorClass notNil ifTrue:[
            symbolSelectorClass withAllSuperclassesDo:[:cls |
                cls ~~ Object ifTrue:[
                    cls ~~ Model ifTrue:[
                        cls methodDictionary keysDo:addSymbol.
                    ]
                ]
            ]
        ].
    ].

    (considerAll or:[classOrNil isNil]) ifTrue:[
        Smalltalk allClassesDo:[:cls |
            cls theNonMetaclass methodDictionary keys do:addSymbol.
            cls theMetaclass methodDictionary keys do:addSymbol.
        ].

        "/ Symbol allInstancesDo:addSymbol.
    ] ifFalse:[
        Smalltalk allClassesInCategory:classOrNil do:[:cls |
            cls theNonMetaclass instAndClassMethodsDo:[:mthd |
                mthd usedSymbols do:addSymbol
            ]
        ].
    ].

    "/ add symbolic literals (especially for spec methods)
    classOrNil notNil ifTrue:[
        classOrNil theMetaclass instAndClassMethodsDo:[:mthd |
            mthd literalsDo:[:lit |
                lit isSymbol ifTrue:[ addSymbol value: lit ]
            ].    
        ].    
    ].
    
    possibleCompletions := possibleCompletions asOrderedCollection sort.

    longest := possibleCompletions longestCommonPrefix.
    possibleCompletions remove:longest ifAbsent:[].
    possibleCompletions addFirst: longest.

    editAction :=
        [:chosenIndex |
            |chosen oldSym oldLen newLen|

            chosen := possibleCompletions at:chosenIndex.
            chosen notNil ifTrue:[
                (codeView characterAtCharacterPosition:start) == $# ifTrue:[
                    start := start + 1.
                ].
                (codeView characterAtCharacterPosition:start) == $' ifTrue:[
                    start := start + 1.
                ].

                oldSym := (codeView textFromCharacterPosition:start to:stop) asString string withoutSeparators.

                codeView
                    undoableDo:[
                        codeView replaceFromCharacterPosition:start to:stop with:chosen
                    ]
                    info:'Completion'.

                (chosen startsWith:oldSym) ifTrue:[
                    oldLen := stop - start + 1.
                    newLen := chosen size.
                    codeView selectFromCharacterPosition:start+oldLen to:start+newLen-1.
                    codeView dontReplaceSelectionOnInput
                ].
            ]
        ].

    actionBlock value:possibleCompletions value:editAction value:'symbol'.

    "Modified: / 16-02-2010 / 10:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-07-2011 / 15:58:45 / cg"
!

codeCompletionForMessage:node into:actionBlock
    "find good completions for a message selector in a message-send node"
    
    |selector lcSelector bestSelectors parentSelector newParentSelector bestSelectors2 bestWithParenthesis allBest numArgs
     newParts nSelParts oldLen newLen selectorParts
     parentNode nodeReceiver "selectorsSentInCode" selectorsImplementedInClass
     editAction parentNodeClassIfKnown
     receiverNodeClassIfKnown 
     offerParenthisationAroundNode parenthesisAroundIndex parentNodeToParenthesize
     offerValueInsertion valueToInsert valueToInsertIndex valueInfo
     classesFromAssignmentsToReceiver otherMessagesToReceiver
     canParenthesize classesOfReceiver|
 
    Verbose == true ifTrue:[
        Transcript show:'node '; show:node; show:' ; '.
        Transcript show:'msg in '; show:methodOrNil; show:' / '; showCR:classOrNil.
    ].
    
    offerParenthisationAroundNode := nil.
    offerValueInsertion := false.
 
    selector := node selector.
    lcSelector := selector asLowercase.
    parentNode := node parent.
    nodeReceiver := node receiver.
    nodeReceiver notNil ifTrue:[
        classesOfReceiver := self classesOfNode:nodeReceiver.
    ].
    Verbose == true ifTrue:[
        Transcript show:node; show:' -> '; showCR:classesOfReceiver.
        ( node isVariable and:[node name = 'self']) ifTrue:[self halt].
    ].
    
    "/ if there is already space before the cursor, and the parent node is not a message,
    "/ do not attempt to complete the current message.
    "/ If it is a message, we will look for parent-message completion also below (best2 stuff)
    (codeView characterBeforeCursor ? Character space) isSeparator ifTrue:[
        selector isKeyword ifFalse:[
            self codeCompletionForMessageTo:node into:actionBlock.
            ^ self
        ].
    ].
 
    "/ only do this if the node-message has no parents around
    node parentheses isEmptyOrNil ifTrue:[
        Verbose == true ifTrue:[
            Transcript show:'try for: '; showCR:nodeReceiver
        ].    
        bestSelectors := self findBest:nodeReceiver for:selector 
                              inClasses:classesOfReceiver
    ] ifFalse:[
        bestSelectors := OrderedCollection new.
    ].
 
    "/ if the receiver is a real variable,
    "/ we can look for other messages being sent to that variable in the current method.
    "/ Also, if there are assignments to it (like constants or '<class> new'), use that as a hint...
    (tree notNil
        and:[ nodeReceiver isVariable
        and:[ nodeReceiver isSelf not
        and:[ nodeReceiver isSuper not ]]])
    ifTrue:[
        |receiverName possibleClasses possibleClassesFromOtherSends|
 
        receiverName := nodeReceiver name.
 
        classesFromAssignmentsToReceiver := self classesFromAssignmentTo:receiverName in:tree.

        possibleClasses := classesFromAssignmentsToReceiver.
        possibleClasses isEmpty ifTrue:[
            "/ messages sent
            otherMessagesToReceiver := self messagesSentTo:receiverName in:tree.
            otherMessagesToReceiver remove:selector ifAbsent:[].

            otherMessagesToReceiver notEmpty ifTrue:[
                "/ classes which respond to all
                possibleClassesFromOtherSends :=
                    Smalltalk 
                        allClassesForWhich:[:cls |
                            cls isLoaded
                            and:[ otherMessagesToReceiver
                                    conform:[:eachSelectorSent | cls canUnderstand:eachSelectorSent]]
                        ].
                possibleClasses := possibleClasses , possibleClassesFromOtherSends.
            ].
        ].
 
        "/ if the receiver is a classVar/classInstVar,
        "/ include the class of its current value and UndefinedObject.
        "/ This helps to complete class methods and (lazy) initializer code.
        (classOrNil notNil) ifTrue:[
            |tryValue currentValue|
 
            tryValue := false.
            (classOrNil theNonMetaclass allClassVarNames includes: receiverName) ifTrue:[
                tryValue := true.
                currentValue := classOrNil theNonMetaclass classVarAt:receiverName.
            ] ifFalse:[
                (classOrNil isMeta and:[ classOrNil allInstVarNames includes: receiverName ]) ifTrue:[
                    tryValue := true.
                    currentValue := classOrNil theNonMetaclass instVarNamed:receiverName.
                ].
            ].
            tryValue ifTrue:[
                possibleClasses := { currentValue class } , possibleClasses.
            ].
        ].
 
        (possibleClasses notEmpty and:[possibleClasses size < 15]) ifTrue:[
            bestSelectors :=
                (possibleClasses 
                    collectAll:[:eachClass |
                        Parser findBest:30 selectorsFor:selector in:eachClass forCompletion:true.
                    ] as:Set) asOrderedCollection.
 
            "/ if any of those is a prefix-keyword of the selector,
            "/ do not offer it (i.e. ifTrue:ifFalse: is already present, don't offer ifTrue:ifFalse: again.
            bestSelectors := bestSelectors reject: [:sel | (selector startsWith: sel) or: [selector endsWith: sel]].
        ].
    ].                                                                            
 
    "/ if we are behind a keyword messages colon,
    "/ only look for matching prefix selectors;
    "/ also, a good completion is to insert an argument;
    "/ the name of the variable from the implementation, as comment, and selected might be a good one!!
    "/ Array new:1
    selector isKeyword ifTrue:[
        (node arguments size = selector argumentCount) ifTrue:[
            offerParenthisationAroundNode := node. 
            "/ Transcript show:'2:'; showCR:node.
        ].
 
        codeView characterBeforeCursor == $: ifTrue:[
            (bestSelectors select:[:sel | sel asLowercase startsWith:lcSelector]) isEmpty ifTrue:[
                "/ nothing better around
                |argIndex argNames argNameStrings impls|
 
                argIndex := node selectorParts size.
                argNames := Set new.
                argNameStrings := OrderedCollection new.
                impls := Smalltalk allImplementorsOf:selector.
                impls size < 10 ifTrue:[
                    impls do:[:eachImplClass |
                        |mthd argName|
 
                        mthd := (eachImplClass compiledMethodAt:selector).
                        argName := (mthd methodArgNames ? #()) at:argIndex ifAbsent:nil.
                        argName notNil ifTrue:[
                            (argNames includes:argName) ifFalse:[
                                argNames add:argName.
                                argNameStrings add:(argName allItalic,' hint only: argName in (' ,mthd mclass name allBold,' ',mthd methodDefinitionTemplate).
                            ].    
                        ].
                    ].
                    argNameStrings notEmptyOrNil ifTrue: [
                        argNameStrings := argNameStrings asOrderedCollection sort.
                        actionBlock value:argNameStrings value:[:selIndex | ] value: 'argument name hint'.
                        ^ self.
                    ]
                ]
            ].
        ].
    ] ifFalse:[
        "/ when completing a non-keyword AND the parent is a keyword message,
        "/ only consider longer keyword messages or unary messages.
        "/ unless the node is parenthesized
        node hasParentheses ifFalse:[ 
            (parentNode notNil and:[ parentNode isKeywordMessage ]) ifTrue:[
                bestSelectors := bestSelectors select:[:sel | sel isUnarySelector or:[ sel startsWith:sel]]
            ]
        ]
    ].
 
"/    bestSelectors := bestSelectors asOrderedCollection.
"/    bestSelectors sort:[:a :b | a size < b size].
 
    (selector isUnarySelector and:[ parentNode notNil and:[ parentNode isMessage ]]) ifTrue:[
        (parentSelector := parentNode selector) isKeyword ifTrue:[
            "/ if its a unary message AND the parent is a keyword node, look for parent completion too.
            "/ i.e. look if there is a longer keyword possible
            newParentSelector := parentSelector,selector.
            bestSelectors2 := self 
                                findBest:(parentNode receiver) for:newParentSelector 
                                inClasses:(self classesOfNode:parentNode receiver).
            bestSelectors2 := bestSelectors2 select:[:sel | sel isKeyword and:[ sel startsWith:parentSelector]].
            bestSelectors2 := bestSelectors2 asOrderedCollection sort:[:a :b | a size < b size].
            bestSelectors := bestSelectors reject:[:sel | bestSelectors2 includes:sel].
 
            "/ if the parent has a valid selector, offer parenthization
            (Smalltalk someImplementorOf:parentSelector) notNil ifTrue:[
                offerParenthisationAroundNode := parentNode.
                "/ Transcript show:'2:'; showCR:parentNode.
            ].
        ] ifFalse:[
            |kwSels|
 
            "/ if its a unary message AND the parent is a unary or binary node, 
            "/ try again, sending the partial message
            "/ as a keyword to the parent node.
            "/ this is the case when after "foo binOp bar if", or "foo unOp bar if"
            "/ which should include ifTrue: in the suggestion result.
            
            "/ suggestion will transform from (the incorrectly parsed)
            "/    foo == (shift if)
            "/
            "/        nonKWsel-msg(parent)
            "/     /         \
            "/    /           \
            "/  rcvr         sel-unary(node)
            "/              /
            "/             /
            "/           arg
            "/
            "/ into:
            "/    (foo == shift) if
            "/
            "/        nonKWsel-msg(parent)
            "/     /         \
            "/    /           \
            "/  rcvr         sel-unary(node)
            "/              /
            "/             /
            "/           arg
 
            "/ but only do this, if typing to the end of the parent message
            "/ (i.e. after (foo == shift) <-
            "/    or after foo bar baz <-
            "/ not if typing into an existing message
            "/ (i.e. into foo == shift <- more
            "/    or into foo bar <- baz
            codeView characterPositionOfCursor >= parentNode stop ifTrue:[
                kwSels := self 
                                findBest:parentNode for:selector 
                                inClasses:(self classesOfNode:parentNode).
                kwSels := kwSels select:[:sel | sel isKeyword].
     
                kwSels := kwSels asOrderedCollection sort:[:a :b | a size < b size].
 
                bestSelectors := bestSelectors reject:[:sel | kwSels includes:sel].
 
                "/ these need to go to bestSelectors (see editAction)
                parentNodeClassIfKnown := self classOfNode:parentNode.
                (parentNodeClassIfKnown notNil and:[ parentNodeClassIfKnown includesBehavior: Boolean ]) ifTrue:[
                    "/ this is so common, that it deserves a special case:
                    "/ if we complete an if after some boolean message e.g '(a == b) if'
                    "/ throw out the very unlikely ifNil, ifEmpty etc. messages (which are inherited by Object, but absolutely unrealistic)
                    bestSelectors := self
                                        withoutSelectorsUnlikelyFor:parentNodeClassIfKnown
                                        from:bestSelectors
                                        forPartial:selector.
                    kwSels := self
                                withoutSelectorsUnlikelyFor:parentNodeClassIfKnown
                                from:kwSels
                                forPartial:selector.
     
                    "/ put keyword selectors in front, because they are very likely
                    bestSelectors := kwSels , bestSelectors.
                ] ifFalse:[
                    "/ put them at the end
                    bestSelectors := bestSelectors , kwSels.
                ].
            ]
        ]
    ].
 
    (selector isUnarySelector and:[ node isMessage ]) ifTrue:[
        receiverNodeClassIfKnown := self classOfNode:nodeReceiver.
        (receiverNodeClassIfKnown notNil and:[ receiverNodeClassIfKnown includesBehavior: Boolean ]) ifTrue:[
            "/ this is so common, that it deserves a special case:
            "/ if we complete an if after some boolean message e.g '(a == b) if'
            "/ throw out the very unlikely ifNil, ifEmpty etc. messages (which are inherited by Object, but absolutely unrealistic)
            bestSelectors := self
                                withoutSelectorsUnlikelyFor:receiverNodeClassIfKnown
                                from:bestSelectors
                                forPartial:selector.
        ].
    ].
    
    Verbose == true ifTrue:[    
        Transcript show:'parentNode: '; showCR:parentNode.
        Transcript show:'parentNode: '; showCR:parentNode class.
        Transcript show:'sel: '; showCR:selector.
    ].
    
    canParenthesize := false.
    parentNode notNil ifTrue:[
        parentNode isMessage ifTrue:[
            (((parentNode selector isUnarySelector not) and:[selector isUnarySelector])
            or:[ ((parentNode selector isKeyword) and:[selector isBinarySelector]) ]) ifTrue:[
                canParenthesize := true.
            ]
        ] ifFalse:[
            offerParenthisationAroundNode isNil ifTrue:[
                selector isKeyword ifTrue:[
                    offerParenthisationAroundNode := node.
                ].    
            ].    
        ].    
    ].    
    canParenthesize ifTrue:[
        "/ completing an already existing keyword or binary message with something starting with
        "/ if, and, or or while.
        "/ Here, offer a special completion which inserts parentheses / brackets around the already
        "/ existing message. Do this only, if the existing message makes sense.
        "/    expr wh
        "/ ->
        "/    [expr] whileXX:[]
        true "((
            #( 'ifTrue' 'ifFalse' 'and' 'or' 'do' 'keysAndValuesDo' 'whileTrue' 'whileFalse' 'ensure' 'on')
        ) contains:[:part | part startsWith:selector])" ifTrue:[
            (Smalltalk someImplementorOf:parentNode selector) notNil ifTrue:[
                |selsP selsB|
 
                selsP := #( 'ifTrue:' 'ifFalse:' 'and' 'or' 'do' 'keysAndValuesDo' )
                            select:[:sel | sel startsWith:selector]
                            thenCollect:[:sel | '(',parentNode selector,') ',sel].
                ( #( 'whileTrue:' 'whileFalse:' 'ensure:' 'on:do:' ) contains:[:sel | sel startsWith:selector]) 
                ifFalse:[
                    selsP := selsP copyWith:'(',parentNode selector,') ',selector  
                ]. 
                selsB := #( 'whileTrue:' 'whileFalse:' 'ensure:' 'on:do:' )
                            select:[:sel | sel startsWith:selector]
                            thenCollect:[:sel | '[',parentNode selector,'] ',sel].
                parentNodeToParenthesize := parentNode.
                bestWithParenthesis := selsP , selsB.
            ].
        ].
    ] ifFalse:[
        "/ also offer adding brackets for a while expression
        "/    expr wh
        "/ ->
        "/    [expr] whileXX:[]
        ((
            #( 'whileTrue' 'whileFalse' 'ensure' 'on')
        ) contains:[:part | part startsWith:selector]) ifTrue:[
            (node receiver isBlock) ifFalse:[
                |sels|
 
                (node receiver isMessage not
                or:[ (Smalltalk someImplementorOf:node receiver selector) notNil ]) ifTrue:[
                    sels := #( 'whileTrue:' 'whileFalse:' 'ensure:' 'on:do:' )
                                select:[:sel | sel startsWith:selector]
                                thenCollect:[:sel | '[...] ',sel].
                    parentNodeToParenthesize := node receiver.
                    bestWithParenthesis := sels.
                ].
            ].
        ].
    ].
 
    allBest := (bestSelectors ? #()) , (bestSelectors2 ? #()) asOrderedCollection.
    self sortSelectors:allBest forSelector:selector lcSelector:lcSelector.
                        
    "/ sort: prefixes first.
    parentSelector notNil ifTrue:[
        allBest := self 
                    splitSelectorList:allBest 
                    by:[:sel | 
                            (sel asLowercase startsWith:lcSelector) 
                            or:[sel startsWith:parentSelector]].
    ].
 
    "/ if receiver is super, always include the method's own selector
    nodeReceiver isSuper ifTrue:[
        (tree isMethod) ifTrue:[
            |mSel|
 
            mSel := tree selector.
            mSel notNil ifTrue:[
                (mSel startsWith:selector) ifTrue:[
                    "/ already the word before the cursor?
                    (mSel ~= selector) ifTrue:[
                        allBest removeAndAddFirst:mSel.
                    ]
                ]
            ]
        ]
    ].
 
    "/ another convenient hack; 
    "/ if we have just typed in foo == 
    "/ and the value of foo is a known literal,
    "/ offer inserting this literal. This is great in a debugger...
    ( #(#'==' #'=' #'~=' #'~~') includes:selector ) ifTrue:[
        |val|

        (val := self valueOfNode:nodeReceiver) notNil ifTrue:[
            "/ this can raise an error, if val does not like to generate a storeString
            "/ (it is recursive, or an X11GraphicsContext, for example)
            Error handle:[:ex |
            ] do:[
                valueToInsert := val storeString.
                offerValueInsertion := true.
                nodeReceiver isVariable ifTrue:[
                    valueInfo := ' (current value of %1)' bindWith:nodeReceiver name.
                ] ifFalse:[                
                    valueInfo := ' (current value of expression)'.
                ].
                valueInfo := valueInfo withColor:(Color grey).
            ].
        ].    
    ].    
    
    (allBest isEmptyOrNil 
        and:[bestWithParenthesis isEmptyOrNil
        and:[offerParenthisationAroundNode isNil
        and:[offerValueInsertion not]]] 
    ) ifTrue:[ 
        ^ self 
    ].
 
"/    "/ see what is aready sent to this variable inside the code
"/    "/ and also what is assigned to it.
"/    nodeReceiver notNil ifTrue:[
"/        nodeReceiver isVariable ifTrue:[
"/            rememberedNodes notNil ifTrue:[
"/                selectorsSentInCode := 
"/                    (rememberedNodes
"/                        select:[:node | 
"/                            node isMessage 
"/                                and:[node receiver isVariable
"/                                and:[node receiver name = nodeReceiver name]]]
"/                        thenCollect:[:node | 
"/                            node selector]
"/                    ) asSet.
"/            ] ifFalse:[
"/                selectorsSentInCode := Set new. 
"/                tree allMessageNodesDo:[:msg |
"/                    (msg receiver isVariable
"/                        and:[msg receiver name = nodeReceiver name]
"/                    ) ifTrue:[
"/                        selectorsSentInCode add:msg selector
"/                    ].
"/                ].
"/                selectorsSentInCode remove:selector ifAbsent:[].
"/            ]. 
"/        ]. 
"/    ]. 

    nodeReceiver notNil ifTrue:[
        |classOrNil|

        classOrNil := self classOfNode:nodeReceiver.
        classOrNil isNil ifTrue:[
            classesFromAssignmentsToReceiver size == 1 ifTrue:[
                classOrNil := classesFromAssignmentsToReceiver anElement
            ].
        ].
        classOrNil notNil ifTrue:[
            selectorsImplementedInClass := classOrNil selectors.
"/            selectorsImplementedInClass := Set new.
"/            classOrNil withAllSuperclassesDo:[:cls |
"/                cls theNonMetaclass ~~ Object ifTrue:[
"/                    selectorsImplementedInClass addAll:cls selectors.
"/                ]
"/            ]    
        ]
    ].    
    selectorsImplementedInClass notNil ifTrue:[
        "/ the one's implemented in the class itself are moved to the top of the list.
        allBest := self 
                    splitSelectorList:allBest 
                    by:[:sel | selectorsImplementedInClass includes:sel].
    ].
    otherMessagesToReceiver "selectorsSentInCode" notNil ifTrue:[
        "/ the one's already sent in the code are moved to the top of the list.
        "/ trouble is: parser bails out on error, so most of the time, we only see
        "/ selectors sent previously. sigh.
        allBest := self 
                    splitSelectorList:allBest 
                    by:[:sel | otherMessagesToReceiver "selectorsSentInCode" includes:sel].
    ].
 
"/ this makes it very slow
"/false ifTrue:[
"/    srchClass notNil ifTrue:[
"/        implClass := srchClass whichClassIncludesSelector:best.
"/    ] ifFalse:[
"/        implClass := Smalltalk allClasses select:[:cls | (cls includesSelector:best) or:[cls class includesSelector:best]].
"/        implClass size == 1 ifTrue:[
"/            implClass := implClass first.
"/        ] ifFalse:[
"/            implClass := nil
"/        ]
"/    ].
"/
"/    info := best storeString.
"/    implClass notNil ifTrue:[
"/        info := implClass name , '  ' , info.
"/    ].
"/    self information:info.
"/].
 
    "/ the one's which are a prefix are moved towards the top of the list
    allBest := self splitSelectorList:allBest 
                    by:[:sel | sel notNil and:[sel asLowercase startsWith:lcSelector]].
 
    "/ heuristic hack:
    "/ 'i' and 'w' generate lists in which ifXXX / whileXXX are not at the top of the list.
    "/ we know, that those are most often wanted!!
    selector size <= 2 ifTrue:[
        allBest := self 
                    splitSelectorList:allBest 
                    by:[:sel | 
                        #(ifTrue: ifFalse: isNil notNil whileTrue whileFalse) includes:sel
                    ].
    ]. 

    self sortUsefulSelectorsIn:allBest. "/cosmetics

    "/ parenthesizers always at the end.
    bestWithParenthesis notEmptyOrNil ifTrue:[ 
        allBest := allBest , bestWithParenthesis.
    ].
 
    "/ self at:1 put:#foo
    "/ Array new:10
    offerParenthisationAroundNode notNil ifTrue:[
        allBest := allBest copyWith:( '(',selector,')' ).
        parenthesisAroundIndex := allBest size.
    ].
    offerValueInsertion ifTrue:[
        allBest := allBest copyWith:( '... ',(valueToInsert contractTo:30),valueInfo). 
        valueToInsertIndex := allBest size.
    ].
 
    editAction :=
        [:index |
            |crsrPos chosen parenthesisToInsert action|
 
            action := nil.
            crsrPos := codeView characterPositionOfCursor.
            chosen := allBest at:index.
 
            chosen ~= selector ifTrue:[
                (bestWithParenthesis notNil and:[bestWithParenthesis includes:chosen]) ifTrue:[
                    "/ for input like: 
                    "/   chosen at: 10 if
                    "/ put parenthesis around, and add ifTrue/ifFalse
                    "/ i.e.:   (chosen at:10) ifTrue:[]
 
                    "/ for input like: 
                    "/   a > 10 wh
                    "/ put brackets around and add whileTrue/whileFalse
                    "/ i.e.:   [a > 10] whileTrue:[]
                    parenthesisToInsert := chosen first == $( ifTrue:'()' ifFalse:'[]'.
                    chosen := (chosen copyFrom:(chosen lastIndexOf:parenthesisToInsert second)+1) withoutSeparators.
                ] ifFalse:[
                    (offerParenthisationAroundNode notNil and:[index = parenthesisAroundIndex]) ifTrue:[
                        "/ for input like: 
                        "/      Array new:10
                        "/ put parenthesis around.
                        "/ i.e.:   (Array new:10)
                        action :=
                            [
                                codeView insertString:'(' atCharacterPosition:offerParenthisationAroundNode start.
                                codeView insertString:')' atCharacterPosition:offerParenthisationAroundNode stop+2.
                                codeView cursorToCharacterPosition:(offerParenthisationAroundNode stop+2); cursorRight.
                            ].
                    ] ifFalse:[
                        (offerValueInsertion and:[index = valueToInsertIndex]) ifTrue:[
                            "/ for input like: 
                            "/      foo == 
                            "/ insert a value
                            "/ i.e.:   foo == #someSymbol
                            action :=
                                [
                                    codeView characterBeforeCursor isSeparator ifFalse:[
                                        codeView insertStringAtCursor:' '.
                                    ].    
                                    codeView insertStringAtCursor:valueToInsert.
                                    "/ codeView cursorRight.
                                ].
                        ]
                    ].    
                ].
 
                action isNil ifTrue:[
                    numArgs := chosen numArgs.
                    (bestSelectors2 notEmptyOrNil and:[bestSelectors2 includes:chosen]) ifTrue:[
                        selectorParts := parentNode selectorParts , node selectorParts.
                    ] ifFalse:[
                        selectorParts := node selectorParts.
                    ].
                    nSelParts := selectorParts size.
 
                    newParts := chosen asCollectionOfSubstringsSeparatedBy:$:.
                    newParts := newParts select:[:part | part size > 0].
 
                    action :=
                        [
                            |positionOfFirstArg newCursorPosition stop checkForArgumentTemplates
                             newPart oldPartialToken start|
 
                            checkForArgumentTemplates := (selector isUnarySelector and:[chosen isKeywordSelector]).
                            numArgs > nSelParts ifTrue:[
                                "/ new selector has more arguments; append them
                                stop := selectorParts last stop.
                                codeView deleteFromCharacterPosition:stop+1 to:crsrPos-1.
 
                                "/ append the rest ...
                                (numArgs min:newParts size) downTo:(nSelParts+1) do:[:idx |
                                    |newPart|
 
                                    newPart := newParts at:idx.
                                    newPart := newPart , ':'.
 
                                    (codeView characterAtCharacterPosition:stop) == $: ifFalse:[
                                        newPart := ':' , newPart.
                                    ].
                                    newPart := (codeView characterAtCharacterPosition:stop) asString , newPart.
 
                                    codeView replaceFromCharacterPosition:stop to:stop with:newPart.
                                    "/ remember the leftMost replacement's end as new cursor position
                                    newCursorPosition := stop + newPart size
                                ].
                                checkForArgumentTemplates := true.
                            ].
 
                            "/ replace existing parts
                            (nSelParts min:newParts size) downTo:1 do:[:idx |
                                |skipColon|
 
                                skipColon := 0.
                                newPart := newParts at:idx.
                                oldPartialToken := selectorParts at:idx.
                                start := oldPartialToken start.
                                stop := oldPartialToken stop.
 
                                (chosen endsWith:$:) ifTrue:[
                                    (codeView characterAtCharacterPosition:stop+1) == $: ifFalse:[
                                        newPart := newPart , ':'.
                                    ] ifTrue:[
                                        skipColon := 1.
                                    ]
                                ] ifFalse:[
                                    (codeView characterAtCharacterPosition:stop) == $: ifTrue:[
                                        newPart := newPart , ':'
                                    ] ifFalse:[
                                        |nextChar|
 
                                        nextChar := codeView characterAtCharacterPosition:stop+1.
                                        nextChar isSeparator ifFalse:[
                                            nextChar == $. ifFalse:[
                                                newPart := newPart , ' '
                                            ].
                                        ]
                                    ]
            "/                            codeView replaceFromCharacterPosition:start to:stop with:(newPart , ':').
            "/                        ] ifFalse:[
            "/                            codeView replaceFromCharacterPosition:start to:stop with:newPart.
                                ].
 
                                oldPartialToken value ~= newPart ifTrue:[
                                    codeView replaceFromCharacterPosition:start to:stop with:newPart.
 
                                    oldLen := stop - start + 1.
                                    newLen := newPart size.
 
                                    "/ codeView selectFromCharacterPosition:start+oldLen to:start+newLen-1.
                                    "/ remember the leftMost replacement's end as new cursor position
                                    newCursorPosition := start + newPart size + skipColon. "/ (newLen-oldLen) + 1.
                                    "/ codeView cursorToCharacterPosition:newCursorPosition.
                                ].
                            ].
                            newCursorPosition notNil ifTrue:[
                                codeView cursorToCharacterPosition:newCursorPosition-1.
                                codeView cursorRight.  "/ avoid going to the next line !!
                            ].
                            codeView dontReplaceSelectionOnInput.
 
                            checkForArgumentTemplates ifTrue:[
                                "/ add opening brackets, etc.
                                self insertAdditonalStuffAfterSelector:chosen.
                            ].
                            parenthesisToInsert notNil ifTrue:[
                                |sav pos|
 
                                sav := codeView characterPositionOfCursor-1.
                                "/ check if already parenthized
                                parentNodeToParenthesize hasParentheses ifTrue:[
                                    pos := parentNodeToParenthesize parentheses first first.
                                    codeView selectFromCharacterPosition:pos to:pos.
                                    codeView replaceSelectionBy:(parenthesisToInsert copyFirst:1) asString.
 
                                    pos := parentNodeToParenthesize parentheses first last.
                                    codeView selectFromCharacterPosition:pos to:pos.
                                    codeView replaceSelectionBy:(parenthesisToInsert copyLast:1) asString.
                                    codeView cursorToCharacterPosition:sav; cursorRight
                                ] ifFalse:[
                                    codeView insertString:(parenthesisToInsert copyLast:1) atCharacterPosition:node receiver stop+1.
                                    codeView insertString:(parenthesisToInsert copyFirst:1) atCharacterPosition:parentNodeToParenthesize start.
                                    codeView cursorToCharacterPosition:sav+2; cursorRight
                                ].
                            ].
                        ].
                    ].
 
                codeView
                    undoableDo:action
                    info:'Completion'.
            ].
        ].
 
    actionBlock value:allBest value:editAction value:nil.

    "Created: / 10-11-2006 / 13:18:27 / cg"
    "Modified: / 16-02-2010 / 10:33:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-05-2016 / 18:36:36 / cg"
!

codeCompletionForMessageTo:node into:actionBlock
    "find good suggestions for a message send to node, with no input yet.
     I.e. right after a receiver (w.o. any input yet)"
    
    |knownClass suggestions selectorsImplementedInClass mostUseful editActions pos|
 
    (knownClass := self classOfNode:node) isNil ifTrue:[
        self breakPoint:#cg.
        "/ self classOfNode:node.
        ^ self
    ].
    
    Verbose == true ifTrue:[ 
        Transcript show:node; show:' -> '; showCR:knownClass.
    ].    
    selectorsImplementedInClass := Set new.

    knownClass withAllSuperclassesDo:[:cls |
        cls ~~ Object ifTrue:[
            selectorsImplementedInClass addAll:cls selectors.
        ]    
    ].

    knownClass isMeta ifTrue:[
        selectorsImplementedInClass := 
            selectorsImplementedInClass reject:[:sel |
                |mthd|

                mthd := knownClass lookupMethodFor:sel.
                mthd notNil and:[mthd category startsWith: 'documentation']
            ].

        knownClass theNonMetaclass isAbstract ifTrue:[
            mostUseful := selectorsImplementedInClass select:[:sel |
                            knownClass implements:sel
                          ]
        ] ifFalse:[
            mostUseful := selectorsImplementedInClass select:[:sel |
                                |mthd|

                                mthd := knownClass lookupMethodFor:sel.
                                mthd notNil and:[mthd category startsWith: 'instance']
                          ].
        ]
    ] ifFalse:[
        mostUseful := 
            #(
                "/ blocks
                ifTrue: ifFalse: whileTrue: whileFalse: on:do: ensure: 
                whileTrue whileFalse loop
                "/ any
                isNil notNil isEmpty notEmpty 
            ).
    ].

    mostUseful notNil ifTrue:[
        suggestions := 
            (selectorsImplementedInClass select:[:sel | mostUseful includes:sel]) asNewOrderedCollection sort
            ,
            (selectorsImplementedInClass reject:[:sel | mostUseful includes:sel]) asNewOrderedCollection sort.
    ] ifFalse:[
        suggestions := selectorsImplementedInClass asNewOrderedCollection sort.
    ].

    suggestions := suggestions reject:[:sel | sel first == $_].
    self sortUsefulSelectorsIn:suggestions. "/cosmetics

    pos := codeView characterPositionOfCursor.
    editActions := suggestions collect:[:word |
                        self editActionToReplaceCodeFrom:pos to:pos-1 by:word.
                   ].                
    actionBlock value:suggestions value:editActions value:nil.

    "Created: / 01-05-2016 / 17:01:21 / cg"
    "Modified: / 01-05-2016 / 18:54:03 / cg"
!

codeCompletionForMethodSpec:node
    "completion in a method's selector pattern"

    self
        codeCompletionForMethodSpec:node
        into:
            [:suggestions :action :whatIsIt |

            |chosen|

            chosen := self askUserForCompletion:whatIsIt for:codeView
                           at:node start from:suggestions.
            chosen notNil ifTrue:[
                action value:(suggestions indexOf:chosen)
            ].
        ].

"/    |crsrPos
"/     selectorSoFar matchingSelectors
"/     selectors distances best rest
"/     allExistingMethods nameBag namesByCount selectors1 selectors2|
"/
"/    crsrPos := codeView characterPositionOfCursor - 1.
"/
"/    selectorSoFar := ''.
"/    node selectorParts doWithIndex:[:partToken :argNr|
"/        |part|
"/
"/        part := partToken value.
"/        selectorSoFar := selectorSoFar , part.
"/
"/        (crsrPos >= partToken start
"/        and:[crsrPos <= partToken stop]) ifTrue:[
"/            (classOrNil notNil and:[classOrNil isMeta]) ifTrue:[
"/                matchingSelectors := Smalltalk allClasses
"/                                    inject:(Set new)
"/                                    into:[:theSet :eachClass |
"/                                        |md|
"/
"/                                        md := eachClass theMetaclass methodDictionary.
"/                                        theSet addAll:(md keys select:[:sel |sel startsWith:selectorSoFar]).
"/                                        theSet.
"/                                    ].
"/                "/ don't forget the stuff in the class-line
"/                Metaclass withAllSuperclassesDo:[:cls |
"/                    matchingSelectors addAll:(cls methodDictionary keys select:[:sel |sel startsWith:selectorSoFar]).
"/                ].
"/            ] ifFalse:[
"/                matchingSelectors := Smalltalk allClasses
"/                                    inject:(Set new)
"/                                    into:[:theSet :eachClass |
"/                                        |md|
"/
"/                                        md := eachClass theNonMetaclass methodDictionary.
"/                                        theSet addAll:(md keys select:[:sel |sel startsWith:selectorSoFar]).
"/                                        theSet.
"/                                    ].
"/            ].
"/            selectors := matchingSelectors asOrderedCollection.
"/
"/            "/ if there is only one, and user has already entered it, he might want to complete the argument-name
"/            (selectors size == 1
"/            and:[selectors first = selectorSoFar]) ifTrue:[
"/                selectorSoFar numArgs == 0 ifTrue:[ ^ self ].
"/
"/                allExistingMethods := (Smalltalk allImplementorsOf:selectorSoFar asSymbol)
"/                                        collect:[:cls | cls compiledMethodAt:selectorSoFar asSymbol].
"/                nameBag := Bag new.
"/                allExistingMethods do:[:eachMethod | nameBag addAll:(eachMethod methodArgNames ? #())].
"/                namesByCount := nameBag valuesAndCounts sort:[:a :b | a value < b value].
"/                "/ take the one which occurs most often
"/                best := self askUserForCompletion:'argument' for:codeView at: node start from:(namesByCount collect:[:a | a key]).
"/
"/                codeView
"/                    undoableDo:[
"/                        (crsrPos+1) >= codeView contents size ifTrue:[
"/                            codeView paste:best.
"/                        ] ifFalse:[
"/                            codeView insertString:best atCharacterPosition:crsrPos+1.
"/                        ]
"/                    ]
"/                    info:'completion'.
"/                codeView cursorToCharacterPosition:(crsrPos + best size - 1).
"/            ] ifFalse:[
"/                "the ones implemented in superclasses are shown first"
"/                classOrNil notNil ifTrue:[
"/                    selectors1 := selectors select:[:sel | classOrNil respondsTo:sel].  "/ in super
"/                    selectors2 := selectors reject:[:sel | selectors1 includes:sel ].   "/ not in super
"/                ] ifFalse:[
"/                    selectors1 := selectors
"/                ].
"/
"/                distances := selectors1 collect:[:each | each spellAgainst:selectorSoFar].
"/                distances sortWith:selectors1.
"/                selectors1 reverse.
"/                selectors := selectors1.
"/
"/                selectors2 notEmptyOrNil ifTrue:[
"/                    distances := selectors2 collect:[:each | each spellAgainst:selectorSoFar].
"/                    distances sortWith:selectors2.
"/                    selectors2 reverse.
"/                    selectors1 := selectors1 collect:[:sel | sel allBold].
"/                    selectors := selectors1,selectors2.
"/                ].
"/
"/                best := self askUserForCompletion:'selector' for:codeView at:(node start) from:selectors.
"/                best isNil ifTrue:[^ self].
"/
"/                rest := best copyFrom:selectorSoFar size.
"/                codeView
"/                    undoableDo:[
"/                        codeView
"/                            replaceFromCharacterPosition:crsrPos+1
"/                            to:crsrPos+1
"/                            with:rest
"/                    ]
"/                    info:'Completion'.
"/                codeView cursorToCharacterPosition:(crsrPos+1 + rest size - 1).
"/            ].
"/            codeView cursorRight. "/ kludge to make it visible
"/        ].
"/    ].

    "Modified: / 04-07-2006 / 18:48:26 / fm"
    "Created: / 10-11-2006 / 13:46:44 / cg"
    "Modified: / 16-02-2010 / 10:13:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2012 / 20:31:36 / cg"
!

codeCompletionForMethodSpec:node into:actionBlock
    "completion in a method's selector pattern"

    |crsrPos crsrLine crsrCol
     selectorSoFar matchingSelectors
     selectors allExistingMethods nameBag namesByCount 
     allSelectors
     selectorsForIsXXXTests selectorsSentInClass selectorsImplementedInSuper 
     editAction editActionForArg argNames selectorsForVars
     selectorTypedSoFar addIfNotYetImplemented alreadyOK|

    allSelectors := Set new.

    "/ Transcript showCR:'m'.
    crsrLine := codeView cursorLine.
    crsrCol := codeView cursorCol.
    crsrPos := codeView characterPositionOfCursor - 1.

    selectorTypedSoFar := node selector.
    selectorTypedSoFar isUnarySelector ifTrue:[
        "/ user has just begun to edit a selector.
        "/ often, a good completion are the names of instVars for which no corresponding getter/setter exists
        classOrNil notNil ifTrue:[
            selectorsForVars := Set new.
            selectorsImplementedInSuper := Set new.
            selectorsSentInClass := Set new.
            selectorsForIsXXXTests := Set new.
            
            addIfNotYetImplemented :=
                [:list :sel |
                    sel ~= selectorTypedSoFar ifTrue:[    
                        (allSelectors includes:sel) ifFalse:[
                            (classOrNil implements:sel asSymbol) ifFalse:[ 
                                selectorsForVars add:sel.
                                allSelectors add:sel.
                            ].
                        ].
                    ].
                ].
                
            classOrNil instVarNames do:[:nm |
                (nm startsWith:selectorTypedSoFar) ifTrue:[
                    addIfNotYetImplemented value:selectorsForVars value:nm.
                    addIfNotYetImplemented value:selectorsForVars value:(nm,':').
                 ]
            ].
            classOrNil isMeta ifTrue:[
                classOrNil theNonMetaclass classVarNames do:[:nm |
                    |nmSel|

                    nmSel := nm asLowercaseFirst.
                    (nmSel startsWith:selectorTypedSoFar) ifTrue:[
                        addIfNotYetImplemented value:selectorsForVars value:nmSel.
                        addIfNotYetImplemented value:selectorsForVars value:(nmSel,':').
                    ]
                ].
            ] ifFalse:[
                "/ isXXX ?
                (('is',classOrNil nameWithoutPrefix) startsWith:selectorTypedSoFar ) ifTrue:[
                    addIfNotYetImplemented value:selectorsForIsXXXTests value:('is',classOrNil nameWithoutPrefix).
                ].
            ].

            "/ and also messages sent by the class itself
            classOrNil methodsDo:[:m |
                m messagesSentToSelf do:[:sel |
                    (sel startsWith:selectorTypedSoFar) ifTrue:[
                        addIfNotYetImplemented value:selectorsSentInClass value:sel.
                    ]                     
                ]
            ].
            classOrNil isMeta ifFalse:[
                classOrNil theMetaclass methodsDo:[:m |
                    m messagesSent do:[:sel |
                        (sel startsWith:selectorTypedSoFar) ifTrue:[
                            addIfNotYetImplemented value:selectorsSentInClass value:sel.
                        ]                     
                    ]                     
                ]
            ].
            "/ and also messages implemented by superclasses (except Object)
            classOrNil allSuperclassesDo:[:eachSuperclass |
                eachSuperclass ~~ Object ifTrue:[
                    eachSuperclass methodDictionary keysDo:[:sel |
                        (sel startsWith:selectorTypedSoFar) ifTrue:[
                            addIfNotYetImplemented value:selectorsImplementedInSuper value:sel.
                        ]                     
                    ]                     
                ]
            ].
        ].
    ].

    selectorSoFar := ''.
    matchingSelectors := Set new.
    
    node selectorParts doWithIndex:[:partToken :argNr|
        |part|

        part := partToken value.
        selectorSoFar := selectorSoFar , part.

        (crsrPos >= partToken start 
            and:[crsrPos <= partToken stop
                 or:[ (crsrPos == (partToken stop+1))
                      and:[codeView characterBeforeCursor == Character space]] ]
        ) ifTrue:[
            (classOrNil notNil and:[classOrNil isMeta]) ifTrue:[
                Smalltalk 
                    allClassesDo:[:eachClass |
                        |md|

                        md := eachClass theMetaclass methodDictionary.
                        matchingSelectors addAll:(md keys 
                                                    select:[:sel |sel startsWith:selectorSoFar]).
                    ].
                "/ do not forget the stuff in the class-line
                Metaclass withAllSuperclassesDo:[:cls |
                    matchingSelectors addAll:(cls methodDictionary keys 
                                                select:[:sel |sel startsWith:selectorSoFar]).
                ].
            ] ifFalse:[
                Smalltalk 
                    allClassesDo:[:eachClass |
                        |md|

                        md := eachClass theNonMetaclass methodDictionary.
                        matchingSelectors addAll:(md keys select:[:sel |sel startsWith:selectorSoFar]).
                    ].
            ].
        ].
    ].  
    alreadyOK := matchingSelectors includes:selectorTypedSoFar.
    matchingSelectors remove:selectorTypedSoFar ifAbsent:[].
    
    selectors := Set new.
    selectors addAll:matchingSelectors.
            
    selectorsForVars notNil ifTrue:[ selectors addAll:selectorsForVars ].
    selectorsSentInClass notNil ifTrue:[ selectors addAll:selectorsSentInClass ].
    selectorsImplementedInSuper notNil ifTrue:[ selectors addAll:selectorsImplementedInSuper ].
    selectorsForIsXXXTests notNil ifTrue:[ selectors addAll:selectorsForIsXXXTests ].
        
    selectors := selectors asOrderedCollection.
    selectors sort:[:a :b | a size < b size].
    selectorsForVars notEmptyOrNil ifTrue:[
        selectors := self 
                        splitSelectorList:selectors 
                        by:[:sel | selectorsForVars includes:sel].
    ].
    selectorsSentInClass notEmptyOrNil ifTrue:[
        selectors := self 
                        splitSelectorList:selectors 
                        by:[:sel | selectorsSentInClass includes:sel].
    ].
    selectorsImplementedInSuper notEmptyOrNil ifTrue:[
        selectors := self 
                        splitSelectorList:selectors 
                        by:[:sel | selectorsImplementedInSuper includes:sel].
    ].
    selectorsForIsXXXTests notEmptyOrNil ifTrue:[
        selectors := self 
                        splitSelectorList:selectors 
                        by:[:sel | selectorsForIsXXXTests includes:sel].
    ].
    
    selectors size > 100 ifTrue:[
        selectors := selectors copyTo:100.
    ].

    "/ if there is only one, and user has already entered it, 
    "/ he might want to complete the argument-name
    (alreadyOK and:[selectorSoFar numArgs > 0]) ifTrue:[
        allExistingMethods := (Smalltalk allImplementorsOf:selectorSoFar asSymbol)
                                    collect:[:cls | cls compiledMethodAt:selectorSoFar asSymbol].
        nameBag := Bag new.
        allExistingMethods do:[:eachMethod | nameBag addAll:(eachMethod methodArgNames ? #())].
        namesByCount := nameBag valuesAndCounts sort:[:a :b | a value < b value].
        namesByCount := namesByCount copyToMax:5.
        
        "/ take the one which occurs most often
        argNames := (namesByCount collect:[:a | a key]).
        argNames do:[:eachArgName |
            selectors add:('%1 %2 %3' 
                            bindWith:(selectorSoFar withColor:Color darkGrey) 
                            with:eachArgName
                            with:('(argument)' allItalic withColor:Color darkGrey)).
        ].
        
        editActionForArg :=
                [:chosenItem |
                    |chosenName|
                    
                    chosenName := chosenItem 
                                    copyFrom:(selectorSoFar size+2)
                                    to:(chosenItem indexOfSeparatorStartingAt:selectorSoFar size+2)-1.
                    codeView
                        undoableDo:[
                            (crsrPos+1) >= codeView contents size ifTrue:[
                                codeView paste:chosenName.
                                codeView cursorToCharacterPosition:(crsrPos + chosenName size - 1).
                            ] ifFalse:[
                                codeView cursorToCharacterPosition:crsrPos.
                                codeView cursorRight.
                                codeView insertStringAtCursor:chosenName.
                                codeView selectFromCharacterPosition:crsrPos+1 to:crsrPos+1+chosenName size-1.
                                codeView dontReplaceSelectionOnInput
                            ].
                        ]
                        info:'argname completion'.
                ].
    ].            

    "/ no, still more possibilities for the selector.
    "/ the ones implemented in superclasses are shown first.
    (classOrNil notNil and:[classOrNil superclass notNil]) ifTrue:[
        selectors := self 
                        splitSelectorList:selectors 
                        by:[:sel | classOrNil superclass implements:sel].
    ].

"/"/    distances := selectors collect:[:each | each spellAgainst:selectorSoFar].
"/"/    distances sortWith:selectors.
"/"/    selectors reverse.

    editAction :=
        [:selectedCompletionIndex |
            |chosen rest|
            
            chosen := selectors at:selectedCompletionIndex.
            (editActionForArg notNil and:[ chosen includesSeparator ]) ifTrue:[
                editActionForArg value:chosen.
            ] ifFalse:[    
                rest := chosen copyFrom:selectorSoFar size + 1.
                codeView
                    undoableDo:[
                        codeView insertString:rest atLine:crsrLine col:crsrCol.
                    ]
                    info:'Completion'.
                codeView cursorToCharacterPosition:(crsrPos+1 + rest size - 1).
                codeView cursorRight. "/ kludge to make it visible
            ].
        ].

    actionBlock
        value:selectors
        value:editAction
        value:'selector'.

    "Modified: / 04-07-2006 / 18:48:26 / fm"
    "Created: / 10-11-2006 / 13:46:44 / cg"
    "Modified: / 16-02-2010 / 10:13:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2012 / 20:31:36 / cg"
!

codeCompletionForTempVariable:node into:actionBlock
!

codeCompletionForVariable:node into:actionBlock
    |nonMetaClass crsrPos nm parent
     allVariables allDistances variablesAlreadyAdded nodeVal
     char getDistanceComputeBlockWithWeight addWithFactorBlock allTheBest bestAssoc
     globalFactor localFactor selectorOfMessageToNode implementors argIdx namesUsed kwPart editActions suggestions nameIsOK longerNames setOfNames otherArgNames
     suggestionsWithInfo isLeftSideOfAssignment|
 
    "/ Transcript show:'var in '; show:methodOrNil; show:' / '; showCR:classOrNil.
    classOrNil notNil ifTrue:[
        nonMetaClass := classOrNil theNonMetaclass.
    ].
 
    nm := node name.
    parent := node parent.
    isLeftSideOfAssignment := false.
    
    (parent notNil) ifTrue:[
        (parent isMessage) ifTrue:[
            node == parent receiver ifTrue:[
                selectorOfMessageToNode := parent selector
            ]
        ] ifFalse:[
            (parent isAssignment) ifTrue:[
                isLeftSideOfAssignment := (node == node parent variable).
            ].    
        ].    
    ].
                    
    crsrPos := codeView characterPositionOfCursor.
 
    "/ if we are behind the variable and a space has already been entered,
    "/ the user is probably looking for a message selector.
    "/ If the variable represents a global, present its instance creation messages
    char := codeView characterBeforeCursor. 

    (isLeftSideOfAssignment not and:[char == Character space]) ifTrue:[
        nm knownAsSymbol ifTrue:[
            classOrNil isNil ifTrue:[
                nodeVal := Smalltalk at:nm asSymbol.
            ] ifFalse:[
                nodeVal := classOrNil topNameSpace at:nm asSymbol ifAbsent:[Smalltalk at:nm asSymbol].
            ].
            nodeVal isBehavior ifTrue:[
                |selectors selectors1 selectors2|

                selectors1 := OrderedSet new.
                selectors2 := OrderedSet new.
                nodeVal class 
                    withAllSuperclassesDo:[:cls |
                        cls methodDictionary keysAndValuesDo:[:sel :mthd |
                            |cat|
                            cat := mthd category asLowercase.
                            cat = 'instance creation' ifTrue:[
                                selectors1 add:sel
                            ] ifFalse:[
                                "/ other category: look if it sends new, new: etc.
                                (mthd messagesSent includesAny:#(new new: basicNew basicNew:)) ifTrue:[
                                    selectors2 add:sel
                                ].    
                            ]
                        ]
                    ].
 
                selectors := selectors1 order sort , #('-') , selectors2 order sort.
                editActions := selectors collect:[:word | self editActionToInsert:word].
                actionBlock value:selectors value:editActions value:nil.
"/                editAction :=
"/                    [:answer |
"/                        |s|
"/                        s := answer isInteger ifTrue:[selectors at:answer] ifFalse:[answer].
"/                        codeView
"/                            undoableDo:[
"/                                codeView insertString:s atCharacterPosition:crsrPos.
"/                                codeView cursorToCharacterPosition:crsrPos+s size.
"/                            ]
"/                            info:'completion'.
"/                    ].
"/                actionBlock value:selectors value:editAction value:nil.
                ^ self.
            ].
        ].
    ].
 
    "/ this is pure voodoo magic (tries to make a good spelling weight,
    "/ by weighting the number of startsWith characters into the spelling distance...)
    getDistanceComputeBlockWithWeight :=
        [:weight |
            [:each |
                |dist factor|

                dist := each spellAgainst:nm.
                factor := 1.

                "/ bump the weight-factor if the name string is included
                (each includesString:nm) ifTrue:[
                    (each startsWith:nm) ifTrue:[
                        factor := 6 * weight * nm size.
                    ] ifFalse:[ 
                        (each endsWith:nm) ifTrue:[
                            factor := 5 * weight * nm size.
                        ] ifFalse:[
                            nm size > 1 ifTrue:[
                                factor := 4 * weight * nm size
                            ].    
                        ].    
                    ].    
                ] ifFalse:[
                    (each includesString:nm caseSensitive:false) ifTrue:[
                        (each asLowercase startsWith:nm asLowercase) ifTrue:[
                            factor := 4 * weight * nm size.
                        ] ifFalse:[
                            (each asLowercase endsWith:nm asLowercase) ifTrue:[
                                factor := 3 * weight * nm size.
                            ] ifFalse:[
                                nm size > 1 ifTrue:[
                                    factor := 2 * weight * nm size.
                                ]
                            ]
                        ]
                    ]
                ].    
                dist := dist + (weight*factor).

                each -> (dist * weight)
             ]
        ].

    nameIsOK := false.
    addWithFactorBlock :=
        [:eachNames :factor |
            |distanceComputeBlock|

            distanceComputeBlock := (getDistanceComputeBlockWithWeight value:factor).
            eachNames do:[:nameToAdd |
                (nameToAdd = nm) ifTrue:[
                    nameIsOK := true
                ] ifFalse:[ "/ not again
                    (variablesAlreadyAdded includes:nameToAdd) ifFalse:[  "/ not again
                        variablesAlreadyAdded add:nameToAdd.
                        allVariables add:nameToAdd.
                        allDistances add:(distanceComputeBlock value:nameToAdd).
                    ]
                ]
            ]
        ].

    nm isUppercaseFirst ifTrue:[
        globalFactor := 2.    "/ favour globals
        localFactor := 1.
    ] ifFalse:[
        globalFactor := 1.    "/ favour locals
        localFactor := 2.
    ].

    variablesAlreadyAdded := Set new.
    allVariables := OrderedCollection new.
    allDistances := OrderedCollection new.

    "/ are we in the method's selector spec ?
    (parent notNil
    and:[parent isMethod
    and:[parent arguments includes:node]]) ifTrue:[
        "/ yes -
        "/ now that's cool: look how the name of this argument is in other implementations
        "/ of this method, and take that as a basis of the selection

        implementors := SystemBrowser
                            findImplementorsOf:(parent selector)
                            in:(Smalltalk allClasses)
                            ignoreCase:false.
        "/ which argument is it
        argIdx := parent arguments indexOf:node.
        implementors size > 50 ifTrue:[
            implementors := implementors asOrderedCollection copyTo:50.
        ].
        namesUsed := implementors
                        collect:[:eachImplementor |
                            |parseTree|
                            parseTree := eachImplementor parseTree.
                            (parseTree notNil and:[parseTree arguments size > 0])
                                ifFalse:nil
                                ifTrue:[ (parseTree arguments at:argIdx) name] ]
                        thenSelect:[:a | a notNil].

        addWithFactorBlock value:namesUsed value:(2 * localFactor).

        "/ try some commonly used arg names, such as aBoolean, anInteger, etc.
        nm size > 1 ifTrue:[
            |tryClassNamesWith|

            ((nm startsWith:'a') and:[(nm at:2) isUppercase]) ifTrue:[
                tryClassNamesWith := 'a'
            ] ifFalse:[
                (nm size > 2 and:[ (nm startsWith:'an') and:[(nm at:3) isUppercase]]) ifTrue:[
                    tryClassNamesWith := 'an'.
                ].
            ].
            tryClassNamesWith notNil ifTrue:[
                addWithFactorBlock 
                    value:(Smalltalk keys 
                            collect:[:className | tryClassNamesWith,className]
                            thenSelect:[:name | name startsWith:nm])
                    value:(1.5 * localFactor)
            ].
        ].

        classOrNil notNil ifTrue:[
            "/ also, look for the keyword before the argument,
            "/ and see if there is such an instVar
            "/ if so, add it with -Arg
            parent selector isKeyword ifTrue:[
                kwPart := parent selector keywords at:argIdx.
                (classOrNil allInstVarNames includes:(kwPart copyButLast:1)) ifTrue:[
                    addWithFactorBlock
                        value:(classOrNil allInstVarNames collect:[:nm| nm,'Arg'])
                        value:(1 * localFactor).
                ].
            ].
            "/ look for the variable names of any other method in that class
            otherArgNames := Set new.
            classOrNil methodDictionary keysAndValuesDo:[:sel :mthd |
                            |parseTree|
                            parseTree := mthd parseTree.
                            (parseTree notNil and:[parseTree arguments size > 0])
                                ifFalse:nil
                                ifTrue:[ otherArgNames addAll:(parseTree arguments collect:[:each | each name])] ].
            addWithFactorBlock value:otherArgNames value:(1.5 * localFactor).
        ].
        addWithFactorBlock 
            value:(codeView previousReplacements 
                                    collect:[:p | p value asString]
                                    thenSelect:[:s | s isValidSmalltalkIdentifier]) 
            value:(1.3 * localFactor).
    ] ifFalse:[
        "/ locals in the block/method
        |names nameSpace|

        names := OrderedCollection withAll:node allVariablesOnScope.
        setOfNames := Set withAll:names.

        rememberedScopeNodes notNil ifTrue:[
            "/ notNil when a parseError occurred.
            rememberedScopeNodes do:[:eachScope |
                (eachScope isMethod or:[eachScope isBlock]) ifTrue:[
                    eachScope argumentNames do:[:eachName |
                        (setOfNames includes:eachName) ifFalse:[ names add:eachName. setOfNames add:eachName ]
                    ]
                ] ifFalse:[
                    eachScope isSequence ifTrue:[
                        eachScope temporaryNames do:[:eachName |
                            (setOfNames includes:eachName) ifFalse:[ names add:eachName. setOfNames add:eachName ]
                        ]
                    ] ifFalse:[
                    ]
                ].
                "/ (setOfNames includesAll:(eachScope allDefinedVariables)) ifFalse:[ self halt].
            ].

            rememberedScopeNodes do:[:eachScope |
                eachScope variableNodesDo:[:var |
                    (setOfNames includes:var name) ifFalse:[
                        names add:var name. setOfNames add:var name
                    ]
                ]
            ]
        ] ifFalse:[
            "/ tree must be there; in order to get as-yet-undeclared method locals
            "/ (further down the code), add them also
            tree variableNodesDo:[:var |
                |name|
                
                name := var name.
                (name first isLowercase or:[isLeftSideOfAssignment not]) ifTrue:[
                    (setOfNames includes:name) ifFalse:[
                        names add:name. 
                        setOfNames add:name
                    ]
                ]
            ]
        ].

        addWithFactorBlock value:names value:(4 * localFactor).

        classOrNil notNil ifTrue:[
            "/ instance variables
            addWithFactorBlock value:classOrNil instVarNames value:(3 * localFactor).

            "/ inherited instance variables
            classOrNil superclass notNil ifTrue:[
                addWithFactorBlock value:classOrNil superclass allInstVarNames value:(2.5 * localFactor).
            ].
        ].

        "/ magic:
        "/ if the node to be expanded is the receiver in a message, look for the selector sent to it
        "/ give names which respond to those messages a higher weight
        selectorOfMessageToNode notNil ifTrue:[
            |responders nonResponders|

            "/ responding to that messsage
"/ self halt.
            classOrNil notNil ifTrue:[
                "/ private classes
                addWithFactorBlock value:(nonMetaClass privateClasses collect:[:cls | cls nameWithoutPrefix])
                                   value:(2.75 * globalFactor).

                "/ class variables
                names := nonMetaClass classVarNames.
                responders := names select:[:classVar | (nonMetaClass classVarAt:classVar) respondsTo:selectorOfMessageToNode].
                nonResponders := names reject:[:classVar | (nonMetaClass classVarAt:classVar) respondsTo:selectorOfMessageToNode].

                addWithFactorBlock value:responders value:(3.0 * globalFactor).
                addWithFactorBlock value:nonResponders value:(0.5 * 1.5 * globalFactor).

                "/ superclass var names
                nonMetaClass allSuperclassesDo:[:superClass |
                    names := superClass classVarNames.
                    responders := names select:[:classVar | (superClass classVarAt:classVar) respondsTo:selectorOfMessageToNode].
                    nonResponders := names reject:[:classVar | (superClass classVarAt:classVar) respondsTo:selectorOfMessageToNode].

                    addWithFactorBlock value:responders value:(2.75 * globalFactor).
                    addWithFactorBlock value:nonResponders value:(0.5 * 1 * globalFactor).
                ].

                isLeftSideOfAssignment ifFalse:[
                    "/ namespace vars
                    classOrNil topNameSpace ~~ Smalltalk ifTrue:[
                        names := classOrNil topNameSpace keys.
                        names := names reject:[:nm | nm includes:$:].
                        names := names select:[:nm | nm isUppercaseFirst ].
                        responders := names select:[:nsVar | |c| c := classOrNil topNameSpace at:nsVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
                        nonResponders := names reject:[:nsVar | |c| c := classOrNil topNameSpace at:nsVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
                        addWithFactorBlock value:responders value:(2.5 * globalFactor).
                        addWithFactorBlock value:nonResponders value:(0.5 * 1.5 * globalFactor).
                    ].
                ].
            ].

            isLeftSideOfAssignment ifFalse:[
                "/ globals
                names := Smalltalk keys.
                names := names reject:
                                [:nm |
                                    (nm includes:$:) and:[ (Smalltalk at:nm) isBehavior not]
                                ].
                names := names reject:[:nm | nm startsWith:'Undeclared:::' ].

                names := names select:[:nm | nm isUppercaseFirst ] as:OrderedCollection.
                responders := names select:[:glblVar | |c| c := Smalltalk at:glblVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
                nonResponders := names reject:[:glblVar | |c| c := Smalltalk at:glblVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
                addWithFactorBlock value:responders value:(1.5 * globalFactor).
                addWithFactorBlock value:nonResponders value:(0.5 * 1.5 * globalFactor).
            ].
            
            isLeftSideOfAssignment ifFalse:[ "/ no, we will not suggest assigning to pool vars
                classOrNil notNil ifTrue:[
                    "/ pool variables
                    classOrNil theNonMetaclass sharedPoolNames do:[:poolName |
                        |pool names|

                        pool := Smalltalk at:poolName.
                        pool notNil ifTrue:[
                            names := pool classVarNames.
                            names := names select:[:nm | nm isUppercaseFirst ].
                            responders := names select:[:glblVar | |c| c := Smalltalk at:glblVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
                            nonResponders := names reject:[:glblVar | |c| c := Smalltalk at:glblVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
                            addWithFactorBlock value:responders value:(2.5 * globalFactor).
                            addWithFactorBlock value:nonResponders value:(0.5 * 2.5 * globalFactor).
                        ].
                    ].
                ]
            ]
        ] ifFalse:[
            classOrNil notNil ifTrue:[
                isLeftSideOfAssignment ifFalse:[ 
                    "/ private classes
                    addWithFactorBlock value:(nonMetaClass privateClasses collect:[:cls | cls nameWithoutPrefix])
                                       value:(2.75 * globalFactor).
                ].
                
                "/ class variables
                addWithFactorBlock value:nonMetaClass classVarNames value:(3.0 * globalFactor).
                nonMetaClass superclass notNil ifTrue:[
                    addWithFactorBlock value:nonMetaClass superclass allClassVarNames value:(2.5 * globalFactor).
                ].

                isLeftSideOfAssignment ifFalse:[ 
                    "/ namespace vars
                    classOrNil topNameSpace ~~ Smalltalk ifTrue:[
                        names := classOrNil topNameSpace keys.
                        names := names reject:[:nm | nm includes:$:].
                        names := names select:[:nm | nm isUppercaseFirst ].
                        addWithFactorBlock value:names value:(2.5 * globalFactor).
                    ].
                    "/ namespace vars
                    ((nameSpace := classOrNil nameSpace) notNil and:[nameSpace ~~ Smalltalk]) ifTrue:[
                        names := nameSpace isNameSpace ifTrue:[nameSpace keys] ifFalse:[nameSpace privateClasses collect:[:c | c nameWithoutPrefix]].
                        names := names select:[:nm | nm isUppercaseFirst ].
                        names := names reject:[:nm | nm includes:$:].
                        addWithFactorBlock value:names value:(2.5 * globalFactor).
                    ].
                ].
                isLeftSideOfAssignment ifFalse:[ "/ no, we will not suggest assigning to pool vars
                    "/ pool variables
                    classOrNil theNonMetaclass sharedPoolNames do:[:poolName |
                        |pool names|

                        pool := Smalltalk at:poolName.
                        pool isNil ifTrue:[
                            Transcript showCR:'non existent pool: ',poolName
                        ] ifFalse:[
                            names := pool classVarNames.
                            addWithFactorBlock value:names value:(2.5 * globalFactor).
                        ]
                    ].
                ].
            ].

            isLeftSideOfAssignment ifFalse:[ 
                "/ globals
                names := OrderedCollection new.
                Smalltalk keysDo:[:k |
                    (k isUppercaseFirst
                    and:[ (k startsWith:'Undeclared:::') not
                    and:[ ((k includes:$:) and:[ (k includesString:'::') not]) not ]]) ifTrue:[
                        names add:k
                    ]
                ].
            
                "/ only consider all globals, if the first char of the completed name is uppercase;
                "/ otherwise, only consider names with a caseInsensitve prefix match
                nm first isUppercase ifFalse:[
                    names := names select:[:globalName | globalName asLowercase startsWith: nm].
                ].
                addWithFactorBlock value:names value:(1.5 * globalFactor).
            ].
        ].

        isLeftSideOfAssignment ifFalse:[ 
            "/ pseudos - assuming that thisContext is seldom used.
            "/ also assuming, that nil is short so its usually typed in.
            addWithFactorBlock value:#('self') value:(2.5 * localFactor).
            addWithFactorBlock value:#('nil') value:(0.5 * localFactor).
            addWithFactorBlock value:#('super' 'false' 'true') value:(2 * localFactor).
            addWithFactorBlock value:#('thisContext') value:(1 * localFactor).
        ].
    ].

    allDistances isEmpty ifTrue:[^ self].

"/ nope (foo := foo + 1) should be possible!!
"/    (parent notNil and:[parent isAssignment]) ifTrue:[
"/        "/ remove the left side of the assignment (to avoid foo := foo suggestions)
"/        |i|
"/
"/        i := allDistances findFirst:[:entry | entry key = parent variable name].
"/        i ~~ 0 ifTrue:[
"/            allDistances removeAtIndex:i
"/        ].
"/    ].

    bestAssoc := allDistances at:1.
    bestAssoc := allDistances inject:bestAssoc into:[:el :best | el value > best value
                                                           ifTrue:[el]
                                                           ifFalse:[best]
                                                    ].

    allDistances sort:[:a :b |
                                a value > b value ifTrue:[
                                    true
                                ] ifFalse:[
                                    a value = b value ifTrue:[
                                        a key < b key
                                    ] ifFalse:[
                                        false
                                    ]
                                ]
                      ].

    allTheBest := allDistances.

    nameIsOK ifTrue:[
        "/ if the name already exists, only allow longer names, if there are
        longerNames := allTheBest select:[:assoc | (assoc key startsWith:nm) or:[assoc key endsWith:nm]].
        longerNames size < 30 ifTrue:[
            longerNames := allTheBest select:[:assoc | assoc key includesString:nm caseSensitive:false].
        ].
        longerNames isEmpty ifTrue:[
            "/ no better name
            ^ self
        ].
        allTheBest := longerNames.
    ].

    allTheBest size > 20 ifTrue:[
        allTheBest := allTheBest copyTo:20.
"/        "/ remove all those which are below some threshold or are a prefix
"/        0.2 to:0.9 by:0.1 do:[:delta |
"/            |bestValue n|
"/            
"/            "/ if still too many, remove more and more
"/            allTheBest size > 50 ifTrue:[
"/                bestValue := bestAssoc value * delta.
"/                n := allTheBest select:[:entry | (entry key startsWith:nm) or:[ entry value >= bestValue ]].
"/                n size >= 15 ifTrue:[ allTheBest := n ].
"/            ]
"/        ].
"/        allTheBest size > 20 ifTrue:[
"/            "/ remove all those which are below some threshold
"/            0.2 to:0.9 by:0.1 do:[:delta |
"/                |bestValue n|
"/                "/ if still too many, remove more and more
"/                allTheBest size > 20 ifTrue:[
"/                    bestValue := bestAssoc value * delta.
"/                    allTheBest := allTheBest select:[:entry | entry value >= bestValue ].
"/                ]
"/            ].
"/        ].
    ].
    suggestions := allTheBest collect:[:assoc | assoc key].

    "/ finally, the trick is to bring them into a reasonable order...
    "/ sort the prefix matchers by length, the others by spelling distance
    "/ and bring the prefix-matchers towards the beginning
    suggestions := ((suggestions select:[:s | s startsWith:nm]) sort:[:a :b | a size < b size ])
                   ,
                   (suggestions reject:[:s | s startsWith:nm]).

    "/ if super is among them, add a full call to the completions
    (suggestions includes:'super') ifTrue:[
        (tree notNil
        and:[ tree isMethod ]) ifTrue:[
            Error handle:[:ex |
                Transcript showCR:'parse error in code completion ignored'.
            ] do:[
                suggestions addFirst:('super ',(Parser methodSpecificationForSelector:tree selector argNames:(tree argumentNames)),'.').
            ]
        ].
    ].

    suggestionsWithInfo := 
        suggestions 
            collect:[:eachName |
                |val kind valAndKind printString|

                valAndKind := self valueAndKindOfVariable:eachName.
                valAndKind isNil ifTrue:[
                    eachName
                ] ifFalse:[
                    val := valAndKind first.
                    kind := valAndKind second.

                    val isBehavior ifTrue:[
                        val isLoaded ifFalse:[
                            eachName,' (= ', ('autoloaded class in ',(val category ? 'unknown category')) allItalic,' )'
                        ] ifTrue:[
                            val isNameSpace ifTrue:[
                                eachName,' ( ', 'namespace' allItalic,' )'
                            ] ifFalse:[
                                eachName,' (= ', ('class in ',(val category ? 'unknown category')) allItalic,' )'
                            ]
                        ]
                    ] ifFalse:[
                        "/ Parser findBest:30 selectorsFor:'isLite' in:nil forCompletion:true

                        (val isLiteral and:[ (printString := val printString) size < 15 ]) ifTrue:[
                            eachName,' (= ',printString allItalic,' )'
                        ] ifFalse:[
                            eachName,' (= ',val class nameWithArticle allItalic,' )'
                        ].
                    ].
                ].
            ].

    editActions := suggestions collect:[:word |
                     self editActionToReplaceNode:node by:word.
                   ].        
    actionBlock value:suggestionsWithInfo value:editActions value:nil.

    "Created: / 10-11-2006 / 13:16:33 / cg"
    "Modified: / 16-02-2010 / 10:13:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-05-2016 / 18:45:07 / cg"
!

editActionToInsert:aString
    ^ [:index |
        codeView
            undoableDo:[
                codeView insertSelectedStringAtCursor:aString.
                codeView dontReplaceSelectionOnInput
            ]
            info:'Completion'.
    ].
!

editActionToInsertFromSuggestions:suggestions
    ^ [:index |
        |answer|

        answer := suggestions at:index.
        codeView
            undoableDo:[
                codeView insertSelectedStringAtCursor:answer.
                codeView dontReplaceSelectionOnInput
            ]
            info:'Completion'.
    ].
!

editActionToReplaceCodeFrom:start to:stop by:aString
    ^ [:index |
        |oldVar oldLen newLen insertWithSpace|

        insertWithSpace := false.

        start <= stop ifTrue:[
            oldVar := (codeView textFromCharacterPosition:start to:stop) asString string withoutSeparators.
        ] ifFalse:[
            codeView characterBeforeCursor == Character space ifTrue:[
                insertWithSpace := true.
            ].
        ].

        oldLen := stop - start + 1.
        newLen := aString size.

        codeView
            undoableDo:[
                insertWithSpace ifTrue:[
                    codeView insertSelectedStringAtCursor:aString
                ] ifFalse:[
                    codeView replaceFromCharacterPosition:start to:stop with:aString.

                    (aString startsWith:oldVar) ifTrue:[
                        codeView selectFromCharacterPosition:start+oldLen to:start+newLen-1.
                    ] ifFalse:[
                        codeView selectFromCharacterPosition:start to:start+newLen-1.
                    ].
                ].
                codeView dontReplaceSelectionOnInput
            ]
            info:'Completion'.

    ].

    "Created: / 01-05-2016 / 18:47:40 / cg"
!

editActionToReplaceCodeFrom:start to:stop byWordIn:suggestions
    ^ [:index |
        |answer oldVar oldLen newLen insertWithSpace|

        insertWithSpace := false.

        answer := suggestions at:index.
        start <= stop ifTrue:[
            oldVar := (codeView textFromCharacterPosition:start to:stop) asString string withoutSeparators.
        ] ifFalse:[
            codeView characterBeforeCursor == Character space ifTrue:[
                insertWithSpace := true.
            ].
        ].

        oldLen := stop - start + 1.
        newLen := answer size.

        codeView
            undoableDo:[
                insertWithSpace ifTrue:[
                    codeView insertSelectedStringAtCursor:answer
                ] ifFalse:[
                    codeView replaceFromCharacterPosition:start to:stop with:answer.

                    (answer startsWith:oldVar) ifTrue:[
                        codeView selectFromCharacterPosition:start+oldLen to:start+newLen-1.
                    ] ifFalse:[
                        codeView selectFromCharacterPosition:start to:start+newLen-1.
                    ].
                ].
                codeView dontReplaceSelectionOnInput
            ]
            info:'Completion'.

    ].

    "Created: / 01-05-2016 / 18:47:40 / cg"
!

editActionToReplaceNode:node by:word
    ^ self editActionToReplaceCodeFrom:node start to:node stop by:word

    "Created: / 01-05-2016 / 18:44:09 / cg"
!

editActionToReplaceNode:node byWordIn:suggestions
    ^ self editActionToReplaceCodeFrom:(node start) to:(node stop) byWordIn:suggestions

    "Created: / 01-05-2016 / 18:44:09 / cg"
!

findBest:node for:selector inClasses:srchClassesArg
    |srchClasses bestSelectors
     allMessagesSentToVariable classesImplementingAllMessages|

    srchClasses := srchClassesArg.
    Verbose == true ifTrue:[
        Transcript show:'node: '; showCR:node.
        Transcript show:'srchClasses: '; showCR:srchClasses.
    ].
    
    srchClasses isEmptyOrNil ifTrue:[
        node isVariable ifTrue:[
            allMessagesSentToVariable := Set new.
            rememberedNodes do:[:eachNode |
                eachNode allMessageNodesDo:[:eachMessage |
                    |msgReceiver msgSelector|

                    (msgReceiver := eachMessage receiver) isVariable ifTrue:[
                        msgReceiver name = node name ifTrue:[
                            (msgSelector := eachMessage selector) ~= selector ifTrue:[
                                allMessagesSentToVariable add:msgSelector
                            ]
                        ]
                    ]
                ]
            ].
            allMessagesSentToVariable notEmpty ifTrue:[
                "/ consider classes which implement all those messages.
                classesImplementingAllMessages := Smalltalk allImplementorsOf:(allMessagesSentToVariable first).
                allMessagesSentToVariable do:[:eachSelector |
                    classesImplementingAllMessages := classesImplementingAllMessages
                                                        select:[:cls | cls implements:eachSelector].
                ].
                srchClasses := classesImplementingAllMessages.
            ].
        ].
    ].
    bestSelectors := Set new.
    srchClasses isEmptyOrNil ifTrue:[
        bestSelectors addAll:( Parser findBest:50 selectorsFor:selector in:nil forCompletion:true ).
        Verbose == true ifTrue:[
            Transcript show:'bestSelectors (1): '; showCR:bestSelectors.
        ].
    ] ifFalse:[    
        srchClasses do:[:srchClass |
            |bestForThisClass|

            bestForThisClass := Parser findBest:50 selectorsFor:selector in:srchClass forCompletion:true.
            bestForThisClass := self
                                withoutSelectorsUnlikelyFor:srchClass
                                from:bestForThisClass
                                forPartial:selector.
            Verbose == true ifTrue:[
                Transcript show:'bestSelectors (2): '; showCR:bestForThisClass.
            ].
            bestSelectors addAll:bestForThisClass.
        ].
    ].
    "/ remove the already typed-in selector itself, in case.
    bestSelectors remove:selector ifAbsent:[].
    bestSelectors := bestSelectors asOrderedCollection.
    ^ bestSelectors
!

findNodeForInterval:interval in:source
    ^ self class findNodeForInterval:interval in:source

    "Modified: / 06-07-2011 / 12:42:53 / cg"
!

findNodeForInterval:interval in:source allowErrors:allowErrors
    ^ self
	findNodeForInterval:interval in:source allowErrors:allowErrors
	mustBeMethod:false

    "Modified: / 16-09-2011 / 14:52:28 / cg"
!

findNodeForInterval:interval in:source allowErrors:allowErrors mustBeMethod:mustBeMethod
    "if mustBeMethod is true, do not try a regular expression (as in a workspace)."

    ^ self
	findNodeForInterval:interval in:source allowErrors:allowErrors
	mustBeMethod:mustBeMethod mustBeExpression:false
!

findNodeForInterval:interval in:source allowErrors:allowErrors mustBeMethod:mustBeMethod mustBeExpression:mustBeExpression
    "parse source, and find the node which is in the given interval 
     (typically a selection or a word in the source).

     parse it as expression or method;
        if mustBeMethod is true, do not try as expression;
        if mustBeExpression is true, do not try as method
     expression syntax parsing is done in workspaces (doIt).

     Big hack as workaround a limitation of RBParser:
     in case of an error, the parent chain of a node is usually not yet set.
     (because the code is written as: 
        parentNode addChild:(self parseChild)
     and the parent-chain of the parsed child is set in addChild).
     However:
        when doing code completion, having invalid syntax to parse is the normal case.

     Workaround:
        remember created nodes as the parse proceeds.
        Thus, I can construct a partial the parent chain.
    "

    |intersectingNodes smallestIntersectingNode firstIntersectingNode
     lastIntersectingNode onErrorBlock
     nodeGenerationHook parserClass parser currentScopeNodes bestNode|

    interval isEmpty ifTrue: [^ nil].

    languageOrNil notNil ifTrue:[
        parserClass := languageOrNil parserClass.
    ] ifFalse:[
        classOrNil notNil ifTrue:[
            parserClass := classOrNil programmingLanguage parserClass.
        ]
    ].
    parserClass notNil ifTrue:[
        "/ hack
        parserClass == Parser ifTrue: [
            parserClass := RBParser.
        ].
    ] ifFalse:[
        parserClass := RBParser.
    ].
    parserClass isNil ifTrue: [^ nil].

    rememberedScopeNodes := nil.
    rememberedNodes := OrderedCollection new.

    "/ LastSource := nil.
    source = LastSource ifTrue:[
        tree := LastParseTree.
        tokens := LastScanTokens.
    ] ifFalse:[
        intersectingNodes := OrderedCollection new.
        currentScopeNodes := IdentitySet new.

        onErrorBlock :=
            [:str :err :nodesSoFar |
                |nodes|

                allowErrors ifTrue:[
                    rememberedScopeNodes := currentScopeNodes.
                    firstIntersectingNode notNil ifTrue:[
                        ^ firstIntersectingNode
                    ].
                    nodesSoFar notNil ifTrue:[
                        nodes := nodesSoFar asOrderedCollection
                                    collect:[:nd | nd whichNodeIntersects:interval]
                                    thenSelect:[:nd | nd notNil ].
                        nodes size == 1 ifTrue:[
                            ^ nodes first
                        ].
                    ]
                ].
                nil
            ].

        self debuggingCodeFor:#cg is:[
            Transcript show:'looking for: '; showCR:interval.
        ].

        nodeGenerationHook :=
            [:node |
                rememberedNodes add:node.

                "/ would like to return here as soon as the node has been created by the parser;
                "/ however, at that time, its parent(chain) is not yet created and so we might not know
                "/ what the semantic interpretation (especially: scope of variable) will be.
                "/ therefore, we parse all, and return the found node at the end.
                (node isMethod or:[node isBlock or:[node isSequence]]) ifTrue:[
                    currentScopeNodes add:node.
                ] ifFalse:[
"/                    self debuggingCodeFor:#cg is:[
"/                        node isMessage ifTrue:[
"/                            Transcript show:node; show:' '; show:node start; show:'->'; showCR:node stop.
"/                        ].
"/                    ].

                    (node intersectsInterval:interval) ifTrue:[
                        self debuggingCodeFor:#cg is:[
                            Transcript showCR:'yes'.
                        ].
                        intersectingNodes add:node.
                        firstIntersectingNode isNil ifTrue:[
                            firstIntersectingNode := lastIntersectingNode := smallestIntersectingNode := node
                        ] ifFalse:[
                            |lenNode lenSmallest|

                            lenNode := (node stop - node start).
                            lenSmallest := (smallestIntersectingNode stop - smallestIntersectingNode start).
                            lenNode < lenSmallest ifTrue:[
                                smallestIntersectingNode := node.
                            ].
                            node start > lastIntersectingNode start ifTrue:[
                                lastIntersectingNode := node.
                            ].
                        ].
                    ].
                ].
            ].

        "/ one of the big problems when using the RBParser here is
        "/ that it behaves badly when a syntax error is encountered;
        "/ for example, a node's parent is usually set AFTER the children are
        "/ completely parsed (for example, a blockNode gets the parent-method only
        "/ after parsing). Thus, when an error is encountered, we cannot walk
        "/ the parent chain, and therefore will not see the outer locals/args of
        "/ an inner scope (allVariablesOnScope returns only a partial set).
        "/ A walkaround is to remember Method/Block nodes as created in the above node generation.
        "/ The disadvantage of it is that we do not have correct scope information, until the node's
        "/ parent gets set eventually, thus we might consider locals from sibling blocks.
        "/ See rememberedScopeNodes handling above.
        "/ Those other nodes are only remembered for failed parses;
        "/ if the parse is ok, rememberedScopeNodes will be nil.

        mustBeExpression ifFalse:[
            tree := parserClass
                        parseMethod: source
                        setup:[:p |
                            parser := p.
                            p rememberNodes:true.
                            p rememberTokens:true.
                            p nodeGenerationCallback:nodeGenerationHook
                        ]
                        onError: onErrorBlock.
            parser notNil ifTrue:[ tokens := parser rememberedTokens ].
        ].

        mustBeMethod ifTrue:[
            "/ only cache parsed methods
            tree notNil ifTrue:[
                LastSource := source.
                LastParseTree := tree.
                LastScanTokens := tokens.
            ].
        ] ifFalse:[
            (tree isNil or:[firstIntersectingNode isNil]) ifTrue:[
                "/ try as an expression
                tree := parserClass
                            parseExpression: source
                            setup:[:p |
                                parser := p.
                                p rememberNodes:true.
                                p rememberTokens:true.
                                p nodeGenerationCallback:nodeGenerationHook
                            ]
                            onError: onErrorBlock.
                parser notNil ifTrue:[ tokens := parser rememberedTokens ].
            ].
        ].
        lastIntersectingNode notNil ifTrue:[
            self debuggingCodeFor:#cg is:[
                Transcript show:'last: '; showCR:lastIntersectingNode.
            ].
            ^ lastIntersectingNode
        ].
        "/ firstIntersectingNode notNil ifTrue:[ ^ firstIntersectingNode ].
    ].

    bestNode := self findNodeForInterval:interval inParseTree:tree.
    self debuggingCodeFor:#cg is:[
        Transcript show:'best: '; showCR:bestNode.
    ].
    ^ bestNode

    "Created: / 16-09-2011 / 14:52:08 / cg"
    "Modified: / 18-09-2013 / 16:47:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-05-2016 / 10:05:10 / cg"
!

findNodeForInterval:interval inParseTree:parseTree
    |node|

    interval isEmpty ifTrue: [^ nil].
    parseTree isNil ifTrue:[^ nil].

    node := parseTree whichNodeIsContainedBy:interval.
    node isNil ifTrue:[
	node := parseTree whichNodeIntersects:interval.
	node isNil ifTrue: [
	    node := self findNodeIn:parseTree forInterval:interval
	].
    ].
    ^ node

    "Modified: / 10-11-2006 / 13:13:58 / cg"
!

findNodeIn:aTree forInterval:anInterval
    ^ self class findNodeIn:aTree forInterval:anInterval

    "Modified: / 20-11-2006 / 12:31:12 / cg"
!

insertAdditonalStuffAfterSelector:chosenCompletion
    |optionalExtraSpace|

    optionalExtraSpace := (codeView characterAfterCursor isSeparator)
                            ifTrue:['']
                            ifFalse:[' '].

    (
        #(
            'ifTrue:' 'ifFalse:' 'ifTrue:ifFalse:' 'ifFalse:ifTrue:'
            'and:' 'or:' 'timesRepeat:' 'whileTrue:' 'whileFalse:'
        ) includes:chosenCompletion
    ) ifTrue:[
        codeView insertStringAtCursor:('[',optionalExtraSpace,']').
        "/ codeView cursorLeft:1+extra size.
    ].
    (
        #(
            'collect:' 'select:' 'reject:' 'do:'
        ) includes:chosenCompletion
    ) ifTrue:[
        codeView insertStringAtCursor:('[:each | ]',optionalExtraSpace).
        codeView cursorLeft:1+optionalExtraSpace size.
    ].
    (
        #(
            'contains:' 'findFirst:' 'detect:'
        ) includes:chosenCompletion
    ) ifTrue:[
        codeView insertStringAtCursor:('[:some | ]',optionalExtraSpace).
        codeView cursorLeft:1+optionalExtraSpace size.
    ].
    (
        #(
            'remove:ifAbsent:' 'detect:ifNone:'
        ) includes:chosenCompletion
    ) ifTrue:[
        codeView insertStringAtCursor:('[]',optionalExtraSpace).
        codeView cursorLeft:1+optionalExtraSpace size.
    ].
!

messagesSentTo:varName in:aTree
    |messagesToReceiver collector|

    collector :=
        [:node | 
            (node isMessage 
            and:[node receiver isVariable
            and:[node receiver name = varName]]) ifTrue:[
                messagesToReceiver add:(node selector)
            ].
        ].
        
    "/ collect messages sent
    messagesToReceiver := Set new.
    "/ remembered nodes is nonNil if parser aborted with error
    rememberedNodes notNil ifTrue:[
        rememberedNodes do:collector.
    ] ifFalse:[
        tree allMessageNodesDo:collector.
    ]. 
    ^ messagesToReceiver
!

old_askUserForCompletion:what for:codeView from:allTheBest
    |list resources choice lastChoice|

    allTheBest isEmpty ifTrue:[ ^ nil ].
    allTheBest size == 1 ifTrue:[ ^ allTheBest first ].

    list := allTheBest.
    LastChoices notNil ifTrue:[
	lastChoice := LastChoices at:what ifAbsent:nil.
	lastChoice notNil ifTrue:[
	    "/ move tha last choice to the top of the list, if it is in.
	    (list includes: lastChoice) ifTrue:[
		(list indexOf: lastChoice) < 10 ifTrue:[
		    list := {lastChoice allBold } , (list copyWithout:lastChoice).
		]
	    ]
	].
    ].

    list size < 30 ifTrue:[
	|menu idx exitKey|

	menu := PopUpMenu labels:list.
	menu hideOnKeyFilter:[:key | |hide|
		hide := ( #( CursorDown CursorUp Escape Return ) includes: key) not.
		hide ifTrue:[
		    exitKey := key.
		].
		hide].
	menu memorizeLastSelection:3 "sigh, not 1 because of heading!!".
	idx := menu startUpWithHeading:'Choose ',what.
	idx == 0 ifTrue:[
	    exitKey notNil ifTrue:[
		codeView keyPress:exitKey x:0 y:0.
	    ].
	    ^ nil
	].
	choice := list at:idx.
    ] ifFalse:[
	resources := codeView application isNil
			ifTrue:[ codeView resources]
			ifFalse:[ codeView application resources ].

	choice := Dialog
	   choose:(resources string:'Choose ',what)
	   fromList:list
	   lines:20
	   initialSelection:(list firstIfEmpty:nil)
	   title:(resources string:'Code completion').
	choice isNil ifTrue:[^ nil].
    ].
    choice := choice string.

    LastChoices isNil ifTrue:[
	LastChoices := Dictionary new.
    ].
    LastChoices at:what put:choice.
    ^ choice

    "Created: / 16-02-2010 / 09:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-08-2013 / 15:28:01 / cg"
!

sortSelectors:list forSelector:selector lcSelector:lcSelector
    list sort: [:a :b |
        |aBeforeB|

        (a startsWith:selector) ifTrue:[
            (b startsWith:selector) ifFalse:[
                aBeforeB := true
            ]
        ] ifFalse:[    
            (b startsWith:selector) ifTrue:[
                aBeforeB := false
            ]
        ].
        aBeforeB isNil ifTrue:[
            aBeforeB := a asLowercase < b asLowercase.
            (a asLowercase startsWith:lcSelector) ifTrue:[
                (b asLowercase startsWith:lcSelector) ifFalse:[
                    aBeforeB := true
                ]
            ] ifFalse:[    
                (b asLowercase startsWith:lcSelector) ifTrue:[
                    aBeforeB := false
                ]
            ].
        ].
        aBeforeB
    ].
!

sortUsefulSelectorsIn:selectorList
    "/ cosmetics: 
    "/  ifTrue / whileTrue should come before ifFalse/whileFalse
    #(
        ifTrue:         ifFalse:
        ifTrue:ifFalse: ifFalse:ifTrue:
        whileTrue:      whileFalse:
        whileTrue       whileFalse
        whileTrue:      whileTrue
        whileFalse:     whileFalse
        new:            basicNew:
        new             basicNew
    ) pairWiseDo:[:sel1 :sel2 |
        |idx1 idx2|

        (idx1 := selectorList indexOf:sel1) ~~ 0 ifTrue:[
            (idx2 := selectorList indexOf:sel2) ~~ 0 ifTrue:[
                idx1 > idx2 ifTrue:[ 
                    selectorList swap:idx1 with:idx2
                ] 
            ] 
        ].
    ].

    "Created: / 01-05-2016 / 17:48:02 / cg"
!

splitSelectorList:list by:condition
    |part1 part2 newList|

    part1 := list select:condition.
    part2 := list reject:condition.
    part1 isEmpty ifTrue:[
        newList := part2.
    ] ifFalse:[
        part2 isEmpty ifTrue:[
            newList := part1.
        ] ifFalse:[
            newList := part1 , part2.
        ]
    ].
    ^ newList
!

treeForCode:source allowErrors:allowErrors
    |tree|

    source = LastSource ifTrue:[
	tree := LastParseTree.
    ] ifFalse:[
	tree := RBParser
		parseMethod:source
		onError: [:str :err :nodesSoFar :parserOrNil|
			allowErrors ifTrue:[
			    "/ parserOrNil isNil if raised by the scanner
			    parserOrNil notNil ifTrue:[
				^ parserOrNil currentMethodNode
			    ]
			].
			^ nil
		    ]
		proceedAfterError:false
		rememberNodes:true.

	tree notNil ifTrue:[
	    LastSource := source.
	    LastParseTree := tree.
	]
    ].
    ^ tree

    "Modified: / 13-01-2012 / 11:54:30 / cg"
!

tryCodeCompletionWithSource:source nodeInterval:interval at:characterPositionOfCursor mustBeExpression:mustBeExpression into:actionBlock
    "this is tried multiple times;
        first with cursor line only
        then with the source copied up to the cursor position,
        then with the full source.
     Either one may give better results (for example, when completing
     after a keyword selector, and the remaining code would lead to a syntactically
     legal, but stupid message send to be parsed...
     (which happens often after inserting)"

    |node nodeParent checkedNode characterBeforeCursor|

    "/ this is too naive and stupid; if there is a syntactic error,
    "/ we will not find a node for a long time (stepping back more and more,
    "/ until reaching the beginning). This leads to a thousand and more times reparsing
    "/ without any progress.
    "/ TODO: do it vice-versa, in that the parser does a callOut for every node generated
    "/ as it parses the code. Stop, when the interval is hit.
    "/ that will also work for syntactic incorrect source code.
    (mustBeExpression not and:[methodOrNil notNil or:[classOrNil notNil]]) ifTrue:[
        node := self findNodeForInterval:interval in:source allowErrors:true mustBeMethod:true.
    ].           
    node isNil ifTrue:[
        node := self findNodeForInterval:interval in:source allowErrors:true mustBeMethod:false mustBeExpression:true.
        node isNil ifTrue:[
            "/ Transcript showCR:'No parseNode found (syntax error before or in comment?)'.
            self information:'No parseNode found (syntax error before or in comment?)'.
            ^ self.
        ].
    ].
    "/ (source startsWith:'sel') ifTrue:[self halt].
    nodeParent := node parent.

    (node isVariable
    and:[ nodeParent notNil
    and:[ nodeParent isMessage
    and:[ node stop < (characterPositionOfCursor-1) ]]]) ifTrue:[
        node := nodeParent.
        nodeParent := node parent.
    ].
    characterPositionOfCursor > source size ifTrue:[^ self].
    characterBeforeCursor := source at:(characterPositionOfCursor-1 max:1). "/ codeView characterBeforeCursor.
    characterBeforeCursor isNil ifTrue:[ "at begin of line" ^ self].
    characterBeforeCursor == $. ifTrue:[ "at end of statement" ^ self].
 
    node isVariable ifTrue:[
        |nodeIsInTemporaries nodeIsInBlockArguments nodeIsInMethodArguments |

        nodeIsInTemporaries :=
            nodeParent notNil
            and:[ nodeParent isSequence
            and:[ nodeParent temporaries notEmptyOrNil
            and:[ node stop <= nodeParent temporaries last stop ]]]. 

        nodeIsInBlockArguments :=
            node blockScope notNil
            and:[ node blockScope arguments notEmptyOrNil
            and:[ node stop <= node blockScope arguments last stop ]].

        (nodeIsInBlockArguments not and:[rememberedScopeNodes notNil]) ifTrue:[
            "/ sigh - parent (and therefore blockScope) is unknown if parser has error
            nodeIsInBlockArguments := 
                rememberedScopeNodes 
                    contains:[:scope |
                        (scope isMethod or:[scope isBlock])
                        and:[scope arguments notEmpty
                        and:[scope arguments first start <= node start
                        and:[scope arguments last stop >= node stop]]].
                    ].        
        ].
        nodeIsInTemporaries ifTrue:[ self codeCompletionForTempVariable:node into:actionBlock. ^ self ]. 
        nodeIsInBlockArguments ifTrue:[ self codeCompletionForBlockArgument:node into:actionBlock. ^ self ]. 

        "/ for variable completion, cursor must be right after the node 
        codeView characterPositionOfCursor = (node stop + 1) ifTrue:[
            codeView characterBeforeCursor ~= Character space ifTrue:[
                self codeCompletionForVariable:node into:actionBlock.
                ^ self.
            ]. 
        ].
        "/ nodeParent isNil or:[nodeParent isMessage not]
    ].

false ifTrue:[
        codeView characterPositionOfCursor = (node stop + 2) ifTrue:[
            |classes cls| 
            "/ after a variable;
            "/ offer local messages, if receiver type is known
            classes := (self classesOfNode:node).
            classes notEmptyOrNil ifTrue:[
                classes size > 1 ifTrue:[
                    cls := classes anElement.
                ] ifFalse:[    
                    cls := Behavior commonSuperclassOf:classes.
                ]
            ]. 
            cls notNil ifTrue:[
                |clsSelectors moreSelectors|
            
                "/ completion in a message-send
                clsSelectors := cls methodDictionary keys. "/ Parser findBest:50 selectorsFor:'' in:cls forCompletion:true.
                clsSelectors size < 30 ifTrue:[
                    cls superclass notNil ifTrue:[
                        moreSelectors := cls superclass methodDictionary keys.
                        clsSelectors size + moreSelectors size < 30 ifTrue:[
                            clsSelectors := clsSelectors , moreSelectors.
                        ].
                    ].    
                ].
                "/ self codeCompletionForMessage:checkedNode into:actionBlock.
                actionBlock value:clsSelectors value:nil value:nil.
                ^ self.
            ]
        ]
].

    node isLiteral ifTrue:[
        "/ however, user may want to complete a symbol inside a literal array!!
        node value isArray ifTrue:[
            node token isLiteralArray ifTrue:[
                |elementBeforeCursor searcher|

                elementBeforeCursor := node token value detect:[:anElementToken | characterPositionOfCursor == (anElementToken stop + 1)] ifNone:nil.
                elementBeforeCursor isNil ifTrue:[
                    searcher :=
                        [:tok :check |
                            tok isLiteralArray ifTrue:[
                                tok value inject:nil into:[:found :el | found ifNil:[searcher value:el value:check]]
                            ] ifFalse:[
                                (check value:tok) ifTrue:[tok] ifFalse:[nil]
                            ]
                        ].
                    elementBeforeCursor := searcher value:node token value:[:anElementToken | characterPositionOfCursor == (anElementToken stop)].
                ].
                (elementBeforeCursor notNil and:[ elementBeforeCursor value isSymbol ]) ifTrue:[
                    self codeCompletionForLiteralSymbol:nil element:elementBeforeCursor considerAll:true into:actionBlock.
                    ^ self.
                ].
            ].
        ].

        "/ cursor must be right after the literal
        characterPositionOfCursor == (node stop + 1) ifFalse:[
            ^ self
        ].

        node value isSymbol ifTrue:[
            self codeCompletionForLiteralSymbol:node element:nil considerAll:false into:actionBlock.
            ^ self.
        ].

        "/ huh - completing strings, numbers or what?
        (nodeParent notNil
            and:[ nodeParent isMessage
            and:[ nodeParent isKeyword ]])
        ifFalse:[
            ^ self
        ].
        "/ no, move up and try completing the outer keyword message (next arg)
        node := nodeParent.
        nodeParent := node parent.
    ].

    Verbose == true ifTrue:[
        Transcript show:'node is '.
        Error ignoreIn:[ Transcript show:node ].
        Transcript cr.
    ].
    
    "/ if in a keyword-argument position...
    node isMessage ifTrue:[
        "/ where are we?
        node selectorString last == $: "node selector isSymbol" ifTrue:[
            characterBeforeCursor == $: ifTrue:[
                |argIdx senders implementors receiverClasses selectorUpToCursor implementorOfSelectorUpToCursor|
                "/ about to enter an argument?
                argIdx := node selectorParts keysAndValuesDetectKey:[:idx :part |
                            part stop == (codeView characterPositionOfCursor-1). 
                          ] ifNone:nil.
                argIdx notNil ifTrue:[          
                    selectorUpToCursor := ((node selectorParts collect:#value) copyTo:argIdx) asStringWith:''.        
                    implementors := Set new.
                    "/ find senders of this message, and see if they call it with a block argument
                    "/ this takes too long for a completion;
                    "/    Smalltalk allClassesDo:[:cls |
                    "/        cls instAndClassMethodsDo:[:m |
                    "/            (m sendsMessageForWhich:[:sel | sel startsWith:node selector]) ifTrue:[
                    "/                senders add:m
                    "/            ].    
                    "/        ]
                    "/    ].
                    "/ therefore, restrict to a max. of 5 classes
                    receiverClasses := self classesOfNode:node receiver.
                    (receiverClasses notEmptyOrNil and:[receiverClasses size <= 5]) ifTrue:[
                        receiverClasses do:[:eachPossibleReceiverClass |
                            eachPossibleReceiverClass withAllSuperclassesDo:[:cls |
                                cls methodDictionary keysAndValuesDo:[:sel :mthd |
                                    (sel startsWith:selectorUpToCursor) ifTrue:[
                                        implementors add:mthd.
                                        (sel = selectorUpToCursor) ifTrue:[
                                            implementorOfSelectorUpToCursor := implementorOfSelectorUpToCursor ? mthd
                                        ].    
                                    ].    
                                ].    
                            ]
                        ]
                    ].
                    implementorOfSelectorUpToCursor notNil ifTrue:[
                        |tree argName|
                        
                        SourceCodeManagerError handle:[:ex |
                        ] do:[    
                            tree := implementorOfSelectorUpToCursor parseTree. 
                            tree notNil ifTrue:[
                                argName := tree argumentNames at:argIdx.
                                (argName includesString:'block' caseSensitive:false) ifTrue:[
                                    actionBlock value:{'[ "',argName,'" ]'}
                                                value:{ self editActionToInsert:('[ "',argName,'" ]') }
                                                value:'block argument'
                                ]. 
                            ].
                        ].    
                    ] ifFalse:[    
                        implementors notEmpty ifTrue:[
                            self breakPoint:#cg.
                        ].    
                    ].
                ].    
            ].    
        ].    
    ].

    (node isVariable or:[node isBlock and:[node stop notNil]]) ifTrue:[
        (characterPositionOfCursor == (node stop + 1)
        "/ hack (spaces at end of line)
        or:[characterPositionOfCursor == (node stop)]) ifTrue:[
            codeView characterBeforeCursor == Character space ifTrue:[
                self codeCompletionForMessageTo:node into:actionBlock.
                ^ self
            ].
        ].
    ].

    "/ characterBeforeCursor == $) ifTrue:[self halt].

    "/ move outward, until we find a message-send node,
    "/ or the method's selector pattern node.
    checkedNode := node.
    [checkedNode notNil] whileTrue:[
        (characterPositionOfCursor <= ((checkedNode stop ? source size)+1)) ifTrue:[
            "/ Transcript show:'T: '; showCR:node.
            "/ Transcript showCR:('Inside a ',(checkedNode className)).
            "/ self information:('Inside a ',(checkedNode className)).
            (checkedNode isMessage 
            and:[characterPositionOfCursor < (checkedNode selectorParts first start)]) ifTrue:[
                self codeCompletionForMessageTo:checkedNode receiver into:actionBlock.
                ^ self
            ]
            
        ].

        checkedNode isMessage ifTrue:[
            "/ completion in a message-send
            "/ Transcript showCR:'codeCompletionForMessage'.
            self codeCompletionForMessage:checkedNode into:actionBlock.
            ^ self
        ].
        checkedNode isMethod ifTrue:[
            "/ completion in a method's selector pattern
            "/ Transcript showCR:'codeCompletionForMethodSpec'.
            self codeCompletionForMethodSpec:checkedNode into:actionBlock.
            ^ self.
        ].


        checkedNode := checkedNode parent.
    ].

    "/ Transcript showCR:'Node is neither variable nor message'.
    self information:'Node is neither variable nor message.'.

    "Modified: / 04-07-2006 / 18:48:26 / fm"
    "Modified: / 01-05-2016 / 19:00:33 / cg"
!

withoutSelectorsUnlikelyFor:aClass from:selectorsArg forPartial:partialSelector
    "some heuristics;
     as best selectors has been chosen by implemented methods for aClass,
     some of them should be filtered (for example, at:/at:put:, which are
     found in object, but only make sense for variable objects or those which do
     implement at:put: themself.
     I have currently no better idea than hardcoding stuff I found irritating..."

    |selectors noNilChecks noIsXXXChecks noNoXXXChecks noBecome 
     noIndexedSetters noIndexedGetters noSizeQueries docSelectors|

    aClass isNil ifTrue:[ ^ selectorsArg ].

    noNilChecks := noIsXXXChecks := noNoXXXChecks := noBecome := false.
    noIndexedSetters := noIndexedGetters := noSizeQueries := false.

    selectors := (selectorsArg ? #()) asOrderedCollection.

    self tracePoint:#cg message:aClass.

    aClass isMeta ifTrue:[
        docSelectors := #(copyright documentation examples 
                          version version_CVS version_SVN version_HG).
        selectors := selectors reject:[:sel | docSelectors includes:sel].
    ].
    
    "/ actually meaning booleans here
    (aClass == True or:[aClass == False]) ifTrue:[
        noNilChecks := noBecome := true.
        (partialSelector startsWith:'is') ifFalse:[ noIsXXXChecks := true ].
        (partialSelector startsWith:'no') ifFalse:[ noNoXXXChecks := true ].
    ].

    (aClass includesBehavior: ArithmeticValue) ifTrue:[ noNilChecks := true ].
    (aClass includesBehavior: Symbol) ifTrue:[ noNilChecks := noBecome := noIndexedSetters := true ].
    (aClass includesBehavior: Number) ifTrue:[ noBecome := true ].
    (aClass includesBehavior: Block) ifTrue:[ noNilChecks := noIsXXXChecks := noNoXXXChecks := noBecome := true ].

    (aClass isMeta) ifTrue:[
        noNilChecks := noBecome := true.
        "/ remove messages which are only defined in Object and non-meta classes.
        selectors := selectors reject:
            [:sel |
                (Object implements:sel)
                and:[ (Smalltalk allImplementorsOf:sel) conform:[:impl | impl isMeta not]]
            ].
    ].

    aClass isVariable ifFalse:[
        noIndexedGetters := noIndexedSetters := noSizeQueries := true.
    ].

    noIndexedSetters ifTrue:[
        #( #'at:put:' #'basicAt:put:') do:[:indexAccessSelector |
            (aClass whichClassIncludesSelector:indexAccessSelector) == Object ifTrue:[
                selectors := selectors copyWithout:indexAccessSelector.
            ].
        ].
    ].
    noIndexedGetters ifTrue:[
        #( #'at:' #'basicAt:') do:[:indexAccessSelector |
            (aClass whichClassIncludesSelector:indexAccessSelector) == Object ifTrue:[
                selectors := selectors copyWithout:indexAccessSelector.
            ].
        ].
    ].
    noSizeQueries ifTrue:[
        #( #size #basicSize ) do:[:indexAccessSelector |
            (aClass whichClassIncludesSelector:indexAccessSelector) == Object ifTrue:[
                selectors := selectors copyWithout:indexAccessSelector.
            ].
        ].
    ].

    noNilChecks ifTrue:[
        selectors removeAllFoundIn:#(
                    'isNil' 'notNil'
                    'ifNil:' 'ifNotNil:' 'ifNil:ifNotNil:' 'ifNotNil:ifNil:' 'ifNotNilDo:'
                    'ifEmpty:' 'ifNotEmpty:' 'ifNotEmptyDo:' 'ifEmpty:ifNotEmpty:'
                    'ifEmpty:ifNotEmptyDo:' 'ifNotEmptyDo:ifEmpty:' 'ifEmptyDo:ifNotEmpty:'
                  ).
    ].
    noIsXXXChecks ifTrue:[
        "/ get rid of all isXXX selectors
        selectors := selectors reject:[:sel | sel startsWith:'is'].
    ].
    noNoXXXChecks ifTrue:[
        "/ get rid of all notXXX selectors
        selectors := selectors reject:[:sel | sel startsWith:'no'].
    ].
    noBecome ifTrue:[
        "/ get rid of all become* selectors
        selectors := selectors reject:[:sel | sel startsWith:'become'].
        selectors remove:#oneWayBecome: ifAbsent:[].
        selectors := selectors reject:[:sel | sel startsWith:'changeClassTo'].
    ].

    "/ actually: directly implemented selectors are more likely, so move them to top
    selectors := (selectors select:[:sel | aClass implements:sel])
                 ,
                 (selectors reject:[:sel | aClass implements:sel]).

    ^ selectors
! !

!DoWhatIMeanSupport methodsFor:'code completion-helpers-old'!

codeCompletionForLiteralSymbol:node inClass:classOrNil codeView:codeView
    |sym possibleCompletions best start stop oldLen newLen oldVar|

    sym := node value.
    possibleCompletions := OrderedCollection new.

    Symbol allInstancesDo:[:existingSym |
	(existingSym startsWith:sym) ifTrue:[
	    (existingSym = sym) ifFalse:[
		possibleCompletions add:existingSym
	    ].
	].
    ].
    possibleCompletions sort.

    best := possibleCompletions longestCommonPrefix.
    (best = sym or:[(possibleCompletions includes:best) not]) ifTrue:[
	best := self askUserForCompletion:'symbol literal' for:codeView at: node start from:possibleCompletions.
	best isNil ifTrue:[^ self].
    ].

"/ self showInfo:best.

    start := node start.
    stop := node stop.
    (codeView characterAtCharacterPosition:start) == $# ifTrue:[
	start := start + 1.
    ].
    (codeView characterAtCharacterPosition:start) == $' ifTrue:[
	start := start + 1.
	stop := stop - 1.
    ].

    oldVar := (codeView textFromCharacterPosition:start to:stop) asString string withoutSeparators.

    codeView
	undoableDo:[ codeView replaceFromCharacterPosition:start to:stop with:best ]
	info:'Completion'.

    (best startsWith:oldVar) ifTrue:[
	oldLen := stop - start + 1.
	newLen := best size.
	codeView selectFromCharacterPosition:start+oldLen to:start+newLen-1.
	codeView dontReplaceSelectionOnInput
    ].

    "Modified: / 16-02-2010 / 10:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-07-2011 / 15:58:45 / cg"
!

codeCompletionForMessage:node inClass:classOrNil instance:instanceOrNil context:contextOrNil codeView:codeView
    "going to be OBSOLETE"
    
    |selector
     bestSelectors selector2 bestSelectors2 bestSelectorsFromRB allBest best numArgs
     newParts nSelParts oldLen newLen selectorParts
     findBest parentNode selectorInBest selector2InBest2
     parser selectorsSentInCode selectorsImplementedInClass
     varName rbTypes rbType tryParent parentIsKeywordMessage parentIsBinaryMessage rcvrClass|

    RefactoryTyper notNil ifTrue:[
        "/ refactory package also provides a (very limited) typer;
        "/ ask it for its oppinion as well (temporary - will vanish, once we have a better typer)
        (node receiver isVariable) ifTrue:[
            varName := node receiver name.
            varName isUppercaseFirst ifTrue:[
            ] ifFalse:[
                tree := RBParser
                            parseMethod:codeView contents string
                            onError:[:aString :pos | nil].
                tree notNil ifTrue:[
                    rbTypes := RefactoryTyper
                                classesFor: varName
                                in: tree
                                model: nil
                                ignoredSelectors:(Array with:node selector).
                    rbTypes size > 0 ifTrue:[
                        rbTypes size > 1 ifTrue:[
                            rbTypes remove:ProtoObject ifAbsent:[].
                            rbTypes remove:Autoload ifAbsent:[].
                            (Smalltalk includesKey:#ObsoleteObject) ifTrue:[
                                rbTypes remove:(Smalltalk at:#ObsoleteObject) ifAbsent:[].
                            ]
                        ].
                        rbTypes size == 1 ifTrue:[
                            rbType := rbTypes first.
                        ] ifFalse:[
                            rbType := Class commonSuperclassOf:rbTypes
                        ].
                        (rbType notNil "and:[rbType ~= Object]") ifTrue:[
                            bestSelectorsFromRB := Parser findBest:30 selectorsFor:node selector in:rbType forCompletion:true.
                        ].
                    ]
                ]
            ]
        ].
    ].

    classOrNil notNil ifTrue:[
        parser := Parser parseMethod:codeView contents string in:classOrNil ignoreErrors:true ignoreWarnings:true.
        selectorsSentInCode := parser messagesSent.
    ].
    classOrNil notNil ifTrue:[
        selectorsImplementedInClass := Set new.
        classOrNil withAllSuperclassesDo:[:cls |
            cls theNonMetaclass ~~ Object ifTrue:[
                selectorsImplementedInClass addAll:cls selectors.
            ]
        ]    
    ].

    findBest := [:node :selector |
        |srchClasses bestSelectors bestPrefixes|

        codeView withCursor:(Cursor questionMark) do:[
            srchClasses := self classesOfNode:node receiver.
            srchClasses notNil ifTrue:[
                bestSelectors := Set new.
                srchClasses do:[:each |
                    bestSelectors addAll:(Parser findBest:30 selectorsFor:selector in:each forCompletion:true).
                ]    
            ] ifFalse:[
                bestSelectors := Parser findBest:30 selectorsFor:selector in:nil forCompletion:true.
            ].
        ].

        (bestSelectors includes:selector) ifTrue:[
            bestSelectors := bestSelectors select:[:sel | sel size > selector size].
        ].
        bestSelectors
    ].

    selector := node selector.
    bestSelectors := findBest value:node value:selector.

    parentNode := node parent.

    parentIsKeywordMessage :=
        (parentNode notNil
            and:[ parentNode isMessage
            and:[ parentNode selector isKeyword]]).
    parentIsBinaryMessage :=
        (parentNode notNil
            and:[ parentNode isMessage
            and:[ parentNode selector isBinarySelector]]).

    tryParent := false.
    "/ if its a unary message AND the parent is a keyword node, look for parent completion too.
    (node selector isUnarySelector and:[ parentIsKeywordMessage ]) ifTrue:[
        tryParent := true.
    ] ifFalse:[
        "/ if the parent is an instance creation message, take that as lookup class.
        (node isMessage
        and:[ node receiver isMessage
        and:[ node receiver receiver isVariable
        and:[ node receiver receiver name isUppercaseFirst
        and:[ #(new new:) includes:(selector2 := node receiver selector) ]]]]) ifTrue:[
            rcvrClass := Smalltalk classNamed:(node receiver receiver name).
            "/ srchClass2 := self lookupClassForMessage:parentNode inClass:classOrNil.
            bestSelectors := Parser findBest:30 selectorsFor:selector in:rcvrClass forCompletion:true.
        ] ifFalse:[
            "/ also, if nothing was found
            (bestSelectors isEmpty
            and:[ parentNode notNil
            and:[ parentNode isMessage ]]) ifTrue:[
                "/ srchClass2 := self lookupClassForMessage:parentNode inClass:classOrNil.
                "/ selector2 := parentNode selector.
                "/ selector2 := selector2,selector.
                bestSelectors := findBest value:parentNode value:selector.
            ]
        ]
    ].
    tryParent ifTrue:[
        selector2 := parentNode selector,selector.
        bestSelectors2 := findBest value:parentNode value:selector2.
    ].
    bestSelectorsFromRB notEmptyOrNil ifTrue:[
        bestSelectors := bestSelectorsFromRB , (bestSelectors reject:[:sel | bestSelectorsFromRB includes:sel]).
    ].

    "/ if the parent is a keyword selector, the child cannot
    (parentIsKeywordMessage or:[parentIsBinaryMessage]) ifTrue:[
        bestSelectors := bestSelectors reject:[:sel | sel isKeyword]
    ].

    bestSelectors2 isEmptyOrNil ifTrue:[
        allBest := bestSelectors.
    ] ifFalse:[
        bestSelectors isEmptyOrNil ifTrue:[
            allBest := bestSelectors2
        ] ifFalse:[
            selectorInBest := (bestSelectors contains:[:sel | sel asLowercase startsWith:selector asLowercase]).
            selector2InBest2 := (bestSelectors2 contains:[:sel | sel asLowercase startsWith:selector2 asLowercase]).

            (selectorInBest not and:[ selector2InBest2 ]) ifTrue:[
                "/ selector2 is more likely
                allBest := bestSelectors2
            ] ifFalse:[
                (selectorInBest and:[ selector2InBest2 not ]) ifTrue:[
                    "/ selector more likely
                    allBest := bestSelectors
                ] ifFalse:[
                    "/ assume same likelyness

                    allBest := bestSelectors isEmpty
                                ifTrue:[ bestSelectors2 ]
                                ifFalse:[ bestSelectors , #(nil) , bestSelectors2 ].
                ]
            ].
        ].
    ].

    allBest isEmptyOrNil ifTrue:[ ^ self ].

    selectorsImplementedInClass notNil ifTrue:[
        "/ the ones implemented in the receiver class are moved to the top of the list.
        allBest := self 
                    splitSelectorList:allBest 
                    by:[:sel | selectorsImplementedInClass includes:sel].
    ].
    selectorsSentInCode notNil ifTrue:[
        "/ the ones already sent in the code are moved to the top of the list.
        allBest := self 
                    splitSelectorList:allBest 
                    by:[:sel | selectorsSentInCode includes:sel].
    ].

    "/ the ones which are a prefix are moved towards the top of the list
    allBest := self 
                splitSelectorList:allBest 
                by:[:sel | sel notNil and:[sel startsWith:selector]].

    best := allBest first.
    allBest size > 1 ifTrue:[
        "allBest size < 20 ifTrue:[
            |idx|

            idx := (PopUpMenu labels:allBest) startUp.
            idx == 0 ifTrue:[ ^ self].
            best := allBest at:idx.
        ] ifFalse:[
            allBest remove:nil ifAbsent:[].
            best := Dialog request:'Matching selectors:' initialAnswer:best list:allBest.

        ]."
        allBest remove:nil ifAbsent:[].
        best := self askUserForCompletion:('Selector for "%1"' bindWith:selector) for:codeView at: node selectorParts first start from:allBest.
        best isEmptyOrNil ifTrue:[^ self].
        best = '-' ifTrue:[^ self].
    ].

"/    srchClass notNil ifTrue:[
"/        implClass := srchClass whichClassIncludesSelector:best.
"/    ] ifFalse:[
"/        implClass := Smalltalk allClasses select:[:cls | (cls includesSelector:best) or:[cls class includesSelector:best]].
"/        implClass size == 1 ifTrue:[
"/            implClass := implClass first.
"/        ] ifFalse:[
"/            implClass := nil
"/        ]
"/    ].
"/
"/    info := best storeString.
"/    implClass notNil ifTrue:[
"/        info := implClass name , '  ' , info.
"/    ].
"/    self information:info.

    best ~= selector ifTrue:[
        numArgs := best numArgs.

        (bestSelectors2 notEmptyOrNil and:[bestSelectors2 includes:best]) ifTrue:[
            selectorParts := parentNode selectorParts , node selectorParts.
        ] ifFalse:[
            selectorParts := node selectorParts.
        ].
        nSelParts := selectorParts size.

        newParts := best asCollectionOfSubstringsSeparatedBy:$:.
        newParts := newParts select:[:part | part size > 0].

        codeView
            undoableDo:[
                |newCursorPosition stop|

                numArgs > nSelParts ifTrue:[
                    stop := selectorParts last stop.

                    "/ append the rest ...
                    numArgs downTo:nSelParts+1 do:[:idx |
                        |newPart|

                        newPart := newParts at:idx.
                        (best endsWith:$:) ifTrue:[
                            newPart := newPart , ':'
                        ].

                        (codeView characterAtCharacterPosition:stop) == $: ifFalse:[
                            newPart := ':' , newPart.
                        ].
                        newPart := (codeView characterAtCharacterPosition:stop) asString , newPart.

                        codeView replaceFromCharacterPosition:stop to:stop with:newPart.
                        newCursorPosition := stop + newPart size.
                    ]
                ].

                (nSelParts min:newParts size) downTo:1 do:[:idx |
                    |newPart oldPartialToken start stop nextChar|

                    newPart := newParts at:idx.
                    oldPartialToken := selectorParts at:idx.
                    start := oldPartialToken start.
                    stop := oldPartialToken stop.

                    (best isKeyword) ifTrue:[
                        (oldPartialToken value endsWith:$:) ifTrue:[
                            newPart := newPart , ':'
                        ] ifFalse:[
                            (codeView characterAtCharacterPosition:stop+1) == $: ifFalse:[
                                newPart := newPart , ':'
                            ]
                        ]
                    ] ifFalse:[
                        (codeView characterAtCharacterPosition:stop) == $: ifTrue:[
                            newPart := newPart , ':'
                        ] ifFalse:[
                            nextChar := codeView characterAtCharacterPosition:stop+1.
                            nextChar isSeparator ifFalse:[
                                (').' includes:nextChar) ifFalse:[
                                    newPart := newPart , ' '
                                ].
                            ]
                        ]
"/                            codeView replaceFromCharacterPosition:start to:stop with:(newPart , ':').
"/                        ] ifFalse:[
"/                            codeView replaceFromCharacterPosition:start to:stop with:newPart.
                    ].

                    codeView replaceFromCharacterPosition:start to:stop with:newPart.

                    "/ codeView selectFromCharacterPosition:start+oldLen to:start+newLen-1.
                    newCursorPosition isNil ifTrue:[
                        oldLen := stop - start + 1.
                        newLen := newPart size.

                        newCursorPosition := stop + (newLen-oldLen)
                    ].
                ].

                codeView cursorToCharacterPosition:newCursorPosition.
                codeView cursorRight.  "/ avoid going to the next line !!

                ((best endsWith:':') and:[numArgs == 1]) ifTrue:[
                    |impls impl|

                    "/ see if it expects a block argument (heuristic)
                    best := best asSymbol.
                    (node notNil
                    and:[classOrNil notNil
                    and:[node receiver isSelf]]) ifTrue:[
                        (impl := classOrNil whichClassImplements:best) isNil ifTrue:[
                            impls := #().
                            Screen current beep.
                        ] ifFalse:[
                            impls := { impl }
                        ]
                    ] ifFalse:[
                        impls := Smalltalk allImplementorsOf:best.
                    ].
                    (impls contains:[:cls |
                        |argName|

                        argName := ((cls compiledMethodAt:best) methodArgAndVarNames at:1) asLowercase.
                        (argName includesString:'block') or:[ (argName includesString:'action')]]
                    ) ifTrue:[
                        codeView insertStringAtCursor:'['
                    ].
                ].
                codeView dontReplaceSelectionOnInput.
            ]
        info:'Completion'.
    ].

    "Created: / 10-11-2006 / 13:18:27 / cg"
    "Modified: / 30-04-2016 / 18:21:21 / cg"
    "Modified: / 25-09-2015 / 07:39:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeCompletionForVariable:node inClass:classOrNil codeView:codeView
    |parent nonMetaClass crsrPos nm
     allVariables allDistances best nodeVal
     char start stop oldLen newLen oldVar
     getDistanceComputeBlockWithWeight addWithFactorBlock allTheBest bestAssoc
     globalFactor localFactor selectorOfMessageToNode tree implementors argIdx namesUsed kwPart|

    classOrNil notNil ifTrue:[
        nonMetaClass := classOrNil theNonMetaclass.
    ].

    nm := node name.

    "/ if we are behind the variable and a space has already been entered,
    "/ the user is probably looking for a message selector.
    "/ If the variable represents a global, present its instance creation messages
    crsrPos := codeView characterPositionOfCursor.
    char := codeView characterAtCharacterPosition:crsrPos-1.
    char isSeparator ifTrue:[
        classOrNil isNil ifTrue:[
            nodeVal := Smalltalk at:nm asSymbol.
        ] ifFalse:[
            nodeVal := classOrNil topNameSpace at:nm asSymbol ifAbsent:[Smalltalk at:nm asSymbol].
        ].
        nodeVal isBehavior ifTrue:[
            |methods menu exitKey idx|

            methods := nodeVal class methodDictionary values
                            select:[:m | |cat|
                                cat := m category asLowercase.
                                cat = 'instance creation'
                            ].

            menu := PopUpMenu labels:(methods collect:[:each | each selector]).
            menu hideOnKeyFilter:[:key | |hide|
                    hide := ( #( CursorDown CursorUp Escape Return ) includes: key) not.
                    hide ifTrue:[
                        exitKey := key.
                    ].
                    hide].

            idx := menu startUp.
            idx == 0 ifTrue:[
                exitKey notNil ifTrue:[
                    codeView keyPress:exitKey x:0 y:0.
                ].
                ^ self
            ].
            best := (methods at:idx) selector.
            codeView
                undoableDo:[
                    codeView insertString:best atCharacterPosition:crsrPos.
                    codeView cursorToCharacterPosition:crsrPos+best size.
                ]
                info:'completion'.
            ^ self.
        ].
    ].

    ((parent := node parent) notNil and:[parent isMessage]) ifTrue:[
        node == parent receiver ifTrue:[
            selectorOfMessageToNode := parent selector
        ]
    ].

    getDistanceComputeBlockWithWeight :=
        [:weight |
            [:each |
                |dist factor|

                dist := each spellAgainst:nm.
                factor := 1.

                (each startsWith:nm) ifTrue:[
                    factor := 6 * nm size.
                ] ifFalse:[
                    (each asLowercase startsWith:nm asLowercase) ifTrue:[
                        factor := 4 * nm size.
                    ] ifFalse:[
                        (each endsWith:nm) ifTrue:[
                            factor := 3 * nm size.
                        ] ifFalse:[
                            (each asLowercase endsWith:nm asLowercase) ifTrue:[
                                factor := 2 * nm size.
                            ]    
                        ]    
                    ]    
                ].
                dist := dist + (weight*factor).

                each -> (dist * weight)
             ]
        ].

    addWithFactorBlock :=
        [:eachNames :factor | |namesToAdd|
            namesToAdd := eachNames select:[:nameToAdd | nameToAdd ~= nm ].
            namesToAdd := namesToAdd reject:[:each | allVariables includes:each ].
            allVariables addAll:namesToAdd.
            allDistances addAll:(namesToAdd collect:(getDistanceComputeBlockWithWeight value:factor)).
        ].

    nm isUppercaseFirst ifTrue:[
        globalFactor := 2.    "/ favour globals
        localFactor := 1.
    ] ifFalse:[
        globalFactor := 1.    "/ favour locals
        localFactor := 2.
    ].

    allVariables := OrderedCollection new.
    allDistances := OrderedCollection new.

    "/ are we in the method's selector spec ?
    ((parent := node parent) notNil
    and:[parent isMethod
    and:[parent arguments includes:node]]) ifTrue:[
        "/ now that's cool: look how the naem of this argument is in other implementations
        "/ of this method, and take that as a basis of the selection

        implementors := SystemBrowser
                            findImplementorsOf:(parent selector)
                            in:(Smalltalk allClasses)
                            ignoreCase:false.
        "/ which argument is it
        argIdx := parent arguments indexOf:node.
        implementors size > 50 ifTrue:[
            implementors := implementors asOrderedCollection copyTo:50.
        ].
        namesUsed := implementors
                        collect:[:eachImplementor |
                            |parseTree|
                            parseTree := eachImplementor parseTree.
                            (parseTree notNil and:[parseTree arguments size > 0])
                                ifFalse:nil
                                ifTrue:[ (parseTree arguments at:argIdx) name] ]
                        thenSelect:[:a | a notNil] as:Set.

        addWithFactorBlock value:namesUsed value:(2 * localFactor).

        classOrNil notNil ifTrue:[
            "/ also, look for the keyword before the argument,
            "/ and see if there is such an instVar
            "/ if so, add it with -Arg
            parent selector isKeyword ifTrue:[
                kwPart := parent selector keywords at:argIdx.
                (classOrNil allInstVarNames includes:(kwPart copyButLast:1)) ifTrue:[
                    addWithFactorBlock
                        value:(classOrNil allInstVarNames collect:[:nm| nm,'Arg'])
                        value:(1 * localFactor).
                ].
            ].
        ]
    ] ifFalse:[
        classOrNil notNil ifTrue:[
            "/ locals in the block/method
            |names|

            names := node allVariablesOnScope.
            "/ if there were no variables (due to a parse error)
            "/ do another parse and see what we have
            names isEmpty ifTrue:[
                tree := self treeForCode:(codeView contentsAsString string) allowErrors:true.
                "/ better if we already have a body (include locals then)
                "/ otherwise, only the arguments are considered
                tree notNil ifTrue:[
                    names := (tree body ? tree) allVariablesOnScope.
                ]
            ].

            addWithFactorBlock value:names value:(4 * localFactor).

            "/ instance variables
            addWithFactorBlock value:classOrNil instVarNames value:(3 * localFactor).

            "/ inherited instance variables
            classOrNil superclass notNil ifTrue:[
                addWithFactorBlock value:classOrNil superclass allInstVarNames value:(2.5 * localFactor).
            ].
        ].

        selectorOfMessageToNode notNil ifTrue:[
            |names responders nonResponders|

            "/ responding to that messsage

            classOrNil notNil ifTrue:[
                "/ private classes
                addWithFactorBlock value:(nonMetaClass privateClasses collect:[:cls | cls nameWithoutPrefix])
                                   value:(1.75 * globalFactor).

                "/ class variables
                names := nonMetaClass classVarNames.
                responders := names select:[:classVar | (nonMetaClass classVarAt:classVar) respondsTo:selectorOfMessageToNode].
                nonResponders := names reject:[:classVar | (nonMetaClass classVarAt:classVar) respondsTo:selectorOfMessageToNode].

                addWithFactorBlock value:responders value:(1.5 * globalFactor).
                addWithFactorBlock value:nonResponders value:(0.5 * 1.5 * globalFactor).

                "/ superclass var names
                nonMetaClass allSuperclassesDo:[:superClass |
                    names := superClass classVarNames.
                    responders := names select:[:classVar | (superClass classVarAt:classVar) respondsTo:selectorOfMessageToNode].
                    nonResponders := names reject:[:classVar | (superClass classVarAt:classVar) respondsTo:selectorOfMessageToNode].

                    addWithFactorBlock value:responders value:(1 * globalFactor).
                    addWithFactorBlock value:nonResponders value:(0.5 * 1 * globalFactor).
                ].

                "/ namespace vars
                classOrNil nameSpace ~~ Smalltalk ifTrue:[
                    names := classOrNil topNameSpace keys.
                    names := names reject:[:nm | nm includes:$:].
                    names := names select:[:nm | nm isUppercaseFirst ].
                    responders := names select:[:nsVar | |c| c := classOrNil topNameSpace at:nsVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
                    nonResponders := names reject:[:nsVar | |c| c := classOrNil topNameSpace at:nsVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
                    addWithFactorBlock value:responders value:(1.5 * globalFactor).
                    addWithFactorBlock value:nonResponders value:(0.5 * 1.5 * globalFactor).
                ].
            ].

            "/ globals
            names := Smalltalk keys.
            "/ names := names reject:[:nm | nm includes:$:].
            names := names select:[:nm | nm isUppercaseFirst ].
            responders := names select:[:glblVar | |c| c := Smalltalk at:glblVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
            nonResponders := names reject:[:glblVar | |c| c := Smalltalk at:glblVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
            addWithFactorBlock value:responders value:(1.5 * globalFactor).
            addWithFactorBlock value:nonResponders value:(0.5 * 1.5 * globalFactor).

            "/ pool variables
            classOrNil theNonMetaclass sharedPoolNames do:[:poolName |
                |pool|

                pool := Smalltalk at:poolName.
                names := pool classVarNames.
                names := names select:[:nm | nm isUppercaseFirst ].
                responders := names select:[:glblVar | |c| c := Smalltalk at:glblVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
                nonResponders := names reject:[:glblVar | |c| c := Smalltalk at:glblVar. c isBehavior not or:[c isLoaded and:[c respondsTo:selectorOfMessageToNode]]].
                addWithFactorBlock value:responders value:(2.5 * globalFactor).
                addWithFactorBlock value:nonResponders value:(0.5 * 2.5 * globalFactor).
            ].
        ] ifFalse:[
            |names|

            classOrNil notNil ifTrue:[
                "/ private classes
                addWithFactorBlock value:(nonMetaClass privateClasses collect:[:cls | cls nameWithoutPrefix])
                                   value:(1.75 * globalFactor).

                "/ class variables
                addWithFactorBlock value:nonMetaClass classVarNames value:(2.0 * globalFactor).
                classOrNil superclass notNil ifTrue:[
                    addWithFactorBlock value:nonMetaClass superclass allClassVarNames value:(2.0 * globalFactor).
                ].

                "/ namespace vars
                classOrNil nameSpace ~~ Smalltalk ifTrue:[
                    names := classOrNil nameSpace isNameSpace ifTrue:[classOrNil nameSpace keys] ifFalse:[classOrNil nameSpace privateClasses collect:[:c | c nameWithoutPrefix]].
                    names := names select:[:nm | nm isUppercaseFirst ].
                    addWithFactorBlock value:names value:(1.5 * globalFactor).
                ].

                "/ pool variables
                classOrNil theNonMetaclass sharedPoolNames do:[:poolName |
                    |pool|

                    pool := Smalltalk at:poolName.
                    names := pool classVarNames.
                    addWithFactorBlock value:names value:(2.5 * globalFactor).
                ].
            ].

            "/ globals
            names := Smalltalk keys.
            names := names select:[:nm | nm isUppercaseFirst ].
            addWithFactorBlock value:names value:(1.5 * globalFactor).
        ].

        "/ pseudos - assuming that thisContext is seldom used.
        "/ also assuming, that nil is short so its usually typed in.
        addWithFactorBlock value:#('self') value:(2.5 * localFactor).
        addWithFactorBlock value:#('nil') value:(0.5 * localFactor).
        addWithFactorBlock value:#('super' 'false') value:(2 * localFactor).
        addWithFactorBlock value:#('thisContext') value:(1 * localFactor).
        addWithFactorBlock value:#('true') value:(1 * localFactor).
        addWithFactorBlock value:#('false') value:(1 * localFactor).
    ].

    allDistances isEmpty ifTrue:[^ self].
    bestAssoc := allDistances at:1.
    bestAssoc := allDistances inject:bestAssoc into:[:el :best | el value > best value
                                                           ifTrue:[el]
                                                           ifFalse:[best]
                                                    ].

    allDistances sort:[:a :b |
                                a value > b value ifTrue:[
                                    true
                                ] ifFalse:[
                                    a value = b value ifTrue:[
                                        a key < b key
                                    ] ifFalse:[
                                        false
                                    ]
                                ]
                      ].
    ((allTheBest := allDistances) count:[:entry | entry value]) > 20 ifTrue:[
        allTheBest := allDistances select:[:entry | entry value >= (bestAssoc value * 0.5)].
        allTheBest size > 15 ifTrue:[
            allTheBest := allDistances select:[:entry | entry value >= (bestAssoc value * 0.8)].
        ].
    ].

    start := node start.
    stop := node stop.

    best := self askUserForCompletion:('Variable for "%1"' bindWith:node name)
                 for:codeView at: start
                 from:(allTheBest collect:[:assoc | assoc key]).
    best isNil ifTrue:[^ self].

"/ self showInfo:best.

    oldVar := (codeView textFromCharacterPosition:start to:stop) asString string withoutSeparators.

    codeView
        undoableDo:[ codeView replaceFromCharacterPosition:start to:stop with:best ]
        info:'Completion'.

    (best startsWith:oldVar) ifTrue:[
        oldLen := stop - start + 1.
        newLen := best size.
        codeView selectFromCharacterPosition:start+oldLen to:start+newLen-1.
        codeView dontReplaceSelectionOnInput
    ].

    "Created: / 10-11-2006 / 13:16:33 / cg"
    "Modified: / 16-02-2010 / 10:13:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-08-2013 / 15:37:28 / cg"
! !

!DoWhatIMeanSupport methodsFor:'helpers-naive type inference'!

addClassesFromAssignmentTo:varName in:aTree to:setOfTypes
    "/ assignments...
    
    aTree allAssignmentNodesDo:[:eachAssignmentNode |
        |leftSide|

        leftSide := eachAssignmentNode variable.
        leftSide name = varName ifTrue:[
            self 
                addClassesOfExpression:eachAssignmentNode value 
                inClass:classOrNil to:setOfTypes.
        ]
    ].
    ^ setOfTypes.
!

addClassesFromMessagesSentTo:varNode in:aTree to:setOfTypes
    "/ from the set of messages sent at other places,
    "/ try to find classes, which respond to all those.
    
    |varName allSelectors candidates|

    varName := varNode name.
    
    allSelectors := IdentitySet new.
    aTree allMessageNodesDo:[:eachMessageNode |
        |rcvr|

        rcvr := eachMessageNode receiver.
        (rcvr isVariable and:[rcvr name = varName]) ifTrue:[
            allSelectors add:eachMessageNode selector
        ]
    ].
    
    "/ the selector being completed must be ignored here
    (varNode parent notNil and:[varNode parent isMessage]) ifTrue:[
        allSelectors remove:(varNode parent selector) ifAbsent:[].
    ].

    "/ now look for classes which implement all of them
    candidates := SystemBrowser findRespondersOfAll:allSelectors in:nil ignoreCase:false.
    candidates remove:Object ifAbsent:[].
    setOfTypes addAll:candidates.
    ^ setOfTypes.
!

addClassesOfBlockVarForWellknownBlocks:variableNode inScope:blockScope to:setOfTypes
    |blockParent blockParentSelector exNode isHandler|

    blockParent := blockScope parent.
    (blockParent notNil and:[blockParent isMessage]) ifFalse:[^ setOfTypes].
    
    blockParentSelector := blockParent selector.
    
    "/ if the parent of the block is an enumeration message, and the receiver is known,
    "/ we know the type of argument.
    ( #(do: keysAndValuesDo: select: collect:) includes:blockParent selector) ifTrue:[
        |collection|

        collection := self valueOfNode:blockParent receiver.
        collection notNil ifTrue:[
            (collection isKindOf:Collection) ifTrue:[
                collection notEmpty ifTrue:[
                    |someElement|
                    someElement := collection anElement.
                    setOfTypes add:someElement class.
                    ^ setOfTypes
                ].
            ].
        ].
    ].
    
    "/ because we type-in those so often, it is great to get
    "/ better info on the ex parameter... (and it's a low hanging fruit)
    ( blockParentSelector == #handle:do: ) ifTrue:[
        exNode := blockParent receiver.
        isHandler := (blockScope == (blockParent arguments at:1)).
    ].
    ( blockParentSelector == #on:do: ) ifTrue:[
"/        self halt.
        exNode := blockParent arg1.
        isHandler := (blockScope == (blockParent arguments at:2)).
    ].    
    exNode notNil ifTrue:[
        |cls exClass|
        
        ((cls := (self valueOfNode:exNode)) notNil and:[cls isBehavior]) ifTrue:[
            exClass := cls
        ] ifFalse:[
            exClass := Exception
        ].
        setOfTypes add:exClass.
        ^ self
    ].    
    ^ setOfTypes
!

addClassesOfExpression:expr inClass:classOrNil to:setOfTypes
    |cls exprVal varName varScope instVarClass classVarClass poolVarClass sym|

    expr isLiteral ifTrue:[
        exprVal := expr value.
        cls := exprVal class.         
        (exprVal isArray or:[ exprVal isByteArray or:[ exprVal isString ]]) ifTrue:[
            exprVal isImmutable ifTrue:[
                setOfTypes add:cls mutableClass.
                ^ setOfTypes.    
            ]
        ].
        setOfTypes add:cls. 
        ^ setOfTypes.    
    ].
    
    expr isBlock ifTrue:[
        setOfTypes add:Block. 
        ^ setOfTypes.
    ].

    thisContext isRecursive ifTrue:[^ setOfTypes].

    expr isVariable ifTrue:[
        varName := expr name.
        varName = 'self' ifTrue:[
            instanceOrNil notNil ifTrue:[
                setOfTypes add:(instanceOrNil class).
            ] ifFalse:[    
                setOfTypes add:(classOrNil ? UndefinedObject).
            ].
            ^ setOfTypes
        ].
        varName = 'super' ifTrue:[
            classOrNil isNil 
                ifTrue:[setOfTypes add:Object]
                ifFalse:[setOfTypes add:classOrNil superclass].
            ^ setOfTypes.    
        ].
        varName = 'thisContext' ifTrue:[
            setOfTypes add:Context.
            ^ setOfTypes
        ].
        
        varScope := expr whoDefines: varName.
        (varScope notNil) ifTrue:[
            varScope isSequence ifTrue:[
                varScope := varScope parent.
            ].
            
            (varScope isBlock) ifTrue:[
                self addClassesOfBlockVarForWellknownBlocks:expr inScope:varScope to:setOfTypes.
                self addClassesFromAssignmentTo:varName in:varScope to:setOfTypes.
                self addClassesFromMessagesSentTo:expr in:varScope to:setOfTypes.
                ^ setOfTypes
            ].    
            (varScope isMethod) ifTrue:[
                self addClassesFromAssignmentTo:varName in:varScope to:setOfTypes.
                self addClassesFromMessagesSentTo:expr in:varScope to:setOfTypes.
                ^ setOfTypes
            ].    
        ].
        
        classOrNil notNil ifTrue:[
            "/ inst var
            instVarClass := classOrNil whichClassDefinesInstVar:varName.
            instVarClass notNil ifTrue:[
                setOfTypes addAll:(self classesOfInstVarNamed:varName inClass:instVarClass).
                ^ setOfTypes
            ].    
        
            "/ class vars
            classVarClass := classOrNil theNonMetaclass whichClassDefinesClassVar:varName.
            classVarClass notNil ifTrue:[
                "/ see what is currently there
                setOfTypes add:(classVarClass classVarAt:varName asSymbol) class.
                ^ setOfTypes
            ].    
            varName isUppercaseFirst ifTrue:[
                "/ private class
                varName knownAsSymbol ifTrue:[
                    cls := classOrNil theNonMetaclass privateClassesAt:varName asSymbol.
                    cls notNil ifTrue:[
                        setOfTypes add:(cls theMetaclass).
                        ^ setOfTypes
                    ].    
                ].    
            ].
            "/ pool vars
            poolVarClass := classOrNil theNonMetaclass whichPoolDefinesPoolVar:varName.
            poolVarClass notNil ifTrue:[
                "/ see what is currently there
                setOfTypes add:(poolVarClass classVarAt:varName asSymbol) class.
                ^ setOfTypes
            ].    
        ].
        
        varName isUppercaseFirst ifTrue:[
            sym := varName asSymbolIfInterned.
            sym notNil ifTrue:[
                exprVal := (Smalltalk at:sym).
                exprVal notNil ifTrue:[
                    setOfTypes add:(exprVal class).
                ]    
            ].        
        ].    
        ^ setOfTypes
    ].

    (exprVal := self valueOfNode:expr) notNil ifTrue:[
        "/ knowing the value is always great!!
        setOfTypes add:exprVal class.
        ^ setOfTypes.
    ].

    expr isMessage ifTrue:[
        self addClassesOfMessage:expr inClass:classOrNil to:setOfTypes.
        ^ setOfTypes
    ].    

    ^ setOfTypes

    "Modified: / 07-06-2016 / 11:33:19 / cg"
!

addClassesOfInstVarNamed:varName inClass:aClass to:setOfTypes
    |instIndex type|
    
    instIndex := aClass instVarIndexFor:varName.

    "/ ask the class
    (type := aClass typeOfInstVarNamed:varName) notNil ifTrue:[
        type isCollection ifTrue:[
            setOfTypes addAll:type.
        ] ifFalse:[    
            setOfTypes add:type.
        ].
        ^ setOfTypes
    ].    

    "/ look for instances
    aClass allSubInstancesDo:[:i |
        |varClass|
        varClass := (i instVarAt:instIndex) class.
        setOfTypes add:varClass.
    ].  
    
    "/ look for assignments in code
    aClass withAllSubclassesDo:[:eachClass |
        eachClass methodDictionary do:[:m |
            |tree code visitor|

            "/ quick check
            SourceCodeManagerError handle:[:ex |
            ] do:[    
                code := m source.
            ].
            (code notNil and:[code includesString:varName]) ifTrue:[
                tree := Parser parse:code class:eachClass.
                (tree notNil and:[tree ~~ #Error]) ifTrue:[
                    visitor := PluggableParseNodeVisitor new. 
                    visitor 
                        actionForNodeClass:AssignmentNode 
                        put:[:node |
                            |val expr exprSelector|

                            node variable name = varName ifTrue:[
                                expr := node expression.
                                "/ only look for wellknown types on the right side.
                                expr isLiteral ifTrue:[
                                    val := expr evaluate.
                                    val isArray ifTrue:[
                                        setOfTypes add:Array 
                                    ] ifFalse:[
                                        setOfTypes add:val class
                                    ].
                                ] ifFalse:[
                                    expr isMessage ifTrue:[
                                        exprSelector := expr selector. 
                                        ( #(+ - * /) includes:exprSelector ) ifTrue:[
                                            setOfTypes add:Number
                                        ] ifFalse:[    
                                            ( #(// size) includes:exprSelector ) ifTrue:[
                                                setOfTypes add:Integer
                                            ] ifFalse:[    
                                                ( #(copy shallowCopy) includes:exprSelector ) ifTrue:[
                                                ] ifFalse:[    
                                                    ( #(new new: basicNew basicNew:) includes:exprSelector ) ifTrue:[
                                                        expr receiver isGlobal ifTrue:[
                                                            setOfTypes add:expr receiver evaluate
                                                        ].    
                                                    ] ifFalse:[    
self breakPoint:#cg.
                                                    ]
                                                ]
                                            ]
                                        ]
                                    ].    
                                ].    
                            ].
                            true "/ yes - visit subnodes
                        ].        
                    visitor visit:tree.
                ].    
            ]    
        ]
    ].
    ^ setOfTypes
!

addClassesOfMessage:expr inClass:classOrNil to:setOfTypes
    |valClass
     msgSelector msgReceiver msgArg1
     receiverClasses receiverClass 
     arg1Classes arg1Value mthd|
    
    msgSelector := expr selector.
         
    "/ heuristic: quickly assume boolean for some:
    (
        #( 
            isNil notNil isEmpty isEmptyOrNil notEmpty notEmptyOrNil
            > >= < <= = == ~ ~=
            knownAsSymbol
            isMeta 
            includes: contains:
            not and: or:
            exists atEnd positive negative odd even
        ) includes:msgSelector
    ) ifTrue:[
        setOfTypes add:True.  "/ use True, because Boolean does not include the full protocol
        ^ setOfTypes    
    ].

    msgReceiver := expr receiver.

    "/ some hardwired knowledge here
    receiverClasses := self classesOfNode:msgReceiver.
    receiverClass := receiverClasses size == 1 ifTrue:[receiverClasses anElement] ifFalse:[nil].

    receiverClass notNil ifTrue:[
        "/ follow Smalltalk at: to see what is there
        receiverClass == Smalltalk ifTrue:[
            msgSelector == #at: ifTrue:[
                msgArg1 := expr arg1.
                msgArg1 isLiteralSymbol ifTrue:[
                    arg1Value := Smalltalk at:msgArg1 value.
                    arg1Value notNil ifTrue:[
                        setOfTypes add:arg1Value class.
                        ^ setOfTypes.
                    ]
                ]    
            ].    
        ].    
        
        "/ usually return something of the receiver's type
        ( #(copy shallowCopy copyWith: , ) includes:msgSelector ) ifTrue:[
            setOfTypes addAll:receiverClasses.
            ^ setOfTypes.
        ].

        ( msgSelector == #class ) ifTrue:[  
            setOfTypes add:(receiverClass class).
            ^ setOfTypes            
        ].

        receiverClass isBehavior ifTrue:[                        
            ( #(compiledMethodAt:) includes:msgSelector) ifTrue:[
                setOfTypes add:Method.
                ^ setOfTypes            
            ].            
            ( #(superclass) includes:msgSelector) ifTrue:[
                receiverClass isMeta ifTrue:[
                    setOfTypes add:Metaclass.
                ] ifFalse:[    
                    setOfTypes add:Class.
                ].    
                ^ setOfTypes            
            ].            
            ( #(theNonMetaclass theMetaclass) includes:msgSelector) ifTrue:[
                receiverClass isMeta ifTrue:[
                    setOfTypes add:Metaclass.
                    ^ setOfTypes            
                ].
                setOfTypes add:(receiverClass perform:msgSelector) class.
                ^ setOfTypes            
            ].
            
            mthd := receiverClass lookupMethodFor:msgSelector.
            receiverClass isMeta ifTrue:[
                ( #( #'new' #'basicNew' #'new:' #'basicNew:' #'with:' #'with:with:') includes: msgSelector ) ifTrue:[
                    setOfTypes add:receiverClass theNonMetaclass.
                    ^ setOfTypes.
                ].
                "/ if that method sends one of new/basicNew/new:/basicNew:, assume it returns an instance of itself
                mthd notNil ifTrue:[
                    ( mthd sendsAny:#( #'new' #'basicNew' #'new:' #'basicNew:' )) ifTrue:[
                        setOfTypes add:receiverClass theNonMetaclass.
                        ^ setOfTypes
                    ].
                ].
            ] ifFalse:[
                mthd notNil ifTrue:[
                    (ParseTreeSearcher methodIsSetterMethod:mthd) ifTrue:[
                        setOfTypes add:receiverClass.
                        ^ setOfTypes
                    ]
                ]
            ]
        ].
    ].

    ((msgSelector startsWith:'as')
    and:[ (valClass := Smalltalk classNamed:(msgSelector copyFrom:3)) notNil ]
    ) ifTrue:[
        setOfTypes add:valClass.
        ^ setOfTypes
    ].    

    ((msgSelector startsWith:'is')
    and:[ (valClass := Smalltalk classNamed:(msgSelector copyFrom:3)) notNil ]
    ) ifTrue:[
        setOfTypes add:True. "/ True - not boolean; it does not contain the full protocol (would not find ifTrue:)
        ^ setOfTypes.
    ].    

    #(
        size                    SmallInteger
        hash                    SmallInteger
        identityHash            SmallInteger
        class                   Class
        theMetaclass            Metaclass
        theNonMetaclass         Class
        fork                    Process
        newProcess              Process
    ) pairWiseDo:[:sel :clsName |
        msgSelector == sel ifTrue:[ 
            setOfTypes add:(Smalltalk at:clsName).
            ^ setOfTypes.
        ].
    ].

    ( #( bitAnd: bitOr: bitShift: rightShift: >> << highBit lowBit ) includes:msgSelector) ifTrue:[
        "/ assume integer

        setOfTypes add:Integer.
        ^ setOfTypes
    ].
    ( #( + - * // \\ ) includes:msgSelector) ifTrue:[
        "/ assume numeric

        setOfTypes add:Number.
        ^ setOfTypes
    ].
    msgSelector == #/ ifTrue:[
        ((receiverClasses ? #()) contains:[:cls | cls includesBehavior:Number]) ifTrue:[
            setOfTypes add:Number.
            ^ setOfTypes.
        ].
        msgArg1 := expr arguments at:1 ifAbsent:nil.
        msgArg1 isNil ifTrue:[^ setOfTypes].
        arg1Classes := ((self classesOfNode:msgArg1) ? #()).
        (arg1Classes contains:[:cls | cls includesBehavior:Number]) ifTrue:[
            setOfTypes add:Number.
            ^ setOfTypes
        ].    
    ].    
    ( #( construct: / ) includes:msgSelector) ifTrue:[
        ((receiverClasses ? #()) contains:[:cls | cls includesBehavior:Filename]) ifTrue:[
            setOfTypes add:Filename.
            ^ setOfTypes
        ].
    ].
    
    ^ setOfTypes
!

classOfNode:aNode
    "returns the class of a receiver, if it is well-known.
     Otherwise nil (either unknown, or multiple possibilities)
     When showing possible completions for a message,
     it is a good idea to know what the kind receiver is."

    | classes |

    classes := self classesOfNode:aNode.
    classes size == 1 ifTrue:[
        ^ classes anElement
    ].
    self breakPoint:#cg.
    ^ nil
!

classesFromAssignmentTo:varName in:aTree
    ^ self addClassesFromAssignmentTo:varName in:aTree to:IdentitySet new
!

classesOfInstVarNamed:varName inClass:aClass
    ^ self addClassesOfInstVarNamed:varName inClass:aClass to:(IdentitySet new)
!

classesOfNode:aNode
    "returns the set of possible classes of a parsenode.
     or nil if unknown.
     When showing possible completions for a message,
     it is a good idea to know what the kind receiver is."

    ^ self addClassesOfExpression:aNode inClass:classOrNil to:(IdentitySet new).
!

isNonDestructive:aMessageNode whenSentTo:receiverValue
    "return true, if it is safe to send aSelector to receiverValue
     (i.e. has no side effects)"

    |selector method impl arg1Value|

    selector := aMessageNode selector.
    
    impl := receiverValue class whichClassIncludesSelector:selector.

    ( #( 
        basicSize basicAt:
        class theMetaclass theNonMetaclass ) includes:selector
    ) ifTrue:[
        ^ true.
    ].    
    
    selector == #size ifTrue:[
        "/ mhm - be conservative; someone might have redefined #size
        "/ more hardwired stuff.
        ((impl == Object) or:[(impl == String) or:[impl isSubclassOf:Collection]]) ifTrue:[
            ^ true.
        ].
    ].
    selector == #at: ifTrue:[
        "/ mhm - be conservative; someone might have redefined #at: and do something there
        "/ more hardwired stuff.
        arg1Value := self valueOfNode:(aMessageNode arg1).
        arg1Value notNil ifTrue:[            
            receiverValue == Smalltalk ifTrue:[
                ^ arg1Value isSymbol
            ].    
        
            ((impl == Object) or:[(impl == String) or:[(impl isSubclassOf:Collection)]]) ifTrue:[
                ^ true.
            ].
        ].
    ].

    selector argumentCount == 0 ifTrue:[
        "/ follow non-destructive accessors
        method := receiverValue class lookupMethodFor:selector.
        method notNil ifTrue:[
            (ParseTreeSearcher methodIsJustReturningSomething:method) ifTrue:[
                "/ we can savely call that method to get the current value
                ^ true.
            ].
        ].
    ].
    
    ^ false
!

valueAndKindOfVariable:aVariableName
    "when showing possible completions for a variable,
     it is a good idea to know what the reveiver's value is.
     Sigh - returns nil as value both if unknown AND if a real nil is there"

    |nodeVal con classInstVarClass classVarClass privateClass pool sym nameSpace topNameSpace|

    aVariableName isUppercaseFirst ifTrue:[
        classOrNil notNil ifTrue:[
            classOrNil isMeta ifTrue:[
                "/ class instVars
                (classInstVarClass := classOrNil whichClassDefinesInstVar:aVariableName) notNil ifTrue:[
                    nodeVal := classInstVarClass theNonMetaclass instVarNamed:aVariableName.
                    ^ { nodeVal . #classInstVariable }
                ].    
            ].
            "/ class vars
            (classVarClass := classOrNil theNonMetaclass whichClassDefinesClassVar:aVariableName) notNil ifTrue:[
                nodeVal := classVarClass classVarAt:aVariableName asSymbol.
                ^ { nodeVal . #classVariable }
            ].    

            privateClass := classOrNil theNonMetaclass privateClasses detect:[:cls | cls nameWithoutPrefix = aVariableName] ifNone:nil.
            privateClass notNil ifTrue:[
                nodeVal := privateClass.
                ^ { nodeVal . #privateClass }
            ].
            pool := classOrNil theNonMetaclass whichPoolDefinesPoolVar:aVariableName.
            pool notNil ifTrue:[
                nodeVal := pool classVarAt:aVariableName.
                ^ { nodeVal . #poolVariable }
            ].
            (sym := aVariableName asSymbolIfInterned) notNil ifTrue:[
                ((nameSpace := classOrNil nameSpace) notNil and:[nameSpace ~~ Smalltalk]) ifTrue:[
                    nameSpace isNameSpace ifTrue:[
                        nodeVal := nameSpace at:sym.
                        (nodeVal notNil or:[nameSpace includesKey:sym]) ifTrue:[     
                            ^ { nodeVal . #nameSpaceVariable }
                        ].
                    ].
                    nodeVal := nameSpace privateClassNamed:sym.
                    (nodeVal notNil) ifTrue:[     
                        ^ { nodeVal . #privateClass }
                    ].    
                ].    
                ((topNameSpace := classOrNil topNameSpace) notNil 
                and:[topNameSpace ~~ nameSpace
                and:[topNameSpace ~~ Smalltalk]]) ifTrue:[
                    nodeVal := topNameSpace at:sym.
                    (nodeVal notNil or:[topNameSpace includesKey:sym]) ifTrue:[     
                        ^ { nodeVal . #nameSpaceVariable }
                    ].    
                ].    
            ].
        ].
        (sym := aVariableName asSymbolIfInterned) notNil ifTrue:[
            nodeVal := Smalltalk at:sym.
            (nodeVal notNil or:[Smalltalk includesKey:sym]) ifTrue:[     
                ^ { nodeVal . #global }
            ]
        ].

        "/ 'evaluate' the variable (like in a browser's codeView)
        "/ mhmh - will we catch workspace vars then?
        Error ignoreIn:[
            nodeVal := Parser new evaluate:aVariableName in:classOrNil receiver:classOrNil.
        ].
        nodeVal notNil ifTrue:[
            ^ { nodeVal . #global }
        ].
        ^ nil
    ].

    aVariableName = 'self' ifTrue:[
        contextOrNil notNil ifTrue:[
            ^ { contextOrNil receiver . #pseudoVar } 
        ].
        (classOrNil notNil and:[classOrNil isMeta]) ifTrue:[
            "/ ^ { classOrNil . #pseudoVar }
            ^ { classOrNil theNonMetaclass . #pseudoVar }
        ].
        ^ nil
    ].

    contextOrNil notNil ifTrue:[
        "/ in the debugger, we know more
        con := contextOrNil.
        [ con notNil ] whileTrue:[
            "/ a local in the context?
            ((con argAndVarNames ? #()) includes:aVariableName) ifTrue:[
                nodeVal := con argsAndVars at:(con argAndVarNames indexOf:aVariableName) ifAbsent:nil.
                nodeVal notNil ifTrue:[
                    ^ { nodeVal . #argument }
                ].
            ].
            con := con home.
        ].
        "/ an instvar?
        (contextOrNil receiver class allInstVarNames includes:aVariableName) ifTrue:[
            contextOrNil receiver isProtoObject ifFalse:[
                nodeVal := contextOrNil receiver instVarNamed:aVariableName.
            ].
            nodeVal notNil ifTrue:[
                ^ { nodeVal . #instanceVariable }
            ].
        ].
    ].
    ^ nil

    "Created: / 01-05-2016 / 12:40:05 / cg"
!

valueOfNode:aNode
    "when showing possible completions for a message,
     it is a good idea to know what the reveiver's value is.
     Sigh - returns nil both if unknown AND if a real nil is there."

    |nodeSelector nodeReceiver receiverValue arg1Value|

    aNode isLiteral ifTrue:[
        ^ aNode value
    ].
    aNode isVariable ifTrue:[
        ^ self valueOfVariable:aNode name.
    ].

    aNode isMessage ifTrue:[
        nodeSelector := aNode selector.
        nodeReceiver := aNode receiver.
                
        "/ some hardwired knowledge here
        classOrNil notNil ifTrue:[
            (nodeReceiver isSelf and:[nodeSelector = #'class']) ifTrue:[
                ^ classOrNil
            ].
        ].

        receiverValue := self valueOfNode:nodeReceiver.
        receiverValue notNil ifTrue:[
            (self isNonDestructive:aNode whenSentTo:receiverValue) ifTrue:[
                [
                     nodeSelector argumentCount == 1 ifTrue:[
                        arg1Value := self valueOfNode:(aNode arg1).
                        ^ receiverValue perform: nodeSelector with: arg1Value.
                    ].    
                    ^ receiverValue perform: nodeSelector.
                ] on:Error do:[
                    ^ nil
                ]    
            ].
        ].
    ].

    ^ nil

    "Created: / 28-08-2013 / 16:34:53 / cg"
!

valueOfVariable:aVariableName
    "when showing possible completions for a variable,
     it is a good idea to know what the reveiver's value is.
     Sigh - returns nil both if unknown AND if a real nil is there."

    |valueAndKind|

    (valueAndKind := self valueAndKindOfVariable:aVariableName) notNil ifTrue:[
        self assert:valueAndKind isArray.
        ^ valueAndKind first.
    ].
    ^ nil

    "Modified: / 26-08-2016 / 14:16:16 / cg"
! !

!DoWhatIMeanSupport::InputCompletionResult class methodsFor:'instance creation'!

bestName:bestNameArg matchingNames:matchingNamesArg
    ^ self with:bestNameArg with:matchingNamesArg

    "
     self bestName:123 matchingNames:345
    "
! !

!DoWhatIMeanSupport::InputCompletionResult methodsFor:'accessing'!

bestName
    ^ self at:1
!

matchingNames
    ^ self at:2
! !

!DoWhatIMeanSupport class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

