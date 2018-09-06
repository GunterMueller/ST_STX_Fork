"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

ApplicationModel subclass:#SmaCCParserGenerator
	instanceVariableNames:'tabList parserClassNameHolder scannerClassNameHolder
		highlighterClassNameHolder conflictHolder scannerHolder
		parserHolder testHolder generateDefinitionCommentsHolder
		generateSymbolCommentsHolder generateItemSetCommentsHolder
		allowUnicodeHolder ignoreCaseHolder editAcceptChannel
		loadScannerAndParserFromFileHolder showSymbolSetHolder
		parserEditTextView scannerEditTextView parserDefinitionFileHolder
		scannerDefinitionFileHolder tabSelectionHolder'
	classVariableNames:'ShowPrecedenceConflicts'
	poolDictionaries:''
	category:'SmaCC-UI'
!

!SmaCCParserGenerator class methodsFor:'documentation'!

examples
"
    openSmaCC
        <menuItem: 'SmaCC Parser Generator'
        nameKey: nil
        menu: #(#menuBar #tools)
                position: 30.00>

        SmaCC.SmaCCParserGenerator open
"
! !

!SmaCCParserGenerator class methodsFor:'initialization'!

initialize
    ShowPrecedenceConflicts := false.
! !

!SmaCCParserGenerator class methodsFor:'interface specs'!

compileWindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmaCC::SmaCCParserGenerator andSelector:#compileWindowSpec
     SmaCC::SmaCCParserGenerator new openInterface:#compileWindowSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: compileWindowSpec
       window: 
      (WindowSpec
         label: 'Compile Grammar Tab'
         name: 'Compile Grammar Tab'
         bounds: (Rectangle 0 0 696 468)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'ContentPanel'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Classes'
                   name: 'ClassesBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'ClassesBoxContent'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         horizontalLayout: fit
                         verticalLayout: fit
                         horizontalSpace: 3
                         verticalSpace: 3
                         elementsChangeSize: true
                         component: 
                        (SpecCollection
                           collection: (
                            (HorizontalPanelViewSpec
                               name: 'ClassesBoxContentScannerClass'
                               horizontalLayout: left
                               verticalLayout: fit
                               horizontalSpace: 3
                               verticalSpace: 3
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Scanner class:'
                                     name: 'ScannerClassLabel'
                                     translateLabel: true
                                     resizeForLabel: true
                                     adjust: left
                                     extent: (Point 110 28)
                                     useDynamicPreferredHeight: true
                                     usePreferredHeight: true
                                   )
                                  (InputFieldSpec
                                     name: 'ScannerClassName'
                                     model: scannerClassNameHolder
                                     type: string
                                     acceptOnLeave: true
                                     acceptOnLostFocus: true
                                     acceptOnPointerLeave: true
                                     extent: (Point 300 28)
                                     useDynamicPreferredHeight: true
                                     usePreferredHeight: true
                                   )
                                  (ActionButtonSpec
                                     label: 'Select'
                                     name: 'ScannerClassFindButton'
                                     translateLabel: true
                                     model: findScannerClass
                                     defaultable: true
                                     useDynamicPreferredHeight: true
                                     usePreferredHeight: true
                                     useDefaultExtent: true
                                   )
                                  )
                                
                               )
                               extent: (Point 662 28)
                               useDynamicPreferredHeight: true
                             )
                            (HorizontalPanelViewSpec
                               name: 'ClassesBoxContentParserClass'
                               horizontalLayout: left
                               verticalLayout: fit
                               horizontalSpace: 3
                               verticalSpace: 3
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Parser class:'
                                     name: 'ParserClassLabel'
                                     translateLabel: true
                                     adjust: left
                                     extent: (Point 110 29)
                                   )
                                  (InputFieldSpec
                                     name: 'ParserClassName'
                                     model: parserClassNameHolder
                                     type: string
                                     acceptOnLeave: true
                                     acceptOnLostFocus: true
                                     acceptOnPointerLeave: true
                                     extent: (Point 300 29)
                                   )
                                  (ActionButtonSpec
                                     label: 'Select'
                                     name: 'ParserClassFindButton'
                                     translateLabel: true
                                     model: findParserClass
                                     defaultable: true
                                     useDynamicPreferredHeight: true
                                     usePreferredHeight: true
                                     useDefaultExtent: true
                                   )
                                  )
                                
                               )
                               extent: (Point 662 29)
                             )
                            (HorizontalPanelViewSpec
                               name: 'HorizontalPanel1'
                               horizontalLayout: left
                               verticalLayout: fit
                               horizontalSpace: 3
                               verticalSpace: 3
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Highlighter cls:'
                                     name: 'HighlighterClassLabel'
                                     translateLabel: true
                                     adjust: left
                                     extent: (Point 110 28)
                                   )
                                  (InputFieldSpec
                                     name: 'EntryField1'
                                     model: highlighterClassNameHolder
                                     type: string
                                     acceptOnLeave: true
                                     acceptOnLostFocus: true
                                     acceptOnPointerLeave: true
                                     extent: (Point 300 28)
                                   )
                                  (ActionButtonSpec
                                     label: 'Select'
                                     name: 'Button1'
                                     translateLabel: true
                                     model: findHighlighterClass
                                     defaultable: true
                                     useDynamicPreferredHeight: true
                                     usePreferredHeight: true
                                     useDefaultExtent: true
                                   )
                                  )
                                
                               )
                               extent: (Point 662 28)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 696 125)
                   useDynamicPreferredHeight: true
                   usePreferredHeight: true
                 )
                (FramedBoxSpec
                   label: 'Options'
                   name: 'OptionsBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'Options1'
                         layout: (LayoutFrame 0 0 0 0 0 0.5 0 1)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Load scanner and parser from file'
                               name: 'loadScannerAndParserFromFiles'
                               model: loadScannerAndParserFromFileHolder
                               translateLabel: true
                               useDefaultExtent: true
                             )
                            (CheckBoxSpec
                               label: 'Allow Unicode Characters'
                               name: allowUnicode
                               model: allowUnicodeHolder
                               translateLabel: true
                               useDefaultExtent: true
                             )
                            (CheckBoxSpec
                               label: 'Ignore Case'
                               name: ignoreCase
                               model: ignoreCaseHolder
                               translateLabel: true
                               useDefaultExtent: true
                             )
                            )
                          
                         )
                       )
                      (VerticalPanelViewSpec
                         name: 'Options2'
                         layout: (LayoutFrame 0 0.5 0 0 0 1 0 1)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Generate symbol comment'
                               name: generateSymbolComments
                               model: generateSymbolCommentsHolder
                               translateLabel: true
                               useDefaultExtent: true
                             )
                            (CheckBoxSpec
                               label: 'Generate item set comments'
                               name: generateItemSetComments
                               model: generateItemSetCommentsHolder
                               translateLabel: true
                               useDefaultExtent: true
                             )
                            (CheckBoxSpec
                               label: 'Generate definition comments'
                               name: generateDefinitionComments
                               model: generateDefinitionCommentsHolder
                               translateLabel: true
                               useDefaultExtent: true
                             )
                            (CheckBoxSpec
                               label: 'Show item set'
                               name: 'ShowSymbolSet'
                               model: showSymbolSetHolder
                               translateLabel: true
                               extent: (Point 331 21)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   usePreferredWidth: true
                   useDynamicPreferredHeight: true
                   usePreferredHeight: true
                   useDynamicPreferredWidth: true
                   useDefaultExtent: true
                 )
                (FramedBoxSpec
                   label: 'Files'
                   name: 'FileBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'FileBoxLabelPanel'
                         layout: (LayoutFrame 0 0 0 0 100 0 0 1)
                         horizontalLayout: fit
                         verticalLayout: fit
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Scanner:'
                               name: 'ScanneFileLabel'
                               translateLabel: true
                               adjust: right
                               extent: (Point 100 32)
                             )
                            (LabelSpec
                               label: 'Parser:'
                               name: 'ParserFileLabel'
                               translateLabel: true
                               adjust: right
                               extent: (Point 100 31)
                             )
                            )
                          
                         )
                       )
                      (VerticalPanelViewSpec
                         name: 'FileBoxFilenameEditPanel'
                         layout: (LayoutFrame 100 0 0 0 -120 1 0 1)
                         horizontalLayout: fit
                         verticalLayout: fit
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (FilenameInputFieldSpec
                               name: 'ScannerFile'
                               enableChannel: loadScannerAndParserFromFileHolder
                               model: scannerDefinitionFileHolder
                               acceptOnPointerLeave: false
                               extent: (Point 440 30)
                             )
                            (FilenameInputFieldSpec
                               name: 'ParserFile'
                               enableChannel: loadScannerAndParserFromFileHolder
                               model: parserDefinitionFileHolder
                               acceptOnPointerLeave: false
                               extent: (Point 440 30)
                             )
                            )
                          
                         )
                       )
                      (VerticalPanelViewSpec
                         name: 'FileBoxFilenameSelectPanel'
                         layout: (LayoutFrame -120 1 0 0 -60 1 0 1)
                         horizontalLayout: fit
                         verticalLayout: fit
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Select'
                               name: 'SelectScannerFile'
                               translateLabel: true
                               model: selectScannerFile
                               enableChannel: loadScannerAndParserFromFileHolder
                               isTriggerOnDown: true
                               actionValue: ''
                               extent: (Point 60 32)
                             )
                            (ActionButtonSpec
                               label: 'Select'
                               name: 'SelectParserFile'
                               translateLabel: true
                               model: selectParserFile
                               enableChannel: loadScannerAndParserFromFileHolder
                               isTriggerOnDown: true
                               actionValue: ''
                               extent: (Point 60 31)
                             )
                            )
                          
                         )
                       )
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel1'
                         layout: (LayoutFrame -60 1 0 0 0 1 0 1)
                         horizontalLayout: fit
                         verticalLayout: fit
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Edit'
                               name: 'EditScannerFile'
                               translateLabel: true
                               model: editScannerFile
                               enableChannel: loadScannerAndParserFromFileHolder
                               isTriggerOnDown: true
                               actionValue: ''
                               extent: (Point 60 32)
                             )
                            (ActionButtonSpec
                               label: 'Edit'
                               name: 'EditParserFile'
                               translateLabel: true
                               model: editParserFile
                               enableChannel: loadScannerAndParserFromFileHolder
                               isTriggerOnDown: true
                               actionValue: ''
                               extent: (Point 60 31)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 696 100)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

generateButtonSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmaCC::SmaCCParserGenerator andSelector:#generateButtonSpec
     SmaCC::SmaCCParserGenerator new openInterface:#generateButtonSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: generateButtonSpec
        window: 
       (WindowSpec
          label: 'GenerateButtonCanvas'
          name: 'GenerateButtonCanvas'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 585 58)
        )
        component: 
       (SpecCollection
          collection: (
           (ActionButtonSpec
              label: 'Compile LALR(1)'
              name: 'GenerateLARL'
              layout: (LayoutFrame 0 0 0 0 0 0.5 0 1)
              translateLabel: true
              model: compileLALR1
            )
           (ActionButtonSpec
              label: 'Compile LR(1)'
              name: 'GenerateLR'
              layout: (LayoutFrame 0 0.5 0 0 0 1 0 1)
              translateLabel: true
              model: compileLR1
            )
           )
         
        )
      )

    "Modified: / 18-03-2006 / 20:44:41 / janfrog"
!

messagesWindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmaCC::SmaCCParserGenerator andSelector:#messagesWindowSpec
     SmaCC::SmaCCParserGenerator new openInterface:#messagesWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: messagesWindowSpec
        window: 
       (WindowSpec
          label: 'Messages'
          name: 'Messages'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (TextEditorSpec
              name: 'Messages'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: conflictHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              tabRequiresControl: true
            )
           )
         
        )
      )

    "Modified: / 14-02-2008 / 10:49:02 / janfrog"
!

old_windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmaCC::SmaCCParserGenerator andSelector:#windowSpec
     SmaCC::SmaCCParserGenerator new openInterface:#windowSpec
     SmaCC::SmaCCParserGenerator open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'SmaCC Parser Generator'
          name: 'SmaCC Parser Generator'
          min: (Point 200 200)
          bounds: (Rectangle 0 0 634 524)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (TabControlSpec
              name: subcanvas
              layout: (LayoutFrame 2 0 2 0 -2 1 -2 1)
              model: tabList
              labels: ()
            )
           )
         
        )
      )

    "Created: / 11-05-2007 / 09:55:16 / janfrog"
!

parserWindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmaCC::SmaCCParserGenerator andSelector:#parserWindowSpec
     SmaCC::SmaCCParserGenerator new openInterface:#parserWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: parserWindowSpec
        window: 
       (WindowSpec
          label: 'Parser Definition'
          name: 'Parser Definition'
          bounds: (Rectangle 0 0 578 352)
        )
        component: 
       (SpecCollection
          collection: (
           (TextEditorSpec
              name: 'Parser'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: parserHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              acceptChannel: editAcceptChannel
              tabRequiresControl: true
              postBuildCallback: postBuildParserDefinitionView:
            )
           )
         
        )
      )

    "Modified: / 11-05-2007 / 12:30:42 / janfrog"
!

scannerWindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmaCC::SmaCCParserGenerator andSelector:#scannerWindowSpec
     SmaCC::SmaCCParserGenerator new openInterface:#scannerWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: scannerWindowSpec
        window: 
       (WindowSpec
          label: 'Scanner Definition'
          name: 'Scanner Definition'
          bounds: (Rectangle 0 0 200 200)
        )
        component: 
       (SpecCollection
          collection: (
           (TextEditorSpec
              name: 'ScannerView'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: scannerHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              acceptChannel: editAcceptChannel
              tabRequiresControl: true
              postBuildCallback: postBuildScannerDefinitionView:
            )
           )
         
        )
      )

    "Modified: / 11-05-2007 / 12:31:31 / janfrog"
!

testWindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmaCC::SmaCCParserGenerator andSelector:#testWindowSpec
     SmaCC::SmaCCParserGenerator new openInterface:#testWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: testWindowSpec
        window: 
       (WindowSpec
          label: 'Unlabeled Canvas'
          name: 'Unlabeled Canvas'
          bounds: (Rectangle 0 0 273 200)
        )
        component: 
       (SpecCollection
          collection: (
           (TextEditorSpec
              name: text
              layout: (LayoutFrame 0 0 0 0 0 1 -25 1)
              model: testHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              acceptChannel: editAcceptChannel
              tabRequiresControl: true
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: fit
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Parse'
                    name: parse
                    model: parse
                    extent: (Point 135 25)
                  )
                 (ActionButtonSpec
                    label: 'Parse and Inspect'
                    name: parseAndInspect
                    model: parseAndInspect
                    extent: (Point 135 25)
                  )
                 )
               
              )
            )
           )
         
        )
      )

    "Modified: / 11-05-2007 / 21:38:24 / janfrog"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmaCC::SmaCCParserGenerator andSelector:#windowSpec
     SmaCC::SmaCCParserGenerator new openInterface:#windowSpec
     SmaCC::SmaCCParserGenerator open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'SmaCC Parser Generator'
          name: 'SmaCC Parser Generator'
          min: (Point 200 200)
          bounds: (Rectangle 0 0 638 466)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (NoteBookViewSpec
              name: 'Tools'
              layout: (LayoutFrame 0 0 0 0 0 1 -25 1)
              model: tabSelectionHolder
              menu: tabList
              useIndex: true
            )
           (UISubSpecification
              name: 'CompileButtons'
              layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
              minorKey: generateButtonSpec
            )
           )
         
        )
      )

    "Modified: / 14-02-2008 / 11:28:11 / janfrog"
! !

!SmaCCParserGenerator class methodsFor:'list specs'!

tabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#tabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'Compile options'
          createNewBuilder: false
          minorKey: compileWindowSpec
        )
       (TabItem
          label: 'Messages'
          createNewBuilder: false
          minorKey: messagesWindowSpec
        )
       (TabItem
          label: 'Scanner definition'
          createNewBuilder: false
          minorKey: scannerWindowSpec
        )
       (TabItem
          label: 'Parser definition'
          createNewBuilder: false
          minorKey: parserWindowSpec
        )
       (TabItem
          label: 'Test workspace'
          createNewBuilder: false
          minorKey: testWindowSpec
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]

    "Modified: / 14-02-2008 / 11:02:24 / janfrog"
! !

!SmaCCParserGenerator class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:SmaCC::SmaCCParserGenerator andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(SmaCC::SmaCCParserGenerator mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Load scanner definition'
                  itemValue: loadScannerDefinition
                )
               (MenuItem
                  label: 'Load parser definition'
                  itemValue: loadParserDefinition
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Save scanner definition'
                  itemValue: saveScannerDefinition
                )
               (MenuItem
                  label: 'Save parser definition'
                  itemValue: saveParserDefinition
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Grammar'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Compile LALR(1)'
                  itemValue: compileLALR1
                )
               (MenuItem
                  label: 'Compile LR(1)'
                  itemValue: compileLR1
                )
               (MenuItem
                  label: 'Compile Highlighter'
                  itemValue: compileHighlighter
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Show FIRST()    '
                  itemValue: showFirstSets
                )
               (MenuItem
                  label: 'Show LAST()'
                  itemValue: showLastSets
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Inspect Grammar'
                  itemValue: inspectGrammar
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Help'
            startGroup: right
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'About this Application'
                  itemValue: openAboutThisApplication
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
! !

!SmaCCParserGenerator methodsFor:'accessing'!

highlighterClass

    ^RBClass new 
        name: self highlighterClassName asSymbol;
        model: (RBNamespace new
                    name: 'Compile Highlighter';
                    yourself);
        yourself

    "Created: / 14-08-2009 / 20:41:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

highlighterClassName
    ^ self highlighterClassNameHolder value

    "Created: / 14-08-2009 / 20:27:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

loadScannerAndParserFromFile

    ^self loadScannerAndParserFromFileHolder value

    "Created: / 11-05-2007 / 12:53:44 / janfrog"
!

parserClass
	^self parserClassNameHolder value asQualifiedReference value
!

parserClassName
    ^ self parserClassNameHolder value

    "Created: / 11-05-2007 / 12:41:24 / janfrog"
!

parserDefinition
    ^ self loadScannerAndParserFromFileHolder value 
        ifTrue:[ self parserDefinitionFile contents asString ]
        ifFalse:[ self parserHolder value ]

    "Created: / 18-03-2006 / 16:53:09 / janfrog"
    "Modified: / 11-05-2007 / 12:52:36 / janfrog"
!

parserDefinition: aString
    ^ self parserHolder value: aString

    "Created: / 12-05-2007 / 20:48:49 / janfrog"
!

parserDefinitionFile
    ^ self parserDefinitionFileHolder value asFilename

    "Created: / 11-05-2007 / 12:52:36 / janfrog"
!

scannerClass
        ^self scannerClassNameHolder value asQualifiedReference value

    "Created: / 11-05-2007 / 12:59:45 / janfrog"
!

scannerClassName
    ^ self scannerClassNameHolder value

    "Created: / 11-05-2007 / 12:41:07 / janfrog"
!

scannerDefinition
    ^ self loadScannerAndParserFromFileHolder value 
        ifTrue:[ self scannerDefinitionFile contents asString ]
        ifFalse:[ self scannerHolder value ]

    "Created: / 18-03-2006 / 16:53:09 / janfrog"
    "Modified: / 11-05-2007 / 12:53:10 / janfrog"
!

scannerDefinition: aString
    ^ self scannerHolder value: aString

    "Created: / 12-05-2007 / 20:49:01 / janfrog"
!

scannerDefinitionFile
    ^ self scannerDefinitionFileHolder value asFilename

    "Created: / 11-05-2007 / 12:53:10 / janfrog"
!

tabSelection: index

    self tabSelectionHolder value:2

    "Created: / 14-02-2008 / 11:29:34 / janfrog"
!

tabSelectionToMessages

    self tabSelection: 2

    "Created: / 14-02-2008 / 11:30:33 / janfrog"
!

tabSelectionToOptions

    self tabSelection: 1

    "Created: / 14-02-2008 / 11:30:24 / janfrog"
!

tabSelectionToParserDefinition

    self tabSelection: 4

    "Created: / 14-02-2008 / 11:30:48 / janfrog"
!

tabSelectionToScannerDefinition

    self tabSelection: 3

    "Created: / 14-02-2008 / 11:30:43 / janfrog"
! !

!SmaCCParserGenerator methodsFor:'accessing - defaults'!

defaultDefinitionFileDirectory

    | defDir |

    defDir := Filename homeDirectory.

    self scannerClass 
        ifNil:[^defDir].
    self parserClass 
        ifNil:[^defDir].
    self scannerClass package ~= self parserClass package 
        ifTrue:[^defDir].

    defDir := Smalltalk getPackageDirectoryForPackage: self scannerClass package.
    defDir ifNil:[^self defaultDefinitionFileDirectory].
    (defDir construct:'resources') exists 
        ifTrue:[defDir := defDir construct:'resources'].
    (defDir construct:'grammar') exists 
        ifTrue:[defDir := defDir construct:'grammar'].
    ^defDir

    "Created: / 11-05-2007 / 13:01:47 / janfrog"
    "Modified: / 11-08-2009 / 16:25:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultParserDefinitionFilename
    ^ self defaultDefinitionFileDirectory / 'parser.txt'

    "Created: / 11-05-2007 / 13:16:34 / janfrog"
    "Modified: / 11-08-2009 / 16:26:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultScannerDefinitionFilename
    ^ self defaultDefinitionFileDirectory / 'scanner.txt'

    "Created: / 11-05-2007 / 13:16:34 / janfrog"
    "Modified: / 11-08-2009 / 16:26:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmaCCParserGenerator methodsFor:'actions'!

aboutThisApplicationText
    "text for an about box for this application."

    |rev clsRev msg|

    rev := ''.

    (clsRev := self class revision) notNil ifTrue: [rev := '  (rev: ', clsRev printString, ')'].

    msg := 'SmaCC Compiler-Compiler framework.
Written by John Brant and Don Roberts.\\
Smalltalk/X UI by Jan Vrany.\\
Available for VisualWorks, Dolphin, VisualAge and Smalltalk/X.
\\' withCRs , self class name asBoldText, rev.
    ^ msg

    "Created: / 13-11-2001 / 12:28:36 / cg"
    "Modified: / 11-05-2007 / 12:24:42 / janfrog"
!

compileHighlighter 
    |grammar class changes oldIgnoreCase oldCharacterSize scannerCompiler |

    self acceptDefinitions.
    (self highlighterClassName isEmpty or:[ self parserClassName isEmpty ]) ifTrue:[
        ^ self warn:'Syntax highlighter and/or parser class name not specified'
    ].
    self 
        withWaitCursorDo:[
            self verifySyntax ifFalse:[
                ^ self
            ].
            oldIgnoreCase := SmaCCGrammar ignoreCase.
            oldCharacterSize := SmaCCGrammar maximumCharacterValue.
            [
                SmaCCGrammar
                    ignoreCase:self ignoreCaseHolder value;
                    maximumCharacterValue:(self allowUnicodeHolder value 
                                ifTrue:[ (2 raisedTo:16) - 1 ]
                                ifFalse:[ 255 ]).
                grammar := SmaCCGrammar new.
                scannerCompiler := 
                    SmaCCScannerCompiler new                                    
                        scannerDefinitionString: self scannerDefinition;
                        scannerClass: (class := self highlighterClass);
                        grammar: grammar;
                        parseTokens.
                (SmaCCGrammarParser on: (ReadStream on: self parserDefinition))
                    grammar: grammar;
                    parse.
                scannerCompiler compileScanner.
                changes := class model changes.
                RefactoryChangeManager instance performChange: changes.
                (Smalltalk at: class name) initializeKeywordMap.

            ] on: Error do: [:ex|ex pass]
    ].

    "Modified: / 14-02-2008 / 13:30:27 / janfrog"
    "Created: / 14-08-2009 / 20:29:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

compileLALR1
        self compile: #LALR1

    "Modified: / 11-05-2007 / 12:32:58 / janfrog"
!

compileLR1
	self compile: #LR1
!

editParserFile

    Desktop edit: self parserDefinitionFile

    "Created: / 11-08-2009 / 16:28:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 11-08-2009 / 17:50:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

editScannerFile

    Desktop edit: self scannerDefinitionFile

    "Created: / 11-08-2009 / 16:28:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 11-08-2009 / 17:50:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

findHighlighterClass
        | class |
        class := self 
                    choose: 'What class do you want to use?'
                    from: (SmaCCScanner allSubclasses asSortedCollection: [:a :b | a name < b name]).
        class isNil ifTrue: [^self].
        self highlighterClassNameHolder value: class fullName.

    "Created: / 14-08-2009 / 20:25:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

findParserClass
        | class |
        class := self choose: 'What class do you want to use?'
                                from: (SmaCCParser allSubclasses asSortedCollection: [:a :b | a name < b name]).
        class isNil ifTrue: [^self].
        self parserClassNameHolder value: class fullName.
        (class class includesSelector: #parserDefinitionComment) 
                ifTrue: 
                        [(self confirm: 'Do you wish to load the parser definition?') 
                                ifTrue: 
                                        [self parserHolder value: (self 
                                                                removeCommentedPartOf: (class class sourceCodeAt: #parserDefinitionComment))]]

    "Modified: / 11-05-2007 / 12:27:46 / janfrog"
!

findScannerClass
	| class |
	class := self choose: 'What class do you want to use?'
				from: (SmaCCScanner allSubclasses asSortedCollection: [:a :b | a name < b name]).
	class isNil ifTrue: [^self].
	self scannerClassNameHolder value: class fullName.
	(class class includesSelector: #scannerDefinitionComment) 
		ifTrue: 
			[(self confirm: 'Do you wish to load the scanner definition?') 
				ifTrue: 
					[self scannerHolder value: (self 
								removeCommentedPartOf: (class class sourceCodeAt: #scannerDefinitionComment))]]
!

inspectGrammar
    | compiler |

    self verifySyntax ifFalse:[
        ^ self
    ].   
    compiler := SmaCCGrammarCompiler new.
    compiler buildScanner:self scannerDefinition andParser:self parserDefinition.
    compiler grammar inspect.

    "Modified: / 24-02-2016 / 09:47:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadParserDefinition

    | file stream |
    (file := Dialog requestFileName:'Select parser definition file' default:'parser.txt')
        isNilOrEmptyCollection ifTrue:[^self].

    file asFilename exists ifFalse:
        [(Dialog warn:'File does not exist.').^self].

    stream := file asFilename readStream.
    [ self parserDefinition: stream contents asString ]
        ensure: [stream close]

    "Created: / 12-05-2007 / 20:50:34 / janfrog"
!

loadScannerDefinition

    | file stream |
    (file := Dialog requestFileName:'Select scanner definition file' default:'scanner.txt')
        isNilOrEmptyCollection ifTrue:[^self].

    file asFilename exists ifFalse:
        [(Dialog warn:'File does not exist.').^self].

    stream := file asFilename readStream.
    [ self scannerDefinition: stream contents asString ]
        ensure: [stream close]

    "Created: / 12-05-2007 / 20:52:19 / janfrog"
    "Modified: / 11-08-2009 / 16:18:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

openAboutThisAppliaction
    Dialog
        about:(resources string:self aboutThisApplicationText)
        label:(resources string:self aboutThisApplicationLabel)
        icon:self aboutImage
!

openDocumentation
    "opens the documentation file of the Parsergenerator"

    HTMLDocumentView openFullOnDocumentationFile:'../../../goodies/smaCC/documentation/Tutorial.html'
!

parse
        self editAcceptChannel value:true.
        self parseAndEvaluate: [:each | self warn: 'Parses without errors']
!

parseAndInspect
        self editAcceptChannel value:true.
        self parseAndEvaluate: [:each | each inspect]
!

saveParserDefinition

    | file stream |
    (file := Dialog requestFileName:'Save parser definition as' default:'parser.txt')
        isNilOrEmptyCollection ifTrue:[^self].

    file asFilename exists ifTrue:
        [(Dialog confirm:'File exists. Overwrite?') ifFalse:[^self]].

    stream := file asFilename writeStream.
    [ stream nextPutAll:self parserDefinition ]
        ensure: [stream close]

    "Created: / 12-05-2007 / 20:46:15 / janfrog"
!

saveScannerDefinition

    | file stream |
    (file := Dialog requestFileName:'Save scanner definition as' default:'scanner.txt')
        isNilOrEmptyCollection ifTrue:[^self].

    file asFilename exists ifTrue:
        [(Dialog confirm:'File exists. Overwrite?') ifFalse:[^self]].

    stream := file asFilename writeStream.
    [ stream nextPutAll:self scannerDefinition ]
        ensure: [stream close]

    "Created: / 12-05-2007 / 20:46:50 / janfrog"
!

selectParserFile
    | fileName |

    (fileName := Dialog 
                requestFileName: 'Select parser definition file'
                default: self defaultParserDefinitionFilename
                fromDirectory: self defaultDefinitionFileDirectory) isNilOrEmptyCollection 
        ifFalse: [ self parserDefinitionFileHolder value: fileName ]

    "Modified: / 11-05-2007 / 13:16:01 / janfrog"
    "Modified: / 11-08-2009 / 16:27:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectScannerFile
    | fileName |

    (fileName := Dialog 
                requestFileName: 'Select parser definition file'
                default: self defaultScannerDefinitionFilename
                fromDirectory: self defaultDefinitionFileDirectory) isNilOrEmptyCollection 
        ifFalse: [ self scannerDefinitionFileHolder value: fileName ]

    "Modified: / 11-05-2007 / 13:16:16 / janfrog"
    "Modified: / 11-08-2009 / 16:27:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showFirstSets
    | compiler grammar |

    self verifySyntax ifFalse:[
        ^ self
    ].   
    compiler := SmaCCGrammarCompiler new.
    compiler buildScanner:self scannerDefinition andParser:self parserDefinition.
    grammar := compiler grammar.       
    grammar calculateFirstSets.
    self conflictHolder value: (String streamContents:[ :s |
        grammar symbols do:[:symbol | 
            symbol isTerminal ifFalse:[ 
                s nextPutAll: 'FIRST('; nextPutAll: symbol name; nextPutAll: ') = {'.
                symbol firstTerminals do:[:term | s nextPutAll: term name ] separatedBy: [ s nextPutAll: ', ' ].
                s nextPutAll: '}'; cr.
            ].
        ].
    ])

    "Modified: / 24-02-2016 / 10:12:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showLastSets
    | compiler grammar |

    self verifySyntax ifFalse:[
        ^ self
    ].   
    compiler := SmaCCGrammarCompiler new.
    compiler buildScanner:self scannerDefinition andParser:self parserDefinition.
    grammar := compiler grammar.       
    grammar calculateLastSets.
    self conflictHolder value: (String streamContents:[ :s |
        grammar symbols do:[:symbol | 
            symbol isTerminal ifFalse:[ 
                s nextPutAll: 'LAST('; nextPutAll: symbol name; nextPutAll: ') = {'.
                symbol lastTerminals do:[:term | s nextPutAll: term name ] separatedBy: [ s nextPutAll: ', ' ].
                s nextPutAll: '}'; cr.
            ].
        ].
    ])

    "Modified: / 24-02-2016 / 10:12:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmaCCParserGenerator methodsFor:'aspects'!

allowUnicodeHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^allowUnicodeHolder isNil
		ifTrue:
			[allowUnicodeHolder := false asValue]
		ifFalse:
			[allowUnicodeHolder]
!

conflictHolder
        "This method was generated by UIDefiner.  Any edits made here
        may be lost whenever methods are automatically defined.  The
        initialization provided below may have been preempted by an
        initialize method."

        conflictHolder ifNil: 
            [conflictHolder := String new asValue.
            conflictHolder onChangeEvaluate:
                    [self tabSelectionToMessages]].
        ^conflictHolder

    "Modified: / 14-02-2008 / 11:35:18 / janfrog"
!

editAcceptChannel
        ^editAcceptChannel isNil
                ifTrue:
                        [editAcceptChannel := TriggerValue new]
                ifFalse:
                        [editAcceptChannel]
!

generateDefinitionCommentsHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^generateDefinitionCommentsHolder isNil
		ifTrue:
			[generateDefinitionCommentsHolder := false asValue]
		ifFalse:
			[generateDefinitionCommentsHolder]
!

generateItemSetCommentsHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^generateItemSetCommentsHolder isNil
		ifTrue:
			[generateItemSetCommentsHolder := false asValue]
		ifFalse:
			[generateItemSetCommentsHolder]
!

generateSymbolCommentsHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^generateSymbolCommentsHolder isNil
		ifTrue:
			[generateSymbolCommentsHolder := false asValue]
		ifFalse:
			[generateSymbolCommentsHolder]
!

highlighterClassNameHolder
        "This method was generated by UIDefiner.  Any edits made here
        may be lost whenever methods are automatically defined.  The
        initialization provided below may have been preempted by an
        initialize method."

        ^highlighterClassNameHolder isNil
                ifTrue:
                        [highlighterClassNameHolder := nil asValue]
                ifFalse:
                        [highlighterClassNameHolder]

    "Created: / 20-07-2009 / 22:36:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

ignoreCaseHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^ignoreCaseHolder isNil
		ifTrue:
			[ignoreCaseHolder := false asValue]
		ifFalse:
			[ignoreCaseHolder]
!

loadScannerAndParserFromFileHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    loadScannerAndParserFromFileHolder isNil ifTrue:[
        loadScannerAndParserFromFileHolder := false asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       loadScannerAndParserFromFileHolder addDependent:self.
         loadScannerAndParserFromFileHolder onChangeSend:#loadScannerAndParserFromFileHolderChanged to:self.
    ].
    ^ loadScannerAndParserFromFileHolder.

    "Created: / 18-03-2006 / 16:34:16 / janfrog"
    "Modified: / 11-08-2009 / 16:13:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

parserClassNameHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^parserClassNameHolder isNil
		ifTrue:
			[parserClassNameHolder := nil asValue]
		ifFalse:
			[parserClassNameHolder]
!

parserDefinitionFileHolder
    "automatically generated by UIPainter ..."
    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"
    
    parserDefinitionFileHolder isNil ifTrue:[
        parserDefinitionFileHolder := ValueHolder new.
        
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       parserFileHolder addDependent:self.
"/       parserFileHolder onChangeSend:#parserFileHolderChanged to:self.
    ].
    ^ parserDefinitionFileHolder.

    "Created: / 11-05-2007 / 12:47:09 / janfrog"
!

parserHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^parserHolder isNil
		ifTrue:
			[parserHolder := String new asValue]
		ifFalse:
			[parserHolder]
!

scannerClassNameHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^scannerClassNameHolder isNil
		ifTrue:
			[scannerClassNameHolder := nil asValue]
		ifFalse:
			[scannerClassNameHolder]
!

scannerDefinitionFileHolder
    "automatically generated by UIPainter ..."
    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"
    
    scannerDefinitionFileHolder isNil ifTrue:[
        scannerDefinitionFileHolder := ValueHolder new.
        
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       scannerFileHolder addDependent:self.
"/       scannerFileHolder onChangeSend:#scannerFileHolderChanged to:self.
    ].
    ^ scannerDefinitionFileHolder.

    "Created: / 11-05-2007 / 12:47:20 / janfrog"
!

scannerHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^scannerHolder isNil
		ifTrue:
			[scannerHolder := String new asValue]
		ifFalse:
			[scannerHolder]
!

showSymbolSetHolder
        "This method was generated by UIDefiner.  Any edits made here
        may be lost whenever methods are automatically defined.  The
        initialization provided below may have been preempted by an
        initialize method."

        ^showSymbolSetHolder isNil
                ifTrue:
                        [showSymbolSetHolder := false asValue]
                ifFalse:
                        [showSymbolSetHolder]

    "Created: / 04-11-2008 / 06:57:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

tabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#tabList) isNil ifTrue:[
        builder aspectAt:#tabList put:(list := self class tabList).
    ].
    ^ list

    "Created: / 11-05-2007 / 10:12:06 / janfrog"
!

tabSelectionHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    tabSelectionHolder isNil ifTrue:[
        tabSelectionHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       tabSelectionHolder addDependent:self.
"/       tabSelectionHolder onChangeSend:#tabSelectionHolderChanged to:self.
    ].
    ^ tabSelectionHolder.

    "Created: / 31-10-2007 / 08:08:31 / janfrog"
!

testHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^testHolder isNil
		ifTrue:
			[testHolder := String new asValue]
		ifFalse:
			[testHolder]
! !

!SmaCCParserGenerator methodsFor:'change & update'!

loadScannerAndParserFromFileHolderChanged

    loadScannerAndParserFromFileHolder value ifTrue:
        [| file  |
        file := self defaultScannerDefinitionFilename.
        (file notNil and:[file exists]) ifTrue:
            [self scannerDefinitionFileHolder value: file asString].
        file := self defaultParserDefinitionFilename.
        (file notNil and:[file exists]) ifTrue:
            [self parserDefinitionFileHolder value: file asString].
        ]

    "Created: / 11-08-2009 / 16:13:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmaCCParserGenerator methodsFor:'hooks'!

postBuildParserDefinitionView: aView

    parserEditTextView := aView scrolledView

    "Created: / 11-05-2007 / 12:32:11 / janfrog"
!

postBuildScannerDefinitionView: aView

    scannerEditTextView := aView scrolledView

    "Created: / 11-05-2007 / 12:32:26 / janfrog"
! !

!SmaCCParserGenerator methodsFor:'initialize-release'!

initialize
        super initialize.
"        (self tabList)
                list: #('Scanner' 'Parser' 'Compile' 'Test') asList;
                selectionIndex: 3.
        self tabList selectionIndexHolder onChangeSend: #changedTab to: self."
        self scannerClassNameHolder value: ''.
        self parserClassNameHolder value: ''.
        self scannerHolder value: ''.
        self parserHolder value: ''.
        self testHolder value: ''.
        self generateDefinitionCommentsHolder value: true

    "Modified: / 11-05-2007 / 10:11:09 / janfrog"
! !

!SmaCCParserGenerator methodsFor:'interface opening'!

_postBuildWith: aBuilder 
        "builder == aBuilder ifFalse: [subcanvasBuilder := aBuilder].
        (aBuilder componentAt: #text) 
                ifNotNil: [:each | each widget controller continuousAccept: true].
        super postBuildWith: aBuilder"

    "Created: / 11-05-2007 / 10:08:48 / janfrog"
!

_postOpenWith: aBuilder 
        "super postOpenWith: aBuilder.
        compileWindowSpec"

    "Created: / 11-05-2007 / 10:08:54 / janfrog"
! !

!SmaCCParserGenerator methodsFor:'private'!

acceptDefinitions

    scannerEditTextView accept.
    parserEditTextView accept.

    "Created: / 11-05-2007 / 12:34:48 / janfrog"
!

choose: title from: collection
    ^Dialog
                choose:title 
                fromList:collection 
                lines:collection size

    "Created: / 11-05-2007 / 10:31:04 / janfrog"
!

compile:aSymbol 
    |grammar stream oldIgnoreCase oldCharacterSize parserCompiler showItemSets |

    self acceptDefinitions.
    (self scannerClassName isEmpty or:[ self parserClassName isEmpty ]) ifTrue:[
        ^ self warn:'Both classes are not specified'
    ].
    self 
        withWaitCursorDo:[
            self verifySyntax ifFalse:[
                ^ self
            ].
            oldIgnoreCase := SmaCCGrammar ignoreCase.
            oldCharacterSize := SmaCCGrammar maximumCharacterValue.
            [
                SmaCCGrammar
                    ignoreCase:self ignoreCaseHolder value;
                    maximumCharacterValue:(self allowUnicodeHolder value 
                                ifTrue:[ (2 raisedTo:16) - 1 ]
                                ifFalse:[ 255 ]).
                parserCompiler := SmaCCGrammarCompiler new.
                parserCompiler
                    buildScanner:self scannerDefinition andParser:self parserDefinition;
                    scannerClass:self scannerClassName;
                    parserClass:self parserClassName.
                grammar := parserCompiler grammar.
                grammar type:aSymbol.
                stream := WriteStream on:Text new.
                showItemSets := false.
                [
                    parserCompiler createChanges.
                    self generateDefinitionCommentsHolder value ifTrue:[
                        parserCompiler compileDefinitionComments
                    ].
                    self generateSymbolCommentsHolder value ifTrue:[
                        parserCompiler compileSymbolComment
                    ].
                    self generateItemSetCommentsHolder value ifTrue:[
                        parserCompiler compileItemSetsComment
                    ].
                    parserCompiler compileChanges
                ] on:SmaCCCompilationNotification
                        do:[:ex | 
                    showItemSets := self showSymbolSetHolder value.
                    (ShowPrecedenceConflicts or:[ ('*precedence*' match:ex messageText) not ]) ifTrue:[
                        stream
                            nextPutAll:'-------------------------\' withCRs asText 
                                        , ex messageText asText allBold;
                            cr;
                            cr;
                            nextPutAll:ex parameter;
                            cr
                    ].
                    ex pass
                ].
                showItemSets ifTrue:[
                    stream cr; nextPutAll:'Item sets' asText allBold; cr; cr.
                    parserCompiler itemSets keysAndValuesDo:
                        [:itemSetNumber :itemSet|
                        itemSet id: itemSetNumber.
                        "/stream nextPutAll: itemSetNumber printString asText allBold.
                        stream nextPut:$:.
                        stream cr.
                        itemSet printOn: stream.
                        stream cr; cr].
                ].
                self conflictHolder value:stream contents.
            ] ensure:[
                SmaCCGrammar
                    ignoreCase:oldIgnoreCase;
                    maximumCharacterValue:oldCharacterSize
            ]
        ]

    "Modified: / 14-02-2008 / 13:30:27 / janfrog"
    "Modified: / 04-11-2008 / 07:00:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

displayError: aString at: position 
        |w|

        w := self textWidget.
        w notNil ifTrue:[ 
                        w takeKeyboardFocus.
                        w widget controller insertAndSelect: aString , ' ->' at: position]
!

parseAndEvaluate: aBlock 
	| class |
	class := self parserClass.
	class isNil ifTrue: [^self warn: 'No parser defined'].
	aBlock value: (class parse: self testHolder value
				onError: 
					[:aString :position | 
					self tabList selection: 'Test'.
					self displayError: aString at: position.
					^self])
!

removeCommentedPartOf: aString 
	| inStream outStream |
	inStream := ReadStream on: aString.
	outStream := WriteStream on: String new.
	inStream upTo: $".
	[inStream atEnd] whileFalse: 
			[(inStream peekFor: $") ifTrue: [outStream nextPut: $"].
			outStream nextPutAll: (inStream upTo: $")].
	^outStream contents
!

selectedSpec
	^(self tabList selection asLowercase , 'WindowSpec') asSymbol
!

syntaxError: aString inFile:file at:position

    | fileContents skipped lineNo|
    fileContents := file asFilename contents.
    skipped := 0.
    lineNo := 1.
    fileContents do:[:line|
        skipped := skipped + line size + 1.
        (skipped > position) ifTrue:
            [^Dialog warn:'Syntax error: ',aString, Character cr, ' in ',file,' at line #',lineNo printString].
        lineNo := lineNo + 1.
    ]

    "Created: / 09-04-2006 / 18:13:26 / janfrog"
!

verifyParser
    ^ [
        SmaCCGrammarCompiler new buildScanner:self scannerDefinition
            andParser:self parserDefinition.
        true
    ] on:SmaCCParserError
            do:[:ex | 
        self loadScannerAndParserFromFileHolder value ifTrue:[
            self 
                syntaxError:ex description
                inFile:self parserDefinitionFileHolder value
                at:ex parameter position
        ] ifFalse:[
            self tabList selection:'Parser'.
            self displayError:ex description at:ex parameter position
        ].
        ex return:false
    ]

    "Modified: / 11-05-2007 / 12:47:09 / janfrog"
!

verifyScanner
        SmaCCScannerParser parse: self scannerDefinition
                onError: 
                        [:aString :position |
                        self loadScannerAndParserFromFileHolder value
                            ifTrue:
                                [self syntaxError:aString inFile:scannerDefinitionFileHolder value at:position]
                            ifFalse:
                                [self tabSelectionToScannerDefinition.
                                self displayError: aString at: position].                            
                        ^false].
        ^true

    "Modified: / 14-02-2008 / 11:31:24 / janfrog"
!

verifySyntax
	^self verifyScanner and: [self verifyParser]
! !

!SmaCCParserGenerator class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !


SmaCCParserGenerator initialize!
