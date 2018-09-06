"
 COPYRIGHT (c) 2013 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

EditTextViewCompletionSupport subclass:#WorkspaceCompletionSupport
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!WorkspaceCompletionSupport class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by eXept Software AG
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
    A completion support using DWIM to complete code for Smalltalk (and JavaScript)

    [author:]
        Claus Gittinger

    [instance variables:]

    [class variables:]

    [see also:]
        DoWhatIMeanSupport

"
! !

!WorkspaceCompletionSupport methodsFor:'private'!

computeCompletions

    |topView suggestions implementations actions contextOrNil|

    "/ a hack - we get better completions, if we know the current context
    topView := editView topView.
    (topView notNil and:[topView isDebugView]) ifTrue:[
        contextOrNil := topView selectedContext.
    ].

    UserInformation ignoreIn:[
        DoWhatIMeanSupport 
            codeCompletionFor: editView codeAspect
            language: editView editedLanguage
            method:editView editedMethod
            orClass:editView editedClass 
            context:contextOrNil 
            codeView:editView 
            into:[:listOfSuggestions :listOfActions :titleWhenAsking |
"/ (listOfSuggestions contains:[:l | l isEmptyOrNil]) ifTrue:[self halt].
                    suggestions := listOfSuggestions collect:[:entry | entry isArray ifTrue:[entry first] ifFalse:[entry]].
                    implementations := listOfSuggestions collect:[:entry | entry isArray ifTrue:[entry second] ifFalse:[nil]].                            
                    actions := listOfActions.
                    nil "/ must return nil to avoid DWIM to do it itself (for now)
            ]
    ].
    "/ Transcript show:'suggestions: '; showCR:suggestions.
    "/ Transcript show:'actions: '; showCR:actions. 
    editView sensor
        pushUserEvent:#'suggestionsArrived:implementations:actions:autoSelect:'
        for:self
        withArguments:{suggestions . implementations . actions . autoSelect }

    "Created: / 26-09-2013 / 17:44:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

suggestionsArrived:suggestionsArg implementations:implementationsArg actions:actionsArg autoSelect:autoSelectArg
    "the background process has generated some suggestions"

    |v numShown numFirst numLast numSkipped
     suggestions implementations actions suggestionOffset keyAndSnippet indexOfSnippet|

    (editView sensor hasKeyPressEventFor:nil) ifTrue:[ 
        self closeCompletionView. 
        ^ self
    ].

    implementations := implementationsArg.
    actions := actionsArg.

    suggestions := suggestionsArg ? #().
    numShown := 25.
    suggestions size > numShown ifTrue:[
        numFirst := numShown-5.    
        numLast := 5.
        numSkipped := suggestions size-numShown.    
        suggestions := (suggestions copyTo:numShown-5) 
                        , { ('<< %1 more skipped >>' bindWith:numSkipped) withColor:Color grey }  
                        , (suggestions copyLast:5).
        implementations isArray ifTrue:[ 
            implementations := (implementations copyTo:numShown-5),#(nil),(implementations copyLast:5).
        ].
        actions isArray ifTrue:[ 
            actions := (actions copyTo:numShown-5),#(nil),(actions copyLast:5).
        ].
    ].

    "/ append snipplet, if any (can be easily reached via CRSR-up)
    suggestionOffset := 0.
    indexOfSnippet := nil.
    UserPreferences current appendAbbreviationsToCompletionSuggestions ifTrue:[
        (keyAndSnippet := editView findAbbreviationKeyBeforeCursor) notNil ifTrue:[
            |abbrev sniplet i line|

            abbrev := keyAndSnippet first.
            sniplet := keyAndSnippet second.

            "/ if the abbreviation is simply at the end of a longer word, ignore the abbrev.
            line := editView lineStringBeforeCursor.
            i := line findLast:[:ch | ch isLetterOrDigit not].
            (i < (line size - abbrev size - 1)) ifFalse:[
                sniplet := sniplet copyWithout:$!!.

                "/ true, false and self are often found in both lists
                (suggestions includes:sniplet) ifFalse:[   
                    suggestions isEmpty ifFalse:[ suggestions := suggestions copyWith: '-' ]. 
                    suggestions := suggestions copyWith: ( '%1 %2'
                                            bindWith:(sniplet asStringCollection first "contractTo:25")
                                            with: ( ('("',abbrev,'" snippet)') withColor:Color gray)).
                    indexOfSnippet := suggestions size.

                    "/ change below, when reversing the order in above code
                    "/ suggestionOffset := 2.
                ]
            ]
        ].
    ].

    suggestions isEmptyOrNil ifTrue:[
        self closeCompletionView.
        ^ self
    ].
    (v := completionView) isNil ifTrue: [
        ^ self
    ].

    v sensor
        pushUserEvent:#value
        for:[
            |top idx preselectIdx performCompletion|

            (v == completionView) ifTrue: [
                top := v topView.
                autoSelectArg ifTrue:[
                    LastCompletions notNil ifTrue:[
                        "/ one of the last completions in list?
                        idx := LastCompletions findFirst:[:compl | suggestions includes:compl].
                        idx ~~ 0 ifTrue:[
                            preselectIdx := suggestions indexOf:(LastCompletions at:idx).
                        ].
                    ].
                    (preselectIdx isNil and:[suggestions size == 1]) ifTrue:[
                        preselectIdx := 1.
                    ].
                ].
                preselectIdx notNil ifTrue:[
                    |pref|

                    pref := suggestions at:preselectIdx.
                    pref notNil ifTrue:[
                        "/ for now, do not move to front (action needs the index)
                        suggestions at:preselectIdx put:(pref allBold).
"/                    suggestions removeAtIndex:preselectIdx.                    
"/                    suggestions addFirst:(pref allBold).
"/                    implementations notNil ifTrue:[
"/                        implementations removeAtIndex:preselectIdx.
"/                        implementations addFirst:implementations.
"/                    ]
                    ].
                ].

                performCompletion :=
                    [:selectedListIndex | 
                        |indexInSuggestions|

                        self closeCompletionView.
                        indexInSuggestions := selectedListIndex - suggestionOffset.
                        (selectedListIndex == indexOfSnippet) ifTrue:[
                            "/ replace the sniplet
                            editView sensor pushUserEvent:#expandAbbreviation for:editView
                        ] ifFalse:[
                            LastCompletions isNil ifTrue:[
                                LastCompletions := OrderedCollection new.
                            ].
                            LastCompletions add:(suggestions at:indexInSuggestions).
                            LastCompletions size > 200 ifTrue:[
                                LastCompletions removeLast
                            ].
                            
                            actions notNil ifTrue:[
                                actions isBlock ifTrue:[
                                    (numFirst notNil and:[indexInSuggestions > numFirst]) ifTrue:[
                                        indexInSuggestions := indexInSuggestions + numSkipped - 1.
                                    ].    
                                    actions value:indexInSuggestions
                                ] ifFalse:[
                                    (actions at:indexInSuggestions) valueWithOptionalArgument:indexInSuggestions
                                ].
                            ].
                        ].
                        "/ disabled - user has made his choice; so don't show more suggestions
                        "/ editView sensor pushUserEvent:#updateCompletionList for:self
                    ].

                (autoSelectArg 
                    and:[ (suggestions size == 1) 
                    and:[ preselectIdx == 1
                    and:[ preselectIdx ~~ indexOfSnippet ]]]) ifTrue:[
                    "/ do it, right here and now
                    performCompletion value:preselectIdx.
                ] ifFalse:[
                    top open.
                    v list:suggestions 
                            expandTabs:false scanForNonStrings:false
                            includesNonStrings:false redraw:true.

                    implementations notNil ifTrue:[
                        implementations keysAndValuesDo:[:idx :impls |
                            |implsMenu|

                            impls notEmptyOrNil ifTrue:[
                                implsMenu := Menu new.
                                impls do:[:each |
                                    implsMenu addItem:(MenuItem new label:each name).
                                ].
                                v subMenuAt:idx put:implsMenu
                            ].
                        ].
                    ].

                    v enable:true.
                    preselectIdx notNil ifTrue:[
                        "/ very disturbing!!
                        v selection:preselectIdx.
                    ].
                    v extent:completionView preferredExtentForContents.
                    v action:performCompletion.

                    (top ~~ v) ifTrue:[
                        top resizeToFit.
                        top bottom > v device usableHeight ifTrue:[
                            top origin:((top origin x) @ (v device usableHeight - v height)).
                        ].
                        top raise.
                    ]
                ]
            ]
        ]
! !

!WorkspaceCompletionSupport class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

