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

NavigatorModel subclass:#OrganizerCanvas
	instanceVariableNames:'projectListSlaveMode namespaceListSlaveMode categoryListSlaveMode
		classInheritanceListSlaveMode classListSlaveMode
		classHierarchyListSlaveMode organizerMode metaToggle
		notMetaToggle meta classList classCategoryDoubleClickChannel
		classDoubleClickChannel classGeneratorHolder
		classGeneratorHolderFromClassCategory
		classGeneratorHolderFromClassHierarchy
		classGeneratorHolderFromProject classGeneratorHolderFromNamespace
		classCategoryListMenuHolder categoryListShown
		classCategoryListUpdateTrigger classListUpdateTrigger
		classListMenuHolder classHierarchyListMenuHolder
		projectListMenuHolder variablesMenuHolder filterClassVars
		variableFilter packageFilter nameSpaceFilter hidePrivateClasses
		hideUnloadedClasses showClassPackages immediateUpdate
		metaToggleLabelHolder selectedCategories selectedClasses
		selectedNamespaces selectedProjects selectionChangeCondition
		nameSpaceFilterSelection markApplicationsHolder
		sortVariablesByName showAllClassesInNameSpaceView
		showMethodInheritance showMethodComplexity showMethodTypeIcon
		methodVisibilityHolder showCoverageInformation
		sortByNameAndInheritance nameSpaceListWidgetVisibleHolder
		groupVariablesByInheritance'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!OrganizerCanvas class methodsFor:'documentation'!

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
    I implement the top part containing the list views in the new system browser
"
! !

!OrganizerCanvas class methodsFor:'constants'!

organizerModeCategory
    ^ #category
!

organizerModeClassHierarchy
    ^ #classHierarchy
!

organizerModeClassInheritance
    ^ #classInheritance
!

organizerModeHierarchy
    ^ #hierarchy
!

organizerModeNamespace
    ^ #namespace
!

organizerModePackageDiagram
    ^ #packageDiagram
!

organizerModeProject
    ^ #project
! !

!OrganizerCanvas class methodsFor:'interface specs'!

embeddedNameSpaceListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::OrganizerCanvas andSelector:#embeddedNameSpaceListSpec
     Tools::OrganizerCanvas new openInterface:#embeddedNameSpaceListSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: embeddedNameSpaceListSpec
       window: 
      (WindowSpec
         label: 'Organizer'
         name: 'Organizer'
         min: (Point 0 0)
         max: (Point 1024 721)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (SubCanvasSpec
             name: 'NamespaceList2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             majorKey: NamespaceList
             subAspectHolders: 
            (Array
               
              (SubChannelInfoSpec
                 subAspect: doubleClickChannel
                 aspect: nameSpaceFilterDoubleClickChannel
               ) 
              (SubChannelInfoSpec
                 subAspect: environmentHolder
                 aspect: environmentHolder
               )
               
              (SubChannelInfoSpec
                 subAspect: forceGeneratorTrigger
                 aspect: forceNamespaceGeneratorTrigger
               ) 
              (SubChannelInfoSpec
                 subAspect: hideUnloadedClasses
                 aspect: hideUnloadedClasses
               )
               
              (SubChannelInfoSpec
                 subAspect: immediateUpdate
                 aspect: immediateUpdate
               ) 
              (SubChannelInfoSpec
                 subAspect: menuHolder
                 aspect: nameSpaceListMenuHolder
               )
               
              (SubChannelInfoSpec
                 subAspect: organizerMode
                 aspect: organizerMode
               ) 
              (SubChannelInfoSpec
                 subAspect: outGeneratorHolder
                 aspect: classGeneratorHolder
               )
               
              (SubChannelInfoSpec
                 subAspect: selectedNamespaces
                 aspect: nameSpaceFilterSelection
               ) 
              (SubChannelInfoSpec
                 subAspect: selectionChangeCondition
                 aspect: selectionChangeCondition
               )
               
              (SubChannelInfoSpec
                 subAspect: slaveMode
                 aspect: popUpNameSpaceListSlaveMode
               ) 
              (SubChannelInfoSpec
                 subAspect: updateTrigger
                 aspect: nameSpaceListUpdateTrigger
               )
             )
             createNewApplication: true
             createNewBuilder: true
             postBuildCallback: nameSpaceListWidgetWasBuilt:
           )
          )
        
       )
     )
!

windowSpec
    ^ self windowSpecNonHierarchicalWithClassDiagram
    "/ ^ self windowSpecNonHierarchical
    "/ ^ self windowSpecHierarchical

    "
     self openInterface:#windowSpec
     self openInterface:#windowSpecWithoutMetaToggles
     self openInterface:#windowSpecNonHierarchicalWithClassDiagram
    "

    "Modified: / 03-09-2006 / 10:47:15 / cg"
!

windowSpecHierarchical
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::OrganizerCanvas andSelector:#windowSpecHierarchical
     Tools::OrganizerCanvas new openInterface:#windowSpecHierarchical
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpecHierarchical
       window: 
      (WindowSpec
         label: 'Organizer'
         name: 'Organizer'
         min: (Point 0 0)
         max: (Point 1024 721)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'CategoryNameSpaceAndProjectPanel'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             visibilityChannel: categoryNameSpaceAndProjectPanelShown
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'LeftBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'ClassCategoryAndNamespaceFilterBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         visibilityChannel: categoryListShown
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassCategoryList'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                               majorKey: HierarchicalClassCategoryList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classCategoryDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: forceGeneratorTrigger
                                   aspect: forceClassCategoryGeneratorTrigger
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classCategoryListMenuHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilterSelection
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: classGeneratorHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedCategories
                                   aspect: selectedCategories
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: categoryListSlaveMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classCategoryListUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            (ExtendedComboBoxSpec
                               name: 'NameSpaceFilterComboBox'
                               layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                               tabable: true
                               model: nameSpaceFilterSelectedNameSpace
                               menuWidgetHolder: nameSpaceListWidgetHolder
                               miniScrollerHorizontal: true
                               menuSelector: nameSpaceFilterPopUpMenu
                             )
                            )
                          
                         )
                       )
                      (SubCanvasSpec
                         name: 'NamespaceList'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         initiallyInvisible: true
                         visibilityChannel: nameSpaceListShown
                         majorKey: NamespaceList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: nameSpaceDoubleClickChannel
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: forceGeneratorTrigger
                             aspect: forceNamespaceGeneratorTrigger
                           ) 
                          (SubChannelInfoSpec
                             subAspect: hideUnloadedClasses
                             aspect: hideUnloadedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: nameSpaceListMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classGeneratorHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedNamespaces
                             aspect: selectedNamespaces
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeCondition
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: slaveMode
                             aspect: nameSpaceListSlaveMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: updateTrigger
                             aspect: nameSpaceListUpdateTrigger
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'ProjectList'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         initiallyInvisible: true
                         visibilityChannel: projectListShown
                         majorKey: ProjectList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: projectDoubleClickChannel
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: forceGeneratorTrigger
                             aspect: forceProjectGeneratorTrigger
                           ) 
                          (SubChannelInfoSpec
                             subAspect: hideUnloadedClasses
                             aspect: hideUnloadedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: projectListMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classGeneratorHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedProjects
                             aspect: selectedProjects
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeCondition
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: slaveMode
                             aspect: projectListSlaveMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: updateTrigger
                             aspect: projectListUpdateTrigger
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      )
                    
                   )
                 )
                (ViewSpec
                   name: 'RightBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (VariableVerticalPanelSpec
                         name: 'ClassAndVariablesPanel'
                         layout: (LayoutFrame 0 0 0 0 0 1 -25 1)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               minorKey: windowSpec
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: hidePrivateClasses
                                   aspect: hidePrivateClasses
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: inGeneratorHolder
                                   aspect: classGeneratorHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classListMenuHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: meta
                                   aspect: meta
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilter
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: outGeneratorHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolderForMethods
                                   aspect: selectorListGenerator5
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: showClassPackages
                                   aspect: showClassPackages
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classListSlaveMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classListUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            (SubCanvasSpec
                               name: 'VariableList'
                               majorKey: VariableList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: classHolder
                                   aspect: selectedClasses
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: variableDoubleClickChannel
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesMenuHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectedVariables
                                   aspect: variableFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showClassVarsInVariableList
                                   aspect: showClassVarsInVariableList
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortVariablesByName
                                   aspect: sortVariablesByName
                                 )
                    (SubChannelInfoSpec
                       subAspect: groupVariablesByInheritance
                       aspect: groupVariablesByInheritance
                     )
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classListSlaveMode
                                 ) 
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggleSpec2'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          (ViewSpec
             name: 'ClassHierarchyOrInheritanceBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             initiallyInvisible: true
             visibilityChannel: classHierarchyOrInheritanceShown
             component: 
            (SpecCollection
               collection: (
                (VariableVerticalPanelSpec
                   name: 'VariableVerticalPanel2'
                   layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                   showHandle: false
                   snapMode: both
                   handlePosition: left
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'HierarchyOrInheritanceBox'
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassHierarchyList'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                               visibilityChannel: classHierarchyShown
                               majorKey: HierarchicalClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: forceGeneratorTrigger
                                   aspect: forceClassInheritanceGeneratorTrigger
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classInheritanceListMenuHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: meta
                                   aspect: meta
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: outGeneratorHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolderForMethods
                                   aspect: selectorListGenerator5
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showClassPackages
                                   aspect: showClassPackages
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classHierarchyListSlaveMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: topClassHolder
                                   aspect: classHierarchyTopClass
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classHierarchyUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            (SubCanvasSpec
                               name: 'ClassInheritanceList'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                               visibilityChannel: classInheritanceShown
                               majorKey: InheritanceClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: forceGeneratorTrigger
                                   aspect: forceClassInheritanceGeneratorTrigger
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classInheritanceListMenuHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: meta
                                   aspect: meta
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: outGeneratorHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolderForMethods
                                   aspect: selectorListGenerator5
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showClassPackages
                                   aspect: showClassPackages
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classInheritanceListSlaveMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: topClassHolder
                                   aspect: classHierarchyTopClass
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classHierarchyUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                       )
                      (SubCanvasSpec
                         name: 'VariableList2'
                         majorKey: VariableList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: classHolder
                             aspect: selectedClasses
                           ) 
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: variableDoubleClickChannel
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: variablesMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedVariables
                             aspect: variableFilter
                           ) 
                          (SubChannelInfoSpec
                             subAspect: showClassVarsInVariableList
                             aspect: showClassVarsInVariableList
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: slaveMode
                             aspect: classHierarchyListSlaveMode
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      )
                    
                   )
                   handles: (Any 0.5 1.0)
                 )
                (SubCanvasSpec
                   name: 'MetaToggles1'
                   layout: (LayoutFrame 0 0.0 -25 1 0 1.0 0 1)
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   minorKey: metaSpec
                   createNewBuilder: false
                 )
                )
              
             )
           )
          )
        
       )
     )
!

windowSpecNonHierarchical
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::OrganizerCanvas andSelector:#windowSpecNonHierarchical
     Tools::OrganizerCanvas new openInterface:#windowSpecNonHierarchical
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpecNonHierarchical
       window: 
      (WindowSpec
         label: 'Organizer'
         name: 'Organizer'
         min: (Point 0 0)
         max: (Point 1024 721)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'CategoryNameSpaceAndProjectPanel'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             visibilityChannel: categoryNameSpaceAndProjectPanelShown
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'LeftBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'ClassCategoryAndNamespaceFilterBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         visibilityChannel: categoryListShown
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassCategoryList'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                               majorKey: ClassCategoryList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classCategoryDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: forceGeneratorTrigger
                                   aspect: forceClassCategoryGeneratorTrigger
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classCategoryListMenuHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilterSelection
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: classGeneratorHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedCategories
                                   aspect: selectedCategories
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: categoryListSlaveMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classCategoryListUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            (ExtendedComboBoxSpec
                               name: 'NameSpaceFilterComboBox'
                               layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                               tabable: true
                               model: nameSpaceFilterSelectedNameSpace
                               menuWidgetHolder: nameSpaceListWidgetHolder
                               miniScrollerHorizontal: true
                               menuSelector: nameSpaceFilterPopUpMenu
                             )
                            )
                          
                         )
                       )
                      (SubCanvasSpec
                         name: 'NamespaceList'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         initiallyInvisible: true
                         visibilityChannel: nameSpaceListShown
                         majorKey: NamespaceList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: nameSpaceDoubleClickChannel
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: forceGeneratorTrigger
                             aspect: forceNamespaceGeneratorTrigger
                           ) 
                          (SubChannelInfoSpec
                             subAspect: hideUnloadedClasses
                             aspect: hideUnloadedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: nameSpaceListMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classGeneratorHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedNamespaces
                             aspect: selectedNamespaces
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeCondition
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: slaveMode
                             aspect: nameSpaceListSlaveMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: updateTrigger
                             aspect: nameSpaceListUpdateTrigger
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'ProjectList'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         initiallyInvisible: true
                         visibilityChannel: projectListShown
                         majorKey: ProjectList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: projectDoubleClickChannel
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: forceGeneratorTrigger
                             aspect: forceProjectGeneratorTrigger
                           ) 
                          (SubChannelInfoSpec
                             subAspect: hideUnloadedClasses
                             aspect: hideUnloadedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: projectListMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classGeneratorHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedProjects
                             aspect: selectedProjects
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeCondition
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: slaveMode
                             aspect: projectListSlaveMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: updateTrigger
                             aspect: projectListUpdateTrigger
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      )
                    
                   )
                 )
                (ViewSpec
                   name: 'RightBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (VariableVerticalPanelSpec
                         name: 'ClassAndVariablesPanel'
                         layout: (LayoutFrame 0 0 0 0 0 1 -25 1)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               minorKey: windowSpec
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: hidePrivateClasses
                                   aspect: hidePrivateClasses
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: inGeneratorHolder
                                   aspect: classGeneratorHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classListMenuHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: meta
                                   aspect: meta
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilter
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: outGeneratorHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolderForMethods
                                   aspect: selectorListGenerator5
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: showClassPackages
                                   aspect: showClassPackages
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classListSlaveMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classListUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            (SubCanvasSpec
                               name: 'VariableList'
                               majorKey: VariableList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: classHolder
                                   aspect: selectedClasses
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: variableDoubleClickChannel
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesMenuHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectedVariables
                                   aspect: variableFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showClassVarsInVariableList
                                   aspect: showClassVarsInVariableList
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortVariablesByName
                                   aspect: sortVariablesByName
                                 )
                    (SubChannelInfoSpec
                       subAspect: groupVariablesByInheritance
                       aspect: groupVariablesByInheritance
                     )
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classListSlaveMode
                                 ) 
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggleSpec2'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          (ViewSpec
             name: 'ClassHierarchyOrInheritanceBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             initiallyInvisible: true
             visibilityChannel: classHierarchyOrInheritanceShown
             component: 
            (SpecCollection
               collection: (
                (VariableVerticalPanelSpec
                   name: 'VariableVerticalPanel2'
                   layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                   showHandle: false
                   snapMode: both
                   handlePosition: left
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'HierarchyOrInheritanceBox'
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassHierarchyList'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                               visibilityChannel: classHierarchyShown
                               majorKey: HierarchicalClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: forceGeneratorTrigger
                                   aspect: forceClassInheritanceGeneratorTrigger
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classInheritanceListMenuHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: meta
                                   aspect: meta
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: outGeneratorHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolderForMethods
                                   aspect: selectorListGenerator5
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showClassPackages
                                   aspect: showClassPackages
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classHierarchyListSlaveMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: topClassHolder
                                   aspect: classHierarchyTopClass
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classHierarchyUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            (SubCanvasSpec
                               name: 'ClassInheritanceList'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                               visibilityChannel: classInheritanceShown
                               majorKey: InheritanceClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: forceGeneratorTrigger
                                   aspect: forceClassInheritanceGeneratorTrigger
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classInheritanceListMenuHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: meta
                                   aspect: meta
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: outGeneratorHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolderForMethods
                                   aspect: selectorListGenerator5
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showClassPackages
                                   aspect: showClassPackages
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classInheritanceListSlaveMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: topClassHolder
                                   aspect: classHierarchyTopClass
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classHierarchyUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                       )
                      (SubCanvasSpec
                         name: 'VariableList2'
                         majorKey: VariableList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: classHolder
                             aspect: selectedClasses
                           ) 
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: variableDoubleClickChannel
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: variablesMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedVariables
                             aspect: variableFilter
                           ) 
                          (SubChannelInfoSpec
                             subAspect: showClassVarsInVariableList
                             aspect: showClassVarsInVariableList
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: slaveMode
                             aspect: classHierarchyListSlaveMode
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      )
                    
                   )
                   handles: (Any 0.5 1.0)
                 )
                (SubCanvasSpec
                   name: 'MetaToggles1'
                   layout: (LayoutFrame 0 0.0 -25 1 0 1.0 0 1)
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   minorKey: metaSpec
                   createNewBuilder: false
                 )
                )
              
             )
           )
          )
        
       )
     )
!

windowSpecNonHierarchicalWithClassDiagram
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::OrganizerCanvas andSelector:#windowSpecNonHierarchicalWithClassDiagram
     Tools::OrganizerCanvas new openInterface:#windowSpecNonHierarchicalWithClassDiagram
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpecNonHierarchicalWithClassDiagram
       window: 
      (WindowSpec
         label: 'Organizer'
         name: 'Organizer'
         min: (Point 0 0)
         max: (Point 1024 721)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'PackageDiagramClassChooser'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             level: 0
             initiallyInvisible: true
             visibilityChannel: packageDiagramShown
             component: 
            (SpecCollection
               collection: (
                (ComboListSpec
                   name: 'ComboList1'
                   layout: (LayoutFrame 0 0 0 0 0 1 25 0)
                   model: selectedDiagramProject
                   comboList: packageList
                   useIndex: false
                 )
                (SubCanvasSpec
                   name: 'SubCanvas1'
                   layout: (LayoutFrame 0 0 25 0 0 1 -25 1)
                   level: 0
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   minorKey: windowSpecForClassChooser
                   clientHolder: diagramApplicationModelHolder
                   createNewBuilder: false
                 )
                (SubCanvasSpec
                   name: 'MetaToggles2'
                   layout: (LayoutFrame 0 0.0 -25 1 0 1.0 0 1)
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   minorKey: metaSpec
                   createNewBuilder: false
                 )
                )
              
             )
           )
          (ViewSpec
             name: 'ClassHierarchyOrInheritanceBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             initiallyInvisible: true
             visibilityChannel: classHierarchyOrInheritanceShown
             component: 
            (SpecCollection
               collection: (
                (VariableVerticalPanelSpec
                   name: 'VariableVerticalPanel2'
                   layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                   showHandle: false
                   snapMode: both
                   handlePosition: left
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'HierarchyOrInheritanceBox'
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassHierarchyList'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                               visibilityChannel: classHierarchyShown
                               majorKey: HierarchicalClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: forceGeneratorTrigger
                                   aspect: forceClassInheritanceGeneratorTrigger
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classInheritanceListMenuHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: meta
                                   aspect: meta
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: outGeneratorHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolderForMethods
                                   aspect: selectorListGenerator5
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showClassPackages
                                   aspect: showClassPackages
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classHierarchyListSlaveMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: topClassHolder
                                   aspect: classHierarchyTopClass
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classHierarchyUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            (SubCanvasSpec
                               name: 'ClassInheritanceList'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                               visibilityChannel: classInheritanceShown
                               majorKey: InheritanceClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: forceGeneratorTrigger
                                   aspect: forceClassInheritanceGeneratorTrigger
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classInheritanceListMenuHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: meta
                                   aspect: meta
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: outGeneratorHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolderForMethods
                                   aspect: selectorListGenerator5
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showClassPackages
                                   aspect: showClassPackages
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classInheritanceListSlaveMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: topClassHolder
                                   aspect: classHierarchyTopClass
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classHierarchyUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                       )
                      (SubCanvasSpec
                         name: 'VariableList2'
                         majorKey: VariableList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: classHolder
                             aspect: selectedClasses
                           ) 
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: variableDoubleClickChannel
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: variablesMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedVariables
                             aspect: variableFilter
                           ) 
                          (SubChannelInfoSpec
                             subAspect: showClassVarsInVariableList
                             aspect: showClassVarsInVariableList
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: slaveMode
                             aspect: classHierarchyListSlaveMode
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      )
                    
                   )
                   handles: (Any 0.5 1.0)
                 )
                (SubCanvasSpec
                   name: 'MetaToggles1'
                   layout: (LayoutFrame 0 0.0 -25 1 0 1.0 0 1)
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   minorKey: metaSpec
                   createNewBuilder: false
                 )
                )
              
             )
           )
          (VariableHorizontalPanelSpec
             name: 'CategoryNameSpaceAndProjectPanel'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             visibilityChannel: categoryNameSpaceAndProjectPanelShown
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'LeftBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'ClassCategoryAndNamespaceFilterBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         visibilityChannel: categoryListShown
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassCategoryList'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                               majorKey: ClassCategoryList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classCategoryDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: forceGeneratorTrigger
                                   aspect: forceClassCategoryGeneratorTrigger
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classCategoryListMenuHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilterSelection
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: classGeneratorHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedCategories
                                   aspect: selectedCategories
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: categoryListSlaveMode
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classCategoryListUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            (ExtendedComboBoxSpec
                               name: 'NameSpaceFilterComboBox'
                               layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                               visibilityChannel: nameSpaceListWidgetVisibleHolder
                               tabable: true
                               model: nameSpaceFilterSelectedNameSpace
                               menuWidgetHolder: nameSpaceListWidgetHolder
                               miniScrollerHorizontal: true
                               menuSelector: nameSpaceFilterPopUpMenu
                             )
                            )
                          
                         )
                       )
                      (SubCanvasSpec
                         name: 'NamespaceList'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         initiallyInvisible: true
                         visibilityChannel: nameSpaceListShown
                         majorKey: NamespaceList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: nameSpaceDoubleClickChannel
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: forceGeneratorTrigger
                             aspect: forceNamespaceGeneratorTrigger
                           ) 
                          (SubChannelInfoSpec
                             subAspect: hideUnloadedClasses
                             aspect: hideUnloadedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: nameSpaceListMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classGeneratorHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedNamespaces
                             aspect: selectedNamespaces
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeCondition
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: slaveMode
                             aspect: nameSpaceListSlaveMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: updateTrigger
                             aspect: nameSpaceListUpdateTrigger
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'ProjectList'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         initiallyInvisible: true
                         visibilityChannel: projectListShown
                         majorKey: ProjectList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: projectDoubleClickChannel
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: forceGeneratorTrigger
                             aspect: forceProjectGeneratorTrigger
                           ) 
                          (SubChannelInfoSpec
                             subAspect: hideUnloadedClasses
                             aspect: hideUnloadedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: projectListMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classGeneratorHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedProjects
                             aspect: selectedProjects
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeCondition
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: slaveMode
                             aspect: projectListSlaveMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: updateTrigger
                             aspect: projectListUpdateTrigger
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      )
                    
                   )
                 )
                (ViewSpec
                   name: 'RightBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (VariableVerticalPanelSpec
                         name: 'ClassAndVariablesPanel'
                         layout: (LayoutFrame 0 0 0 0 0 1 -25 1)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               minorKey: windowSpec
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: classDoubleClickChannel
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: hidePrivateClasses
                                   aspect: hidePrivateClasses
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: inGeneratorHolder
                                   aspect: classGeneratorHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classListMenuHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: meta
                                   aspect: meta
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: nameSpaceFilter
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: outGeneratorHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolderForMethods
                                   aspect: selectorListGenerator5
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeCondition
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: showClassPackages
                                   aspect: showClassPackages
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classListSlaveMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: updateTrigger
                                   aspect: classListUpdateTrigger
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            (SubCanvasSpec
                               name: 'VariableList'
                               majorKey: VariableList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: classHolder
                                   aspect: selectedClasses
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   aspect: variableDoubleClickChannel
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesMenuHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectedVariables
                                   aspect: variableFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showClassVarsInVariableList
                                   aspect: showClassVarsInVariableList
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortVariablesByName
                                   aspect: sortVariablesByName
                                 ) 
                    (SubChannelInfoSpec
                       subAspect: groupVariablesByInheritance
                       aspect: groupVariablesByInheritance
                     )
                                (SubChannelInfoSpec
                                   subAspect: slaveMode
                                   aspect: classListSlaveMode
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggleSpec2'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          )
        
       )
     )
!

windowSpecWithoutMetaToggles
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::OrganizerCanvas andSelector:#windowSpecWithoutMetaToggles
     Tools::OrganizerCanvas new openInterface:#windowSpecWithoutMetaToggles
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpecWithoutMetaToggles
       window: 
      (WindowSpec
         label: 'Organizer'
         name: 'Organizer'
         min: (Point 0 0)
         max: (Point 1024 721)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (SubCanvasSpec
             name: 'ClassHierarchyList'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             visibilityChannel: classHierarchyShown
             majorKey: HierarchicalClassList
             minorKey: windowSpec
             subAspectHolders: 
            (Array
               
              (SubChannelInfoSpec
                 subAspect: doubleClickChannel
                 aspect: classDoubleClickChannel
               ) 
              (SubChannelInfoSpec
                 subAspect: environmentHolder
                 aspect: environmentHolder
               )
               
              (SubChannelInfoSpec
                 subAspect: forceGeneratorTrigger
                 aspect: forceClassInheritanceGeneratorTrigger
               ) 
              (SubChannelInfoSpec
                 subAspect: hideUnloadedClasses
                 aspect: hideUnloadedClasses
               )
               
              (SubChannelInfoSpec
                 subAspect: immediateUpdate
                 aspect: immediateUpdate
               ) 
              (SubChannelInfoSpec
                 subAspect: markApplicationsHolder
                 aspect: markApplicationsHolder
               )
               
              (SubChannelInfoSpec
                 subAspect: menuHolder
                 aspect: classInheritanceListMenuHolder
               ) 
              (SubChannelInfoSpec
                 subAspect: meta
                 aspect: meta
               )
               
              (SubChannelInfoSpec
                 subAspect: methodVisibilityHolder
                 aspect: methodVisibilityHolder
               ) 
              (SubChannelInfoSpec
                 subAspect: nameSpaceFilter
                 aspect: nameSpaceFilter
               )
               
              (SubChannelInfoSpec
                 subAspect: organizerMode
                 aspect: organizerMode
               ) 
              (SubChannelInfoSpec
                 subAspect: outGeneratorHolder
                 aspect: outGeneratorHolder
               )
               
              (SubChannelInfoSpec
                 subAspect: packageFilter
                 aspect: packageFilter
               ) 
              (SubChannelInfoSpec
                 subAspect: selectedClasses
                 aspect: selectedClasses
               )
               
              (SubChannelInfoSpec
                 subAspect: selectionChangeCondition
                 aspect: selectionChangeCondition
               ) 
              (SubChannelInfoSpec
                 subAspect: showClassPackages
                 aspect: showClassPackages
               )
               
              (SubChannelInfoSpec
                 subAspect: showCoverageInformation
                 aspect: showCoverageInformation
               ) 
              (SubChannelInfoSpec
                 subAspect: showMethodComplexity
                 aspect: showMethodComplexity
               )
               
              (SubChannelInfoSpec
                 subAspect: showMethodInheritance
                 aspect: showMethodInheritance
               ) 
              (SubChannelInfoSpec
                 subAspect: showMethodTypeIcon
                 aspect: showMethodTypeIcon
               )
               
              (SubChannelInfoSpec
                 subAspect: slaveMode
                 aspect: classInheritanceListSlaveMode
               ) 
              (SubChannelInfoSpec
                 subAspect: topClassHolder
                 aspect: classHierarchyTopClass
               )
               
              (SubChannelInfoSpec
                 subAspect: updateTrigger
                 aspect: classHierarchyUpdateTrigger
               )
             )
             createNewApplication: true
             createNewBuilder: true
           )
          (SubCanvasSpec
             name: 'ClassInheritanceList'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             visibilityChannel: classInheritanceShown
             majorKey: InheritanceClassList
             minorKey: windowSpec
             subAspectHolders: 
            (Array
               
              (SubChannelInfoSpec
                 subAspect: doubleClickChannel
                 aspect: classDoubleClickChannel
               ) 
              (SubChannelInfoSpec
                 subAspect: environmentHolder
                 aspect: environmentHolder
               )
               
              (SubChannelInfoSpec
                 subAspect: forceGeneratorTrigger
                 aspect: forceClassInheritanceGeneratorTrigger
               ) 
              (SubChannelInfoSpec
                 subAspect: hideUnloadedClasses
                 aspect: hideUnloadedClasses
               )
               
              (SubChannelInfoSpec
                 subAspect: immediateUpdate
                 aspect: immediateUpdate
               ) 
              (SubChannelInfoSpec
                 subAspect: markApplicationsHolder
                 aspect: markApplicationsHolder
               )
               
              (SubChannelInfoSpec
                 subAspect: menuHolder
                 aspect: classInheritanceListMenuHolder
               ) 
              (SubChannelInfoSpec
                 subAspect: meta
                 aspect: meta
               )
               
              (SubChannelInfoSpec
                 subAspect: nameSpaceFilter
                 aspect: nameSpaceFilter
               ) 
              (SubChannelInfoSpec
                 subAspect: organizerMode
                 aspect: organizerMode
               )
               
              (SubChannelInfoSpec
                 subAspect: outGeneratorHolder
                 aspect: outGeneratorHolder
               ) 
              (SubChannelInfoSpec
                 subAspect: packageFilter
                 aspect: packageFilter
               )
               
              (SubChannelInfoSpec
                 subAspect: selectedClasses
                 aspect: selectedClasses
               ) 
              (SubChannelInfoSpec
                 subAspect: selectionChangeCondition
                 aspect: selectionChangeCondition
               )
               
              (SubChannelInfoSpec
                 subAspect: showCoverageInformation
                 aspect: showCoverageInformation
               ) 
              (SubChannelInfoSpec
                 subAspect: slaveMode
                 aspect: classInheritanceListSlaveMode
               )
               
              (SubChannelInfoSpec
                 subAspect: topClassHolder
                 aspect: classHierarchyTopClass
               ) 
              (SubChannelInfoSpec
                 subAspect: updateTrigger
                 aspect: classHierarchyUpdateTrigger
               )
             )
             createNewApplication: true
             createNewBuilder: true
           )
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             visibilityChannel: classHierarchyNotShown
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (SubCanvasSpec
                         name: 'ClassCategoryList'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         visibilityChannel: categoryListShown
                         majorKey: ClassCategoryList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: classCategoryDoubleClickChannel
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: forceGeneratorTrigger
                             aspect: forceClassCategoryGeneratorTrigger
                           ) 
                          (SubChannelInfoSpec
                             subAspect: hideUnloadedClasses
                             aspect: hideUnloadedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: classCategoryListMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classGeneratorHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedCategories
                             aspect: selectedCategories
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeCondition
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: updateTrigger
                             aspect: classCategoryListUpdateTrigger
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'NamespaceList'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         visibilityChannel: nameSpaceListShown
                         majorKey: NamespaceList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: nameSpaceDoubleClickChannel
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: forceGeneratorTrigger
                             aspect: forceNamespaceGeneratorTrigger
                           ) 
                          (SubChannelInfoSpec
                             subAspect: hideUnloadedClasses
                             aspect: hideUnloadedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: nameSpaceListMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classGeneratorHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedNamespaces
                             aspect: selectedNamespaces
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeCondition
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: updateTrigger
                             aspect: nameSpaceListUpdateTrigger
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'ProjectList'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         visibilityChannel: projectListShown
                         majorKey: ProjectList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             aspect: projectDoubleClickChannel
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: forceGeneratorTrigger
                             aspect: forceProjectGeneratorTrigger
                           ) 
                          (SubChannelInfoSpec
                             subAspect: hideUnloadedClasses
                             aspect: hideUnloadedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: projectListMenuHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classGeneratorHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedProjects
                             aspect: selectedProjects
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeCondition
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showCoverageInformation
                             aspect: showCoverageInformation
                           ) 
                          (SubChannelInfoSpec
                             subAspect: updateTrigger
                             aspect: projectListUpdateTrigger
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'ClassList'
                   majorKey: ClassList
                   minorKey: windowSpec
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       aspect: classDoubleClickChannel
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: hidePrivateClasses
                       aspect: hidePrivateClasses
                     ) 
                    (SubChannelInfoSpec
                       subAspect: hideUnloadedClasses
                       aspect: hideUnloadedClasses
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     ) 
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: classGeneratorHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: markApplicationsHolder
                       aspect: markApplicationsHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: classListMenuHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: meta
                       aspect: meta
                     ) 
                    (SubChannelInfoSpec
                       subAspect: organizerMode
                       aspect: organizerMode
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: outGeneratorHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedClasses
                       aspect: selectedClasses
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeCondition
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: slaveMode
                       aspect: classListSlaveMode
                     ) 
                    (SubChannelInfoSpec
                       subAspect: sortByNameAndInheritance
                       aspect: sortByNameAndInheritance
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: updateTrigger
                       aspect: classListUpdateTrigger
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          )
        
       )
     )
! !

!OrganizerCanvas class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #(classCategoryDoubleClickChannel action)
        #classCategoryListMenuHolder
        #(classDoubleClickChannel action)
        #classHierarchyListMenuHolder
        #classHierarchyTopClass
        #classListMenuHolder
        #environmentHolder
        #filterClassVars
        #hidePrivateClasses
        #hideUnloadedClasses
        #immediateUpdate
        #markApplicationsHolder
        #meta
        #metaToggleLabelHolder
        #(nameSpaceDoubleClickChannel action)
        #nameSpaceFilter
        #nameSpaceListMenuHolder
        #organizerMode
        #outGeneratorHolder
        #packageFilter
        #(projectDoubleClickChannel action)
        #projectListMenuHolder
        #selectedCategories
        #selectedClasses
        #selectedNamespaces
        #selectedProjects
        #selectedProtocols
        #selectionChangeCondition
        #showClassPackages
        #showCoverageInformation
        #sortByNameAndInheritance
        #sortVariablesBy
        #(variableDoubleClickChannel action)
        #variableFilter
        #variablesMenuHolder
      ).

! !

!OrganizerCanvas methodsFor:'aspects'!

classCategoryDoubleClickChannel
    classCategoryDoubleClickChannel isNil ifTrue:[
        classCategoryDoubleClickChannel := TriggerValue new.
    ].
    ^ classCategoryDoubleClickChannel.
!

classCategoryListMenuHolder
    classCategoryListMenuHolder isNil ifTrue:[
        classCategoryListMenuHolder := ValueHolder new.
    ].
    ^ classCategoryListMenuHolder.

    "Created: / 18.2.2000 / 11:52:55 / cg"
!

classDoubleClickChannel
    classDoubleClickChannel isNil ifTrue:[
        classDoubleClickChannel := TriggerValue new.
    ].
    ^ classDoubleClickChannel.
!

classGeneratorHolder
    classGeneratorHolder isNil ifTrue:[
        classGeneratorHolder := ValueHolder new.
    ].
    ^ classGeneratorHolder.

    "Created: / 18.2.2000 / 00:56:50 / cg"
!

classGeneratorHolderFromClassCategory
    classGeneratorHolderFromClassCategory isNil ifTrue:[
        classGeneratorHolderFromClassCategory := ValueHolder new.
    ].
    ^ classGeneratorHolderFromClassCategory.

    "Created: / 18.2.2000 / 02:21:55 / cg"
!

classGeneratorHolderFromClassHierarchy
    classGeneratorHolderFromClassHierarchy isNil ifTrue:[
        classGeneratorHolderFromClassHierarchy := ValueHolder new.
    ].
    ^ classGeneratorHolderFromClassHierarchy.

    "Created: / 18.2.2000 / 02:21:55 / cg"
!

classGeneratorHolderFromNamespace
    classGeneratorHolderFromNamespace isNil ifTrue:[
        classGeneratorHolderFromNamespace := ValueHolder new.
    ].
    ^ classGeneratorHolderFromNamespace.

    "Created: / 18.2.2000 / 02:21:55 / cg"
!

classGeneratorHolderFromProject
    classGeneratorHolderFromProject isNil ifTrue:[
        classGeneratorHolderFromProject := ValueHolder new.
    ].
    ^ classGeneratorHolderFromProject.

    "Created: / 18.2.2000 / 02:21:55 / cg"
!

classHierarchyListMenuHolder
    classHierarchyListMenuHolder isNil ifTrue:[
        classHierarchyListMenuHolder := ValueHolder new.
    ].
    ^ classHierarchyListMenuHolder.

    "Created: / 18.2.2000 / 11:52:55 / cg"
!

classHierarchyTopClass
    ^ builder valueAspectFor:#classHierarchyTopClass initialValue:Object
!

classInheritanceListMenuHolder
    ^ self classHierarchyListMenuHolder
!

classList
    classList isNil ifTrue:[
        classList := ValueHolder new.
    ].
    ^ classList.

    "Created: / 18.2.2000 / 00:23:43 / cg"
!

classListMenuHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    classListMenuHolder isNil ifTrue:[
	classListMenuHolder := ValueHolder new.
"/        classListMenuHolder addDependent:self.
    ].
    ^ classListMenuHolder.

    "Created: / 18.2.2000 / 11:57:22 / cg"
!

defaultOrganizerMode
    ^ OrganizerCanvas organizerModePackageDiagram.
    ^ OrganizerCanvas organizerModeCategory
!

diagramPackageSelection
    |holder|

    (holder := builder bindingAt:#diagramPackageSelection) isNil ifTrue:[
        holder := ValueHolder with:nil.
        builder aspectAt:#diagramPackageSelection put:holder.
        holder onChangeSend:#diagramPackageSelectionChanged to:self.
    ].
    ^ holder.
!

filterClassVars
    filterClassVars isNil ifTrue:[
        filterClassVars := ValueHolder new.
"/        filterClassVars addDependent:self.
    ].
    ^ filterClassVars.

    "Created: / 24-02-2000 / 23:29:52 / cg"
!

groupVariablesByInheritance
    groupVariablesByInheritance isNil ifTrue:[
        groupVariablesByInheritance := ValueHolder with:true.
    ].
    ^ groupVariablesByInheritance.
!

hidePrivateClasses
    hidePrivateClasses isNil ifTrue:[
        hidePrivateClasses := ValueHolder with:false.
"/        hidePrivateClasses addDependent:self.
    ].
    ^ hidePrivateClasses.

    "Created: / 24-02-2000 / 16:18:45 / cg"
!

hideUnloadedClasses
    hideUnloadedClasses isNil ifTrue:[
        hideUnloadedClasses := ValueHolder with:false.
"/        hideUnloadedClasses addDependent:self.
    ].
    ^ hideUnloadedClasses.

    "Created: / 18-02-2000 / 17:54:57 / cg"
!

immediateUpdate
    immediateUpdate isNil ifTrue:[
        immediateUpdate := ValueHolder with:false.
"/        immediateUpdate addDependent:self.
    ].
    ^ immediateUpdate.

    "Created: / 18-02-2000 / 00:23:43 / cg"
!

initialOrganizerMode
    ^ nil  "/ dummy
!

markApplicationsHolder
    markApplicationsHolder isNil ifTrue:[
        markApplicationsHolder := ValueHolder with:false.
    ].
    ^ markApplicationsHolder.
!

meta
    meta isNil ifTrue:[
        meta := ValueHolder with:false.
"/        meta addDependent:self.
    ].
    ^ meta.

    "Created: / 18-02-2000 / 00:23:43 / cg"
    "Modified (comment): / 04-07-2011 / 18:52:49 / cg"
!

metaToggle
    metaToggle isNil ifTrue:[
	metaToggle := PluggableAdaptor on:(self meta).
	metaToggle
	    getBlock:[:m | m value == true]
	    putBlock:[:m :newValue | m value:(newValue ? false)]
	    updateBlock:[:m :aspect :param | true].
    ].
    ^ metaToggle
!

metaToggleLabelHolder
    "this is changed from 'Instance/Class' to 'Instance/Static' for Java"

    metaToggleLabelHolder isNil ifTrue:[
        metaToggleLabelHolder := ValueHolder with:(resources string:'Class').
"/        metaToggleLabelHolder addDependent:self.
    ].
    ^ metaToggleLabelHolder.

    "Created: / 18-02-2000 / 11:52:55 / cg"
!

methodVisibilityHolder
    masterApplication notNil ifTrue:[
        ^ masterApplication methodVisibilityHolder
    ].

    methodVisibilityHolder isNil ifTrue:[
        methodVisibilityHolder := ValueHolder with:false.
    ].
    ^ methodVisibilityHolder.

    "Created: / 05-11-2007 / 16:57:58 / cg"
!

nameSpaceDoubleClickChannel
    |holder|

    (holder := builder bindingAt:#nameSpaceDoubleClickChannel) isNil ifTrue:[
        holder := TriggerValue new.
        builder aspectAt:#nameSpaceDoubleClickChannel put:holder.
"/        holder addDependent:self.
    ].
    ^ holder.

    "Modified (comment): / 04-07-2011 / 18:53:36 / cg"
!

nameSpaceFilter
    nameSpaceFilter isNil ifTrue:[
        nameSpaceFilter := ValueHolder new.
        nameSpaceFilter onChangeEvaluate:[
            nameSpaceFilter value ~= nameSpaceFilterSelection value ifTrue:[
                self halt:'should not happen'
            ].
"/            self nameSpaceFilter value: nameSpaceFilterSelection value.
        ]
    ].
    ^ nameSpaceFilter.

    "Created: / 24.2.2000 / 23:29:52 / cg"
!

nameSpaceFilterDoubleClickChannel
    |holder|

    (holder := builder bindingAt:#nameSpaceFilterDoubleClickChannel) isNil ifTrue:[
        holder := TriggerValue new.
        builder aspectAt:#nameSpaceFilterDoubleClickChannel put:holder.
        holder onChangeEvaluate:[
                    (builder componentAt:#NameSpaceFilterComboBox) closeMenu.
"/                    self nameSpaceDoubleClickChannel value:true.
               ]
    ].
    ^ holder.

    "Modified (comment): / 04-07-2011 / 18:53:39 / cg"
!

nameSpaceFilterPopUpMenu
    ^ self nameSpaceListMenuHolder.
!

nameSpaceFilterSelectedNameSpace
    |holder|

    (holder := builder bindingAt:#nameSpaceFilterSelectedNameSpace) isNil ifTrue:[
	holder := self class nameListEntryForALL "'* all *'" asValue.
	builder aspectAt:#nameSpaceFilterSelectedNameSpace put:holder.
	holder onChangeEvaluate:[ self updateNameSpaceLabel. ].
    ].
    ^ holder.

    "Created: / 18.2.2000 / 11:52:55 / cg"
!

nameSpaceFilterSelection
    "automatically generated by UIPainter ..."

    nameSpaceFilterSelection isNil ifTrue:[
	nameSpaceFilterSelection := (OrderedCollection with:self class nameListEntryForALL) asValue.
	nameSpaceFilterSelection addDependent:self.
    ].
    ^ nameSpaceFilterSelection.
!

nameSpaceListMenuHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#nameSpaceListMenuHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#nameSpaceListMenuHolder put:holder.
    ].
    ^ holder.

    "Created: / 18.2.2000 / 11:52:55 / cg"
!

nameSpaceListWidget
    |view|

    view := SubCanvas new.
    view client:self spec:#embeddedNameSpaceListSpec builder:nil. "/ (self builder).
    (view builder findComponentAt:#List) autoHideHorizontalScrollBar:true.
    ^ view.
!

nameSpaceListWidgetHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#nameSpaceListWidgetHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#nameSpaceListWidgetHolder put:holder.
        holder value:(self nameSpaceListWidget).
    ].
    ^ holder.
!

notMetaToggle
    notMetaToggle isNil ifTrue:[
	notMetaToggle := PluggableAdaptor on:(self meta).
	notMetaToggle
	    getBlock:[:m | m value == false]
	    putBlock:[:m :newValue | m value:(newValue ? false) not]
	    updateBlock:[:m :aspect :param | true].
    ].
    ^ notMetaToggle
!

organizerMode
    organizerMode isNil ifTrue:[
        organizerMode := self defaultOrganizerMode asValue.
        organizerMode addDependent:self.
    ].
    ^ organizerMode

    "Created: / 18.2.2000 / 00:30:44 / cg"
    "Modified: / 18.2.2000 / 02:56:21 / cg"
!

outGeneratorHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#outGeneratorHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#outGeneratorHolder put:holder.
    ].
    ^ holder.

    "Created: / 18.2.2000 / 00:23:43 / cg"
!

packageFilter
    "automatically generated by UIPainter ..."

    packageFilter isNil ifTrue:[
        packageFilter := ValueHolder new.
        "/ packageFilter addDependent:self.
    ].
    ^ packageFilter.

    "Created: / 24.2.2000 / 23:29:52 / cg"
!

packageList
    |holder|

    (holder := builder bindingAt:#packageList) isNil ifTrue:[
        holder := ValueHolder with:(ProjectList new listOfProjects).
        builder aspectAt:#packageList put:holder.
    ].
    ^ holder.
!

popUpNameSpaceListSlaveMode
    ^ false
!

projectDoubleClickChannel
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#projectDoubleClickChannel) isNil ifTrue:[
        holder := TriggerValue new.
        builder aspectAt:#projectDoubleClickChannel put:holder.
    ].
    ^ holder.
!

projectListMenuHolder
    "automatically generated by UIPainter ..."

    projectListMenuHolder isNil ifTrue:[
        projectListMenuHolder := ValueHolder new.
    ].
    ^ projectListMenuHolder.

    "Created: / 18.2.2000 / 11:52:55 / cg"
!

selectedCategories
    "automatically generated by UIPainter ..."

    selectedCategories isNil ifTrue:[
        selectedCategories := ValueHolder new.
    ].
    ^ selectedCategories.

    "Created: / 18.2.2000 / 12:27:58 / cg"
!

selectedClasses
    "bad name- it's a holder, baby"

    selectedClasses isNil ifTrue:[
        selectedClasses := ValueHolder new.
        selectedClasses addDependent:self.
    ].
    ^ selectedClasses.

    "Created: / 18.2.2000 / 00:23:43 / cg"
!

selectedDiagramProject
    |holder|

    (holder := builder bindingAt:#selectedDiagramProject) isNil ifTrue:[
        holder := ValueHolder with:nil.
        builder aspectAt:#selectedDiagramProject put:holder.
        holder addDependent:self.
    ].
    ^ holder.
!

selectedNamespaces
    selectedNamespaces isNil ifTrue:[
        selectedNamespaces := (OrderedCollection with:self class nameListEntryForALL) asValue.
    ].
    ^ selectedNamespaces.

    "Created: / 18.2.2000 / 12:27:58 / cg"
!

selectedProjects
    selectedProjects isNil ifTrue:[
        selectedProjects := ValueHolder new.
        selectedProjects addDependent:self.
    ].
    ^ selectedProjects.

    "Created: / 18.2.2000 / 12:16:01 / cg"
!

selectionChangeCondition

    selectionChangeCondition isNil ifTrue:[
        selectionChangeCondition := ValueHolder new.
"/        selectionChangeCondition addDependent:self.
    ].
    ^ selectionChangeCondition.

    "Created: / 18.2.2000 / 00:23:43 / cg"
!

showAllClassesInNameSpaceOrganisation
    masterApplication notNil ifTrue:[
        ^ masterApplication showAllClassesInNameSpaceOrganisation
    ].

    showAllClassesInNameSpaceView isNil ifTrue:[
        showAllClassesInNameSpaceView := ValueHolder with:false.
    ].
    ^ showAllClassesInNameSpaceView.

    "Created: / 05-03-2007 / 16:52:02 / cg"
    "Modified: / 06-03-2007 / 12:30:17 / cg"
!

showClassPackages
    showClassPackages isNil ifTrue:[
        showClassPackages := ValueHolder with:false.
    ].
    ^ showClassPackages.

    "Created: / 18.2.2000 / 17:54:57 / cg"
!

showCoverageInformation
    masterApplication notNil ifTrue:[
        ^ masterApplication showCoverageInformation
    ].

    showCoverageInformation isNil ifTrue:[
        showCoverageInformation := ValueHolder with:false.
    ].
    ^ showCoverageInformation.

    "Created: / 27-04-2010 / 16:32:56 / cg"
!

showMethodComplexity
    masterApplication notNil ifTrue:[
        ^ masterApplication showMethodComplexity
    ].

    showMethodComplexity isNil ifTrue:[
        showMethodComplexity := ValueHolder with:false.
    ].
    ^ showMethodComplexity.

    "Created: / 05-11-2007 / 16:56:36 / cg"
!

showMethodInheritance
    masterApplication notNil ifTrue:[
        ^ masterApplication showMethodInheritance
    ].

    showMethodInheritance isNil ifTrue:[
        showMethodInheritance := ValueHolder with:false.
    ].
    ^ showMethodInheritance.

    "Created: / 05-11-2007 / 16:55:35 / cg"
!

showMethodTypeIcon
    masterApplication notNil ifTrue:[
        ^ masterApplication showMethodTypeIcon
    ].

    showMethodTypeIcon isNil ifTrue:[
        showMethodTypeIcon := ValueHolder with:false.
    ].
    ^ showMethodTypeIcon.

    "Created: / 05-11-2007 / 16:57:12 / cg"
!

sortByNameAndInheritance
    sortByNameAndInheritance isNil ifTrue:[
        sortByNameAndInheritance := ValueHolder with:false.
"/        sortByNameAndInheritance addDependent:self.
    ].
    ^ sortByNameAndInheritance.

    "Created: / 04-07-2011 / 18:41:22 / cg"
!

sortVariablesByName
    sortVariablesByName isNil ifTrue:[
        sortVariablesByName := ValueHolder with:false.
    ].
    ^ sortVariablesByName.
!

updateNameSpaceLabel
    |box|

    box := self componentAt:#NameSpaceFilterComboBox.
    box notNil ifTrue:[
        "/ new code: ExtComboBox uses always an EditField
        box editor contents:nameSpaceFilterSelection value first.        

        "/ old code: readOnly ExtComboBox used a Label
        "/ box menuField label:nameSpaceFilterSelection value first
    ]
!

variableDoubleClickChannel
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#variableDoubleClickChannel) isNil ifTrue:[
        holder := TriggerValue new.
        builder aspectAt:#variableDoubleClickChannel put:holder.
    ].
    ^ holder.
!

variableFilter
    variableFilter isNil ifTrue:[
        variableFilter := ValueHolder new.
    ].
    ^ variableFilter.

    "Created: / 24.2.2000 / 23:29:52 / cg"
!

variablesMenuHolder
    "automatically generated by UIPainter ..."

    variablesMenuHolder isNil ifTrue:[
        variablesMenuHolder := ValueHolder new.
    ].
    ^ variablesMenuHolder.

    "Created: / 24.2.2000 / 23:29:52 / cg"
! !

!OrganizerCanvas methodsFor:'aspects-exported'!

classCategoryDoubleClickChannel:aValueHolder
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    classCategoryDoubleClickChannel := aValueHolder.

    "Created: / 18.8.2000 / 20:04:48 / cg"
!

classCategoryListMenuHolder:aValueHolder
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    classCategoryListMenuHolder := aValueHolder.

    "Created: / 18.2.2000 / 11:53:31 / cg"
!

classCategoryListUpdateTrigger:aValueHolder
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    classCategoryListUpdateTrigger := aValueHolder.

    ^ self.

    "Created: / 18.2.2000 / 02:08:01 / cg"
!

classDoubleClickChannel:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ classDoubleClickChannel removeDependent:self.

    classDoubleClickChannel := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.
!

classHierarchyListMenuHolder:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ classHierarchyListMenuHolder removeDependent:self.

    classHierarchyListMenuHolder := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 11:53:31 / cg"
!

classHierarchyShown:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ |holder|

    "/ (holder := builder bindingAt:#classHierarchyShown) notNil ifTrue:[
    "/     holder removeDependent:self.
    "/ ].
    builder aspectAt:#classHierarchyShown put:something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 00:24:28 / cg"
!

classHierarchyTopClass:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ |holder|

    "/ (holder := builder bindingAt:#classHierarchyTopClass) notNil ifTrue:[
    "/     holder removeDependent:self.
    "/ ].
    builder aspectAt:#classHierarchyTopClass put:something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.
!

classHierarchyUpdateTrigger:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ |holder|

    "/ (holder := builder bindingAt:#classHierarchyUpdateTrigger) notNil ifTrue:[
    "/     holder removeDependent:self.
    "/ ].
    builder aspectAt:#classHierarchyUpdateTrigger put:something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 02:08:01 / cg"
!

classList:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ classList notNil ifTrue:[
    "/     classList removeDependent:self.
    "/ ].
    classList := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 00:24:28 / cg"
!

classListMenuHolder:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ classListMenuHolder removeDependent:self.

    classListMenuHolder := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 11:57:22 / cg"
!

classListUpdateTrigger:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ classListUpdateTrigger removeDependent:self.

    classListUpdateTrigger := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 02:08:01 / cg"
!

filterClassVars:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ filterClassVars removeDependent:self.

    filterClassVars := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 24.2.2000 / 23:46:16 / cg"
!

groupVariablesByInheritance:aValueHolder
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    groupVariablesByInheritance := aValueHolder.
!

hidePrivateClasses:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ hidePrivateClasses removeDependent:self.

    hidePrivateClasses := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 24.2.2000 / 16:18:32 / cg"
!

hideUnloadedClasses:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ hideUnloadedClasses removeDependent:self.

    hideUnloadedClasses := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 17:54:57 / cg"
!

immediateUpdate:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ immediateUpdate removeDependent:self.

    immediateUpdate := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 00:24:29 / cg"
!

markApplicationsHolder:something
    markApplicationsHolder := something.
!

meta:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ meta notNil ifTrue:[
    "/     meta removeDependent:self.
    "/ ].
"/ (something == true or:[something == false]) ifTrue:[self halt].
    meta := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    metaToggle notNil ifTrue:[
	metaToggle model:something
    ].
    notMetaToggle notNil ifTrue:[
	notMetaToggle model:something
    ].
    ^ self.

    "Created: / 18.2.2000 / 00:24:29 / cg"
!

metaToggleLabelHolder:something
    |v|

    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ metaToggleLabelHolder removeDependent:self.

    metaToggleLabelHolder := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    (v := builder componentAt:#ClassToggle) notNil ifTrue:[
	v labelChannel:metaToggleLabelHolder.
    ].
    ^ self.

    "Created: / 18.2.2000 / 11:53:31 / cg"
!

methodVisibilityHolder:aValueHolder
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    methodVisibilityHolder := aValueHolder.

    "Created: / 05-11-2007 / 16:57:34 / cg"
!

nameSpaceFilter:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ packageFilter notNil ifTrue:[
    "/     packageFilter removeDependent:self.
    "/ ].
    nameSpaceFilter := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    self nameSpaceFilterSelection value:something value.
    ^ self.

    "Created: / 24.2.2000 / 23:46:16 / cg"
!

nameSpaceListMenuHolder:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ |holder|

    "/ (holder := builder bindingAt:#namespaceListMenuHolder) notNil ifTrue:[
    "/     holder removeDependent:self.
    "/ ].
    builder aspectAt:#nameSpaceListMenuHolder put:something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 11:53:31 / cg"
!

nameSpaceListUpdateTrigger:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ |holder|

    "/ (holder := builder bindingAt:#namespaceListUpdateTrigger) notNil ifTrue:[
    "/     holder removeDependent:self.
    "/ ].
    builder aspectAt:#nameSpaceListUpdateTrigger put:something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 02:08:01 / cg"
!

organizerMode:aValueHolder
    organizerMode notNil ifTrue:[
	organizerMode removeDependent:self.
    ].
    organizerMode := aValueHolder.
    organizerMode notNil ifTrue:[
	organizerMode addDependent:self.
    ].

    "Created: / 18.2.2000 / 10:21:41 / cg"
!

outGeneratorHolder:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ |holder|

    "/ (holder := builder bindingAt:#outGeneratorHolder) notNil ifTrue:[
    "/     holder removeDependent:self.
    "/ ].
    builder aspectAt:#outGeneratorHolder put:something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 00:24:29 / cg"
!

packageFilter:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ packageFilter notNil ifTrue:[
    "/     packageFilter removeDependent:self.
    "/ ].
    packageFilter := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 24.2.2000 / 23:46:16 / cg"
!

projectDoubleClickChannel:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ |holder|

    "/ (holder := builder bindingAt:#projectDoubleClickChannel) notNil ifTrue:[
    "/     holder removeDependent:self.
    "/ ].
    builder aspectAt:#projectDoubleClickChannel put:something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.
!

projectListMenuHolder:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    projectListMenuHolder := something.

    "Created: / 18.2.2000 / 11:53:31 / cg"
!

projectListUpdateTrigger:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ |holder|

    "/ (holder := builder bindingAt:#projectListUpdateTrigger) notNil ifTrue:[
    "/     holder removeDependent:self.
    "/ ].
    builder aspectAt:#projectListUpdateTrigger put:something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.

    "Created: / 18.2.2000 / 02:08:01 / cg"
!

selectedCategories:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    selectedCategories := something.
    ^ self.

    "Created: / 18.2.2000 / 14:04:36 / cg"
!

selectedClasses:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    selectedClasses removeDependent:self.

    selectedClasses := something.
    something notNil ifTrue:[
	something addDependent:self.
    ].
    ^ self.

    "Created: / 18.2.2000 / 00:24:29 / cg"
!

selectedNamespaces:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    selectedNamespaces := something.
    selectedNamespaces onChangeEvaluate:[
        nameSpaceFilterSelection notNil ifTrue:[
            nameSpaceFilterSelection value:selectedNamespaces value.     
        ]
    ].

    "Modified: / 05-11-2007 / 17:16:56 / cg"
!

selectedProjects:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    selectedProjects := something.
!

selectionChangeCondition:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    selectionChangeCondition := something.
!

showClassPackages:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    showClassPackages := something.
!

showCoverageInformation:something

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    showCoverageInformation := something.

    "Created: / 06-07-2011 / 19:48:20 / cg"
!

showMethodComplexity:aValueHolder
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    showMethodComplexity := aValueHolder.

    "Created: / 05-11-2007 / 16:56:18 / cg"
!

showMethodInheritance:aValueHolder
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    showMethodInheritance := aValueHolder.

    "Created: / 05-11-2007 / 16:55:12 / cg"
!

showMethodTypeIcon:aValueHolder
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    showMethodTypeIcon := aValueHolder.

    "Created: / 05-11-2007 / 16:57:02 / cg"
!

sortByNameAndInheritance:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ sortByNameAndInheritance removeDependent:self.

    sortByNameAndInheritance := something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].

    "Created: / 04-07-2011 / 18:42:01 / cg"
!

sortVariablesByName:aValueHolder
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    sortVariablesByName := aValueHolder.
!

variableDoubleClickChannel:aValueHolder
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    builder aspectAt:#variableDoubleClickChannel put:aValueHolder.
!

variableFilter:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    variableFilter := something.
!

variablesMenuHolder:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    variablesMenuHolder := something.
! !

!OrganizerCanvas methodsFor:'aspects-private'!

categoryListSlaveMode
    categoryListSlaveMode isNil ifTrue:[
        categoryListSlaveMode := ValueHolder with:false.
    ].
    ^ categoryListSlaveMode

    "Created: / 18.2.2000 / 00:30:44 / cg"
    "Modified: / 18.2.2000 / 02:56:21 / cg"
!

classHierarchyListSlaveMode
    classHierarchyListSlaveMode isNil ifTrue:[
        classHierarchyListSlaveMode := ValueHolder with:true.
    ].
    ^ classHierarchyListSlaveMode

    "Created: / 18.2.2000 / 00:30:44 / cg"
    "Modified: / 18.2.2000 / 02:56:21 / cg"
!

classInheritanceListSlaveMode
    classInheritanceListSlaveMode isNil ifTrue:[
        classInheritanceListSlaveMode := ValueHolder with:true.
    ].
    ^ classInheritanceListSlaveMode

    "Modified: / 18.2.2000 / 02:56:21 / cg"
    "Created: / 26.2.2000 / 00:09:18 / cg"
!

classListSlaveMode
    classListSlaveMode isNil ifTrue:[
        classListSlaveMode := ValueHolder with:false.
    ].
    ^ classListSlaveMode

    "Created: / 18.2.2000 / 00:30:44 / cg"
    "Modified: / 18.2.2000 / 02:56:21 / cg"
!

nameSpaceListSlaveMode
    namespaceListSlaveMode isNil ifTrue:[
        namespaceListSlaveMode := ValueHolder with:true.
    ].
    ^ namespaceListSlaveMode

    "Created: / 18.2.2000 / 00:30:44 / cg"
    "Modified: / 18.2.2000 / 02:56:21 / cg"
!

projectListSlaveMode
    projectListSlaveMode isNil ifTrue:[
        projectListSlaveMode := ValueHolder with:true.
    ].
    ^ projectListSlaveMode

    "Created: / 18.2.2000 / 00:30:44 / cg"
    "Modified: / 18.2.2000 / 02:56:21 / cg"
! !

!OrganizerCanvas methodsFor:'aspects-trigger'!

classCategoryListUpdateTrigger
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    classCategoryListUpdateTrigger isNil ifTrue:[
	classCategoryListUpdateTrigger := TriggerValue new.
"/        classCategoryListUpdateTrigger addDependent:self.
    ].
    ^ classCategoryListUpdateTrigger.

    "Created: / 18.2.2000 / 02:05:14 / cg"
    "Modified: / 18.2.2000 / 02:14:04 / cg"
!

classHierarchyUpdateTrigger
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#classHierarchyUpdateTrigger) isNil ifTrue:[
	holder := TriggerValue new.
	builder aspectAt:#classHierarchyUpdateTrigger put:holder.
"/        holder addDependent:self.
    ].
    ^ holder.

    "Created: / 18.2.2000 / 02:05:14 / cg"
    "Modified: / 18.2.2000 / 02:13:57 / cg"
!

classListUpdateTrigger
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    classListUpdateTrigger isNil ifTrue:[
	classListUpdateTrigger := TriggerValue new.
"/        classListUpdateTrigger addDependent:self.
    ].
    ^ classListUpdateTrigger.

    "Created: / 18.2.2000 / 02:05:14 / cg"
    "Modified: / 18.2.2000 / 02:14:08 / cg"
!

forceClassCategoryGeneratorTrigger
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#forceClassCategoryGeneratorTrigger) isNil ifTrue:[
	holder := TriggerValue new.
	builder aspectAt:#forceClassCategoryGeneratorTrigger put:holder.
"/        holder addDependent:self.
    ].
    ^ holder.

    "Created: / 18.2.2000 / 02:49:43 / cg"
    "Modified: / 18.2.2000 / 02:52:30 / cg"
!

forceClassHierarchyGeneratorTrigger
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#forceClassHierarchyGeneratorTrigger) isNil ifTrue:[
	holder := TriggerValue new.
	builder aspectAt:#forceClassHierarchyGeneratorTrigger put:holder.
"/        holder addDependent:self.
    ].
    ^ holder.

    "Created: / 18.2.2000 / 02:49:43 / cg"
    "Modified: / 18.2.2000 / 02:52:32 / cg"
!

forceNamespaceGeneratorTrigger
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#forceNamespaceGeneratorTrigger) isNil ifTrue:[
	holder := TriggerValue new.
	builder aspectAt:#forceNamespaceGeneratorTrigger put:holder.
"/        holder addDependent:self.
    ].
    ^ holder.

    "Created: / 18.2.2000 / 02:49:43 / cg"
    "Modified: / 18.2.2000 / 02:52:35 / cg"
!

forceProjectGeneratorTrigger
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#forceProjectGeneratorTrigger) isNil ifTrue:[
	holder := TriggerValue new.
	builder aspectAt:#forceProjectGeneratorTrigger put:holder.
"/        holder addDependent:self.
    ].
    ^ holder.

    "Created: / 18.2.2000 / 02:49:43 / cg"
    "Modified: / 18.2.2000 / 02:52:38 / cg"
!

nameSpaceListUpdateTrigger
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#nameSpaceListUpdateTrigger) isNil ifTrue:[
        holder := TriggerValue new.
        builder aspectAt:#nameSpaceListUpdateTrigger put:holder.
    ].
    ^ holder.

    "Created: / 18.2.2000 / 02:05:14 / cg"
    "Modified: / 18.2.2000 / 02:14:12 / cg"
!

projectListUpdateTrigger
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#projectListUpdateTrigger) isNil ifTrue:[
        holder := TriggerValue new.
        builder aspectAt:#projectListUpdateTrigger put:holder.
    ].
    ^ holder.

    "Created: / 18.2.2000 / 02:05:14 / cg"
    "Modified: / 18.2.2000 / 02:14:15 / cg"
! !

!OrganizerCanvas methodsFor:'aspects-visibility'!

categoryListShown
    categoryListShown isNil ifTrue:[
        categoryListShown := BlockValue 
                        with:[:v | v == OrganizerCanvas organizerModeCategory]
                        argument:(self organizerMode).
    ].
    ^ categoryListShown

    "Modified: / 08-03-2007 / 23:01:48 / cg"
!

categoryNameSpaceAndProjectPanelShown
    |holder|

    (holder := builder bindingAt:#categoryNameSpaceAndProjectPanelShown) isNil ifTrue:[
        holder := BlockValue 
                        with:[:v1 :v2 :v3 | (v1 or:[v2 or:[v3]]) not]
                        argument:(self classHierarchyShown)
                        argument:(self classInheritanceShown)
                        argument:(self packageDiagramShown).
        builder aspectAt:#categoryNameSpaceAndProjectPanelShown put: holder
    ].
    ^ holder

    "Modified: / 08-03-2007 / 23:01:57 / cg"
!

classHierarchyNotShown
    |holder|

    (holder := builder bindingAt:#classHierarchyNotShown) isNil ifTrue:[
        holder := BlockValue 
                        with:[:v | |org|
                                   org := v.
                                   org ~~ OrganizerCanvas organizerModeHierarchy
                                   and:[org ~~ OrganizerCanvas organizerModeClassHierarchy
                                   and:[org ~~ OrganizerCanvas organizerModeClassInheritance]]]
                        argument:(self organizerMode).
        builder aspectAt:#classHierarchyNotShown put: holder
    ].
    ^ holder

    "Created: / 18-02-2000 / 00:36:38 / cg"
    "Modified: / 08-03-2007 / 23:01:51 / cg"
!

classHierarchyOrInheritanceNotShown
    <resource: #obsolete>

    |holder|

    (holder := builder bindingAt:#classHierarchyOrInheritanceNotShown) isNil ifTrue:[
        holder := BlockValue 
                        with:[:v1 :v2 | (v1 or:[v2]) not]
                        argument:(self classHierarchyShown)
                        argument:(self classInheritanceShown).
        builder aspectAt:#classHierarchyOrInheritanceNotShown put: holder
    ].
    ^ holder

    "Modified: / 08-03-2007 / 23:01:57 / cg"
!

classHierarchyOrInheritanceShown
    |holder|

    (holder := builder bindingAt:#classHierarchyOrInheritanceShown) isNil ifTrue:[
        holder := BlockValue 
                        with:[:v1 :v2 | v1 or:[v2] ]
                        argument:(self classHierarchyShown)
                        argument:(self classInheritanceShown).
        builder aspectAt:#classHierarchyOrInheritanceShown put: holder
    ].
    ^ holder

    "Modified: / 08-03-2007 / 23:02:03 / cg"
!

classHierarchyShown
    |holder|

    (holder := builder bindingAt:#classHierarchyShown) isNil ifTrue:[
        holder := BlockValue 
                        with:[:v | |org|
                                   org := v.
                                   org == OrganizerCanvas organizerModeHierarchy
                                   or:[org == OrganizerCanvas organizerModeClassHierarchy]]
                        argument:(self organizerMode).
        builder aspectAt:#classHierarchyShown put: holder
    ].
    ^ holder

    "Modified: / 08-03-2007 / 23:02:07 / cg"
!

classInheritanceShown
    |holder|

    (holder := builder bindingAt:#classInheritanceShown) isNil ifTrue:[
        holder := BlockValue 
                        with:[:v | v == OrganizerCanvas organizerModeClassInheritance]
                        argument:(self organizerMode).
        builder aspectAt:#classInheritanceShown put: holder
    ].
    ^ holder

    "Created: / 24-02-2000 / 13:23:01 / cg"
    "Modified: / 08-03-2007 / 23:02:09 / cg"
!

classListShown
    |holder|

    (holder := builder bindingAt:#classListShown) isNil ifTrue:[
        holder := BlockValue 
                        with:[:v | v ~~ OrganizerCanvas organizerModeHierarchy]
                        argument:(self organizerMode).
        builder aspectAt:#classListShown put: holder
    ].
    ^ holder

    "Modified: / 08-03-2007 / 23:02:12 / cg"
!

nameSpaceListShown
    |holder|

    (holder := builder bindingAt:#nameSpaceListShown) isNil ifTrue:[
        holder := BlockValue 
                        with:[:v | v == OrganizerCanvas organizerModeNamespace]
                        argument:(self organizerMode).
        builder aspectAt:#nameSpaceListShown put: holder
    ].
    ^ holder

    "Created: / 18-02-2000 / 00:32:09 / cg"
    "Modified: / 08-03-2007 / 23:02:15 / cg"
!

nameSpaceListWidgetVisibleHolder
    |holder|

    (holder := builder bindingAt:#nameSpaceListWidgetVisibleHolder) isNil ifTrue:[
        holder := BlockValue 
                        with:[:env | env hasNameSpaces ]
                        argument:(self environmentHolder).
        builder aspectAt:#nameSpaceListWidgetVisibleHolder put: holder
    ].
    ^ holder

    "Modified: / 03-03-2015 / 11:24:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageDiagramShown
    |holder|

    (holder := builder bindingAt:#packageDiagramShown) isNil ifTrue:[
        holder := BlockValue 
                        with:[:v | |org|
                                   org := v.
                                   org == OrganizerCanvas organizerModePackageDiagram]
                        argument:(self organizerMode).
        builder aspectAt:#packageDiagramShown put: holder
    ].
    ^ holder

    "Modified: / 08-03-2007 / 23:02:07 / cg"
!

projectListShown
    |holder|

    (holder := builder bindingAt:#projectListShown) isNil ifTrue:[
        holder := BlockValue 
                        with:[:v | v == OrganizerCanvas organizerModeProject]
                        argument:(self organizerMode).
        builder aspectAt:#projectListShown put: holder
    ].
    ^ holder

    "Created: / 18-02-2000 / 00:32:09 / cg"
    "Modified: / 08-03-2007 / 23:02:18 / cg"
! !

!OrganizerCanvas methodsFor:'change & update'!

diagramClassSelectionChanged
    |graphApp classes|

    graphApp := self diagramApplicationModelHolder value.

    classes := graphApp selectedClassesHolder value.
    self classGeneratorHolder value:classes.
    self classList value:classes.
    self selectedClasses value:classes.

"/    self outGeneratorHolder value:classes.
!

diagramPackageSelectionChanged
    |package|

    self packageDiagramShown value ifTrue:[
        package := self diagramPackageSelection value.
        self withWaitCursorDo:[
            self diagramApplicationModelHolder value
                packages:(Array with:package);
                generateDiagram
        ]
    ].
!

packageFilterChanged
!

selectedProjectsChanged
    self updatePackageDiagramView
!

update:something with:aParameter from:changedObject
    |orgMode trigger classes selectedClassesHolder selectionValue|

    orgMode := organizerMode value.
    selectedClassesHolder := self selectedClasses.
    classes := selectedClassesHolder value copy ? #().

    changedObject == packageFilter ifTrue:[
        self breakPoint:#cg
    ].

    changedObject == organizerMode ifTrue:[
        self classHierarchyListSlaveMode value:true.
        self classInheritanceListSlaveMode value:true.
        self classListSlaveMode value:true.
        self categoryListSlaveMode value:true.
        self nameSpaceListSlaveMode value:true.
        self projectListSlaveMode value:true.

        self variableFilter value:nil.
        self packageFilter value:nil.
        self nameSpaceFilter value:nil.

        "/ must update the packageFilter
        orgMode == OrganizerCanvas organizerModeProject ifTrue:[
            self selectedProjects value:(classes collect:[:each | each package] as:Set).
            packageFilter setValue:(self selectedProjects value)
        ] ifFalse:[
            packageFilter value:nil
        ].

        self updateOrganizationFromChangedClass.

        orgMode == OrganizerCanvas organizerModeCategory ifTrue:[
            trigger := self forceClassCategoryGeneratorTrigger.
        ] ifFalse:[ orgMode == OrganizerCanvas organizerModeHierarchy ifTrue:[
            trigger := self forceClassHierarchyGeneratorTrigger.
        ] ifFalse:[ orgMode == OrganizerCanvas organizerModeNamespace ifTrue:[
            trigger := self forceNamespaceGeneratorTrigger
        ] ifFalse:[ orgMode == OrganizerCanvas organizerModeProject ifTrue:[
            trigger := self forceProjectGeneratorTrigger.
        ] ifFalse:[ ((orgMode == OrganizerCanvas organizerModeClassHierarchy) 
                  or:[orgMode == OrganizerCanvas organizerModeClassInheritance]) ifTrue:[
"/            trigger := self forceClassHierarchyGeneratorTrigger.
        ]]]]].

        trigger notNil ifTrue:[
            trigger value:true
        ].
        "/ selectedClassesHolder value:classes.

        (orgMode == OrganizerCanvas organizerModeClassHierarchy or:[orgMode == OrganizerCanvas organizerModeHierarchy]) ifTrue:[
            classHierarchyListSlaveMode value:false.
        ].
        (orgMode == OrganizerCanvas organizerModeClassInheritance) ifTrue:[
            classInheritanceListSlaveMode value:false.
        ].
        (orgMode == OrganizerCanvas organizerModeClassInheritance 
        or:[orgMode == OrganizerCanvas organizerModeClassHierarchy 
        or:[orgMode == OrganizerCanvas organizerModeHierarchy]])
        ifFalse:[
            classListSlaveMode value:false.
        ].
        (orgMode == OrganizerCanvas organizerModeCategory) ifTrue:[
            categoryListSlaveMode value:false.
        ].
        (orgMode == OrganizerCanvas organizerModeNamespace) ifTrue:[
            namespaceListSlaveMode value:false.
        ].
        (orgMode == OrganizerCanvas organizerModeProject) ifTrue:[
            projectListSlaveMode value:false.
            self selectedProjects value isEmptyOrNil ifTrue:[
                self updateProjectSelectionFromClasses.
            ].
        ].
        (orgMode == OrganizerCanvas organizerModePackageDiagram) ifTrue:[
            "/
            self selectedProjects value isEmptyOrNil ifTrue:[
                self updateProjectSelectionFromClasses.
            ].
        ].

        ^ self
    ].

    changedObject == selectedClasses ifTrue:[
        selectedClasses value size ~~ 0 ifTrue:[
            (orgMode ~~ OrganizerCanvas organizerModeClassHierarchy
            and:[ orgMode ~~ OrganizerCanvas organizerModePackageDiagram ]) ifTrue:[
                "/ if the organizerMode is project, avoid clobbering the project selection
                (orgMode ~~ OrganizerCanvas organizerModeProject
                "/ or:[ (self selectedProjects value includesAll:( selectedClasses value collect:[:each | each package] )) not ]
                or:[ (self selectedProjects value includes: self class nameListEntryForChanged)
                or:[ (self selectedProjects value includes: self class nameListEntryForALL) ]]
                ) ifTrue:[
                    self updateOrganizationFromChangedClass.
                ].
            ].
        ]
    ].
"/    changedObject == selectedNamespaces ifTrue:[
"/ self halt.
"/    ].
    changedObject == nameSpaceFilterSelection ifTrue:[
        selectionValue := nameSpaceFilterSelection value.
        selectionValue size > 1 ifTrue:[
            nameSpaceFilterSelection value:(OrderedCollection with:selectionValue first).
            selectionValue := nameSpaceFilterSelection value.
        ].
        self selectedNamespaces value:selectionValue.
        selectionValue size > 0 ifTrue:[
            self nameSpaceFilterSelectedNameSpace setValue:selectionValue first.
            self updateNameSpaceLabel.
        ].
        self nameSpaceFilter value: selectionValue.
    ].
    changedObject == self selectedProjects ifTrue:[
        self breakPoint:#cg.
        self selectedProjectsChanged.
    ].
    changedObject == self selectedDiagramProject ifTrue:[
        self breakPoint:#cg.
        self selectedProjects value:(Array with:self selectedDiagramProject value).
        self selectedProjectsChanged.
        ^ self
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 27-04-2010 / 16:58:31 / cg"
    "Modified: / 26-03-2014 / 10:17:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateCategorySelectionFromClasses
    |allEntry changedEntry oldSelectedCategories categories|

    allEntry := self class nameListEntryForALL.
    changedEntry := self class nameListEntryForChanged.

    categories := Set new.
    oldSelectedCategories := self selectedCategories value.

    "/ category-selection feedBack;
    "/ if '* all *' was in its selection, keep it (to avoid updating the classList)
    oldSelectedCategories size > 0 ifTrue:[
        (oldSelectedCategories includes:allEntry) ifTrue:[
            categories add:allEntry
        ].
        oldSelectedCategories do:[:entry | 
            (NavigatorModel isPseudoCategory:entry) ifTrue:[
                (oldSelectedCategories size == 1) ifTrue:[
                    "/ don't switch to category
                    ^ self
                ].
                categories add:entry
            ].
        ].
    ].

    (self selectedClasses value ? #()) do:[:eachSelectedClass |
        |cat cls|

        cls := eachSelectedClass theNonMetaclass.
        cls isPrivate ifTrue:[
            cls := cls topOwningClass.
        ].
        cat := cls category.   
        categories add:cat.
    ].

    (categories conform:[:each | (self selectedCategories value ? #()) includes:each]) ifFalse:[
        self selectedCategories value:categories.
    ].

    "Modified: / 18.2.2000 / 13:17:36 / cg"
!

updateNamespaceSelectionFromClasses
    "invoked when switching to the namespace-organization;
     update selected namespaces from the set of selected classes"

    |allEntry classes selectedNamespaces oldSelectedNamespaces|

    allEntry := self class nameListEntryForALL.

    classes := self selectedClasses value.
    classes isEmptyOrNil ifTrue:[
        |categories includesAll|

        categories := self selectedCategories value.
        categories notEmptyOrNil ifTrue:[
            includesAll := categories includes:BrowserList nameListEntryForALL.
            classes :=  environment allClassesForWhich:[:aClass |
                (includesAll or:[categories includes:aClass category]).
            ].
        ].
    ].
    classes notEmptyOrNil ifTrue:[
        selectedNamespaces := self selectedNamespaces value.
        oldSelectedNamespaces := (selectedNamespaces ? #()) asSet.
        selectedNamespaces := Set new.

        "/ namespace-selection feedBack;
        "/ if '* all *' was in its selection, keep it (to avoid updating the classList)
"/        (oldSelectedNamespaces includes:allEntry) ifTrue:[
"/            selectedNamespaces add:allEntry.
"/        ].
        selectedNamespaces addAll:(classes collect:[:eachClass | eachClass theNonMetaclass topNameSpace name.]).

        classes := classes copy.
        "/ selectedNamespaces ~= oldSelectedNamespaces ifTrue:[
            self selectedNamespaces value:selectedNamespaces.
        "/ ].

"/        (classes ~= self selectedClasses) value ifTrue:[self halt:'oops'].
    ].

    "Modified: / 10-08-2006 / 16:04:55 / cg"
!

updateOrganizationFromChangedClass
    |orgMode selectedClassesHolder selectedClasses classHierarchyTopClassHolder commonSuperClass|

    orgMode := organizerMode value.

    orgMode == OrganizerCanvas organizerModeCategory ifTrue:[
        self updateCategorySelectionFromClasses.
        ^ self.
    ].
    orgMode == OrganizerCanvas organizerModeNamespace ifTrue:[
        self updateNamespaceSelectionFromClasses.
        ^ self.
    ].
    orgMode == OrganizerCanvas organizerModeProject ifTrue:[
        self updateProjectSelectionFromClasses.
        ^ self.
    ].
    orgMode == OrganizerCanvas organizerModePackageDiagram ifTrue:[
        self updatePackageDiagramView.
        ^ self.
    ].

    selectedClassesHolder := self selectedClasses.
    selectedClasses := selectedClassesHolder value.
    classHierarchyTopClassHolder := self classHierarchyTopClass.

    (orgMode == OrganizerCanvas organizerModeClassHierarchy) ifTrue:[
"/        (selectedClasses size == 1) ifTrue:[
"/            self classHierarchyTopClass value:selectedClasses first
"/        ].
        "/ classHierarchyTopClassHolder value isNil ifTrue:[
        selectedClasses size > 0 ifTrue:[
            commonSuperClass := selectedClasses 
                                    inject:selectedClasses first 
                                    into:[:commonSuperClass :thisClass | commonSuperClass commonSuperclass:thisClass ].
            classHierarchyTopClassHolder value:commonSuperClass "selectedClasses first".
        ].
        "/ ].
        ^ self.
    ].
    orgMode == OrganizerCanvas organizerModeHierarchy ifTrue:[
        classHierarchyTopClassHolder value:nil.
        ^ self.
    ].
    (orgMode == OrganizerCanvas organizerModeClassInheritance) ifTrue:[
        classHierarchyTopClassHolder value:
            ((selectedClasses size == 1) ifTrue:[selectedClasses first] ifFalse:nil).
        ^ self.
    ].
!

updatePackageDiagramView
    |diagramApp packages selectedClasses|

    self packageDiagramShown computeValue ifTrue:[
        diagramApp := self diagramApplicationModelHolder value.
        selectedClasses := self selectedClasses value ? #().

        packages := self selectedProjects value ? #().
        packages isEmpty ifTrue:[
            selectedClasses notEmptyOrNil ifTrue:[
                packages := (selectedClasses collect:[:cls | cls package] as:Set) asOrderedCollection.
            ].
        ].

        self selectedDiagramProject value:(packages firstIfEmpty:nil) withoutNotifying:self.
        diagramApp notNil ifTrue:[
            self withWaitCursorDo:[
                diagramApp
                    packages:packages;
                    generateDiagram;
                    selectClasses:selectedClasses.
            ]
        ]
    ].

    "Modified: / 28-04-2010 / 08:16:55 / cg"
!

updateProjectSelectionFromClasses
    "invoked when switching to the projects-organization;
     update selected projects from the set of selected classes"

    |allEntry classes selectedProjects oldSelectedProjects categories|

    allEntry := self class nameListEntryForALL.

    selectedProjects := self selectedProjects value.
    oldSelectedProjects := ((selectedProjects ? #()) collect:[:pkg | pkg string] as:Set).

    self variableFilter value:nil.
    self packageFilter value:nil.
    self nameSpaceFilter value:nil.

    selectedProjects := Set new.
    "/ project-selection feedBack;
    "/ if '* all *' was in its selection, keep it (to avoid updating the classList)
    (oldSelectedProjects size > 0 
    and:[oldSelectedProjects includes:allEntry]) 
    ifTrue:[
        selectedProjects add:allEntry.
    ].

    classes := self selectedClasses value.
    classes isEmptyOrNil ifTrue:[
        classes := OrderedCollection new.
        categories := self selectedCategories value.
        categories notEmptyOrNil ifTrue:[
            categories do:[:eachCategory |
                classes addAll:(environment allClassesInCategory:eachCategory)
            ].
        ].
    ].
    classes notEmptyOrNil ifTrue:[
        classes do:[:eachClass |
            selectedProjects add:(eachClass package).
            eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                selectedProjects add:(mthd package).
            ]
        ].
    ].

    selectedProjects ~= oldSelectedProjects ifTrue:[
        self selectedProjects value:selectedProjects.
    ].

    "Created: / 26-02-2000 / 01:09:13 / cg"
    "Modified: / 22-02-2007 / 13:52:21 / cg"
! !

!OrganizerCanvas methodsFor:'forwarder operations'!

copyMethods:methods toClass:cls
    self masterApplication copyMethods:methods toClass:cls.
!

moveClasses:classes toCategory:cat
    self masterApplication moveClasses:classes toCategory:cat
!

moveClasses:classes toProject:cat
    self masterApplication moveClasses:classes toProject:cat
!

moveMethods:methods toClass:cls
    self masterApplication moveMethods:methods toClass:cls.
!

moveMethods:methods toProject:package
    self masterApplication moveMethods:methods toProject:package.
! !

!OrganizerCanvas methodsFor:'help specs'!

flyByHelpTextFor:aComponent
    (aComponent isSameOrComponentOf:(builder componentAt:#NameSpaceFilterComboBox)) ifTrue:[
        ^ resources string:'Namespace filter'
    ].
    ^ super flyByHelpTextFor:aComponent
! !

!OrganizerCanvas methodsFor:'initialize-release'!

release
    super release.

    nameSpaceFilterSelection removeDependent:self.
    organizerMode removeDependent:self.
    selectedClasses removeDependent:self.
! !

!OrganizerCanvas methodsFor:'private'!

nameSpaceListWidgetWasBuilt:widget
    |list|

    "/ sigh - cannot do this in the nameSpaceListWidget method,
    "/ because the GUI is build late (when the menu is popped up the first time)
    widget application immediateUpdate:true.
    list := widget builder componentAt:#List.
    list autoHideHorizontalScrollBar:true.
! !

!OrganizerCanvas methodsFor:'subapplications'!

diagramApplicationModelHolder
    |holder graphApp|

    (holder := builder bindingAt:#diagramApplicationModelHolder) isNil ifTrue:[
        OOM::MetricVisualizer notNil ifTrue:[
            graphApp := OOM::MetricVisualizer new.
            graphApp masterApplication:self.
            graphApp selectedClassesHolder onChangeSend:#diagramClassSelectionChanged to:self.
            graphApp showShortClassInfo:true.
            graphApp ignoreAutoloadedClasses:true.
            graphApp askForAutoload:false.

            holder := ValueHolder new.
            holder value:graphApp.
            builder aspectAt:#diagramApplicationModelHolder put: holder.

            self packageFilter onChangeSend:#packageFilterChanged to:self.
        ].
    ].
    ^ holder
! !

!OrganizerCanvas class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

