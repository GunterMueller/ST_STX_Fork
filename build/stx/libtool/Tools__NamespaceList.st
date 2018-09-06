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

BrowserList subclass:#NamespaceList
	instanceVariableNames:'namespaceNameList namespaceList'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!NamespaceList class methodsFor:'documentation'!

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
    I implement the namespace list in the new system browser
"
! !

!NamespaceList class methodsFor:'interface specs'!

singleNameSpaceWindowSpec
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
	#name: #singleNameSpaceWindowSpec
	#window: 
       #(#WindowSpec
	  #label: 'NameSpaceList'
	  #name: 'NameSpaceList'
	  #min: #(#Point 0 0)
	  #max: #(#Point 1024 721)
	  #bounds: #(#Rectangle 218 175 518 475)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'NameSpaceName'
	      #name: 'NameSpaceLabel'
	      #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 25 0)
	      #translateLabel: true
	      #labelChannel: #nameSpaceLabelHolder
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
     UIPainter new openOnClass:ProjectList andSelector:#windowSpec
     ProjectList new openInterface:#windowSpec
     ProjectList open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'NamespaceList'
          #name: 'NamespaceList'
          #min: #(#Point 0 0)
          #bounds: #(#Rectangle 13 23 313 323)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SequenceViewSpec
              #name: 'List'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #tabable: true
              #model: #selectedNamespaces
              #menu: #menuHolder
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #valueChangeSelector: #selectionChangedByClick
              #useIndex: false
              #sequenceList: #nameSpaceList
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

    "Created: / 18.2.2000 / 01:06:05 / cg"
    "Modified: / 18.2.2000 / 01:24:50 / cg"
! !

!NamespaceList class methodsFor:'queries-plugin'!

aspectSelectors
    ^ #( 
        environmentHolder
        #(#doubleClickChannel #action )
        immediateUpdate 
        selectedNamespaces 
        menuHolder 
        inGeneratorHolder 
        outGeneratorHolder 
        selectionChangeCondition 
        updateTrigger
        forceGeneratorTrigger
        hideUnloadedClasses
        showAllClassesInNameSpaceOrganisation
        organizerMode
        slaveMode
       )

    "Created: / 18-02-2000 / 01:06:27 / cg"
    "Modified: / 05-03-2007 / 16:47:45 / cg"
    "Modified: / 24-02-2014 / 10:37:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceList methodsFor:'aspects'!

itemList
    ^ self nameSpaceList value
!

nameSpaceLabelHolder
    ^ self pseudoListLabelHolder
!

nameSpaceList
    namespaceList isNil ifTrue:[
	namespaceList := ValueHolder new
    ].
    ^ namespaceList

    "Created: / 18.2.2000 / 00:59:01 / cg"
!

selectedNamespaces
    ^ self selectionHolder

!

selectedNamespaces:aValueHolder
    ^ self selectionHolder:aValueHolder

! !

!NamespaceList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject

    self inSlaveModeOrInvisible 
    ifTrue:[
	changedObject == environment ifTrue:[
	    something == #classComment ifTrue:[^ self].
	].
	self invalidateList.
	^ self
    ].

    changedObject == slaveMode ifTrue:[
	listValid ~~ true ifTrue:[
	    self enqueueDelayedUpdateList
	].
	"/ self invalidateList.
	^  self
    ].

    changedObject == environment ifTrue:[
	something == #newClass ifTrue:[
	    listValid == true ifTrue:[
		aParameter isNameSpace ifTrue:[
		    (namespaceList value includes:aParameter name) ifFalse:[
			self invalidateList.
		    ]
		].
	    ].
	    ^ self
	].
	something == #classRemove ifTrue:[
	    listValid == true ifTrue:[
		aParameter isNameSpace ifTrue:[
		    self invalidateList.
		].
	    ].
	    ^ self
	].
	^ self
    ].

    super delayedUpdate:something with:aParameter from:changedObject

    "Created: / 18.2.2000 / 01:00:07 / cg"
    "Modified: / 26.2.2000 / 01:10:46 / cg"
!

selectionChangedByClick
    "we are not interested in that - get another notification
     via the changed valueHolder"

    "Created: / 18.2.2000 / 01:00:14 / cg"
!

update:something with:aParameter from:changedObject
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

    "Modified: / 20-07-2011 / 18:55:12 / cg"
! !

!NamespaceList methodsFor:'drag & drop'!

canDropContext:aDropContext
    |objects nameSpace|

    objects := aDropContext dropObjects collect:[:obj | obj theObject].
    (objects conform:[:aMethodOrClass | aMethodOrClass isClass ]) ifFalse:[^ false].

    nameSpace := self nameSpaceAtTargetPointOf:aDropContext.
    nameSpace isNil ifTrue:[^ false].
    nameSpace = self class nameListEntryForALL ifTrue:[^ false].

    ^ (objects contains:[:aClass | aClass nameSpace name ~= nameSpace]) 
!

doDropContext:aDropContext
    |nameSpaceName nameSpace objects|

    objects := aDropContext dropObjects collect:[:aDropObject | aDropObject theObject].
    (objects conform:[:something | something isClass]) ifTrue:[
        nameSpaceName := self nameSpaceAtTargetPointOf:aDropContext.
        (nameSpaceName notNil
        and:[ nameSpaceName ~= self class nameListEntryForALL]) ifTrue:[
            nameSpace := NameSpace name:nameSpaceName.
            objects do:[:eachClassToMove |
                |className|

                className := eachClassToMove nameWithoutPrefix.
                nameSpace == environment ifTrue:[
                    environment renameClass:eachClassToMove to:className asSymbol.
                ] ifFalse:[
                    environment renameClass:eachClassToMove to:(nameSpace name , '::' , className) asSymbol.
                    nameSpace changed.
                ].
            ].
            environment changed.
        ].
        ^ self
    ].
!

nameSpaceAtTargetPointOf:aDropContext
    |p targetView lineNr item|

    p := aDropContext targetPoint.

    targetView := aDropContext targetWidget.

    lineNr := targetView yVisibleToLineNr:p y.
    lineNr isNil ifTrue:[^ nil].

    item := self itemList at:lineNr.
    item isNil ifTrue:[^ nil].

    ^ item
! !

!NamespaceList methodsFor:'generators'!

makeGenerator
    "return a generator which enumerates the classes from the selected namespace(s)."

    |spaceNames hideUnloadedClasses showAllClasses showChangedClasses|

    spaceNames := self selectedNamespaces value.
    spaceNames size == 0 ifTrue:[
        ^ #()
    ].

    hideUnloadedClasses := self hideUnloadedClasses value.
    showAllClasses := self showAllClassesInNameSpaceOrganisation value.
    showChangedClasses := spaceNames includes:(self class nameListEntryForChanged).

    (showAllClasses or:[spaceNames includes:(self class nameListEntryForALL)]) ifTrue:[
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
                           environment allClassesDo:whatToDo
                      ]
    ].

    (spaceNames size == 1 
     and:[spaceNames first = 'environment']) ifTrue:[
        "/ somewhat tuned - quick look if classes name includes colons ...
        ^ Iterator on:[:whatToDo |
                       environment allClassesDo:[:cls |
                           |includeIt|

                           includeIt := (cls name includes:$:) not.
                           includeIt := includeIt
                                        or:[(cls isPrivate not 
                                            and:[(cls nameSpace == environment)])].
                           includeIt := includeIt
                                        or:[(cls isPrivate  
                                            and:[(cls topOwningClass nameSpace == environment)])].

                           includeIt := includeIt
                                        and:[hideUnloadedClasses not or:[cls isLoaded]].

                           includeIt := includeIt
                                        or:[ cls extensions 
                                                contains:[:mthd | 
                                                            |sel parts|
                                                            sel := mthd selector.
                                                            (sel isNameSpaceSelector
                                                            and:[ parts := sel nameSpaceSelectorParts.
                                                                  spaceNames includes:parts first])  
                                                         ]
                                           ].

                           includeIt ifTrue:[
                               cls isRealNameSpace ifFalse:[
                                   whatToDo value:cls
                               ]
                           ]
                       ]
                      ]
    ].

    ^ Iterator on:[:whatToDo |
                       |changedClasses|

                        showChangedClasses ifTrue:[ changedClasses := ChangeSet current changedClasses collect:[:cls | cls theNonMetaclass]].

                        environment allClassesDo:[:cls |
                            |spaceOfClass spaceNameOfClass includeIt|

                            spaceOfClass := cls isPrivate ifTrue:[cls topOwningClass nameSpace] ifFalse:[cls nameSpace].
                            spaceNameOfClass := spaceOfClass name.

                            includeIt := spaceNames contains:[:nm | nm = spaceNameOfClass
                                                                    or:[spaceNameOfClass startsWith:(nm , '::')]].
                            includeIt ifFalse:[
                                (showChangedClasses and:[ (changedClasses includes:cls theNonMetaclass) ]) ifTrue:[
                                    includeIt := true
                                ].
                            ].
                            hideUnloadedClasses ifTrue:[
                                includeIt := includeIt and:[cls isLoaded].
                            ].
                            includeIt ifTrue:[
                                cls isRealNameSpace ifFalse:[
                                    whatToDo value:cls
                                ]
                            ]
                        ]
                  ]

    "Created: / 18-02-2000 / 01:01:58 / cg"
    "Modified: / 05-03-2007 / 23:01:21 / cg"
! !

!NamespaceList methodsFor:'private'!

defaultSlaveModeValue
    |mode|

    mode := self topApplication perform:#initialOrganizerMode ifNotUnderstood:nil.
    mode == OrganizerCanvas organizerModeNamespace ifTrue:[^ false].
"/    self organizerMode value == OrganizerCanvas organizerModeCategory ifTrue:[^ true].
"/    ^ false
    mode isNil ifTrue:[^ false].
    ^ true
!

initialOrganizerMode
    ^ OrganizerCanvas organizerModeNamespace
!

listOfNamespaces
    |allNamespaces showAllNamespaces generator|

    showAllNamespaces := false.    "/ only topLevel namespaces are shown
    showAllNamespaces := true.

    allNamespaces := IdentitySet new.

    inGeneratorHolder isNil ifTrue:[
        (self hideUnloadedClasses value) ifTrue:[
            environment allClassesDo:[:eachClass |
                eachClass isLoaded ifTrue:[
                    allNamespaces add:(eachClass theNonMetaclass topNameSpace)
                ].
            ]
        ] ifFalse:[
            allNamespaces := NameSpace allNameSpaces.
        ].

        showAllNamespaces ifFalse:[
            "/ only topLevel namespaces are shown
            "/ i.e. ignore subspaces 

            allNamespaces := allNamespaces select:[:ns | ns isTopLevelNameSpace].
        ].
        "/JV@2011-12-04: Do not show java packages, they are all shown
        "/when JAVA namespace is shown. Use #askFor: here, as eXept's libbasic
        "/does not have #isJavaPackage
        allNamespaces := allNamespaces reject:[:ns | ns askFor: #isJavaPackage ].

        allNamespaces := allNamespaces collect:[:ns | ns name].
    ] ifFalse:[
        generator := inGeneratorHolder value.
        generator isNil ifTrue:[^ #() ].
        generator do:[:ns | allNamespaces add:ns].
    ].

    allNamespaces := allNamespaces asOrderedCollection.
    allNamespaces sort.
    allNamespaces size == 1 ifTrue:[
        self nameSpaceLabelHolder value:(LabelAndIcon icon:(self class nameSpaceIcon) string:allNamespaces first).
    ].

"/ for now: disabled, because it gets replicated into the nameSpace filter, which
"/ does not (yet) handle it correctly
"/    numClassesInChangeSet := ChangeSet current changedClasses size.
"/    numClassesInChangeSet > 0 ifTrue:[
"/        "/ don't include count - makeGenerator compares against the un-expanded nameListEntry (sigh - need two lists)
"/        allNamespaces addFirst:((self class nameListEntryForChanged "bindWith:numClassesInChangeSet") allItalic).
"/    ].

    allNamespaces addFirst:(self class nameListEntryForALL allItalic).
    ^ allNamespaces

    "Created: / 18-02-2000 / 01:04:27 / cg"
    "Modified: / 25-02-2000 / 22:11:29 / cg"
    "Modified: / 04-12-2011 / 12:30:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeDependent
    environment addDependent:self

    "Created: / 18.2.2000 / 01:04:36 / cg"
!

makeIndependent
    environment removeDependent:self.

    "Created: / 18.2.2000 / 01:04:42 / cg"
!

updateList
    |newList oldSelection newSelection selectedNamespacesHolder|

    selectedNamespacesHolder := self selectedNamespaces.
    oldSelection := selectedNamespacesHolder value.
    newList := self listOfNamespaces.
    newList ~= namespaceList value ifTrue:[
"/        oldSelection size > 0 ifTrue:[
"/            selectedNamespacesHolder removeDependent:self.
"/            selectedNamespacesHolder value:#().
"/            selectedNamespacesHolder addDependent:self.
"/        ].
        self nameSpaceList value:newList.

        oldSelection size > 0 ifTrue:[
            newSelection := oldSelection select:[:nm | 
                                (nm = self class nameListEntryForALL) 
                                or:[ (environment at:nm asSymbol) isNameSpace]
                            ].
            newSelection ~= oldSelection ifTrue:[
                selectedNamespacesHolder value:newSelection.
            ]
        ]
    ].
    self setListValid:true.
! !

!NamespaceList class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

