"
 COPYRIGHT (c) 2000 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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

BrowserList subclass:#MethodCategoryList
	instanceVariableNames:'variableFilter filterClassVars lastSelectedProtocols classes
		leafClasses protocolList rawProtocolList selectedProtocolIndices
		lastGeneratedProtocols packageFilterOnInput
		methodVisibilityHolder noAllItem noPseudoItems
		showPseudoProtocols showSyntheticMethods'
	classVariableNames:'AdditionalEmptyCategoriesPerClassName MethodInfoCache
		MethodInfoCacheAccessLock'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

Object subclass:#CachedMethodInfo
	instanceVariableNames:'flags'
	classVariableNames:'FlagObsolete FlagSendsSuper FlagIsUncommented
		FlagIsDocumentationMethod FlagIsLongMethod FlagIsExtension
		FlagIsRedefine FlagIsRedefined FlagIsOverride
		FlagIsSubclassResponsibility FlagIsTest FlagIsAnnotated'
	poolDictionaries:''
	privateIn:MethodCategoryList
!

Method variableSubclass:#MissingMethod
	instanceVariableNames:'selector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MethodCategoryList
!

MethodCategoryList::MissingMethod variableSubclass:#MethodStubForTestResult
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MethodCategoryList
!

!MethodCategoryList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    I implement the method category (= protocol) list in the new system browser
"
! !

!MethodCategoryList class methodsFor:'initialization'!

flushMethodInfo
    MethodInfoCache := Dictionary new.

    "
     self flushMethodInfo
    "
!

initialize
    MethodInfoCache := Dictionary new.
    MethodInfoCacheAccessLock := RecursionLock new name:'MethodInfoCacheAccessLock'.
! !

!MethodCategoryList class methodsFor:'cleanup'!

lowSpaceCleanup
    self flushMethodInfo

    "Created: / 08-08-2011 / 19:15:25 / cg"
! !

!MethodCategoryList class methodsFor:'interface specs'!

singleProtocolWindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MethodCategoryList andSelector:#singleProtocolWindowSpec
     MethodCategoryList new openInterface:#singleProtocolWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #singleProtocolWindowSpec
        #window: 
       #(#WindowSpec
          #label: 'ProtocolList'
          #name: 'ProtocolList'
          #min: #(#Point 0 0)
          #max: #(#Point 1024 721)
          #bounds: #(#Rectangle 12 22 312 322)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#LabelSpec
              #label: 'ProtocolName'
              #name: 'ProtocolLabel'
              #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 25 0)
              #translateLabel: true
              #labelChannel: #protocolLabelHolder
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
     UIPainter new openOnClass:MethodCategoryList andSelector:#windowSpec
     MethodCategoryList new openInterface:#windowSpec
     MethodCategoryList open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'ProtocolList'
          #name: 'ProtocolList'
          #min: #(#Point 0 0)
          #bounds: #(#Rectangle 16 46 316 346)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SequenceViewSpec
              #name: 'List'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #tabable: true
              #model: #selectedProtocolIndices
              #menu: #menuHolder
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #valueChangeSelector: #selectionChangedByClick
              #useIndex: true
              #sequenceList: #protocolList
              #doubleClickChannel: #doubleClickChannel
              #properties: 
             #(#PropertyListDictionary
                #dragArgument: nil
                #dropArgument: nil
                #canDropSelector: #canDropContext:
                #dropSelector: #doDropContext:
              )
            )
           )
         
        )
      )
! !

!MethodCategoryList class methodsFor:'plugIn spec'!

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
        #(#doubleClickChannel #action )
        #filterClassVars
        #forceGeneratorTrigger
        #immediateUpdate
        #inGeneratorHolder
        #menuHolder
        #noAllItem
        #showPseudoProtocols
        #outGeneratorHolder
        #packageFilter
        #packageFilterOnInput
        #selectedProtocols
        #selectionChangeCondition
        #updateTrigger
        #variableFilter
        #methodVisibilityHolder
        #showCoverageInformation
        #showSyntheticMethods
      ).

    "Modified: / 27-04-2010 / 16:40:39 / cg"
    "Modified: / 24-02-2014 / 10:37:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodCategoryList class methodsFor:'queries'!

isPseudoCategory:cat
    ^ (super isPseudoCategory:cat)
    or:[ (cat startsWith:'* ')
        and:[ (cat endsWith:' *')
        and:[ (cat includesString:'%1') ]]]
! !

!MethodCategoryList methodsFor:'aspects'!

browserNameList
    ^ self protocolList 
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

    "Modified: / 31.1.2000 / 00:56:31 / cg"
    "Created: / 5.2.2000 / 13:42:10 / cg"
!

filterClassVars:aValueHolder
    filterClassVars notNil ifTrue:[
        filterClassVars removeDependent:self
    ].
    filterClassVars := aValueHolder.
    filterClassVars notNil ifTrue:[
        filterClassVars addDependent:self
    ].

    "Modified: / 31.1.2000 / 00:56:31 / cg"
    "Created: / 5.2.2000 / 13:42:10 / cg"
!

methodVisibilityHolder
    methodVisibilityHolder isNil ifTrue:[
        methodVisibilityHolder := ValueHolder with:false.
        methodVisibilityHolder addDependent:self
    ].
    ^  methodVisibilityHolder
!

methodVisibilityHolder:aValueHolder
    methodVisibilityHolder notNil ifTrue:[
        methodVisibilityHolder removeDependent:self
    ].
    methodVisibilityHolder := aValueHolder.
    methodVisibilityHolder notNil ifTrue:[
        methodVisibilityHolder addDependent:self
    ].

    "Modified: / 31.1.2000 / 00:56:31 / cg"
    "Created: / 5.2.2000 / 13:42:10 / cg"
!

noAllItem
    noAllItem isNil ifTrue:[
        noAllItem := ValueHolder with:false.
        noAllItem addDependent:self
    ].
    ^  noAllItem
!

noAllItem:aValueHolder
    noAllItem notNil ifTrue:[
        noAllItem removeDependent:self
    ].
    noAllItem := aValueHolder.
    noAllItem notNil ifTrue:[
        noAllItem addDependent:self
    ].
!

packageFilterOnInput
    packageFilterOnInput isNil ifTrue:[
        packageFilterOnInput := ValueHolder with:nil.
        packageFilterOnInput addDependent:self
    ].
    ^  packageFilterOnInput
!

packageFilterOnInput:aValueHolder
    |prevFilter|

    prevFilter := packageFilterOnInput value.
    packageFilterOnInput notNil ifTrue:[
        packageFilterOnInput removeDependent:self
    ].
    packageFilterOnInput := aValueHolder.
    packageFilterOnInput notNil ifTrue:[
        packageFilterOnInput addDependent:self
    ].
    prevFilter ~= packageFilterOnInput value ifTrue:[
        self enqueueDelayedUpdateList
    ].
!

protocolLabelHolder
    ^ self pseudoListLabelHolder
!

protocolList
    protocolList isNil ifTrue:[
        protocolList := List new. "/ ValueHolder new
    ].
    ^ protocolList

    "Modified: / 31.1.2000 / 00:56:31 / cg"
    "Created: / 5.2.2000 / 13:42:10 / cg"
!

rawProtocolList
    rawProtocolList isNil ifTrue:[
        rawProtocolList := List new.
    ].
    ^ rawProtocolList
!

selectedProtocolIndices
    selectedProtocolIndices isNil ifTrue:[
        selectedProtocolIndices := ValueHolder new.
        selectedProtocolIndices addDependent:self
    ].
    ^ selectedProtocolIndices.
!

selectedProtocols
    ^ self selectionHolder
!

selectedProtocols:aValueHolder
    ^ self selectionHolder:aValueHolder
!

showPseudoProtocols
    showPseudoProtocols isNil ifTrue:[
        showPseudoProtocols := ValueHolder with:true.
        showPseudoProtocols addDependent:self
    ].
    ^  showPseudoProtocols
!

showPseudoProtocols:aValueHolder
    showPseudoProtocols notNil ifTrue:[
        showPseudoProtocols removeDependent:self
    ].
    showPseudoProtocols := aValueHolder.
    showPseudoProtocols notNil ifTrue:[
        showPseudoProtocols addDependent:self
    ].
!

showSyntheticMethods
    showSyntheticMethods isNil ifTrue:[
        showSyntheticMethods := ValueHolder with:true.
        showSyntheticMethods addDependent:self
    ].
    ^  showSyntheticMethods
!

showSyntheticMethods:aValueHolder
    showSyntheticMethods notNil ifTrue:[
        showSyntheticMethods removeDependent:self
    ].
    showSyntheticMethods := aValueHolder.
    showSyntheticMethods notNil ifTrue:[
        showSyntheticMethods addDependent:self
    ].
!

variableFilter
    variableFilter isNil ifTrue:[
        variableFilter := ValueHolder with:false.
        variableFilter addDependent:self
    ].
    ^  variableFilter

    "Modified: / 31.1.2000 / 00:56:31 / cg"
    "Created: / 5.2.2000 / 13:42:10 / cg"
!

variableFilter:aValueHolder
    variableFilter notNil ifTrue:[
        variableFilter removeDependent:self
    ].
    variableFilter := aValueHolder.
    variableFilter notNil ifTrue:[
        variableFilter addDependent:self
    ].

    "Modified: / 31.1.2000 / 00:56:31 / cg"
    "Created: / 5.2.2000 / 13:42:10 / cg"
! !

!MethodCategoryList methodsFor:'change & update'!

classDefinitionChanged:aClass
    |refetch anyChange|

    anyChange := false.
    refetch := [:oldClass | 
                    |nm cls newClass|

                    nm := oldClass theNonMetaclass name.
                    newClass := Smalltalk at:nm.

                    oldClass isMeta ifTrue:[
                        newClass isNil ifTrue:[
                            "/ Transcript showCR:'oops - browser lost class ' , nm.
                            newClass := oldClass
                        ] ifFalse:[
                            newClass := newClass theMetaclass
                        ]
                    ].


                    newClass ~~ oldClass ifTrue:[
                        anyChange := true.
                    ].
                    newClass
            ].

    classes := classes collect:[:oldClass | oldClass notNil ifTrue:[refetch value: oldClass] ifFalse:[nil]].
    leafClasses := leafClasses collect:[:oldClass | oldClass notNil ifTrue:[refetch value: oldClass] ifFalse:[nil]].
    anyChange ifTrue:[
        self updateOutputGenerator
    ].

    "Modified: / 06-07-2011 / 11:44:13 / cg"
    "Modified: / 15-10-2013 / 01:19:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delayedUpdate:something with:aParameter from:changedObject
    |sel oldMethod newMethod mthd selectedCategories selectedProtocolsHolder oldProtocol newProtocol
     rawProtocolListHolder rawProtocolList oldSelectedProtocols newSelectedProtocols newIndices idx cls listView|

    selectedProtocolsHolder := self selectedProtocols.
    rawProtocolListHolder := self rawProtocolList.

    changedObject == environment ifTrue:[
        classes notNil ifTrue:[
            something == #methodCategory ifTrue:[
                cls := aParameter at:1.
                (cls notNil and:[classes includesIdentical:cls]) ifTrue:[
                    mthd := aParameter at:2.
                    newProtocol := mthd category.
                    oldProtocol := aParameter at:3.

                    listValid == true ifTrue:[ self invalidateList ].

                    selectedCategories := selectedProtocolsHolder value.
                    selectedCategories size > 0 ifTrue:[
                        selectedCategories := selectedCategories collect:[:each | each ifNil:[self class nameListEntryForNILCategory]].
                        selectedCategories := selectedCategories collect:[:each | each string].

                        ((selectedCategories includes:oldProtocol)
                        or:[ (selectedCategories includes:newProtocol)
                        or:[ selectedCategories includes:(self class nameListEntryForALL) ]])
                        ifTrue:[
                            self enqueueDelayedUpdateOutputGenerator "/ updateOutputGenerator.
                        ].
                    ].

                ].
                ^ self
            ].

            something == #methodInClass ifTrue:[
                "/ a method has been added/removed/changed
                cls := aParameter at:1.
                (classes includesIdentical:cls) ifTrue:[
                    sel := aParameter at:2.
                    self flushMethodInfoForClassNamed:cls name selector:sel.
                    oldMethod := aParameter at:3.
                    newMethod := cls compiledMethodAt:sel.
                    oldMethod notNil ifTrue:[
                        variableFilter value size > 0 ifTrue:[
                            "/ sigh - must invalidate
                            listValid == true ifTrue:[ self invalidateList ].
                        ].
                        ^ self.
                    ].
                    "/ method was added - update the methodList
                    "/ Q: is this needed (methodCategoryList should send me a new inGenerator)
                    listValid == true ifTrue:[ self invalidateList ].

                    "/ if its category is selected, updateOutputGenerator
                    selectedCategories := selectedProtocolsHolder value.
                    selectedCategories size > 0 ifTrue:[
                        selectedCategories := selectedCategories collect:[:each | each ifNil:[self class nameListEntryForNILCategory]].
                        selectedCategories := selectedCategories collect:[:each | each string].

                        ((oldMethod notNil and:[selectedCategories includes:(oldMethod category)])
                        or:[ (newMethod notNil and:[selectedCategories includes:(newMethod category)])])
                        ifTrue:[
                            self enqueueDelayedUpdateOutputGenerator "/ updateOutputGenerator.
                        ].
                    ].
                ].
                ^ self.
            ].

            something == #methodInClassRemoved ifTrue:[
                cls := aParameter at:1.
                (classes includesIdentical:cls) ifTrue:[
                    sel := aParameter at:2.
                    self flushMethodInfoForClassNamed:cls name selector:sel.
                    "/ method was removed - update the list and output generator
                    self invalidateList.
                    "/ self updateOutputGenerator.
                    self slaveMode value == true ifFalse:[
                        self enqueueDelayedUpdateOutputGenerator.
                    ]
                ].
                ^ self.
            ].

            (something == #classOrganization
            or:[ something == #methodCategoryAdded
            or:[ something == #methodCategoryRemoved
            or:[ something == #methodCategoriesRemoved
            or:[ something == #methodCategoryRenamed ]]]]) ifTrue:[
                cls := (something == #classOrganization) ifTrue:aParameter ifFalse:[aParameter first].
                (classes includesIdentical:cls) ifTrue:[
                    listValid == true ifTrue:[ self invalidateList ].
                ] ifFalse:[
                    (classes contains:[:aClass | aClass name = cls name]) ifTrue:[
                        listValid == true ifTrue:[ self invalidateList ].
                        "/ self error:'obsolete class: should not happen'.
                    ]
                ].
                ^ self.
            ].

            something == #projectOrganization ifTrue:[
                aParameter notNil ifTrue:[
                    cls := aParameter at:1.
                    cls notNil ifTrue:[
                        ((classes includes:cls theMetaclass)
                        or:[(classes includes:cls theNonMetaclass)]) ifTrue:[
                            self invalidateList.
                            self slaveMode value == true ifFalse:[
                                self enqueueDelayedUpdateOutputGenerator.
                            ]
                        ].
                    ].
                ] ifFalse:[
                    listValid == true ifTrue:[ self invalidateList ].
                ].
                ^ self
            ].

            (something == #methodCoverageInformation) ifTrue:[
                "/ already checked if it is one of my classes
                listValid == true ifTrue:[ self invalidateList ].
                ^ self
            ].

            (something == #classDefinition or:[something == #classVariables])
            ifTrue:[
                self classDefinitionChanged:aParameter.
                ^ self
            ].

            "/ everything else is ignored    
            "/ self halt.
        ].
        ^ self
    ].

    changedObject == self selectedProtocolIndices ifTrue:[
        oldSelectedProtocols := selectedProtocolsHolder value ? #().
        oldSelectedProtocols := oldSelectedProtocols collect:[:each | each ifNil:[self class nameListEntryForNILCategory]].
        oldSelectedProtocols := oldSelectedProtocols collect:[:each | each string].
        newSelectedProtocols := self getSelectedProtocolsFromIndices.
        oldSelectedProtocols ~= newSelectedProtocols ifTrue:[
            selectedProtocolsHolder value:newSelectedProtocols.
        ].
        newSelectedProtocols size > 1 ifTrue:[
            (newSelectedProtocols includes:(self class nameListEntryForALL)) ifTrue:[
                rawProtocolList := rawProtocolListHolder value.
                idx := rawProtocolList indexOf: (newSelectedProtocols copy remove:(self class nameListEntryForALL); yourself) first.
                idx ~~ 0 ifTrue:[
                    (listView := self componentAt:#List) notNil ifTrue:[
                        listView makeLineVisible:idx.
                    ]
                ]
            ]
        ].

        ^ self
    ].

    changedObject == selectedProtocolsHolder ifTrue:[
        rawProtocolList := rawProtocolListHolder value.
        rawProtocolList size == 0 ifTrue:[
            lastGeneratedProtocols := nil.
            self updateList.
            rawProtocolList := rawProtocolListHolder value.
        ].
        rawProtocolList notNil ifTrue:[
            selectedCategories := selectedProtocolsHolder value ? #().
            selectedCategories := selectedCategories collect:[:each | each ifNil:[self class nameListEntryForNILCategory]].
            newIndices := selectedCategories 
                            collect:[:each | rawProtocolList findFirst:[:p | p string = each string]]
                            thenSelect:[:each | each ~~ 0].
            newIndices ~= self selectedProtocolIndices value ifTrue:[
                self selectedProtocolIndices 
                    setValue:nil;                    "/ to force update
                    value:newIndices.
            ].
            "/ cg: does not work (selecting all with testcase classes)
            "/ don't see why, at the moment, but....
            (lastGeneratedProtocols notNil
            and:[(lastGeneratedProtocols includes:self class nameListEntryForALL)
            and:[(selectedCategories ? #()) includes:self class nameListEntryForALL]])
            ifTrue:[
                "/ no need to update generator
            ] ifFalse:[
                self updateOutputGenerator.
            ]
        ].
        ^ self
    ].

    (changedObject == variableFilter
    or:[changedObject == filterClassVars
    or:[changedObject == packageFilterOnInput]]) ifTrue:[
        self invalidateList.
        ^  self
    ].

    changedObject == methodVisibilityHolder ifTrue:[
        self invalidateList.
        self updateOutputGenerator.
        ^  self
    ].

    lastGeneratedProtocols := nil.

    changedObject == inGeneratorHolder ifTrue:[
        selectedCategories := selectedProtocolsHolder value.

        selectedCategories size > 0 ifTrue:[
            oldSelectedProtocols := selectedCategories ? #().
            oldSelectedProtocols := oldSelectedProtocols collect:[:each | each ifNil:[self class nameListEntryForNILCategory]].
            oldSelectedProtocols := oldSelectedProtocols collect:[:each | each string].
            self updateList.
            rawProtocolList := rawProtocolListHolder value.
            newSelectedProtocols := oldSelectedProtocols select:[:each | rawProtocolList includes:each].
"/            selectedProtocolsHolder setValue:nil.                    "/ to force update
            selectedProtocolsHolder value:newSelectedProtocols.
            ^ self
        ].
    ].

    super delayedUpdate:something with:aParameter from:changedObject

    "Created: / 05-02-2000 / 13:42:10 / cg"
    "Modified: / 23-09-2011 / 20:37:31 / cg"
!

getSelectedProtocolsFromIndices
    |l|

    l := self rawProtocolList value.
    ^ self selectedProtocolIndices value collect:[:idx | l at:idx].
!

selectionChanged
    |newSelectedCategories allEntry|

    newSelectedCategories := self selectedProtocols value.

    "/ the outputGenerator is only to be updated, if the output would really
    "/ change ...
    allEntry := self class nameListEntryForALL.

    (lastSelectedProtocols notNil
    and:[newSelectedCategories notNil
    and:[(lastSelectedProtocols includes:(allEntry))
    and:[newSelectedCategories includes:(allEntry)]]]) ifTrue:[
        "/ no change ...
        ^ self
    ].

    super selectionChanged.

    "Created: / 5.2.2000 / 13:42:10 / cg"
    "Modified: / 24.2.2000 / 14:12:12 / cg"
!

selectionChangedByClick
    "we are not interested in that - get another notification
     via the changed valueHolder"

    lastSelectedProtocols := self getSelectedProtocolsFromIndices
!

update:something with:aParameter from:changedObject
    |cls sel mthd oldMethod newMethod|

    "/ some can be ignored immediately
    changedObject == environment ifTrue:[
        something isNil ifTrue:[
            "/ self halt "/ huh - environment changed - so what ?
            ^ self.
        ].

        something == #currentChangeSet ifTrue:[
            listValid == true ifTrue:[ self invalidateList ].
            ^ self.
        ].

        something == #methodInClass ifTrue:[
            "/ a method has been added/removed/changed
            cls := aParameter at:1.
            (classes notNil and:[classes includesIdentical:cls]) ifFalse:[^ self].

            sel := aParameter at:2.
            self flushMethodInfoForClassNamed:cls name selector:sel.
            oldMethod := aParameter at:3.
            newMethod := cls compiledMethodAt:sel.
            oldMethod notNil ifTrue:[
                variableFilter value size > 0 ifTrue:[
                    "/ sigh - must invalidate
                    listValid ifTrue:[ self invalidateList ].
                    ^ self.    
                ].
                oldMethod category ~= newMethod category ifTrue:[
                    listValid ifTrue:[ self invalidateList ].
                    ^ self.    
                ].
                "/ mhmh - its now changed (so coloring will change).
                listValid ifTrue:[ self invalidateList ].
                ^ self.
            ].
        ].

"/        something == #classDefinition ifTrue:[
"/            ^ self.
"/        ].
        something == #newClass ifTrue:[
            ^ self.
        ].
        something == #classRemove ifTrue:[
            ^ self.
        ].
        something == #classRename ifTrue:[
            ^ self.
        ].
"/        something == #classVariables ifTrue:[
"/            ^ self.
"/        ].
        something == #classComment ifTrue:[
            ^ self.
        ].
        something == #organization ifTrue:[
            ^ self.
        ].
        something == #methodTrap ifTrue:[
            ^ self
        ].

        something == #methodCoverageInfo ifTrue:[
            self showCoverageInformation value ifFalse:[^ self].
            listValid ifFalse:[^ self ].

            mthd := aParameter.
            (classes notNil and:[classes includesIdentical:mthd mclass]) ifFalse:[^ self].

            self invalidateList.
            "/ self enqueueDelayedUpdateList.
            ^ self
        ].
    ].

    something == #lastTestRunResult ifTrue:[
        cls := aParameter at:1.
        (classes notNil and:[classes includesIdentical:cls]) ifTrue:[
            self invalidateList.
        ].    
        ^ self.
    ].

    super update:something with:aParameter from:changedObject.

    "Modified: / 05-06-2012 / 23:38:31 / cg"
! !

!MethodCategoryList methodsFor:'drag & drop'!

canDropContext:aDropContext
    |cat methods|

    methods := aDropContext dropObjects collect:[:obj | obj theObject].
    (methods conform:[:aMethod | aMethod isMethod]) ifFalse:[^ false].

    cat := self categoryAtTargetPointOf:aDropContext.
    cat isNil ifTrue:[^ false].

    (methods contains:[:aMethod | aMethod category ~= cat]) ifFalse:[^ false].
    ^ true

    "Modified: / 13-09-2006 / 11:44:02 / cg"
!

categoryAtTargetPointOf:aDropContext
    |p methodListView lineNr cat|

    p := aDropContext targetPoint.

    methodListView := aDropContext targetWidget.

    lineNr := methodListView lineAtY:p y.
    lineNr isNil ifTrue:[^ nil].

    cat := rawProtocolList at:lineNr.
    cat := cat string.
    cat = self class nameListEntryForALL ifTrue:[^ nil].

    ^ cat
!

doDropContext:aDropContext
    "handle dropping of a method as a category change"

    |cat methods|

    methods := aDropContext dropObjects collect:[:aDropObject | aDropObject theObject].
    (methods conform:[:something | something isMethod]) ifFalse:[^ self].

    cat := self categoryAtTargetPointOf:aDropContext.
    cat notNil ifTrue:[
        self masterApplication moveMethods:methods toProtocol:cat.
    ].

    "Modified: / 13-09-2006 / 11:43:23 / cg"
! !

!MethodCategoryList methodsFor:'generators'!

makeGenerator
    "return a generator which enumerates the methods from the selected protocol;
     that generator generates 4-element elements (includes the class and protocol), 
     in order to make the consumers only depend on one input 
     (i.e. to pass multiple-class and multiple-protocol info
      without a need for another classHolder/protocolHolder in the methodList)."

    |protocols noPackage noCat static notStatic|

    noPackage := PackageId noProjectID.
    noCat := (self class nameListEntryForNILCategory).
    static := (self class nameListEntryForStatic).
    notStatic := (self class nameListEntryForNonStatic).

    protocols := self selectedProtocols value ? #().
    protocols := protocols collect:[:each | (each ifNil:[noCat]) string].
    lastGeneratedProtocols := protocols.
    protocols := protocols asSet.

    ^ Iterator 
        on:[:whatToDo |
            | 
             allProtocols superSendProtocols uncommentedProtocols obsoleteProtocols 
             documentationProtocols longProtocols extensionProtocols redefinedProtocols
             redefineProtocols  overrideProtocols
             missingRequiredProtocols subclassResponsibilities
             anyCoverage notInstrumentedProtocols annotatedProtocols fullyCoveredProtocols 
             partiallyCoveredProtocols uncoveredProtocols allTestsProtocols allTestsNotPassedProtocols
             classSelectorPairsAlreadyDone
             packages remainingClasses remainingCategories classesAlreadyDone 
             catListed showChanged|

            (leafClasses size > 0 and:[protocols size > 0]) ifTrue:[
                allProtocols := protocols includes:(self class nameListEntryForALL).
                superSendProtocols := protocols includes:(self class nameListEntryForSuperSend).
                uncommentedProtocols := protocols includes:(self class nameListEntryForUncommented).
                obsoleteProtocols := protocols includes:(self class nameListEntryForObsolete).
                documentationProtocols := protocols includes:(self class nameListEntryForDocumentation).
                longProtocols := protocols includes:(self class nameListEntryForLong).
                extensionProtocols := protocols includes:(self class nameListEntryForExtensions).
                redefinedProtocols := protocols includes:(self class nameListEntryForRedefined).
                redefineProtocols := protocols includes:(self class nameListEntryForRedefine).
                overrideProtocols := protocols includes:(self class nameListEntryForOverride).
                missingRequiredProtocols := protocols includes:(self class nameListEntryForRequired).
                subclassResponsibilities := protocols includes:(self class nameListEntryForMustBeRedefinedInSubclass).
                annotatedProtocols := protocols includes:(self class nameListEntryForAnnotated).

                fullyCoveredProtocols := protocols includes:(self class nameListEntryForFullyCovered).
                partiallyCoveredProtocols := protocols includes:(self class nameListEntryForPartiallyCovered).
                uncoveredProtocols := protocols includes:(self class nameListEntryForUncovered).
                notInstrumentedProtocols := protocols includes:(self class nameListEntryForNotInstrumented).
                anyCoverage := fullyCoveredProtocols | partiallyCoveredProtocols 
                               | uncoveredProtocols | notInstrumentedProtocols.

                allTestsProtocols := protocols includes:(self class nameListEntryForAllTests).
                allTestsNotPassedProtocols := protocols includes:(self class nameListEntryForTestsNotPassed).

                packages := packageFilter value value.
                (packages notNil and:[packages includes:(self class nameListEntryForALL)]) ifTrue:[
                    packages := nil.
                ].
                showChanged := packages notNil and:[packages includes:(self class nameListEntryForChanged)].

                remainingClasses := leafClasses asNewIdentitySet.
                remainingCategories := protocols asNewSet.

                classesAlreadyDone := IdentitySet new.
                classSelectorPairsAlreadyDone := Set new.

                leafClasses do:[:aLeafClass |  
                    (self classesToProcessForClasses:(Array with:aLeafClass)) do:[:aClass |
                        |supportsMethodCategories isJavaClass anyInThisClass requiredProtocolForClass 
                         isTestCaseClass allTestSelectors allTestsNotPassed|

                        (classesAlreadyDone includes:aClass) ifFalse:[
                            classesAlreadyDone add:aClass.

                            supportsMethodCategories := aClass supportsMethodCategories.
                            isJavaClass := aClass isJavaClass.
                            isTestCaseClass := false.
                            
                            (allTestsProtocols or:[allTestsNotPassedProtocols]) ifTrue:[
                                isTestCaseClass := aClass isTestCaseLike and:[aClass isMetaclass not and:[aClass isAbstract not]].
                                isTestCaseClass ifTrue:[
                                    allTestsProtocols ifTrue:[
                                        allTestSelectors := aClass allTestSelectors asSet.
                                    ].
                                ].
                            ].
                            anyInThisClass := false.

                            aClass methodDictionary keysAndValuesDo:[:sel :mthd |
                                |cat mPkg includeIt info|

                                supportsMethodCategories ifTrue:[
                                    cat := mthd category.
                                ] ifFalse:[
                                    isJavaClass ifTrue:[
                                        cat := mthd isStatic ifTrue:[static] ifFalse:[notStatic]
                                    ] ifFalse:[
                                        cat := noCat.
                                    ]
                                ].
                                catListed := cat.

                                mPkg := mthd package.
                                (packages isNil 
                                    or:[ mPkg = noPackage 
                                    or:[ (packages includes:mPkg)
                                    or:[ allProtocols "(extensionProtocols and:[ mthd isExtension ])"
                                    or:[ showChanged    
                                    ]]]]
                                ) ifTrue:[
                                    "/ used to be a more readable or, but to reuse info, I've splitted it.
                                    "/ because we should use the parser only once, we reuse the same methodInfo.
                                    "/ otherwise, the list update becomes too slow for long classes (NewSystemBrowser)
                                    includeIt := allProtocols or:[protocols includes:cat].
                                    includeIt ifFalse:[
                                        allTestsProtocols ifTrue:[
                                            includeIt := allTestSelectors notNil and:[allTestSelectors includes:sel]].
                                            
                                        includeIt ifFalse:[
                                            (allTestsNotPassedProtocols and:[isTestCaseClass]) ifTrue:[
                                                (aClass isTestSelector:sel) ifTrue:[
                                                    |lastResultOrNil|

                                                    lastResultOrNil := aClass asTestCase rememberedOutcomeFor:sel.
                                                    includeIt := lastResultOrNil isNil 
                                                                or:[lastResultOrNil result ~~ TestResult statePass]]]].    
                                                
                                        includeIt ifFalse:[
                                            superSendProtocols ifTrue:[
                                                info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
                                                includeIt := info sendsSuper ]].
                                                
                                        includeIt ifFalse:[
                                            uncommentedProtocols ifTrue:[
                                                info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
                                                includeIt := info isUncommented.
                                                catListed := self class nameListEntryForUncommented ]].
                                                
                                        includeIt ifFalse:[ 
                                            obsoleteProtocols ifTrue:[
                                                info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
                                                includeIt := info isObsolete ]].
                                                
                                        includeIt ifFalse:[ 
                                            documentationProtocols ifTrue:[
                                                info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
                                                includeIt := info isDocumentationMethod ]].
                                                
                                        includeIt ifFalse:[ 
                                            longProtocols ifTrue:[
                                                info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
                                                includeIt := info isLongMethod ]].
                                                
                                        includeIt ifFalse:[ 
                                            extensionProtocols ifTrue:[
                                                info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
                                                includeIt := info isExtensionMethod.
                                                catListed := self class nameListEntryForExtensions ]].
                                                
                                        includeIt ifFalse:[ 
                                            overrideProtocols ifTrue:[
                                                info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
                                                includeIt := info isOverride ]].
                                                
    "/                                    includeIt ifFalse:[ 
    "/                                        redefinedProtocols ifTrue:[
    "/                                            info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
    "/                                            includeIt := info isRedefined ]].
    
                                        includeIt ifFalse:[ 
                                            redefineProtocols ifTrue:[
                                                info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
                                                includeIt := info isRedefine ]].
                                                
                                        includeIt ifFalse:[
                                            subclassResponsibilities ifTrue:[
                                                info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
                                                includeIt := info isSubclassResponsibility ]].
                                                
                                        includeIt ifFalse:[
                                            annotatedProtocols ifTrue:[
                                                info isNil ifTrue:[ info := self methodInfoFor:mthd in:aClass selector:sel ].
                                                includeIt := info isAnnotated ]].

                                        includeIt ifFalse:[
                                            anyCoverage ifTrue:[
                                                mthd isInstrumented ifTrue:[
                                                    mthd hasBeenCalled ifTrue:[
                                                        mthd haveAllBlocksBeenExecuted ifTrue:[
                                                            includeIt := fullyCoveredProtocols.
                                                        ] ifFalse:[
                                                            includeIt := partiallyCoveredProtocols 
                                                        ]
                                                    ] ifFalse:[
                                                        includeIt := uncoveredProtocols
                                                    ].
                                                ] ifFalse:[
                                                    includeIt := notInstrumentedProtocols
                                                ].
                                            ].
                                        ].
                                    ].
                                    
                                    includeIt ifTrue:[
                                        (methodVisibilityHolder value == #class) ifTrue:[
                                            whatToDo value:aClass value:catListed value:sel value:mthd.
                                        ] ifFalse:[
                                            (classSelectorPairsAlreadyDone includes:(aLeafClass->sel)) ifFalse:[
                                                classSelectorPairsAlreadyDone add:(aLeafClass->sel).
                                                whatToDo value:aClass value:catListed value:sel value:mthd.
                                            ].
                                        ].
                                        anyInThisClass := true.
                                        remainingCategories remove:catListed ifAbsent:nil.
                                    ].
                                ].
                                allTestSelectors notNil ifTrue:[ allTestSelectors remove: sel ifAbsent:[] ].
                            ].

                            missingRequiredProtocols ifTrue:[
                                requiredProtocolForClass := SmalltalkCodeGeneratorTool missingRequiredProtocolFor:aClass.
                                requiredProtocolForClass do:[:sel | 
                                    |selectorInRed missingMethodPlaceHolder|

                                    selectorInRed := sel withColor:Color red.
                                    missingMethodPlaceHolder := MissingMethod mclass:aClass selector:sel.
                                    whatToDo value:aClass value:'required' value:selectorInRed value:missingMethodPlaceHolder.
                                ].
                            ].
                            allTestSelectors notEmptyOrNil ifTrue:[
                                allTestSelectors do:[:sel | 
                                    |methodPlaceHolder implClass|

                                    implClass := aClass whichClassImplements:sel.
                                    methodPlaceHolder := MethodStubForTestResult mclass:implClass selector:sel.
                                    whatToDo value:aClass value:'all tests' value:sel value:methodPlaceHolder.
                                ].
                            ].
                            anyInThisClass ifTrue:[ remainingClasses remove:aClass ifAbsent:nil. ].
                        ].
                    ].
                ].
                remainingClasses do:[:aClass |
                    whatToDo value:aClass value:nil value:nil value:nil.
                ].
                remainingCategories do:[:cat |
                    whatToDo value:nil value:cat value:nil value:nil.
                ]
            ]
      ]

    "Created: / 05-02-2000 / 13:42:10 / cg"
    "Modified: / 18-09-2011 / 12:51:45 / cg"
    "Modified: / 26-07-2016 / 23:31:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodCategoryList methodsFor:'private'!

class:cls protocol:cat includesMethodsInAnyPackage:packageFilter
    cls methodDictionary keysAndValuesDo:[:sel :mthd |
        mthd category == cat ifTrue:[
            (packageFilter includes:mthd package) ifTrue:[
                ^ true
            ]
        ]
    ].
    ^ false
!

class:cls protocol:cat includesModsOfClassVariable:variablesToHighLight
    "are there any methods in the protocol cat which modify any class variable in variablesToHighLight ?"

    ^ self class:cls protocol:cat includesRefsToVariable:variablesToHighLight askParserWith:#modifiedClassVars
!

class:cls protocol:cat includesModsOfInstanceVariable:variablesToHighLight
    "are there any methods in the protocol cat which modify any inst variable in variablesToHighLight ?"

    ^ self class:cls protocol:cat includesRefsToVariable:variablesToHighLight askParserWith:#modifiedInstVars
!

class:cls protocol:cat includesRefsToClassVariable:variablesToHighLight
    "are there any methods in the protocol cat which reference any class variable in variablesToHighLight ?"

    ^ self class:cls protocol:cat includesRefsToVariable:variablesToHighLight askParserWith:#usedClassVars
!

class:cls protocol:cat includesRefsToInstanceVariable:variablesToHighLight
    "are there any methods in the protocol cat which reference any inst variable in variablesToHighLight ?"

    ^ self class:cls protocol:cat includesRefsToVariable:variablesToHighLight askParserWith:#usedInstVars
!

class:cls protocol:cat includesRefsToVariable:variablesToHighLight askParserWith:querySelector
    "Are there any methods in the protocol cat which reference/modify any inst/class variable in variablesToHighLight?"

    |anyVarNameAccessible|

    anyVarNameAccessible := cls allInstVarNames includesAny:variablesToHighLight.
    anyVarNameAccessible ifFalse:[
        anyVarNameAccessible := cls theNonMetaclass allClassVarNames includesAny:variablesToHighLight.
    ].
    anyVarNameAccessible ifFalse:[
        "/ no need to parse
        ^ false
    ].

    cls selectorsAndMethodsDo:[:sel :mthd |
        |src parser usedVars|

        mthd category = cat ifTrue:[
            src := mthd source.
            src notNil ifTrue:[
                "
                 before doing a slow parse, quickly scan the
                 methods source for the variables name ...
                "
                (variablesToHighLight contains:[:varName | (src findString:varName) ~~ 0]) ifTrue:[
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
            ] ifFalse:[
                Transcript showCR:'Oops - cannot access method source'.
            ]        
        ]
    ].
    ^ false

    "Modified: / 06-07-2011 / 11:44:25 / cg"
!

classesToProcessForClasses:classes
    ^ self classesToProcessForClasses:classes withVisibility:methodVisibilityHolder value.
!

commonPostOpen
    super commonPostOpen.

    self showPseudoProtocols value ifTrue:[
        "/ revalidate my list, because it was only shown lazy
        self invalidateList.
    ].
!

flushMethodInfoForClassNamed:className selector:selector
    MethodInfoCacheAccessLock critical:[
        MethodInfoCache notNil ifTrue:[
            MethodInfoCache 
                removeKey:(className,'>>',selector)
                ifAbsent:[]
        ].
    ]

    "Modified: / 08-08-2011 / 19:16:32 / cg"
!

listOfMethodCategories
    |categoryList categoryBag plainCategories classesProcessed leafClassesProcessed
     generator nm variablesToHighlight classVarsToHighLight
     itemsWithVarRefs itemsWithVarMods itemsWithExtensions itemsWithSuppressedExtensions
     itemsInChangeSet itemsInRemoteChangeSet
     itemsWithInstrumentedMethods itemsWithCalledMethods itemsWithUncalledMethods
     itemsWithPartiallyCoveredMethods itemsWithFullyCoveredMethods
     packageFilterOnInput packageFilter showChanges nameListEntryForALL changeSet 
     emphasizedPlus emphasisForRef emphasisForMod
     numAll numObsolete numSuper numUncommented numDocumentation numLong numOverride
     numRedefine numRedefined numExtension numMissingRequired numSubclassResponsibility
     numAnnotated numFullyCovered numPartiallyCovered numUncovered numNotInstrumented 
     numAllTestResults numTestsNotPassed 
     showPseudoProtocols showCoverageInformation
     addPseudoEntry addPseudoEntryWithColor countAll pseudoEntryColor userPreferences
     startTime suppressPseudoProtocolsNow needsSpecialColoring|

    userPreferences := UserPreferences current.
    countAll := true.
    startTime := Timestamp now.
    suppressPseudoProtocolsNow := false.

    generator := inGeneratorHolder value.
    generator isNil ifTrue:[ ^ #() ].

    showPseudoProtocols := self showPseudoProtocols value.
    showCoverageInformation := self showCoverageInformation value.

    nameListEntryForALL := self class nameListEntryForALL.

    packageFilterOnInput := self packageFilterOnInput value.
    (packageFilterOnInput notNil and:[packageFilterOnInput includes:nameListEntryForALL]) ifTrue:[
        packageFilterOnInput := nil
    ].
    packageFilter := self packageFilter value.
    (packageFilter notNil and:[packageFilter includes:nameListEntryForALL]) ifTrue:[
        packageFilter := nil
    ].
    showChanges := false.
    (packageFilter notNil and:[packageFilter includes:self class nameListEntryForChanged]) ifTrue:[
        showChanges := true
    ].

    categoryList := Set new.
    categoryBag := Bag new.
    itemsWithVarRefs := Set new.
    itemsWithVarMods := Set new.
    itemsWithExtensions := Set new.
    itemsWithSuppressedExtensions := Set new.
    itemsInChangeSet := Set new.
    itemsInRemoteChangeSet := Set new.

    itemsWithInstrumentedMethods := Set new.
    itemsWithCalledMethods := Set new. 
    itemsWithUncalledMethods := Set new. 
    itemsWithPartiallyCoveredMethods := Set new.
    itemsWithFullyCoveredMethods := Set new.

    plainCategories := Set new.
    classesProcessed := IdentitySet new.
    leafClassesProcessed := IdentitySet new.
    variablesToHighlight := variableFilter value.
    classVarsToHighLight := filterClassVars value.
    numObsolete := numSuper := numUncommented := numDocumentation := numLong := 0.
    numRedefine := numRedefined := numOverride := numExtension := numMissingRequired := numSubclassResponsibility := 0.
    numNotInstrumented := numFullyCovered := numPartiallyCovered := numUncovered := 0.
    numAnnotated := numAllTestResults := numTestsNotPassed := 0.
    numAll := 0.

    generator do:[:clsIn :catIn | 
        |emptyProtocols clsName doHighLight doHighLightRed includedCats|

        includedCats := Set new.

        leafClassesProcessed add:clsIn.
        (self classesToProcessForClasses:(Array with:clsIn)) do:[:cls |
            |cats processCategory|

            classesProcessed add:cls.

            cls ~~ clsIn ifTrue:[
                cats := cls categories
            ] ifFalse:[
                cats := Array with:catIn.
            ].
            cats do:[:cat | 
                |suppress|

                cat notNil ifTrue:[
                    suppress := packageFilterOnInput notNil 
                                and:[ (self class:cls protocol:cat includesMethodsInAnyPackage:packageFilterOnInput) not ].
                    suppress ifFalse:[
                        includedCats add:cat.

                        variablesToHighlight notEmptyOrNil ifTrue:[
                            (itemsWithVarRefs includes:cat) ifFalse:[
                                classVarsToHighLight ifTrue:[
                                    doHighLight := self class:cls protocol:cat includesRefsToClassVariable:variablesToHighlight.
                                    doHighLight ifTrue:[
                                        doHighLightRed := self class:cls protocol:cat includesModsOfClassVariable:variablesToHighlight.
                                    ].
                                ] ifFalse:[
                                    doHighLight := self class:cls protocol:cat includesRefsToInstanceVariable:variablesToHighlight.
                                    doHighLight ifTrue:[
                                        doHighLightRed := self class:cls protocol:cat includesModsOfInstanceVariable:variablesToHighlight.
                                    ].
                                ].
                                doHighLight ifTrue:[
                                    itemsWithVarRefs add:cat.
                                    doHighLightRed ifTrue:[
                                        itemsWithVarMods add:cat.
                                    ].
                                ]
                            ]
                        ].

                        AdditionalEmptyCategoriesPerClassName size > 0 ifTrue:[
                            clsName := cls name.
                            emptyProtocols := AdditionalEmptyCategoriesPerClassName at:clsName ifAbsent:nil.
                            emptyProtocols size > 0 ifTrue:[
                                emptyProtocols remove:cat ifAbsent:nil.    
                            ].
                            emptyProtocols size == 0 ifTrue:[
                                AdditionalEmptyCategoriesPerClassName removeKey:clsName ifAbsent:nil
                            ].
                        ].
                    ]
                ]
            ].

            cats := cats asSet.

            cls selectorsAndMethodsDo:[:sel :mthd |
                |info cat suppress|

                (includedCats includes:(cat := mthd category)) ifTrue:[
                    suppress := packageFilter notNil 
                                and:[ (packageFilter includes:mthd package) not 
                                and:[ showChanges not ]].
                    suppress ifFalse:[
                        numAll := numAll + 1.
                        categoryBag add:cat.
                        (showPseudoProtocols and:[suppressPseudoProtocolsNow not]) ifTrue:[
                            info := self methodInfoFor:mthd in:cls selector:sel lazy:suppressPseudoProtocolsNow.
                            info notNil ifTrue:[
                                info isObsolete ifTrue:[ numObsolete := numObsolete + 1 ].
                                info sendsSuper ifTrue:[ numSuper := numSuper + 1 ].
                                info isUncommented ifTrue:[ numUncommented := numUncommented + 1 ].
                                info isDocumentationMethod ifTrue:[ numDocumentation := numDocumentation + 1 ].
                                info isLongMethod ifTrue:[ numLong := numLong + 1 ].
                                info isExtensionMethod ifTrue:[ numExtension := numExtension + 1 ].
                                info isOverride ifTrue:[ numOverride := numOverride + 1 ].
                                info isRedefine ifTrue:[ numRedefine := numRedefine + 1 ].
                                info isRedefined ifTrue:[ numRedefined := numRedefined + 1 ].
                                info isSubclassResponsibility ifTrue:[ numSubclassResponsibility := numSubclassResponsibility + 1].
                                info isAnnotated ifTrue:[ numAnnotated := numAnnotated + 1].
                            ].
                            (Timestamp now secondDeltaFrom:startTime) > 5 ifTrue:[
                                suppressPseudoProtocolsNow := true.
                                "/ because we already computed for 5 seconds, more and more will be found in
                                "/ the cache, and eventually, pseudo protocols will be shown anyway
                                masterApplication showInfo:'suppress pseudo protocols - parsing took too long'.
                                "/ self enqueueDelayedUpdateList.
                            ].
                        ]
                    ]
                ].
            ].
        ]
    ].

    changeSet := ChangeSet current.

    classesProcessed do:[:eachClass |
        |classPackage required testOutcomes isTestCaseClass|

        isTestCaseClass := eachClass isTestCaseLike and:[eachClass isMeta not and:[eachClass isAbstract not]].
        (showSyntheticMethods value ? true) ifTrue:[
            isTestCaseClass ifTrue:[
                testOutcomes := eachClass testSelectorsWithLastOutcomes.
                numAllTestResults := numAllTestResults + testOutcomes size.
            ].
        ].

        classPackage := eachClass package.
        eachClass methodDictionary keysAndValuesDo:[:mSelector :mthd |
            |mPackage mCategory|

            mPackage := mthd package.
            mCategory := mthd category.    

            #fixme.
            mPackage = classPackage ifTrue:[
                mPackage ~~ classPackage ifTrue:[
                    mthd setPackage:(mPackage := mPackage string asSymbol).
                ]
            ].
            mPackage ~~ classPackage ifTrue:[
                (mCategory notNil and:[mPackage ~= PackageId noProjectID]) ifTrue:[
                    (packageFilter notNil 
                    and:[ (packageFilter includes:mPackage) not])
                    ifTrue:[
                        itemsWithSuppressedExtensions add:mCategory.    
                    ] ifFalse:[
                        itemsWithExtensions add:mCategory.    
                    ]
                ].
            ].

            showCoverageInformation ifTrue:[
                mthd category = 'documentation' ifFalse:[
                    mthd isInstrumented ifTrue:[
                        itemsWithInstrumentedMethods add:mCategory.
                        mthd hasBeenCalled ifTrue:[
                            itemsWithCalledMethods add:mCategory.
                            mthd haveAllBlocksBeenExecuted ifTrue:[
                                itemsWithFullyCoveredMethods add:mCategory.
                                numFullyCovered := numFullyCovered + 1.
                            ] ifFalse:[
                                itemsWithPartiallyCoveredMethods add:mCategory.
                                numPartiallyCovered := numPartiallyCovered + 1.
                            ].
                        ] ifFalse:[
                            itemsWithUncalledMethods add:mCategory.
                            numUncovered := numUncovered + 1.
                        ].
                    ] ifFalse:[
                        numNotInstrumented := numNotInstrumented + 1.
                    ].
                ].
            ].
            
            (changeSet includesChangeForClass:eachClass selector:mSelector) ifTrue:[
                (packageFilter notNil 
                and:[ (packageFilter includes:mPackage) not])
                ifTrue:[
                    "/ itemsInChangeSetSuppressed add:mCategory.    
                ] ifFalse:[
                    itemsInChangeSet add:mCategory.    
                ]
            ].
            (SmallTeam notNil and:[ SmallTeam includesChangeForClass:eachClass selector:mSelector] ) ifTrue:[
                itemsInRemoteChangeSet add:mCategory.    
            ].
            isTestCaseClass ifTrue:[
                (eachClass isTestSelector:mSelector) ifTrue:[
                    |lastResultOrNil|
                    
                    lastResultOrNil := eachClass asTestCase rememberedOutcomeFor:mSelector.
                    (lastResultOrNil isNil or:[lastResultOrNil result ~~ TestResult statePass]) ifTrue:[
                        numTestsNotPassed := numTestsNotPassed + 1
                    ]    
                ].    
            ].
            
            testOutcomes notNil ifTrue:[ testOutcomes remove: mSelector ifAbsent:[] ].
        ].

        (packageFilter isNil or:[ packageFilter includes:eachClass package ]) ifTrue:[
            (showPseudoProtocols and:[suppressPseudoProtocolsNow not]) ifTrue:[
                (showSyntheticMethods value ? true) ifTrue:[   
                    "/ see if there is a subclassResponsibility in a superclass
                    required := SmalltalkCodeGeneratorTool missingRequiredProtocolFor:eachClass.
                    numMissingRequired := numMissingRequired + required size.
                ].
            ].
        ].
    ].

    pseudoEntryColor := self class pseudoEntryForegroundColor.

    categoryList := categoryBag asSet asOrderedCollection.
    self rawProtocolList removeAll.
    rawProtocolList addAll:categoryList.

    emphasizedPlus := (self colorizeForDifferentPackage:' [ + ]').
    emphasisForRef := userPreferences emphasisForReadVariable.
    emphasisForMod := userPreferences emphasisForWrittenVariable.

    needsSpecialColoring :=
        (itemsInChangeSet notEmpty 
        or:[itemsInRemoteChangeSet notEmpty
        or:[itemsWithExtensions notEmpty
        or:[itemsWithVarRefs notEmpty
        or:[itemsWithInstrumentedMethods notEmpty
        or:[itemsWithCalledMethods notEmpty
        or:[itemsWithUncalledMethods notEmpty
        or:[itemsWithFullyCoveredMethods notEmpty
        or:[itemsWithPartiallyCoveredMethods notEmpty]]]]]]]]).

    rawProtocolList keysAndValuesDo:[:idx :cat |
        |item inChangeSet inRemoteChangeSet hasExtensions hasVarRef hasVarMod
         clr|

        item := cat.

        needsSpecialColoring ifTrue:[
            inChangeSet := false.

            showCoverageInformation ifTrue:[
                (itemsWithInstrumentedMethods includes:cat) ifTrue:[
                    (itemsWithCalledMethods includes:cat) ifTrue:[
                        (itemsWithPartiallyCoveredMethods includes:cat) ifTrue:[
                            clr := (userPreferences colorForInstrumentedPartiallyCoveredCode).
                        ] ifFalse:[
                            (itemsWithUncalledMethods includes:cat) ifTrue:[
                                clr := (userPreferences colorForInstrumentedPartiallyCoveredCode).
                            ] ifFalse:[
                                 clr := (userPreferences colorForInstrumentedFullyCoveredCode).
                            ]                    
                        ]
                    ] ifFalse:[
                        clr := (userPreferences colorForInstrumentedNeverCalledCode).
                    ].
                    item := self colorize:cat with:(#color -> clr).
                ]
            ].
            clr isNil ifTrue:[
                inChangeSet := itemsInChangeSet includes:cat.
                inChangeSet ifTrue:[
                    item := self colorizeForChangedCode:cat.
                ].

                inRemoteChangeSet := itemsInRemoteChangeSet includes:cat.
                inRemoteChangeSet ifTrue:[
                    item := (self colorizeForChangedCodeInSmallTeam:'!! '),item.
                ].
            ].

            hasVarRef := itemsWithVarRefs includes:cat.
            hasVarRef ifTrue:[
                hasVarMod := itemsWithVarMods includes:cat.
                item := item asText 
                            emphasisAllAdd:(hasVarMod ifTrue:[emphasisForMod] ifFalse:[emphasisForRef]).
            ].
        ].


        item := item , ((' (%1)' bindWith:(categoryBag occurrencesOf:cat)) 
                            withColor:pseudoEntryColor).

        needsSpecialColoring ifTrue:[
            hasExtensions := itemsWithExtensions includes:cat.
            hasExtensions ifTrue:[
                item := item , emphasizedPlus.
            ].
            inChangeSet ifTrue:[
                item := item , self class markForBeingInChangeList.
            ].
        ].

        categoryList at:idx put:item.
    ].

    classesProcessed size > 0 ifTrue:[
        "/ those are simulated - in ST/X, empty categories do not
        "/ really exist; however, during browsing, it makes sense.
        AdditionalEmptyCategoriesPerClassName size > 0 ifTrue:[
            AdditionalEmptyCategoriesPerClassName keysAndValuesDo:[:clsName :protocols |
                (classesProcessed contains:[:cls | cls name = clsName]) ifTrue:[
                    categoryList addAll:protocols.
                    rawProtocolList addAll:protocols.
                ]
            ]
        ].
    ].

    self makeIndependent.
    classes := classesProcessed.
    leafClasses := leafClassesProcessed.
    self makeDependent.

    rawProtocolList sortWith:categoryList.
    categoryList size == 1 ifTrue:[
        nm := categoryList first string.
        classes size == 1 ifTrue:[
            nm := ((classes first name) ? '*unnamed*') , '-' , nm
        ].
        self protocolLabelHolder value:nm
    ].

    categoryList notEmpty ifTrue:[
        noAllItem value ~~ true ifTrue:[
            |allName|

            countAll ifTrue:[
                allName := self class nameListEntryForALLWithCount bindWith:numAll.
            ] ifFalse:[
                allName := nameListEntryForALL.
            ].
            categoryList addFirst:(allName allItalic withColor:pseudoEntryColor).
            rawProtocolList addFirst:nameListEntryForALL.
        ].
    ].

    (showPseudoProtocols and:[suppressPseudoProtocolsNow not]) ifTrue:[
        addPseudoEntryWithColor := [:s :n :clr | 
                                n > 0 ifTrue:[
                                    categoryList 
                                        add:((s bindWith:n) allItalic withColor:clr).
                                    rawProtocolList add:s.
                                ].
                           ].

        addPseudoEntry := [:s :n | addPseudoEntryWithColor value:s value:n value:pseudoEntryColor].

        addPseudoEntry value:self class nameListEntryForAnnotated value:numAnnotated.
        addPseudoEntry value:self class nameListEntryForDocumentation value:numDocumentation.
        addPseudoEntry value:self class nameListEntryForExtensions value:numExtension.
        addPseudoEntry value:self class nameListEntryForLong value:numLong.
        addPseudoEntry value:self class nameListEntryForMustBeRedefinedInSubclass value:numSubclassResponsibility.
        addPseudoEntry value:self class nameListEntryForObsolete value:numObsolete.
        addPseudoEntry value:self class nameListEntryForOverride value:numOverride.
        addPseudoEntry value:self class nameListEntryForRedefine value:numRedefine.
        addPseudoEntry value:self class nameListEntryForRedefined value:numRedefined.
        "/ I think red is too much of an alert color (and we get more of them as we think...)
"/        numMissingRequired > 0 ifTrue:[
"/            categoryList add:((self class nameListEntryForRequired bindWith:numMissingRequired) allItalic "colorizeAllWith:Color red").
"/            rawProtocolList add:self class nameListEntryForRequired.
"/        ].
        addPseudoEntry value:self class nameListEntryForRequired value:numMissingRequired.
        addPseudoEntry value:self class nameListEntryForSuperSend value:numSuper.
        addPseudoEntry value:self class nameListEntryForUncommented value:numUncommented.
        addPseudoEntry value:self class nameListEntryForAllTests value:numAllTestResults.
        addPseudoEntry value:self class nameListEntryForTestsNotPassed value:numTestsNotPassed.
        
        showCoverageInformation ifTrue:[                                                                              
            addPseudoEntry value:self class nameListEntryForNotInstrumented value:numNotInstrumented.
            addPseudoEntryWithColor value:self class nameListEntryForUncovered value:numUncovered value:userPreferences colorForInstrumentedNeverCalledCode.
            addPseudoEntryWithColor value:self class nameListEntryForPartiallyCovered value:numPartiallyCovered value:userPreferences colorForInstrumentedPartiallyCoveredCode.
            addPseudoEntryWithColor value:self class nameListEntryForFullyCovered value:numFullyCovered value:userPreferences colorForInstrumentedFullyCoveredCode.
        ].

    ].
    ^ categoryList

    "Created: / 05-02-2000 / 13:42:11 / cg"
    "Modified: / 08-09-2011 / 04:56:47 / cg"
    "Modified: / 26-07-2016 / 23:31:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeDependent
    environment addDependent:self.
"/    ChangeSet addDependent:self.

    "Modified: / 10-11-2006 / 17:57:13 / cg"
!

makeIndependent
    environment removeDependent:self.
"/    ChangeSet removeDependent:self.
!

release
    super release.

    filterClassVars removeDependent:self.
    methodVisibilityHolder removeDependent:self.
    noAllItem removeDependent:self.
    packageFilterOnInput removeDependent:self.
    selectedProtocolIndices removeDependent:self.
    variableFilter removeDependent:self.
!

updateList
    |prevClasses prevSelection newSelection newList oldList sameContents selectedProtocolsHolder rawList|

    selectedProtocolsHolder := self selectedProtocols.
    
    prevClasses := classes isNil ifTrue:[ #() ] ifFalse:[ classes copy ].
    oldList := self protocolList value copy.
    newList := self listOfMethodCategories.

    "/ oldListSize := self browserNameList size.
    "/ newListSize := newList size.
    self selectedProtocolIndices removeDependent:self.
    sameContents := self updateListFor:newList.
    self selectedProtocolIndices addDependent:self.
    sameContents ifFalse:[
        prevSelection := lastSelectedProtocols ? (selectedProtocolsHolder value) ? #().
        "/ prevSelection := selectedProtocolsHolder value ? lastSelectedProtocols ? #().

        rawList := self rawProtocolList value.
        newSelection := prevSelection select:[:item | item notNil and:[rawList includes:item string]].

        newSelection size > 0 ifTrue:[
            "/ force change (for dependents)
"/                selectedProtocolsHolder value:nil.
"/                selectedProtocolsHolder value:newSelection.
            selectedProtocolsHolder setValue:newSelection.
            selectedProtocolsHolder removeDependent:self.    
            selectedProtocolsHolder changed:#value.
            selectedProtocolsHolder addDependent:self.    
        ] ifFalse:[
            prevSelection := selectedProtocolsHolder value.
            selectedProtocolsHolder value:nil.
        ].
        (prevSelection size > 0 or:[newSelection size > 0]) ifTrue:[
            self enqueueDelayedUpdateOutputGenerator.
            "/ self updateOutputGenerator.
        ].

"/        prevSelection notNil ifTrue:[
"/            lastSelectedProtocols := prevSelection.
"/        ].
    ] ifTrue:[
        "/ same list - but classes might have changed
        "/ that is the case, if the class selection has been changed,
        "/ to another class which has the same categories.
        (prevClasses size ~= classes size 
        or:[prevClasses asOrderedCollection ~= (classes ? #()) asOrderedCollection ]) ifTrue:[
            (newList size > 0 or:[oldList size > 0]) ifTrue:[
                self updateOutputGenerator
            ]
        ] ifFalse:[
"/                self protocolList value:newList.
        ]
    ].
    self setListValid:true.

    "Created: / 05-02-2000 / 13:42:11 / cg"
    "Modified: / 23-03-2012 / 15:53:41 / cg"
! !

!MethodCategoryList methodsFor:'private-info'!

methodInfoFor:aMethod in:mclass selector:selector
    ^ self methodInfoFor:aMethod in:mclass selector:selector lazy:false

    "Modified: / 08-08-2011 / 18:21:03 / cg"
!

methodInfoFor:aMethod in:mclass selector:selector lazy:lazy
    |info isDocumentationMethod isVersionMethod def methodsPackage|

    "/ the first at:ifAbsent: is actually not needed - it is here to
    "/ reduce the average blocking time, and to allow for debugging the info generating
    "/ code without deadlock
    MethodInfoCacheAccessLock critical:[
        info := MethodInfoCache at:aMethod "(mclass name,'>>',selector)" ifAbsent:nil.
    ].
    info isNil ifTrue:[
        lazy ifTrue:[
            "/ TODO: start a background thread to compute the stuff below,
            "/ notify me to update the list, when all the lazy info is avail...
        ] ifFalse:[
            true "aMethod mclass language isenvironment" ifTrue:[
                methodsPackage := aMethod package.

                isVersionMethod := aMethod isVersionMethod.
                isDocumentationMethod := isVersionMethod not and:[aMethod isDocumentationMethod].

                info := CachedMethodInfo new.
                info isObsolete:(aMethod isObsolete). "/ (aMethod isObsolete).
                info sendsSuper:(aMethod superMessages notEmptyOrNil). "/ (aMethod superMessages notEmptyOrNil).
                info isUncommented:(self methodIsMarkedAsUncommented:aMethod). "/ (self methodIsMarkedAsUncommented:aMethod).
                info isDocumentationMethod:isDocumentationMethod.
                info isLongMethod:(self methodIsMarkedAsLong:aMethod). "/ (self methodIsMarkedAsLong:aMethod).

                methodsPackage ~= mclass package ifTrue:[
                    methodsPackage ~= #'__NoProject__' ifTrue:[
                        info isExtensionMethod:true.
                        info isOverride:(
                                          ((def := methodsPackage asPackageId projectDefinitionClass) notNil
                                          and:[ (def methodOverwrittenBy:aMethod ) notNil ]) 
                                        )
                    ]
                ] ifFalse:[
                    info isExtensionMethod:false.
                    info isOverride:false.
                ].
                info isRedefine:(
                                    ( isVersionMethod not
                                    and:[ isDocumentationMethod not
                                    and:[ mclass superclass notNil
                                    and:[ (mclass superclass whichClassIncludesSelector:selector ) notNil ]]]) 
                                ).
"/ too expensive - makes browser slow
"/                info isRedefined:(
"/                                    ( isVersionMethod not
"/                                    and:[ isDocumentationMethod not
"/                                    and:[ mclass allSubclasses contains:[:cls | cls includesSelector:selector ]]]) 
"/                                ).

                info isSubclassResponsibility:( aMethod sendsAny:#( #subclassResponsibility #subclassResponsibility: )).
                info isAnnotated:(aMethod hasAnnotation).

                MethodInfoCacheAccessLock critical:[
                    MethodInfoCache at:aMethod "(mclass name,'>>',selector)" put:info
                ].
            ].
        ].
    ].
    ^ info

    "Created: / 08-08-2011 / 18:18:14 / cg"
!

methodIsMarkedAsLong:aMethod
    "if true, it will be also categorized under the pseudo category 'long'"

    |src ast linesWithCode visitor|

    src := aMethod source ? ''.
    src asCollectionOfLines size < UserPreferences current numberOfLinesForLongMethod "~~30" ifTrue:[^ false].

    "/ ok, it is long;
    "/ but do not blame the user for writing documentation (don't count comments),
    "/ or using literal arrays
    RBParser notNil ifTrue:[
        ast := RBParser parseMethod:src.
        ast notNil ifTrue:[
            visitor := RBProgramNodeVisitor new.
            visitor pluggableNodeAction:
                [:eachNode |
                    |lno|
                    lno := eachNode lineNumber.
                    lno notNil ifTrue:[ linesWithCode add:lno ].
                ].

            linesWithCode := Set new.
            ast acceptVisitor:visitor.
            linesWithCode size < UserPreferences current numberOfLinesForLongMethod "~~30" ifTrue:[^ false].
        ].
    ].
    ^ true.
!

methodIsMarkedAsUncommented:aMethod
    "if true, it will be also categorized under the pseudo category 'undocumented'"

    ^ aMethod comment isEmptyOrNil 
    and:[aMethod isVersionMethod not]
! !

!MethodCategoryList methodsFor:'special'!

addAdditionalProtocol:aProtocol forClass:aClass
    "those are simulated - in ST/X, empty categories do not really exist; 
     (because the category is an attribute of the method)
     However, during browsing, it makes sense. Therefore, empty categories are
     remembered here"

    |categories|

    AdditionalEmptyCategoriesPerClassName isNil ifTrue:[
        AdditionalEmptyCategoriesPerClassName := Dictionary new.
    ].
    categories := AdditionalEmptyCategoriesPerClassName at:aClass name ifAbsent:nil.
    categories isNil ifTrue:[
        categories := Set new.
        AdditionalEmptyCategoriesPerClassName at:aClass name put:categories.
    ].
    categories add:aProtocol.
    aClass changed:#organization.                                                       "/ not really ... to force update
    environment changed:#methodCategoryAdded with:(Array with:aClass with:aProtocol).     "/ not really ... to force update

    "Modified (comment): / 01-08-2012 / 17:30:36 / cg"
!

additionalProtocolForClass:aClass
    "those are simulated - in ST/X, empty categories do not really exist; 
     (because the category is an attribute of the method)
     However, during browsing, it makes sense. Therefore, empty categories are
     remembered here"

    AdditionalEmptyCategoriesPerClassName isNil ifTrue:[ ^ #() ].
    ^ AdditionalEmptyCategoriesPerClassName at:aClass name ifAbsent:[ #() ].

    "Modified (comment): / 01-08-2012 / 17:29:16 / cg"
!

clearLastSelectedProtocol
    lastSelectedProtocols := nil
!

lastSelectedProtocols
    ^ lastSelectedProtocols
!

removeAdditionalProtocol:aListOfProtocols forClass:aClass
    "those are simulated - in ST/X, empty categories do not really exist; 
     (because the category is an attribute of the method)
     However, during browsing, it makes sense. Therefore, empty categories are
     remembered here"

    |categories|

    AdditionalEmptyCategoriesPerClassName isNil ifTrue:[^ self].

    categories := AdditionalEmptyCategoriesPerClassName at:aClass name ifAbsent:nil.
    categories isNil ifTrue:[^ self].
    categories removeAllFoundIn:aListOfProtocols.
    categories isEmpty ifTrue:[
        AdditionalEmptyCategoriesPerClassName removeKey:aClass name.
    ].

    aClass changed:#organization.                      "/ not really ... to force update
    environment changed:#methodCategoriesRemoved with:(Array with:aClass with:aListOfProtocols).     "/ not really ... to force update

    "Modified (comment): / 01-08-2012 / 17:29:59 / cg"
!

removeAllAdditionalProtocol
    "those are simulated - in ST/X, empty categories do not really exist; 
     (because the category is an attribute of the method)
     However, during browsing, it makes sense. Therefore, empty categories are
     remembered here"

    AdditionalEmptyCategoriesPerClassName := nil

    "Modified (comment): / 01-08-2012 / 17:30:05 / cg"
!

removeAllAdditionalProtocolForClass:aClass
    "those are simulated - in ST/X, empty categories do not really exist; 
     (because the category is an attribute of the method)
     However, during browsing, it makes sense. Therefore, empty categories are
     remembered here"

    AdditionalEmptyCategoriesPerClassName notNil ifTrue:[
        AdditionalEmptyCategoriesPerClassName removeKey:aClass name ifAbsent:nil
    ].

    "Modified (comment): / 01-08-2012 / 17:30:10 / cg"
!

renameAdditionalProtocol:oldName to:newName forClass:aClass
    "those are simulated - in ST/X, empty categories do not really exist; 
     (because the category is an attribute of the method)
     However, during browsing, it makes sense. Therefore, empty categories are
     remembered here"

    |categories|

    AdditionalEmptyCategoriesPerClassName isNil ifTrue:[^ self].
    categories := AdditionalEmptyCategoriesPerClassName at:aClass name ifAbsent:nil.
    categories isNil ifTrue:[^ self].
    categories remove:oldName ifAbsent:nil.
    categories add:newName.

    aClass changed:#organization.                      "/ not really ... to force update
    environment changed:#methodCategoryRenamed with:(Array with:aClass with:oldName with:newName).     "/ not really ... to force update

    "Modified (comment): / 01-08-2012 / 17:30:16 / cg"
! !

!MethodCategoryList::CachedMethodInfo class methodsFor:'initialization'!

initialize
    FlagObsolete := 1.
    FlagSendsSuper := 2.
    FlagIsUncommented := 4.
    FlagIsDocumentationMethod := 8.
    FlagIsLongMethod := 16.
    FlagIsExtension := 32.
    FlagIsOverride := 64.
    FlagIsRedefine := 128.
    FlagIsSubclassResponsibility := 128.
    FlagIsTest := 256.
    FlagIsAnnotated := 512.
    FlagIsRedefined := 1024.

    "Modified: / 08-03-2010 / 18:33:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 10:04:30 / cg"
! !

!MethodCategoryList::CachedMethodInfo class methodsFor:'instance creation'!

new
    ^ self basicNew flags:0.
! !

!MethodCategoryList::CachedMethodInfo methodsFor:'accessing'!

flags:something
    flags := something.
!

isAnnotated
    ^ (flags ? 0) bitTest: FlagIsAnnotated

    "Created: / 07-09-2011 / 10:04:56 / cg"
!

isAnnotated:aBoolean
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagIsAnnotated ]
                ifFalse:[ flags bitClear: FlagIsAnnotated]

    "Created: / 07-09-2011 / 10:04:48 / cg"
!

isDocumentationMethod
    ^ (flags ? 0) bitTest: FlagIsDocumentationMethod
!

isDocumentationMethod:aBoolean
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagIsDocumentationMethod ]
                ifFalse:[ flags bitClear: FlagIsDocumentationMethod]
!

isExtensionMethod
    ^ (flags ? 0) bitTest: FlagIsExtension
!

isExtensionMethod:aBoolean
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagIsExtension ]
                ifFalse:[ flags bitClear: FlagIsExtension]
!

isLongMethod
    ^ (flags ? 0) bitTest: FlagIsLongMethod
!

isLongMethod:aBoolean
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagIsLongMethod ]
                ifFalse:[ flags bitClear: FlagIsLongMethod]
!

isObsolete
    ^ (flags ? 0) bitTest: FlagObsolete
!

isObsolete:aBoolean
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagObsolete ]
                ifFalse:[ flags bitClear: FlagObsolete]
!

isOverride
    ^ (flags ? 0) bitTest: FlagIsOverride
!

isOverride:aBoolean
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagIsOverride ]
                ifFalse:[ flags bitClear: FlagIsOverride]
!

isRedefine
    ^ (flags ? 0) bitTest: FlagIsRedefine
!

isRedefine:aBoolean
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagIsRedefine ]
                ifFalse:[ flags bitClear: FlagIsRedefine]
!

isRedefined
    ^ (flags ? 0) bitTest: FlagIsRedefined
!

isRedefined:aBoolean
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagIsRedefined ]
                ifFalse:[ flags bitClear: FlagIsRedefined]
!

isSubclassResponsibility
    ^ (flags ? 0) bitTest: FlagIsSubclassResponsibility
!

isSubclassResponsibility:aBoolean
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagIsSubclassResponsibility ]
                ifFalse:[ flags bitClear: FlagIsSubclassResponsibility]
!

isTest
    ^ (flags ? 0) bitTest: FlagIsTest

    "Created: / 08-03-2010 / 18:41:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUncommented
    ^ (flags ? 0) bitTest: FlagIsUncommented
!

isUncommented:aBoolean 
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagIsUncommented ]
                ifFalse:[ flags bitClear: FlagIsUncommented]
!

sendsSuper
    ^ (flags ? 0) bitTest: FlagSendsSuper
!

sendsSuper:aBoolean
    flags := aBoolean
                ifTrue:[ flags bitOr: FlagSendsSuper ]
                ifFalse:[ flags bitClear: FlagSendsSuper]
! !

!MethodCategoryList::MissingMethod class methodsFor:'instance creation'!

mclass:aClass selector:aSelector
    ^ self new mclass:aClass selector:aSelector
! !

!MethodCategoryList::MissingMethod methodsFor:'accessing'!

mclass
    ^ mclass
!

mclass:aClass
    mclass := aClass
!

mclass:aClass selector:aSelector
    mclass := aClass.
    selector := aSelector.
!

selector
    ^ selector
!

selector:something
    selector := something.
!

source
    ^ (SmalltalkCodeGeneratorTool basicNew
        codeFor_shouldImplementFor:selector inClass:mclass) 
            withColor:Color red

    "Modified: / 31-01-2011 / 18:29:17 / cg"
! !

!MethodCategoryList::MissingMethod methodsFor:'printing & storing'!

printStringForBrowserWithSelector:selector inClass:aClass
    ^ (selector,' (** missing required **)') withColor:Color red
! !

!MethodCategoryList::MissingMethod methodsFor:'queries'!

containingClass
    | savedMclass |

    "/ Save mclass here as Method>>containingClass clobbers it!!
    [
        savedMclass := mclass.
        super containingClass
    ] ensure:[ 
        mclass := savedMclass
    ].

    "Created: / 01-04-2014 / 12:21:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSynthetic
    ^ true
!

who
    | savedMclass |

    "/ Save mclass here as Method>>who clobbers it!!
    [
        savedMclass := mclass.
        super who
    ] ensure:[ 
        mclass := savedMclass
    ].

    "Created: / 01-04-2014 / 12:28:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodCategoryList::MethodStubForTestResult methodsFor:'accessing'!

source
    ^ (mclass compiledMethodAt:selector) source  
            withColor:Color grey
! !

!MethodCategoryList::MethodStubForTestResult methodsFor:'printing & storing'!

printStringForBrowserWithSelector:selector inClass:aClass
    ^ (selector,' (** from ',self mclass name,' **)') withColor:Color gray
! !

!MethodCategoryList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


MethodCategoryList initialize!
MethodCategoryList::CachedMethodInfo initialize!
