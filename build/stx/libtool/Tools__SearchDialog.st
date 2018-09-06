"
 COPYRIGHT (c) 2000 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

DialogBox subclass:#SearchDialog
	instanceVariableNames:'openHow classes methods selectedClasses selectedCategories
		selectedMethods selectedPackages currentClass currentNamespace
		currentClassCategory currentPackage browser whereRadioGroup
		currentPanel searchAreas caseHolder matchHolder isMethodHolder
		codeField selectorHolder defaultOpenHow withTextEntry allowFind
		allowBuffer allowBrowser searchWhat searchClassProtocolHolder
		searchInstanceProtocolHolder selectorOrCode selectionList
		listHolder matchProcess inputField showMetaFilter
		metaclassesOnlyHolder classesOnlyHolder initialText
		withSearchStringInLiterals searchStringInLiteralsHolder
		searchFreeStandingWordsOnlyHolder withSearchFreeStandingWordsOnly
		ignoreDocumentationMethodsHolder'
	classVariableNames:'LastCodeSearched LastCodeSearchWasMethod LastGlobalSearched
		LastStringSearched LastSearchWasMatch LastSearchWasCaseSensitive
		LastStringSearchArea LastCodeSearchArea AREA_LISTOFMETHODS
		LastResourceSearched'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!SearchDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SearchDialog class methodsFor:'initialization'!

initialize
    AREA_LISTOFMETHODS := #listOfMethods

    "Created: / 19-11-2010 / 12:00:18 / cg"
! !

!SearchDialog class methodsFor:'constants'!

constantForListOfMethodsArea
    ^ AREA_LISTOFMETHODS

    "Created: / 19-11-2010 / 12:11:50 / cg"
! !

!SearchDialog class methodsFor:'help'!

helpSpec
    ^ Dictionary new addPairsFrom:#(
#listOfChangedClasses
'Search only in changed classes'

#listOfChangedMethods
'Search only in changed methods'

#currentClassesNameSpace
'Search in the namespace(s) of the selected class(es)'

#currentClassesPackage
'Search in the package(s) of the selected class(es)'

#currentNameSpace
'Search in the current selected or selected classes namespace'

#currentPackage
'Search in the current selected or selected classes package'

#currentClassesPackage
'Search in the current selected classes package'

#currentPackageAndSubPackages
'Search in the current (selected) package and subpackages.\(disabled if there are no subpackages)'

#everywhere
'Search everywhere (all loaded classes)'

#listOfMethods
'Search only in the list of (shown) methods'

#ownersWithPrivateClasses
'Search in class and the owning and private classes.\(disabled if there are none)'

#ownersHierarchiesWithPrivateClasses
'Search in class, owners, private classes and all subclasses.\(disabled if there are none)'

#classes
'Search in selected class(es) only'

#classesWithPrivateClasses
'Search in selected class(es) and any private classes.\(disabled if there are no private classes)'

#classHierarchies
'Search in selected class(es) and down all subclasses.\(disabled if there are no subclasses)'

#classHierarchiesWithPrivateClasses
'Search in selected class(es), down all subclasses and all of their private classes.\(disabled if there are none)'

#classesAndSuperclasses
'Search in selected class(es) and up all super classes.\(disabled if there are none)'

#classCategories
'Search in selected class category(s)'

#listOfSelectedMethodClasses
'Search in class(es) of selected method(s)'

#listOfSelectedMethodPackages
'Search in package(es) of selected method(s)'

#listOfSelectedMethods
'Search in selected method(s)'

#selectedPackages
'Search in selected package(s)'

#searchPatternField
'The searched string or name. Does completion on TAB-key'

#codeEntryField
'Code fragment to match against in the search.\Press "pattern-help" to learn more about code searches'

#nonMetaClassesOnly
'Search only in instance methods (non-meta classes)'

#metaClassesOnly
'Search only in class methods (meta classes)'

#searchStringInLiterals
'Search string in literal constants; not in source code'

#searchFreeStandingWordsOnly
'Search for free-standing words only (i.e. not substrings)'

#match
'Perform a pattern match search, as opposed to an exact string search.\Pattern is a simple GLOB pattern (as in filenames)'

#caseSensitive
'Perform a case sensitive search (default is to ignore case differences)'
)
! !

!SearchDialog class methodsFor:'queries'!

lastCodeSearchArea
    ^ LastCodeSearchArea
!

lastStringSearchArea
    ^ LastStringSearchArea
!

lastStringSearchArea:aSymbol
    LastStringSearchArea := aSymbol
! !

!SearchDialog methodsFor:'accessing'!

currentClass:aClass
    currentClass := aClass   
!

currentPackage
    ^ currentPackage
!

currentPackage:aPackage
    currentPackage := aPackage   
!

initialText:aString
    initialText := aString.
!

showMetaFilter:aBoolean
    "enable another checkbox, to allow searching in meta/non-meta"

    showMetaFilter := aBoolean.
!

withSearchFreeStandingWordsOnly:aBoolean
    "enable another checkbox, to allow searching for full words only"
     
    withSearchFreeStandingWordsOnly := aBoolean.
!

withSearchStringInLiterals:aBoolean
    "enable another checkbox, to allow searching for a string
     in the literals only"
     
    withSearchStringInLiterals := aBoolean.
! !

!SearchDialog methodsFor:'accessing-entered values'!

classesOnly
    "the value of the corresponding check toggle;
     if on, only search in non-metaclasses"

    ^ (classesOnlyHolder ? false) value

    "Created: / 20-08-2012 / 13:25:26 / cg"
!

classesToSearch
    ^ classes.
!

codeToSearch
    ^ selectorOrCode.
!

ignoreDocumentationMethods
    "the value of the corresponding check toggle;
     if on, only search in metaclasses"

    ^ (ignoreDocumentationMethodsHolder ? false) value
!

matchMethods
    ^ isMethodHolder value ? false.
!

metaclassesOnly
    "the value of the corresponding check toggle;
     if on, only search in metaclasses"

    ^ (metaclassesOnlyHolder ? false) value

    "Created: / 20-08-2012 / 13:17:12 / cg"
!

methodsToSearch
    ^ methods.
!

openHow
    "the value of the corresponding button pressed to close the dialog;
     a symbol describing what to do (newBrowser/newBuffer/find)"

    ^ openHow.
!

searchAreaSelected
    "the value of the corresponding radio button;
     a symbol describing where to search"

    ^ whereRadioGroup value.
!

searchFreeStandingWordsOnly
    "the value of the corresponding check toggle;
     if on, only free standing words match - i.e. the searched word
     may not be part of a longer word"
     
    ^ searchFreeStandingWordsOnlyHolder value ? false.
!

searchIgnoringCase
    ^ self searchIsCaseSensitive not
!

searchIsCaseSensitive
    "the value of the corresponding check toggle;
     if on, search is case sensitive; otherwise ignore case"

    ^ (caseHolder value ? false)
!

searchStringInLiterals
    "the value of the corresponding check toggle;
     if on, only literal strings should be searched;
     otherwise, the sourcecode is searched"
     
    ^ searchStringInLiteralsHolder value ? false.
!

searchWithMatch
    "the value of the corresponding check toggle;
     if on, do a GLOB match; otherwise an exact search"

    ^ matchHolder value ? false.
!

selectorToSearch
    ^ selectorOrCode.
! !

!SearchDialog methodsFor:'help'!

flyByHelpTextFor:aComponent
    |symbolicHelpKey text|

    (symbolicHelpKey := aComponent helpKey) notNil ifTrue:[
        text := self class helpSpec at:symbolicHelpKey ifAbsent:[ nil ].
        text notNil ifTrue:[
            ^ NewSystemBrowser classResources stringWithCRs:text.
        ].    
    ].
    ^ nil
! !

!SearchDialog methodsFor:'obsolete'!

addCheckBoxForClassMethodSearch
    |b|

    b := CheckBox label:(resources string:'Class Protocol').
    b model:(self searchClassProtocolHolder).
    currentPanel add:b.
    ^ b.
!

addCheckBoxForInstanceMethodSearch
    |b|

    b := CheckBox label:(resources string:'Instance Protocol').
    b model:(self searchInstanceProtocolHolder).
    currentPanel add:b.
    ^ b.
! !

!SearchDialog methodsFor:'private'!

searchClassProtocolHolder
    searchClassProtocolHolder isNil ifTrue:[
        searchClassProtocolHolder := true asValue
    ].
    ^ searchClassProtocolHolder
!

searchInstanceProtocolHolder
    searchInstanceProtocolHolder isNil ifTrue:[
        searchInstanceProtocolHolder := true asValue
    ].
    ^ searchInstanceProtocolHolder
!

showHelpOnCodePatterns
    HTMLDocumentView openFullOnHelpFile:'Browser/RBSearchPatterns.html'
!

updateListOfMatchingSelectorsFor:s
    |p|

    (p := matchProcess) notNil ifTrue:[
        p terminate.
    ].
    listHolder isNil ifTrue:[^ self].

    matchProcess := 
        [
            |what matching|

            [
                searchWhat == #globalName ifFalse:[ 
                    what := DoWhatIMeanSupport selectorCompletion:s inEnvironment:Smalltalk match:(matchHolder value) ignoreCase:(caseHolder value not)
                ] ifTrue:[ 
                    what := DoWhatIMeanSupport globalNameCompletion:s inEnvironment:Smalltalk match:(matchHolder value).
                ].
                "/ best := what first.
                matching := what second.
                self sensor pushAction:[ listHolder contents:matching ].
            ] ensure:[
                matchProcess := nil.
            ].
        ] fork.

    "Modified: / 26-10-2010 / 20:33:05 / cg"
! !

!SearchDialog methodsFor:'public'!

addTextEntryWithCaseIgnore:withCaseIgnore withMatch:withMatch
    |initialMatch initialCaseSensitive|

    matchHolder := caseHolder := nil.

    searchWhat == #code ifTrue:[
        self addTextEntryFieldForCode.
        ^ self.
    ].

    self addInputFieldForSelectorOrNameOrString.
    withCaseIgnore ifTrue:[
        initialCaseSensitive := false.
        (searchWhat ~~ #resource) ifTrue:[ 
            initialCaseSensitive := (LastSearchWasCaseSensitive ? false) 
        ].  
        (self 
            addCheckBox:(resources string:'Case Sensitive')
            on:(caseHolder := initialCaseSensitive asValue))
            helpKey:#caseSensitive.
    ].
    withMatch ifTrue:[
        initialMatch := true.
        (searchWhat ~~ #resource) ifTrue:[ 
            initialMatch := (LastSearchWasMatch ? true) 
        ].
        (self 
            addCheckBox:(resources string:'Match')
            on:(matchHolder := initialMatch asValue))
            helpKey:#match.
"/                (isSelector and:[ sel notNil. ]) ifTrue:[ 
"/                    sel includesMatchCharacters ifTrue:[ 
"/                        matchHolder value:false.
"/                    ].
"/                ].
    ]

    "Modified (format): / 06-07-2011 / 11:56:31 / cg"
!

askThenDo:aBlock 
    |where code sel matchHolderValue caseHolderValue|

    self beScreenDialog.                "raise it above all windows"
    self open.
    self accepted ifFalse:[ 
        ^ self.
    ].

    openHow isNil ifTrue:[ 
        openHow := defaultOpenHow.
    ].
    where := whereRadioGroup value.

    withTextEntry ifTrue:[ 
        searchWhat == #code ifTrue:[
            code := codeField contentsAsString.
            LastCodeSearched := code.
            LastCodeSearchArea := where.
        ] ifFalse:[
            (selectionList notNil and:[selectionList hasSelection]) ifTrue:[
                sel := selectionList selectionValue.
            ] ifFalse:[
                sel := selectorHolder value.
                searchWhat ~~ #string ifTrue:[
                    sel := sel withoutSeparators.
                ].
            ].
            sel isEmptyOrNil ifTrue:[ 
                browser warn:((searchWhat == #selector) 
                            ifTrue:[ 'No selector entered for search'. ]
                            ifFalse:[ 'Nothing entered for search'. ]).
                ^ self.
            ].
            sel := sel string.

            (browser ? SystemBrowser) rememberSearchPattern:sel.
            searchWhat == #globalName ifTrue:[ 
                LastGlobalSearched := sel.
            ] ifFalse:[
                searchWhat == #string ifTrue:[
                    LastStringSearched := sel.
                    LastStringSearchArea := where.
                ] ifFalse:[
                    (sel startsWith:'#''') ifTrue:[
                        sel := sel copyFrom:3.
                        (sel endsWith:$') ifTrue:[
                            sel := sel copyButLast.
                        ].
                    ].
                ]
            ]
        ].
    ] ifFalse:[
        sel := initialText
    ].
    
    where isNil ifTrue:[ 
        (browser ? Dialog) warn:'No class(es) for search'.
        ^ self.
    ].
    self getClassesAndMethodsFor:where.

    (#(#classesWithPrivateClasses #classHierarchiesWithPrivateClasses #ownersWithPrivateClasses #ownersHierarchiesWithPrivateClasses) 
        includes:where) 
            ifTrue:[ 
                |toSearch|

                toSearch := IdentitySet withAll:classes.
                classes := IdentitySet withAll:toSearch.
                [ toSearch notEmpty ] whileTrue:[
                    |cls|

                    cls := toSearch removeFirst.
                    classes addAll:cls allPrivateClasses.
                ].
            ].

    classes size == 0 ifTrue:[
        classes := nil.
        methods size == 0 ifTrue:[ 
            (browser ? Dialog) warn:'No class(es) given for search.'.
            ^ self.
        ].
    ] ifFalse:[
        classes := classes asOrderedCollection.
        methods size ~~ 0 ifTrue:[ 
            (browser ? Dialog) warn:'oops'.
            methods := nil.
        ].
    ].

    matchHolderValue := matchHolder value.
    matchHolderValue notNil ifTrue:[
        LastSearchWasMatch := matchHolderValue
    ].
    caseHolderValue := caseHolder value.
    caseHolderValue notNil ifTrue:[
        LastSearchWasCaseSensitive := caseHolderValue
    ].

    selectorOrCode := sel ? code.

    aBlock numArgs == 7 ifTrue:[
        "/ old style
        aBlock
            value:classes
            value:(sel ? code)
            value:(self searchIgnoringCase)
            value:openHow
            value:(matchHolderValue ? false)
            value:methods
            value:(isMethodHolder value ? false).
    ] ifFalse:[
        aBlock value.
    ]

    "Modified: / 26-09-2012 / 11:50:45 / cg"
!

setupToAskForMethodSearchTitle:title forBrowser:brwsrArg searchWhat:searchWhatArg 
    searchArea:whereDefault withCaseIgnore:withCaseIgnore withMatch:withMatch 
    withMethodList:withMethodList allowFind:allowFindArg allowBuffer:allowBufferArg 
    allowBrowser:allowBrowserArg withTextEntry:withTextEntryArg 

    "the real construction of the box is done here. 
     Any additional parameters (metaOnly, searchLiterals etc. must have been done
     already."
    
    "searchWhatArg:
        one of:#selector #string
     searchArea:
        one of: #everywhere #currentNameSpace
    "

    |where ns methodNameSpaces methodPackages hPanel 
     leftVerticalPanel rightVerticalPanel updateListAction|

    allowFind := allowFindArg.
    allowBuffer := allowBufferArg.
    allowBrowser := allowBrowserArg.
    searchWhat := searchWhatArg.

    withTextEntry := withTextEntryArg.
    resources := NewSystemBrowser classResources.

    (browser := brwsrArg) notNil ifTrue:[
        selectedClasses := browser selectedClasses value.
        selectedCategories := browser selectedCategoriesValue.
        selectedCategories := selectedCategories reject:[:cat | NavigatorModel isPseudoCategory:cat].
        selectedMethods := browser selectedMethods value.
        currentClass := browser theSingleSelectedClass.
        currentClassCategory := browser theSingleSelectedCategory.
        currentPackage := browser theSingleSelectedProject.
        currentClass isNil ifTrue:[
            browser hasMethodSelected ifTrue:[
                currentClass := selectedMethods first mclass.
                "/ selectedClasses := (selectedMethods collect:[:each | each mclass ]) asIdentitySet.
                "/ selectedClasses := selectedClasses select:[:each | each notNil ].
            ].
        ].
    ].

    (self addTextLabel:(resources stringWithCRs:title)) adjust:#left.

    currentClass notNil ifTrue:[
        currentClass := currentClass theNonMetaclass.
    ].
    withTextEntry ifTrue:[
        self addTextEntryWithCaseIgnore:withCaseIgnore withMatch:withMatch.
    ].

    (showMetaFilter ? false) ifTrue:[
        currentPanel := self.
        self addCheckBoxForMetaClassesOnly.
    ].
    (withSearchStringInLiterals ? false) ifTrue:[    
        currentPanel := self.
        self addCheckBoxForSearchInLiteralsOnly
    ].
    (withSearchFreeStandingWordsOnly ? false) ifTrue:[    
        currentPanel := self.
        self addCheckBoxForSearchFreeStandingWordsOnly
    ].
    (showMetaFilter ? false) ifTrue:[
        currentPanel := self.
        searchWhat == #string ifTrue:[
            self addCheckBoxForIgnoreDocumentationMethods
        ].
    ].
    
    self addHorizontalLine.

    hPanel := HorizontalPanelView "SimpleView" new.
    hPanel verticalLayout:#top.
    hPanel horizontalLayout:#left.

    leftVerticalPanel := currentPanel := VerticalPanelView new.
    leftVerticalPanel verticalLayout:#topSpace.
    leftVerticalPanel horizontalLayout:#fitSpace.

    (self addTextLabel:(resources string:'Search in:')) adjust:#left.

    searchAreas := OrderedCollection new.
    whereRadioGroup := RadioButtonGroup new.

    self addCheckBoxForEverywhere.
    (selectedCategories notEmptyOrNil or:[ selectedClasses notEmptyOrNil ]) ifTrue:[
        "/        classMethodListView notNil ifTrue:[
        "/            b := CheckBox label:(resources string:'Shown Methods').
        "/            panel add:b. whereChannel add:b value:#currentMethodList.
        "/            areas add:#currentMethodList.
        "/            self makeTabable:b.
        "/        ].
        browser isMethodListBrowser ifTrue:[
            methods := browser selectedMethods value ? #().
            methodNameSpaces := methods
                        select:[:eachMethod | eachMethod mclass notNil]
                        thenCollect:[:eachMethod | eachMethod mclass topNameSpace ].
            methodPackages := methods 
                        collect:[:eachMethod | eachMethod package ].
        ].
        methodNameSpaces size == 1 ifTrue:[
            currentNamespace := methodNameSpaces first.
        ] ifFalse:[
            currentNamespace := browser currentNamespace.
            selectedClasses isEmptyOrNil ifTrue:[
                |classesInAllSelectedCategories nameSpacesOfAllClassesInAllSelectedCategories|
                classesInAllSelectedCategories := Smalltalk allClasses select:[:cls | selectedCategories includes:cls category].
                nameSpacesOfAllClassesInAllSelectedCategories := classesInAllSelectedCategories collect:[:eachClass | eachClass topNameSpace].
                nameSpacesOfAllClassesInAllSelectedCategories size == 1 ifTrue:[
                    currentNamespace := nameSpacesOfAllClassesInAllSelectedCategories first.
                ].
            ].
        ].

        (currentNamespace notNil 
            and:[ currentNamespace ~= (browser nameListEntryForALL) ]) 
                ifTrue:[ self addCheckBoxForCurrentNamespace ]
                ifFalse:[
                    (currentClass notNil 
                        and:[ (ns := currentClass nameSpace) notNil and:[ ns ~~ Smalltalk ] ]) 
                            ifTrue:[ self addCheckBoxForClassesNamespace:ns ].
                ].

        methodPackages size == 1 ifTrue:[
            currentPackage := methodPackages first.
        ] ifFalse:[
            currentPackage := browser currentProject.
"/            selectedClasses size == 0 ifTrue:[
"/                |classesInAllSelectedCategories packagesOfAllClassesInAllSelectedCategories|
"/                classesInAllSelectedCategories := Smalltalk allClasses select:[:cls | selectedCategories includes:cls category].
"/                packagesOfAllClassesInAllSelectedCategories := classesInAllSelectedCategories collect:[:eachClass | eachClass package].
"/                packagesOfAllClassesInAllSelectedCategories size == 1 ifTrue:[
"/                    currentPackage := packagesOfAllClassesInAllSelectedCategories first.
"/                ].
"/            ].
        ].

        (currentPackage notNil 
            and:[ currentPackage ~= (browser nameListEntryForALL) ]) 
                ifTrue:[ 
                    self addCheckBoxForCurrentPackage.
                    self addCheckBoxForCurrentPackageAndSubPackages.
                ]
                ifFalse:[
                    (currentClass notNil) ifTrue:[ 
                        self addCheckBoxForClassesPackage:(currentClass package) 
                    ].
                ].

        selectedCategories notEmptyOrNil ifTrue:[
            self addCheckBoxForSelectedClassCategory.
        ].
        (selectedClasses notEmptyOrNil or:[ selectedMethods notEmptyOrNil ]) ifTrue:[
            self addCheckBoxForSelectedClass.
            self addCheckBoxForSelectedClassAndSuperclasses.
            self addCheckBoxForSelectedClassAndSubclasses.
            self addCheckBoxForSelectedClassAndPrivateClasses.
            self addCheckBoxForSelectedClassAndSubclassesAndPrivateClasses.
            self addCheckBoxForOwnerAndItsPrivateClasses.
            self addCheckBoxForOwnerAndItsSubclassesAndItsPrivateClasses.
        ].
    ] ifFalse:[
        (browser notNil and:[browser currentNamespace ~~ Smalltalk]) ifTrue:[
            self addCheckBoxForEverywhere.
            currentNamespace := browser currentNamespace.
            currentNamespace ~= (browser nameListEntryForALL) ifTrue:[
                self addCheckBoxForCurrentNamespace.
            ] ifFalse:[
                (currentClass notNil 
                and:[ (ns := currentClass nameSpace) notNil 
                and:[ ns ~~ Smalltalk ] ]) 
                ifTrue:[ 
                    self addCheckBoxForClassesNamespace:ns 
                ].
            ].
        ].
        (currentPackage notNil and:[ browser isNil or:[ currentPackage ~= (browser nameListEntryForALL) ]]) 
        ifTrue:[ 
            self addCheckBoxForCurrentPackage.
            self addCheckBoxForCurrentPackageAndSubPackages.
        ] ifFalse:[
            (currentClass notNil) ifTrue:[ 
                self addCheckBoxForClassesPackage:(currentClass package) 
            ].
        ].
        currentClass notNil ifTrue:[
            self addCheckBoxForSelectedClass
        ].    
    ].
    searchAreas isEmptyOrNil ifTrue:[
        self addCheckBoxForEverywhere.
    ].
    self addCheckBoxForChangedClassesList.

    withMethodList ifTrue:[
        browser isMethodListBrowser ifTrue:[
            searchAreas isEmptyOrNil ifTrue:[
                self addCheckBoxForEverywhere.
            ].
            self addCheckBoxForMethodList.
            self addCheckBoxForSelectedMethods.
            self addCheckBoxForSelectedMethodClasses.
            self addCheckBoxForSelectedMethodPackages.
        ] ifFalse:[
            searchAreas isEmptyOrNil ifTrue:[
                self addCheckBoxForEverywhere.
            ].
            self addCheckBoxForChangedMethodList.
        ].
    ].

    searchAreas isEmptyOrNil ifTrue:[
        whereRadioGroup := #everywhere asValue.
        self addDummyCheckBoxForEverywhere.
    ] ifFalse:[
        whereDefault notNil ifTrue:[
            (searchAreas includes:whereDefault) ifTrue:[
                where := whereDefault asSymbol.
            ] ifFalse:[
                where := searchAreas first.
            ].
        ] ifFalse:[
            where := #everywhere.
        ].
        whereRadioGroup value:where.
    ].

    hPanel add:leftVerticalPanel.

false ifTrue:[
    "/ noone liked the right panel...
    rightVerticalPanel := currentPanel := VerticalPanelView new.
    rightVerticalPanel verticalLayout:#topSpace.
    rightVerticalPanel horizontalLayout:#fitSpace.

    self addCheckBoxForClassMethodSearch.
    self addCheckBoxForInstanceMethodSearch.
"/    rightVerticalPanel origin:0.75@0.0 corner:1.0@1.0.
    hPanel 
        preferredExtent:(leftVerticalPanel preferredWidth + rightVerticalPanel preferredWidth)
                        @
                        (leftVerticalPanel preferredHeight max:rightVerticalPanel preferredHeight).
    hPanel add:rightVerticalPanel.
] ifFalse:[

"/    rightVerticalPanel origin:0.75@0.0 corner:1.0@1.0.
    hPanel 
        preferredExtent:(leftVerticalPanel preferredWidth) @ (leftVerticalPanel preferredHeight).
].

    self addComponent:hPanel indent:0.

    "/ panel has its own idea of indenting
    "/ self addVerticalSpace.
    searchWhat == #selector ifTrue:[
        "/ not yet implemented
        "/ self addHorizontalLine.
        "/ self addCheckBoxesForClassAndMetaSearch.
        updateListAction := [ self updateListOfMatchingSelectorsFor:inputField contents ].

        selectionList := self addFilteredListOfMatchingSelectors.
        self stickAtBottomWithVariableHeight:selectionList.
        matchHolder notNil ifTrue:[ matchHolder onChangeEvaluate:updateListAction ].
        caseHolder notNil ifTrue:[ caseHolder onChangeEvaluate:updateListAction ].
        inputField notNil ifTrue:updateListAction.
    ] ifFalse:[
        self addHorizontalLine.
    ].
    self addButtons.

    self label:(resources string:'Search').

    "Modified: / 20-08-2012 / 13:25:03 / cg"
! !

!SearchDialog methodsFor:'setup'!

addCheckBox:b forSearchArea:area 
    self addCheckBox:b forSearchArea:area helpKey:area
!

addCheckBox:b forSearchArea:area helpKey:symbolicHelpKey
    currentPanel add:b.
    whereRadioGroup add:b value:area.
    searchAreas add:area.
    self makeTabable:b.
    symbolicHelpKey notNil ifTrue:[ b helpKey:symbolicHelpKey ].
!

addCheckBoxForChangedClassesList
    |b|

    b := RadioButton "CheckBox" label:(resources string:'Changed Classes').
    
    self addCheckBox:b forSearchArea:#listOfChangedClasses.
    ChangeSet current changedClasses isEmpty ifTrue:[
        b disable
    ].
    ^ b.
!

addCheckBoxForChangedMethodList
    |b|

    b := RadioButton "CheckBox" label:(resources string:'Changed Methods').

    self addCheckBox:b forSearchArea:#listOfChangedMethods.
    ChangeSet current changeSelectors isEmpty ifTrue:[
        b disable
    ].
    ^ b.
!

addCheckBoxForClassesNamespace:ns 
    |b|

    b := RadioButton "CheckBox" label:(resources string:'Classes'' nameSpace ("%1")' with:ns name).
    self addCheckBox:b forSearchArea:#currentClassesNameSpace.
    ^ b.
!

addCheckBoxForClassesPackage:pkg 
    |b|

    b := RadioButton "CheckBox" label:(resources string:'Classes'' package ("%1")' with:pkg).
    self addCheckBox:b forSearchArea:#currentClassesPackage.
    ^ b.

    "Created: / 21-09-2006 / 17:39:55 / cg"
!

addCheckBoxForCurrentNamespace
    |b|

    b := RadioButton "CheckBox" label:(resources string:'Current nameSpace ("%1")' with:currentNamespace name).
    self addCheckBox:b forSearchArea:#currentNameSpace.
    ^ b.

    "Modified: / 10-10-2006 / 15:28:47 / cg"
!

addCheckBoxForCurrentPackage
    |b|

    b := RadioButton "CheckBox" label:(resources string:'Current Package ("%1")' with:currentPackage).
    self addCheckBox:b forSearchArea:#currentPackage.
    ^ b.

    "Modified: / 10-10-2006 / 15:28:51 / cg"
!

addCheckBoxForCurrentPackage:pkg 
    |b|

    b := RadioButton "CheckBox" label:(resources string:'Classes'' package ("%1")' with:pkg).
    self addCheckBox:b forSearchArea:#currentClassesPackage.
    ^ b.

    "Modified: / 10-10-2006 / 15:29:06 / cg"
!

addCheckBoxForCurrentPackageAndSubPackages
    |b any|

    b := RadioButton "CheckBox" label:(resources string:'Current Package ("%1") and Subpackages' with:currentPackage).
    self addCheckBox:b forSearchArea:#currentPackageAndSubPackages.
    any := Smalltalk allPackageIDs contains:[:p | p startsWith:currentPackage,'/'].
    any ifFalse:[
        b disable
    ].        
    ^ b.
!

addCheckBoxForEverywhere
    |b|

    b := RadioButton "CheckBox" label:(resources string:'Everywhere').
    self addCheckBox:b forSearchArea:#everywhere.
    ^ b.
!

addCheckBoxForIgnoreDocumentationMethods
    |p b|

    p := View new.
    
    b := CheckBox label:(resources string:'Ignore Documentation Methods') in:p.
    b model:(ignoreDocumentationMethodsHolder := false asValue).
    b helpKey:#ignoreDocumentationMethods.
    self makeTabable:b.

    currentPanel add:p.
    ^ nil.
!

addCheckBoxForMetaClassesOnly
    |p b|

    p := View new.
    
    b := CheckBox label:(resources string:'Metaclasses Only') in:p.
    b model:(metaclassesOnlyHolder := false asValue).
    b helpKey:#metaClassesOnly.
    metaclassesOnlyHolder onChangeEvaluate:[metaclassesOnlyHolder value ifTrue:[classesOnlyHolder value:false]].
    self makeTabable:b.

    b := CheckBox label:(resources string:'Classes Only') in:p.
    b left:0.5.
    b model:(classesOnlyHolder := false asValue).
    b helpKey:#nonMetaClassesOnly.
    classesOnlyHolder onChangeEvaluate:[classesOnlyHolder value ifTrue:[metaclassesOnlyHolder value:false]].
    self makeTabable:b.

    currentPanel add:p.
    ^ nil.

    "Created: / 20-08-2012 / 11:32:15 / cg"
!

addCheckBoxForMethodList
    |b|

    b := RadioButton "CheckBox" label:(resources string:'Methodlist').
    self addCheckBox:b forSearchArea:AREA_LISTOFMETHODS.
    ^ b.

    "Modified: / 19-11-2010 / 12:00:52 / cg"
!

addCheckBoxForOwnerAndItsPrivateClasses
    |b lbl arg|

    (currentClass notNil and:[ currentClass isPrivate. ]) ifTrue:[ 
        lbl := 'Owner (%1) & all its private classes'.
        arg := currentClass owningClass name.
    ] ifFalse:[ 
        lbl := 'Owners & all their private classes'.
    ].
    b := RadioButton "CheckBox" label:(resources string:lbl with:arg).
    self addCheckBox:b forSearchArea:#ownersWithPrivateClasses.
    (selectedClasses contains:[ :cls | cls isPrivate. ]) ifFalse:[ 
        b disable.
    ].
    ^ b.
!

addCheckBoxForOwnerAndItsSubclassesAndItsPrivateClasses
    |b lbl arg|

    (currentClass notNil and:[ currentClass isPrivate. ]) ifTrue:[ 
        lbl := 'Owner (%1) & its subclasses & all its private classes'.
        arg := currentClass owningClass name.
    ] ifFalse:[ 
        lbl := 'Owners & their subclasses & all their private classes'.
    ].
    b := RadioButton "CheckBox" label:(resources string:lbl with:arg).
    self addCheckBox:b forSearchArea:#ownersHierarchiesWithPrivateClasses.
    (selectedClasses contains:[ :cls | cls isPrivate. ]) ifFalse:[ 
        b disable.
    ].
    ^ b.
!

addCheckBoxForSearchFreeStandingWordsOnly
    |p b|

    p := View new.
    
    b := CheckBox label:(resources string:'Search Free Standing Words Only') in:p.
    b model:(searchFreeStandingWordsOnlyHolder := false asValue).
    p helpKey:#searchFreeStandingWordsOnly.
    self makeTabable:b.

    currentPanel add:p.
    ^ nil.
!

addCheckBoxForSearchInLiteralsOnly
    |p b|

    p := View new.
    
    b := CheckBox label:(resources string:'Search String-Constants (Literals) Only') in:p.
    b model:(searchStringInLiteralsHolder := false asValue).
    p helpKey:#searchStringInLiterals.
    self makeTabable:b.

    currentPanel add:p.
    ^ nil.
!

addCheckBoxForSelectedClass
    |b lbl arg|

    ((browser notNil and:[browser isMethodListBrowser])
    or:[ currentClass isNil
    or:[ selectedClasses size > 1]]) ifTrue:[ 
        selectedClasses size == 1 ifTrue:[ 
            lbl := 'Selected class ("%1")'.
            arg := selectedClasses first theNonMetaclass name.
        ] ifFalse:[ 
            lbl := 'Selected classes (%1)'.
            arg := selectedClasses size.
        ].
    ] ifFalse:[ 
        lbl := 'Class ("%1")'.
        arg := currentClass name.
    ].
    b := RadioButton "CheckBox" label:(resources string:lbl with:arg).
    self addCheckBox:b forSearchArea:#classes.
    ^ b.
!

addCheckBoxForSelectedClassAndPrivateClasses
    |b lbl|

    (browser isMethodListBrowser 
    or:[ currentClass isNil 
    or:[ selectedClasses size > 1] ]) ifTrue:[ 
        lbl := 'Selected classes & all private classes'.
    ] ifFalse:[ 
        lbl := 'Class & private classes'.
    ].
    b := RadioButton "CheckBox" label:(resources string:lbl).
    self addCheckBox:b forSearchArea:#classesWithPrivateClasses.
    (selectedClasses 
        contains:[ :cls | cls theNonMetaclass privateClasses size > 0. ]) 
            ifFalse:[ b disable. ].
    ^ b.
!

addCheckBoxForSelectedClassAndSubclasses
    |b lbl|

    (browser isMethodListBrowser 
    or:[ currentClass isNil
    or:[ selectedClasses size > 1] ]) ifTrue:[ 
        lbl := 'Selected classes & all subclasses'.
    ] ifFalse:[ 
        lbl := 'Class & subclasses'.
    ].
    b := RadioButton "CheckBox" label:(resources string:lbl).
    self addCheckBox:b forSearchArea:#classHierarchies.
    (selectedClasses 
        contains:[ :cls | cls theNonMetaclass subclasses size > 0. ]) 
            ifFalse:[ b disable. ].
    ^ b.
!

addCheckBoxForSelectedClassAndSubclassesAndPrivateClasses
    |b lbl|

    (browser isMethodListBrowser 
    or:[ currentClass isNil
    or:[ selectedClasses size > 1] ]) ifTrue:[ 
        lbl := 'Selected classes & all subclasses & all private classes'.
    ] ifFalse:[ 
        lbl := 'Class & subclasses & all private classes'.
    ].
    b := RadioButton "CheckBox" label:(resources string:lbl).
    self addCheckBox:b forSearchArea:#classHierarchiesWithPrivateClasses.
    (selectedClasses 
        contains:[ :cls | cls theNonMetaclass privateClasses size > 0. ]) 
            ifFalse:[ b disable. ].
    ^ b.
!

addCheckBoxForSelectedClassAndSuperclasses
    |b lbl|

    (browser isMethodListBrowser 
    or:[ currentClass isNil
    or:[ selectedClasses size > 1] ]) ifTrue:[ 
        lbl := 'Selected classes & all superclasses'.
    ] ifFalse:[ 
        lbl := 'Class & superclasses'.
    ].
    b := RadioButton "CheckBox" label:(resources string:lbl).
    self addCheckBox:b forSearchArea:#classesAndSuperclasses.
    (selectedClasses 
        contains:[ :cls | cls theNonMetaclass superclass notNil. ]) 
            ifFalse:[ b disable. ].
    ^ b.
!

addCheckBoxForSelectedClassCategory
    |b lbl arg|

    currentClassCategory notNil ifTrue:[ 
        lbl := 'Class category ("%1")'.
        arg := currentClassCategory.
    ] ifFalse:[ 
        lbl := 'Selected class categories (%1)'.
        arg := selectedCategories size.
    ].
    b := RadioButton "CheckBox" label:(resources string:lbl with:arg).
    self addCheckBox:b forSearchArea:#classCategories.
    ^ b.
!

addCheckBoxForSelectedMethodClasses
    |b classes numClasses|

    classes := ((browser selectedMethods value ? #()) 
                    select:[:m | m mclass notNil]
                    thenCollect:[:m | m mclass theNonMetaclass]) asSet.
    numClasses := classes size.
    numClasses == 0 ifTrue:[^ self]. "/ comment this to show, but disabled

    numClasses == 1 ifTrue:[
        b := RadioButton "CheckBox" label:(resources string:'Selected method''s class ("%1")'
                            with:classes first name).
    ] ifFalse:[
        b := RadioButton "CheckBox" label:(resources string:'Selected methods'' classes (%1)'
                            with:numClasses).
        numClasses == 0 ifTrue:[
            b disable
        ].
    ].
    self addCheckBox:b forSearchArea:#listOfSelectedMethodClasses.
    ^ b.

    "Modified (comment): / 20-07-2012 / 11:40:44 / cg"
!

addCheckBoxForSelectedMethodPackages
    |b packages numPackages|

    packages := ((browser selectedMethods value ? #()) 
                    collect:[:m | m package] as:Set).
    numPackages := packages size.
    numPackages size == 0 ifTrue:[^ self]. "/ comment this to show, but disabled

    numPackages == 1 ifTrue:[
        b := RadioButton "CheckBox" label:(resources string:'Selected method''s package ("%1")'
                            with:packages first).
    ] ifFalse:[
        b := RadioButton "CheckBox" label:(resources string:'Selected methods'' packages (%1)'
                            with:numPackages).
        numPackages == 0 ifTrue:[
            b disable
        ].
    ].
    self addCheckBox:b forSearchArea:#listOfSelectedMethodPackages.
    ^ b.

    "Created: / 29-02-2012 / 19:42:26 / cg"
!

addCheckBoxForSelectedMethods
    |b numSelected|

    numSelected := browser selectedMethods value size.
    numSelected == 0 ifTrue:[^ self]. "/ comment this to show, but disabled

    b := RadioButton "CheckBox" label:(resources string:'Selected methods (%1)' with:numSelected).
    self addCheckBox:b forSearchArea:#listOfSelectedMethods.
    numSelected == 0 ifTrue:[b disable].
    ^ b.

    "Modified (comment): / 20-07-2012 / 11:40:33 / cg"
!

addCheckBoxForSelectedPackage
    |b lbl arg|

    currentPackage notNil ifTrue:[ 
        lbl := 'Class package ("%1")'.
        arg := currentPackage.
    ] ifFalse:[ 
        lbl := 'Selected classes packages (%1)'.
        arg := selectedPackages size.
    ].
    b := RadioButton "CheckBox" label:(resources string:lbl with:arg).
    self addCheckBox:b forSearchArea:#selectedPackages.
    ^ b.
!

addCheckBoxesForClassAndMetaSearch
    |y b1 b2|

    y := self yPosition.
    b1 := self addCheckBox:(resources string:'Instance Protocol') on:(self searchInstanceProtocolHolder).
    b1 helpKey:#classesOnly.
    "/ b1 width:0.5.

    "/ self yPosition:y.
    b2 := self addCheckBox:(resources string:'Class Protocol') on:(self searchClassProtocolHolder).
    b2 helpKey:#metaClassesOnly.
    "/ b2 left:0.5; width:0.5.

    "Created: / 06-12-2011 / 11:24:11 / cg"
!

addDummyCheckBoxForEverywhere
    |b|

    b := RadioButton "CheckBox" label:(resources string:'Everywhere').
    b turnOn.
    b disable.

    currentPanel add:b.
!

addFilteredListOfMatchingSelectors
    |l|

    listHolder := List new.

    l := HVScrollableView for:SelectionInListView.
    l listHolder:listHolder.
    self addComponent:l.
    l doubleClickAction:[
            selectorHolder value:(l selectionValue).
            matchHolder notNil ifTrue:[matchHolder value:false].
            caseHolder notNil ifTrue:[caseHolder value:false].
            self doAccept.
            self okPressed.
    ].
    ^ l.
!

addInputFieldForSelectorOrNameOrString
    |sel lastSearchPatterns|

    initialText notNil ifTrue:[
        sel := initialText
    ] ifFalse:[
        browser notNil ifTrue:[
            searchWhat == #selector ifTrue:[ 
                sel := browser selectorToSearchFor.
            ] ifFalse:[ 
                searchWhat == #globalName ifTrue:[ 
                    sel := browser globalNameToSearchFor ? LastGlobalSearched.
                ] ifFalse:[ 
                    searchWhat == #string ifTrue:[
                        sel := browser stringToSearchFor ? LastStringSearched.
                    ] ifFalse:[
                        searchWhat == #resource ifTrue:[
                            sel := browser stringToSearchFor ? LastResourceSearched.
                        ] ifFalse:[
                            sel := browser selectorToSearchFor.
                        ]
                    ]
                ].
            ].
        ].
    ].
    lastSearchPatterns := (browser ? SystemBrowser) lastSearchPatterns.

    sel isEmptyOrNil ifTrue:[ 
        "/ use last searchString
        lastSearchPatterns size > 0 ifTrue:[ 
            sel := lastSearchPatterns first.
        ].
    ].
    searchWhat == #string ifTrue:[
        selectorHolder := (sel ? '') asValue.
    ] ifFalse:[
        selectorHolder := (sel ? '') withoutSeparators asValue.
    ].

    inputField := self addComboBoxOn:selectorHolder tabable:true.
    inputField list:lastSearchPatterns.
    inputField selectAllInitially.
    inputField immediateAccept:true.
    inputField takeFocus.
    inputField helpKey:#searchPatternField.

    searchWhat == #string ifFalse:[
        inputField 
            entryCompletionBlock:[ :contents | 
                |s what|

                s := contents withoutSpaces.
                self topView 
                    withWaitCursorDo:[
                        |best matching|

                        searchWhat == #resource ifTrue:[
                            what := DoWhatIMeanSupport resourceCompletion:s inEnvironment:Smalltalk match:true ignoreCase:false.
                        ] ifFalse:[
                            searchWhat == #globalName ifFalse:[ 
                                what := DoWhatIMeanSupport selectorCompletion:s inEnvironment:Smalltalk.
                            ] ifTrue:[ 
                                what := DoWhatIMeanSupport globalNameCompletion:s inEnvironment:Smalltalk match:true.
                            ].
                        ].
                        best := what first.
                        matching := what second.
                        inputField contents:best.
                        "/ listHolder contents:matching.
                        matching size ~~ 1 ifTrue:[ 
                            (browser ? self) window beep.
                        ].
                    ].
            ].

        selectorHolder onChangeEvaluate:[ self updateListOfMatchingSelectorsFor:inputField contents ].
    ].
    "Modified: / 14-02-2012 / 14:13:52 / cg"
!

addTextEntryFieldForCode
    |initial box panel patternInfoBox infoLabel helpButton errMessageField checkCodeAction
     metaBox buttonBox helpButtonBox b|

    box := View new.
    box extent:(600 @ 200).
    box helpKey:#codeEntryField.

    panel := VariableHorizontalPanel in:box.
    panel origin:0.0@0.0 corner:(1.0@1.0).

    codeField := CodeView in:panel.        
    codeField canTab:true.
"/    codeField origin:0.0@0.0 corner:(0.75@1.0).

    patternInfoBox := View in:panel.

    infoLabel := ScrollableView for:TextView in:patternInfoBox.
    infoLabel origin:0.0@0.0 corner:1.0@1.0.
    infoLabel level:0.
    infoLabel readOnly:true.
    infoLabel scrolledView backgroundColor:(patternInfoBox viewBackground).
    infoLabel scrolledView viewBackground:(patternInfoBox viewBackground).
    "/ infoLabel geometryLayout:(LayoutFrame bottomInset:30).

    infoLabel scrolledView font:(codeField font asSize:(codeField font size - 2)).
    infoLabel scrolledView lineSpacing:0.
    "/ infoLabel scrolledView font:(Label defaultFont asSize:(Label defaultFont size "- 2")).
    "/ infoLabel adjust:#left.
    "/ infoLabel label:(self helpTextForMetaPatterns).
    infoLabel contents:(self helpTextForMetaPatterns).

    panel relativeCorners:#(0.6 1.0).
    panel showHandle:true.

    buttonBox := HorizontalPanelView new.
    buttonBox horizontalLayout:#rightFit.
    
    helpButtonBox := HorizontalPanelView new.
    helpButtonBox horizontalLayout:#right.
    
    helpButton := Button label:(resources string:'Pattern Help') in:helpButtonBox.
    helpButton layout:((AlignmentOrigin fractionalFromPoint:0.5@1.0) 
                            leftOffset:2
                            topOffset:helpButton preferredHeight negated;
                            leftAlignmentFraction:0.5 topAlignmentFraction:0).
    helpButton topInset:0.75@1.0.
    helpButton action:[self showHelpOnCodePatterns].
    helpButton helpKey:#showPatternHelp.


    self addComponent:box tabable:true.

    metaBox := HorizontalPanelView new.
    metaBox horizontalLayout:#leftMax.

    b := Button label:'+Lit' action:[ codeField pasteOrReplace:'`#n' ] in:metaBox.
    b helpKey:#matchAnyLiteral.
    b := Button label:'+Var' action:[ codeField pasteOrReplace:'`v' ] in:metaBox.
    b helpKey:#matchAnyVariable.
    b := Button label:'+Expr' action:[ codeField pasteOrReplace:'`@e' ] in:metaBox.
    b helpKey:#matchAnyExpression.
    b := Button label:'+Msg' action:[ codeField pasteOrReplace:'`@m:' ] in:metaBox.
    b helpKey:#matchAnyMessage.
    b := Button label:'+Node' action:[ codeField pasteOrReplace:'`{:node | node isLiteral and:[node value isSymbol] }' ] in:metaBox.
    b helpKey:#matchAnyNode.
    b := Button label:'+Stats' action:[ codeField pasteOrReplace:'`.@stats' ] in:metaBox.
    b helpKey:#matchAnyStats.
    buttonBox addComponent:metaBox.
    buttonBox addComponent:helpButtonBox.
    buttonBox addComponent:(View new width:5).
    
    self addComponent:buttonBox.

    errMessageField := (self addTextLabel:'') adjust:#left.
    errMessageField level:-1.    
    self addCheckBox:(resources string:'Method') on:self isMethodHolder.

    checkCodeAction := [ self checkCodeIn:codeField notifying:errMessageField. ].

    codeField modifiedChannel onChangeEvaluate:checkCodeAction.
    self isMethodHolder onChangeEvaluate:checkCodeAction.

    initial := browser selectionInCodeView.
    initial isEmptyOrNil ifTrue:[
        initial := LastCodeSearched ? ''
    ].
    codeField contents:initial.
    checkCodeAction value.

    "Modified: / 23-07-2011 / 10:35:14 / cg"
!

checkCodeIn:codeField notifying:errMessageField
    |codeString tree errAction|

    codeString := codeField contents asString string.
    errAction := [:str :pos |
                    |line col badLine|

                    line := codeField lineOfCharacterPosition:pos.
                    col := (codeField colOfCharacterPosition:pos) max:1.

                    badLine := (codeField listAt:line) ? ''.
                    col <= badLine size size ifTrue:[
                        codeField 
                            listAt:line 
                            put:(badLine asText 
                                    emphasisAt:col 
                                    put:(UserPreferences current unknownIdentifierEmphasis)).
                        "/ codeField selectFromCharacterPosition:pos to:pos.
                    ].
                    errMessageField label:('line: ',line printString,' ',str).
                    errMessageField backgroundColor:Color red.    
                    codeField requestFocus.
                    nil.
                 ].

    isMethodHolder value ifTrue:[
        tree := RBParser parseRewriteMethod:codeString onError: errAction.
    ] ifFalse:[
        tree := RBParser parseRewriteExpression:codeString onError: errAction.
    ].
    tree notNil ifTrue:[ 
        errMessageField backgroundColor:View defaultViewBackgroundColor.    
        errMessageField label:nil 
    ].
    codeField modifiedChannel setValue:false.
!

getClassesAndMethodsFor:where 
    where == #everywhere ifTrue:[ 
        classes := Smalltalk allClasses.
        methods := nil.
        ^ self.
    ].
    where == #currentNameSpace ifTrue:[ 
        classes := currentNamespace allClassesWithAllPrivateClasses.
        methods := nil.
        ^ self.
    ].
    where == #currentClassesNameSpace ifTrue:[ 
        currentClass isPrivate ifTrue:[ 
            classes := currentClass topOwningClass nameSpace 
                        allClassesWithAllPrivateClasses.
        ] ifFalse:[ 
            classes := currentClass nameSpace allClassesWithAllPrivateClasses.
        ].
        methods := nil.
        ^ self.
    ].
    where == #currentPackage ifTrue:[ 
        classes := Smalltalk allClassesInPackage:currentPackage. 
        methods := nil.
        ^ self.
    ].
    where == #currentPackageAndSubPackages ifTrue:[ 
        classes := Smalltalk 
                        allClassesForWhich:[:cls | 
                            |pkg|

                            pkg := cls package ? PackageId noProjectID.
                            pkg = currentPackage or:[ pkg startsWith:(currentPackage,'/') ]
                        ].
        methods := nil.
        ^ self.
    ].
    where == #currentClassesPackage ifTrue:[ 
        classes := Smalltalk allClassesInPackage:currentClass package. 
        methods := nil.
        ^ self.
    ].
    where == #classCategories ifTrue:[ 
        classes := Smalltalk allClasses 
                    select:[ :cls | selectedCategories includes:cls category. ].
        classes := classes collect:[ :each | each theNonMetaclass. ].
        methods := nil.
        ^ self.
    ].
    (where == #classes or:[ where == #classesWithPrivateClasses. ]) ifTrue:[
        selectedClasses notNil ifTrue:[
            classes := selectedClasses collect:[ :each | each theNonMetaclass. ].
            methods := nil.
        ] ifFalse:[
            browser selectedMethods value notEmptyOrNil ifTrue:[
                classes := ((browser selectedMethods value ? #()) collect:[:m | m mclass theNonMetaclass] as:Set) asOrderedCollection.
                methods := nil.
            ].
            ^ self.
        ].
    ].
    (where == #classHierarchies or:[ where == #classHierarchiesWithPrivateClasses. ]) 
    ifTrue:[ 
        classes := IdentitySet new.
        selectedClasses do:[ :cls | 
            classes addAll:cls theNonMetaclass withAllSubclasses.
        ].
        methods := nil.
        ^ self.
    ].
    where == #ownersWithPrivateClasses ifTrue:[ 
        classes := IdentitySet new.
        selectedClasses do:[ :cls | 
            |c|

            c := cls theNonMetaclass.
            classes add:(c owningClass ? c).
        ].
        methods := nil.
        ^ self.
    ].
    where == #ownersHierarchiesWithPrivateClasses ifTrue:[ 
        classes := IdentitySet new.
        selectedClasses do:[ :cls | 
            |c|

            c := cls theNonMetaclass.
            classes addAll:(c owningClass ? c) withAllSubclasses.
        ].
        methods := nil.
        ^ self.
    ].
    (where == #classesAndSuperclasses) ifTrue:[ 
        classes := IdentitySet new.
        selectedClasses do:[ :cls | 
            classes addAll:cls theNonMetaclass withAllSuperclasses.
        ].
        methods := nil.
        ^ self.
    ].
    (where == AREA_LISTOFMETHODS) ifTrue:[ 
        classes := nil.
        methods := browser methodListApp methodList value.
        ^ self.
    ].
    (where == #listOfSelectedMethods) ifTrue:[ 
        classes := nil.
        methods := browser selectedMethods value ? #().
        ^ self.
    ].
    (where == #listOfSelectedMethodClasses) ifTrue:[ 
        classes := ((browser selectedMethods value ? #()) collect:[:m | m mclass theNonMetaclass] as:Set) asOrderedCollection.
        methods := nil.
        ^ self.
    ].
    (where == #listOfSelectedMethodPackages) ifTrue:[ 
        classes := (((browser selectedMethods value ? #()) collect:[:m | m package] as:Set)
                        collectAll:[:p | Smalltalk allClassesInPackage:p ]) asOrderedCollection.
        methods := nil.
        ^ self.
    ].
    (where == #listOfChangedClasses) ifTrue:[ 
        classes := ChangeSet current changedClasses.
        methods := nil.
        ^ self.
    ].
    (where == #listOfChangedMethods) ifTrue:[ 
        classes := nil.
        methods := Set new.
        ChangeSet current do:[:chg |
            |mthd|

            chg notNil ifTrue:[
                chg isMethodChange ifTrue:[
                    mthd := chg changeMethod.
                    mthd notNil ifTrue:[
                        methods add:mthd
                    ]
                ]
            ]
        ].
        methods := methods asOrderedCollection.
        ^ self.
    ].

    self todo:'unimplemented search'.

    "Modified: / 05-10-2011 / 15:48:20 / az"
    "Modified: / 18-11-2016 / 00:22:55 / cg"
!

helpTextForMetaPatterns
    ^ 'MetaPatterns:
    ' , '`' allBold , ' = meta 
    ' , '@' allBold , ' = list/any
    ' , '.' allBold , ' = statement
    ' , '`' allBold , ' = recurse

    ' , '`#n' allBold , ' any lit
    ' , '`v' allBold , '  any var (`V => global)
    ' , '`@e' allBold , ' any expr
    ' , '`@m:' allBold , ' any message (`m => unary)
    ' , '`{:n|...}' allBold , ' node pattern
    ' , '`''a.*''' allBold , ' regex on string const
'.

    "Modified: / 08-08-2011 / 20:33:03 / cg"
!

isMethodHolder
    isMethodHolder isNil ifTrue:[isMethodHolder := (LastCodeSearchWasMethod ? false) asValue].
    ^ isMethodHolder
! !

!SearchDialog methodsFor:'setup-buttons'!

addBrowseButton
    |b|

    b := Button label:(resources string:'Browse').
    (DialogBox defaultOKButtonAtLeft) ifTrue:[ 
	self addButton:b before:nil.
    ] ifFalse:[ 
	self addButton:b after:nil.
    ].
    b 
	action:[ 
	    openHow := #newBrowser.
	    self doAccept.
	    self okPressed.
	].
    ^ b.
!

addBufferButton
    |b|

    b := Button label:(resources string:'Add Buffer').
    (DialogBox defaultOKButtonAtLeft) ifTrue:[ 
	self addButton:b before:nil.
    ] ifFalse:[ 
	self addButton:b after:nil.
    ].
    b 
	action:[ 
	    openHow := #newBuffer.
	    self doAccept.
	    self okPressed.
	].
    ^ b.
!

addButtons
    "add find/newBrowser/newBuffer buttons"

    |prevButton|

    allowFind ifTrue:[
        defaultOpenHow := #showHere.
        prevButton := self addFindButton.
    ].
    allowBrowser ifTrue:[
        defaultOpenHow := #newBrowser.
        prevButton := self addBrowseButton.
    ].
    allowBuffer ifTrue:[
        defaultOpenHow := #newBuffer.
        prevButton := self addBufferButton.
    ].
    prevButton notNil ifTrue:[
        prevButton isReturnButton:true.
    ].
    self addAbortButton.
!

addFindButton
    |b|

    b := Button label:(resources string:'Find').
    (DialogBox defaultOKButtonAtLeft) ifTrue:[ 
	self addButton:b before:nil.
    ] ifFalse:[ 
	self addButton:b after:nil.
    ].
    b 
	action:[ 
	    openHow := #showHere.
	    self doAccept.
	    self okPressed.
	].
    ^ b.
! !

!SearchDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


SearchDialog initialize!
