"
 COPYRIGHT (c) 2002 by eXept Software AG
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

"{ NameSpace: Smalltalk }"

Object subclass:#CodeGeneratorTool
	instanceVariableNames:'compositeChangeCollector compositeChangeNesting userPreferences
		generateComments confirmChanges targetClass'
	classVariableNames:'GenerateCommentsForGetters GenerateCommentsForSetters
		CopyrightTemplate'
	poolDictionaries:''
	category:'Interface-Browsers'
!

!CodeGeneratorTool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    This utility class contains various code generation facilites;
    these were extracted from the old and newBrowser.
    There is probably more to come...

    Note: being refactored into separate per-language generators

    [author:]
        Claus Gittiner
"
! !

!CodeGeneratorTool class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!CodeGeneratorTool class methodsFor:'code generation'!

createAccessMethodsFor:aCollectionOfVarNames in:aClass withChange:withChange asValueHolder:asValueHolder readersOnly:readersOnly writersOnly:writersOnly
    "create accessors in aClass"

    ^ self new 
        createAccessMethodsFor:aCollectionOfVarNames 
        in:aClass 
        withChange:withChange 
        asValueHolder:asValueHolder 
        readersOnly:readersOnly 
        writersOnly:writersOnly
!

createApplicationCodeFor:aClass
    "create an empty application framework"

    ^ self new createApplicationCodeFor:aClass
!

createClassResponsibleProtocolFor:aClass
    "create stubs for the required protocol"

    ^ self new createClassResponsibleProtocolFor:aClass
!

createClassTypeTestMethodsIn:aClass forClasses:subClasses
    "create a #isXXX test methods (I'm tired of typing)"

    ^ self new createClassTypeTestMethodsIn:aClass forClasses:subClasses
!

createDocumentationMethodsFor:aClass
    "create empty documentation methods"

    ^ self new createDocumentationMethodsFor:aClass
!

createEnumTypeCodeFor:aClass
    ^ self new createEnumTypeCodeFor:aClass
!

createInitializationMethodIn:aClass
    "create a #initialize methods (I'm tired of typing)"

    ^ self new createInitializationMethodIn:aClass
!

createInitializedInstanceCreationMethodsIn:aClass
    "create a #new and #initialize methods (I'm tired of typing)"

    ^ self new createInitializedInstanceCreationMethodsIn:aClass
!

createIsAbstractMethodIn:aClass
    "create a #isABstract query method (I'm tired of typing)"

    ^ self new createIsAbstractMethodIn:aClass
!

createParametrizedInstanceCreationMethodsNamed:selector in:aClass
    "create a #selector instance creation method (I'm tired of typing)"

    ^ self new createParametrizedInstanceCreationMethodsNamed:selector in:aClass
!

createRedefinedInstanceCreationMethodsIn:aClass
    "create a redefined #new method"

    ^ self new createRedefinedInstanceCreationMethodsIn:aClass
!

createSingletonPatternInstanceCreationMethodsIn:aClass usingVariable:varName
    "create redefined #new method for singleton pattern"

    ^ self new createSingletonPatternInstanceCreationMethodsIn:aClass usingVariable:varName

    "Created: / 10-02-2011 / 16:32:43 / cg"
!

createStandaloneStartupCodeFor:aClass
    "create an empty console application framework"

    ^ self new createStandaloneStartupCodeFor:aClass

    "Created: / 19-08-2011 / 01:58:57 / cg"
!

createStartupCodeFor:aClass forStartOf:anApplicationClassOrNil
    "create standAloneStartup code"

    ^ self new createStartupCodeFor:aClass forStartOf:anApplicationClassOrNil
!

createTestCaseSampleCodeFor:aClass
    "create an (almost) empty testCase class"

    ^ self new createTestCaseSampleCodeFor:aClass
!

createVisitorMethodsIn:visitedClass andVisitorClass:visitorClass
    "create acceptVisitor: in visitedClass and acceptXXX in visitorClass. (I'm tired of typing)"

    ^ self new createVisitorMethodsIn:visitedClass andVisitorClass:visitorClass
!

createWebApplicationCodeFor:aClass
    "create an empty webApplication framework"

    ^ self new createWebApplicationCodeFor:aClass
!

createWebServiceCodeFor:aClass
    "create an empty webService framework"

    ^ self new createWebServiceCodeFor:aClass
!

createWidgetCodeFor:aClass
    "create usually required widget code (redraw, model update, event handling)"

    ^ self new createWidgetCodeFor:aClass
!

initialMenuSpecMethodSourceForApplications
    "return code for a menuSpec with typical stuff in it"

    self subclassResponsibility
!

initialPageMenuSpecMethodSourceForWebApplications
    "return code for a menuSpec with typical stuff in it"

    self subclassResponsibility

    "
     SmalltalkCodeGeneratorTool initialPageMenuSpecMethodSourceForWebApplications
    "
!

initialPageSpecMethodSourceForWebApplications
    "return an empty pageSpec"

    self subclassResponsibility
!

initialToolbarMenuSpecMethodSource
    "return a menuSpec with typical stuff in it"

    self subclassResponsibility

    "
     SmalltalkCodeGenerator initialToolbarMenuSpecMethodSource
    "
!

initialWindowSpecMethodSourceForApplications
    "return an empty windowSpec with an initial menubar in it"

    self subclassResponsibility

    "
     SmalltalkCodeGeneraotTool initialWindowSpecMethodSourceForApplications
    "
!

initialWindowSpecMethodSourceForDialogs
    "return an empty windowSpec for dialogs"

    self subclassResponsibility

    "
     SmalltalkCodeGeneraotTool initialWindowSpecMethodSourceForDialogs
    "
! !

!CodeGeneratorTool class methodsFor:'code generation-basic'!

createAccessMethodsFor:aCollectionOfVarNames in:aClass withChange:withChange asValueHolder:asValueHolder readersOnly:readersOnly writersOnly:writersOnly lazyInitialization:lazyInitialization
    "workhorse for creating access methods for instvars."

    ^ self new 
        createAccessMethodsFor:aCollectionOfVarNames in:aClass withChange:withChange asValueHolder:asValueHolder readersOnly:readersOnly writersOnly:writersOnly lazyInitialization:lazyInitialization
! !

!CodeGeneratorTool class methodsFor:'code generation-individual methods'!

createAcceptVisitorMethod:selector in:aClass
    "create an acceptVisitor: method
     (I'm tired of typing)"

    ^ self new createAcceptVisitorMethod:selector in:aClass
!

createAcceptVisitorMethodIn:aClass
    "create an acceptVisitor: method
     (I'm tired of typing)"

    ^ self new createAcceptVisitorMethodIn:aClass
!

createAspectMethodFor:anAspectSymbol in:aClass
    "create an aspect method."

    ^ self new createAspectMethodFor:anAspectSymbol in:aClass
!

createCopyrightMethodFor:aClass
    "add copyright method containing your/your companies
     copyright template but only if not already present.
     this is only added, if specified in the 
     COPYRIGHT_TEMPLATE_FILE resources."

    ^ self new createCopyrightMethodFor:aClass
!

createDocumentationMethodFor:aClass
    "add documentation method containing doc template
     but only if not already present."

    ^ self new createDocumentationMethodFor:aClass
!

createExamplesMethodFor:aClass
    "add examples method containing examples template
     but only if not already present."

    ^ self new createExamplesMethodFor:aClass
!

createFalseReturnMethodFor:aSelector category:cat in:aClass
    "add a ^ false method;
     but only if not already present."

    ^ self new createFalseReturnMethodFor:aSelector category:cat in:aClass
!

createImageSpecMethodFor:anImage comment:comment in:aClass selector:sel
    ^ self new createImageSpecMethodFor:anImage comment:comment in:aClass selector:sel
!

createInitialHistoryMethodFor:aClass
    "add history method containing created-entry
     but only if not already present."

    ^ self new createInitialHistoryMethodFor:aClass
!

createInstanceCreationMethodWithSetupFor:selector category:category in:aMetaClass
    "add an inst-creation method"

    ^ self new createInstanceCreationMethodWithSetupFor:selector category:category in:aMetaClass
!

createMultiSetterInstanceCreationMethodFor:aCollectionOfVarNames in:aClass
    "create a multi-setter instance creator method for instvars.
     This creates a multi setter method (a:val1 b:val2 c:val3...)
     and a corresponding new method on the class side."

    ^ self new createMultiSetterInstanceCreationMethodFor:aCollectionOfVarNames in:aClass
!

createMultiSetterMethodFor:aCollectionOfVarNames in:aClass
    "create a multi-setter method (a:val1 b:val2 c:val3...) for instvars."

    ^ self new createMultiSetterMethodFor:aCollectionOfVarNames in:aClass
!

createSubclassResponsibilityMethodFor:aSelector category:cat in:aClass
    "add a subclassResponsibility method;
     but only if not already present."

    ^ self new createSubclassResponsibilityMethodFor:aSelector category:cat in:aClass
!

createUpdateMethodIn:aClass
    "create an update:with:from:-method
     (I'm tired of typing)"

    ^ self new createUpdateMethodIn:aClass
!

createVersionMethodFor:aClass
    "add a version method containing RCS template
     but only if not already present and it's not a private class."

    ^ self new createVersionMethodFor:aClass

    "Modified (comment): / 21-08-2012 / 11:55:15 / cg"
! !

!CodeGeneratorTool class methodsFor:'code generation-menus'!

createActionMethodFor:aSelector in:aClass category:aCategory redefine:redefine
    self subclassResponsibility
!

createAspectMethodFor:aSelector in:aClass category:aCategory redefine:redefine
    self subclassResponsibility
! !

!CodeGeneratorTool class methodsFor:'compilation'!

compile:theCode forClass:aClass inCategory:cat 
    "install some code for a class.
     If refactory browser stuff is avaliable the refactory tools are used to support undo"

    self new compile:theCode forClass:aClass inCategory:cat
! !

!CodeGeneratorTool class methodsFor:'defaults'!

copyrightTemplate
    "return the contents of COPYRIGHT_TEMPLATE_FILE resources
     or a standard template"

    |fn copyrightHolder|

    CopyrightTemplate notNil ifTrue:[^ CopyrightTemplate].

    fn := SystemBrowser classResources at:#'COPYRIGHT_TEMPLATE_FILE' default:nil.
    fn notNil ifTrue:[
        fn := fn asFilename.
        fn exists ifTrue:[
            ^ fn contentsAsString.
        ].
    ].
    (OperatingSystem getDomainName endsWith:'exept.de') ifTrue:[
        copyrightHolder := 'eXept Sofware AG'.
    ] ifFalse:[
        copyrightHolder := '>>your company<<'.
    ].

    ^ ' COPYRIGHT (c) %1 by %2
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.  This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.' bindWith:(Date today year) with:copyrightHolder.
!

copyrightTemplate:aString
    "set the COPYRIGHT_TEMPLATE_FILE"

    CopyrightTemplate := aString.
! !

!CodeGeneratorTool class methodsFor:'interface specs'!

initialMenuSpecForApplications
    "return a menuSpec with typical stuff in it"

    "This resource specification was automatically generated by the CodeGeneratorTool."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:self andSelector:#initialMenuSpecForApplications
    "

    <resource: #menu>

    ^ #(#Menu
           #(
             #(#MenuItem
                #label: 'File'
                #translateLabel: true
                #submenu: 
                 #(#Menu
                     #(
                       #(#MenuItem
                          #label: 'New'
                          #translateLabel: true
                          #value: #menuNew
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Open...'
                          #translateLabel: true
                          #value: #menuOpen
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Save'
                          #translateLabel: true
                          #value: #menuSave
                      )
                       #(#MenuItem
                          #label: 'Save As...'
                          #translateLabel: true
                          #value: #menuSaveAs
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Exit'
                          #translateLabel: true
                          #value: #closeRequest
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: 'MENU_Help'
                #translateLabel: true
                #startGroup: #right
                #submenu: 
                 #(#Menu
                     #(
                       #(#MenuItem
                          #label: 'Documentation'
                          #translateLabel: true
                          #value: #openDocumentation
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'About this Application...'
                          #translateLabel: true
                          #value: #openAboutThisApplication
                      )
                    ) nil
                    nil
                )
            )
          ) nil
          nil
      )
!

initialPageMenuSpecForWebApplications
    "return a menuSpec with typical stuff in it"

    "This resource specification was automatically generated by the CodeGeneratorTool."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:self andSelector:#initialPageMenuSpecForWebApplications
    "

    <resource: #menu>

    ^ #(#Menu
           #(
             #(#MenuItem
                #label: 'File'
                #translateLabel: true
                #submenu: 
                 #(#Menu
                     #(
                       #(#MenuItem
                          #label: 'New'
                          #translateLabel: true
                          #value: #menuNew
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Open...'
                          #translateLabel: true
                          #value: #menuOpen
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Save'
                          #translateLabel: true
                          #value: #menuSave
                      )
                       #(#MenuItem
                          #label: 'Save As...'
                          #translateLabel: true
                          #value: #menuSaveAs
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Exit'
                          #translateLabel: true
                          #value: #closeRequest
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: 'MENU_Help'
                #translateLabel: true
                #startGroup: #right
                #submenu: 
                 #(#Menu
                     #(
                       #(#MenuItem
                          #label: 'Documentation'
                          #translateLabel: true
                          #value: #openDocumentation
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'About this Application...'
                          #translateLabel: true
                          #value: #openAboutThisApplication
                      )
                    ) nil
                    nil
                )
            )
          ) nil
          nil
      )
!

initialPageSpecForWebApplications
    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:self andSelector:#initialPageSpecForWebApplications
    "

    <resource: #canvas>

    ^ #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: '%1'
              #layout: #(#LayoutFrame 204 0 162 0 503 0 461 0)
              #label: '%1'
              #min: #(#Point 10 10)
              #max: #(#Point 1024 768)
              #bounds: #(#Rectangle 204 162 504 462)
              #menu: #pageMenu
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: #()
          )
      )

    "Modified: / 14-07-2011 / 16:44:20 / cg"
!

initialToolbarMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:CodeGeneratorTool andSelector:#initialToolbarMenuSpec
     (Menu new fromLiteralArrayEncoding:(CodeGeneratorTool initialToolbarMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Reload'
            itemValue: menuReload
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary reload24x24Icon)
          )
         )
        nil
        nil
      )
!

initialWindowSpecForApplications
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodeGeneratorTool andSelector:#initialWindowSpecForApplications
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: initialWindowSpecForApplications
        window: 
       (WindowSpec
          label: '%1'
          name: '%1'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Hello World'
              name: 'Label1'
              layout: (LayoutFrame 0 0.0 60 0 0 1.0 219 0)
              translateLabel: true
            )
           )
         
        )
      )

    "Modified: / 07-05-2010 / 14:21:48 / cg"
!

initialWindowSpecForApplications2
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodeGeneratorTool andSelector:#initialWindowSpecForApplications2
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: initialWindowSpecForApplications2
        window: 
       (WindowSpec
          label: '%1'
          name: '%1'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'ToolBar1'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 36 0)
              menu: toolbarMenu
              textDefault: true
            )
           (ViewSpec
              name: 'Box1'
              layout: (LayoutFrame 1 0 36 0 0 1 -26 1)
              level: 1
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Hello World'
                    name: 'Contents'
                    layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                    translateLabel: true
                  )
                 )
               
              )
            )
           (ViewSpec
              name: 'Box2'
              layout: (LayoutFrame 0 0 -26 1 0 1 0 1)
              level: 1
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'InfoLabel'
                    name: 'Label2'
                    layout: (LayoutFrame 0 0 -26 1 -1 1 0 1)
                    level: -1
                    translateLabel: true
                    labelChannel: infoLabelHolder
                    adjust: left
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

initialWindowSpecForDialogs
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodeGeneratorTool andSelector:#initialWindowSpecForDialogs
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: initialWindowSpecForDialogs
        window: 
       (WindowSpec
          label: '%1'
          name: '%1'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (HorizontalPanelViewSpec
              name: 'buttonPanel'
              layout: (LayoutFrame 0 0.0 -40 1 0 1.0 0 1.0)
              horizontalLayout: spreadSpaceMax
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'cancelButton'
                    translateLabel: true
                    tabable: true
                    model: cancel
                    extent: (Point 125 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'okButton'
                    translateLabel: true
                    tabable: true
                    model: accept
                    isDefault: true
                    extent: (Point 125 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )

    "Modified: / 07-05-2010 / 14:21:55 / cg"
! !

!CodeGeneratorTool class methodsFor:'private'!

canUseRefactoringSupport
    "check if refactory browser stuff is avaliable"

    ^ (Smalltalk at: #'stx_goodies_refactoryBrowser_changes') notNil 
        and:[ (Smalltalk at: #'stx_goodies_refactoryBrowser_browser') notNil
        and:[ UserPreferences current useRefactoringSupport ] ]

    "
    CodeGeneratorTool canUseRefactoringSupport
    "

    "Modified: / 13-02-2016 / 15:05:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodNameTemplateFor:aSelector
    self subclassResponsibility
! !

!CodeGeneratorTool class methodsFor:'queries'!

isAbstract
    ^ self == CodeGeneratorTool
! !

!CodeGeneratorTool class methodsFor:'utilities'!

missingRequiredProtocolFor:aClass
    "return the missing required protocol; 
     that is the set of selectors which send #subclassResponsibility in a superclass and 
     have no implementation in aClass or in any class between aClass and that superclass"

    |requiredSelectors implementedSelectors|

    aClass isAbstract ifTrue:[
        "abstract classes are not responsible for methods to be defined in subclasses"    
        ^ #().
    ].

    requiredSelectors := IdentitySet new.
    implementedSelectors := IdentitySet withAll:(aClass methodDictionary keys).

    aClass allSuperclassesDo:[:eachSuperClass |
        eachSuperClass methodDictionary keysAndValuesDo:[:eachSelector :eachMethod |
            (eachMethod sendsAny:#( #subclassResponsibility #subclassResponsibility: )) ifTrue:[
                (implementedSelectors includes:eachSelector) ifFalse:[
                    requiredSelectors add:eachSelector.
                ]
            ] ifFalse:[
                (requiredSelectors includes:eachSelector) ifFalse:[
                    implementedSelectors add:eachSelector.
                ].
            ].
        ]
    ].
    ^ requiredSelectors

    "Modified: / 08-08-2011 / 18:44:58 / cg"
    "Modified: / 10-01-2015 / 06:46:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeGeneratorTool class methodsFor:'utilities - source code'!

methodTemplate
    "return a method definition template string"

    ^ ''
!

methodTemplateForDocumentation
    "return a method definition template string for a documentation method"

    ^ self methodTemplate
!

methodTemplateForPackageDocumentation
    "return a documentation method definition template string for a package"

    ^ self methodTemplateForDocumentation

    "Created: / 18-11-2016 / 10:51:39 / cg"
! !

!CodeGeneratorTool methodsFor:'bulk changes'!

addChange:aChange
    compositeChangeCollector addChange:aChange
!

executeCollectedChangesNamed:name
    "if both the compositeChangeCollector and I myself think, that it should be confirmed,
     the let user do it - I am not sure, if the heuristics here is useful;
     it might be better to let the generator decide (for example, if it does high-impact
     changes, as opposed to simple ones)"

    compositeChangeCollector notNil ifTrue:[
        compositeChangeNesting := compositeChangeNesting - 1.
        compositeChangeNesting == 0 ifTrue:[
            compositeChangeCollector name:name.
            compositeChangeCollector changesSize == 0 ifTrue:[
                self information:'Nothing generated.'.
            ] ifFalse:[
                "JV@2012-04-04: Here used to be a code for confirming changes.
                 The has moved to RefactoryChangeManager so all refactorings
                 are also subject to confirmation (is enabled in UserPreferences)"
                RefactoryChangeManager instance performChange: compositeChangeCollector
            ].
            compositeChangeCollector := nil.
        ]
    ]

    "Modified (comment): / 04-08-2011 / 17:30:27 / cg"
    "Modified (format): / 04-04-2012 / 16:35:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startCollectChanges
    (self canUseRefactoringSupport) ifTrue:[
        compositeChangeCollector isNil ifTrue:[
            compositeChangeCollector := CompositeRefactoryChange new.
            compositeChangeNesting := 0.
        ].
        compositeChangeNesting := compositeChangeNesting + 1.
    ]
! !

!CodeGeneratorTool methodsFor:'code generation'!

createAccessMethodsFor:aCollectionOfVarNames in:aClass withChange:withChange asValueHolder:asValueHolder readersOnly:readersOnly writersOnly:writersOnly
    "create accessors in aClass"

    self
        createAccessMethodsFor:aCollectionOfVarNames 
        in:aClass 
        withChange:withChange 
        asValueHolder:asValueHolder 
        readersOnly:readersOnly 
        writersOnly:writersOnly 
        lazyInitialization:false
!

createApplicationCodeFor:aClass
    "create an empty application framework"

    |nonMetaClass metaClass className txt isDialog 
     categoryForMenuActionsMethods compileTemplateAction|

    self startCollectChanges.

    categoryForMenuActionsMethods := userPreferences categoryForMenuActionsMethods.

    nonMetaClass := aClass theNonMetaclass.
    metaClass := aClass theMetaclass.
    className := nonMetaClass name.

    isDialog := (nonMetaClass isSubclassOf:SimpleDialog).

    "/ add a windowSpec method for an empty applicationWindow,
    "/ with a menuPanel.

    (metaClass includesSelector:#windowSpec) ifFalse:[
        isDialog ifTrue:[
            txt := self class initialWindowSpecMethodSourceForDialogs.
        ] ifFalse:[
            txt := self class initialWindowSpecMethodSourceForApplications.
        ].
        self
            compile:(txt bindWith:className)
            forClass:metaClass 
            inCategory:'interface specs'.
    ].

    compileTemplateAction := 
        [:selector :category |
            (nonMetaClass includesSelector:selector) ifFalse:[
                |codeTemplateSelector|

                codeTemplateSelector := ('codeFor_',(selector upTo:$:)) asSymbol.
                txt := self perform:codeTemplateSelector.
                self
                    compile:txt
                    forClass:nonMetaClass 
                    inCategory:(category = '*' ifTrue:categoryForMenuActionsMethods ifFalse:category).
            ]
        ].

    #(
        #'postBuildWith:'   'initialization & release'
        #'postOpenWith:'    'initialization & release'
    ) pairWiseDo:compileTemplateAction.

    isDialog ifFalse:[
        "/ add a topMenu method 

        (metaClass includesSelector:#mainMenu) ifFalse:[
            txt := self class initialMenuSpecMethodSourceForApplications.
            self
                compile:(txt bindWith:className)
                forClass:metaClass 
                inCategory:'menu specs'.
        ].
        (metaClass includesSelector:#toolbarMenu) ifFalse:[
            txt := self class initialToolbarMenuSpecMethodSource.
            self
                compile:(txt bindWith:className)
                forClass:metaClass 
                inCategory:'menu specs'.
        ].

        #(
            #'hasUnsavedChanges'        'private queries'
            #'closeRequest'             'initialization & release'
            #'closeDownViews'           'initialization & release'
            #'menuReload'               '*'
            #'menuSaveAs'               '*'
            #'menuNew'                  '*'
            #'menuOpen'                 '*'
            #'menuSave'                 '*'
            #'doSaveAs'                 '*'
            #'openDocumentation'        '*'
            #'openAboutThisApplication' '*'
        ) pairWiseDo:compileTemplateAction.
    ].

    isDialog ifTrue:[
        #(
            #'closeAccept'      'user actions'
        ) pairWiseDo:compileTemplateAction.
    ].

    self executeCollectedChangesNamed:('Add Application Code for ' , className).

    "Modified: / 27-10-2006 / 10:21:58 / cg"
!

createClassInitializeMethodIn:aClass
    "create a #initialize method on the class side (I'm tired of typing)"

    self subclassResponsibility
!

createClassResponsibleProtocolFor:aClass
    "create stubs for the required protocol"

    |nonMetaClass metaClass className|

    nonMetaClass := aClass theNonMetaclass.
    metaClass := aClass theMetaclass.
    className := nonMetaClass name.

    self startCollectChanges.

    self privCreateClassResponsibleProtocolFor:nonMetaClass.
    self privCreateClassResponsibleProtocolFor:metaClass.

    self executeCollectedChangesNamed:('Add Required Protocol to ' , className).
!

createClassTypeTestMethodsIn:aClass forClasses:subClasses
    "create a #isXXX test methods (I'm tired of typing)"

    self subclassResponsibility
!

createDocumentationMethodsFor:aClass
    "create empty documentation methods"

    |nonMetaClass metaClass className|

    nonMetaClass := aClass theNonMetaclass.
    metaClass := aClass theMetaclass.
    className := nonMetaClass name.

    self startCollectChanges.

"/    self createVersionMethodFor:metaClass.
    self createCopyrightMethodFor:metaClass.
    self createDocumentationMethodFor:metaClass.
    self createExamplesMethodFor:metaClass.
    "/ self createInitialHistoryMethodFor:metaClass.

    self executeCollectedChangesNamed:('Add Documentation to ' , className).
!

createEnumTypeCodeFor:aClass
    self subclassResponsibility
!

createExamplesMethodForViewClass:aClass
    "create an examples method"

    self subclassResponsibility
!

createInitializationMethodIn:aClass
    "create a #initialize methods (I'm tired of typing)"

    self subclassResponsibility
!

createInitializedInstanceCreationMethodsIn:aClass
    "create a #new and #initialize methods (I'm tired of typing)"

    self subclassResponsibility
!

createIsAbstractMethodIn:aClass
    "create a #isAbstract query method (I'm tired of typing)"

    self subclassResponsibility
!

createParametrizedInstanceCreationMethodsNamed:selector in:aClass
    "create a #selector instance creation method (I'm tired of typing)"

    self subclassResponsibility
!

createPoolInitializationCodeFor:aClass
    self subclassResponsibility
!

createRedefinedInstanceCreationMethodsIn:aClass
    "create a redefined #new methods"

    self subclassResponsibility
!

createSingletonPatternInstanceCreationMethodsIn:aClass usingVariable:varName
    "create redefined #new methods for a singleton pattern"

    self subclassResponsibility

    "Created: / 10-02-2011 / 16:32:36 / cg"
!

createStandaloneStartupCodeFor:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

!

createStandardPrintOnMethodIn:aClass
    "create a #printOn: method (I'm tired of typing)"

    self subclassResponsibility
!

createStartupCodeFor:aClass forStartOf:anApplicationClassOrNil
    "create startup code (main)"

    self subclassResponsibility
!

createTestCaseSampleCodeFor:aClass
    "create an (almost) empty testCase class"

    self subclassResponsibility
!

createVisitorMethodsIn:visitedClass andCompilerClass:visitorClass
    "   
        This is much like createVisitorMethodsIn:andVisitorClass:,
        but generates 
            acceptVisitor:forEffect:
            and
            visit<NODE>:forEffect:
        in visit* methods.
    "

    |sel superSel |

    self assert:( visitedClass isMeta not ).
    self assert:( visitorClass isMeta not ).

    self startCollectChanges.

    sel := ('visit' , visitedClass nameWithoutPrefix , ':').
    superSel := ('visit' , visitedClass superclass nameWithoutPrefix , ':').

    (visitedClass includesSelector:#acceptVisitor:forEffect:) ifFalse:
        [self addChange:
            (CodeGenerator new
                class: visitedClass;
                protocol: 'visiting';
                source: ('acceptVisitor: visitor forEffect: effect
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern) and given effect"

    "stub code automatically generated - please change if required"

    ^visitor `@sel: self forEffect: effect');
                replace: '`@sel:' with: sel asSymbol;
                change)
        ].




    (visitorClass includesSelector:(sel, 'forEffect:') asSymbol) ifFalse:[
        self addChange:
            (CodeGenerator new
                class: visitorClass;
                protocol: 'visiting';
                source: ('`@sel: anObject forEffect: effect
    "dispatched back from the visited object (visitor pattern)"

    ^ self `@superSel: anObject forEffect: effect');
                replace: '`@sel:' with: sel asSymbol;
                replace: '`@superSel:' with: superSel asSymbol;
                change)
    ].


    (visitorClass includesSelector:#'visit:') ifFalse:[
        self 
            compile:
('visit:anObject 
    "visit anObject (visitor pattern).
     The object should call back one of my visitXXXX methods."

    ^ anObject acceptVisitor:self
')
            forClass:visitorClass 
            inCategory:'visiting'.
    ].

    self executeCollectedChangesNamed:('Create Compiler Visiting Methods').

    "Created: / 20-03-2010 / 10:49:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createVisitorMethodsIn:visitedClass andVisitorClass2:visitorClass
    "   
        This is much like createVisitorMethodsIn:andVisitorClass:,
        but generates 
            self visitSuperclass: anObject
        in visit* methods.
    "

    |sel superSel |

    self assert:( visitedClass isMeta not ).
    self assert:( visitorClass isMeta not ).

    self startCollectChanges.

    sel := ('visit' , visitedClass nameWithoutPrefix , ':').
    superSel := ('visit' , visitedClass superclass nameWithoutPrefix , ':').
    self createAcceptVisitorMethod:sel in:visitedClass.

    (visitorClass includesSelector:sel) ifFalse:[
        self addChange:
            (CodeGenerator new
                class: visitorClass;
                protocol: 'visiting';
                source: ('`@sel: anObject 
    "dispatched back from the visited %2-object (visitor pattern)"

    ^ self `@superSel: anObject');
                replace: '`@sel:' with: sel asSymbol;
                replace: '`@superSel:' with: superSel asSymbol;
                change)
    ].


    (visitorClass includesSelector:#'visit:') ifFalse:[
        self 
            compile:
('visit:anObject 
    "visit anObject (visitor pattern).
     The object should call back one of my visitXXXX methods."

    ^ anObject acceptVisitor:self
')
            forClass:visitorClass 
            inCategory:'visiting'.
    ].

    self executeCollectedChangesNamed:('Add Visitor Pattern').

    "Created: / 07-07-2009 / 19:53:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

createVisitorMethodsIn:visitedClass andVisitorClass:visitorClass
    "create acceptVisitor: in visitedClass and acceptXXX in visitorClass. (I'm tired of typing)"

    self subclassResponsibility
!

createVisitorMethodsIn:arg1 andVisitorClass:arg2 withParameter:arg3 withSuper:arg4 
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility
!

createWebApplicationCodeFor:aClass
    "create an empty webApplication framework"

    self subclassResponsibility
!

createWebServiceCodeFor:aClass
    "create an empty webService framework"

    self subclassResponsibility
!

createWidgetCodeFor:aClass
    "create usually required widget code (redraw, model update, event handling)"

    self subclassResponsibility
! !

!CodeGeneratorTool methodsFor:'code generation-basic'!

createAccessMethodsFor:aCollectionOfVarNames in:aClass withChange:withChange asValueHolder:asValueHolder readersOnly:readersOnly writersOnly:writersOnly lazyInitialization:lazyInitialization
    "workhorse for creating access methods for instvars."

    self subclassResponsibility
!

createCollectionAccessMethodsFor:aCollectionOfVarNames in:aClass withChange:withChange
    self subclassResponsibility
!

createGetterFor:aVarName in:aClass 
    self 
        createAccessMethodsFor:{ aVarName} in:aClass 
        withChange:false asValueHolder:false readersOnly:true writersOnly:false 
        lazyInitialization:false
!

createSetterFor:aVarName in:aClass 
    self 
        createAccessMethodsFor:{ aVarName} in:aClass 
        withChange:false asValueHolder:false readersOnly:false writersOnly:true 
        lazyInitialization:false

    "
    
    "
!

createValueHoldersFor:aCollectionOfVarNames in:aClass lazyInitialization:lazyInitialization
    "workhorse for creating access methods for instvars."

    self subclassResponsibility
! !

!CodeGeneratorTool methodsFor:'code generation-individual methods'!

createAcceptVisitorMethod:selector in:aClass
    "create an acceptVisitor: method
     (I'm tired of typing)"

    self subclassResponsibility
!

createAcceptVisitorMethodIn:aClass
    "create an acceptVisitor: method
     (I'm tired of typing)"

    self subclassResponsibility
!

createAspectMethodFor:anAspectSymbol in:aClass
    "create an aspect method."

    self subclassResponsibility
!

createCopyrightMethodFor:aClass
    "add copyright method containing your/your companies
     copyright template but only if not already present.
     this is only added, if specified in the 
     COPYRIGHT_TEMPLATE_FILE resources."

    |fn copyRightText|

    (aClass includesSelector:#copyright) ifFalse:[
        fn := SystemBrowser classResources at:#'COPYRIGHT_TEMPLATE_FILE' default:nil.
        fn notNil ifTrue:[
            fn := fn asFilename.
            fn exists ifTrue:[
                copyRightText := fn contentsAsString.
                self createCopyrightMethodFor:copyRightText for:aClass
            ]
        ].
    ].
!

createCopyrightMethodFor:copyRightText for:aClass
    "add copyright method containing text,
     but only if not already present."

    self subclassResponsibility
!

createDocumentationMethodFor:aClass
    "add documentation method containing doc template
     but only if not already present."

    self subclassResponsibility
!

createExamplesMethodFor:aClass
    "add examples method containing examples template
     but only if not already present."

    self subclassResponsibility
!

createFalseReturnMethodFor:aSelector category:cat in:aClass
    "add a ^false method;
     but only if not already present."

    self subclassResponsibility
!

createImageSpecMethodFor:anImage comment:comment in:aClass selector:sel
    self subclassResponsibility
!

createInitialHistoryMethodFor:aClass
    "add history method containing created-entry
     but only if not already present."

    self subclassResponsibility
!

createInstanceCreationMethodWithSetupFor:selector category:category in:aMetaClass
    "add an inst-creation method"

    self subclassResponsibility
!

createMultiSetterInstanceCreationMethodFor:aCollectionOfVarNames in:aClass
    "create a multi-setter instance creator method for instvars.
     This creates a multi setter method (a:val1 b:val2 c:val3...)
     and a corresponding new method on the class side."

    self subclassResponsibility
!

createMultiSetterMethodFor:aCollectionOfVarNames in:aClass
    "create a multi-setter method (a:val1 b:val2 c:val3...) for instvars."

    self subclassResponsibility
!

createShouldImplementMethodFor:aSelector category:cat in:aClass
    "add a shouldImplement method;
     but only if not already present."

    self subclassResponsibility
!

createSubclassResponsibilityMethodFor:aSelector category:cat in:aClass
    "add a subclassResponsibility method;
     but only if not already present."

    self subclassResponsibility
!

createUpdateMethodIn:aClass
    "create an update:with:from:-method
     (I'm tired of typing)"

    self subclassResponsibility
!

createVersionMethodFor:aClass
    <resource: #obsolete>

    "add version method containing RCS template
     but only if not already present and its not a private class."

    self subclassResponsibility
! !

!CodeGeneratorTool methodsFor:'code templates'!

codeFor_classInitialize
    self subclassResponsibility
!

codeFor_closeAccept
    self subclassResponsibility
!

codeFor_closeDownViews
    self subclassResponsibility
!

codeFor_closeRequest
    self subclassResponsibility

    "Created: / 27-10-2006 / 10:01:06 / cg"
!

codeFor_doSaveAs
    ^ self codeFor_emptyMenuActionCodeFor:#doSaveAs menuItem:'save/saveAs'

    "Created: / 27-10-2006 / 10:22:06 / cg"
!

codeFor_emptyMenuActionCodeFor:selector menuItem:item
    self subclassResponsibility
!

codeFor_hasUnsavedChanges
    self subclassResponsibility

    "Created: / 27-10-2006 / 10:00:36 / cg"
!

codeFor_menuNew
    ^ self codeFor_emptyMenuActionCodeFor:#menuNew menuItem:'new'

    "Created: / 27-10-2006 / 10:17:08 / cg"
!

codeFor_menuOpen
    ^ self codeFor_emptyMenuActionCodeFor:#menuOpen menuItem:'open'

    "Created: / 27-10-2006 / 10:17:18 / cg"
!

codeFor_menuReload
    ^ self codeFor_emptyMenuActionCodeFor:#menuReload menuItem:'reload'
!

codeFor_menuSave
    ^ self codeFor_emptyMenuActionCodeFor:#menuSave menuItem:'save'

    "Created: / 27-10-2006 / 10:17:25 / cg"
!

codeFor_menuSaveAs
    self subclassResponsibility
!

codeFor_openAboutThisApplication
    self subclassResponsibility
!

codeFor_openDocumentation
    self subclassResponsibility
!

codeFor_postBuildWith
    self subclassResponsibility
!

codeFor_postOpenWith
    self subclassResponsibility
!

codeFor_shouldImplementFor:selector inClass:aClass
    "used in the 'generate required protocol' to generate a shouldImplement-sending
     method for each subclassClassresponsibility method above aClass."

    self subclassResponsibility
!

codeFor_standAloneApplicationRegistryPath
    ^ self codeFor_standAloneApplicationRegistryPathFor:nil

    "Created: / 19-08-2011 / 02:13:14 / cg"
!

codeFor_standAloneApplicationRegistryPathFor:aClass
    self subclassResponsibility

    "Created: / 21-01-2012 / 11:23:47 / cg"
!

codeFor_standAloneApplicationUUID
    self subclassResponsibility

    "Created: / 19-08-2011 / 02:12:51 / cg"
!

codeFor_standAloneMainFor:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

codeFor_standAloneUsage
    self subclassResponsibility

    "Created: / 19-08-2011 / 02:21:52 / cg"
!

code_forWidget_buttonPress
    self subclassResponsibility
!

code_forWidget_initialize
    self subclassResponsibility
!

code_forWidget_keyPress
    self subclassResponsibility
!

code_forWidget_redraw
    self subclassResponsibility
!

code_forWidget_sizeChanged
    self subclassResponsibility
!

code_forWidget_update
    self subclassResponsibility
! !

!CodeGeneratorTool methodsFor:'compilation'!

compile:theCode forClass:aClass inCategory:cat 
    "install some code for a class.
     If refactory browser stuff is avaliable the refactory tools are used to support undo"

    self
        compile:theCode forClass:aClass inCategory:cat 
        skipIfSame:true
!

compile:theCode forClass:aClass inCategory:categoryOrNil skipIfSame:skipIfSame 
    "install some code for a class.
     If refactory browser stuff is avaliable the refactory tools are used to support undo"

    |change compiler selector oldMethod category|

    category := categoryOrNil.

    skipIfSame ifTrue:[
        "JV: Do not use class's compilerClass, it may differ from
         the compiler of this generator's language. For instance,
         when compiling Smalltalk extension to Java or JavaScript class.
         So, use proper compiler for language the receiver is generator for,
         i.e., Compiler for SmalltalkCodeGenerator, JavaScriptCompiler for
         JavaScriptCodeGenerator..."

        "/ this is not the real compilation - but a prescan for the selector
        compiler := self compilerClass new.
        compiler parseMethod:theCode in:aClass ignoreErrors:true ignoreWarnings:true.

        selector := compiler selector.
        selector notNil ifTrue:[
            oldMethod := aClass compiledMethodAt:selector.
            oldMethod notNil ifTrue:[
                oldMethod source = theCode ifTrue:[^ self ]. "/ the same.
            
                categoryOrNil isNil ifTrue:[
                    "/ if no category given, take the existing one.
                    category := oldMethod category.
                ].
            ].
        ].
    ].

    category isNil ifTrue:[
        category := Compiler defaultMethodCategory.
    ].    

    self canUseRefactoringSupport ifFalse:[
        "/ compile immediately
        ^ aClass compile:theCode classified:category.
    ].

    change := InteractiveAddMethodChange compile:(theCode asString) in:aClass classified:category.
    change controller:(CompilationErrorHandlerQuery query).

    compositeChangeCollector notNil ifTrue:[
        "/ if collecting, add to changes, to be executed as one change at the end.
        "/ In order to have only one change in the undo-list (instead of many)
        compositeChangeCollector addChange:change.
    ] ifFalse:[
        "/ do it now.
        RefactoryChangeManager performChange:change.
    ].
    
    "Modified: / 21-08-2006 / 18:39:06 / cg"
    "Modified (format): / 21-01-2012 / 10:40:59 / cg"
    "Modified (format): / 05-08-2014 / 21:06:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compilerClass
    "Return a real compiler classto use to compile code"

    ^ self subclassResponsibility

    "Created: / 05-08-2014 / 21:01:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeGeneratorTool methodsFor:'initialization'!

confirmChanges
    "if true, let user confirm complicated changes; if false, just do it"

    ^ confirmChanges ? true

    "Created: / 04-08-2011 / 17:31:45 / cg"
!

confirmChanges:aBoolean
    "if true, let user confirm complicated changes; if false, just do it"

    confirmChanges := aBoolean

    "Created: / 04-08-2011 / 17:26:47 / cg"
!

initialize
    userPreferences := UserPreferences current.
    generateComments := userPreferences generateComments.
! !

!CodeGeneratorTool methodsFor:'private'!

canUseRefactoringSupport
    "check if refactory browser stuff is avaliable"

     ^ self class canUseRefactoringSupport
!

privCreateClassResponsibleProtocolFor:aClass
    "create stubs for the required protocol.
     aClass may be a a MetaClass or a non-MetaClass"

    |requiredProtocol|

    requiredProtocol := self class missingRequiredProtocolFor:aClass.
    requiredProtocol do:[:eachSelector |
        |code implClass|

        implClass := aClass whichClassImplements:eachSelector.
        implClass == Object ifFalse:[
            code := self codeFor_shouldImplementFor:eachSelector inClass:aClass.

            self 
                compile:code
                forClass:aClass 
                inCategory:(implClass compiledMethodAt:eachSelector) category.
        ]
    ].
! !

!CodeGeneratorTool class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

