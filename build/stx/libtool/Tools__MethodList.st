"
 COPYRIGHT (c) 2000 by eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
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

BrowserList subclass:#MethodList
	instanceVariableNames:'classes selectedMethodNameIndices methodList methodNameList
		lastSelectedMethods browserNameList variableFilter
		filterClassVars updateProcess lastShowClass lastShowCategory
		lastShowClassFirst showMethodInheritance lastMethodClass
		lastMethodClassesSubclasses
		classAndSelectorsRedefinedBySubclassesOfClass showClass
		showMethodComplexity showMethodTypeIcon
		showImageResourceMethodsImages showSyntheticMethods'
	classVariableNames:'ShowComplexityValue'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!MethodList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
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
    I implement the method list in the new system browser
"
! !

!MethodList class methodsFor:'interface specs'!

singleMethodWindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MethodList andSelector:#singleMethodWindowSpec
     MethodList new openInterface:#singleMethodWindowSpec
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #singleMethodWindowSpec
	#window:
       #(#WindowSpec
	  #label: 'SingleSelectorList'
	  #name: 'SingleSelectorList'
	  #min: #(#Point 0 0)
	  #max: #(#Point 1024 721)
	  #bounds: #(#Rectangle 12 22 312 322)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'MethodName'
	      #name: 'MethodLabel'
	      #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 25 0)
	      #translateLabel: true
	      #labelChannel: #methodLabelHolder
	      #menu: #menuHolder
	   )
	   )

	)
      )

    "Modified: / 1.3.2000 / 20:50:15 / cg"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::MethodList andSelector:#windowSpec
     Tools::MethodList new openInterface:#windowSpec
     Tools::MethodList open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'SelectorList'
	  name: 'SelectorList'
	  min: (Point 0 0)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (SequenceViewSpec
	      name: 'List'
	      layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
	      tabable: true
	      model: selectedMethodNameIndices
	      menu: menuHolder
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      miniScrollerHorizontal: true
	      isMultiSelect: true
	      valueChangeSelector: selectionChangedByClick
	      useIndex: true
	      sequenceList: browserNameList
	      doubleClickChannel: doubleClickChannel
	      properties:
	     (PropertyListDictionary
		canDropSelector: canDropContext:
		dragArgument: nil
		dropArgument: nil
		dropSelector: doDropContext:
	      )
	    )
	   )

	)
      )
! !

!MethodList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
	environmentHolder
	#(doubleClickChannel action)
	#filterClassVars
	#forceGeneratorTrigger
	#immediateUpdate
	#inGeneratorHolder
	#menuHolder
	#methodCategoryHolder
	#packageFilter
	#selectedMethods
	#selectionChangeCondition
	#showCoverageInformation
	#showImageResourceMethodsImages
	#showMethodComplexity
	#showMethodInheritance
	#showMethodTypeIcon
	#sortBy
	#updateTrigger
	#variableFilter
	#showSyntheticMethods
      ).

    "Modified: / 24-02-2014 / 10:37:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodList methodsFor:'aspects'!

browserNameList
    browserNameList isNil ifTrue:[
	browserNameList := List new.
    ].
    ^ browserNameList.

    "Modified: / 31.1.2000 / 00:42:44 / cg"
    "Created: / 5.2.2000 / 22:38:32 / cg"
!

defaultSlaveModeValue
    ^ false.
!

filterClassVars
    filterClassVars isNil ifTrue:[
        filterClassVars := ValueHolder with:false.
        filterClassVars addDependent:self
    ].
    ^  filterClassVars
!

filterClassVars:aValueHolder
    filterClassVars notNil ifTrue:[
	filterClassVars removeDependent:self
    ].
    filterClassVars := aValueHolder.
    filterClassVars notNil ifTrue:[
	filterClassVars addDependent:self
    ].
!

methodLabelHolder
    ^ self pseudoListLabelHolder

    "Created: / 1.3.2000 / 20:50:07 / cg"
!

methodList
    ^ methodList
!

selectedMethodNameIndices
    selectedMethodNameIndices isNil ifTrue:[
	selectedMethodNameIndices := ValueHolder new.
	selectedMethodNameIndices addDependent:self
    ].
    ^ selectedMethodNameIndices.

    "Modified: / 5.2.2000 / 00:31:48 / cg"
    "Created: / 5.2.2000 / 22:59:31 / cg"
!

selectedMethods
    ^ self selectionHolder
!

selectedMethods:aValueHolder
    ^ self selectionHolder:aValueHolder
!

showImageResourceMethodsImages
    showImageResourceMethodsImages isNil ifTrue:[
        showImageResourceMethodsImages := ValueHolder with:false.
        showImageResourceMethodsImages addDependent:self
    ].
    ^  showImageResourceMethodsImages
!

showImageResourceMethodsImages:aValueHolder
    showImageResourceMethodsImages notNil ifTrue:[
	showImageResourceMethodsImages removeDependent:self
    ].
    showImageResourceMethodsImages := aValueHolder.
    showImageResourceMethodsImages notNil ifTrue:[
	showImageResourceMethodsImages addDependent:self
    ].
!

showMethodComplexity
    showMethodComplexity isNil ifTrue:[
        showMethodComplexity := ValueHolder with:false.
        showMethodComplexity addDependent:self
    ].
    ^  showMethodComplexity
!

showMethodComplexity:aValueHolder
    showMethodComplexity notNil ifTrue:[
	showMethodComplexity removeDependent:self
    ].
    showMethodComplexity := aValueHolder.
    showMethodComplexity notNil ifTrue:[
	showMethodComplexity addDependent:self
    ].
!

showMethodInheritance
    showMethodInheritance isNil ifTrue:[
        showMethodInheritance := ValueHolder with:false.
        showMethodInheritance addDependent:self
    ].
    ^  showMethodInheritance
!

showMethodInheritance:aValueHolder
    showMethodInheritance notNil ifTrue:[
	showMethodInheritance removeDependent:self
    ].
    showMethodInheritance := aValueHolder.
    showMethodInheritance notNil ifTrue:[
	showMethodInheritance addDependent:self
    ].
!

showMethodTypeIcon
    showMethodTypeIcon isNil ifTrue:[
        showMethodTypeIcon := ValueHolder with:true.
        showMethodTypeIcon addDependent:self
    ].
    ^  showMethodTypeIcon
!

showMethodTypeIcon:aValueHolder
    showMethodTypeIcon notNil ifTrue:[
	showMethodTypeIcon removeDependent:self
    ].
    showMethodTypeIcon := aValueHolder.
    showMethodTypeIcon notNil ifTrue:[
	showMethodTypeIcon addDependent:self
    ].
!

showSyntheticMethods
    showSyntheticMethods isNil ifTrue:[
        showSyntheticMethods := ValueHolder with:false.
        showSyntheticMethods addDependent:self
    ].
    ^  showSyntheticMethods

    "Created: / 13-04-2012 / 16:03:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showSyntheticMethods:aValueHolder
    showSyntheticMethods notNil ifTrue:[
	showSyntheticMethods removeDependent:self
    ].
    showSyntheticMethods := aValueHolder.
    showSyntheticMethods notNil ifTrue:[
	showSyntheticMethods addDependent:self
    ].

    "Created: / 13-04-2012 / 16:03:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variableFilter
    variableFilter isNil ifTrue:[
        variableFilter := ValueHolder with:nil.
        variableFilter addDependent:self
    ].
    ^  variableFilter
!

variableFilter:aValueHolder
    variableFilter notNil ifTrue:[
	variableFilter removeDependent:self
    ].
    variableFilter := aValueHolder.
    variableFilter notNil ifTrue:[
	variableFilter addDependent:self
    ].
! !

!MethodList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    |cls clsName sel oldMethod newMethod methods newSelection
     selection needSelectionChange|

    selection := self selectionHolder value.

    changedObject == environment ifTrue:[
        classes notNil ifTrue:[
            something == #classDefinition ifTrue:[
                cls := aParameter.
                clsName := cls name.
                (classes contains:[:aClass | aClass notNil and:[aClass name = clsName]]) ifFalse:[
                    ^ self   "/ I don't care for that class
                ].
                classes := classes collect:[:eachClass | (environment classNamed:eachClass name) ].
                self invalidateList.
"/                self updateList.
                ^ self.
            ].

            something == #methodCategory ifTrue:[
                "/ ignore here - methodCategoryList will tell me if required
                ^ self
            ].
            (something == #classOrganization
            or:[ something == #methodCategoryAdded
            or:[ something == #methodCategoryRemoved
            or:[ something == #methodCategoriesRemoved
            or:[ something == #methodCategoryRenamed ]]]]) ifTrue:[
                "/ ignore here - methodCategoryList will tell me if required
                ^ self
            ].

            (something == #methodInClass
            or:[something == #methodCoverageInfo]) ifTrue:[
                "/ a method has been added/changed
                cls := aParameter at:1.
                (classes includesIdentical:cls) ifTrue:[
                    sel := aParameter at:2.
                    oldMethod := aParameter at:3.
                    newMethod := cls compiledMethodAt:sel.
                    (oldMethod notNil and:[newMethod notNil]) ifTrue:[
                        "a method was changed & accepted;
                         No need for a rescan of the methodDictionary;
                         however, ensure that the refs to the old method are updated
                        "
                        methods := selection.
                        selection notEmpty ifTrue:[
                            (methods includesIdentical:oldMethod) ifTrue:[
                                needSelectionChange := true.
                            ]
                        ].
                        methodList replaceAllIdentical:oldMethod with:newMethod.
                        lastSelectedMethods notNil ifTrue:[
                            lastSelectedMethods replaceAllIdentical:oldMethod with:newMethod
                        ].
                        selection notEmpty ifTrue:[
                            methods := methods asOrderedCollection.
                            methods replaceAllIdentical:oldMethod with:newMethod.
                        ].

                        needSelectionChange == true ifTrue:[
                            selectionHolder setValue:methods.
                            "/ self enqueueDelayedMethodsSelectionChanged.
                            "/ need this to inform my browser that method was changed
                            "/ by someone else.
                            selectionHolder changed.
                        ].
                        "/JV@2011-07-22: Update always - I need to see immediately that
                        "/the method has changed. Also, add/remove breakpoint etc.

"/                        (variableFilter value size > 0
"/                        or:[oldMethod package ~= newMethod package
"/                        or:[oldMethod resources ~= newMethod resources
"/                        or:[showMethodComplexity value == true]]])
                        self autoUpdateOnChange ifTrue:[
                            "/ only update that method's entry
                            self updateListEntryFor:newMethod.
                            "/ sigh - must invalidate
                            "/ self invalidateList.
                        ].
                        ^ self.
                    ].
                    "/ method was added - update the methodList
                    "/ Q: is this needed (methodCategoryList should send me a new inGenerator)
                    self invalidateList.
                ].
                ^ self.
            ].

            something == #methodInClassRemoved ifTrue:[
                cls := aParameter at:1.
                (classes includesIdentical:cls) ifTrue:[
                    sel := aParameter at:2.
                    "/ method was removed - update the methodList
                    "/ Q: is this needed (methodCategoryList should send me a new inGenerator)
                    self invalidateList.
                ].
                ^ self.
            ].

            something == #methodCoverageInfo ifTrue:[
                "/ already checked if it is one of my classes
                self updateListEntryFor:aParameter.
"/                self enqueueDelayedUpdateList.
"/                listValid == true ifTrue:[
"/                    self invalidateList.
"/                ].
                ^ self.
            ].

            (something == #methodTrap
            or:[ something == #lastTestRunResult
            or:[ something == #privacyOfMethod ]]) ifTrue:[
                cls := aParameter at:1.
                sel := aParameter at:2.
                (classes includesIdentical:cls) ifFalse:[ ^ self].

                newMethod := cls compiledMethodAt:sel.
                newMethod isNil ifTrue:[
                    self invalidateList.
                    ^ self
                ].

                ((something == #privacyOfMethod) or:[something == #lastTestRunResult]) ifTrue:[
                    self updateListEntryFor:newMethod.
                ].

                (something == #methodTrap) ifTrue:[
                    newMethod isWrapped ifTrue:[
                        oldMethod := newMethod originalMethod.
                        "/ We have to handle the case the method was wrapped before
                        "/ and now is wrapped differently - for example there was be breakpoint
                        "/ changed to trace point.
                        "/ 
                        "/ In that case, the oldMethod (the one that is in the selection and the one
                        "/ that WAS installed in the class is not `newMethod originalMethod` but it's the
                        "/ method whose originalMethod is the same as `newMethod originalMethod`. 
                        "/ 
                        "/ Since we're interested in this case if such method is selected, checn the selection.
                        "/ A little tricky, we'll see.
                        "/ 
                        "/ See https://swing.fit.cvut.cz/projects/ticket/103
                        "/ 
                        selection notEmpty ifTrue:[
                            oldMethod := selection detect:[:each | each isWrapped and:[each originalMethod == oldMethod"newMethod originalMethod"]] ifNone:oldMethod.
                        ]
                    ] ifFalse:[
                        selection notEmpty ifTrue:[
                            oldMethod := selection detect:[:each | each isWrapped and:[each originalMethod == newMethod]] ifNone:nil.
                        ]
                    ].

                    selection notEmpty ifTrue:[
                        (selection includesIdentical:oldMethod) ifTrue:[
                            needSelectionChange := true.
                        ]
                    ].
                    methodList replaceAllIdentical:oldMethod with:newMethod.
                    lastSelectedMethods notNil ifTrue:[
                        lastSelectedMethods replaceAllIdentical:oldMethod with:newMethod
                    ].
                    selection notEmpty ifTrue:[
                        "/ Used to be:
                        "/ 
                        "/     selection := selection asOrderedCollection,
                        "/     selection replaceAllIdentical:oldMethod with:newMethod.
                        "/ 
                        "/ but that's WRONG!! If the selection is not an ordered collection,
                        "/ then asOrderedCollection would create new collection noone else
                        "/ references and thus the replace is useless. If the selection 
                        "/ is already an OrderedCollection, then #asOrderedCollection is
                        "/ itself useless.
                        "/ 
                        "/ The former case (when selection was for example an array) caused
                        "/ selection loss on some cases, hard to chase down!!
                        selection isSequenceable ifTrue:[ 
                            selection replaceAllIdentical:oldMethod with:newMethod.
                        ] ifFalse:[ 
                            "/ Now, are we sure selection is always a sequenceable? 
                            "/ I (JV) am not sure so handle (Identity)Set cases too:
                            self breakPoint: #jv.  
                            (selection includesIdentical: oldMethod) ifTrue:[ 
                                selection removeIdentical: oldMethod.
                                selection add: newMethod.
                            ].
                        ].
                    ].
                    needSelectionChange == true ifTrue:[
                        selectionHolder changed.
                    ].

                    "/ actually, could just change that single item ...
                    "/ ... might be cheaper, if list is huge.
                    "/ only update that methods entry
                    self updateListEntryFor:newMethod.
                    "/ self invalidateList.
                ].
                ^ self
            ].

            (something == #projectOrganization
            or:[something == #lastTestRunResult]) ifTrue:[
                aParameter notNil ifTrue:[
                    cls := aParameter at:1.
                    cls notNil ifTrue:[
                        ((classes includesIdentical:cls theNonMetaclass)
                        or:[(classes includesIdentical:cls theMetaclass)]) ifTrue:[
                            self invalidateList.
                        ].
                    ].
                ] ifFalse:[
                    self invalidateList.
                ].
                ^ self
            ].

            "/ everything else is ignored
            "/ self halt.
        ].
        ^ self
    ].

"/    something == #organization ifTrue:[
"/self halt:'no longer'.
"/^ self.
"/        "/ a methods cateory has changed
"/        (classes includesIdentical:changedObject) ifTrue:[
"/            aParameter isSymbol ifTrue:[
"/                "/ a method with a new category
"/                (self methodList includesIdentical:(changedObject compiledMethodAt:aParameter)) ifTrue:[
"/                    self invalidateList.
"/                ].
"/                ^ self.
"/            ].
"/            "/ a new category (no method yet)
"/            self invalidateList
"/        ].
"/        ^ self
"/    ].

"/    something == #methodDictionary ifTrue:[
"/self halt:'no longer'.
"/^ self.
"/        "/ a method has been added/removed
"/        (classes includesIdentical:changedObject) ifTrue:[
"/            aParameter isArray ifTrue:[
"/                sel := aParameter at:1.
"/                oldMethod := aParameter at:2.
"/                newMethod := changedObject compiledMethodAt:sel.
"/                oldMethod notNil ifTrue:[
"/                    "a method was changed & accepted;
"/                     No need for a rescan of the methodDictionary;
"/                     however, ensure that the refs to the old method are updated
"/                    "
"/                    methods := selection.
"/                    methods size > 0 ifTrue:[
"/                        (methods includesIdentical:oldMethod) ifTrue:[
"/                            needSelectionChange := true.
"/                        ]
"/                    ].
"/                    methodList replaceAllIdentical:oldMethod with:newMethod.
"/                    lastSelectedMethods notNil ifTrue:[
"/                        lastSelectedMethods replaceAllIdentical:oldMethod with:newMethod
"/                    ].
"/                    methods size > 0 ifTrue:[
"/                        methods := methods asOrderedCollection.
"/                        methods replaceAllIdentical:oldMethod with:newMethod.
"/                    ].
"/                    needSelectionChange == true ifTrue:[
"/                        selectionHolder setValue:methods.
"/                        selectionHolder changed.
"/                    ].
"/                    ^ self.
"/                ]
"/            ].
"/            "/ class has changed must update the methodList
"/            self invalidateList.
"/        ].
"/        ^ self.
"/    ].

"/    something == #projectOrganization ifTrue:[
"/        ((classes includesIdentical:changedObject theNonMetaclass)
"/        or:[(classes includesIdentical:changedObject theMetaclass)]) ifTrue:[
"/            self invalidateList.
"/        ].
"/        ^ self
"/    ].

    changedObject == sortBy ifTrue:[
        listValid ~~ true ifTrue:[  "/ could be nil
            inGeneratorHolder value isNil ifTrue:[
                "/ ok, no need to react on that one
                "/ (will invalidate anyway, once I have more info at hand)
                ^ self
            ].
        ].
        self invalidateList.
        ^ self
    ].

    (changedObject == variableFilter
    or:[changedObject == filterClassVars
    or:[changedObject == showMethodInheritance
    or:[changedObject == showMethodComplexity
    or:[changedObject == showSyntheticMethods
    ]]]]) ifTrue:[
        self invalidateList.
        ^  self
    ].

    changedObject == selectedMethodNameIndices ifTrue:[
        newSelection := self selectedMethodNameIndices value collect:[:idx | methodList at:idx].
        newSelection ~= selection ifTrue:[
            selectionHolder value:newSelection.
            lastSelectedMethods := newSelection.
            lastSelectedMethods notNil ifTrue:[
                lastSelectedMethods := lastSelectedMethods asOrderedCollection
            ].
        ] ifFalse:[
            "/ a reselect - force update
"/            selection size == 1 ifTrue:[
                selectionHolder setValue:newSelection.
                selectionHolder changed:#value.
"/            ].
        ].
        ^ self
    ].
    changedObject == selectionHolder ifTrue:[
        self selectedMethodsChanged.
        lastSelectedMethods := selectionHolder value.
        lastSelectedMethods notNil ifTrue:[
            lastSelectedMethods := lastSelectedMethods asOrderedCollection
        ].
        ^ self
    ].
"/    something == #methodTrap ifTrue:[
"/self halt:'no longer'.
"/^ self.
"/        (classes includesIdentical:changedObject) ifTrue:[
"/            newMethod := changedObject compiledMethodAt:aParameter.
"/            newMethod isNil ifTrue:[
"/                self invalidateList.
"/                ^ self
"/            ].
"/            newMethod isWrapped ifTrue:[
"/                oldMethod := newMethod originalMethod
"/            ] ifFalse:[
"/                selection size > 0 ifTrue:[
"/                    oldMethod := selection detect:[:each | each isWrapped and:[each originalMethod == newMethod]] ifNone:nil.
"/                ]
"/            ].
"/
"/            selection size > 0 ifTrue:[
"/                (selection includesIdentical:oldMethod) ifTrue:[
"/                    needSelectionChange := true.
"/                ]
"/            ].
"/"/            methodList replaceAllIdentical:oldMethod with:newMethod.
"/            lastSelectedMethods notNil ifTrue:[
"/                lastSelectedMethods replaceAllIdentical:oldMethod with:newMethod
"/            ].
"/            selection size > 0 ifTrue:[
"/                selection := selection asOrderedCollection.
"/                selection replaceAllIdentical:oldMethod with:newMethod.
"/            ].
"/            needSelectionChange == true ifTrue:[
"/                selectionHolder changed.
"/            ].
"/            self invalidateList.
"/            ^ self
"/        ].
"/        ^ self
"/    ].
    super delayedUpdate:something with:aParameter from:changedObject

    "Created: / 05-02-2000 / 13:42:14 / cg"
    "Modified: / 05-06-2012 / 23:47:15 / cg"
    "Modified: / 16-10-2017 / 00:05:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedMethodsChanged
    "the set of selected methods has changed;
     update the selection-index collection (for the selectionInListView)"

    |indices methods reverseMap
     selectedMethodsHolder selectedMethods selectedMethodNameIndicesHolder|

    methods := methodList ? #().
    methods size == 0 ifTrue:[
        "/ this may happen during early startup,
        "/ when invoked with a preset methodSelection,
        "/ and the methodGenerator has not yet been setup
        "/ to not clobber the selection, defer the update
        "/ until the methodList arrives ...
        ^ self
    ].

    selectedMethodsHolder := self selectedMethods.
    selectedMethods := selectedMethodsHolder value.

    "/ check if all is selected (likely)
    ((selectedMethods size == methodList size)
    and:[selectedMethods = methodList]) ifTrue:[
        indices := (1 to:selectedMethods size)
    ] ifFalse:[
        selectedMethods size > 100 ifTrue:[
            "/ check if all is selected (likely)
            ((selectedMethods size == methodList size)
            and:[selectedMethods = methodList]) ifTrue:[
                indices := (1 to:selectedMethods size)
            ] ifFalse:[
                "/ for big collections, generate a reverse map
                reverseMap := IdentityDictionary new.
                methods keysAndValuesDo:[:idx :mthd | reverseMap at:mthd put:idx].
                indices := selectedMethods 
                                collect:[:eachSelectedMethod |
                                    reverseMap at:eachSelectedMethod ifAbsent:0]
                                thenSelect:[:idx | idx ~~ 0]
            ]
        ] ifFalse:[
            indices := (selectedMethods ? #()) 
                            collect:[:eachSelectedMethod |
                                methods identityIndexOf:eachSelectedMethod]
                            thenSelect:[:idx | idx ~~ 0]
        ].
    ].

    selectedMethodNameIndicesHolder := self selectedMethodNameIndices.
    selectedMethodNameIndicesHolder value ~= indices ifTrue:[
        selectedMethodNameIndicesHolder value:indices.
    ]
!

selectionChanged
    |methods|

    methods := ((self selectedMethodNameIndices value) ? #()) collect:[:idx | methodList at:idx].
    methods notEmpty ifTrue:[
	lastSelectedMethods := methods asOrderedCollection.
    ].
    "/ to allow reselect, change my valueHolder, even if the same collection
"/    self selectedMethods value ~= methods ifTrue:[
	self selectedMethods value:methods asOrderedCollection
"/    ]

    "Created: / 05-02-2000 / 13:42:14 / cg"
    "Modified: / 05-02-2000 / 23:32:20 / cg"
    "Modified: / 13-06-2013 / 12:19:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionChangedByClick
    "we are not interested in that - get another notification
     via the changed valueHolder "
!

update:something with:aParameter from:changedObject
    |cls clsName sel mthd mustFlushInheritanceInfo|

    mustFlushInheritanceInfo := true.

    "/ some can be ignored immediately
    changedObject == environment ifTrue:[
        classes isNil ifTrue:[
            ^ self.
        ].
        something isNil ifTrue:[
            "/ self halt "/ huh - environment changed - so what ?
            ^ self.
        ].
        something == #classComment ifTrue:[
            ^ self.
        ].
        something == #classVariables ifTrue:[
            ^ self.
        ].
        something == #organization ifTrue:[
            ^ self.
        ].
        something == #methodCategory ifTrue:[
            "/ ignore here - methodCategoryList will tell me if required
            ^ self
        ].
        (something == #classOrganization
        or:[ something == #methodCategoryAdded
        or:[ something == #methodCategoryRemoved
        or:[ something == #methodCategoriesRemoved
        or:[ something == #methodCategoryRenamed ]]]]) ifTrue:[
            "/ ignore here - methodCategoryList will tell me if required
            ^ self
        ].

        something == #methodCoverageInfo ifTrue:[
            self showCoverageInformation value ifFalse:[^ self].
            mthd := aParameter.
            (classes notNil and:[classes includesIdentical:mthd mclass]) ifFalse:[
                ^ self   "/ I don't care for that class
            ].
            mustFlushInheritanceInfo := false.
        ].

        (something == #methodTrap
        or:[ something == #methodPrivacy
        or:[ something == #lastTestRunResult] ]) ifTrue:[
            cls := aParameter at:1.
            (classes includesIdentical:cls) ifFalse:[ ^ self].

            sel := aParameter at:2.
            mthd := cls compiledMethodAt:sel.
            (mthd notNil and:[mthd isWrapped or:[mthd isMethodWithBreakpoints]]) ifTrue:[
                |original|

                original := mthd originalMethod.
                (methodList includesIdentical:original) ifTrue:[
                    methodList replaceAll:original with:mthd.
                    lastSelectedMethods notNil ifTrue:[
                        lastSelectedMethods replaceAll:original with:mthd.
                    ].
                ]
            ].

            self window shown ifFalse:[
                "JV@2011-11-17: Do not break the dependency here,
                 because then the window won't get updates once
                 deiconified -> leads to confusing behavior
                 (browser shows obsolete info)"
                "/changedObject removeDependent:self. "/ ?????
                listValid ifTrue:[ self invalidateList ].
                ^ self
            ].
            mustFlushInheritanceInfo := false.
        ].
        something == #newClass ifTrue:[
            ^ self.
        ].

        (something == #methodInClass
        or:[ something == #methodInClassRemoved ]) ifTrue:[
            cls := aParameter first.
            clsName := cls name.
            (classes contains:[:aClass | aClass name = clsName]) ifFalse:[
                ^ self   "/ I don't care for that class
            ].
            sel := aParameter second.
            (methodList contains:[:mthd | mthd getMclass notNil and:[mthd selector = sel]]) ifFalse:[
                mustFlushInheritanceInfo := false.
                self window topView hasFocus ifFalse:[
                    self enqueueDelayedUpdate:something with:aParameter from:changedObject.
                    ^ self.
                ].
            ].
        ].

        mustFlushInheritanceInfo ifTrue:[
            "/ as the organisation changes, flush my remembered redefinition-cache-info
            classAndSelectorsRedefinedBySubclassesOfClass := nil.
        ].

        something == #classDefinition ifTrue:[
            cls := aParameter.
            clsName := cls name.
            (classes contains:[:aClass | aClass name = clsName]) ifFalse:[
                ^ self   "/ I don't care for that class
            ].
            self enqueueDelayedUpdate:something with:aParameter from:changedObject.
            ^ self.
        ].
        something == #classRemove ifTrue:[
            ^ self.
        ].
        something == #classRename ifTrue:[
            ^ self.
        ].
    ].

    "/ these must lead to immediate update of the selectedMethods collection
    "/ (otherwise, that collection might be updated too late, leading to
    "/ an obsolete methods code being shown by the codeView.
    (something == #methodInClass
    or:[ something == #methodCoverageInfo ]) ifTrue:[
        "/ as the organisation changes, flush my remembered redefinition-cache-info
        classAndSelectorsRedefinedBySubclassesOfClass := nil.
        cls := aParameter at:1.
        classes isNil ifTrue:[ ^ self ].
        (classes includesIdentical:cls) ifFalse:[
            ^ self   "/ I dont care for that class
        ].
        self enqueueDelayedUpdate:something with:aParameter from:changedObject.
        ^ self
    ].

    something == #coverageInfo ifTrue:[
        listValid == true ifTrue:[
            self enqueueDelayedUpdateList
        ].
        ^ self.
    ].

    something == #methodInClassRemoved ifTrue:[
        cls := aParameter at:1.
        classes isNil ifTrue:[ ^ self ].
        (classes includesIdentical:cls) ifFalse:[
            ^ self   "/ I dont care for that class
        ].
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 05-06-2012 / 23:41:50 / cg"
    "Modified: / 17-04-2014 / 21:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodList methodsFor:'drag & drop'!

canDropContext:aDropContext
    "I can receive methods (from another browser) and image filenames"
    |objects|

    "/ ignore drop from myself
    aDropContext sourceWidget == aDropContext targetWidget ifTrue:[^ false].

    objects := aDropContext dropObjects collect:[:obj | obj theObject].
    (objects
	conform:[:anObject |
	    |mime|

	    anObject isMethod
	    or:[ anObject isFilename
		    and:[ (mime := anObject mimeTypeFromName) notNil
		    and:[ mime isImageType ]]]
	]) ifFalse:[^ false].

    self masterApplication theSingleSelectedClass isNil ifTrue:[^ false].
    ^ true

    "Modified: / 13-09-2006 / 11:43:54 / cg"
!

doDropContext:aDropContext
    |objects methods files browser cls|

    browser := self masterApplication.
    cls := browser theSingleSelectedClass.

    objects := aDropContext dropObjects collect:[:aDropObject | aDropObject theObject].
    methods := objects select:[:something | something isMethod].

    aDropContext dragType == DropContext dragTypeCopy ifTrue:[
	browser
	    copyMethods:methods
	    toClass:cls.
    ] ifFalse:[
	browser
	    moveMethods:methods
	    toClass:cls.
    ].

    files := objects select:[:something | something isFilename].
    files do:[:eachFilename |
	|img sel mime|

	((mime := eachFilename mimeTypeFromName) notNil
	and:[mime isImageType]) ifTrue:[
	    img := Image fromFile:eachFilename.
	    sel := Dialog request:'Name of Image Method' initialAnswer:'img_',eachFilename withoutSuffix baseName.
	    sel isEmptyOrNil ifTrue:[^ self].
	    browser theSingleSelectedClass programmingLanguage codeGeneratorClass
		createImageSpecMethodFor:img comment:'"Imported from ',eachFilename pathName,'"' in:cls selector:sel
	]
    ].

    "Modified: / 13-09-2006 / 11:43:44 / cg"
! !

!MethodList methodsFor:'private'!

isMethodToBeShown:aMethod
    "invoked, when we get a change for aMethod which was previously not
     in the list (for example, if I show a filtered list).
     Check if that single method is to be shown now.
     Used to speed up update for senders/string/implementors lists"

    |generator|

    generator := inGeneratorHolder value.
    generator isNil ifTrue:[
	^ false
    ].

    "/ generator generates nil-selector entries
    "/ to pass multiple-class and multiple-protocol info

    generator do:[:cls :cat :sel :mthd |
	mthd == aMethod ifTrue:[
	    mthd isSynthetic ifFalse:[
		sel notNil ifTrue:[
"/ cg: no longer filter those...
"/                    (packageFilter value isNil
"/                    or:[ packageFilter value includes:mthd package ]) ifTrue:[
			^ true
"/                    ]
		]
	    ].
	    ^ false
	]
    ].
    ^ false

    "Created: / 17-08-2011 / 15:03:34 / cg"
!

listOfMethodNames
    |methods entries selectorBag newNameList allClasses newClasses
     allCategories                 "allSelectors"
     generator doShowClass doShowClassFirst doShowCategory enforceClassAndProtocolInList
     theMethod sortByClass anyMethodToWatch mclass
     packageFilterValue nameListEntryForExtensions
     suppressInheritanceInfoNow startTime|

    suppressInheritanceInfoNow := (showMethodInheritance value ? true) not.
    startTime := Timestamp now.

    generator := inGeneratorHolder value.
    generator isNil ifTrue:[
        ^ #()
    ].
    allClasses := IdentitySet new.
    allCategories := IdentitySet new.

    "/ allSelectors := Set new.

    newClasses := IdentitySet new.
    selectorBag := Bag new.
    entries := OrderedCollection new.
    enforceClassAndProtocolInList := false.
    anyMethodToWatch := false.

    "/ no longer filter those
    "/ JV@2013-09-17: Why on hell not? A little explanation please!!
    "/ Enabled again, because when i select package in a browser I expect
    "/ to see only methods belonging to that package!!
    packageFilterValue := packageFilter value.
    packageFilterValue notNil ifTrue:[
        (packageFilterValue includes:self class nameListEntryForALL) ifTrue:[
            packageFilterValue := nil
        ]
    ].

    "/ generator generates nil-selector entries
    "/ to pass multiple-class and multiple-protocol info
    nameListEntryForExtensions := self class nameListEntryForExtensions.

    generator do:[:cls :cat :sel :mthd |
        |categoryIsExtensionsPseudoCategory|

        categoryIsExtensionsPseudoCategory := (cat = nameListEntryForExtensions).
        (cls isNil and:[ cat isNil and:[ sel isNil ] ]) ifTrue:[
            enforceClassAndProtocolInList := true
        ] ifFalse:[
            cls notNil ifTrue:[
                allClasses add:cls.
            ].
            "/ JV: Filter method through package filter
            "/ but not, if it is an extension method and we are showing extensions
            (mthd notNil
                and:[ (mthd isSynthetic not or:[showSyntheticMethods value == true])
                and:[ sel notNil ]]
            ) ifTrue:[
                (packageFilterValue isNil
                    or:[ (packageFilterValue includes:mthd package)
                    or:[ categoryIsExtensionsPseudoCategory and:[ mthd isExtension] ]]
                ) ifTrue:[
                    entries add:(Array with:cls with:sel with:mthd).
                    selectorBag add:sel.
                    newClasses add:cls.

                    allCategories add:mthd category.
                    "/ allSelectors add:sel.
                ]
            ]
        ].
        (mthd notNil and:[ mthd isWrapped ]) ifTrue:[
            (mthd isTiming or:[ mthd isCounting or:[ mthd isCountingMemoryUsage ] ]) ifTrue:[
                anyMethodToWatch := true
            ]
        ].
    ].
    showMethodInheritance value ~~ false ifTrue:[
        "/ collect redefinition information once (big speedup for #methodIsRedefinedbelow)
        classAndSelectorsRedefinedBySubclassesOfClass isNil ifTrue:[
            classAndSelectorsRedefinedBySubclassesOfClass := IdentityDictionary new.
        ].
        allClasses do:[:cls |
            |d|

            d := classAndSelectorsRedefinedBySubclassesOfClass.
            (d notNil and:[ (d includesKey:cls) not ]) ifTrue:[
                cls isLoaded ifTrue:[
                    d at:cls put:(self setOfAllSelectorsImplementedBelow:cls)
                ]
            ]
        ].
    ].

    "/ multiple classes must: add the className for some

    doShowClass := enforceClassAndProtocolInList or:[ allClasses size > 1 ].

    "/ multiple categories: must add the categorie for some

    doShowCategory := enforceClassAndProtocolInList or:[ allCategories size > 1 ].

    doShowClassFirst := doShowClass.
    doShowClassFirst := doShowClass and:[ sortBy value == #class ].
    sortBy value == false ifTrue:[
        "/ do not sort
    ] ifFalse:[
        (doShowClass not and:[ sortBy value == #class ]) ifTrue:[
            "/ multiple classes must add the className for some
            "/ check, if doShowClass must be enforced
            entries do:[:entry |
                |cls sel mthd s needClass|

                "/ cls := entry at:1.
                sel := entry at:2.
                "/ mthd := entry at:3.
                doShowClass ifFalse:[
                    doShowClass := (selectorBag occurrencesOf:sel) > 1
                ].
            ].
        ].
        sortByClass := doShowClass and:[ sortBy value == #class ].
        sortByClass ifTrue:[
            entries
                sort:[:a :b |
                    |clsA clsB selA selB nmA nmB clsNmA clsNmB nsNmA nsNmB mthdA mthdB|

                    clsA := a at:1. clsB := b at:1.
                    clsNmA := clsA name.
                    clsNmB := clsB name.
                    clsNmA = clsNmB ifTrue:[
                        selA := a at:2. selB := b at:2.
                        nmA := selA asSymbol selectorWithoutNameSpace.
                        nmB := selB asSymbol selectorWithoutNameSpace.
                        nmA = nmB ifTrue:[
                            mthdA := a at:3. mthdB := b at:3.
                            nsNmA := mthdA nameSpaceName.
                            nsNmB := mthdB nameSpaceName.
                            nsNmA < nsNmB
                        ] ifFalse:[ nmA < nmB ]
                    ] ifFalse:[
                        clsNmA < clsNmB
                    ]
                ].
        ] ifFalse:[
            sortBy value == #category ifTrue:[
                entries
                    sort:[:a :b |
                        |mthdA mthdB selA selB clsA clsB nmA nmB catA catB clsNmA clsNmB nsNmA nsNmB|

                        mthdA := a at:3. mthdB := b at:3.
                        catA := mthdA category.
                        catB := mthdB category.
                        catA = catB ifTrue:[
                            selA := a at:2. selB := b at:2.
                            nmA := selA asSymbol selectorWithoutNameSpace.
                            nmB := selB asSymbol selectorWithoutNameSpace.
                            nmA = nmB ifTrue:[
                                clsA := a at:1. clsB := b at:1.
                                clsNmA := clsA name.
                                clsNmB := clsB name.
                                clsNmA = clsNmB ifTrue:[
                                    nsNmA := mthdA nameSpaceName.
                                    nsNmB := mthdB nameSpaceName.
                                    nsNmA < nsNmB
                                ] ifFalse:[
                                    clsNmA < clsNmB
                                ]
                            ] ifFalse:[ nmA < nmB ]
                        ] ifFalse:[
                            catA < catB
                        ]
                    ].
            ] ifFalse:[
                entries
                    sort:[:a :b |
                        |nmA nmB clsNmA clsNmB nsNmA nsNmB|

                        nmA := (a at:2) asSymbol selectorWithoutNameSpace.
                        nmB := (b at:2) asSymbol selectorWithoutNameSpace.
                        nmA = nmB ifTrue:[
                            clsNmA := (a at:1) name.
                            clsNmB := (b at:1) name.
                            clsNmA = clsNmB ifTrue:[
                                nsNmA := (a at:3) nameSpaceName.
                                nsNmB := (b at:3) nameSpaceName.
                                nsNmA < nsNmB
                            ] ifFalse:[
                                clsNmA < clsNmB
                            ]
                        ] ifFalse:[ nmA < nmB ]
                    ].
            ].
        ].
    ].
    methods := OrderedCollection new:(entries size).
    methodNameList := OrderedCollection new:(entries size).

    newNameList := OrderedCollection new:(entries size).

    "/ multiple classes must add the className for some

    entries do:[:entry |
        |cls sel mthd s needClass|

        cls := entry at:1.
        sel := entry at:2.
        mthd := entry at:3.
        needClass := doShowClass.

"/        needClass ifFalse:[
"/            needClass := (selectorBag occurrencesOf:sel) > 1
"/        ].
        (suppressInheritanceInfoNow not
        and:[ (Timestamp now secondDeltaFrom:startTime) > 3 ]) ifTrue:[
            suppressInheritanceInfoNow := true.
        ].

        s := self
                listEntryForMethod:mthd
                selector:sel
                class:cls
                showClass:needClass
                showCategory:doShowCategory
                classFirst:doShowClassFirst
                suppressInheritanceInfo:suppressInheritanceInfoNow.

        newNameList add:s.

        methods add:mthd.
        methodNameList add:{ cls name . sel}.
    ].
    
    self makeIndependent.
    classes := newClasses.
    self makeDependent.
    methodList := methods.
    methods size == 1 ifTrue:[
        theMethod := methods first.
        mclass := theMethod mclass.
        mclass isNil ifTrue:[
            theMethod isWrapped ifTrue:[
                theMethod := theMethod originalMethod.
                mclass := theMethod mclass.
            ].
        ].
        self methodLabelHolder 
                value:(mclass isNil
                    ifTrue:[ ('???' , ' ' , '???') ]
                    ifFalse:[ (mclass name ? '*unnamed*'), ' ' , (theMethod selector asString) ])
    ].
"/    anyMethodToWatch ifTrue:[
"/        self startWatchProcess.
"/    ] ifFalse:[
"/        self stopWatchProcess.
"/    ].

    "/ remember these, in case of an incremental (single method only)
    "/ update in the future.

    lastShowClass := doShowClass.
    lastShowClassFirst := doShowClassFirst.
    lastShowCategory := doShowCategory.
    ^ newNameList.

    "Created: / 05-02-2000 / 22:43:40 / cg"
    "Modified: / 24-08-2010 / 20:34:09 / Jan Vrany <enter your email here>"
    "Modified: / 20-07-2012 / 20:00:58 / cg"
    "Modified (comment): / 17-09-2013 / 10:31:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeDependent
    environment addDependent:self.
"/    ChangeSet addDependent:self.

    "Modified: / 10-11-2006 / 17:57:01 / cg"
!

makeIndependent
    environment removeDependent:self.
"/    ChangeSet removeDependent:self.
!

method:mthd includesModsOfClassVariable:variablesToHighLight
    ^ self method:mthd includesRefsToVariable:variablesToHighLight askParserWith:#modifiedClassVars
!

method:mthd includesModsOfInstanceVariable:variablesToHighLight
    ^ self method:mthd includesRefsToVariable:variablesToHighLight askParserWith:#modifiedInstVars
!

method:mthd includesRefsToClassVariable:variablesToHighLight
    ^ self method:mthd includesRefsToVariable:variablesToHighLight askParserWith:#usedClassVars
!

method:mthd includesRefsToInstanceVariable:variablesToHighLight
    ^ self method:mthd includesRefsToVariable:variablesToHighLight askParserWith:#usedInstVars
!

method:mthd includesRefsToVariable:variablesToHighLight askParserWith:querySelector
    |cls src parser usedVars anyVarNameAccessible|

    cls := mthd mclass.
    cls isNil ifTrue:[^ false].

    anyVarNameAccessible := cls allInstVarNames includesAny:variablesToHighLight.
    anyVarNameAccessible ifFalse:[
        anyVarNameAccessible := cls theNonMetaclass allClassVarNames includesAny:variablesToHighLight.
    ].
    anyVarNameAccessible ifFalse:[
        "/ no need to parse
        ^ false
    ].

    "/ JV Following code is just very bad. It assumes that method is a Smalltalk method.
    "/ But it may not, it could be JavaScript method, Java method or whatever fancy language
    "/ method. Should be actually delegated to the method itself, just as #messagesSend & co.

    "/ I'm not going to refactor now to keep the differences between jv-branch and CVS
    "/ ss small as possible. This interface is bad anyway as method is parsed several times
    "/ to check different things. Once should be enough.

    "/ Hack:

    mthd programmingLanguage isSmalltalk ifFalse:[
        ^ [
            usedVars := mthd perform:querySelector.
            usedVars includesAny:variablesToHighLight
        ] on: Error do:[
            false
        ]
    ].

    src := mthd source.
    src notNil ifTrue:[
        "
         before doing a slow parse, quickly scan the
         methods source for the variables name ...
        "
        (variablesToHighLight contains:[:varName | src includesString:varName ]) ifTrue:[
            parser := Parser
                            parseMethod:src
                            in:cls
                            ignoreErrors:true
                            ignoreWarnings:true.
            (parser notNil and:[parser ~~ #Error]) ifTrue:[
                usedVars := parser perform:querySelector.
                (usedVars includesAny:variablesToHighLight)
                ifTrue:[
                    ^  true
                ]
            ]
        ]
    ].
    ^ false

    "Modified: / 30-08-2013 / 13:46:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodIsInheritedFromAbove:aMethod
    |mClass|

    mClass := aMethod mclass.
    (mClass notNil and:[mClass superclass notNil]) ifTrue:[
	^ (mClass superclass whichClassIncludesSelector:aMethod selector) notNil.
    ].
    ^ false
!

methodIsRedefinedBelow:aMethod
    |mclass subClasses setOfRedefinedSelectors|

    mclass := aMethod mclass.
    mclass isNil ifTrue:[^ false].

    "/ if possible, make use of info prepared by listOfMethodNames
    classAndSelectorsRedefinedBySubclassesOfClass notNil
    ifTrue:[
	setOfRedefinedSelectors := classAndSelectorsRedefinedBySubclassesOfClass at:mclass ifAbsent:nil.
	setOfRedefinedSelectors notNil ifTrue:[
	    ^ setOfRedefinedSelectors includes:aMethod selector
	]
    ].

    lastMethodClass == mclass ifTrue:[
	subClasses := lastMethodClassesSubclasses
    ] ifFalse:[
	subClasses := aMethod mclass allSubclasses.
	lastMethodClassesSubclasses := subClasses.
	lastMethodClass := mclass.
    ].
    ^ subClasses contains:[:cls | cls includesSelector:aMethod selector].
!

redefinedOrInheritedIconFor:aMethod
    |inherited redefined subclassResponsibility|

    inherited := self methodIsInheritedFromAbove:aMethod.
    redefined := self methodIsRedefinedBelow:aMethod.

    inherited ifTrue:[
        redefined ifTrue:[
            ^ self methodInheritedFromAboveAndRedefinedBelowIcon.
        ].
        ^ self methodInheritedFromAboveIcon.
    ].

    subclassResponsibility := aMethod sendsAny:#( subclassResponsibility implementedBySubclass).
    redefined ifTrue:[
        subclassResponsibility ifTrue:[
            ^ self methodIsSubclassResponsibilityAndRedefinedBelowIcon.
        ].
        ^ self methodRedefinedBelowIcon.
    ].
    subclassResponsibility ifTrue:[
        ^ self methodIsSubclassResponsibilityIcon.
    ].

    ^ self methodEmptyInheritedIcon
!

release
    super release.

    filterClassVars removeDependent:self.
    selectedMethodNameIndices removeDependent:self.
    showMethodInheritance removeDependent:self.
    variableFilter removeDependent:self.
!

setOfAllSelectorsImplementedBelow:aClass
    |set|

    set := IdentitySet new.
    aClass allSubclassesDo:[:eachSubclass |
	set addAll:(eachSubclass methodDictionary keys).
    ].
    ^ set
!

updateList
    |prevSelection newList newSelection newSelIdx reverseMap sameContents newListSize oldListSize
     prevClasses methodSet selectedMethodsHolder|

    selectedMethodsHolder := self selectedMethods.
    prevSelection := selectedMethodsHolder value ? #().

    prevClasses := classes isNil ifTrue:[ #() ] ifFalse:[ classes copy ].

    oldListSize := self browserNameList size.

    self topApplication withWaitCursorDo:[
	newList := self listOfMethodNames.
    ].
    newListSize := newList size.
    sameContents := self updateListFor:newList.

    sameContents ifFalse:[
"/      self browserNameList value:newList.

	(prevSelection size == 0
	and:[selectedMethodsHolder value size ~~ 0]) ifTrue:[
	    "/ this happens during early startup time,
	    "/ when the selection is already (pre-)set,
	    "/ and the methodList is generated the first time
	    "/ (i.e. when opened with preset selection

	    "/ do not clobber the selection in this case.
	    prevSelection := selectedMethodsHolder value.
	].

	(methodList size == 0 or:[prevSelection size == 0]) ifTrue:[
	    newSelection := #()
	] ifFalse:[
	    methodSet := methodList.

	    "/ intersect is much faster with sets, if the number of items is large
	    "/ however, only if its worth building the set ...
	    (methodSet size + prevSelection size) > 35 ifTrue:[
		methodSet := methodSet asIdentitySet.
	    ].
	    newSelection := methodSet intersect:prevSelection.
	].
	newSelection size > 0 ifTrue:[
	    newSelection size > 100 ifTrue:[
		"/ need selection indices - might be expensive if done straight forward...
		reverseMap := IdentityDictionary new.
		methodList keysAndValuesDo:[:idx :mthd | reverseMap at:mthd put:idx].
		newSelIdx := newSelection collect:[:mthd | reverseMap at:mthd].
	    ] ifFalse:[
		newSelIdx := newSelection collect:[:mthd | methodList identityIndexOf:mthd]
	    ].
"/ self halt.
	    "/ force change (for dependents)
	    newSelIdx ~= selectedMethodNameIndices value ifTrue:[
		self selectedMethodNameIndices value:newSelIdx.
	    ].
	] ifFalse:[
	    lastSelectedMethods := selectedMethodsHolder value.
	    lastSelectedMethods notNil ifTrue:[
		lastSelectedMethods := lastSelectedMethods asOrderedCollection
	    ].
	    selectedMethodNameIndices value size > 0 ifTrue:[
		selectedMethodNameIndices value:#().
	    ]
	].

	newSelection ~= prevSelection ifTrue:[
	    self selectionChanged.
	]
    ] ifTrue:[
	"/ same list - but classes might have changed
	"/ that is the case, if the class selection has been changed,
	"/ to another class which has the same categories.

	(prevClasses ~= (classes ? IdentitySet new)) ifTrue:[
	    (newListSize > 0 or:[oldListSize > 0]) ifTrue:[
		self selectionChanged.
	    ]
	]
    ]

    "Modified: / 05-03-2007 / 16:07:24 / cg"
    "Modified: / 24-02-2014 / 11:08:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateListEntryFor:aMethod
    "update my list for a single method.
     (used when a single methods package, code or whatever changes, and a full udpate
      would be too slow)"

    |s idx|

    s := self
            listEntryForMethod:aMethod
            selector:aMethod selector ? '*unbound*'
            class:aMethod mclass
            showClass:lastShowClass
            showCategory:lastShowCategory
            classFirst:lastShowClassFirst
            suppressInheritanceInfo:false.

    idx := methodList identityIndexOf:aMethod.
    idx == 0 ifTrue:[
        aMethod isWrapped ifTrue:[
            idx := methodList identityIndexOf:aMethod originalMethod.
            idx == 0 ifTrue:[
                "/ aMethod (wrapped) has changed its status, but is not in the list.
                ^ self.
            ].
        ]
    ].
    idx == 0 ifTrue:[
        "/ method was not previously shown; try to avoid a full update
        "/ (self isMethodToBeShown:aMethod) ifTrue:[
            self invalidateList
        "/ ].
    ] ifFalse:[
        self browserNameList at:idx put:s.
    ]

    "Modified: / 16-10-2016 / 23:31:22 / cg"
! !

!MethodList methodsFor:'private-presentation'!

colorForCoverageInformationOfMethod:aMethod
    aMethod isInstrumented ifFalse:[^ nil].
    aMethod category = 'documentation' ifTrue:[^ nil].

    aMethod hasBeenCalled ifTrue:[
	aMethod haveAllBlocksBeenExecuted ifTrue:[
	    ^ UserPreferences current colorForInstrumentedFullyCoveredCode
	].
	^ UserPreferences current colorForInstrumentedPartiallyCoveredCode
    ].
    ^ UserPreferences current colorForInstrumentedNeverCalledCode

    "Created: / 30-04-2010 / 11:53:38 / cg"
!

listEntryForMethod:aMethod selector:selector class:cls showClass:showClass showCategory:showCategory classFirst:showClassFirst
    "answer a method list entry
     gimmics:
	adding a little image to breakPointed methods,
	inheritance indicators,
	highlight accessors of variable"

    ^ self
	listEntryForMethod:aMethod
	selector:selector
	class:cls
	showClass:showClass showCategory:showCategory
	classFirst:showClassFirst
	suppressInheritanceInfo:false
!

listEntryForMethod:aMethod selector:selector class:cls showClass:showClassArg showCategory:showCategory classFirst:showClassFirst suppressInheritanceInfo:suppressInheritanceInfo
    "answer a method list entry
     gimmics:
        adding a little image to breakPointed methods,
        inheritance indicators,
        highlight accessors of variable"

    |s icn variablesToHighlight classVarsToHighLight
     doHighLight doHighLightRed clr emp cat l redefIcon
     metrics complexity complexityString complexityIcon mark lastResultOrNil|

    aMethod isNil ifTrue:[
        "/ a non-existing (pseudo) method (such as required protocol)
        ^ selector withColor:Color red.
    ].

    (showClassFirst and:[cls notNil]) ifTrue:[        
        s := aMethod printStringForBrowserWithSelector:selector allBold inClass:cls.
        s := cls nameInBrowser , ' ' , s
    ] ifFalse:[
        s := aMethod printStringForBrowserWithSelector:selector inClass:cls.
    ].

    "/
    "/ wrap icons (i.e. break- or trace points on the method)
    "/ have higher prio ...
    "/
    (aMethod notNil and:[aMethod isWrapped]) ifTrue:[
        (s endsWith:' !!') ifTrue:[
            s := s copyButLast:2
        ].
        aMethod isBreakpointed ifTrue:[
            icn := self fullBreakPointedIcon.
        ] ifFalse:[
            aMethod isTimed ifTrue:[
                icn := self timeIcon
            ] ifFalse:[
                icn := self traceIcon
            ]
        ].
    ].

    "/
    "/ breakpoint icons (i.e. break- or trace points inside)
    "/
    icn isNil ifTrue:[
        (aMethod notNil and:[aMethod isMethodWithBreakpoints]) ifTrue:[
            aMethod hasEnabledBreakpoints ifTrue:[ 
                icn := self lineBreakPointedIcon
            ] ifFalse:[    
                aMethod hasEnabledTracepoints ifTrue:[ 
                    icn := self lineTracePointedIcon
                ] ifFalse:[    
                    icn := self disabledBreakpointIcon
                ]    
            ].
        ].
    ].

    icn isNil ifTrue:[
        self showImageResourceMethodsImages value ~~ false ifTrue:[
            (aMethod hasImageResource) ifTrue:[
                aMethod mclass isMeta ifTrue:[
                    icn := aMethod valueWithReceiver:nil arguments:nil .
                ].
            ].
        ].
    ].

    icn isNil ifTrue:[
        showMethodTypeIcon value ~~ false ifTrue:[
            icn := self resourceIconForMethod:aMethod.
        ].
        icn isNil ifTrue:[
            aMethod isProtected ifTrue:[
                icn := self protectedMethodIcon
            ] ifFalse:[
                aMethod isPrivate ifTrue:[
                    icn := self privateMethodIcon
                ] ifFalse:[
                    (aMethod isIgnored) ifTrue:[
                        icn := self ignoredMethodIcon
                    ] ifFalse:[
                        (aMethod isJavaMethod and:[aMethod isAbstract]) ifTrue:[
                            icn := self abstractMethodIcon
                        ]
                    ]
                ]
            ].
        ].
    ].
    (icn isNil and:[cls notNil]) ifTrue:[
        "/ (selector isSymbol and:[selector startsWith:'test']) ifTrue:[
        (((cls isTestCaseLike) and:[cls isAbstract not])
        or:[self showSyntheticMethods value and:[aMethod isSynthetic]]) ifTrue:[
            (cls isTestCaseLike and:[cls isTestSelector:selector]) ifTrue:[
                "JV@2011-11-17: Show thumbs even if not all test were run"

                lastResultOrNil := cls asTestCase rememberedOutcomeFor:selector.
                lastResultOrNil notNil ifTrue:[
                    |state|

                    state := lastResultOrNil result.
                    (state == TestResult statePass) ifTrue:[
                        icn := ToolbarIconLibrary testCasePassedIcon
                    ] ifFalse:[
                        (state == TestResult stateError) ifTrue:[
                            icn := ToolbarIconLibrary testCaseErrorIcon
                        ] ifFalse:[
                            (state == TestResult stateFail) ifTrue:[
                                icn := ToolbarIconLibrary testCaseFailedIcon
                            ] ifFalse:[
                                icn := ToolbarIconLibrary testCaseSkippedIcon
                            ]
                        ]
                    ]
                ].
            ].
        ]
    ].

    showClassArg ifTrue:[
        showClassFirst ifFalse:[
            s := s , ' [' , cls nameInBrowser allBold , ']'.
        ]
    ].
    (showCategory and:[aMethod mclass notNil and:[aMethod mclass supportsMethodCategories]]) ifTrue:[
        cat := aMethod category.
        cat notNil ifTrue:[
            s := s , ' {' , (cat "allItalic" withColor:Color gray), '}'
        ]
    ].

    (self showCoverageInformation value and:[(clr := self colorForCoverageInformationOfMethod:aMethod) notNil]) ifTrue:[
        s := self colorize:s with:(#color->clr).
        "/ aMethod isInstrumented ifTrue:[
        "/     icn := self instrumentationIcon
        "/ ].
    ] ifFalse:[
        (ChangeSet current includesChangeForClass:cls selector:selector) ifTrue:[
            mark := self class markForBeingInChangeList.
            "/ mark := self colorizeForChangedCode:mark.
            s := s , mark.
            "/ cg: I don't know why this was disabled - it is req'd to
            "/ see changed methods in a method list (implementors...)
            s := self colorizeForChangedCode:s.
        ].

        (SmallTeam notNil and:[SmallTeam includesChangeForClass:cls selector:selector]) ifTrue:[
            s := (self colorizeForChangedCodeInSmallTeam:'!! '),s
        ].
    ].

    variablesToHighlight := variableFilter value.
    variablesToHighlight size > 0 ifTrue:[
        classVarsToHighLight := filterClassVars value.
        classVarsToHighLight ifTrue:[
            doHighLight := self method:aMethod includesRefsToClassVariable:variablesToHighlight.
            doHighLight ifTrue:[
                doHighLightRed := self method:aMethod includesModsOfClassVariable:variablesToHighlight.
            ].
        ] ifFalse:[
            doHighLight := self method:aMethod includesRefsToInstanceVariable:variablesToHighlight.
            doHighLight ifTrue:[
                doHighLightRed := self method:aMethod includesModsOfInstanceVariable:variablesToHighlight
            ]
        ].
        doHighLight ifTrue:[
            s := s allBold.
            doHighLightRed ifTrue:[
                emp := (UserPreferences current emphasisForWrittenVariable)
            ] ifFalse:[
                emp := (UserPreferences current emphasisForReadVariable)
            ].
            s := s emphasisAllAdd:emp
        ]
    ].

    (showMethodComplexity value == true
    and:[ OOM::MethodMetrics notNil ]) ifTrue:[
        icn isNil ifTrue:[
                metrics := OOM::MethodMetrics forMethod:aMethod.
                complexity := metrics complexity ? 0.
                complexityIcon := OOM::MethodMetrics iconForComplexity:complexity.

                ShowComplexityValue == true ifTrue:[
                    complexityString := '{' , complexity printString , '}'.
                    s := complexityString , ' ' , s.
                ].
                "/ icn := icn ? complexityIcon.
                s := LabelAndIcon icon:complexityIcon string:s.
        ].
    ].

    (showMethodInheritance value ? true) ifTrue:[
        suppressInheritanceInfo ifTrue:[
            redefIcon := self methodEmptyInheritedIcon.
        ] ifFalse:[
            redefIcon := self redefinedOrInheritedIconFor:aMethod.
        ].
    ].

    (icn notNil or:[redefIcon notNil]) ifTrue:[
        "/eXept version
        "/l := LabelAndIcon icon:redefIcon string:s.
        "/l image:icn.
        "/JV:
        l := LabelAndIcon icon:icn string:s.
        l image:redefIcon.
        icn isNil ifTrue:[l offset: 13].
        l gap:1.
        ^ l
    ].
    ^ s

    "Created: / 22-10-1996 / 19:51:00 / cg"
    "Modified: / 15-08-2009 / 13:13:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-03-2012 / 19:06:09 / cg"
    "Modified: / 27-07-2016 / 00:05:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resourceIconForMethod:aMethod
    ^ SystemBrowser resourceIconForMethod:aMethod

    "Modified: / 17-08-2006 / 09:09:01 / cg"
! !

!MethodList methodsFor:'private-watching'!

startWatchProcess
    updateProcess notNil ifTrue:[
	^ self
    ].
    updateProcess := [
			[true] whileTrue:[
			    Delay waitForSeconds:1.
			    self enqueueDelayedUpdateList
			]
		     ] fork.
!

stopWatchProcess
    |p|

    (p := updateProcess) notNil ifTrue:[
	updateProcess := nil.
	p terminate
    ].
! !

!MethodList methodsFor:'setup'!

postBuildWith:aBuilder
    |methodListView|

    super postBuildWith:aBuilder.

    methodListView := aBuilder componentAt:'List'.
    methodListView notNil ifTrue:[
	methodListView allowDrag:true.
	methodListView dragObjectConverter:[:obj |
					    |nm method idx|

					    nm := obj theObject asString string string.
					    idx := browserNameList value findFirst:[:item | item string string = nm].
					    method := methodList value at:idx.
					    DropObject newMethod:method.
					 ].
    ]
! !

!MethodList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

