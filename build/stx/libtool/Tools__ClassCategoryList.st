"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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

BrowserList subclass:#ClassCategoryList
	instanceVariableNames:'categoryList classes allSelected showPseudoCategories
		rawCategoryList cookedCategoryList categoryListView'
	classVariableNames:'AdditionalEmptyCategories'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!ClassCategoryList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    embeddable application displaying the class-categories.
    Provides an outputGenerator, which enumerates the classes in
    the selected categories.

    [author:]
	Claus Gittinger (cg@exept.de)
"
! !

!ClassCategoryList class methodsFor:'interface specs'!

singleCategoryWindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ClassCategoryList andSelector:#singleCategoryWindowSpec
     ClassCategoryList new openInterface:#singleCategoryWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #singleCategoryWindowSpec
	#window: 
       #(#WindowSpec
	  #label: 'ClassCategoryList'
	  #name: 'ClassCategoryList'
	  #min: #(#Point 0 0)
	  #max: #(#Point 1024 721)
	  #bounds: #(#Rectangle 218 175 518 475)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'ClassCategoryName'
	      #name: 'ClassCategoryLabel'
	      #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 25 0)
	      #translateLabel: true
	      #labelChannel: #classCategoryLabelHolder
	      #menu: #menuHolder
	    )
	   )
         
	)
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ClassCategoryList andSelector:#windowSpec
     Tools::ClassCategoryList new openInterface:#windowSpec
     Tools::ClassCategoryList open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'ClassCategoryList'
          name: 'ClassCategoryList'
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
              model: selectedCategories
              menu: menuHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              isMultiSelect: true
              valueChangeSelector: selectionChangedByClick
              useIndex: false
              sequenceList: categoryList
              doubleClickChannel: doubleClickChannel
              properties: 
             (PropertyListDictionary
                canDropSelector: canDropContext:
                dragArgument: nil
                dropArgument: nil
                dropSelector: doDropContext:
              )
              postBuildCallback: postBuildCategoryListView:
            )
           )
         
        )
      )
! !

!ClassCategoryList class methodsFor:'plugIn spec'!

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
        #forceGeneratorTrigger
        #hideUnloadedClasses
        #immediateUpdate
        #inGeneratorHolder
        #menuHolder
        #nameSpaceFilter
        #organizerMode
        #outGeneratorHolder
        #packageFilter
        #selectedCategories
        #selectionChangeCondition
        #showCoverageInformation
        #slaveMode
        #updateTrigger
      ).

    "Modified: / 24-02-2014 / 10:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassCategoryList class methodsFor:'special'!

addAdditionalCategory:aCategory
    "/ those are simulated - in ST/X, empty categories do not
    "/ really exist; however, during browsing, it makes sense.

    AdditionalEmptyCategories isNil ifTrue:[
        AdditionalEmptyCategories := Set new.
    ].
    AdditionalEmptyCategories add:aCategory.
    Smalltalk changed:#organization with:(nil -> aCategory).  "/ not really ... to force update
!

removeAdditionalCategories:aListOfCategories
    "/ those are simulated - in ST/X, empty categories do not
    "/ really exist; however, during browsing, it makes sense.

    AdditionalEmptyCategories isNil ifTrue:[^ self].
    aListOfCategories do:[:eachCategory |
        AdditionalEmptyCategories remove:eachCategory ifAbsent:nil.
    ].

    Smalltalk changed:#organization   "/ not really ... to force update
!

removeAllAdditionalCategories
    "/ those are simulated - in ST/X, empty categories do not
    "/ really exist; however, during browsing, it makes sense.

    AdditionalEmptyCategories := nil
!

renameAdditionalCategories:oldNames to:newName
    "/ those are simulated - in ST/X, empty categories do not
    "/ really exist; however, during browsing, it makes sense.

    self removeAdditionalCategories:oldNames.
    self addAdditionalCategory:newName.
! !

!ClassCategoryList methodsFor:'aspects'!

categoryList
    categoryList isNil ifTrue:[
	categoryList := ValueHolder new.
    ].
    ^ categoryList

    "Created: / 25.2.2000 / 02:23:08 / cg"
!

categoryList:aValueHolder
    categoryList notNil ifTrue:[
	categoryList removeDependent:self
    ].
    categoryList := aValueHolder.
    categoryList notNil ifTrue:[
	categoryList addDependent:self
    ].

    "Created: / 18.8.2000 / 15:21:42 / cg"
!

classCategoryLabelHolder
    ^ self pseudoListLabelHolder
!

selectedCategories
    ^ self selectionHolder 
!

selectedCategories:aValueHolder
    ^ self selectionHolder:aValueHolder
!

selectionHolder
"/    self halt.
    ^ super selectionHolder
!

selectionHolder:aValueHolder
    "/ self halt.
    super selectionHolder:aValueHolder
! !

!ClassCategoryList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    |selectedCategories allSelectedBefore 
     nameListEntryForALL cls categoryOfClass wg|

    selectedCategories := self selectedCategoriesStrings.

    "/ if many individual method changes arrive (when loading a package or filing in),
    "/ these are condensed into updates of self - updateCategoryForChangedMethod with class as param.
    changedObject == self ifTrue:[
        something == #updateCategoryForChangedMethod ifTrue:[
            | class |

            class := aParameter.
            categoryOfClass := class category.
            (rawCategoryList includes:categoryOfClass) ifTrue:[
                self colorizeCategoryAsChanged:categoryOfClass
             ]. 
             ^ self.
        ].
    ].

    changedObject == environment ifTrue:[
        (something == #methodDictionary
        or:[ something == #methodInClass 
        or:[ something == #classComment
        or:[ something == #methodInClassRemoved ]]]) ifTrue:[ 
            "/ Class has been modified, must update list (color & boldness)
            "/ send another delayed update, so all notifications for a single class
            "/ will be condensed into a single update.
            | class |

            class := aParameter isArray ifTrue:[ aParameter first ] ifFalse:[ aParameter ].
            class isBehavior ifFalse:[ 
                self breakPoint: #jv.
            ] ifTrue:[
                listValid == false ifTrue:[
                    ^ self
                ].
                self window sensor userEventCount > 100 ifTrue:[
                    self invalidateList.
                    ^ self
                ].
                self enqueueDelayedUpdate:#updateCategoryForChangedMethod with:class from:self.
            ].
             ^ self.
        ].
        "/ Care for condensing current changeset.
        (something == #currentChangeSet) ifTrue:[
            "/ List of categories does not change, so all we have
            "/ to do is to update cookedCategoryList and redraw.

            self listOfCategories. "/ This has the sideeffect to update cookedCategoryList.
            categoryListView notNil ifTrue:[
                categoryListView invalidate.
            ]
        ].

        ((something == #classVariables) 
        or:[something == #classDefinition]) ifTrue:[
            listValid == true ifTrue:[
                categoryOfClass := aParameter category.
                (rawCategoryList includes:categoryOfClass) ifFalse:[
                    self invalidateList.                
                ].
                slaveMode value ~~ true ifTrue:[
                    (selectedCategories includes:categoryOfClass) ifTrue:[
                        "/ a selected class has changed
                        "/ in order to give others a chance to update their list before,
                        "/ this one is always enqueued for delayed update (even if immediateUpdate is true)
                        "/ self enqueueDelayedUpdateOutputGenerator
                        self enqueueMessage:#updateOutputGenerator for:self arguments:#()
                    ].
                ].
            ].
            ^ self
        ].
        something == #newClass ifTrue:[
            categoryOfClass := aParameter category.
            listValid == false ifTrue:[
                ^ self
            ].

            (rawCategoryList includes:categoryOfClass) ifFalse:[
                self invalidateList.                
            ].

            slaveMode value ~~ true ifTrue:[
                (selectedCategories includes:categoryOfClass) ifTrue:[
                    self enqueueDelayedUpdateOutputGenerator
                ].
            ].
            ^ self
        ].
        something == #projectOrganization ifTrue:[
            listValid == false ifTrue:[
                ^ self
            ].
            aParameter isNil ifTrue:[
                self invalidateList.                
                slaveMode value ~~ true ifTrue:[
                    selectedCategories notEmptyOrNil ifTrue:[
                        self enqueueDelayedUpdateOutputGenerator
                    ].
                ]
            ] ifFalse:[
                cls := aParameter first.
                categoryOfClass := cls category.

                (rawCategoryList includes:categoryOfClass) ifFalse:[
                    self invalidateList.                
                ].

                slaveMode value ~~ true ifTrue:[
                    (selectedCategories includes:categoryOfClass) ifTrue:[
                        self enqueueDelayedUpdateOutputGenerator
                    ].
                ]
            ].
            ^ self
        ].

        self invalidateList.

        (something == #classRemove 
        or:[something == #projectOrganization 
        or:[something == #organization]]) ifTrue:[
            slaveMode value ~~ true ifTrue:[
                "/ sorry: cannot filter on category (already changed to #removed)
                self enqueueDelayedUpdateOutputGenerator
            ].
        ].
        ^ self
    ].

    changedObject == ChangeSet ifTrue:[
        "/ remove all other change notifications from the eventQueue
        wg := self windowGroup.
        wg isNil ifTrue:[
            "/ oops - should no longer be dependent...
            changedObject removeDependent:self.
        ] ifFalse:[
            wg sensor 
                flushEventsFor:self 
                where:[:ev | ev isMessageSendEvent 
                             and:[ev selector == #delayedUpdate:with:from:
                             and:[(ev arguments at:3) == ChangeSet]]].
        ].

        something == #addChange: ifTrue:[
            "/ only need to invalidate, if that change changes my emphasis 
            "/ (i.e. if its a new methodChange)
            self window topView shown ifFalse:[
                self invalidateList.
                ^ self
            ].

            aParameter isMethodChange ifTrue:[
                aParameter changeClass notNil ifTrue:[
                    (ChangeSet current 
                        count:[:chg | chg notNil 
                                      and:[chg isMethodChange
                                      and:[ chg className = aParameter className ]]]) == 1 
                    ifTrue:[
                        "/ that methodChange is the first for this method.
                        self colorizeCategoryAsChanged:(aParameter changeClass category).
                    ]
                ]
            ].
            ^ self
        ].

        self invalidateList.
        ^ self
    ].

    changedObject == nameSpaceFilter ifTrue:[
        "/ all might be more or less than before ...
        allSelected := false.
        "/ self invalidateList - done in super
    ].
    changedObject == packageFilter ifTrue:[
        "/ all might be more or less than before ...
        allSelected := false.
        "/ self invalidateList - done in super
    ].

    changedObject == self selectedCategories ifTrue:[
        listValid ifFalse:[
            "/ oops - hurry up
            self invalidateList.
        ].

        nameListEntryForALL := self class nameListEntryForALL.

        selectedCategories size > 1 ifTrue:[
            (selectedCategories includes:nameListEntryForALL) ifTrue:[
                self makeSelectionOtherThanAllVisible.
            ]
        ].

        "/ if all selected before AND allSelected after, no need to update the output generator
        allSelectedBefore := allSelected ? false.
        allSelected := selectedCategories includes:nameListEntryForALL.
        (allSelectedBefore and:[allSelected]) ifTrue:[
            ^ self
        ].
    ].
    changedObject == categoryList ifTrue:[
        self breakPoint:#cg.
    ].
    super delayedUpdate:something with:aParameter from:changedObject

    "Created: / 05-02-2000 / 13:42:12 / cg"
    "Modified: / 12-11-2001 / 19:36:16 / cg"
    "Modified: / 27-03-2014 / 11:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forceUpdateList
    self categoryList setValue:#().
    self updateList.
    self categoryList changed.
!

selectionChangedByClick
    "we are not interested in that - get another notification
     via the changed valueHolder"

    "Created: / 11.2.2000 / 11:39:48 / cg"
!

update:something with:aParameter from:changedObject
    |categoryOfClass|

    loadInProgress ifTrue:[
        something == #newClass ifTrue:[
            rawCategoryList isNil ifTrue:[
                "/ may affect me
                self invalidateList.
                ^ self.
            ].

            categoryOfClass := aParameter category.
            (self selectedCategoriesStrings includes:categoryOfClass) ifTrue:[
                "/ affects me
                self enqueueMessage:#updateOutputGenerator for:self arguments:nil.
                ^ self.
            ].
            ((rawCategoryList ? #()) includes:categoryOfClass) ifTrue:[
                ^ self
            ].
            self invalidateList.
            ^ self
        ].
        something == #projectOrganization ifTrue:[
            ^ self
        ].
"/ self halt.
    ].

    changedObject == environment ifTrue:[
        (something == #methodTrap
        or:[ something == #methodCoverageInfo
        or:[ something == #lastTestRunResult
"/        or:[ something == #methodDictionary
"/        or:[ something == #methodInClass 
"/        or:[ something == #classComment
"/        or:[ something == #methodInClassRemoved ]]]]
        ]]) ifTrue:[
            ^ self
        ].

        (something == #classVariables
        or:[something == #classDefinition]) ifTrue:[
            categoryOfClass := aParameter category.
            (self selectedCategoriesStrings includes:categoryOfClass) ifTrue:[
                "/ self halt.
                self updateOutputGenerator.                
            ].
        ].
"/        something == #prePackageLoad ifTrue:[
"/            "/ self halt.
"/            ^ self
"/        ].
"/        something == #postPackageLoad ifTrue:[
"/            "/ self halt.
"/            ^ self
"/        ].
    ].

"/    changedObject == ChangeSet ifTrue:[
"/        something == #addChange: ifTrue:[
"/            ^ self
"/        ]
"/    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 20-07-2011 / 18:50:04 / cg"
    "Modified: / 23-04-2015 / 11:55:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassCategoryList methodsFor:'drag & drop'!

canDropContext:aDropContext
    |cat objects droppedClasses|

    objects := aDropContext dropObjects collect:[:obj | obj theObject].
    (self objectsAreClassFiles:objects) ifTrue:[^ true].

    (objects conform:[:aClass | aClass isClass]) ifFalse:[^ false].
    droppedClasses := objects.
    (droppedClasses contains:[:aClass | aClass isPrivate not]) ifFalse:[^ false].

    cat := self categoryAtTargetPointOf:aDropContext.
    (cat isNil 
      or:[ (cat = '* obsolete *')
      or:[ (cat = #'* as yet unknown category *')
      or:[ self class isPseudoCategory:cat ]]])
        ifTrue:[ ^  false ].

    (droppedClasses contains:[:aClass | aClass category ~= cat]) ifFalse:[^ false].
    ^ true.

    "Modified: / 17-10-2006 / 18:28:04 / cg"
!

categoryAtTargetPointOf:aDropContext
    |p categoryListView lineNr cat|

    p := aDropContext targetPoint.

    categoryListView := aDropContext targetWidget.

    lineNr := categoryListView lineAtY:p y.
    lineNr isNil ifTrue:[^ nil].

    cat := rawCategoryList at:lineNr.
    cat := cat string.
    cat = self class nameListEntryForALL ifTrue:[^ nil].

    (cat endsWith:(self stringForExtensions)) ifTrue:[
        cat := cat copyButLast:(self stringForExtensions size)
    ].
    ^ cat
!

doDropContext:aDropContext
    |cat objects|

    objects := aDropContext dropObjects collect:[:aDropObject | aDropObject theObject].
    (objects conform:[:something | something isClass]) ifTrue:[
        cat := self categoryAtTargetPointOf:aDropContext.
        (cat isNil 
          or:[ (cat = '* obsolete *')
          or:[ self class isPseudoCategory:cat ]])
        ifFalse:[
            self masterApplication moveClasses:objects toCategory:cat.
        ].
        ^ self
    ].
    (objects conform:[:something | something isFilename]) ifTrue:[
        self dropClassFiles:objects.
        ^ self
    ].

    "Modified: / 17-10-2006 / 18:29:25 / cg"
! !

!ClassCategoryList methodsFor:'generators'!

makeGenerator
    "return a generator which enumerates the classes from the selected category."

    |cats hideUnloadedClasses allName nameSpaceFilter packageFilter 
     showChangedClasses showUnloaded showUndocumented showExtendedClasses inclusionTest changedClasses|

    cats := self selectedCategoriesStrings.
    cats size == 0 ifTrue:[
        ^ #()
    ].

    allName := self class nameListEntryForALL.

    (cats includes:allName) ifTrue:[
        inGeneratorHolder value isOrderedCollection ifTrue:[
            cats := rawCategoryList copyWithout:allName.
        ]
    ].

    showChangedClasses := cats includes:(self class nameListEntryForChanged).
    showUnloaded := cats includes:(self class nameListEntryForUnloaded).
    showUndocumented := cats includes:(self class nameListEntryForUndocumented).
    showExtendedClasses := cats includes:(self class nameListEntryForExtendedClasses).

    hideUnloadedClasses := self hideUnloadedClasses value ? false.
    nameSpaceFilter := self nameSpaceFilter value.
    nameSpaceFilter notNil ifTrue:[
        (nameSpaceFilter includes:allName) ifTrue:[nameSpaceFilter := nil].
    ].
    packageFilter := self packageFilter value.
    packageFilter notNil ifTrue:[
        packageFilter := packageFilter collect:[:p | p withoutSeparators].
        (packageFilter includes:allName) ifTrue:[packageFilter := nil].
    ].

    (cats includes:allName) ifTrue:[
        hideUnloadedClasses ifTrue:[
            inclusionTest := [:cls | cls isLoaded].
        ] ifFalse:[
            inclusionTest := [:cls | true].
        ].
    ] ifFalse:[
        inclusionTest := 
            [:cls | 
                |cat isLoaded included|

                isLoaded := cls isLoaded.
                included := isLoaded not and:[ showUnloaded ].
                included ifFalse:[
                    (hideUnloadedClasses not or:[isLoaded]) ifTrue:[
                        cat := cls category ? '* no category *'.
                        included := cats includes:cat.
                        included ifFalse:[
                            included := showChangedClasses 
                                        and:[ (changedClasses includes:cls theNonMetaclass)
                                                or:[(changedClasses includes:cls theMetaclass)] ].
                            included ifFalse:[
                                included := showUndocumented 
                                            and:[ isLoaded 
                                            and:[ cls isPrivate not    
                                            and:[ (cls theMetaclass includesSelector:#documentation) not ]]].
                                included ifFalse:[
                                    included := showExtendedClasses
                                                and:[ cls hasExtensions ].
                                ].
                            ].
                        ].
                    ].
                ].
                included
            ].
    ].

    ^ Iterator on:[:whatToDo |
            showChangedClasses ifTrue:[ changedClasses := ChangeSet current changedClasses ].

            environment allClassesDo:[:cls |
                (cls isRealNameSpace) ifFalse:[
                    (inclusionTest value:cls) ifTrue:[
                        (nameSpaceFilter isNil
                        or:[self isClass:cls shownWithNameSpaceFilter:nameSpaceFilter]) ifTrue:[
                            (packageFilter isNil
                            or:[self isClass:cls shownWithPackageFilter:packageFilter]) ifTrue:[
                                whatToDo value:cls
                            ]
                        ]
                    ].
                ].
            ].
        ].

    "Created: / 05-02-2000 / 13:42:12 / cg"
    "Modified: / 10-11-2006 / 17:13:26 / cg"
! !

!ClassCategoryList methodsFor:'initialize-release'!

commonPostBuild
    |listView|

    listView := self listView.
    listView notNil ifTrue:[
        listView scrollWhenUpdating:nil
    ].
    super commonPostBuild
!

commonPostOpen
    super commonPostOpen.
    listValid ifFalse:[
        self enqueueDelayedUpdateList.
        self enqueueMessage:#xUpdateOutputGenerator for:self arguments:nil.
        "/ self enqueueMessage:#updateSelectionIndexFromSelection for:self arguments:nil. "/ #().
    ]. 
!

postBuildCategoryListView:aView
    categoryListView := aView.
    categoryListView visualBlock:[:view :lineNr | cookedCategoryList at:lineNr].
    categoryListView selectedVisualBlock:[:view :lineNr | (cookedCategoryList at:lineNr) "string"withoutAnyColorEmphasis]

    "Modified: / 26-03-2014 / 09:21:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassCategoryList methodsFor:'private'!

colorizeCategoryAsChanged:category
    | idx |

    idx := rawCategoryList indexOf: category.
    idx ~~ 0 ifTrue:[ 
        | oldEntry newEntry |

        oldEntry := cookedCategoryList at: idx.
        newEntry := self listEntryForCategory: category.
        (oldEntry sameStringAndEmphasisAs:newEntry) ifFalse:[
            cookedCategoryList at: idx put: newEntry.
            categoryListView notNil ifTrue:[
                categoryListView invalidate.
            ].
        ].
    ].


"/ OLD CODE
"/    |colorizedCategoryItem categoryList idx|
"/
"/    colorizedCategoryItem := self colorizeForChangedCode:category copy asText.
"/
"/    categoryList := self categoryList value.
"/    idx := categoryList indexOf:category.
"/    idx ~~ 0 ifTrue:[
"/        ((categoryList at:idx) sameStringAndEmphasisAs:colorizedCategoryItem) ifFalse:[
"/            categoryList at:idx put:colorizedCategoryItem.
"/            self categoryList changed.
"/        ]
"/    ].

    "Modified: / 26-03-2014 / 09:39:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listOfCategories
    |categories categoriesBag hideUnloadedClassesValue generator nameSpaceFilterValue packageFilterValue allName
     categoriesWithExtensions categoriesWithChangedCode categoriesWithRemoteChangedCode
     classesInChangeSet classesInRemoteChangeSet classesWithExtensions
     numClassesInChangeSet numUnloaded numUndocumented 
     pseudoEntryColor showCounts|

    showCounts := true.

    allName := self class nameListEntryForALL.

    hideUnloadedClassesValue := self hideUnloadedClasses value.
    nameSpaceFilterValue := self nameSpaceFilter value.
    nameSpaceFilterValue notNil ifTrue:[
        (nameSpaceFilterValue includes:allName) ifTrue:[nameSpaceFilterValue := nil].
    ].
    packageFilterValue := self packageFilter value.
    packageFilterValue notNil ifTrue:[
        (packageFilterValue includes:allName) ifTrue:[packageFilterValue := nil].
    ].

    numUndocumented := numUnloaded := numClassesInChangeSet := 0.

    categories := Set new.
    categoriesBag := Bag new.
    categoriesWithExtensions := Set new.
    categoriesWithChangedCode := Set new.
    categoriesWithRemoteChangedCode := Set new.

    classesInChangeSet := ChangeSet current changedClasses.
    classesInChangeSet := classesInChangeSet collect:[:eachClass | eachClass theNonMetaclass].
    numClassesInChangeSet := classesInChangeSet size.

    classesInRemoteChangeSet := SmallTeam isNil ifTrue:[#()] ifFalse:[ SmallTeam changedClasses ].
    classesInRemoteChangeSet := classesInRemoteChangeSet collect:[:each | each theNonMetaclass].

    classesWithExtensions := IdentitySet new.

    classes := IdentitySet new.
    inGeneratorHolder isNil ifTrue:[
        environment allClassesDo:[:cls | 
            |cat isLoaded|

            (cls isRealNameSpace) ifFalse:[
                (nameSpaceFilterValue isNil
                or:[self isClass:cls shownWithNameSpaceFilter:nameSpaceFilterValue]) ifTrue:[
                    (packageFilterValue isNil
                    or:[self isClass:cls shownWithPackageFilter:packageFilterValue]) ifTrue:[

                        isLoaded := cls isLoaded.
                        isLoaded ifTrue:[ 
                            cls isPrivate ifFalse:[  
                                (cls theMetaclass includesSelector:#documentation) ifFalse:[
                                    numUndocumented := numUndocumented + 1.
                                ].
                            ].
                        ] ifFalse:[
                            numUnloaded := numUnloaded + 1.
                        ].

                        (hideUnloadedClassesValue not or:[isLoaded])
                        ifTrue:[
                            cat := cls category ? '* no category *'.
                            cat isString ifFalse:[self halt:'oops - strange category'].
                            categories add:cat.
                            classes add:cls.
                            categoriesBag add:cat.

                            (classesInChangeSet includes:cls theNonMetaclass) ifTrue:[
                                categoriesWithChangedCode add:cat
                            ].
                            (classesInRemoteChangeSet includes:cls theNonMetaclass) ifTrue:[
                                categoriesWithRemoteChangedCode add:cat
                            ].
                            cls hasExtensions ifTrue:[
                                categoriesWithExtensions add:cat.
                                classesWithExtensions add:cls.
                            ].
                        ]
                    ]
                ]
            ]
        ].

        "/ those are simulated - in ST/X, empty categories do not
        "/ really exist; however, during browsing, it makes sense.
        AdditionalEmptyCategories size > 0 ifTrue:[
            "/ remove those that are present ...
            AdditionalEmptyCategories := AdditionalEmptyCategories reject:[:cat | (categories includes:cat)].
            categories addAll:AdditionalEmptyCategories.
            categoriesBag addAll:AdditionalEmptyCategories withOccurrences:0.
        ].
    ] ifFalse:[
        |setOfCategories|

        generator := inGeneratorHolder value.
        generator isNil ifTrue:[^ #() ].
        setOfCategories := Set withAll:generator.
        generator do:[:cat | categories add:cat string].
        
        environment allClassesDo:[:eachClass |
            |cat|

            eachClass isNameSpace ifFalse:[
                cat := eachClass category string asSymbol.
                (setOfCategories includes:cat) ifTrue:[
                    categoriesBag add:cat.
                ].
            ]
        ].
    ].

    pseudoEntryColor := self class pseudoEntryForegroundColor.

    categories := categories asOrderedCollection.

    categories sort.
    rawCategoryList := categories.

    categories := 
        categories collect:[:cat |
            self listEntryForCategory: cat numClasses: (categoriesBag occurrencesOf:cat) showCounts: showCounts pseudoEntryColor: pseudoEntryColor
                hasLocalChangedCode: (categoriesWithChangedCode includes:cat) 
                hasRemoteChangedCode: (categoriesWithRemoteChangedCode includes:cat) 
                hasExtensions: (categoriesWithExtensions includes:cat)
        ].

    numUndocumented > 0 ifTrue:[
        rawCategoryList add:self class nameListEntryForUndocumented.
        categories add:((self class nameListEntryForUndocumentedWithCount bindWith:numUndocumented) allItalic withColor:pseudoEntryColor).
    ].
    numUnloaded > 0 ifTrue:[
        rawCategoryList add:self class nameListEntryForUnloaded.
        categories add:((self class nameListEntryForUnloadedWithCount bindWith:numUnloaded) allItalic withColor:pseudoEntryColor).
    ].
    (classesWithExtensions size > 0) ifTrue:[
        rawCategoryList add:self class nameListEntryForExtendedClasses.
        categories add:((self class nameListEntryForExtendedClassesWithCount bindWith:(classesWithExtensions size)) allItalic withColor:pseudoEntryColor).
    ].
    numClassesInChangeSet > 0 ifTrue:[
        rawCategoryList addFirst:self class nameListEntryForChanged.
        categories addFirst:((self class nameListEntryForChangedWithCount bindWith:numClassesInChangeSet) allItalic withColor:pseudoEntryColor).
    ].

    categories size > 0 ifTrue:[
        categories size == 1 ifTrue:[
            self classCategoryLabelHolder value:(categories first)
        ].
        rawCategoryList addFirst:self class nameListEntryForALL.
        categories addFirst:((self class nameListEntryForALLWithCount bindWith:(classes size)) allItalic withColor:pseudoEntryColor).
    ].

    cookedCategoryList := categories.
    ^ rawCategoryList.

    "Created: / 05-02-2000 / 13:42:12 / cg"
    "Modified: / 27-10-2012 / 12:34:19 / cg"
    "Modified: / 26-03-2014 / 08:53:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listView 
    ^ self componentAt:#List
!

makeDependent
    environment addDependent:self.
    ChangeSet addDependent:self.

    "Created: / 5.2.2000 / 13:42:13 / cg"
!

makeIndependent
    environment removeDependent:self.
    ChangeSet removeDependent:self.

    "Created: / 5.2.2000 / 13:42:13 / cg"
!

makeItemVisible:item
    |idx listView|

    idx := categoryList value indexOf:item.
    idx ~~ 0 ifTrue:[
        (listView := self listView) notNil ifTrue:[
            listView makeLineVisible:idx.
        ]
    ]
!

makeSelectionOtherThanAllVisible
    |selectedCategories item|

    selectedCategories := self selectedCategoriesStrings.
    "/ the first item after the *all* item
    item := (selectedCategories copy remove:self class nameListEntryForALL; yourself) first.
    self makeItemVisible:item.
!

release
    super release.

    categoryList removeDependent:self.
!

selectedCategoriesStrings
    |selectedCategories stringForExtensions|

    stringForExtensions := self stringForExtensions.

    selectedCategories := self selectedCategories value ? #().

"/    selectedCategories := selectedCategories 
"/                collect:[:each | 
"/                                |s|
"/                                s := each string.
"/                                (s endsWith:stringForExtensions) ifTrue:[
"/                                    s := s copyWithoutLast:(stringForExtensions size).
"/                                ].
"/                                s
"/                        ].
    ^ selectedCategories

    "Modified: / 23-08-2006 / 11:38:26 / cg"
!

stringForExtensions
    ^ ' [ + ]'
!

updateList
    |oldList newList oldSelection newSelection prevClasses
     selectedCategoriesHolder|

    selectedCategoriesHolder := self selectedCategories.
    oldSelection := selectedCategoriesHolder value ? #().
    prevClasses := classes "copy".

    newList := self listOfCategories.    "/ sigh - sideeffect of setting rawList
    oldList := (self categoryList value) ? #().
    (newList sameContentsAs:oldList whenComparedWith:[:a :b | a sameStringAndEmphasisAs: b]) 
    ifFalse:[
        "/ a real change, or only emphasis ?
        (newList sameContentsAs:oldList whenComparedWith:[:a :b | a asString string = b asString string]) ifTrue:[
            "/ only emphasis 

            oldSelection notEmpty ifTrue:[
                selectedCategoriesHolder removeDependent:self.
                selectedCategoriesHolder value:#().
                selectedCategoriesHolder addDependent:self.
            ].

            categoryList value:newList.

            oldSelection notEmpty ifTrue:[
                newSelection := oldSelection select:[:cat | newList includes:cat].
                selectedCategoriesHolder value:newSelection.
            ]
        ] ifFalse:[
            "/ a real change

            categoryList value:newList.

            "/ in case the same categories are present, but classes have changed ...
            (prevClasses isNil or:[(classes identicalContentsAs:prevClasses) not]) ifTrue:[
                self updateOutputGenerator.
            ]
        ]
    ] ifTrue:[
        "/ in case the same categories are present, but classes have changed,
        "/ we still have to update the outputGenerator, to get a new classList...
        (prevClasses isNil or:[(classes identicalContentsAs:prevClasses) not]) ifTrue:[
            self updateOutputGenerator.
        ]
    ].
    self setListValid:true.

    "Created: / 05-02-2000 / 13:42:13 / cg"
    "Modified: / 17-08-2011 / 09:52:13 / cg"
!

xUpdateOutputGenerator
    "/ self updateOutputGenerator
self enqueueDelayedUpdateOutputGenerator
! !

!ClassCategoryList methodsFor:'private-presentation'!

listEntryForCategory: cat
    "only called after an individual method's change,
     and this is the very first change for that class, to update the list entry.
     Don't ever call this for every category to avoid O(n^2) behavior on the number of classes,
     because this method enumerates all classes in the environment"

    | showCounts numClasses hideUnloadedClassesValue nameSpaceFilterValue packageFilterValue allName 
      hasLocalChangedCode hasRemoteChangedCode hasExtensions classesInChangeSet classesInRemoteChangeSet |

    showCounts := true.
    allName := self class nameListEntryForALL.

    hideUnloadedClassesValue := self hideUnloadedClasses value.
    nameSpaceFilterValue := self nameSpaceFilter value.
    nameSpaceFilterValue notNil ifTrue:[
        (nameSpaceFilterValue includes:allName) ifTrue:[nameSpaceFilterValue := nil].
    ].
    packageFilterValue := self packageFilter value.
    packageFilterValue notNil ifTrue:[
        (packageFilterValue includes:allName) ifTrue:[packageFilterValue := nil].
    ].    

    classesInChangeSet := ChangeSet current changedClasses.
    classesInChangeSet := classesInChangeSet collect:[:eachClass | eachClass theNonMetaclass].

    classesInRemoteChangeSet := SmallTeam isNil ifTrue:[#()] ifFalse:[ SmallTeam changedClasses ].
    classesInRemoteChangeSet := classesInRemoteChangeSet collect:[:each | each theNonMetaclass].

    numClasses := 0.
    hasLocalChangedCode := false.
    hasRemoteChangedCode := false.
    hasExtensions := false.

    environment allClassesDo:[:cls | 
        | isLoaded |

        cls category = cat ifTrue:[
            (cls isRealNameSpace) ifFalse:[
                (nameSpaceFilterValue isNil
                or:[self isClass:cls shownWithNameSpaceFilter:nameSpaceFilterValue]) ifTrue:[
                    (packageFilterValue isNil
                    or:[self isClass:cls shownWithPackageFilter:packageFilterValue]) ifTrue:[

                        isLoaded := cls isLoaded.

                        (hideUnloadedClassesValue not or:[isLoaded])
                        ifTrue:[
                            numClasses := numClasses + 1.

                            hasLocalChangedCode := hasLocalChangedCode or:[classesInChangeSet includes:cls theNonMetaclass].
                            hasRemoteChangedCode := hasRemoteChangedCode or:[classesInRemoteChangeSet includes:cls theNonMetaclass].
                            hasExtensions := hasExtensions or:[cls hasExtensions].
                        ]
                    ]
                ]
            ]
        ].
    ].


    ^ self listEntryForCategory: cat numClasses: numClasses showCounts: showCounts pseudoEntryColor: self class pseudoEntryForegroundColor
                hasLocalChangedCode: hasLocalChangedCode 
                hasRemoteChangedCode: hasRemoteChangedCode 
                hasExtensions: hasExtensions

    "Created: / 26-03-2014 / 09:12:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listEntryForCategory: cat numClasses: numClasses showCounts: showCounts pseudoEntryColor: pseudoEntryColor
    hasLocalChangedCode: isInLocalChangeSet 
    hasRemoteChangedCode: isInRemoteChangeSet 
    hasExtensions: hasExtensions

    |item |

    isInLocalChangeSet ifTrue:[
         item := self colorizeForChangedCode:cat copy asText
    ] ifFalse:[
        hasExtensions ifTrue:[
             item := self colorizeForDifferentPackage:cat copy asText
             "/ cannot add a + here - need separate list for presentation and filter
             "/ cat , (self colorizeForDifferentPackage:self stringForExtensions)
        ] ifFalse:[
            isInRemoteChangeSet ifTrue:[
                 item := self colorizeForChangedCodeInSmallTeam:cat copy asText
            ] ifFalse:[
                 item := cat
            ]
        ]
    ].
    showCounts ifTrue:[
        item := item , 
                    ((' (%1)' bindWith:numClasses) 
                            withColor:pseudoEntryColor).
    ].
    isInLocalChangeSet ifTrue:[
        item := item , self class markForBeingInChangeList
    ].

    ^ item

    "Created: / 26-03-2014 / 08:51:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassCategoryList methodsFor:'special'!

addAdditionalCategory:aCategory
    "/ those are simulated - in ST/X, empty categories do not
    "/ really exist; however, during browsing, it makes sense.

    self class addAdditionalCategory:aCategory
!

removeAdditionalCategories:aListOfCategories
    self class removeAdditionalCategories:aListOfCategories
!

removeAllAdditionalCategories
    self class removeAllAdditionalCategories
!

renameAdditionalCategories:oldNames to:newName
    "/ those are simulated - in ST/X, empty categories do not
    "/ really exist; however, during browsing, it makes sense.

    self class renameAdditionalCategories:oldNames to:newName
! !

!ClassCategoryList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

