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

BrowserList subclass:#ProjectList
	instanceVariableNames:'projectList projectNameList selectionIndexHolder worker
		workerQueue includedPseudoEntryForChanged selectionIndexValid'
	classVariableNames:'AdditionalEmptyProjects HideModules'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!ProjectList class methodsFor:'documentation'!

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
!

documentation
"
    I implement the project list in the new system browser
"
! !

!ProjectList class methodsFor:'interface specs'!

singleProjectWindowSpec
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
	#name: #singleProjectWindowSpec
	#window: 
       #(#WindowSpec
	  #label: 'ProjectList'
	  #name: 'ProjectList'
	  #min: #(#Point 0 0)
	  #max: #(#Point 1024 721)
	  #bounds: #(#Rectangle 218 175 518 475)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'ProjectName'
	      #name: 'ProjectLabel'
	      #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 25 0)
	      #translateLabel: true
	      #labelChannel: #projectLabelHolder
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
     UIPainter new openOnClass:Tools::ProjectList andSelector:#windowSpec
     Tools::ProjectList new openInterface:#windowSpec
     Tools::ProjectList open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'ProjectList'
         name: 'ProjectList'
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
             model: selectionIndexHolder
             menu: menuHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             miniScrollerHorizontal: true
             isMultiSelect: true
             valueChangeSelector: selectionChangedByClick
             useIndex: true
             sequenceList: projectNameList
             doubleClickChannel: doubleClickChannel
             postBuildCallback: postBuildProjectListView:
             properties: 
            (PropertyListDictionary
               canDropSelector: canDropContext:
               dropArgument: nil
               dropSelector: doDropContext:
               dragArgument: nil
             )
           )
          )
        
       )
     )
! !

!ProjectList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #(doubleClickChannel action)
        #environmentHolder
        #forceGeneratorTrigger
        #hideUnloadedClasses
        #immediateUpdate
        #inGeneratorHolder
        #menuHolder
        #organizerMode
        #outGeneratorHolder
        #selectedProjects
        #selectionChangeCondition
        #slaveMode
        #updateTrigger
      ).

! !

!ProjectList methodsFor:'accessing'!

includedPseudoEntryForChanged:something
    includedPseudoEntryForChanged := something.
! !

!ProjectList methodsFor:'aspects'!

itemList
    ^ self projectList value
!

projectLabelHolder
    ^ self pseudoListLabelHolder
!

projectList
    projectList isNil ifTrue:[
	projectList := ValueHolder new.
	projectList addDependent:self.
    ].
    ^ projectList

    "Created: / 17.2.2000 / 23:39:32 / cg"
!

projectNameList
    projectNameList isNil ifTrue:[
        projectNameList := ValueHolder new.
        "/ projectNameList addDependent:self.
    ].
    ^ projectNameList

    "Created: / 17.2.2000 / 23:39:32 / cg"
!

selectedProjects
    ^ self selectionHolder

    "Created: / 17.2.2000 / 23:39:57 / cg"
!

selectedProjects:aValueHolder
    ^ self selectionHolder:aValueHolder
!

selectionIndexHolder
    selectionIndexHolder isNil ifTrue:[
        selectionIndexHolder := 0 asValue.
        selectionIndexHolder addDependent:self.
    ].
    ^ selectionIndexHolder

    "Created: / 17.2.2000 / 23:39:32 / cg"
! !

!ProjectList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    |cls sel pkg mthd newSel|

    self inSlaveModeOrInvisible 
    "/ (self slaveMode value == true) 
    ifTrue:[
        (changedObject == environment
        or:[ something == #projectOrganization ]) ifTrue:[
            listValid ifFalse:[ ^ self].
            self setListValid:false
        ].
        changedObject == self selectionHolder ifTrue:[
            selectionIndexValid := false.
        ].
        changedObject == inGeneratorHolder ifTrue:[
            self invalidateList.
            self updateList.
        ].
"/
"/        self window shown ifFalse:[ ^ self ].
    ].

    (changedObject == self selectionHolder) ifTrue:[
        self updateSelectionIndexFromSelection.
        "/ self enqueueDelayedUpdateOutputGenerator.
        ^ self.
    ].

    selectionIndexValid ifFalse:[
        self updateSelectionIndexFromSelection.
    ].

    changedObject == self selectionIndexHolder ifTrue:[
        listValid ifFalse:[
             self updateList.
        ].
        changedObject value == 0 ifTrue:[
            self selectionIndexHolder value:#()
        ].
        newSel := changedObject value collect:[:idx | (projectList value at:idx) withoutSeparators].
        newSel ~= self selectedProjects value ifTrue:[
            self selectedProjects value:newSel.
        ].
        self enqueueDelayedUpdateOutputGenerator.
        ^ self.
    ].

    changedObject == slaveMode ifTrue:[
        listValid ~~ true ifTrue:[
            self enqueueDelayedUpdateList
        ].
        "/ self invalidateList.
        ^  self
    ].

    changedObject == self projectList ifTrue:[
        ^  self
    ].

    changedObject == environment ifTrue:[
        something == #projectOrganization ifTrue:[
            self invalidateList.
            slaveMode value == true ifFalse:[
                self enqueueDelayedUpdateOutputGenerator.
            ].
            ^ self.
        ].
        something == #methodInClass ifTrue:[
            listValid == true ifTrue:[
                cls := aParameter at:1.
                sel := aParameter at:2.
                mthd := cls compiledMethodAt:sel.
                mthd notNil ifTrue:[
                    pkg := mthd package.
                    (projectList value includes:pkg) ifFalse:[
                        self invalidateList.
                    ]
                ].
            ].
            ^ self
        ].

        (something == #classDefinition
        or:[something == #newClass]) ifTrue:[
            listValid == true ifTrue:[
                cls := aParameter.
                pkg := cls package.
                (projectList value includes:pkg) ifFalse:[
                    self invalidateList.
                ] ifTrue:[
                    self enqueueDelayedUpdateOutputGenerator
                ].
            ] ifFalse:[
                self invalidateList
            ].
            ^ self
        ].
        (something == #classRemove) ifTrue:[
            listValid == true ifTrue:[
                cls := aParameter.
                pkg := cls package.
            ].
        ].
        ^ self
    ].

"/    something == #projectOrganization ifTrue:[
"/        aParameter isSymbol ifTrue:[
"/                    "/ a single method has changed
"/"/                    sel := aParameter.
"/"/                    mthd := changedObject compiledMethodAt:sel.
"/            self enqueueDelayedUpdateOutputGenerator.
"/        ].
"/        ^ self
"/    ].

    changedObject == ChangeSet ifTrue:[
        self invalidateList.
        ^ self
    ].

    (organizerMode notNil
    and:[organizerMode value ~~ #project]) ifTrue:[
        self invalidateList.
        ^ self
    ].
    super delayedUpdate:something with:aParameter from:changedObject

    "Created: / 17-02-2000 / 23:41:02 / cg"
    "Modified: / 17-10-2006 / 18:43:40 / cg"
!

selectionChangedByClick
    "we are not interested in that - get another notification
     via the changed valueHolder"

    self enqueueDelayedUpdateOutputGenerator.

    "Created: / 17.2.2000 / 23:41:17 / cg"
!

update:something with:aParameter from:changedObject

    changedObject == environmentHolder ifTrue:[
        self environmentChanged.
        ^ self.
    ].  

    (self builder isNil or:[self window topView realized not]) ifTrue:[
        "/ ignore those changes while I am invisible
        "/ self makeIndependent.
        self setListValid:false.
        selectionIndexValid := false.
        ^ self
    ].

    changedObject == environment ifTrue:[
        something == #methodDictionary ifTrue:[
            ^ self 
        ].
        something == #methodTrap ifTrue:[
            ^ self
        ].
        something == #methodCoverageInfo ifTrue:[
            ^ self
        ].
        something == #methodInClass ifTrue:[
            ^ self
        ].
        something == #classVariables ifTrue:[
            ^ self
        ].
        something == #classComment ifTrue:[
            ^ self.
        ].
        something == #methodInClassRemoved ifTrue:[
            ^ self.
        ].
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 20-07-2011 / 18:54:39 / cg"
    "Modified: / 25-02-2014 / 10:07:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSelectionIndexFromSelection
    |newSel allIdx selection selectionIndex |

    selection := self selectionHolder value.
    selection isNil ifTrue:[
        self selectionIndexHolder value:0.
        ^ self.
    ].

    listValid ifFalse:[
         self updateList.
    ].
    allIdx := projectList value indexOf:(self class nameListEntryForALL).

    newSel := selection 
                    collect:[:val | |i|
                                    i := projectList value findFirst:[:entry | entry string withoutSeparators = val].
                                    i == 0 ifTrue:[allIdx] ifFalse:[i]]
                    thenSelect:[:idx | idx ~~ 0]. 

    selectionIndex := self selectionIndexHolder value.
    (newSel ~= selectionIndex or:[ selectionIndex == 0]) ifTrue:[
        self selectionIndexHolder value:newSel
    ].

    selectionIndexValid := true.
! !

!ProjectList methodsFor:'drag & drop'!

canDropContext:aDropContext
    |objects package|

    objects := aDropContext dropObjects collect:[:obj | obj theObject].

    (self objectsAreClassFiles:objects) ifTrue:[^ true].

    (objects conform:[:aMethodOrClass | (aMethodOrClass isMethod or:[aMethodOrClass isClass]) ]) ifFalse:[^ false].

    package := self packageAtTargetPointOf:aDropContext.
    package isNil ifTrue:[^ false].

    (objects contains:[:aMethodOrClass | aMethodOrClass package ~= package]) ifFalse:[^ false].
    ^ true

    "Modified: / 17-10-2006 / 18:30:32 / cg"
!

doDropContext:aDropContext
    |package objects methods classes|

    objects := aDropContext dropObjects collect:[:aDropObject | aDropObject theObject].
    (objects conform:[:something | (something isMethod or:[something isClass])]) ifTrue:[
        methods := objects select:[:something | something isMethod].
        classes := objects select:[:something | something isClass].

        package := self packageAtTargetPointOf:aDropContext.
        package notNil ifTrue:[
            methods notEmpty ifTrue:[
                self masterApplication moveMethods:methods toProject:package.
            ].
            classes notEmpty ifTrue:[
                self masterApplication moveClasses:classes toProject:package.
            ]
        ].
        ^ self
    ].

    (objects conform:[:something | something isFilename]) ifTrue:[
        |p|

        p := (self selectedProjects value ? #()) firstIfEmpty:PackageId noProjectID.

        Class packageQuerySignal answer:p
        do:[
            self dropClassFiles:objects.
        ].
        ^ self
    ].

    "Modified: / 17-10-2006 / 18:34:43 / cg"
!

packageAtTargetPointOf:aDropContext
    |p packageListView lineNr item package dropInfo now 
     overItem timeOverItem|

    p := aDropContext targetPoint.

    packageListView := aDropContext targetWidget.

    dropInfo := aDropContext dropInfo.

    lineNr := packageListView yVisibleToLineNr:p y.
    lineNr isNil ifTrue:[^ nil].

    item := projectList value at:lineNr.
    item isNil ifTrue:[^ nil].
    item isString ifTrue:[^ item asSymbol].

    item canExpand ifTrue:[
        now := Timestamp now.
        overItem := dropInfo at:#overItem ifAbsentPut:item.
        timeOverItem := dropInfo at:#timeOverItem ifAbsentPut:[now].

        overItem ~~ item ifTrue:[
            dropInfo at:#timeOverItem put:now.
            dropInfo at:#overItem put:item.
            aDropContext passiveAction:[ self packageAtTargetPointOf:aDropContext ].
        ] ifFalse:[
            (now millisecondDeltaFrom:timeOverItem) >= (UserPreferences current timeToAutoExpandItemsWhenDraggingOver) ifTrue:[
                aDropContext saveDraw:[ item expand. packageListView repairDamage ].
                dropInfo removeKey:#timeOverItem.
                dropInfo removeKey:#overItem.
            ] ifFalse:[
                aDropContext passiveAction:[ self packageAtTargetPointOf:aDropContext ].
            ]
        ].
    ].

    package := item package.
    package = self class nameListEntryForALL ifTrue:[^ nil].
    ^ package.

    "Modified: / 18-11-2006 / 16:13:47 / cg"
! !

!ProjectList methodsFor:'generators'!

makeGenerator
    "return a generator which enumerates the classes from the selected project(s)."

    |selectedPackages thePackage hideUnloadedClasses showChangedClasses|

    selectedPackages := self selectedProjects value.
    selectedPackages size == 0 ifTrue:[
        ^ #()
    ].
    selectedPackages := selectedPackages collect:[:p | p string withoutSeparators].

    showChangedClasses := selectedPackages includes:(self class nameListEntryForChanged).
    hideUnloadedClasses := self hideUnloadedClasses value.

    (selectedPackages includes:(self class nameListEntryForALL)) ifTrue:[
        hideUnloadedClasses ifTrue:[
            ^ Iterator on:[:whatToDo |
                               environment allClassesDo:[:cls |
                                   cls isLoaded ifTrue:[
                                       cls isRealNameSpace ifFalse:[
                                           whatToDo value:cls
                                       ]
                                   ]
                               ]
                          ]
        ].
        ^ Iterator on:[:whatToDo |
                           environment allClassesDo:[:cls |
                               cls isRealNameSpace ifFalse:[
                                   whatToDo value:cls
                               ]
                           ]
                      ]
    ].

    selectedPackages size == 1 ifTrue:[
        "/ faster common case
        thePackage := selectedPackages first.

        ^ Iterator on:[:whatToDo | 
                           |changedClasses|

                           showChangedClasses ifTrue:[ changedClasses := ChangeSet current changedClasses ].

                           environment allClassesDo:[:cls |
                               |doInclude|

                               (hideUnloadedClasses not or:[cls isLoaded])
                               ifTrue:[
                                   cls isRealNameSpace ifFalse:[
                                       doInclude := (thePackage = cls package).
                                       doInclude ifFalse:[
                                           "/ JV@2013-09-17; Why? Java classes can have Smalltalk / Ruby / ... extensions as well!!
                                            "/ cls isJavaClass ifFalse:[
                                               doInclude := (cls methodDictionary contains:[:mthd | thePackage = mthd package])
                                                            or:[ cls class methodDictionary contains:[:mthd | thePackage = mthd package]].
                                            "/ ].
                                            doInclude ifFalse:[
                                                (showChangedClasses and:[ (changedClasses includes:cls theNonMetaclass)
                                                                        or:[(changedClasses includes:cls theMetaclass)] ]) ifTrue:[
                                                    doInclude := true
                                                ].
                                            ].
                                       ].
                                       doInclude ifTrue:[
                                           whatToDo value:cls
                                       ]
                                   ]
                               ]
                           ]
                      ]
    ].

    ^ Iterator on:[:whatToDo | 
                       |changedClasses|

                       showChangedClasses ifTrue:[ changedClasses := ChangeSet current changedClasses ].

                       environment allClassesDo:[:cls |
                           |doInclude|

                           (hideUnloadedClasses not or:[cls isLoaded])
                           ifTrue:[
                               cls isRealNameSpace ifFalse:[
                                   doInclude := (selectedPackages includes:cls package).
                                   doInclude ifFalse:[
                                        cls isJavaClass ifFalse:[
                                           doInclude := (cls methodDictionary contains:[:mthd | selectedPackages includes:mthd package])
                                                        or:[ cls class methodDictionary contains:[:mthd | selectedPackages includes:mthd package]].
                                           doInclude ifFalse:[
                                               (showChangedClasses and:[ (changedClasses includes:cls theNonMetaclass)
                                                                       or:[(changedClasses includes:cls theMetaclass)] ]) ifTrue:[
                                                   doInclude := true
                                               ].
                                           ].

                                        ]
                                   ].
                                   doInclude ifTrue:[
                                       whatToDo value:cls
                                   ]
                               ]
                           ]
                       ]
                  ]

    "Created: / 17-02-2000 / 23:49:37 / cg"
    "Modified: / 10-11-2006 / 17:15:15 / cg"
    "Modified: / 17-09-2013 / 10:24:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectList methodsFor:'initialize-release'!

commonPostBuild
    super commonPostBuild.
    listValid ifFalse:[
        self window sensor class == SynchronousWindowSensor ifFalse:[
            self enqueueDelayedUpdateList.
        ]. 
    ]. 
!

commonPostOpen
    super commonPostOpen.
    listValid ifFalse:[
        self enqueueDelayedUpdateList.
        self enqueueMessage:#updateSelectionIndexFromSelection for:self arguments:nil. 
    ]. 
!

initialize

    super initialize.
    workerQueue := SharedQueue new.
    includedPseudoEntryForChanged := true.
    selectionIndexValid := false.

    "Created: / 14-12-2010 / 15:41:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildProjectListView:projectListView
    projectListView allowDrag:true.
    projectListView 
        dragObjectConverter:[:obj :idx | 
            |project|

            project := projectList value at:idx.
            DropObject newProject:project.
        ].
!

release
    super release.

    projectList removeDependent:self.
! !

!ProjectList methodsFor:'private'!

allShownProjects
    |hideUnloaded allProjects projectBag generator addWithAllParentPackages hideModules|

    hideModules := HideModules ? true.
    hideModules := HideModules ? false.

    sortBy value == #keep ifTrue:[
        allProjects := OrderedCollection new.
    ] ifFalse:[
        allProjects := IdentitySet new.
    ].
    projectBag := Bag new.

    inGeneratorHolder isNil ifTrue:[
        hideUnloaded := self hideUnloadedClasses value.

        addWithAllParentPackages := 
            [:package |
                |p parent module|

                (allProjects includes:package) ifFalse:[
                    allProjects add:package.
                    (package ~= PackageId noProjectID 
                    and:[package ~= #private]) ifTrue:[
                        p := package asPackageId.
                        [(parent := p parentPackage) notNil] whileTrue:[
                            allProjects add:parent asSymbol.
                            p := parent.
                        ].
                        hideModules ifFalse:[
                            (module := p module) notNil ifTrue:[
                                allProjects add:module asSymbol.
                            ].
                        ].
                    ].
                ].
            ].

        environment allClassesDo:[:eachClass |
            |cls pkg p classPackage|

            eachClass isRealNameSpace ifFalse:[

                (hideUnloaded not or:[eachClass isLoaded]) ifTrue:[
                    cls := eachClass theNonMetaclass.
                    (cls isPrivate and:[cls isJavaClass not]) ifTrue:[
                        cls := cls topOwningClass
                    ].

                    classPackage := cls package ? (PackageId noProjectID).
                    classPackage size > 0 ifTrue:[
                        classPackage := classPackage asSymbol.
                        addWithAllParentPackages value:classPackage.
                        projectBag add:classPackage.
                    ] ifFalse:[
                        "/ for now, nameSpaces are not in any package;
                        "/ this might change. Then, 0-sized packages are
                        "/ illegal, and the following should be enabled.
                        "/ self halt
                    ].

                    cls isJavaClass ifFalse:[
                        cls instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                            |mpkg|

                            mpkg := mthd package asSymbol.
                            mpkg ~~ classPackage ifTrue:[   
                                (allProjects includes:mpkg) ifFalse:[
                                    addWithAllParentPackages value:mpkg.
                                ]
                            ].
                        ].
                    ].
                ].
            ].
        ].
        allProjects := allProjects asOrderedCollection.

        "/ those are simulated - in ST/X, empty projects do not
        "/ really exist; however, during browsing, it makes sense.
        AdditionalEmptyProjects size > 0 ifTrue:[
            "/ remove those that are present ...
            AdditionalEmptyProjects := AdditionalEmptyProjects select:[:pkg | (allProjects includes:pkg) not].
            allProjects addAll:AdditionalEmptyProjects.
        ].
    ] ifFalse:[
        generator := inGeneratorHolder value.
        generator isNil ifTrue:[^ #() ].
        generator do:[:prj | allProjects add:prj].
    ].
    ^ allProjects asOrderedCollection.

    "Modified: / 16-01-2007 / 15:56:16 / cg"
    "Modified: / 28-04-2014 / 10:15:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultSlaveModeValue
    |mode|

    mode := self topApplication perform:#initialOrganizerMode ifNotUnderstood:nil.
    mode == OrganizerCanvas organizerModeProject ifTrue:[^ false].
    mode isNil ifTrue:[^ false].
    ^ true
!

initialOrganizerMode
    ^ OrganizerCanvas organizerModeProject       
!

listOfProjects
    |allProjects numClassesInChangeSet|

    allProjects := self allShownProjects copyAsOrderedCollection.
    sortBy value ~~ #keep ifTrue:[ 
        allProjects sort 
    ].

    allProjects size == 1 ifTrue:[
        "/ self projectLabelHolder value:(allProjects first , ' [Project]').
        self projectLabelHolder value:(LabelAndIcon icon:(self class packageIcon) string:allProjects first).
    ].

    sortBy value ~~ #keep ifTrue:[ 
        includedPseudoEntryForChanged ifTrue:[
            numClassesInChangeSet := ChangeSet current changedClasses size.
            numClassesInChangeSet > 0 ifTrue:[
                "/ don't include count - makeGenerator compares against the un-expanded nameListEntry (sigh - need two lists)
                allProjects addFirst:((self class nameListEntryForChanged "bindWith:numClassesInChangeSet") allItalic).
            ].
        ].

        allProjects size > 1 ifTrue:[
            allProjects addFirst:(self class nameListEntryForALL allItalic).
        ].
    ].

    ^ allProjects

    "Created: / 17-02-2000 / 23:43:05 / cg"
    "Modified: / 17-08-2006 / 15:08:42 / cg"
!

makeDependent
    environment addDependent:self.
    ChangeSet addDependent:self.
!

makeIndependent
    environment removeDependent:self.
    ChangeSet removeDependent:self.
!

markEntry: rawEntry at: index forBeingManagedBySVN: package
    ^ rawEntry.

    (ConfigurableFeatures includesFeature: #SubversionSupportEnabled) ifFalse:[^rawEntry].
    package = PackageId noProjectID ifTrue:[^rawEntry].

"/    workerQueue 
"/        nextPut:[
"/            | repo newEntry branch mark|
"/            "/ use environment-at to trick the dependency/prerequisite generator
"/            repo := (environment at:#SVN::RepositoryManager) current 
"/                        repositoryForPackage: package onlyFromCache: false.
"/            repo ifNotNil:[
"/                mark := ' [SVN]'.
"/                branch := repo workingCopy branchOrNil.
"/                branch ifNotNil:[mark := ' [SVN: ', branch path,']'].
"/                newEntry := rawEntry , (mark asText colorizeAllWith: Color gray).
"/                self projectNameList value at: index put: newEntry.
"/                self projectNameList changed.
"/            ]].
    ^rawEntry

    "Created: / 14-12-2010 / 15:59:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2012 / 13:17:30 / cg"
    "Modified: / 19-01-2012 / 10:46:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameListFor:aProjectList
    "
     self basicNew
         nameListFor:#(
            'exept:expecco'
            'exept:expecco/application'
            'exept:procware'
            'exept:workflow'
        )

     self basicNew
         nameListFor:#(
            'exept'
            'exept:expecco'
            'exept:expecco/application'
            'exept:procware'
            'exept:workflow'
        )
    "

    |stack projectsWithExtensions projectsWithChangedCode packagesInChangeSet projectNameList|

    stack := OrderedCollection new.

    projectsWithExtensions := Set new.
    projectsWithChangedCode := Set new.

    packagesInChangeSet := ChangeSet current changedPackages.

    projectNameList := OrderedCollection new.
    aProjectList do:[:this |
        |thisC entry rawEntry prefix indent|

        this = self class nameListEntryForALL ifTrue:[
            entry := this
        ] ifFalse:[
            thisC := this asCollectionOfSubstringsSeparatedByAny:':/'.
            thisC isEmpty ifTrue:[
                thisC := Array with:(PackageId noProjectID).
            ].

            [
                |stackTop|

                stack notEmpty
                and:[
                    stackTop := stack last.
                    (thisC startsWith:stackTop) ifFalse:[
                        stack removeLast.
                        true
                    ] ifTrue:[
                        false
                    ]]
            ] whileTrue.
            prefix := stack notEmpty ifTrue:[ stack last ] ifFalse:[ #() ].
            indent := stack size * 4.
            stack addLast:thisC.
            prefix isEmpty ifTrue:[
                rawEntry := thisC first.
                thisC size > 1 ifTrue:[
                    rawEntry := rawEntry , ':' , ((thisC copyFrom:2) asStringWith:$/).
                ]
            ] ifFalse:[
                rawEntry := (thisC copyFrom:prefix size+1) asStringWith:$/.
            ].

            (packagesInChangeSet includes:this) ifTrue:[
                rawEntry := rawEntry , self class markForBeingInChangeList.
                rawEntry := self colorizeForChangedCode:rawEntry.
            ].
        
            entry := (String new:indent) , rawEntry.
            ((ConfigurableFeatures includesFeature: #SubversionSupportEnabled) and:[this first ~= $*]) ifTrue:[
                entry := self markEntry: entry at: projectNameList size + 1 forBeingManagedBySVN: this.
            ].
        ].
        projectNameList add:entry.
    ].
    self startWorker.        
    ^ projectNameList.

    "Created: / 17-02-2000 / 23:43:05 / cg"
    "Modified: / 07-09-2011 / 10:45:05 / cg"
    "Modified: / 19-01-2012 / 10:46:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startWorker
    worker 
        ifNil:[
            worker := [
                    [ workerQueue notEmpty ] whileTrue:[
                        |job|

                        job := workerQueue next.
                        job value
                    ].
                    worker := nil.
                ] newProcess.
            worker resume
        ].

    "Created: / 14-12-2010 / 15:49:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2010 / 17:35:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    |newList oldList newNameList oldNameList oldSelection newSelection selectedProjectsHolder|

    selectedProjectsHolder := self selectedProjects.
    oldSelection := selectedProjectsHolder value.
    newList := self listOfProjects.
    oldList := projectList value.
    newNameList := self nameListFor:newList.
    oldNameList := self projectNameList value.
    (newList ~= oldList
    or:[ newNameList ~= oldNameList]) ifTrue:[
"/        oldSelection size > 0 ifTrue:[
"/            selectedProjectsHolder removeDependent:self.
"/            selectedProjectsHolder value:#().
"/            selectedProjectsHolder addDependent:self.
"/        ].

        self projectList value ~= newList ifTrue:[
            "Hack to avoid recursion"
            self projectList value:newList.
        ].
        self setListValid:true.
        self projectNameList value:newNameList.

        oldSelection size > 0 ifTrue:[
            newSelection := oldSelection select:[:prj | newList includes:prj].
            selectedProjectsHolder value:newSelection.
        ]
    ].
    self setListValid:true.

    "Modified: / 25.2.2000 / 23:10:01 / cg"
! !

!ProjectList methodsFor:'special'!

addAdditionalProject:aProject
    "/ those are simulated - in ST/X, empty projects do not
    "/ really exist; however, during browsing, it makes sense.
    AdditionalEmptyProjects isNil ifTrue:[
        AdditionalEmptyProjects := Set new.
    ].
    AdditionalEmptyProjects add:aProject.

    environment changed:#projectOrganization   "/ not really ... to force update

    "Created: / 17.2.2000 / 23:44:27 / cg"
!

removeAdditionalProjects:aListOfProjects
    "/ those are simulated - in ST/X, empty categories do not
    "/ really exist; however, during browsing, it makes sense.
    AdditionalEmptyProjects notNil ifTrue:[
	aListOfProjects do:[:eachProject |
	    AdditionalEmptyProjects remove:eachProject ifAbsent:nil.
	].
    ].
    environment changed:#projectOrganization   "/ not really ... to force update

    "Created: / 17.2.2000 / 23:45:24 / cg"
! !

!ProjectList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

