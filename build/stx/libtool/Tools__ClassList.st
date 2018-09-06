"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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

BrowserList subclass:#ClassList
	instanceVariableNames:'classList classNameList meta lastSelectedClasses
		selectedClassNameIndices currentNamespace hidePrivateClasses
		unloadedClassesColor markApplicationsHolder classFilterBlock
		sortByNameAndInheritance outGeneratorHolderForMethods
		addOwnerClasses ownersAddedForTheirPrivateClassesOnly'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!ClassList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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
    embeddable application displaying the classes as listed by
    the inputGenerator.
    Provides an outputGenerator, which enumerates the classes and
    their protocols (method-categories) in the selected classes.

    [author:]
	Claus Gittinger (cg@exept.de)
"


! !

!ClassList class methodsFor:'interface specs'!

singleClassWindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ClassList andSelector:#singleClassWindowSpec
     ClassList new openInterface:#singleClassWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #windowSpec
	#window: 
       #(#WindowSpec
	  #label: 'ClassList'
	  #name: 'ClassList'
	  #min: #(#Point 0 0)
	  #max: #(#Point 1024 721)
	  #bounds: #(#Rectangle 12 22 312 322)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'ClassName'
	      #name: 'ClassLabel'
	      #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 25 0)
	      #translateLabel: true
	      #labelChannel: #classLabelHolder
	      #menu: #menuHolder
	    )
"/           #(#UISubSpecification
"/              #name: 'MetaToggleSpec'
"/              #layout: #(#LayoutFrame 0 0.0 -25 1.0 0 1.0 0 1.0)
"/              #minorKey: #metaSpec
"/            )
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
     UIPainter new openOnClass:ClassList andSelector:#windowSpec
     ClassList new openInterface:#windowSpec
     ClassList open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'ClassList'
          #name: 'ClassList'
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
              #model: #selectedClassNameIndices
              #menu: #menuHolder
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #valueChangeSelector: #selectionChangedByClick
              #useIndex: true
              #sequenceList: #classNameList
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

!ClassList class methodsFor:'plugIn spec'!

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
        #currentNamespace
        #(#doubleClickChannel #action )
        #forceGeneratorTrigger
        #hidePrivateClasses
        #hideUnloadedClasses
        #sortByNameAndInheritance
        #immediateUpdate
        #inGeneratorHolder
        #menuHolder
        #meta
        #organizerMode
        #outGeneratorHolder
        #packageFilter
        #nameSpaceFilter
        #selectedClasses
        #selectionChangeCondition
        #showClassPackages
        #slaveMode
        #updateTrigger
        #markApplicationsHolder
        #showCoverageInformation
        #outGeneratorHolderForMethods
      ).

    "Modified: / 04-07-2011 / 18:34:44 / cg"
    "Modified: / 24-02-2014 / 10:37:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassList methodsFor:'accessing'!

markApplications
    "return the value of the instance variable 'markApplications' (automatically generated)"

    ^ self markApplicationsHolder value

    "Created: / 3.11.2001 / 14:06:19 / cg"
!

markApplications:something
    "set the value of the instance variable 'markApplications' (automatically generated)"

    self markApplicationsHolder value:something.

    "Created: / 3.11.2001 / 14:06:25 / cg"
!

unloadedClassesColor
    "return the value of the instance variable 'unloadedClassesColor' (automatically generated)"

    ^ unloadedClassesColor
!

unloadedClassesColor:something
    "set the value of the instance variable 'unloadedClassesColor' (automatically generated)"

    unloadedClassesColor := something.
! !

!ClassList methodsFor:'aspects'!

addOwnerClasses
    addOwnerClasses isNil ifTrue:[
        addOwnerClasses := ValueHolder with:true.
        addOwnerClasses addDependent:self.
    ].
    ^ addOwnerClasses.
!

addOwnerClasses:aBooleanValueHolder
    addOwnerClasses notNil ifTrue:[
        addOwnerClasses removeDependent:self
    ].
    addOwnerClasses := aBooleanValueHolder.
    addOwnerClasses notNil ifTrue:[
        addOwnerClasses addDependent:self
    ].
!

classLabelHolder
    ^ self pseudoListLabelHolder
!

classList
    classList isNil ifTrue:[
	classList := ValueHolder new.
    ].
    ^ classList

    "Created: / 5.2.2000 / 13:42:16 / cg"
    "Modified: / 25.2.2000 / 02:21:07 / cg"
!

classNameList
    classNameList isNil ifTrue:[
	classNameList := ValueHolder new
    ].
    ^ classNameList
!

currentNamespace:aValueHolder
    currentNamespace notNil ifTrue:[
	currentNamespace removeDependent:self
    ].
    currentNamespace := aValueHolder.
    currentNamespace notNil ifTrue:[
	currentNamespace isBehavior ifTrue:[self halt:'should not happen'].
	currentNamespace addDependent:self
    ].

    "Modified: / 4.2.2000 / 23:34:28 / cg"
    "Created: / 5.2.2000 / 21:37:57 / cg"
!

doubleClick
    self halt:'should not happen'.
!

hidePrivateClasses
    hidePrivateClasses isNil ifTrue:[
        hidePrivateClasses := ValueHolder with:false.
        hidePrivateClasses addDependent:self.
    ].
    ^ hidePrivateClasses.

    "Created: / 24.2.2000 / 15:06:44 / cg"
!

hidePrivateClasses:aValueHolder
    hidePrivateClasses notNil ifTrue:[
	hidePrivateClasses removeDependent:self
    ].
    hidePrivateClasses := aValueHolder.
    hidePrivateClasses notNil ifTrue:[
	hidePrivateClasses addDependent:self
    ].

    "Created: / 24.2.2000 / 15:06:46 / cg"
!

markApplicationsHolder
    markApplicationsHolder isNil ifTrue:[
        markApplicationsHolder := ValueHolder with:true.
        markApplicationsHolder addDependent:self.
    ].
    ^ markApplicationsHolder.
!

markApplicationsHolder:aValueHolder
    markApplicationsHolder notNil ifTrue:[
	markApplicationsHolder removeDependent:self
    ].
    markApplicationsHolder := aValueHolder.
    markApplicationsHolder notNil ifTrue:[
	markApplicationsHolder addDependent:self
    ].

    "Created: / 24.2.2000 / 15:06:46 / cg"
!

meta
    meta isNil ifTrue:[
        meta := ValueHolder with:false.
        meta addDependent:self
    ].
    ^ meta

    "Modified: / 31.1.2000 / 01:19:59 / cg"
    "Created: / 5.2.2000 / 13:42:16 / cg"
!

meta:aValueHolder
"/ (aValueHolder == true or:[aValueHolder == false]) ifTrue:[self halt].

    meta notNil ifTrue:[
	meta removeDependent:self
    ].
    meta := aValueHolder.
    meta notNil ifTrue:[
	meta addDependent:self
    ].
!

selectClass:aClass
    self selectedClasses value:(Array with:aClass)
!

selectedClassNameIndices
    selectedClassNameIndices isNil ifTrue:[
        selectedClassNameIndices := ValueHolder with:#().
        selectedClassNameIndices addDependent:self
    ].
    ^ selectedClassNameIndices.

    "Created: / 5.2.2000 / 21:31:48 / cg"
    "Modified: / 5.2.2000 / 21:43:02 / cg"
!

selectedClasses
    "bad name- it's a holder, baby"

    ^ self selectionHolder
!

selectedClasses:aValueHolder
    "bad name- its a holder, baby"

    ^ self selectionHolder:aValueHolder
!

sortByNameAndInheritance
    sortByNameAndInheritance isNil ifTrue:[
        sortByNameAndInheritance := ValueHolder with:false.
        sortByNameAndInheritance addDependent:self.
    ].
    ^ sortByNameAndInheritance.

    "Created: / 04-07-2011 / 18:28:15 / cg"
!

sortByNameAndInheritance:something
    "set the 'sortByNameAndInheritance' value holder (automatically generated)"

    |oldValue newValue|

    sortByNameAndInheritance notNil ifTrue:[
        oldValue := sortByNameAndInheritance value.
        sortByNameAndInheritance removeDependent:self.
    ].
    sortByNameAndInheritance := something.
    sortByNameAndInheritance notNil ifTrue:[
        sortByNameAndInheritance addDependent:self.
    ].
    newValue := sortByNameAndInheritance value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:sortByNameAndInheritance.
    ].
! !

!ClassList methodsFor:'change & update'!

classDefinitionChanged:aClassOrNil

    listValid ifFalse:[^ self].

    slaveMode value == true ifTrue:[
	self invalidateList.
	^ self.
    ].
    self slaveMode value isNil ifTrue:[
	self window shown ifFalse:[
	    self invalidateList.
	    ^ self
	].
    ].

    aClassOrNil isNil ifTrue:[
	self halt:'should not happen'.
    ].

    "/ if that class is in my list ...
    ((self classList value ? #()) contains:[:cls | cls notNil and:[cls theNonMetaclass name = aClassOrNil theNonMetaclass name]])
    ifTrue:[
	self updateListsFor:aClassOrNil.
	"/ force update
	self selectedClassNameIndices value:(self selectedClassNameIndices value).

	((self selectedClasses value ? #()) contains:[:cls | cls notNil ifTrue:[cls theNonMetaclass name = aClassOrNil theNonMetaclass name] ifFalse:[false]]) 
	ifTrue:[
	    self updateOutputGenerator
	].
    ] ifFalse:[
	self invalidateList
    ]


    "Modified: / 29.2.2000 / 00:15:23 / cg"
!

classIsInList:cls
    |classListValue|

    cls notNil ifTrue:[
        classListValue := classList value.

        classListValue size > 0 ifTrue:[
            ((classListValue includesIdentical:cls theNonMetaclass)
            or:[(classListValue includesIdentical:cls theMetaclass)]) ifTrue:[
                ^ true.
            ]
        ]
    ].
    ^ false.
!

classRemoved:aClass
    |list|

    list := self classList value.
    list notNil ifTrue:[
	(list includesIdentical:aClass) ifTrue:[
	    self invalidateList.
	]
    ]

    "Modified: / 25.2.2000 / 23:53:51 / cg"
!

delayedUpdate:something with:aParameter from:changedObject
    |cls classes chgClass wg savedList|

    classes := self classList value ? #().

"/    (self slaveMode value == true) ifTrue:[^ self].
"/    self slaveMode value isNil ifTrue:[
"/        self window shown ifFalse:[
"/            self invalidateList.
"/            ^ self
"/        ].
"/    ].

    changedObject == slaveMode ifTrue:[
        "/ a previously suppressed update is now due
        listValid ~~ true ifTrue:[
            self enqueueDelayedUpdateList.
        ].
        self enqueueDelayedClassSelectionChanged.
        ^  self
    ].

    changedObject == self selectedClasses ifTrue:[
        self inSlaveMode ifFalse:[
            savedList := self selectedClasses value.
            lastSelectedClasses := nil.
            listValid == true ifFalse:[
                self updateList
            ].
            self selectedClasses setValue:savedList.
            self selectedClassesChanged.
            self updateOutputGenerator.
        ] ifTrue:[
"/            listValid := false.
            self selectedClassesChanged.
        ].
        ^ self 
    ].

    (changedObject == meta 
    or:[changedObject == selectedClassNameIndices]) ifTrue:[
        self inSlaveMode ifFalse:[
            self selectionChanged.
        ] ifTrue:[
            self setListValid:false.
            self selectedClassesChanged.
        ].
        ^ self
    ].

    self inSlaveModeOrInvisible ifTrue:[
        self invalidateList.
        ^ self.
    ].

    changedObject == environment ifTrue:[
        something == #methodInClass ifTrue:[
            ^ self "no interest" 
        ].    
        something == #methodInClassRemoved ifTrue:[
            "/ must update the list, if the methods package is different from
            "/ the classes package (to undo any has-exension highlighting)
            cls := aParameter first.
            self updateListsFor:cls.
            ^ self 
        ].    
        something == #organization ifTrue:[^ self "no interest" ].    

        (something == #classDefinition 
        or:[something == #classVariables
        or:[something == #newClass]]) ifTrue:[
            "/ update that class in my classList and the selection
            listValid ifTrue:[
                self classDefinitionChanged:aParameter.
            ].
            ^ self.
        ].
        (something == #lastTestRunResult) ifTrue:[
            "/ update that class in my classList and the selection
            listValid ifTrue:[
                self updateListsFor:aParameter.
                "/ self classDefinitionChanged:aParameter.
            ].
            ^ self.
        ].
        something == #classRemove ifTrue:[
            "/ update my classList and the selection
            self classRemoved:aParameter.
            ^ self.
        ].
        something == #classRename ifTrue:[
            "/ update that class in my classList and the selection
            listValid ifTrue:[
                aParameter isArray ifTrue:[
                    cls := aParameter at:1.
                    self classDefinitionChanged:cls.
                ]
            ].
            ^ self.
        ].

        something == #projectOrganization ifTrue:[
            aParameter isNil ifTrue:[
                self invalidateList.
                organizerMode value == #project ifTrue:[
                    self enqueueDelayedUpdateOutputGenerator.
                ].
                ^ self
            ].

            cls := aParameter at:1.
            cls notNil ifTrue:[  "/ should not happen (but does occasionally)
                ((classes includes:cls theMetaclass)
                or:[(classes includes:cls theNonMetaclass)]) ifTrue:[
                    self invalidateList.
                    organizerMode value == #project ifTrue:[
                        self enqueueDelayedUpdateOutputGenerator.
                    ]
                ].
            ].
            ^ self
        ].
        ^ self.
    ].

    (something == #lastTestRunResult) ifTrue:[
        ^ self
    ].

    changedObject == ChangeSet ifTrue:[
        wg := self windowGroup.
        wg isNil ifTrue:[
            changedObject removeDependent:self.
        ] ifFalse:[
            "/ react on changes of the changeSet to recolorize items
            ((something ~~ #addChange:)
                or:[ 
                    chgClass := aParameter changeClass.
                    chgClass notNil 
                    and:[ (classes includes:chgClass theNonMetaclass) 
                          or:[classes includes:chgClass theMetaclass]]
                ]
            ) ifTrue:[
                wg sensor 
                    flushEventsFor:self 
                    where:[:ev | ev isMessageSendEvent 
                                 and:[ev selector == #delayedUpdate:with:from:
                                 and:[(ev arguments at:3) == ChangeSet]]].
                self enqueueDelayedAction:[self reconstructNameList].
            ].
        ].
        ^ self 
    ].

    changedObject == showClassPackages ifTrue:[
        self classNameList value:nil.
        self invalidateList.
        ^ self 
    ].

    (changedObject == hideUnloadedClasses
    or:[changedObject == hidePrivateClasses
    or:[changedObject == nameSpaceFilter
    or:[changedObject == packageFilter]]]) ifTrue:[
        self invalidateList.
        ^ self 
    ].

    super delayedUpdate:something with:aParameter from:changedObject

    "Modified: / 13.11.2001 / 11:32:10 / cg"
!

enqueueDelayedClassSelectionChanged
    (NewSystemBrowser synchronousUpdate == true
    or:[ immediateUpdate value == true ])
    ifTrue:[
        self selectedClassesChanged.
        ^ self.
    ].

    self enqueueMessage:#selectedClassesChanged for:self arguments:#()
!

getSelectedClassIndicesFromClasses
    "the class selection has changed;
     return a collection of selection-indices"

    |classes selectedClasses numSelected|

    classes := self classList value.
    selectedClasses := self selectedClasses value.

    numSelected := selectedClasses size.
    numSelected == 0 ifTrue:[
        ^ #()
    ].

    numSelected == classes size ifTrue:[
        "/ all selected - easy
        ^ (1 to:numSelected) asOrderedCollection
    ].
    meta value ifTrue:[
        classes := classes collect:[:eachClass | eachClass theMetaclass].
    ].

    ^ selectedClasses 
        collect:[:aSelectedClass | classes identityIndexOf:aSelectedClass]
        thenSelect:[:idx | idx ~= 0].

    "Created: / 24.2.2000 / 19:47:52 / cg"
!

getSelectedClassesFromIndices
    "the selection-index collection has changed;
     return a collection of corresponding classes"

    |selected classes allEntrySelected isMeta anyLost selectedClassNameIndices|

    allEntrySelected := false.

    classes := classList value.
    classes isNil ifTrue:[
        self updateList.
        classes := classList value.
    ].

    isMeta := meta value.
    anyLost := false.

    selectedClassNameIndices := self selectedClassNameIndices value.
    selectedClassNameIndices size == classes size ifTrue:[
        selectedClassNameIndices size == 0 ifTrue:[^ #()].
        isMeta ifTrue:[
            ^ classes collect:[:eachClass | eachClass theMetaclass].
        ].
        ^ classes collect:[:eachClass | eachClass theNonMetaclass].
    ].

    selected := selectedClassNameIndices 
                    collect:[:idx |
                                |cls|

                                cls := classes at:idx.
                                cls == (self class nameListEntryForALL) ifTrue:[
                                    allEntrySelected := true.
                                ] ifFalse:[
                                    cls notNil ifTrue:[
                                        isMeta ifTrue:[
                                            cls := cls theMetaclass
                                        ] ifFalse:[
                                            cls := cls theNonMetaclass
                                        ].
                                    ] ifFalse:[
                                        anyLost := true
                                    ].
                                ].
                                cls
                            ].
    anyLost ifTrue:[
        selected := selected select:[:each | each notNil].
    ].

"/    allEntrySelected ifTrue:[
"/        selected := classList value select:[:cls | cls ~~ AllEntry].
"/        meta value ifTrue:[
"/            selected := selected collect:[:cls | cls theMetaclass].
"/        ] ifFalse:[
"/            selected := selected collect:[:cls | cls theNonMetaclass].
"/        ].
"/    ].

    ^ selected.

    "Created: / 24.2.2000 / 19:43:37 / cg"
!

selectedClassesChanged
    |indices selectedClassNameIndicesHolder|

    self classList value size == 0 ifTrue:[
	"/ this may happen during early startup, 
	"/ when invoked with a preset classSelection,
	"/ and the classGenerator has not yet been setup
	"/ to not clobber the selection, defer the update
	"/ until the classList arrives ...
	^ self
    ].
    "/ lastSelectedClasses := self selectedClasses value copy.

    indices := self getSelectedClassIndicesFromClasses. 
    selectedClassNameIndicesHolder := self selectedClassNameIndices.
    selectedClassNameIndicesHolder value ~= indices ifTrue:[
	"/ in slaveMode, do not update selectedClasses from indices
	true "slaveMode value" ifTrue:[
	    selectedClassNameIndicesHolder value:indices withoutNotifying:self
	] ifFalse:[
	    selectedClassNameIndicesHolder value:indices.
	]
    ]

    "Created: / 13.2.2000 / 22:18:10 / cg"
    "Modified: / 24.2.2000 / 19:48:56 / cg"
!

selectionChanged
    "the lists selection has changed. Since the list uses indices,
     update the corresponding selectedClasses collection"

    |selected prevSelection selectedClassesHolder|

    selectedClassesHolder := self selectedClasses.

    selected := self getSelectedClassesFromIndices.

    prevSelection := selectedClassesHolder value ? #().

    prevSelection ~= selected ifTrue:[
        selectedClassesHolder value:selected.
    ].
!

selectionChangedByClick
    "we are not interested in that - get another notification
     via the changed valueHolder"

    |selected master|

    selected := self getSelectedClassesFromIndices.
    (selected = lastSelectedClasses and:[selected size == 1])
    ifTrue:[
        "/ that's a kludge - we want to turn off the protocol selection,
        "/ when a class is reselected.

        masterApplication notNil ifTrue:[
            master := masterApplication.
            masterApplication masterApplication notNil ifTrue:[
                master := masterApplication masterApplication.
            ].
            (master respondsTo:#classReselected) ifTrue:[
                master classReselected.
            ].
        ] 
    ] ifFalse:[
        lastSelectedClasses := selected copy.
    ]
!

update:something with:aParameter from:changedObject
    |cls sel mthd newMethod oldMethod idx classListValue change|

    self inSlaveMode ifTrue:[
        something == #methodInClass ifTrue:[ ^ self ].
        something == #addChange:    ifTrue:[ listValid ifTrue:[self invalidateList]. ^ self ].
        something == #methodCoverageInfo ifTrue:[ self invalidateList. ^ self ].
    ].

    something == #lastTestRunResult ifTrue:[
        (self window sensor isNil or:[self window sensor class == SynchronousWindowSensor]) ifTrue:[
            "/ not visible ...
            self invalidateList.
            ^ self
        ].
    ].

    classListValue := classList value.

    changedObject == environment ifTrue:[
        something == #classComment ifTrue:[
            ^ self.
        ].
        something == #methodDictionary ifTrue:[
            ^ self 
        ].
        something == #methodTrap ifTrue:[
            ^ self
        ].
        something == #coverageInfo ifTrue:[
            listValid == true ifTrue:[
                self enqueueDelayedUpdateList
            ].
            ^ self.
        ].

        something == #addChange: ifTrue:[ 
            listValid ifTrue:[
                change := aParameter.
                change isMethodCategoryChange ifTrue:[
                    cls := change changeClass.
                    (self classIsInList:cls) ifTrue:[
                        self updateListsFor:aParameter.
                        "/ self enqueueDelayedUpdateList
                    ].
                ].
            ].
            ^ self 
        ].

        something == #methodCoverageInfo ifTrue:[
            listValid == true ifTrue:[
                mthd := aParameter.
                cls := mthd mclass.
                cls notNil ifTrue:[
                    (self classIsInList:cls) ifTrue:[
                        self enqueueDelayedUpdateList
                    ]
                ].
            ].
            ^ self
        ].
        something == #lastTestRunResult ifTrue:[
            cls := aParameter at:1.
            sel := aParameter at:2.
            "/ JV: Note: change is triggered only if outcome changes
            cls notNil ifTrue:[
                (self classIsInList:cls) ifTrue:[
                    self enqueueDelayedUpdateList
                ]
            ].
            ^ self
        ].

        something == #methodInClassRemoved ifTrue:[
            self inSlaveMode ifFalse:[
                cls := aParameter at:1.
                cls notNil ifTrue:[
                    (self classIsInList:cls) ifTrue:[
                        self enqueueDelayedUpdateList
                    ]
                ].
            ].
            ^ self
        ].

        something == #methodInClass ifTrue:[
            cls := aParameter at:1.
            cls notNil ifTrue:[
                (self classIsInList:cls) ifTrue:[
                    newMethod := cls compiledMethodAt:(aParameter at:2).
                    oldMethod := aParameter at:3.
                    ((oldMethod isNil
                        and:[newMethod package ~= cls package])
                    or:[oldMethod notNil
                        and:[newMethod package ~= oldMethod package]])
                    ifTrue:[
                        "/ must update the list (for the package-info)
                        self enqueueDelayedUpdateList
                    ]
                ]
            ].
            ^ self
        ].

        "/ kludge: must be careful if my inGenerator is a constant list.
        "/ in that case, I have to update it 
        "/ (sigh - all a consequence of not #becoming the new class)
        ((something == #classDefinition) or:[something == #newClass]) ifTrue:[
            inGeneratorHolder value isOrderedCollection ifTrue:[
                idx := inGeneratorHolder value findFirst:[:eachClass | eachClass name = aParameter theNonMetaclass name].
                idx ~~ 0 ifTrue:[
                    inGeneratorHolder value at:idx put:aParameter.
                    self updateListsFor:aParameter.
                    "/ self enqueueDelayedUpdateList.
                ]
            ] ifFalse:[
                classListValue size > 0 ifTrue:[
                    idx := classListValue findFirst:[:eachClass | eachClass name = aParameter theNonMetaclass name].
                    idx ~~ 0 ifTrue:[
                        listValid ifTrue:[
                            self classDefinitionChanged:aParameter.
                            ^ self.
                        ]
                    ]
                ].
            ].
        ].
    ].

    changedObject == sortByNameAndInheritance ifTrue:[
        self invalidateList.
        ^ self.
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 05-06-2012 / 23:39:34 / cg"
    "Modified: / 06-12-2013 / 17:06:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassList methodsFor:'drag & drop'!

canDropContext:aDropContext
    |objects|

    objects := aDropContext dropObjects collect:[:obj | obj theObject].
    (objects conform:[:anObject | anObject isMethod]) ifTrue:[
        |methods cls|

        methods := objects.
        cls := self classAtTargetPointOf:aDropContext.
        cls isNil ifTrue:[^ false].

        ^ methods contains:[:aMethod | aMethod mclass ~= cls]
    ].
    (self objectsAreClassFiles:objects) ifTrue:[^ true].
    ^ false.

    "Modified: / 17-10-2006 / 18:26:07 / cg"
!

classAtTargetPointOf:aDropContext
    |p classListView lineNr cls|

    p := aDropContext targetPoint.

    classListView := aDropContext targetWidget.

    lineNr := classListView lineAtY:p y.
    lineNr isNil ifTrue:[^ nil].

    cls := classList value at:lineNr.
    ^ cls
!

doDropContext:aDropContext
    |objects browser|

    browser := self masterApplication.

    objects := aDropContext dropObjects collect:[:aDropObject | aDropObject theObject].
    (objects conform:[:something | something isMethod]) ifTrue:[
        |cls methods|

        methods := objects.
        cls := self classAtTargetPointOf:aDropContext.
        methods first mclass isMeta ifTrue:[
            cls := cls theMetaclass
        ].

        cls notNil ifTrue:[
            methods := methods reject:[:mthd | mthd mclass theNonMetaclass == cls theNonMetaclass].
            methods notEmpty ifTrue:[
                aDropContext dragType == DropContext dragTypeCopy ifTrue:[
                    browser copyMethods:methods toClass:cls.
                ] ifFalse:[
                    browser moveMethods:methods toClass:cls.
                ].
            ]
        ].
        ^ self
    ].
    (objects conform:[:something | something isFilename]) ifTrue:[
        self dropClassFiles:objects.
        ^ self
    ].

    "Modified: / 21-10-2006 / 20:39:55 / cg"
! !

!ClassList methodsFor:'generators'!

makeGenerator
    "return a generator which enumerates the method categories from the selected class;
     that generator generates 2-element elements (includes the class), in order
     to make the consumers only depend on one input (i.e. no need for another
     classHolder in the methodList)."

    ^ Iterator 
        on:[:whatToDo |
                |allEntry classes cls already anyMethod packages classIsInPackage 
                 showChanged changedClasses|

                allEntry := self class nameListEntryForALL.

                classes := self selectedClasses value ? #().
                packages := packageFilter value value.

                (packages notNil and:[packages includes:allEntry]) ifTrue:[packages := nil].

                showChanged := packages notNil and:[packages includes:NavigatorModel nameListEntryForChanged].
                showChanged ifTrue:[
                    changedClasses := ChangeSet current changedClasses.
                ].

                classes do:[:cls |
                    (cls notNil and:[cls ~~ allEntry]) ifTrue:[
                        anyMethod := false.
                        classIsInPackage := packages isNil 
                                            or:[(packages includes:cls package)
                                            or:[ showChanged and:[changedClasses includes:cls]] ].

                        cls theNonMetaclass isJavaClass ifTrue:[
                            cls isMeta ifTrue:[
                                whatToDo value:cls theNonMetaclass value:(self class nameListEntryForStatic).
                            ] ifFalse:[
                                whatToDo value:cls value:(self class nameListEntryForNonStatic).
                            ]
                        ] ifFalse:[
                            cls supportsMethodCategories ifFalse:[
                                whatToDo value:cls value:(self class nameListEntryForNILCategory).
                            ] ifTrue:[
                                already := Set new.
                                cls methodDictionary keysAndValuesDo:[:sel :mthd |
                                    |cat|

                                    cat := mthd category.
                                    (already includes:cat) ifFalse:[
                                        (classIsInPackage
                                            or:[packages isNil
                                            or:[(packages includes:mthd package) ]])
                                        ifTrue:[
                                            already add:cat.
                                            whatToDo value:cls value:cat.
                                        ]
                                    ]
                                ].
                            ].
                        ].

                        anyMethod ifFalse:[
                            "/ tell the one below, which classes are seen here,
                            "/ (even if no method is present)
                            "/ to allow him to decide if the className is to be shown in the list
                            whatToDo value:cls value:nil.
                        ].
                    ].
                ].
          ]

    "Modified: / 24.2.2000 / 23:18:26 / cg"
!

makeGeneratorForMethods
    "return a generator which enumerates the methods directly from the selected class;
     that generator generates 4-element elements (includes the class, category, selector and method).
     Can be used as an in-generator of methodlists"

    ^ Iterator 
        on:[:whatToDo |
                |allEntry classes cls already packages classIsInPackage 
                 showChanged changedClasses cat |

                allEntry := self class nameListEntryForALL.

                classes := self selectedClasses value ? #().
                packages := packageFilter value value.
                (packages notNil and:[packages includes:allEntry]) ifTrue:[packages := nil].

                showChanged := packages notNil and:[packages includes:NavigatorModel nameListEntryForChanged].
                showChanged ifTrue:[
                    changedClasses := ChangeSet current changedClasses.
                ].

                classes do:[:cls |
                    (cls notNil and:[cls ~~ allEntry]) ifTrue:[
                        classIsInPackage := packages isNil 
                                            or:[(packages includes:cls package)
                                            or:[ showChanged and:[changedClasses includes:cls]] ].
                        cls isMeta ifTrue:[
                            cat := self class nameListEntryForStatic.
                        ] ifFalse:[
                            cat := self class nameListEntryForNonStatic.
                        ].

                        "Java classes have static methods in it's instance method dictionary..."
                        cls theNonMetaclass isJavaClass ifTrue:[
                            cls isMeta ifTrue:[
                                "/ Iterate static method...
                                cls theNonMetaclass methodDictionary keysAndValuesDo:[:sel :mthd |
                                    (mthd isJavaMethod and:[mthd isStatic]) ifTrue:[
                                        whatToDo value:cls value:cat value:sel value:mthd.
                                    ]
                                ].
                                "/ ...and possible class extensions/synthetic proxies...
                                cls methodDictionary keysAndValuesDo:[:sel :mthd |
                                    whatToDo value:cls value:cat value:sel value:mthd.
                                ].                            
                            ] ifFalse:[
                                cls methodDictionary keysAndValuesDo:[:sel :mthd |
                                    "/ filter out static method
                                    (mthd isJavaMethod not or:[mthd isStatic not]) ifTrue:[
                                        whatToDo value:cls value:cat value:sel value:mthd.
                                    ].
                                ].                            
                            ]
                        ] ifFalse:[
                            cls methodDictionary keysAndValuesDo:[:sel :mthd |
                                whatToDo value:cls value:cat value:sel value:mthd.
                            ].                            
                        ]

                    ].
                ].
          ]

    "Modified: / 24-02-2000 / 23:18:26 / cg"
    "Created: / 07-08-2011 / 19:01:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-08-2013 / 00:38:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

outGeneratorHolderForMethods
    ^ outGeneratorHolderForMethods
!

outGeneratorHolderForMethods:something
    outGeneratorHolderForMethods := something.
!

updateOutputGenerator
    "create a generator which enumerates my elements, 
     and place it into the outputGenerator holder"

    super updateOutputGenerator.
    outGeneratorHolderForMethods notNil ifTrue:[
        outGeneratorHolderForMethods value: self makeGeneratorForMethods.
    ].

    "Modified: / 04-02-2000 / 17:16:34 / cg"
    "Created: / 05-02-2000 / 13:42:08 / cg"
    "Created: / 07-08-2011 / 18:51:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassList methodsFor:'initialize-release'!

release
    super release.

    currentNamespace removeDependent:self.
    sortByNameAndInheritance removeDependent:self.
    hidePrivateClasses removeDependent:self.
    markApplicationsHolder removeDependent:self.
    meta removeDependent:self.
    selectedClassNameIndices removeDependent:self.
    showClassPackages removeDependent:self.

    "Created: / 05-02-2000 / 13:42:18 / cg"
! !

!ClassList methodsFor:'private'!

listOfClasses
    |classesAlready classesOrdered generator nameSpaceFilter packageFilter allName hidePrivate
     privateClassesPerClass nameFilterIncludesMatchCharacters lcNameFilter|

    self sortByNameAndInheritance value ifTrue:[
        ^ self listOfClassesByInheritance
    ].

    allName := self class nameListEntryForALL.
    (self showAllClassesInNameSpaceOrganisation value) ifFalse:[
        nameSpaceFilter := self nameSpaceFilter value.
        nameSpaceFilter notNil ifTrue:[
            (nameSpaceFilter includes:allName) ifTrue:[
                nameSpaceFilter := nil
            ].
        ].
    ].
"/    packageFilter := self packageFilter value.
"/    packageFilter notNil ifTrue:[
"/        (packageFilter includes:allName) ifTrue:[packageFilter := nil].
"/    ].

    inGeneratorHolder isNil ifTrue:[
        "/ for standAlone testing
        generator := (environment?Smalltalk) allClasses.
        (self hideUnloadedClasses value) ifTrue:[
            generator := generator select:[:cls | cls isLoaded]
        ].
    ] ifFalse:[
        generator := inGeneratorHolder value.
        generator isNil ifTrue:[^ #() ].
    ].

    classesAlready := IdentitySet new.
    classesOrdered := OrderedCollection new.
    ownersAddedForTheirPrivateClassesOnly := IdentitySet new.

    hidePrivate := self hidePrivateClasses value.

    privateClassesPerClass := IdentityDictionary new.
    nameFilterIncludesMatchCharacters := nameFilter notNil and:[nameFilter includesMatchCharacters].
    nameFilter notNil ifTrue:[ lcNameFilter := nameFilter asLowercase].

    generator do:[:cls | 
        |owner bucket isAnonymousJavaClass whereToAdd|

        "JV@2011-08-07: FIXME: Ugly code, hard to extend!! And duplicated in listOfClassesByInheritance !!!!!!!!"            
        (hidePrivate not or:[cls isPrivate not])
        ifTrue:[
            (nameSpaceFilter isNil
            or:[self isClass:cls shownWithNameSpaceFilter:nameSpaceFilter]) ifTrue:[
                (packageFilter isNil
                or:[self isClass:cls shownWithPackageFilter:packageFilter]) ifTrue:[
                    (classesAlready includes:cls) ifFalse:[
                        (classFilterBlock isNil
                        or:[(classFilterBlock value:cls)]) ifTrue:[
                            classesAlready add:cls.
                            (nameFilter isNil 
                              or:[ (nameFilterIncludesMatchCharacters not and:[ cls name asLowercase startsWith:lcNameFilter])
                              or:[ (nameFilterIncludesMatchCharacters and:[nameFilter match:cls name ignoreCase:true]) ]]) ifTrue:[
                                isAnonymousJavaClass := cls isJavaClass and:[cls isAnonymous].

                                "Do not show Java anonymous classes"
                                isAnonymousJavaClass ifFalse:[
                                    ((owner := cls owningClass) notNil and:[self addOwnerClasses value]) ifTrue:[
                                        bucket := privateClassesPerClass 
                                                        at:owner 
                                                        ifAbsentPut:[SortedCollection new 
                                                                        sortBlock:[:a :b | (a name ? '?') < (b name ? '?')] ].
                                        whereToAdd := bucket.
                                    ] ifFalse:[
                                        whereToAdd := classesOrdered.
                                    ].
                                    whereToAdd add:cls.
                                ]                                            
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].

    "/ are there any private classes, for which the owner is not in the list ?
    privateClassesPerClass keysAndValuesDo:[:eachOwnerClass :privateClasses|
        (classesAlready includes:eachOwnerClass) ifFalse:[
            ownersAddedForTheirPrivateClassesOnly add:eachOwnerClass.
            classesOrdered add:eachOwnerClass.
            classesAlready add:eachOwnerClass.
"/            privateClasses do:[:privateClass |
"/                (classesOrdered includes:privateClass) ifFalse:[
"/                    classesOrdered add:privateClass.
"/                ].
"/            ].
        ].
    ].

    classesOrdered size == 1 ifTrue:[
        self classLabelHolder value:(classesOrdered first name)
    ] ifFalse:[
"/        self classLabelHolder value:(classes size printString , ' classes').
        sortBy value ~~ #doNotSort ifTrue:[
            classesOrdered sort:[:a :b | a name < b name].
        ]
    ].

    privateClassesPerClass notEmpty ifTrue:[
        |stream action|

        stream := WriteStream on:#().

        action := 
            [:eachClass |
                |bucket|

                stream nextPut:eachClass.

                bucket := privateClassesPerClass at:eachClass ifAbsent:nil.
                bucket notNil ifTrue:[
                    bucket do:action.
                ]
            ].

        classesOrdered do:action.
        classesOrdered := stream contents.
    ].

"/
"/ does not work (yet)
"/    classes addFirst:AllEntry.
    ^ classesOrdered

    "Modified: / 04-07-2011 / 18:33:56 / cg"
    "Modified: / 06-08-2014 / 14:14:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listOfClassesByInheritance
    "TODO: needs refatoring and common code extract with listOfClasses,
     but I have no time at the moment..."

    |classesAlready classes classesOrdered generator nameSpaceFilter packageFilter allName hidePrivate
     privateClassesPerClass nameFilterIncludesMatchCharacters lcNameFilter|

    allName := self class nameListEntryForALL.
    nameSpaceFilter := self nameSpaceFilter value.
    nameSpaceFilter notNil ifTrue:[
        (nameSpaceFilter includes:allName) ifTrue:[nameSpaceFilter := nil].
    ].
    packageFilter := self packageFilter value.
    packageFilter notNil ifTrue:[
        (packageFilter includes:allName) ifTrue:[packageFilter := nil].
    ].

    inGeneratorHolder isNil ifTrue:[
        "/ for standAlone testing
        generator := environment allClasses.
        (self hideUnloadedClasses value) ifTrue:[
            generator := generator select:[:cls | cls isLoaded]
        ].
    ] ifFalse:[
        generator := inGeneratorHolder value.
        generator isNil ifTrue:[^ #() ].
    ].

    classesAlready := IdentitySet new.
    classes := Set new.
    classesOrdered := OrderedCollection new.
    ownersAddedForTheirPrivateClassesOnly := IdentitySet new.
    hidePrivate := self hidePrivateClasses value.

    privateClassesPerClass := IdentityDictionary new.
    nameFilterIncludesMatchCharacters := nameFilter notNil and:[nameFilter includesMatchCharacters].
    nameFilter notNil ifTrue:[ lcNameFilter := nameFilter asLowercase].

    generator do:[:cls | 
        |owner bucket|

        (hidePrivate not or:[cls isPrivate not])
        ifTrue:[
            (nameSpaceFilter isNil
            or:[self isClass:cls shownWithNameSpaceFilter:nameSpaceFilter]) ifTrue:[
                (packageFilter isNil
                or:[self isClass:cls shownWithPackageFilter:packageFilter]) ifTrue:[
                    (classesAlready includes:cls) ifFalse:[
                        classesAlready add:cls.
                        ownersAddedForTheirPrivateClassesOnly remove:cls ifAbsent:[].
                        ((owner := cls owningClass) notNil and:[self addOwnerClasses value]) ifTrue:[
                            (classesAlready includes:owner) ifFalse:[
                                ownersAddedForTheirPrivateClassesOnly add:owner.
                                classesAlready add:owner.
                                classes add:owner.
                            ].
                            bucket := privateClassesPerClass at:owner ifAbsentPut:[SortedCollection new sortBlock:[:a :b | a name < b name] ].

                            "Do not show Java anonymous classes"
                            cls isJavaClass ifTrue:[
                                cls isAnonymous ifFalse:[
                                    bucket add:cls.
                                ]
                            ] ifFalse:[
                                bucket add:cls.
                            ].
                        ] ifFalse:[
                            cls isJavaClass ifTrue:[
                                cls isAnonymous ifFalse:[
                                    classes add:cls.
                                ]
                            ] ifFalse:[
                               classes add:cls.
                            ]                                    
                        ]
                    ]
                ]
            ]
        ]
    ].

    privateClassesPerClass keysAndValuesDo:[:owner :privateClasses|
        (owner isPrivate not and:[(classes includes: owner) not]) ifTrue:[
            classes addAll: privateClasses
        ]
    ].


    classes size == 1 ifTrue:[
        classesOrdered := classes asArray.
        self classLabelHolder value:(classes first name)
    ] ifFalse:[
"/        self classLabelHolder value:(classes size printString , ' classes').
"        sortBy value ~~ #doNotSort ifTrue:[
            classesOrdered sort:[:a :b | a name < b name].
        ]"
        classesOrdered := ClassSorter sort: classes.
    ].

    privateClassesPerClass notEmpty ifTrue:[
        |stream action|

        stream := WriteStream on:#().

        action := [:eachClass |
                |bucket|

                stream nextPut:eachClass.

                bucket := privateClassesPerClass at:eachClass ifAbsent:nil.
                bucket notNil ifTrue:[
                    bucket do:action.
                ]
        ].

        classesOrdered do:action.
        classesOrdered := stream contents.
    ].

"/
"/ does not work (yet)
"/    classes addFirst:AllEntry.
    ^ classesOrdered

    "Modified: / 18-08-2000 / 20:34:10 / cg"
    "Modified: / 21-01-2008 / 19:43:04 / janfrog"
    "Modified: / 24-08-2010 / 20:17:07 / Jan Vrany <enter your email here>"
    "Created: / 04-07-2011 / 18:27:34 / cg"
    "Modified: / 06-08-2014 / 14:14:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeDependent
    environment addDependent:self.
    ChangeSet addDependent:self.

    "Created: / 5.2.2000 / 13:42:17 / cg"
!

makeIndependent
    environment removeDependent:self.
    ChangeSet removeDependent:self.
!

nameListForClasses:aClassList
    |orgMode namespaces showNamespaces fullNameList nameList
     filteredPackages filteredNameSpaces classesInRemoteChangeSet
     classNamesInChangeSet classNamesInRemoteChangeSet javaClassCountsByBname|

    showNamespaces := false.
    filteredNameSpaces := nameSpaceFilter value.
    orgMode := organizerMode value.

    (filteredNameSpaces isNil 
     and:[orgMode ~~ OrganizerCanvas organizerModeNamespace]) ifTrue:[
        showNamespaces := true.       "/ if no filter, always show the namespace.
    ] ifFalse:[
        (filteredNameSpaces size ~~ 0 
         and:[(filteredNameSpaces size > 1)
              or:[filteredNameSpaces includes:(self class nameListEntryForALL)]]) ifTrue:[
            showNamespaces := true
        ] ifFalse:[
            "/ if there are classes from multiple namespaces,
            "/ show the full name
            namespaces := IdentitySet new.
            fullNameList := OrderedCollection new.

            aClassList do:[:eachClass | 
                namespaces add:eachClass topNameSpace.
                fullNameList add:eachClass nameInBrowser.
            ].
            showNamespaces := namespaces size > 1.
        ].
    ].

    filteredPackages := packageFilter value value.

    classNamesInChangeSet := ChangeSet current changedClasses
                                collect:[:each | each theNonMetaclass name].
    classesInRemoteChangeSet := SmallTeam isNil ifTrue:[#()] ifFalse:[ SmallTeam changedClasses ].
    classNamesInRemoteChangeSet := classesInRemoteChangeSet collect:[:each | each theNonMetaclass name].

    javaClassCountsByBname := Dictionary new.
    aClassList do:[:eachClass |
        eachClass isJavaClass ifTrue:[
            javaClassCountsByBname
                at:eachClass binaryName 
                put:(javaClassCountsByBname at:eachClass ifAbsent:[0]) + 1
        ]
    ].

    nameList := aClassList 
                    collect:[:eachClass | 
                            |className nm pkg emPkg hasExtensions 
                             isInChangeSet isInRemoteChangeSet icon clr|

                            className := eachClass theNonMetaclass name.
                            isInChangeSet := classNamesInChangeSet includes:className.
                            isInRemoteChangeSet := classNamesInRemoteChangeSet includes:className.

                            nm := self nameListEntryFor:eachClass withNameSpace:showNamespaces.

                            eachClass isJavaClass ifTrue:[
                                 "/ Java classes are never in changeset, so check their sourceString 
                                 "/ (if not nil, they have been modified/edited. Kludgy...
                                 isInChangeSet := eachClass sourceString notNil.
                        
                                 (javaClassCountsByBname at:eachClass binaryName) > 1 ifTrue:[
                                    | cl clstring |

                                    cl := eachClass classLoader.
                                    "/ Do not mark classes loaded by primordial, ext or system class loader...
                                    (cl notNil 
                                     and:[JavaVM systemClassLoader isNil 
                                          or:[cl ~~ JavaVM systemClassLoader 
                                              and:[cl ~~ (JavaVM systemClassLoader instVarNamed:#parent)]]]
                                    ) ifTrue:[
                                        clstring := ' [', cl displayString , ']'.
                                        nm := nm , (clstring withColor:Color gray).
                                    ].
                                ].
                            ].

                            (ownersAddedForTheirPrivateClassesOnly notNil 
                              and:[ownersAddedForTheirPrivateClassesOnly includes:eachClass]
                            ) ifTrue:[
                                clr := Color grey.
                            ].
                            
                            self showCoverageInformation value ifTrue:[
                                clr := self colorForCoverageInformationOfClass:eachClass.
                            ].
                            clr notNil ifTrue:[
                                nm := self colorize:nm with:#color -> clr
                            ] ifFalse:[
                                isInChangeSet ifTrue:[
                                    nm := self emphasizeForChangedCode:nm
                                ].
                                isInRemoteChangeSet ifTrue:[
                                    nm := (self colorizeForChangedCodeInSmallTeam:'!! '),nm
                                ].
                            ].
                            nm isText ifTrue:[
                                "in some fonts, bold spaces are larger than normal spaces.
                                 remove emphasis from leading spaces"
                                nm emphasisFrom:1 to:(nm leftIndent) remove:#bold.
                            ].

                            pkg := eachClass package ? '-'.
                            hasExtensions := eachClass hasExtensions.
                            hasExtensions ifTrue:[
                                emPkg := self emphasizeForDifferentPackage:'+'. "/ self emphasizeForDifferentPackage:pkg.
                            ].

                            orgMode == OrganizerCanvas organizerModeProject ifTrue:[
                                (filteredPackages notNil
                                and:[(filteredPackages includes:eachClass package) not]) ifTrue:[
                                    "/ class is in another packae;
                                    "/ however, class is listed due to methods
                                    "/ in the filtered package
                                    hasExtensions ifTrue:[
                                        nm := nm , emPkg.
                                    ] ifFalse:[    
                                        nm := nm , ' [ ' , pkg, ' ]'.
                                    ].
                                ] ifFalse:[
                                    "/ any methods from other packages in this class ?
                                    hasExtensions ifTrue:[
                                        nm := nm , (self emphasizeForDifferentPackage:'+').
                                    ].
                                ].
                            ] ifFalse:[
                                showClassPackages value == true ifTrue:[
                                    "/ add the package;
                                    hasExtensions ifTrue:[
                                        nm := nm , ' [ ' , pkg, ' ]' , (self emphasizeForDifferentPackage:'+').
"/                                        isInChangeSet ifFalse:[
"/                                            nm := self colorizeForDifferentPackage:nm
"/                                        ].
                                    ] ifFalse:[
                                        nm := nm , (self colorizeGrey:(' [ ' , pkg, ' ]')).
                                    ].
                                ] ifFalse:[
                                    hasExtensions ifTrue:[
                                        nm := nm , emPkg.
"/                                        isInChangeSet ifFalse:[
"/                                            nm := self colorizeForDifferentPackage:nm
"/                                        ]
                                    ].
                                ]
                            ].

                            isInChangeSet ifTrue:[
                                nm := nm , self class markForBeingInChangeList
                            ].
"/                          eachClass isVisualStartable ifTrue:[
"/                              nm := LabelAndIcon icon:((SystemBrowser visualStartableClassIcon)
"/                                                      onDevice:self window device)
"/                                                 string:nm
"/                          ].
                            eachClass isObsolete ifTrue:[ 
                                icon := SystemBrowser doNotEnterIcon. 
                            ] ifFalse:[
                                markApplicationsHolder value == true ifTrue:[
                                    icon := self iconForClass:eachClass theNonMetaclass.
                                    icon isNil ifTrue:[
                                        icon := SystemBrowser emptyIcon
                                    ].
                                ]
                            ].
                            icon notNil ifTrue:[
                                nm := LabelAndIcon icon:icon string:nm
                            ].
                            nm
                       ].   

    ^ nameList

    "Modified: / 27-10-2012 / 12:32:20 / cg"
    "Modified: / 26-05-2017 / 10:54:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reconstructNameList
    "only reconstruct the names - class list & selection remains unschanged.
     Invoked when the organizerMode mode changes"

    |prevMode listView oldNameList newNameList sav|

    self classList value isNil ifTrue:[
        self updateList
    ].

    newNameList := self nameListForClasses:(classList value ? #()).
    oldNameList := self classNameList value ? #().
    (newNameList 
        sameContentsAs: oldNameList 
        whenComparedWith:[:a :b | (a sameStringAndEmphasisAs: b) 
                                  and:[ a hasImage == b hasImage
                                  and:[ a hasIcon == b hasIcon ]]]
    ) 
    ifTrue:[
        "/ no need to update
    ] ifFalse:[
        builder notNil ifTrue:[
            listView := builder componentAt:#List.
        ].
        (listView isNil or:[listView scrolledView isNil]) ifTrue:[    
            "/ invoked very early during setup
            self classNameList value:newNameList
        ] ifFalse:[
            "/ avoid flicker and useless redraws

            prevMode := listView scrollWhenUpdating.
            listView scrollWhenUpdating:nil.

            "/ this will lead to a selectionIndex change (done by the selListView);
            "/ however, we don't want this here, since it recurses into
            "/ a selectionChange. Therefore, temporarily disconnect the selectionIndexHolder...
            [
                self selectedClassNameIndices removeDependent:self.
                "/ also, don't want a callback (selectionChangedByClick)
                sav := listView action.
                listView action:nil.
                self classNameList value:newNameList.
            ] ensure:[
                listView action:sav.
                self selectedClassNameIndices addDependent:self.
                listView scrollWhenUpdating:prevMode.
            ].
        ]
    ].

    "Modified: / 31.10.2001 / 11:33:21 / cg"
!

updateClassesIn:aCollection
    "replace any obsolete class in aCollection;
     return true, if any was found"

    |found meta classes|

    found := false.

    aCollection isSequenceable ifFalse:[
        classes := aCollection copy.
        aCollection removeAll.
        classes do:[:cls |
            |newClass|

            meta := cls isMeta.
            newClass := environment at:(cls theNonMetaclass name).
            newClass isNil ifTrue:[
                newClass := cls
            ] ifFalse:[
                meta ifTrue:[
                    newClass := newClass class
                ]
            ].
            found := cls ~~ newClass.
            aCollection add:newClass.
        ].
    ] ifTrue:[
        aCollection keysAndValuesDo:[:idx :cls |
            |newClass|

            cls notNil ifTrue:[
                meta := cls isMeta.
                newClass := environment at:(cls theNonMetaclass name).
                newClass isNil ifTrue:[
                    newClass := cls
                ] ifFalse:[
                    meta ifTrue:[
                        newClass := newClass class
                    ]
                ].
                found := cls ~~ newClass.
                aCollection at:idx put:newClass.
            ]
        ].
    ].
    ^ found

    "Modified: / 04-08-2013 / 13:48:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    |prevSelection oldList newList newSelectionIndices 
     forceSelectionChange selectedClassNameIndicesHolder classList
     classesAddedToList classesRemovedFromList newSet oldSet|

    newList := self listOfClasses.
    classList := self classList.
    oldList := classList value ? #().

    autoSelect == true ifTrue:[
        classesRemovedFromList := OrderedCollection new.
        newSet := newList asSet.
        oldSet := oldList asSet.
        classesAddedToList := newSet select:[:eachNewClass | (oldSet includes:eachNewClass) not].
        classesRemovedFromList := oldSet select:[:eachOldClass | (newSet includes:eachOldClass) not].
    ].

    (newList ~= oldList
    or:[self classNameList value isNil and:[newList size > 0]]) ifTrue:[
        prevSelection := lastSelectedClasses ? #().
        prevSelection := prevSelection select:[:each | each notNil].

        (newList collect:[:each | each name]) = (oldList collect:[:each | each name]) ifTrue:[
            "/ no need to tell anybody
            classList setValue:newList.
        ] ifFalse:[
            classList value:newList.
        ].
        self reconstructNameList.

        (prevSelection size == 0 
        and:[self selectedClasses value size ~~ 0]) ifTrue:[
            "/ this happens during early startup time,
            "/ when the selection is already (pre-)set,
            "/ and the classList is generated the first time
            "/ (i.e. when opened with preset selection)

            "/ do not clobber the selection in this case.
            prevSelection := self selectedClasses value.
            prevSelection := prevSelection select:[:cls | cls notNil].
            "/ simulate a change, to force selection update in listView
            forceSelectionChange := true.
        ].

        autoSelect == true ifTrue:[
            prevSelection isNil ifTrue:[
                prevSelection := OrderedCollection new
            ].
            prevSelection := prevSelection asOrderedCollection.

            classesAddedToList do:[:eachNewClass |
                (prevSelection includes:eachNewClass) ifFalse:[
                    prevSelection add:eachNewClass.
                ].
            ].
            classesRemovedFromList do:[:eachOldClass |
                prevSelection remove:eachOldClass ifAbsent:[].
            ].
        ].

        newSelectionIndices := prevSelection 
                            collect:[:item | 
                                |cls|

                                cls := environment at:item theNonMetaclass name.   
                                newList identityIndexOf:cls]
                            thenSelect:[:index | index ~~ 0].

        selectedClassNameIndicesHolder := self selectedClassNameIndices.

        ((selectedClassNameIndicesHolder value size ~~ self selectedClasses value size)
        or:[newSelectionIndices ~= selectedClassNameIndicesHolder value])
        ifTrue:[
            newSelectionIndices notEmpty ifTrue:[
                "/ force change (for dependents)
                "/ selectedClassNameIndicesHolder value:newSelectionIndices.
            ] ifFalse:[
                prevSelection := self selectedClasses value.
                newSelectionIndices := #().
            ].
            selectedClassNameIndicesHolder value:newSelectionIndices.

            prevSelection notNil ifTrue:[
                lastSelectedClasses := prevSelection.
            ].
            self updateOutputGenerator.
        ].

    ] ifFalse:[
        "/ same classes - but name(s) could be differnet
        newList size > 0 ifTrue:[
            self reconstructNameList
        ]
    ].
    self setListValid:true.

    "Created: / 05-02-2000 / 13:42:18 / cg"
    "Modified: / 31-10-2001 / 11:35:39 / cg"
    "Modified: / 24-09-2013 / 23:30:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateListsFor:aClass
    "selective update of a single entry (avoid full rescan)"

    |classes found foundInSelection|

    found := foundInSelection := false.

    "/ update for a changed class in the classList
    (classes := classList value) size > 0 ifTrue:[
        (self updateClassesIn:classes) ifTrue:[
            found := true
        ].
        (classes includes:nil) ifTrue:[
            "/ self halt:'should not happen'.
            classList value:(classes := classes select:[:each | each notNil]).
        ].
    ].
    "/ possibly in the generator
    ((classes := inGeneratorHolder value) isOrderedCollection 
    and:[classes size > 0]) ifTrue:[
        (self updateClassesIn:classes) ifTrue:[
            found := true
        ].
        (classes includes:nil) ifTrue:[
            "/ self halt:'should not happen'.
            inGeneratorHolder value:(classes select:[:each | each notNil]).
        ]
    ].
    "/ and in the selection
    (classes := self selectedClasses value) size > 0 ifTrue:[
        (self updateClassesIn:classes) ifTrue:[
            found := true.
            foundInSelection := true.
        ].
        (classes includes:nil) ifTrue:[
            "/ self halt:'should not happen'.
            self selectedClasses value:(classes select:[:each | each notNil]).
        ]
    ].
    "/ and in the last selection
    (classes := lastSelectedClasses) size > 0 ifTrue:[
        (self updateClassesIn:classes) ifTrue:[
            found := true
        ].
        (classes includes:nil) ifTrue:[
            "/ self halt:'should not happen'.
            lastSelectedClasses := (classes select:[:each | each notNil]).
        ]
    ].

    found ifFalse:[
        "/ could be a new class (or no-longer autolaoded one).
        listValid ifTrue:[
            self enqueueDelayedUpdateList.
        ].
    ].
    foundInSelection ifTrue:[
        "/ force update of output generator
        self selectedClasses 
            removeDependent:self;
            changed;
            addDependent:self.
    ].

    "Modified: / 05-06-2012 / 23:39:25 / cg"
! !

!ClassList methodsFor:'private-presentation'!

colorForCoverageInformationOfClass:aClass
    |instrumented anyPartiallyCovered anyCalled anyNotCalled|

    instrumented := anyPartiallyCovered := anyCalled := anyNotCalled := false.
    aClass instAndClassMethodsDo:[:m |
        m category = 'documentation' ifFalse:[
            m isInstrumented ifTrue:[
                instrumented := true.
                m hasBeenCalled ifFalse:[
                    anyNotCalled := true.
                ] ifTrue:[
                    anyCalled := true.
                    m haveAllBlocksBeenExecuted ifFalse:[
                        anyPartiallyCovered := true.
                        "/ no need to search further...
                        ^ UserPreferences current colorForInstrumentedPartiallyCoveredCode
                    ]
                ].
            ].
        ].
    ].
    instrumented ifFalse:[ ^ nil].

    anyCalled ifFalse:[ ^ UserPreferences current colorForInstrumentedNeverCalledCode ].
    anyNotCalled ifFalse:[ ^ UserPreferences current colorForInstrumentedFullyCoveredCode ].
    ^ UserPreferences current colorForInstrumentedPartiallyCoveredCode

    "Created: / 28-04-2010 / 14:05:27 / cg"
!

iconForClass:aClass
    ^ SystemBrowser iconForClass:aClass

    "Created: / 17-08-2006 / 09:12:32 / cg"
!

indentPerPrivacyLevel
    ^ 4
!

nameListEntryFor:aClass withNameSpace:useFullName
    |sortByNameAndInheritanceValue nm indent owner orgMode indentString |

    aClass == (self class nameListEntryForALL) ifTrue:[ ^ aClass ].

    sortByNameAndInheritanceValue := self sortByNameAndInheritance value.

    sortByNameAndInheritanceValue ifTrue:[
        nm := (self nameListIndentStringFor: aClass withNameSpace: useFullName) , aClass nameInBrowser.
    ] ifFalse:[
        nm := aClass nameInBrowser.
    ].

    aClass isLoaded ifFalse:[
        unloadedClassesColor notNil ifTrue:[
            nm := nm withColor:unloadedClassesColor
        ]
    ] ifTrue:[
        | instMethodCount classMethodCount |   

        aClass isAbstract ifTrue:[ nm := nm allItalic ].
        instMethodCount := aClass methodsCount.
        classMethodCount := aClass class methodsCount.

        (instMethodCount notNil or:[ classMethodCount notNil ]) ifTrue:[ 
            nm := nm, ((' (%1+%2) ' bindWith:(instMethodCount ? '?') with:(classMethodCount ? '?')) 
                        withColor:self class pseudoEntryForegroundColor).
        ]
    ].

    orgMode := organizerMode value.
    orgMode == OrganizerCanvas organizerModeHierarchy ifTrue:[
        "/ always show the full name
        ^ nm
    ].
    orgMode == OrganizerCanvas organizerModeClassHierarchy ifTrue:[
        "/ always show the full name
        ^ nm
    ].

    aClass isJavaClass ifTrue:[
        | package javaPackage |
        "/ only show the last name, unless multiple packages are shown in the list
        package := aClass package.
        javaPackage := aClass javaPackage.
        javaPackage notEmptyOrNil ifTrue:[
            (self classList value contains:[:cls | cls package ~= package]) ifFalse:[ 
                | i |

                i := nm string indexOfNonSeparator.
                nm := nm copyFrom: i + (javaPackage size + 1).     
                i > 0 ifTrue:[ 
                    nm := (String new: i - 1) , nm
                ].
            ]
        ].
        ^ nm
    ].

    useFullName ifFalse:[
        aClass isPrivate ifFalse:[
            sortByNameAndInheritanceValue ifTrue:[
                ^ (self nameListIndentStringFor: aClass withNameSpace: useFullName) , aClass nameWithoutNameSpacePrefix 
            ].
            ^ aClass nameWithoutNameSpacePrefix 
        ]
    ].

    "/ full name required if owner is not in the list
    owner := aClass owningClass.
    (owner isNil
     or:[(self classList value includesIdentical:owner) not]) ifFalse:[
        "/ namespace
        indent := (nm count:[:char | char == $:]) // 2.
        indent > 0 ifTrue:[
            indent := indent * self indentPerPrivacyLevel.
            indentString := String new:indent withAll:Character space.
            sortByNameAndInheritanceValue ifTrue:[
                nm := (self nameListIndentStringFor:owner withNameSpace:useFullName)
                        , indentString , '::' , aClass nameWithoutPrefix.
            ] ifFalse:[
                nm := indentString , '::' , aClass nameWithoutPrefix
            ]
        ].
    ].

    ^ nm

    "Modified: / 04-07-2011 / 19:00:45 / cg"
    "Modified: / 27-03-2015 / 16:23:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameListIndentStringFor:aClass withNameSpace:useFullName 
    |indent indentString cls|

    indent := 0.
    indentString := ''.
    cls := aClass superclass.
    [self classList value includesIdentical:cls] whileTrue:[
        indent := indent + 1.
        cls := cls superclass
    ].
    indent == 0 ifFalse:[
        indent <= 5 ifTrue:[
            indentString := #( 
                 ''
                 '  '
                 '    '
                 '      '
                 '        '
                 '          ' ) at:indent + 1.
        ] ifFalse:[
            indentString := String new:indent * 2 withAll:Character space.
        ].
    ].
    ^ indentString

    "Modified: / 24-02-2000 / 17:52:28 / cg"
    "Created: / 21-01-2008 / 19:02:07 / janfrog"
    "Modified (format): / 04-07-2011 / 18:30:20 / cg"
! !

!ClassList methodsFor:'queries'!

supportsSearch

    ^(self componentAt: #List) notNil

    "Created: / 28-07-2011 / 17:46:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassList methodsFor:'setup'!

autoSelect:aBoolean
    autoSelect ~~ aBoolean ifTrue:[
        autoSelect := aBoolean.
        classList value:nil.
    ].
!

classFilterBlock:aBlock
    "use this to filter away unwanted packages"

    classFilterBlock := aBlock
!

postBuildWith:aBuilder
    |classListView|

    super postBuildWith:aBuilder.

    classListView := aBuilder componentAt:'List'.
    classListView notNil ifTrue:[
	classListView allowDrag:true.
	classListView dragObjectConverter:[:obj | 
					    |nm class idx|

					    nm := obj theObject asString.
					    idx := classNameList value indexOf:nm.
					    idx == 0 ifTrue:[
						idx := classNameList value indexOf:nm string.
					    ].
					    class := classList value at:idx.
					    DropObject newClass:class.
					 ].
    ]
! !

!ClassList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

