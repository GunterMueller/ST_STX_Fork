"
 COPYRIGHT (c) 2002 by eXept Software AG
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

ApplicationModel subclass:#TagsBrowser
	instanceVariableNames:'editedFileHolder commonAspects tagView tagList action tagsMenu
		menus tagsValid tagListGenerator'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File-Tags'
!

SelectionInListModelView subclass:#TagView
	instanceVariableNames:'application process fileName tagLineNr itemHeight'
	classVariableNames:'TypeInset'
	poolDictionaries:''
	privateIn:TagsBrowser
!

!TagsBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    a simple tag-support view, which can be plugged into another (file) application
    for indexing.
    Supports a bunch of languages somehow, but none really perfect.
    Uses ctags if present, if not, has naive fallback tag generation support.

    Good enough for me, doing occasional work in other languages (of course, is not able
    to compete with a specialized editor tools loke notepad++, emacs or similar.
"
! !

!TagsBrowser class methodsFor:'help specs'!

flyByHelpSpec
    ^ super flyByHelpSpec addPairsFrom:#(

#updateTagList
'Update (regenerate) the tag list'

#sortByName
'Sort by name (ignoring case and leading underscores)'

#sortByLineNumber
'Sort by line number'

#functionsOnly
'Show only Functions (see popup menu for more options)'

#structsOnly
'Show only Structures (see popup menu for more options)'

#toggleTagFilter
'Toggle name filter to show only tags which match a pattern'

#tagFilter
'Pattern to filter tags by name.\Multiple OR-patterns are separated by ";"'

    )

    "Created: / 06-10-2011 / 12:04:51 / cg"
! !

!TagsBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TagsBrowser andSelector:#windowSpec
     Tools::TagsBrowser new openInterface:#windowSpec
     Tools::TagsBrowser open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'TagsBrowser'
         name: 'TagsBrowser'
         min: (Point 10 10)
         max: (Point 1024 768)
         bounds: (Rectangle 0 0 300 337)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: topFit
             horizontalSpace: 3
             verticalSpace: 3
             elementsChangeSize: true
             component: 
            (SpecCollection
               collection: (
                (HorizontalPanelViewSpec
                   name: 'TagToolbarHorizontalPanel'
                   horizontalLayout: leftFit
                   verticalLayout: center
                   horizontalSpace: 3
                   verticalSpace: 3
                   ignoreInvisibleComponents: false
                   elementsChangeSize: true
                   component: 
                  (SpecCollection
                     collection: (
                      (MenuPanelSpec
                         name: 'ToolBar1'
                         level: 0
                         menu: toolBarMenu
                         extent: (Point 196 30)
                         usePreferredWidth: true
                         textDefault: true
                         useDynamicPreferredWidth: true
                       )
                      )
                    
                   )
                   extent: (Point 300 30)
                 )
                (HorizontalPanelViewSpec
                   name: 'TagFilterPanel'
                   visibilityChannel: tagFilterFieldVisibleHolder
                   horizontalLayout: leftFit
                   verticalLayout: center
                   horizontalSpace: 3
                   verticalSpace: 3
                   ignoreInvisibleComponents: false
                   elementsChangeSize: true
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Filter:'
                         name: 'Label1'
                         translateLabel: true
                         resizeForLabel: true
                         adjust: left
                         useDefaultExtent: true
                       )
                      (InputFieldSpec
                         name: 'TagFilterInputField'
                         activeHelpKey: tagFilter
                         model: tagFilterPatternHolder
                         immediateAccept: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnPointerLeave: true
                         extent: (Point 254 22)
                       )
                      )
                    
                   )
                   extent: (Point 300 30)
                 )
                (ArbitraryComponentSpec
                   name: 'Browser'
                   level: -1
                   menu: middleButtonMenu
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   miniScrollerHorizontal: true
                   miniScrollerVertical: false
                   hasBorder: false
                   component: tagView
                   extent: (Point 300 271)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!TagsBrowser class methodsFor:'menu specs'!

assemblerMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#assemblerMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser assemblerMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasAssemblerSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Local Labels (Style1: Starting with ".")'
	    translateLabel: true
	    isVisible: editedFileHasAssemblerSuffix
	    hideMenuOnActivated: false
	    indication: hideLocalLabels:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Local Labels (Style2: Not Starting with "_")'
	    translateLabel: true
	    isVisible: editedFileHasAssemblerSuffix
	    hideMenuOnActivated: false
	    indication: hideLocalLabels2:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Local Labels (Style3: "L[0-9]+")'
	    translateLabel: true
	    isVisible: editedFileHasAssemblerSuffix
	    hideMenuOnActivated: false
	    indication: hideLocalLabels3:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Data Labels'
	    translateLabel: true
	    isVisible: editedFileHasAssemblerSuffix
	    hideMenuOnActivated: false
	    indication: hideDataLabels:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Text Labels'
	    translateLabel: true
	    isVisible: editedFileHasAssemblerSuffix
	    hideMenuOnActivated: false
	    indication: hideTextLabels:
	  )
	 )
	nil
	nil
      )

    "Modified: / 13-05-2012 / 11:26:28 / cg"
!

cMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#cMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser cMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasCSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Classes, Functions && Variables Only'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    indication: classesFunctionsAndVariablesOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Classes Only'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    indication: classesOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Functions Only'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    indication: functionsOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Variables Only'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    indication: variablesOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Types Only'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    indication: typesOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Structs Only'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    indication: structsOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Defines Only'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    indication: definesOnly:
	  )
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasCSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Classes'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    hideMenuOnActivated: false
	    indication: hideClasses:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Functions'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    hideMenuOnActivated: false
	    indication: hideFunctions:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Variables'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    hideMenuOnActivated: false
	    indication: hideVariables:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Typedefs'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    hideMenuOnActivated: false
	    indication: hideTypedefs:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Structures'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    hideMenuOnActivated: false
	    indication: hideStructures:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Struct Members'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    hideMenuOnActivated: false
	    indication: hideStructMembers:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Defines'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    hideMenuOnActivated: false
	    indication: hideDefines:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Labels'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    hideMenuOnActivated: false
	    indication: hideLabels:
	  )
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasCSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Static'
	    translateLabel: true
	    isVisible: editedFileHasCSuffix
	    hideMenuOnActivated: false
	    indication: hideStatic:
	  )
	 )
	nil
	nil
      )
!

dartMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#javaMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser javaMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasDartSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Classes Only'
	    translateLabel: true
	    isVisible: editedFileHasDartSuffix
	    indication: dartClassesOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Methods Only'
	    translateLabel: true
	    isVisible: editedFileHasDartSuffix
	    indication: dartMethodsOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Classes && Methods Only'
	    translateLabel: true
	    isVisible: editedFileHasDartSuffix
	    indication: dartClassesAndMethodsOnly:
	  )
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasDartSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Packages'
	    translateLabel: true
	    isVisible: false "editedFileHasDartSuffix"
	    hideMenuOnActivated: false
	    indication: hideJavaPackages:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Classes'
	    translateLabel: true
	    isVisible: editedFileHasDartSuffix
	    hideMenuOnActivated: false
	    indication: hideDartClasses:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Interfaces'
	    translateLabel: true
	    isVisible: editedFileHasDartSuffix
	    hideMenuOnActivated: false
	    indication: hideDartInterfaces:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Methods'
	    translateLabel: true
	    isVisible: editedFileHasDartSuffix
	    hideMenuOnActivated: false
	    indication: hideDartMethods:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Fields'
	    translateLabel: true
	    isVisible: editedFileHasDartSuffix
	    hideMenuOnActivated: false
	    indication: hideDartFields:
	  )
	 )
	nil
	nil
      )

    "Modified: / 21-08-2012 / 20:49:32 / cg"
!

htmlMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#lispMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser lispMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: '-'
            isVisible: editedFileHasHtmlSuffix
          )
         (MenuItem
            enabled: tagTypesPresentHolder
            label: 'Anchors Only'
            translateLabel: true
            isVisible: editedFileHasHtmlSuffix
            indication: anchorsOnly:
          )
         (MenuItem
            enabled: tagTypesPresentHolder
            label: 'Headlines Only'
            translateLabel: true
            isVisible: editedFileHasHtmlSuffix
            indication: headlinesOnly:
          )
         )
        nil
        nil
      )
!

javaMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#javaMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser javaMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasJavaSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Classes Only'
	    translateLabel: true
	    isVisible: editedFileHasJavaSuffix
	    indication: javaClassesOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Methods OnLy'
	    translateLabel: true
	    isVisible: editedFileHasJavaSuffix
	    indication: javaMethodsOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Classes && Methods Only'
	    translateLabel: true
	    isVisible: editedFileHasJavaSuffix
	    indication: javaClassesAndMethodsOnly:
	  )
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasJavaSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Packages'
	    translateLabel: true
	    isVisible: editedFileHasJavaSuffix
	    hideMenuOnActivated: false
	    indication: hideJavaPackages:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Classes'
	    translateLabel: true
	    isVisible: editedFileHasJavaSuffix
	    hideMenuOnActivated: false
	    indication: hideJavaClasses:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Methods'
	    translateLabel: true
	    isVisible: editedFileHasJavaSuffix
	    hideMenuOnActivated: false
	    indication: hideJavaMethods:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Fields'
	    translateLabel: true
	    isVisible: editedFileHasJavaSuffix
	    hideMenuOnActivated: false
	    indication: hideJavaFields:
	  )
	 )
	nil
	nil
      )
!

javaScriptMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#javaScriptMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser javaScriptMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasJavaScriptSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Functions Only'
	    translateLabel: true
	    isVisible: editedFileHasJavaScriptSuffix
	    hideMenuOnActivated: false
	    indication: functionsOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Variables Only'
	    translateLabel: true
	    isVisible: editedFileHasJavaScriptSuffix
	    hideMenuOnActivated: false
	    indication: variablesOnly:
	  )
	 )
	nil
	nil
      )
!

lispMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#lispMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser lispMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasLispSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Documentation Only'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    indication: documentationOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Classes Only'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    indication: classesOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Methods Only'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    indication: methodsOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Functions Only'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    indication: functionsOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Variables Only'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    indication: variablesOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Macros Only'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    indication: macrosOnly:
	  )
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasLispSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Documentation'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    hideMenuOnActivated: false
	    indication: hideDocumentation:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Classes'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    hideMenuOnActivated: false
	    indication: hideClasses:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Methods'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    hideMenuOnActivated: false
	    indication: hideLispMethods:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Functions'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    hideMenuOnActivated: false
	    indication: hideFunctions:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Variables'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    hideMenuOnActivated: false
	    indication: hideVariables:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Macros'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    hideMenuOnActivated: false
	    indication: hideLispMacros:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Constants'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    hideMenuOnActivated: false
	    indication: hideLispConstants:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Evaluations'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    hideMenuOnActivated: false
	    indication: hideLispEvaluations:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Structs'
	    translateLabel: true
	    isVisible: editedFileHasLispSuffix
	    hideMenuOnActivated: false
	    indication: hideStructures:
	  )
	 )
	nil
	nil
      )
!

luaMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#javaScriptMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser javaScriptMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasLuaSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Functions Only'
	    translateLabel: true
	    isVisible: editedFileHasLuaSuffix
	    hideMenuOnActivated: false
	    indication: functionsOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Variables Only'
	    translateLabel: true
	    isVisible: editedFileHasLuaSuffix
	    hideMenuOnActivated: false
	    indication: variablesOnly:
	  )
	 )
	nil
	nil
      )
!

makefileMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#makefileMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser makefileMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileIsMakefile
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Targets Only'
	    translateLabel: true
	    isVisible: editedFileIsMakefile
	    hideMenuOnActivated: false
	    indication: targetsOnly:
	  )
	 )
	nil
	nil
      )
!

middleButtonMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CBrowser::TagsBrowser andSelector:#middleButtonMenu
     (Menu new fromLiteralArrayEncoding:(CBrowser::TagsBrowser middleButtonMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            enabled: tagTypesPresentHolder
            label: 'Group by Type'
            translateLabel: true
            indication: groupedByType:
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Sort by Name'
            translateLabel: true
            indication: sortedByName:
          )
         (MenuItem
            label: 'Sort by Name Ignoring Case'
            translateLabel: true
            indication: sortedByNameIgnoringCase:
          )
         (MenuItem
            label: 'Sort by Name (Ignore Leading Underscores)'
            translateLabel: true
            indication: sortedByNameIgnoringLeadingUnderscores:
          )
         (MenuItem
            label: 'Sort by Name (Ignore Leading Underscores and Case)'
            translateLabel: true
            indication: sortedByNameIgnoringLeadingUnderscoresAndCase:
          )
         (MenuItem
            label: 'Sort by Line Number'
            translateLabel: true
            indication: sortedByLineNumber:
          )
         (MenuItem
            label: 'C Menu Slice'
            translateLabel: true
            submenuChannel: cMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Smalltalk Menu Slice'
            translateLabel: true
            submenuChannel: smalltalkMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Java Menu Slice'
            translateLabel: true
            submenuChannel: javaMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'JavaScript Menu Slice'
            translateLabel: true
            submenuChannel: javaScriptMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Dart Menu Slice'
            translateLabel: true
            submenuChannel: dartMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'TCL Menu Slice'
            translateLabel: true
            submenuChannel: tclMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Assembler Menu Slice'
            translateLabel: true
            submenuChannel: assemblerMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Lisp Menu Slice'
            translateLabel: true
            submenuChannel: lispMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Lua Menu Slice'
            translateLabel: true
            submenuChannel: luaMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Python Menu Slice'
            translateLabel: true
            submenuChannel: pythonMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'ObjC Menu Slice'
            translateLabel: true
            submenuChannel: objcMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'OZ Menu Slice'
            translateLabel: true
            submenuChannel: ozMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Makefile Menu Slice'
            translateLabel: true
            submenuChannel: makefileMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'HTML Menu Slice'
            translateLabel: true
            submenuChannel: htmlMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Update'
            itemValue: updateTagList
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Modified: / 21-08-2012 / 21:00:35 / cg"
!

objcMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#objcMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser objcMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: '-'
            isVisible: editedFileHasObjcSuffix
          )
         (MenuItem
            enabled: tagTypesPresentHolder
            label: 'Hide Classes'
            translateLabel: true
            isVisible: editedFileHasObjcSuffix
            hideMenuOnActivated: false
            indication: hideObjcClasses:
          )
         (MenuItem
            enabled: tagTypesPresentHolder
            label: 'Hide Methods'
            translateLabel: true
            isVisible: editedFileHasObjcSuffix
            hideMenuOnActivated: false
            indication: hideObjcMethods:
          )
         )
        nil
        nil
      )
!

ozMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#ozMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser ozMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasOzSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Classes'
	    translateLabel: true
	    isVisible: editedFileHasOzSuffix
	    hideMenuOnActivated: false
	    indication: hideOzClasses:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Methods'
	    translateLabel: true
	    isVisible: editedFileHasOzSuffix
	    hideMenuOnActivated: false
	    indication: hideOzMethods:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Functions'
	    translateLabel: true
	    isVisible: editedFileHasOzSuffix
	    hideMenuOnActivated: false
	    indication: hideOzFunctions:
	  )
	 )
	nil
	nil
      )
!

pythonMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#pythonMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser pythonMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasPythonSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Classes Only'
	    translateLabel: true
	    isVisible: editedFileHasPythonSuffix
	    indication: pythonClassesOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Methods Only'
	    translateLabel: true
	    isVisible: editedFileHasPythonSuffix
	    indication: pythonMethodsOnly:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Functions Only'
	    translateLabel: true
	    isVisible: editedFileHasPythonSuffix
	    indication: pythonFunctionsOnly:
	  )
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasPythonSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Classes'
	    translateLabel: true
	    isVisible: editedFileHasPythonSuffix
	    hideMenuOnActivated: false
	    indication: hidePythonClasses:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Methods'
	    translateLabel: true
	    isVisible: editedFileHasPythonSuffix
	    hideMenuOnActivated: false
	    indication: hidePythonMethods:
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Functions'
	    translateLabel: true
	    isVisible: editedFileHasPythonSuffix
	    hideMenuOnActivated: false
	    indication: hidePythonFunctions:
	  )
	 )
	nil
	nil
      )
!

smalltalkMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#smalltalkMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser smalltalkMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: '-'
            isVisible: editedFileHasSmalltalkSuffix
          )
         (MenuItem
            enabled: tagTypesPresentHolder
            label: 'Hide Classes'
            translateLabel: true
            isVisible: editedFileHasSmalltalkSuffix
            hideMenuOnActivated: false
            indication: hideClasses:
          )
         (MenuItem
            enabled: tagTypesPresentHolder
            label: 'Hide Methods'
            translateLabel: true
            isVisible: editedFileHasSmalltalkSuffix
            hideMenuOnActivated: false
            indication: hideMethods:
          )
         )
        nil
        nil
      )

    "Created: / 21-08-2012 / 20:59:28 / cg"
!

tclMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#tclMenuSlice
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser tclMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '-'
	    isVisible: editedFileHasTCLSuffix
	  )
	 (MenuItem
	    enabled: tagTypesPresentHolder
	    label: 'Hide Variables'
	    translateLabel: true
	    isVisible: editedFileHasTCLSuffix
	    hideMenuOnActivated: false
	    indication: hideVariables:
	  )
	 )
	nil
	nil
      )
!

toolBarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::TagsBrowser andSelector:#toolBarMenu
     (Menu new fromLiteralArrayEncoding:(Tools::TagsBrowser toolBarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: updateTagList
            label: 'updateTagList'
            itemValue: updateTagList
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary reloadIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: sortByName
            label: 'SortByName'
            itemValue: sortByName
            isButton: true
            indication: sortIsByName
            labelImage: (ResourceRetriever ToolbarIconLibrary sortByName16x16Icon)
          )
         (MenuItem
            activeHelpKey: sortByLineNumber
            label: 'SortByLineNumber'
            itemValue: sortByLineNumber
            isButton: true
            indication: sortIsByLineNumber
            labelImage: (ResourceRetriever ToolbarIconLibrary sortByLineNumber16x16Icon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: functionsOnly
            label: 'FunctionsOnly'
            itemValue: functionsOnly:
            isButton: true
            indication: functionsOnlyHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary functionsOnly16x16Icon)
          )
         (MenuItem
            activeHelpKey: structsOnly
            label: 'StructsOnly'
            itemValue: structsOnly:
            isButton: true
            isVisible: structsOnlyVisibleHolder
            indication: structsOnlyHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary structsOnly16x16Icon)
          )
         (MenuItem
            activeHelpKey: toggleTagFilter
            label: 'TagFilter'
            isButton: true
            indication: tagFilterFieldVisibleHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary filter16x16Icon)
          )
         )
        nil
        nil
      )
! !

!TagsBrowser methodsFor:'accessing'!

editedFile
    ^ self editedFileHolder value

    "Created: / 06-05-2011 / 13:56:20 / cg"
!

editedFile:aFilename
    self editedFileHolder value:aFilename

    "Created: / 07-05-2011 / 14:48:58 / cg"
!

editedFileHolder
    "gets the holder, which keeps the current edited file
    "
    editedFileHolder isNil ifTrue:[
	editedFileHolder := nil asValue.
	editedFileHolder addDependent:self.
    ].
    ^ editedFileHolder.

    "Created: / 06-05-2011 / 13:52:39 / cg"
    "Modified: / 07-05-2011 / 10:15:30 / cg"
!

editedFileHolder:aHolder
    "gets the holder, which keeps the current edited file
    "
    editedFileHolder notNil ifTrue:[
	editedFileHolder removeDependent:self.
    ].
    editedFileHolder := aHolder.
    editedFileHolder notNil ifTrue:[
	editedFileHolder addDependent:self.
    ].

    "Created: / 07-05-2011 / 10:16:18 / cg"
!

filter:aString
    tagView filter:aString.
!

tagsMenu:aMenuOrNil
    "set the menu to be shown in the tag list"
    
    tagsMenu := aMenuOrNil.
!

tagsValid
    ^ tagsValid ? false
!

tempDirectory
    commonAspects notNil ifTrue:[
	^ commonAspects tempDirectory
    ].
    ^ Filename tempDirectory

    "Created: / 07-05-2011 / 15:42:44 / cg"
! !

!TagsBrowser methodsFor:'accessing filters'!

anchorsOnly
    ^ tagList anchorsOnly
!

anchorsOnly:aBool
"/    aBool ifTrue:[
"/        tagList hideAnchors:false.
"/    ].
    tagList anchorsOnly:aBool.
    self updateTagList

    "Created: / 08-05-2011 / 10:51:03 / cg"
!

classesFunctionsAndVariablesOnly
    ^ tagList classesFunctionsAndVariablesOnly
!

classesFunctionsAndVariablesOnly:aBool
    aBool ifTrue:[
	tagList hideClasses:false.
	tagList hideFunctions:false.
	tagList hideVariables:false.
    ].
    tagList classesFunctionsAndVariablesOnly:aBool.
    self updateTagList

    "Modified: / 05-05-2011 / 15:33:13 / cg"
!

classesOnly
    ^ tagList classesOnly
!

classesOnly:aBool
    aBool ifTrue:[
	tagList hideClasses:false.
    ].
    tagList classesOnly:aBool.
    self updateTagList

    "Modified: / 05-05-2011 / 15:33:07 / cg"
!

dartClassesAndMethodsOnly
    ^ tagList dartClassesAndMethodsOnly
!

dartClassesAndMethodsOnly:aBool
    aBool ifTrue:[
	tagList hideDartClasses:false.
	tagList hideDartMethods:false.
    ].
    tagList dartClassesAndMethodsOnly:aBool.
    self updateTagList
!

dartClassesOnly
    ^ tagList dartClassesOnly
!

dartClassesOnly:aBool
    aBool ifTrue:[
	tagList hideDartClasses:false.
    ].
    tagList dartClassesOnly:aBool.
    self updateTagList
!

dartMethodsOnly
    ^ tagList dartMethodsOnly
!

dartMethodsOnly:aBool
    aBool ifTrue:[
	tagList hideDartMethods:false.
    ].
    tagList dartMethodsOnly:aBool.
    self updateTagList
!

definesOnly
    ^ tagList definesOnly
!

definesOnly:aBool
    aBool ifTrue:[
	tagList hideDefines:false.
    ].
    tagList definesOnly:aBool.
    self updateTagList
!

documentationOnly
    ^ tagList documentationOnly

    "Created: / 08-05-2011 / 10:50:52 / cg"
!

documentationOnly:aBool
    aBool ifTrue:[
	tagList hideDocumentation:false.
    ].
    tagList documentationOnly:aBool.
    self updateTagList

    "Created: / 08-05-2011 / 10:51:03 / cg"
!

functionsAndVariablesOnly
    ^ tagList functionsAndVariablesOnly
!

functionsAndVariablesOnly:aBool
    aBool ifTrue:[
	tagList hideFunctions:false.
	tagList hideVariables:false.
    ].
    tagList functionsAndVariablesOnly:aBool.
    self updateTagList
!

functionsOnly
    ^ tagList functionsOnly
!

functionsOnly:aBool
    self functionsOnlyHolder value:aBool.
    aBool ifTrue:[
        self structsOnlyHolder value:false.
        tagList hideFunctions:false.
    ].
    tagList functionsOnly:aBool.
    self updateTagList

    "Modified: / 06-10-2011 / 14:03:45 / cg"
!

headlinesOnly
    ^ tagList headlinesOnly
!

headlinesOnly:aBool
"/    aBool ifTrue:[
"/        tagList hideDocumentation:false.
"/    ].
    tagList headlinesOnly:aBool.
    self updateTagList
!

hideClasses
    ^ tagList hideClasses
!

hideClasses:aBool
    tagList hideClasses:aBool.
    self updateTagList
!

hideDartClasses
    ^ tagList hideDartClasses
!

hideDartClasses:aBool
    tagList hideDartClasses:aBool.
    self updateTagList
!

hideDartFields
    ^ tagList hideDartFields
!

hideDartFields:aBool
    tagList hideDartFields:aBool.
    self updateTagList
!

hideDartInterfaces
    ^ tagList hideDartInterfaces
!

hideDartInterfaces:aBool
    tagList hideDartInterfaces:aBool.
    self updateTagList
!

hideDartMethods
    ^ tagList hideDartMethods
!

hideDartMethods:aBool
    tagList hideDartMethods:aBool.
    self updateTagList
!

hideDartPackages
    ^ tagList hideDartPackages
!

hideDartPackages:aBool
    tagList hideDartPackages:aBool.
    self updateTagList
!

hideDataLabels
    ^ tagList hideDataLabels
!

hideDataLabels:aBool
    tagList hideDataLabels:aBool.
    self updateTagList
!

hideDefines
    ^ tagList hideDefines
!

hideDefines:aBool
    tagList hideDefines:aBool.
    self updateTagList
!

hideDocumentation
    ^ tagList hideDocumentation

    "Created: / 08-05-2011 / 10:56:45 / cg"
!

hideDocumentation:aBool
    tagList hideDocumentation:aBool.
    self updateTagList

    "Created: / 08-05-2011 / 10:56:49 / cg"
!

hideFunctionProtoTypes
    ^ tagList hideFunctionProtoTypes
!

hideFunctionProtoTypes:aBool
    tagList hideFunctionProtoTypes:aBool.
    self updateTagList
!

hideFunctions
    ^ tagList hideFunctions
!

hideFunctions:aBool
    tagList hideFunctions:aBool.
    self updateTagList
!

hideJavaClasses
    ^ tagList hideJavaClasses
!

hideJavaClasses:aBool
    tagList hideJavaClasses:aBool.
    self updateTagList
!

hideJavaFields
    ^ tagList hideJavaFields
!

hideJavaFields:aBool
    tagList hideJavaFields:aBool.
    self updateTagList
!

hideJavaInterfaces
    ^ tagList hideJavaInterfaces
!

hideJavaInterfaces:aBool
    tagList hideJavaInterfaces:aBool.
    self updateTagList
!

hideJavaMethods
    ^ tagList hideJavaMethods
!

hideJavaMethods:aBool
    tagList hideJavaMethods:aBool.
    self updateTagList
!

hideJavaPackages
    ^ tagList hideJavaPackages
!

hideJavaPackages:aBool
    tagList hideJavaPackages:aBool.
    self updateTagList
!

hideLabels
    ^ tagList hideLabels
!

hideLabels:aBool
    tagList hideLabels:aBool.
    self updateTagList
!

hideLispConstants
    ^ tagList hideLispConstants
!

hideLispConstants:aBool
    tagList hideLispConstants:aBool.
    self updateTagList
!

hideLispEvaluations
    ^ tagList hideLispEvaluations
!

hideLispEvaluations:aBool
    tagList hideLispEvaluations:aBool.
    self updateTagList
!

hideLispMacros
    ^ tagList hideLispMacros
!

hideLispMacros:aBool
    tagList hideLispMacros:aBool.
    self updateTagList
!

hideLispMethods
    ^ tagList hideLispMethods
!

hideLispMethods:aBool
    tagList hideLispMethods:aBool.
    self updateTagList
!

hideLocalLabels
    ^ tagList hideLocalLabels
!

hideLocalLabels2
    ^ tagList hideLocalLabels2

    "Created: / 24-03-2012 / 23:23:43 / cg"
!

hideLocalLabels2:aBool
    tagList hideLocalLabels2:aBool.
    self updateTagList

    "Created: / 24-03-2012 / 23:23:26 / cg"
!

hideLocalLabels3
    ^ tagList hideLocalLabels3

    "Created: / 13-05-2012 / 11:09:54 / cg"
!

hideLocalLabels3:aBool
    tagList hideLocalLabels3:aBool.
    self updateTagList

    "Created: / 13-05-2012 / 11:10:01 / cg"
!

hideLocalLabels:aBool
    tagList hideLocalLabels:aBool.
    self updateTagList
!

hideLuaFunctions
    ^ tagList hideLuaFunctions
!

hideLuaFunctions:aBool
    tagList hideLuaFunctions:aBool.
    self updateTagList
!

hideLuaVariables
    ^ tagList hideLuaVariables
!

hideLuaVariables:aBool
    tagList hideLuaVariables:aBool.
    self updateTagList
!

hideMethods
    ^ tagList hideMethods

    "Created: / 21-08-2012 / 21:02:54 / cg"
!

hideMethods:aBool
    tagList hideMethods:aBool.
    self updateTagList

    "Created: / 21-08-2012 / 21:01:45 / cg"
!

hideObjcClasses
    ^ tagList hideObjcClasses
!

hideObjcClasses:aBool
    tagList hideObjcClasses:aBool.
    self updateTagList
!

hideOzClasses
    ^ tagList hideOzClasses
!

hideOzClasses:aBool
    tagList hideOzClasses:aBool.
    self updateTagList
!

hideOzFunctions
    ^ tagList hideOzFunctions
!

hideOzFunctions:aBool
    tagList hideOzFunctions:aBool.
    self updateTagList
!

hideOzMethods
    ^ tagList hideOzMethods
!

hideOzMethods:aBool
    tagList hideOzMethods:aBool.
    self updateTagList
!

hidePythonClasses
    ^ tagList hidePythonClasses
!

hidePythonClasses:aBool
    tagList hidePythonClasses:aBool.
    self updateTagList
!

hidePythonFunctions
    ^ tagList hidePythonFunctions
!

hidePythonFunctions:aBool
    tagList hidePythonFunctions:aBool.
    self updateTagList
!

hidePythonMethods
    ^ tagList hidePythonMethods
!

hidePythonMethods:aBool
    tagList hidePythonMethods:aBool.
    self updateTagList
!

hideStatic
    ^ tagList hideStatic
!

hideStatic:aBool
    tagList hideStatic:aBool.
    self updateTagList
!

hideStructMembers
    ^ tagList hideStructMembers
!

hideStructMembers:aBool
    tagList hideStructMembers:aBool.
    self updateTagList
!

hideStructures
    ^ tagList hideStructures
!

hideStructures:aBool
    tagList hideStructures:aBool.
    self updateTagList
!

hideTextLabels
    ^ tagList hideTextLabels
!

hideTextLabels:aBool
    tagList hideTextLabels:aBool.
    self updateTagList
!

hideTypedefs
    ^ tagList hideTypedefs
!

hideTypedefs:aBool
    tagList hideTypedefs:aBool.
    self updateTagList
!

hideVariables
    ^ tagList hideVariables
!

hideVariables:aBool
    tagList hideVariables:aBool.
    self updateTagList
!

javaClassesAndMethodsOnly
    ^ tagList javaClassesAndMethodsOnly
!

javaClassesAndMethodsOnly:aBool
    aBool ifTrue:[
	tagList hideJavaClasses:false.
	tagList hideJavaMethods:false.
    ].
    tagList javaClassesAndMethodsOnly:aBool.
    self updateTagList
!

javaClassesOnly
    ^ tagList javaClassesOnly
!

javaClassesOnly:aBool
    aBool ifTrue:[
	tagList hideJavaClasses:false.
    ].
    tagList javaClassesOnly:aBool.
    self updateTagList
!

javaMethodsOnly
    ^ tagList javaMethodsOnly
!

javaMethodsOnly:aBool
    aBool ifTrue:[
	tagList hideJavaMethods:false.
    ].
    tagList javaMethodsOnly:aBool.
    self updateTagList
!

luaFunctionsOnly
    ^ tagList luaFunctionsOnly
!

luaFunctionsOnly:aBool
    aBool ifTrue:[
	tagList hideLuaFunctions:false.
    ].
    tagList luaFunctionsOnly:aBool.
    self updateTagList
!

macrosOnly
    ^ tagList macrosOnly

    "Created: / 07-06-2010 / 12:08:42 / cg"
!

macrosOnly:aBool
    aBool ifTrue:[
	tagList hideLispMacros:false.
    ].
    tagList macrosOnly:aBool.
    self updateTagList

    "Created: / 07-06-2010 / 12:09:08 / cg"
!

methodsOnly
    ^ tagList methodsOnly

    "Created: / 07-06-2010 / 12:11:55 / cg"
!

methodsOnly:aBool
    aBool ifTrue:[
	tagList hideLispMethods:false.
    ].
    tagList methodsOnly:aBool.
    self updateTagList

    "Created: / 07-06-2010 / 12:12:03 / cg"
!

pythonClassesOnly
    ^ tagList pythonClassesOnly
!

pythonClassesOnly:aBool
    aBool ifTrue:[
	tagList hidePythonClasses:false.
    ].
    tagList pythonClassesOnly:aBool.
    self updateTagList
!

pythonFunctionsOnly
    ^ tagList pythonFunctionsOnly
!

pythonFunctionsOnly:aBool
    aBool ifTrue:[
	tagList hidePythonFunctions:false.
    ].
    tagList pythonFunctionsOnly:aBool.
    self updateTagList
!

pythonMethodsOnly
    ^ tagList pythonMethodsOnly
!

pythonMethodsOnly:aBool
    aBool ifTrue:[
	tagList hidePythonMethods:false.
    ].
    tagList pythonMethodsOnly:aBool.
    self updateTagList
!

structsOnly
    ^ tagList structsOnly

    "Created: / 25-06-2010 / 10:54:46 / cg"
!

structsOnly:aBool
    self structsOnlyHolder value:aBool.
    aBool ifTrue:[
        self functionsOnlyHolder value:false.
        tagList hideStructures:false.
    ].
    tagList structsOnly:aBool.
    self updateTagList
!

tagTypesPresent
    ^ tagList tagTypesPresent
!

tagTypesPresentHolder
    ^ [ self tagTypesPresent ]
!

targetsOnly
    ^ tagList targetsOnly
!

targetsOnly:aBool
    tagList targetsOnly:aBool.
    self updateTagList
!

typesOnly
    ^ tagList typesOnly
!

typesOnly:aBool
    aBool ifTrue:[
	tagList hideTypedefs:false.
    ].
    tagList typesOnly:aBool.
    self updateTagList
!

variablesOnly
    ^ tagList variablesOnly
!

variablesOnly:aBool
    aBool ifTrue:[
	tagList hideVariables:false.
    ].
    tagList variablesOnly:aBool.
    self updateTagList

    "Modified: / 05-05-2011 / 15:33:18 / cg"
! !

!TagsBrowser methodsFor:'accessing presentation aspects'!

groupedByType
    ^ tagList groupedByType

    "Created: / 05-05-2011 / 14:51:29 / cg"
!

groupedByType:aBool
    tagList groupedByType:aBool

    "Created: / 05-05-2011 / 14:51:33 / cg"
!

sorted
    ^ tagList sorted
!

sorted:aBool
    tagList sorted:aBool
!

sortedByLineNumber
    ^ tagList sortedByLineNumber
!

sortedByLineNumber:aBool
    tagList sortedByLineNumber:aBool
!

sortedByName
    ^ tagList sortedByName
!

sortedByName:aBool
    tagList sortedByName:aBool
!

sortedByNameIgnoringCase
    ^ tagList sortedByNameIgnoringCase
!

sortedByNameIgnoringCase:aBool
    tagList sortedByNameIgnoringCase:aBool
!

sortedByNameIgnoringLeadingUnderscores
    ^ tagList sortedByNameIgnoringLeadingUnderscores
!

sortedByNameIgnoringLeadingUnderscores:aBool
    tagList sortedByNameIgnoringLeadingUnderscores:aBool
!

sortedByNameIgnoringLeadingUnderscoresAndCase
    ^ tagList sortedByNameIgnoringLeadingUnderscoresAndCase
!

sortedByNameIgnoringLeadingUnderscoresAndCase:aBool
    tagList sortedByNameIgnoringLeadingUnderscoresAndCase:aBool
!

sortedByType
    ^ tagList sortedByType
!

sortedByType:aBool
    tagList sortedByType:aBool
! !

!TagsBrowser methodsFor:'accessing-behavior'!

action:aOneArgBlock
    "set the action, which is called with the selected tag,
     if the user selects one"
     
    action := aOneArgBlock.

    "Modified: / 23-06-2011 / 16:36:59 / cg"
! !

!TagsBrowser methodsFor:'aspects'!

editedFileHasAssemblerSuffix
    ^builder booleanValueAspectFor: #editedFileHasAssemblerSuffix


!

editedFileHasCSuffix
    ^builder booleanValueAspectFor: #editedFileHasCSuffix


!

editedFileHasDartSuffix
    ^builder booleanValueAspectFor: #editedFileHasDartSuffix
!

editedFileHasEiffelSuffix
    ^builder booleanValueAspectFor: #editedFileHasEiffelSuffix


!

editedFileHasFortranSuffix
    ^builder booleanValueAspectFor: #editedFileHasFortranSuffix


!

editedFileHasHtmlSuffix
    ^builder booleanValueAspectFor: #editedFileHasHtmlSuffix
!

editedFileHasJavaScriptSuffix
    ^builder booleanValueAspectFor: #editedFileHasJavaScriptSuffix

    "Created: / 28-06-2010 / 13:09:15 / cg"
!

editedFileHasJavaSuffix
    ^builder booleanValueAspectFor: #editedFileHasJavaSuffix


!

editedFileHasLispSuffix
    ^builder booleanValueAspectFor: #editedFileHasLispSuffix


!

editedFileHasLuaSuffix
    ^builder booleanValueAspectFor: #editedFileHasLuaSuffix
!

editedFileHasObjcSuffix
    ^builder booleanValueAspectFor: #editedFileHasObjcSuffix
!

editedFileHasOzSuffix
    ^builder booleanValueAspectFor: #editedFileHasOzSuffix
!

editedFileHasPythonSuffix
    ^builder booleanValueAspectFor: #editedFileHasPythonSuffix


!

editedFileHasRubySuffix
    ^builder booleanValueAspectFor: #editedFileHasRubySuffix
!

editedFileHasSmalltalkSuffix
    ^builder booleanValueAspectFor: #editedFileHasSmalltalkSuffix


!

editedFileHasTCLSuffix
    ^builder booleanValueAspectFor: #editedFileHasTCLSuffix


!

editedFileIsMakefile
    ^builder booleanValueAspectFor: #editedFileIsMakefile
!

functionsOnlyHolder
    ^ builder booleanValueAspectFor: #functionsOnly

    "Created: / 06-10-2011 / 12:19:23 / cg"
!

remoteCtagsModel

    |holder|

    (holder := builder bindingAt:#remoteCtagsModel) isNil ifTrue:[
	holder := false asValue.
	builder aspectAt:#remoteCtagsModel put:holder.
    ].
    ^ holder.
!

sortIsByLineNumber
    ^ builder booleanValueAspectFor: #sortIsByLineNumber

    "Created: / 03-08-2011 / 11:17:48 / cg"
!

sortIsByName
    ^ builder booleanValueAspectFor: #sortIsByName

    "Created: / 03-08-2011 / 11:17:52 / cg"
!

structsOnlyHolder
    ^ builder booleanValueAspectFor: #structsOnly
!

structsOnlyVisibleHolder
    ^ builder booleanValueAspectFor: #structsOnlyVisible
!

tagFilterFieldVisibleHolder
    |holder|

    (holder := builder bindingAt:#tagFilterFieldVisibleHolder) isNil ifTrue:[
	holder := false asValue.
	builder aspectAt:#tagFilterFieldVisibleHolder put:holder.
	holder onChangeSend:#tagFilterVisibilityChanged to:self.
    ].
    ^ holder.

    "Created: / 01-08-2012 / 10:52:48 / cg"
!

tagFilterPatternHolder
    |holder|

    (holder := builder bindingAt:#tagFilterPatternHolder) isNil ifTrue:[
	holder := '' asValue.
	builder aspectAt:#tagFilterPatternHolder put:holder.
	holder onChangeSend:#tagFilterChanged to:self.
    ].
    ^ holder.

    "Created: / 01-08-2012 / 16:43:26 / cg"
!

tagList
    "returns the tagList
    "
    ^ tagList
!

tagView
    "returns the widget which shows the tags
    "
    ^ tagView
! !

!TagsBrowser methodsFor:'change & update'!

delayedEditedFileChanged
    "called when the current editing file has changed.
     Update the valueHolders which keep track of the edited files type (i.e. language)
    "

    self updateFileTypeHolders.
    tagsValid ifFalse:[
	self updateTagList.
    ].

    "Created: / 07-05-2011 / 15:36:52 / cg"
!

editedFileChanged
    tagsValid := false.
    self enqueueDelayedAction:[self delayedEditedFileChanged].

    "Modified: / 07-05-2011 / 15:37:00 / cg"
!

tagFilterChanged
    tagList filter:(self tagFilterPatternHolder value)

    "Created: / 01-08-2012 / 16:44:54 / cg"
!

tagFilterVisibilityChanged
    self tagFilterFieldVisibleHolder value ifTrue:[
"/        self windowGroup
"/            focusView:(self builder componentAt:#TagFilterInputField)
"/            byTab:true.
	self enqueueMessage:#assignFocusToTagFilterInputField for:self arguments:#().
    ].

    "Created: / 01-08-2012 / 17:00:27 / cg"
!

update:something with:aparameter from:changedObject
    changedObject == self editedFileHolder ifTrue:[
	tagList removeAll.
	self editedFileChanged.
	^ self
    ].
    super update:something with:aparameter from:changedObject

    "Modified: / 01-08-2012 / 16:58:30 / cg"
!

updateFileTypeHolders
    "called when the current editing file has changed.
     Update the valueHolders which keep track of the edited files type (i.e. language)
    "

    |edFile suffix mime|

    edFile := self editedFile.
"/    edFile notNil ifTrue:[
"/        suffix := edFile suffix.
"/    ].

    mime := TagList tagMimeTypeForFile:edFile.

         "/ valueHolder                 mime(s)
    #(
          (editedFileHasJavaSuffix      ('text/java' 'application/x-java-source'))
          (editedFileHasJavaScriptSuffix ('text/javaScript' 'text/javascript' 'application/x-javascript' 'application/x-javascript-source') )
          (editedFileHasDartSuffix      ('text/dart' 'application/x-dart' 'application/x-dart-source') )
          (editedFileHasCSuffix         ('text/c' 'application/x-c-source'))
          (editedFileHasEiffelSuffix    ('text/eiffel' 'application/x-eiffel-source'))
          (editedFileHasFortranSuffix   ('text/fortran' 'application/x-fortran-source'))
          (editedFileHasPythonSuffix    ('text/python' 'application/x-python-source'))
          (editedFileHasObjcSuffix      ('text/objcsrc' 'application/x-objcsrc'))
          (editedFileHasOzSuffix        ('text/oz' 'application/x-oz-source'))
          (editedFileHasLuaSuffix       ('text/lua' 'application/x-lua-source'))
          (editedFileHasLispSuffix      ('text/lisp' 'text/lisp-arc' 'text/scheme' 'application/x-lisp-source' 'application/x-scheme-source') )
          (editedFileHasSmalltalkSuffix ('text/smalltalk' 'application/x-smalltalk-source'))
          (editedFileHasTCLSuffix       ('text/tcl' 'application/x-tcl-source') )
          (editedFileHasAssemblerSuffix ('text/asm' 'application/x-assembler-source'))
          (editedFileIsMakefile         'text/make')
          (editedFileHasRubySuffix      ('text/ruby' 'application/x-ruby-source'))
          (editedFileHasHtmlSuffix      ('text/html' ))
    ) pairsDo:[:holderName :mimeTypeOrTypes |
        |holder|

        holder := self perform:holderName.
        mimeTypeOrTypes isString ifTrue:[
            holder value:(mime = mimeTypeOrTypes)
        ] ifFalse:[
            holder value:(mimeTypeOrTypes includes:mime)
        ].
    ].
    self structsOnlyVisibleHolder value:(self editedFileHasCSuffix value).

    "Modified: / 21-08-2012 / 20:54:08 / cg"
!

updateForLine:lineNr
    "/ highlight the tag for a particular line in the edittext
    "/ called via a hook via the masterapp from the editView...

    self updateForLine:lineNr filtering:nil
!

updateForLine:lineNr filtering:tagFilterOrNil
    "highlight the tag for a particular line in the edittext
     called via a hook via the masterapp from the editView...
     The filter can be used eg. to find only function tags
     (i.e. to ignore case and goto labels in C)"

    |bestTag|

    bestTag := tagList bestTagForLine:lineNr filtering:tagFilterOrNil.
    bestTag notNil ifTrue:[
	tagView setSelection:(tagList identityIndexOf:bestTag).
    ] ifFalse:[
	"/ remember line in case the tag-list is being generated
	tagView tagLineNr:lineNr
    ].

    "Modified: / 23-06-2011 / 17:28:26 / cg"
! !

!TagsBrowser methodsFor:'hooks for ccbrowser'!

buildTarget
    commonAspects notNil ifTrue:[
	^ commonAspects buildTarget
    ].
    ^ nil

    "Created: / 07-05-2011 / 15:38:20 / cg"
!

tagForFunction:functionName
    ^ tagList tagForFunction:functionName
!

tagForMacro:typeName
    ^ tagList tagForMacro:typeName
!

tagForType:typeName
    ^ tagList tagForType:typeName
! !

!TagsBrowser methodsFor:'hooks for embedding'!

tagListGenerator:aBlockOrValueHolder
    "to use a tagsBrowser as a component in another application,
     this hook allows for the tag list to be provided by that application.
     If non-nil, it will be evaluated to generate the tagList instead of
     reading the tags from the editedFile"

    tagListGenerator := aBlockOrValueHolder.
! !

!TagsBrowser methodsFor:'menu actions'!

keepingSelectionDo:aBlock
    |oldSelection oldLabel|

    oldSelection := tagView selectionValue.
    aBlock value.

    oldSelection notNil ifTrue:[
	oldLabel := oldSelection label.
	tagView
	    selectElementForWhich:[:el | el label = oldLabel]
	    ifAbsent:[self halt:'ouch - no such label'].
    ].

    "Created: / 06-10-2011 / 13:41:57 / cg"
!

middleButtonMenu
    ^ [
	|menu suffix file item|

	tagsMenu notNil ifTrue:[
	    tagsMenu
	] ifFalse:[
	    menus isNil ifTrue:[
		menus := IdentityDictionary new.
	    ].

	    menu := nil.

	    (file := self editedFile) notNil ifTrue:[
		(tagList supportsFile:file) ifTrue:[
		    menu := menus at:#exists ifAbsentPut:[
							menu := self class middleButtonMenu decodeAsLiteralArray.
							menu receiver:self.
							menu findGuiResourcesIn:self.
							menu
						       ].
		    menu := MenuPanel menu:menu receiver:self.
		] ifFalse:[
		    suffix := file suffix.

		    suffix size ~~ 0 ifTrue:[
			menu := menus at:#new ifAbsentPut:[
			    menu := Menu new.
			    item := MenuItem label:('assign ', (Text string:suffix emphasis:#underline), ' to:').
			    item enabled:false.
			    menu addItem:item.
			    menu addItem:(MenuItem separator).

			    tagList class tagsSuffixes keysAndValuesDo:[:aKey :aValue|
				item := MenuItem label:('  - ', aKey )
						 itemValue:[ |list|
							list := aValue asOrderedCollection.
							list add:(suffix asLowercase).
							tagList class tagsSuffixes at:aKey put:list.
							self editedFileChanged.
						       ].
				menu addItem:item.
			    ].
			    menu
			].

		    ]
		].
	    ].
	    menu
	]
      ]

    "Modified: / 08-09-2012 / 19:51:03 / cg"
!

sortByLineNumber
    self keepingSelectionDo:[
	tagList sortedByLineNumber:true.
	self sortIsByName value:false.
	self sortIsByLineNumber value:true.
    ]

    "Created: / 03-08-2011 / 11:04:51 / cg"
!

sortByName
    self keepingSelectionDo:[
	tagList sortedByNameIgnoringLeadingUnderscoresAndCase: "sortedByName:" true.
	self sortIsByLineNumber value:false.
	self sortIsByName value:true.
    ].

    "Created: / 03-08-2011 / 11:04:37 / cg"
!

updateTagList
    "regenerate tags
    "

    |file target oldSelection|

    tagListGenerator notNil ifTrue:[
        tagList setRawList:(tagListGenerator value).
        "/ tagView list:(tagListGenerator value).
        tagsValid := true.
        ^ self.
    ].

    tagsValid := false.
    (true "(self tagsVisibilityHolder value == true)"
        and:[(file := self editedFile) notNil
        and:[tagList supportsFile:file]]
    ) ifTrue:[
        (target := self buildTarget) notNil ifTrue:[
            (target isRemote and:[self tagsRemoteHolder value]) ifFalse:[
                target := nil
            ]
        ].
        oldSelection := tagView selectionValue.
        (tagView generateTagsFor:file onTarget:target
                finally:[
                    |tagsForLabel oldLabel bestTag|

                    oldSelection notNil ifTrue:[
                        oldLabel := oldSelection label.
                        tagsForLabel := tagView elementsForWhich:[:el | el label = oldLabel].
                        "/ only reselect, if there is exactly one
                        tagsForLabel size == 1 ifTrue:[
                            tagView selectElement:tagsForLabel first
                        ].
"/                        tagView 
"/                            selectElementForWhich:[:el | el label = oldLabel] 
"/                            ifAbsent:["ok, if previous tag is filtered away" "self halt"].
                    ].
                    tagsValid := true.
                ]
        ) ifFalse:[
            "/ did not start a background tag job
            tagsValid := true.  "/ to avoid waiting forever
        ].
    ] ifFalse:[
        tagView stopGeneratingTags.
        tagView clearList.
        tagsValid := true.
    ].

    "Modified: / 07-12-2011 / 11:13:18 / cg"
! !

!TagsBrowser methodsFor:'startup & release'!

assignFocusToTagFilterInputField
    (self builder componentAt:#TagFilterInputField) requestFocus.
    "/ (self builder componentAt:#TagFilterInputField) takeFocus

    "Created: / 02-08-2012 / 22:00:45 / cg"
!

cloneWith:anApplication
"/    |browser|
"/
"/    (browser := anApplication tagsBrowser) notNil ifTrue:[
"/        self tagsVisibilityHolder value:(browser tagsVisibilityHolder value)
"/    ]

    "Modified: / 07-05-2011 / 11:54:48 / cg"
!

initialize
    super initialize.

    tagList := TagList new.
    tagView := TagView new.
    tagsValid := false.

    tagView application:self.
    tagView list:tagList.

    tagView action:[:i| self tagListSelectionChangedTo:i].

    "Modified: / 06-12-2011 / 14:57:06 / cg"
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.

    self sortIsByName value:true.

    "Created: / 03-08-2011 / 11:19:44 / cg"
!

tagListSelectionChangedTo:idx
    |tag|

    action notNil ifTrue:[
	tagList isEmpty ifTrue:[
	    tagList := tagView list
	].
	tag := tagList at:idx ifAbsent:nil.
	tag notNil ifTrue:[ action value:tag ].
    ]

    "Modified: / 03-08-2011 / 11:19:49 / cg"
    "Created: / 06-12-2011 / 14:57:26 / cg"
! !

!TagsBrowser::TagView methodsFor:'accessing'!

application
    "returns my application, the TagsBrowser
    "
    ^ application
!

application:theTagsBrowser
    "set my application, the TagsBrowser
    "
    application := theTagsBrowser.
!

clearList
    self list:nil
!

filter:aString
    list filter:aString.
!

list:aList
    (aList isNil or:[aList isKindOf:Tools::TagList]) ifFalse:[self halt].
    super list:aList.
!

newDefaultList
    ^ TagList new
!

tagLineNr:lineNr
    "remember line nr for which a tag should be highlighted.
     (will set my selection late, when the taglist is available"

    tagLineNr := lineNr
! !

!TagsBrowser::TagView methodsFor:'drawing'!

drawLabelAt:anIndex x:x y:y h:h
    "draw the label at position x/y without clearing the background"

    |item label typeIdentifier font
     y0 widthOfTypeIdentifier inset inSelection lineNrString|

    item := list at:anIndex ifAbsent:nil.
    item isNil ifTrue:[^ self].

    font := gc font.

    label := item printString ? ''.
    (inSelection := self isInSelection:anIndex) ifTrue:[
        self hasFocus ifTrue:[    
            gc paint:hilightFgColor on:hilightBgColor.
        ] ifFalse:[
            gc paint:hilightFgColorNoFocus on:hilightBgColorNoFocus
        ].
        label := label string.   "/ to avoid printing blue on blue
    ] ifFalse:[
        gc paint:fgColor on:bgColor.
    ].

    lineNrString := ' [ %1 ]' bindWith:item lineNumber.
    inSelection ifFalse:[
        lineNrString := lineNrString withColor:Color darkGray.
    ].
    label := label asText , lineNrString.

    y0 := y - (((font height) + 1 - h) // 2) + font ascent.

    typeIdentifier := item typeIdentifierInList.
    typeIdentifier isNil ifTrue:[
        widthOfTypeIdentifier := 0
    ] ifFalse:[
        typeIdentifier := Text string:typeIdentifier emphasis:#bold.
        typeIdentifier displayOn:gc x:x y:y0.
        widthOfTypeIdentifier := (typeIdentifier widthOn:gc) + font width "... of a space".
    ].
    inset := TypeInset max:widthOfTypeIdentifier.

    label displayOn:gc x:(x + inset) y:y0

    "Modified: / 17-03-2012 / 11:15:27 / cg"
    "Modified: / 23-06-2014 / 21:23:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawSelectionFrameAt:lnNr x:x w:w
    "draw the background and foreground of the selection frame
     at a lineNr.
    "
    |item
     x0 "{ Class:SmallInteger }"
     x1 "{ Class: SmallInteger }"
     y0 "{ Class:SmallInteger }"
     y1 "{ Class:SmallInteger }"
     hL "{ Class:SmallInteger }"
     wL "{ Class:SmallInteger }"
    |
    (item := list at:lnNr ifAbsent:nil) isNil ifTrue:[
        "/ list might change during drawing; item no longer visible
        ^ self
    ].

    "/ CLEAR THE BACKGROUND

    y0 := self yVisibleOfLine:lnNr.
    y1 := self yVisibleOfLine:(lnNr + 1).
    hL := y1 - y0.

    x0 := textStartLeft - viewOrigin x "+ TypeInset - 4".
    x1 := (self widthOfContents - viewOrigin x) max:(width - margin).
    wL := x1 - x0.

    wL > 0 ifFalse:[^ self].

    gc paint:(self hasFocus ifTrue:[hilightBgColor] ifFalse:[hilightBgColorNoFocus]).
    gc fillRectangleX:x0 y:y0 width:wL height:hL.

    "/ DRAW THE FRAME

    hilightFrameColor notNil ifTrue:[
        hilightLevel == 0 ifTrue:[
            gc paint:hilightFrameColor.
            gc displayRectangleX:x0 y:y0 width:wL height:hL.
            ^ self.
        ]
    ] ifFalse:[
        hilightStyle == #motif ifTrue:[
            gc paint:bgColor.
            y1 := y0 + 1.
            gc displayRectangleX:x0 + 1 y:y1 width:wL - 2 height:hL - 2.
        ]
    ].

    hilightLevel ~~ 0 ifTrue:[
        "/ draw edge
        self drawEdgesForX:x0 y:y0 width:wL height:hL level:hilightLevel.
    ]
! !

!TagsBrowser::TagView methodsFor:'generating tags'!

generateTagsFor:aFile onTarget:aTarget finally:aBlock
    "generate tags for a file (optionally on a remote target)
     return true, if a background job for generation has been started"

    |tagFile|

    "/ ugly hack to suppress generation if the taglist is externally provided
    (list isKindOf:Tools::TagList) ifFalse:[
	^ false
    ].

    Tag autoload.

    self stopGeneratingTags.

    aFile isNil ifTrue:[
	^ false
    ].
    fileName := aFile asFilename.

"/    (tagFile := application changes backupFor:fileName) isNil ifTrue:[
	tagFile := fileName.
"/    ].

    process := [
	[
	    Error handle:[:ex|
		Transcript show:'TagGenerator error caught:'; showCR:ex errorString.
		ex suspendedContext fullPrintAllOn:Transcript.
		(Dialog
		    confirm:(resources stringWithCRs:'Error encountered while generating tags:\\    %1\\Debug ?' with:ex description)
		    yesLabel:'Debug'
		) ifTrue:[
		    ex reject
		].
	    ] do:[
		|bestTag|

		self enabled:false.
		list add:nil.
		list add:(Tag label:('Generating Tags ...' allBold) pattern:nil).
		"/ list filter:filter.
		list sortedByName:(application sortIsByName value).

		list
		    fromFile:tagFile
		    in:(application tempDirectory)
		    onTarget:aTarget.

		tagLineNr notNil ifTrue:[
		    bestTag := list bestTagForLine:tagLineNr.
		    bestTag notNil ifTrue:[
			self setSelection:(list identityIndexOf:bestTag).
		    ].
		    tagLineNr := nil
		].
		aBlock value.
	    ]
	] ensure:[
	    process := nil.
	    self enabled:true.
	].
    ] forkAt:4.

    process priorityRange:(4 to:8).
    ^ true.

    "Created: / 06-10-2011 / 13:56:18 / cg"
!

stopGeneratingTags
    "stop the process which generates the tags
    "
    |task|

    (task := process) notNil ifTrue:[
	process := nil.

	Exception handle:[:ex|
	    Transcript showCR:('caught exception during tag-process termination: ',ex description).
	] do:[
	    task terminateWithAllSubprocessesInGroup.
	    task waitUntilTerminated.
	]
    ].
    fileName := nil.
    "/ list removeAll.

    "Modified (comment): / 06-10-2011 / 14:01:30 / cg"
! !

!TagsBrowser::TagView methodsFor:'initialize & release'!

destroy
    self  stopGeneratingTags.
    super destroy.
!

initialize

    TypeInset := 16.

    super initialize.
    highlightMode := #line.
    itemHeight := gc font height.
! !

!TagsBrowser::TagView methodsFor:'protocol'!

heightOfLineAt:aLineNr
    "returns the total height for a line at an index (including lineSpacing)"

    ^ lineSpacing + itemHeight
!

widthOfWidestLineBetween:firstLine and:lastLine
    "return the width in pixels of the widest line in a range.
     - used to optimize scrolling, by limiting the scrolled area;
       not for scrollbar or other width related stuff which should be exact."

    ^ TypeInset + (super widthOfWidestLineBetween:firstLine and:lastLine)
! !

!TagsBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

