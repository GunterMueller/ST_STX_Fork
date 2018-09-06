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

NavigatorModel subclass:#NavigatorCanvas
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!NavigatorCanvas class methodsFor:'documentation'!

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

!NavigatorCanvas class methodsFor:'interface specs'!

categoryAndClassOnlySpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#categoryAndClassOnlySpec
     Tools::NavigatorCanvas new openInterface:#categoryAndClassOnlySpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: categoryAndClassOnlySpec
       window: 
      (WindowSpec
         label: 'Full Class Browser'
         name: 'Full Class Browser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (SubCanvasSpec
             name: 'Organizer'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             majorKey: OrganizerCanvas
             minorKey: windowSpecWithoutMetaToggles
             subAspectHolders: 
            (Array
               
              (SubChannelInfoSpec
                 subAspect: classCategoryDoubleClickChannel
                 callBack: classCategoryDoubleClicked
               ) 
              (SubChannelInfoSpec
                 subAspect: classCategoryListMenuHolder
                 aspect: categoryPopUpMenu
               )
               
              (SubChannelInfoSpec
                 subAspect: classDoubleClickChannel
                 callBack: classDoubleClicked
               ) 
              (SubChannelInfoSpec
                 subAspect: classHierarchyListMenuHolder
                 aspect: hierarchyPopUpMenu
               )
               
              (SubChannelInfoSpec
                 subAspect: classHierarchyTopClass
                 aspect: classHierarchyTopClass
               ) 
              (SubChannelInfoSpec
                 subAspect: classListMenuHolder
                 aspect: classPopUpMenu
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
                 subAspect: markApplicationsHolder
                 aspect: markApplicationsHolder
               ) 
              (SubChannelInfoSpec
                 subAspect: meta
                 aspect: meta
               )
               
              (SubChannelInfoSpec
                 subAspect: metaToggleLabelHolder
                 aspect: metaToggleLabelHolder
               ) 
              (SubChannelInfoSpec
                 subAspect: methodVisibilityHolder
                 aspect: methodVisibilityHolder
               )
               
              (SubChannelInfoSpec
                 subAspect: nameSpaceDoubleClickChannel
                 callBack: nameSpaceDoubleClicked
               ) 
              (SubChannelInfoSpec
                 subAspect: nameSpaceListMenuHolder
                 aspect: nameSpacePopUpMenu
               )
               
              (SubChannelInfoSpec
                 subAspect: organizerMode
                 aspect: organizerMode
               ) 
              (SubChannelInfoSpec
                 subAspect: outGeneratorHolder
                 aspect: protocolListGenerator
               )
               
              (SubChannelInfoSpec
                 subAspect: packageFilter
                 aspect: packageFilter
               ) 
              (SubChannelInfoSpec
                 subAspect: projectDoubleClickChannel
                 callBack: projectDoubleClicked
               )
               
              (SubChannelInfoSpec
                 subAspect: projectListMenuHolder
                 aspect: projectPopUpMenu
               ) 
              (SubChannelInfoSpec
                 subAspect: selectedCategories
                 aspect: selectedCategories
                 callBack: categorySelectionChanged
               )
               
              (SubChannelInfoSpec
                 subAspect: selectedClasses
                 aspect: selectedClasses
                 callBack: classSelectionChanged
               ) 
              (SubChannelInfoSpec
                 subAspect: selectedNamespaces
                 aspect: selectedNamespaces
               )
               
              (SubChannelInfoSpec
                 subAspect: selectedProjects
                 aspect: selectedProjects
               ) 
              (SubChannelInfoSpec
                 subAspect: selectionChangeCondition
                 aspect: selectionChangeConditionHolder
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
                 subAspect: showMethodInheritance
                 aspect: showMethodInheritance
               ) 
              (SubChannelInfoSpec
                 subAspect: showMethodTypeIcon
                 aspect: showMethodTypeIcon
               )
               
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
              (SubChannelInfoSpec
                 subAspect: sortByNameAndInheritance
                 aspect: sortByNameAndInheritance
               )
               
              (SubChannelInfoSpec
                 subAspect: variableDoubleClickChannel
                 callBack: variableDoubleClicked
               )
             )
             createNewApplication: true
             createNewBuilder: true
           )
          )
        
       )
     )
!

categoryAndSingleClassOnlySpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#categoryAndSingleClassOnlySpec
     Tools::NavigatorCanvas new openInterface:#categoryAndSingleClassOnlySpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: categoryAndSingleClassOnlySpec
       window: 
      (WindowSpec
         label: 'Full Class Browser'
         name: 'Full Class Browser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (SubCanvasSpec
             name: 'Organizer'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             majorKey: OrganizerCanvas
             minorKey: windowSpecWithoutMetaToggles
             subAspectHolders: 
            (Array
               
              (SubChannelInfoSpec
                 subAspect: classCategoryDoubleClickChannel
                 callBack: classCategoryDoubleClicked
               ) 
              (SubChannelInfoSpec
                 subAspect: classCategoryListMenuHolder
                 aspect: categoryPopUpMenu
               )
               
              (SubChannelInfoSpec
                 subAspect: classDoubleClickChannel
                 callBack: classDoubleClicked
               ) 
              (SubChannelInfoSpec
                 subAspect: classHierarchyListMenuHolder
                 aspect: hierarchyPopUpMenu
               )
               
              (SubChannelInfoSpec
                 subAspect: classHierarchyTopClass
                 aspect: classHierarchyTopClass
               ) 
              (SubChannelInfoSpec
                 subAspect: classListMenuHolder
                 aspect: classPopUpMenu
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
                 subAspect: markApplicationsHolder
                 aspect: markApplicationsHolder
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
                 subAspect: nameSpaceDoubleClickChannel
                 callBack: nameSpaceDoubleClicked
               )
               
              (SubChannelInfoSpec
                 subAspect: nameSpaceListMenuHolder
                 aspect: nameSpacePopUpMenu
               ) 
              (SubChannelInfoSpec
                 subAspect: organizerMode
                 aspect: organizerMode
               )
               
              (SubChannelInfoSpec
                 subAspect: outGeneratorHolder
                 aspect: protocolListGenerator
               ) 
              (SubChannelInfoSpec
                 subAspect: packageFilter
                 aspect: packageFilter
               )
               
              (SubChannelInfoSpec
                 subAspect: projectDoubleClickChannel
                 callBack: projectDoubleClicked
               ) 
              (SubChannelInfoSpec
                 subAspect: projectListMenuHolder
                 aspect: projectPopUpMenu
               )
               
              (SubChannelInfoSpec
                 subAspect: selectedCategories
                 aspect: selectedCategories
                 callBack: categorySelectionChanged
               ) 
              (SubChannelInfoSpec
                 subAspect: selectedClasses
                 aspect: selectedClasses
                 callBack: classSelectionChanged
               )
               
              (SubChannelInfoSpec
                 subAspect: selectedNamespaces
                 aspect: selectedNamespaces
               ) 
              (SubChannelInfoSpec
                 subAspect: selectedProjects
                 aspect: selectedProjects
               )
               
              (SubChannelInfoSpec
                 subAspect: selectionChangeCondition
                 aspect: selectionChangeConditionHolder
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
                 subAspect: showMethodInheritance
                 aspect: showMethodInheritance
               )
               
              (SubChannelInfoSpec
                 subAspect: showMethodTypeIcon
                 aspect: showMethodTypeIcon
               ) 
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               )
               
              (SubChannelInfoSpec
                 subAspect: sortByNameAndInheritance
                 aspect: sortByNameAndInheritance
               ) 
              (SubChannelInfoSpec
                 subAspect: variableDoubleClickChannel
                 callBack: variableDoubleClicked
               )
             )
             createNewApplication: true
             createNewBuilder: true
           )
          )
        
       )
     )
!

fullBrowserSpec

    ^UserPreferences current showEmbeddedTestRunnerInBrowser
        ifTrue: [self fullBrowserSpecWithEmbeddedTestRunner]
        ifFalse:[self fullBrowserSpecPlain]

    "Modified: / 11-03-2010 / 10:15:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fullBrowserSpecPlain
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#fullBrowserSpecPlain
     Tools::NavigatorCanvas new openInterface:#fullBrowserSpecPlain
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: fullBrowserSpecPlain
       window: 
      (WindowSpec
         label: 'SystemBrowser'
         name: 'SystemBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
         icon: defaultIcon
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'Organizer'
                   majorKey: OrganizerCanvas
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: classCategoryListMenuHolder
                       aspect: categoryPopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: classCategoryDoubleClickChannel
                       callBack: classCategoryDoubleClicked
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: classDoubleClickChannel
                       callBack: classDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: nameSpaceDoubleClickChannel
                       callBack: nameSpaceDoubleClicked
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: projectDoubleClickChannel
                       callBack: projectDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableDoubleClickChannel
                       callBack: variableDoubleClicked
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: classHierarchyListMenuHolder
                       aspect: hierarchyPopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: classHierarchyTopClass
                       aspect: classHierarchyTopClass
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: classListMenuHolder
                       aspect: classPopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: hideUnloadedClasses
                       aspect: hideUnloadedClasses
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: sortByNameAndInheritance
                       aspect: sortByNameAndInheritance
                     ) 
                    (SubChannelInfoSpec
                       subAspect: markApplicationsHolder
                       aspect: markApplicationsHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: showClassPackages
                       aspect: showClassPackages
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: meta
                       aspect: meta
                     ) 
                    (SubChannelInfoSpec
                       subAspect: metaToggleLabelHolder
                       aspect: metaToggleLabelHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: nameSpaceListMenuHolder
                       aspect: nameSpacePopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: organizerMode
                       aspect: organizerMode
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: projectListMenuHolder
                       aspect: projectPopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedCategories
                       aspect: selectedCategories
                       callBack: categorySelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedClasses
                       aspect: selectedClasses
                       callBack: classSelectionChanged
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedNamespaces
                       aspect: selectedNamespaces
                       callBack: nameSpaceSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedProjects
                       aspect: selectedProjects
                       callBack: projectSelectionChanged
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: nameSpaceFilter
                       aspect: nameSpaceFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                       callBack: variableSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variablesMenuHolder
                       aspect: variablesPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: sortVariablesByName
                       aspect: sortVariablesByName
                     )
                    (SubChannelInfoSpec
                       subAspect: groupVariablesByInheritance
                       aspect: groupVariablesByInheritance
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                       callBack: variableSelectionChanged
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                       callBack: variableSelectionChanged
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.5 0.75 1.0)
           )
          )
        
       )
     )
!

fullBrowserSpecWithEmbeddedTestRunner
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#fullBrowserSpecWithEmbeddedTestRunner
     Tools::NavigatorCanvas new openInterface:#fullBrowserSpecWithEmbeddedTestRunner
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: fullBrowserSpecWithEmbeddedTestRunner
       window: 
      (WindowSpec
         label: 'SystemBrowser'
         name: 'SystemBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
         icon: defaultIcon
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'Organizer'
                   majorKey: OrganizerCanvas
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: classCategoryDoubleClickChannel
                       callBack: classCategoryDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: classCategoryListMenuHolder
                       aspect: categoryPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: classDoubleClickChannel
                       callBack: classDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: classHierarchyListMenuHolder
                       aspect: hierarchyPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: classHierarchyTopClass
                       aspect: classHierarchyTopClass
                     ) 
                    (SubChannelInfoSpec
                       subAspect: classListMenuHolder
                       aspect: classPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
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
                       subAspect: meta
                       aspect: meta
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: metaToggleLabelHolder
                       aspect: metaToggleLabelHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: nameSpaceDoubleClickChannel
                       callBack: nameSpaceDoubleClicked
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: nameSpaceFilter
                       aspect: nameSpaceFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: nameSpaceListMenuHolder
                       aspect: nameSpacePopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: organizerMode
                       aspect: organizerMode
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: protocolListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: projectDoubleClickChannel
                       callBack: projectDoubleClicked
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: projectListMenuHolder
                       aspect: projectPopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedCategories
                       aspect: selectedCategories
                       callBack: categorySelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedClasses
                       aspect: selectedClasses
                       callBack: classSelectionChanged
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedNamespaces
                       aspect: selectedNamespaces
                       callBack: nameSpaceSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedProjects
                       aspect: selectedProjects
                       callBack: projectSelectionChanged
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: sortByNameAndInheritance
                       aspect: sortByNameAndInheritance
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
                       subAspect: variableDoubleClickChannel
                       callBack: variableDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                       callBack: variableSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variablesMenuHolder
                       aspect: variablesPopUpMenu
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'CategoryAndMethodList'
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   majorKey: #'Tools::NavigatorCanvas'
                   minorKey: protocolAndMethodListSpec
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                   )
                   createNewBuilder: false
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          )
        
       )
     )
!

multipleCategoryBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#multipleCategoryBrowserSpec
     Tools::NavigatorCanvas new openInterface:#multipleCategoryBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: multipleCategoryBrowserSpec
       window: 
      (WindowSpec
         label: 'CategoryBrowser'
         name: 'CategoryBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (VariableHorizontalPanelSpec
                   name: 'VariableHorizontalPanel1'
                   barWidth: 2
                   showHandle: false
                   component: 
                  (SpecCollection
                     collection: (
                      (SubCanvasSpec
                         name: 'CategoryList'
                         majorKey: ClassCategoryList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             callBack: classCategoryDoubleClicked
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
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
                             aspect: categoryListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: categoryPopUpMenu
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectedCategories
                             aspect: selectedCategories
                             callBack: categorySelectionChanged
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeConditionHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: showClassPackages
                             aspect: showClassPackages
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (ViewSpec
                         name: 'Box1'
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
                                  (SubCanvasSpec
                                     name: 'ClassList'
                                     majorKey: ClassList
                                     subAspectHolders: 
                                    (Array
                                       
                                      (SubChannelInfoSpec
                                         subAspect: doubleClickChannel
                                         callBack: classDoubleClicked
                                       ) 
                                      (SubChannelInfoSpec
                                         subAspect: environmentHolder
                                         aspect: environmentHolder
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
                                         aspect: classListGenerator
                                       ) 
                                      (SubChannelInfoSpec
                                         subAspect: markApplicationsHolder
                                         aspect: markApplicationsHolder
                                       )
                                       
                                      (SubChannelInfoSpec
                                         subAspect: menuHolder
                                         aspect: classPopUpMenu
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
                                         aspect: protocolListGenerator
                                       )
                                       
                                      (SubChannelInfoSpec
                                         subAspect: packageFilter
                                         aspect: packageFilter
                                       ) 
                                      (SubChannelInfoSpec
                                         subAspect: selectedClasses
                                         aspect: selectedClasses
                                         callBack: classSelectionChanged
                                       )
                                       
                                      (SubChannelInfoSpec
                                         subAspect: selectionChangeCondition
                                         aspect: selectionChangeConditionHolder
                                       ) 
                                      (SubChannelInfoSpec
                                         subAspect: showCoverageInformation
                                         aspect: showCoverageInformation
                                       )
                                       
                                      (SubChannelInfoSpec
                                         subAspect: sortByNameAndInheritance
                                         aspect: sortByNameAndInheritance
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
                                         callBack: variableDoubleClicked
                                       )
                                       
                                      (SubChannelInfoSpec
                                         subAspect: environmentHolder
                                         aspect: environmentHolder
                                       ) 
                                      (SubChannelInfoSpec
                                         subAspect: menuHolder
                                         aspect: variablesPopUpMenu
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
                                     )
                                     createNewApplication: true
                                     createNewBuilder: true
                                   )
                                  )
                                
                               )
                               handles: (Any 0.5 1.0)
                             )
                            (UISubSpecification
                               name: 'MetaToggles'
                               layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                               majorKey: NavigatorModel
                               minorKey: metaSpec
                             )
                            )
                          
                         )
                       )
                      (SubCanvasSpec
                         name: 'MethodCategoryList'
                         majorKey: MethodCategoryList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             callBack: protocolDoubleClicked
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: filterClassVars
                             aspect: filterClassVars
                           ) 
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: inGeneratorHolder
                             aspect: protocolListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: protocolMenu
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: methodVisibilityHolder
                             aspect: methodVisibilityHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: selectorListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: packageFilter
                             aspect: packageFilter
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectedProtocols
                             aspect: selectedProtocols
                             callBack: protocolSelectionChanged
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeConditionHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: showCoverageInformation
                             aspect: showCoverageInformation
                           )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                           
                          (SubChannelInfoSpec
                             subAspect: showPseudoProtocols
                             aspect: showPseudoProtocols
                           ) 
                          (SubChannelInfoSpec
                             subAspect: variableFilter
                             aspect: variableFilter
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'MethodList'
                         majorKey: MethodList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             callBack: methodDoubleClicked
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: filterClassVars
                             aspect: filterClassVars
                           ) 
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: inGeneratorHolder
                             aspect: selectorListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: selectorPopUpMenu
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: packageFilter
                             aspect: packageFilter
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectedMethods
                             aspect: selectedMethods
                             callBack: methodsSelectionChanged
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeConditionHolder
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
                             subAspect: showSyntheticMethods
                             aspect: showSyntheticMethods
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: variableFilter
                             aspect: variableFilter
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      )
                    
                   )
                   handles: (Any 0.25 0.5 0.75 1.0)
                 )
                )
              
             )
             handles: (Any 1.0)
           )
          )
        
       )
     )
!

multipleClassBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#multipleClassBrowserSpec
     Tools::NavigatorCanvas new openInterface:#multipleClassBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: multipleClassBrowserSpec
       window: 
      (WindowSpec
         label: 'ClassBrowser'
         name: 'ClassBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
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
                      (VariableVerticalPanelSpec
                         name: 'VariableVerticalPanel1'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
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
                                   aspect: classListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classPopUpMenu
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
                                   aspect: protocolListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
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
                                   subAspect: sortBy
                                   aspect: sortBy
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
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
                                   callBack: variableDoubleClicked
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.333333 0.666667 1.0)
           )
          )
        
       )
     )
!

multipleClassDiffBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#multipleClassDiffBrowserSpec
     Tools::NavigatorCanvas new openInterface:#multipleClassDiffBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: multipleClassDiffBrowserSpec
       window: 
      (WindowSpec
         label: 'ClassBrowser'
         name: 'ClassBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (SubCanvasSpec
             name: 'ClassList'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -30 1.0)
             majorKey: ClassList
             subAspectHolders: 
            (Array
               
              (SubChannelInfoSpec
                 subAspect: doubleClickChannel
                 callBack: classDoubleClicked
               ) 
              (SubChannelInfoSpec
                 subAspect: environmentHolder
                 aspect: environmentHolder
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
                 aspect: classListGenerator
               ) 
              (SubChannelInfoSpec
                 subAspect: markApplicationsHolder
                 aspect: markApplicationsHolder
               )
               
              (SubChannelInfoSpec
                 subAspect: menuHolder
                 aspect: classPopUpMenu
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
                 aspect: protocolListGenerator
               )
               
              (SubChannelInfoSpec
                 subAspect: packageFilter
                 aspect: packageFilter
               ) 
              (SubChannelInfoSpec
                 subAspect: selectedClasses
                 aspect: selectedClasses
                 callBack: classSelectionChanged
               )
               
              (SubChannelInfoSpec
                 subAspect: selectionChangeCondition
                 aspect: selectionChangeConditionHolder
               ) 
              (SubChannelInfoSpec
                 subAspect: showClassPackages
                 aspect: showClassPackages
               )
               
              (SubChannelInfoSpec
                 subAspect: sortBy
                 aspect: sortBy
               ) 
              (SubChannelInfoSpec
                 subAspect: sortByNameAndInheritance
                 aspect: sortByNameAndInheritance
               )
             )
             createNewApplication: true
             createNewBuilder: true
           )
          (LabelSpec
             label: 'projectInfo'
             name: 'Label1'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             level: -1
             labelChannel: classesProjectInfoHolder
             adjust: left
           )
          )
        
       )
     )
!

multipleClassExtensionBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#multipleClassExtensionBrowserSpec
     Tools::NavigatorCanvas new openInterface:#multipleClassExtensionBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: multipleClassExtensionBrowserSpec
       window: 
      (WindowSpec
         label: 'ClassBrowser'
         name: 'ClassBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
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
                      (VariableVerticalPanelSpec
                         name: 'VariableVerticalPanel1'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
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
                                   aspect: classListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classPopUpMenu
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
                                   aspect: protocolListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
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
                                   subAspect: sortBy
                                   aspect: sortBy
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
                                 )
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            (SubCanvasSpec
                               name: 'ProjectList'
                               majorKey: ProjectList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: inGeneratorHolder
                                   aspect: projectListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: projectPopUpMenu
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectedProjects
                                   aspect: selectedProjects
                                   callBack: projectSelectionChangedForFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
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
                                   subAspect: doubleClickChannel
                                   callBack: variableDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: classHolder
                                   aspect: selectedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.7 1.0 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: packageFilterOnInput
                       aspect: packageFilter
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                       callBack: variableSelectionChanged
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                       callBack: variableSelectionChanged
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.333333 0.666667 1.0)
           )
          )
        
       )
     )
!

multipleFullProtocolBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#multipleFullProtocolBrowserSpec
     Tools::NavigatorCanvas new openInterface:#multipleFullProtocolBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: multipleFullProtocolBrowserSpec
       window: 
      (WindowSpec
         label: 'ProtocolBrowser'
         name: 'ProtocolBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     ) 
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: noAllItem
                       aspect: noAllItem
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     ) 
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     ) 
                    (SubChannelInfoSpec
                       subAspect: sortBy
                       aspect: sortBy
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
!

multipleNameSpaceBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#multipleNameSpaceBrowserSpec
     Tools::NavigatorCanvas new openInterface:#multipleNameSpaceBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: multipleNameSpaceBrowserSpec
       window: 
      (WindowSpec
         label: 'NameSpaceBrowser'
         name: 'NameSpaceBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'NamespaceList'
                   majorKey: NamespaceList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: nameSpaceDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
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
                       aspect: nameSpaceListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: nameSpacePopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: classListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedNamespaces
                       aspect: selectedNamespaces
                       callBack: nameSpaceSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showClassPackages
                       aspect: showClassPackages
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (VariableVerticalPanelSpec
                         name: 'VariableVerticalPanel1'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
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
                                   aspect: classListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: meta
                                   aspect: meta
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: selectedNamespaces
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: organizerMode
                                   aspect: organizerMode
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: protocolListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
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
                                   callBack: variableDoubleClicked
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.25 0.5 0.75 1.0)
           )
          )
        
       )
     )
!

multipleNameSpaceFullBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#multipleNameSpaceFullBrowserSpec
     Tools::NavigatorCanvas new openInterface:#multipleNameSpaceFullBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: multipleNameSpaceFullBrowserSpec
       window: 
      (WindowSpec
         label: 'NameSpaceBrowser'
         name: 'NameSpaceBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (VariableVerticalPanelSpec
                   name: 'VariableVerticalPanel2'
                   component: 
                  (SpecCollection
                     collection: (
                      (SubCanvasSpec
                         name: 'NameSpaceList'
                         majorKey: NamespaceList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             callBack: nameSpaceDoubleClicked
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
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
                             aspect: nameSpaceListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: nameSpacePopUpMenu
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedNamespaces
                             aspect: selectedNamespaces
                             callBack: nameSpaceSelectionChanged
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeConditionHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showClassPackages
                             aspect: showClassPackages
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'ClassCategoryList'
                         majorKey: ClassCategoryList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             callBack: classCategoryDoubleClicked
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
                             aspect: categoryPopUpMenu
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: nameSpaceFilter
                             aspect: selectedNamespaces
                           ) 
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classListGenerator
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
                      )
                    
                   )
                   handles: (Any 0.5 1.0)
                 )
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (VariableVerticalPanelSpec
                         name: 'VariableVerticalPanel1'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classPopUpMenu
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: selectedNamespaces
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: inGeneratorHolder
                                   aspect: classListGenerator
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
                                   aspect: protocolListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
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
                                   subAspect: doubleClickChannel
                                   callBack: variableDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: classHolder
                                   aspect: selectedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.25 0.5 0.75 1.0)
           )
          )
        
       )
     )
!

multipleProjectBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#multipleProjectBrowserSpec
     Tools::NavigatorCanvas new openInterface:#multipleProjectBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: multipleProjectBrowserSpec
       window: 
      (WindowSpec
         label: 'ProjectBrowser'
         name: 'ProjectBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'ProjectList'
                   majorKey: ProjectList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: projectDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
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
                       aspect: projectListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: projectPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: classListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProjects
                       aspect: selectedProjects
                       callBack: projectSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showClassPackages
                       aspect: showClassPackages
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (VariableVerticalPanelSpec
                         name: 'VariableVerticalPanel1'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
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
                                   aspect: classListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
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
                                   aspect: protocolListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
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
                                   callBack: variableDoubleClicked
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                       callBack: variableSelectionChanged
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                       callBack: variableSelectionChanged
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.25 0.5 0.75 1.0)
           )
          )
        
       )
     )
!

multipleProjectFullBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#multipleProjectFullBrowserSpec
     Tools::NavigatorCanvas new openInterface:#multipleProjectFullBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: multipleProjectFullBrowserSpec
       window: 
      (WindowSpec
         label: 'ProjectBrowser'
         name: 'ProjectBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (VariableVerticalPanelSpec
                   name: 'VariableVerticalPanel2'
                   component: 
                  (SpecCollection
                     collection: (
                      (SubCanvasSpec
                         name: 'ProjectList'
                         majorKey: ProjectList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             callBack: projectDoubleClicked
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
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
                             aspect: projectListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: projectPopUpMenu
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedProjects
                             aspect: selectedProjects
                             callBack: projectSelectionChanged
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeConditionHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showClassPackages
                             aspect: showClassPackages
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'ClassCategoryList'
                         majorKey: ClassCategoryList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             callBack: classCategoryDoubleClicked
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
                             aspect: categoryPopUpMenu
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: packageFilter
                             aspect: selectedProjects
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
                      )
                    
                   )
                   handles: (Any 0.5 1.0)
                 )
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (VariableVerticalPanelSpec
                         name: 'VariableVerticalPanel1'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
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
                                   aspect: classListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classPopUpMenu
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
                                   aspect: protocolListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: selectedProjects
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
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
                                   callBack: variableDoubleClicked
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                       callBack: variableSelectionChanged
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                       callBack: variableSelectionChanged
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.25 0.5 0.75 1.0)
           )
          )
        
       )
     )
!

multipleProtocolBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#multipleProtocolBrowserSpec
     Tools::NavigatorCanvas new openInterface:#multipleProtocolBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: multipleProtocolBrowserSpec
       window: 
      (WindowSpec
         label: 'ProtocolBrowser'
         name: 'ProtocolBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     ) 
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: noAllItem
                       aspect: noAllItem
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     ) 
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     ) 
                    (SubChannelInfoSpec
                       subAspect: sortBy
                       aspect: sortBy
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
!

protocolAndMethodListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#protocolAndMethodListSpec
     Tools::NavigatorCanvas new openInterface:#protocolAndMethodListSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: protocolAndMethodListSpec
       window: 
      (WindowSpec
         label: 'Protocol and Method List'
         name: 'Protocol and Method List'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 498 456)
         icon: defaultIcon
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: bottomFit
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'ProtocolAndMethodListCanvas'
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   majorKey: #'Tools::NavigatorCanvas'
                   minorKey: #'protocolAndMethodListSpec_Both'
                   specHolder: organizerProtocolAndMethodListSpecHolder
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                   )
                   createNewBuilder: false
                   extent: (Point 498 456)
                 )
                (SubCanvasSpec
                   name: 'TestRunnerEmbedded'
                   initiallyInvisible: true
                   visibilityChannel: testRunnerVisibleHolder
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   majorKey: #'Tools::TestRunnerEmbedded'
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: infoHolder
                       aspect: infoLabelHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: methodGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedClassesHolder
                       aspect: selectedClasses
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethodsHolder
                       aspect: selectedMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedProtocolsHolder
                       aspect: selectedProtocols
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                   extent: (Point 498 50)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

selectorBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#selectorBrowserSpec
     Tools::NavigatorCanvas new openInterface:#selectorBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: selectorBrowserSpec
       window: 
      (WindowSpec
         label: 'SelectorBrowser'
         name: 'SelectorBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             barWidth: 2
             showHandle: false
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'AllMethodCategoryList'
                   majorKey: FullMethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     ) 
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'ImplementedMethodList'
                   majorKey: ImplementingMethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: xxxDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     ) 
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: implementingClassListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'ImplementingClassList'
                   majorKey: ImplementingClassList
                   minorKey: windowSpec
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     ) 
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: implementingClassListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.333333 0.666667 1.0)
           )
          )
        
       )
     )
!

singleCategoryBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#singleCategoryBrowserSpec
     Tools::NavigatorCanvas new openInterface:#singleCategoryBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: singleCategoryBrowserSpec
       window: 
      (WindowSpec
         label: 'CategoryBrowser'
         name: 'CategoryBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
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
                         name: 'PseudoCategoryList'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 25 0)
                         majorKey: ClassCategoryList
                         minorKey: singleCategoryWindowSpec
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
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
                             aspect: categoryListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: categoryPopUpMenu
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedCategories
                             aspect: selectedCategories
                           ) 
                          (SubChannelInfoSpec
                             subAspect: showClassPackages
                             aspect: showClassPackages
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (VariableVerticalPanelSpec
                         name: 'VariableVerticalPanel1'
                         layout: (LayoutFrame 0 0.0 25 0.0 0 1.0 -25 1.0)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
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
                                   aspect: classListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classPopUpMenu
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
                                   aspect: protocolListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
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
                                   callBack: variableDoubleClicked
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.333333 0.666667 1.0)
           )
          )
        
       )
     )
!

singleClassBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#singleClassBrowserSpec
     Tools::NavigatorCanvas new openInterface:#singleClassBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: singleClassBrowserSpec
       window: 
      (WindowSpec
         label: 'ClassBrowser'
         name: 'ClassBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
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
                         name: 'PseudoClassList'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 25 0)
                         majorKey: ClassList
                         minorKey: singleClassWindowSpec
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
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
                             aspect: classListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: classPopUpMenu
                           ) 
                          (SubChannelInfoSpec
                             subAspect: meta
                             aspect: meta
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: protocolListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectedClasses
                             aspect: selectedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showClassPackages
                             aspect: showClassPackages
                           ) 
                          (SubChannelInfoSpec
                             subAspect: sortByNameAndInheritance
                             aspect: sortByNameAndInheritance
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (VariableVerticalPanelSpec
                         name: 'VariableVerticalPanel1'
                         layout: (LayoutFrame 0 0.0 25 0.0 0 1.0 -25 1.0)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'MethodCategoryList'
                               majorKey: MethodCategoryList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: protocolDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: filterClassVars
                                   aspect: filterClassVars
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: inGeneratorHolder
                                   aspect: protocolListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: protocolMenu
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: outGeneratorHolder
                                   aspect: selectorListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectedProtocols
                                   aspect: selectedProtocols
                                   callBack: protocolSelectionChanged
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showPseudoProtocols
                                   aspect: showPseudoProtocols
                                 )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                                 
                                (SubChannelInfoSpec
                                   subAspect: variableFilter
                                   aspect: variableFilter
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
                                   callBack: variableDoubleClicked
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
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
!

singleClassWithoutVariableListBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#singleClassWithoutVariableListBrowserSpec
     Tools::NavigatorCanvas new openInterface:#singleClassWithoutVariableListBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: singleClassWithoutVariableListBrowserSpec
       window: 
      (WindowSpec
         label: 'ClassBrowser'
         name: 'ClassBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
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
                         name: 'PseudoClassList'
                         layout: (LayoutFrame 0 0 0 0 0 1 25 0)
                         majorKey: ClassList
                         minorKey: singleClassWindowSpec
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
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
                             aspect: classListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: classPopUpMenu
                           ) 
                          (SubChannelInfoSpec
                             subAspect: meta
                             aspect: meta
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: protocolListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectedClasses
                             aspect: selectedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showClassPackages
                             aspect: showClassPackages
                           ) 
                          (SubChannelInfoSpec
                             subAspect: sortByNameAndInheritance
                             aspect: sortByNameAndInheritance
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'MethodCategoryList'
                         layout: (LayoutFrame 0 0 25 0 0 1 -25 1)
                         majorKey: MethodCategoryList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             callBack: protocolDoubleClicked
                           ) 
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: filterClassVars
                             aspect: filterClassVars
                           ) 
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: inGeneratorHolder
                             aspect: protocolListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: protocolMenu
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: selectorListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: packageFilter
                             aspect: packageFilter
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedProtocols
                             aspect: selectedProtocols
                             callBack: protocolSelectionChanged
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectionChangeCondition
                             aspect: selectionChangeConditionHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showCoverageInformation
                             aspect: showCoverageInformation
                           ) 
                          (SubChannelInfoSpec
                             subAspect: showPseudoProtocols
                             aspect: showPseudoProtocols
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showSyntheticMethods
                             aspect: showSyntheticMethods
                           ) 
                          (SubChannelInfoSpec
                             subAspect: variableFilter
                             aspect: variableFilter
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
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
!

singleFullProtocolBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#singleFullProtocolBrowserSpec
     Tools::NavigatorCanvas new openInterface:#singleFullProtocolBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: singleFullProtocolBrowserSpec
       window: 
      (WindowSpec
         label: 'ProtocolBrowser'
         name: 'ProtocolBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'PseudoProtocolList'
                   layout: (LayoutFrame 0 0.0 0 0 0 1.0 25 0)
                   majorKey: MethodCategoryList
                   minorKey: singleProtocolWindowSpec
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   layout: (LayoutFrame 0 0.0 25 0.0 0 1.0 0 1.0)
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     ) 
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     ) 
                    (SubChannelInfoSpec
                       subAspect: sortBy
                       aspect: sortBy
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

singleNameSpaceBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#singleNameSpaceBrowserSpec
     Tools::NavigatorCanvas new openInterface:#singleNameSpaceBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: singleNameSpaceBrowserSpec
       window: 
      (WindowSpec
         label: 'NameSpaceBrowser'
         name: 'NameSpaceBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
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
                         name: 'PseudoNameSpaceList'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 25 0)
                         majorKey: NamespaceList
                         minorKey: singleNameSpaceWindowSpec
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
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
                             aspect: nameSpaceListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectedNamespaces
                             aspect: selectedNamespaces
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showClassPackages
                             aspect: showClassPackages
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (VariableVerticalPanelSpec
                         name: 'VariableVerticalPanel1'
                         layout: (LayoutFrame 0 0.0 25 0.0 0 1.0 -25 1.0)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
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
                                   aspect: classListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classPopUpMenu
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
                                   aspect: protocolListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   callBack: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
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
                                   callBack: variableDoubleClicked
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.333333 0.666667 1.0)
           )
          )
        
       )
     )
!

singleNameSpaceFullBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#singleNameSpaceFullBrowserSpec
     Tools::NavigatorCanvas new openInterface:#singleNameSpaceFullBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: singleNameSpaceFullBrowserSpec
       window: 
      (WindowSpec
         label: 'NameSpaceBrowser'
         name: 'NameSpaceBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
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
                         name: 'PseudoNameSpaceList'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 25 0)
                         majorKey: NamespaceList
                         minorKey: singleNameSpaceWindowSpec
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
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
                             aspect: nameSpaceListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classListPerNameSpaceGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectedNamespaces
                             aspect: selectedNamespaces
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showClassPackages
                             aspect: showClassPackages
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'ClassCategoryList'
                         layout: (LayoutFrame 0 0.0 25 0.0 0 1.0 0 1.0)
                         majorKey: ClassCategoryList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             callBack: classCategoryDoubleClicked
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
                             aspect: categoryPopUpMenu
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: nameSpaceFilter
                             aspect: selectedNamespaces
                           ) 
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classListGenerator
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
                      )
                    
                   )
                 )
                (ViewSpec
                   name: 'Box2'
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
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: nameSpaceFilter
                                   aspect: selectedNamespaces
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: hideUnloadedClasses
                                   aspect: hideUnloadedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: immediateUpdate
                                   aspect: immediateUpdate
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: inGeneratorHolder
                                   aspect: classListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classPopUpMenu
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
                                   aspect: protocolListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   callBack: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
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
                                   subAspect: doubleClickChannel
                                   callBack: variableDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: classHolder
                                   aspect: selectedClasses
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.25 0.5 0.75 1.0)
           )
          )
        
       )
     )
!

singleProjectBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#singleProjectBrowserSpec
     Tools::NavigatorCanvas new openInterface:#singleProjectBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: singleProjectBrowserSpec
       window: 
      (WindowSpec
         label: 'ProjectBrowser'
         name: 'ProjectBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
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
                         name: 'PseudoProjectList'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 25 0)
                         majorKey: ProjectList
                         minorKey: singleProjectWindowSpec
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: projectPopUpMenu
                           ) 
                          (SubChannelInfoSpec
                             subAspect: hideUnloadedClasses
                             aspect: hideUnloadedClasses
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showClassPackages
                             aspect: showClassPackages
                           ) 
                          (SubChannelInfoSpec
                             subAspect: inGeneratorHolder
                             aspect: projectListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classListGenerator
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectedProjects
                             aspect: selectedProjects
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: immediateUpdate
                             aspect: immediateUpdate
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (VariableVerticalPanelSpec
                         name: 'VariableVerticalPanel1'
                         layout: (LayoutFrame 0 0.0 25 0.0 0 1.0 -25 1.0)
                         showHandle: false
                         snapMode: both
                         handlePosition: left
                         component: 
                        (SpecCollection
                           collection: (
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
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
                                   aspect: classListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classPopUpMenu
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
                                   aspect: protocolListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: packageFilter
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
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
                                   callBack: variableDoubleClicked
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'MetaToggles'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.333333 0.666667 1.0)
           )
          )
        
       )
     )
!

singleProjectFullBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#singleProjectFullBrowserSpec
     Tools::NavigatorCanvas new openInterface:#singleProjectFullBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: singleProjectFullBrowserSpec
       window: 
      (WindowSpec
         label: 'ProjectBrowser'
         name: 'ProjectBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
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
                         name: 'PseudoProjectList'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 25 0)
                         majorKey: ProjectList
                         minorKey: singleProjectWindowSpec
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: environmentHolder
                             aspect: environmentHolder
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
                             aspect: projectListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: menuHolder
                             aspect: projectPopUpMenu
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedProjects
                             aspect: selectedProjects
                           ) 
                          (SubChannelInfoSpec
                             subAspect: showClassPackages
                             aspect: showClassPackages
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'ClassCategoryList'
                         layout: (LayoutFrame 0 0.0 25 0.0 0 1.0 0 1.0)
                         majorKey: ClassCategoryList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: doubleClickChannel
                             callBack: classCategoryDoubleClicked
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
                             aspect: categoryPopUpMenu
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: organizerMode
                             aspect: organizerMode
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: classListGenerator
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: packageFilter
                             aspect: selectedProjects
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
                      )
                    
                   )
                 )
                (ViewSpec
                   name: 'Box2'
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
                            (SubCanvasSpec
                               name: 'ClassList'
                               majorKey: ClassList
                               subAspectHolders: 
                              (Array
                                 
                                (SubChannelInfoSpec
                                   subAspect: doubleClickChannel
                                   callBack: classDoubleClicked
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
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
                                   aspect: classListGenerator
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: markApplicationsHolder
                                   aspect: markApplicationsHolder
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: classPopUpMenu
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
                                   aspect: protocolListGenerator
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: packageFilter
                                   aspect: selectedProjects
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: selectedClasses
                                   aspect: selectedClasses
                                   callBack: classSelectionChanged
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: selectionChangeCondition
                                   aspect: selectionChangeConditionHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: showCoverageInformation
                                   aspect: showCoverageInformation
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: sortByNameAndInheritance
                                   aspect: sortByNameAndInheritance
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
                                   callBack: variableDoubleClicked
                                 )
                                 
                                (SubChannelInfoSpec
                                   subAspect: environmentHolder
                                   aspect: environmentHolder
                                 ) 
                                (SubChannelInfoSpec
                                   subAspect: menuHolder
                                   aspect: variablesPopUpMenu
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
                               )
                               createNewApplication: true
                               createNewBuilder: true
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      (UISubSpecification
                         name: 'SubSpecification1'
                         layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
                         majorKey: NavigatorModel
                         minorKey: metaSpec
                       )
                      )
                    
                   )
                 )
                (SubCanvasSpec
                   name: 'MethodCategoryList'
                   majorKey: MethodCategoryList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: protocolDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: methodVisibilityHolder
                       aspect: methodVisibilityHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                       callBack: protocolSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showPseudoProtocols
                       aspect: showPseudoProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: filterClassVars
                       aspect: filterClassVars
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
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
                       subAspect: showSyntheticMethods
                       aspect: showSyntheticMethods
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: variableFilter
                       aspect: variableFilter
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.25 0.5 0.75 1.0)
           )
          )
        
       )
     )
!

singleProtocolBrowserSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorCanvas andSelector:#singleProtocolBrowserSpec
     Tools::NavigatorCanvas new openInterface:#singleProtocolBrowserSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: singleProtocolBrowserSpec
       window: 
      (WindowSpec
         label: 'ProtocolBrowser'
         name: 'ProtocolBrowser'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 462 300)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'PseudoProtocolList'
                   layout: (LayoutFrame 0 0.0 0 0 0 1.0 25 0)
                   majorKey: MethodCategoryList
                   minorKey: singleProtocolWindowSpec
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: protocolListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: protocolMenu
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: outGeneratorHolder
                       aspect: selectorListGenerator
                     ) 
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedProtocols
                       aspect: selectedProtocols
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'MethodList'
                   layout: (LayoutFrame 0 0.0 25 0.0 0 1.0 0 1.0)
                   majorKey: MethodList
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: doubleClickChannel
                       callBack: methodDoubleClicked
                     ) 
                    (SubChannelInfoSpec
                       subAspect: environmentHolder
                       aspect: environmentHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: immediateUpdate
                       aspect: immediateUpdate
                     ) 
                    (SubChannelInfoSpec
                       subAspect: inGeneratorHolder
                       aspect: selectorListGenerator
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: menuHolder
                       aspect: selectorPopUpMenu
                     ) 
                    (SubChannelInfoSpec
                       subAspect: packageFilter
                       aspect: packageFilter
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: selectedMethods
                       aspect: selectedMethods
                       callBack: methodsSelectionChanged
                     ) 
                    (SubChannelInfoSpec
                       subAspect: selectionChangeCondition
                       aspect: selectionChangeConditionHolder
                     )
              (SubChannelInfoSpec
                 subAspect: showSyntheticMethods
                 aspect: showSyntheticMethods
               ) 
                     
                    (SubChannelInfoSpec
                       subAspect: showCoverageInformation
                       aspect: showCoverageInformation
                     ) 
                    (SubChannelInfoSpec
                       subAspect: sortBy
                       aspect: sortBy
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

windowSpec
    ^ self fullBrowserSpec
! !

!NavigatorCanvas class methodsFor:'misc'!

classResources
    ^ NewSystemBrowser classResources
! !

!NavigatorCanvas class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #environmentHolder
      ).

! !

!NavigatorCanvas methodsFor:'accessing'!

initialOrganizerMode
    ^ nil  "/ dummy
! !

!NavigatorCanvas methodsFor:'actions'!

classDoubleClicked
    self subclassResponsibility
! !

!NavigatorCanvas methodsFor:'queries'!

showAllClassesInNameSpaceOrganisation
    ^ true
! !

!NavigatorCanvas class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

