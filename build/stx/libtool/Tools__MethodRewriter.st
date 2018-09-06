"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2015 Jan Vrany

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ApplicationModel subclass:#MethodRewriter
	instanceVariableNames:'replaceTextView methods classes packages searchTextView
		actionInProgressHolder infoHolder progressHolder
		templateSearchPatternHolder templateReplacePatternHolder
		selectedTemplateIndex templates selectedTabIndex
		selectedClassesHolder selectedRuleIndex rules
		ruleReplacePatternHolder ruleSearchPatternHolder
		ruleSearchAndReplacePatternHolder ruleForRewriteOrNilForAdHoc
		adHocFindAndReplaceVisibleHolder ruleNameHolder
		isMethodPatternHolder classesInfoTextHolder
		cachedMethodsFromClasses'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools'
!

!MethodRewriter class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2015 Jan Vrany

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!MethodRewriter class methodsFor:'example templates'!

templateReplaceAtIfAbsentByAtAifAbsentPut

    ^Array
	with:('Replace ','Dictionary>>#at:ifAbsent:'allBold,' by ','#at:ifAbsentPut:' allBold)
with: '``@dictionary
    at: ``@key
    ifAbsent:
	[| `@temps |
	`@.statements.
	``@dictionary at: ``@key put: ``@object]'
with:'``@dictionary
    at: ``@key
    ifAbsentPut:
	[| `@temps |
	`@.statements.
	``@object]'

    "Created: / 12-12-2007 / 11:08:01 / janfrog"
    "Modified: / 17-02-2008 / 08:35:17 / janfrog"
    "Modified: / 04-07-2011 / 17:41:21 / cg"
!

templateReplaceIfNilByIsNilIfTrue

    ^Array
	with:('Replace ','ifNil:' allBold,' by ','isNil ifTrue:' allBold)
	with: '``@receiver ifNil: ``@block'
	with: '``@receiver isNil ifTrue: ``@block'

    "Created: / 04-07-2011 / 19:25:06 / cg"
!

templateReplaceIfNotNilByNotNilIfTrue

    ^Array
	with:('Replace ','ifNotNil:' allBold,' by ','notNil ifTrue:' allBold)
	with: '``@receiver ifNotNil: ``@block'
	with: '``@receiver notNil ifTrue: ``@block'
!

templateReplaceIsNilOrEmptyCollectionByIsEmptyOrNil

    ^Array
	with:('Replace ','isNilOrEmptyCollection' allBold,' by ','isEmptyOrNil' allBold)
	with: '``@receiver isNilOrEmptyCollection'
	with: '``@receiver isEmptyOrNil'''

    "Created: / 03-07-2011 / 21:59:47 / cg"
!

templateReplaceSelfHaltBySelfBreakPoint
    |initials|

    initials := OperatingSystem getLoginName.

    ^Array
	with:('Replace ','self halt' allBold,' by ','self breakPoint: #' allBold ,initials)
	with: 'self halt'
	with: 'self breakPoint: #',initials

    "Modified: / 17-02-2008 / 08:35:09 / janfrog"
    "Created: / 04-07-2011 / 17:43:46 / cg"
!

templateReplaceSelfHaltBySelfError

    ^Array
	with:('Replace ','self halt'allBold,' by ','self error:''was: self halt''' allBold)
	with: 'self halt'
	with: 'self error:''was: self halt'''

    "Created: / 12-12-2007 / 11:29:51 / janfrog"
    "Modified: / 17-02-2008 / 08:35:09 / janfrog"
    "Modified: / 04-07-2011 / 17:41:33 / cg"
!

templates
    "finds all methods here, which start with 'template'"

    |templateSelectors templatesHere|

    templateSelectors :=
	(self class selectors select:[:e|(e startsWith:'template')
	    and:[e ~= #templates and:[e ~= #templatesSpec]]]).

    templatesHere := templateSelectors collect:[:e| (self perform:e) copyWith:nil ].
    templatesHere := templatesHere sort:[:a :b | a first < b first].
    ^ templatesHere

    "
     self templates
    "

    "Created: / 12-12-2007 / 11:03:32 / janfrog"
! !

!MethodRewriter class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::MethodRewriter
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#isMethodPattern
'The patterns are applied to the method''s whole source (including selector)\as opposed to the code''s syntax tree nodes.\(read the pattern help on this)'

#doSearchAction
'Searches for matching methods and opens a browser on those.'

#doReplaceAction
'Searches for matching methods, generates the new code and presents a list of changes.\This list allows for inspection and individual selection of changes to be applied'

)
! !

!MethodRewriter class methodsFor:'interface specs'!

classesSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::MethodRewriter andSelector:#classesSpec
     Tools::MethodRewriter new openInterface:#classesSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: classesSpec
       window: 
      (WindowSpec
         label: 'Classes'
         name: 'Classes'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Hint: drag''n''drop classes, methods or packages from browser'
             name: 'HintLabel'
             layout: (LayoutFrame 0 0 0 0 0 1 30 0)
             translateLabel: true
             adjust: left
           )
          (SelectionInListModelViewSpec
             name: 'ClassesList'
             layout: (LayoutFrame 0 0 30 0 0 1 -60 1)
             model: selectedClassesHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             listModel: classes
             multipleSelectOk: true
             useIndex: false
             highlightMode: line
             properties: 
            (PropertyListDictionary
               canDropSelector: canDropClasses:
               dropArgument: nil
               dropSelector: doDropClasses:
               dragArgument: nil
             )
           )
          (LabelSpec
             name: 'ClassInfoLabel'
             layout: (LayoutFrame 0 0 -60 1 0 1 -34 1)
             translateLabel: true
             labelChannel: classesInfoTextHolder
             adjust: left
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -34 1 0 1 0 1)
             horizontalLayout: center
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Add All Your Packages'
                   name: 'AddAllYourPackagesButton'
                   translateLabel: true
                   model: addAllYourPackagesAction
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Add All Packages'
                   name: 'AddAllPackagesButton'
                   translateLabel: true
                   model: addAllPackagesAction
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Remove Selected Classes'
                   name: 'RemoveSelectedClassesButton'
                   translateLabel: true
                   model: removeSeletedClassesAction
                   useDefaultExtent: true
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
!

howToUseSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::MethodRewriter andSelector:#howToUseSpec
     Tools::MethodRewriter new openInterface:#howToUseSpec
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: howToUseSpec
       window:
      (WindowSpec
	 label: 'Classes'
	 name: 'Classes'
	 min: (Point 10 10)
	 bounds: (Rectangle 0 0 300 300)
       )
       component:
      (SpecCollection
	 collection: (
	  (HTMLViewSpec
	     name: 'HTMLBrowser1'
	     layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	     model: howToUseRewriteToolURL
	     hasHorizontalScrollBar: true
	     hasVerticalScrollBar: true
	   )
	  )

       )
     )
!

rulesSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::MethodRewriter andSelector:#rulesSpec
     Tools::MethodRewriter new openInterface:#rulesSpec
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: rulesSpec
       window:
      (WindowSpec
	 label: 'Method Rewriter'
	 name: 'Method Rewriter'
	 min: (Point 10 10)
	 bounds: (Rectangle 0 0 472 354)
       )
       component:
      (SpecCollection
	 collection: (
	  (VariableVerticalPanelSpec
	     name: 'FindAndReplacePanel'
	     layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
	     showHandle: true
	     snapMode: both
	     component:
	    (SpecCollection
	       collection: (
		(SelectionInListModelViewSpec
		   name: 'SelectionInListModelView1'
		   model: selectedRuleIndex
		   hasHorizontalScrollBar: true
		   hasVerticalScrollBar: true
		   listModel: ruleNameList
		   highlightMode: line
		 )
		(ViewSpec
		   name: 'ReplaceBox'
		   component:
		  (SpecCollection
		     collection: (
		      (LabelSpec
			 label: 'Finds and Replaces With:'
			 name: 'ReplaceLabel'
			 layout: (LayoutFrame 0 0 0 0 0 1 20 0)
			 translateLabel: true
			 adjust: left
		       )
		      (TextEditorSpec
			 name: 'ReplaceText'
			 layout: (LayoutFrame 0 0 20 0 0 1 0 1)
			 model: ruleSearchAndReplacePatternHolder
			 hasHorizontalScrollBar: true
			 hasVerticalScrollBar: true
			 isReadOnly: true
			 hasKeyboardFocusInitially: false
		       )
		      )

		   )
		 )
		)

	     )
	     handles: (Any 0.5 1.0)
	   )
	  (HorizontalPanelViewSpec
	     name: 'HorizontalPanel1'
	     layout: (LayoutFrame 0 0 -30 1 -16 1 0 1)
	     horizontalLayout: center
	     verticalLayout: center
	     horizontalSpace: 3
	     verticalSpace: 3
	     component:
	    (SpecCollection
	       collection: (
		(ActionButtonSpec
		   label: 'Use Rule'
		   name: 'UseAsRuleButton'
		   translateLabel: true
		   model: useAsRuleAction
		   useDefaultExtent: true
		 )
		)

	     )
	     keepSpaceForOSXResizeHandleH: true
	   )
	  )

       )
     )
!

searchAndReplaceSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::MethodRewriter andSelector:#searchAndReplaceSpec
     Tools::MethodRewriter new openInterface:#searchAndReplaceSpec
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: searchAndReplaceSpec
       window:
      (WindowSpec
	 label: 'Method Rewriter'
	 name: 'Method Rewriter'
	 min: (Point 10 10)
	 bounds: (Rectangle 0 0 418 294)
       )
       component:
      (SpecCollection
	 collection: (
	  (ViewSpec
	     name: 'MethodPatternBox'
	     layout: (LayoutFrame 0 0 0 0 0 1 30 0)
	     component:
	    (SpecCollection
	       collection: (
		(CheckBoxSpec
		   label: 'Method Pattern'
		   name: 'CheckBox1'
		   layout: (LayoutFrame 0 0 8 0 136 0 30 0)
		   activeHelpKey: isMethodPattern
		   model: isMethodPatternHolder
		   translateLabel: true
		 )
		)

	     )
	   )
	  (VariableVerticalPanelSpec
	     name: 'FindAndReplacePanel'
	     layout: (LayoutFrame 0 0 30 0 0 1 -30 1)
	     visibilityChannel: adHocFindAndReplaceVisibleHolder
	     showHandle: true
	     snapMode: both
	     component:
	    (SpecCollection
	       collection: (
		(ViewSpec
		   name: 'FindBox'
		   component:
		  (SpecCollection
		     collection: (
		      (LabelSpec
			 label: 'Find:'
			 name: 'FindLabel'
			 layout: (LayoutFrame 0 0 0 0 0 1 20 0)
			 translateLabel: true
			 adjust: left
		       )
		      (TextEditorSpec
			 name: 'FindText'
			 layout: (LayoutFrame 0 0 20 0 0 1 0 1)
			 hasHorizontalScrollBar: true
			 hasVerticalScrollBar: true
			 hasKeyboardFocusInitially: false
			 postBuildCallback: postBuildFindTextView:
		       )
		      )

		   )
		 )
		(ViewSpec
		   name: 'ReplaceBox'
		   component:
		  (SpecCollection
		     collection: (
		      (LabelSpec
			 label: 'Replace with:'
			 name: 'ReplaceLabel'
			 layout: (LayoutFrame 0 0 0 0 0 1 20 0)
			 translateLabel: true
			 adjust: left
		       )
		      (TextEditorSpec
			 name: 'ReplaceText'
			 layout: (LayoutFrame 0 0 20 0 0 1 0 1)
			 hasHorizontalScrollBar: true
			 hasVerticalScrollBar: true
			 hasKeyboardFocusInitially: false
			 postBuildCallback: postBuildReplaceTextView:
		       )
		      )

		   )
		 )
		)

	     )
	     handles: (Any 0.5 1.0)
	   )
	  (ViewSpec
	     name: 'ExecuteRuleBox'
	     layout: (LayoutFrame 0 0 30 0 0 1 -30 1)
	     visibilityChannel: ruleExecutionVisibleHolder
	     component:
	    (SpecCollection
	       collection: (
		(LabelSpec
		   label: 'Rule:'
		   name: 'Label2'
		   layout: (LayoutFrame 0 0 0 0 100 0 25 0)
		   translateLabel: true
		   adjust: left
		 )
		(LabelSpec
		   name: 'Label4'
		   layout: (LayoutFrame 100 0 0 0 0 1 25 0)
		   translateLabel: true
		   labelChannel: ruleNameHolder
		 )
		(TextEditorSpec
		   name: 'TextEditor1'
		   layout: (LayoutFrame 0 0 25 0 0 1 0 1)
		   model: ruleSearchAndReplacePatternHolder
		   hasHorizontalScrollBar: true
		   hasVerticalScrollBar: true
		   isReadOnly: true
		   hasKeyboardFocusInitially: false
		 )
		)

	     )
	   )
	  (ViewSpec
	     name: 'Box1'
	     layout: (LayoutFrame 0 0 -30 1 -16 1 0 1)
	     component:
	    (SpecCollection
	       collection: (
		(LabelSpec
		   label: 'Enjoy'
		   name: 'Label1'
		   layout: (LayoutFrame 5 0 -25 1 255 0 -5 1)
		   xxvisibilityChannel: actionInProgressHolder
		   translateLabel: true
		   labelChannel: infoHolder
		   adjust: left
		 )
		(ProgressIndicatorSpec
		   name: 'ProgressIndicator1'
		   layout: (LayoutFrame 260 0 -25 1 -215 1 -5 1)
		   xxvisibilityChannel: actionInProgressHolder
		   model: progressHolder
		 )
		(ActionButtonSpec
		   label: 'Search'
		   name: 'Button2'
		   layout: (LayoutFrame -210 1 -26 1 -110 1 -5 1)
		   activeHelpKey: doSearchAction
		   translateLabel: true
		   model: doSearchAction
		 )
		(ActionButtonSpec
		   label: 'Rewrite...'
		   name: 'Button1'
		   layout: (LayoutFrame -105 1 -25 1 -5 1 -5 1)
		   activeHelpKey: doRewriteAction
		   translateLabel: true
		   model: doRewriteAction
		 )
		)

	     )
	     keepSpaceForOSXResizeHandleH: true
	   )
	  )

       )
     )
!

searchPatternHelpSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::MethodRewriter andSelector:#searchPatternHelpSpec
     Tools::MethodRewriter new openInterface:#searchPatternHelpSpec
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: searchPatternHelpSpec
       window:
      (WindowSpec
	 label: 'Classes'
	 name: 'Classes'
	 min: (Point 10 10)
	 bounds: (Rectangle 0 0 300 300)
       )
       component:
      (SpecCollection
	 collection: (
	  (HTMLViewSpec
	     name: 'HTMLBrowser1'
	     layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	     model: searchPatternHelpURL
	     hasHorizontalScrollBar: true
	     hasVerticalScrollBar: true
	   )
	  )

       )
     )
!

templatesSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::MethodRewriter andSelector:#templatesSpec
     Tools::MethodRewriter new openInterface:#templatesSpec
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: templatesSpec
       window:
      (WindowSpec
	 label: 'Method Rewriter'
	 name: 'Method Rewriter'
	 min: (Point 10 10)
	 bounds: (Rectangle 0 0 472 354)
       )
       component:
      (SpecCollection
	 collection: (
	  (VariableVerticalPanelSpec
	     name: 'FindAndReplacePanel'
	     layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
	     showHandle: true
	     snapMode: both
	     component:
	    (SpecCollection
	       collection: (
		(SelectionInListModelViewSpec
		   name: 'SelectionInListModelView1'
		   model: selectedTemplateIndex
		   hasHorizontalScrollBar: true
		   hasVerticalScrollBar: true
		   listModel: templateNameList
		   highlightMode: line
		 )
		(ViewSpec
		   name: 'FindBox'
		   component:
		  (SpecCollection
		     collection: (
		      (LabelSpec
			 label: 'Find:'
			 name: 'FindLabel'
			 layout: (LayoutFrame 0 0 0 0 0 1 20 0)
			 translateLabel: true
			 adjust: left
		       )
		      (TextEditorSpec
			 name: 'FindText'
			 layout: (LayoutFrame 0 0 20 0 0 1 0 1)
			 enableChannel: templateSearchPatternIsEditable
			 model: templateSearchPatternHolder
			 hasHorizontalScrollBar: true
			 hasVerticalScrollBar: true
			 hasKeyboardFocusInitially: false
		       )
		      )

		   )
		 )
		(ViewSpec
		   name: 'ReplaceBox'
		   component:
		  (SpecCollection
		     collection: (
		      (LabelSpec
			 label: 'Replace With:'
			 name: 'ReplaceLabel'
			 layout: (LayoutFrame 0 0 0 0 0 1 20 0)
			 translateLabel: true
			 adjust: left
		       )
		      (TextEditorSpec
			 name: 'ReplaceText'
			 layout: (LayoutFrame 0 0 20 0 0 1 0 1)
			 enableChannel: templateReplacePatternIsEditable
			 model: templateReplacePatternHolder
			 hasHorizontalScrollBar: true
			 hasVerticalScrollBar: true
			 hasKeyboardFocusInitially: false
		       )
		      )

		   )
		 )
		)

	     )
	     handles: (Any 0.20000000000000001 0.59999999999999998 1.0)
	   )
	  (HorizontalPanelViewSpec
	     name: 'HorizontalPanel1'
	     layout: (LayoutFrame 0 0 -30 1 -16 1 0 1)
	     horizontalLayout: center
	     verticalLayout: center
	     horizontalSpace: 3
	     verticalSpace: 3
	     component:
	    (SpecCollection
	       collection: (
		(ActionButtonSpec
		   label: 'Use as Template'
		   name: 'UseAsTemplateButton'
		   translateLabel: true
		   model: useAsTemplateAction
		   useDefaultExtent: true
		 )
		)

	     )
	     keepSpaceForOSXResizeHandleH: true
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
     UIPainter new openOnClass:Tools::MethodRewriter andSelector:#windowSpec
     Tools::MethodRewriter new openInterface:#windowSpec
     Tools::MethodRewriter open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Method Rewriter'
	  name: 'Method Rewriter'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 658 490)
	)
	component:
       (SpecCollection
	  collection: (
	   (NoteBookViewSpec
	      name: 'NoteBook'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      model: selectedTabIndex
	      menu: tabList
	      useIndex: true
	      fitLastRow: false
	    )
	   )

	)
      )

    "Modified: / 12-12-2007 / 11:39:31 / janfrog"
! !

!MethodRewriter class methodsFor:'list specs'!

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
	  label: 'Search and Replace'
	  createNewBuilder: false
	  minorKey: searchAndReplaceSpec
	)
       (TabItem
	  label: 'Classes'
	  createNewBuilder: false
	  minorKey: classesSpec
	)
       (TabItem
	  label: 'Templates'
	  createNewBuilder: false
	  minorKey: templatesSpec
	)
       (TabItem
	  label: 'Existing Rules'
	  createNewBuilder: false
	  minorKey: rulesSpec
	)
       (TabItem
	  label: 'How To Use This Tool'
	  createNewBuilder: false
	  minorKey: howToUseSpec
	)
       (TabItem
	  label: 'Pattern Info'
	  createNewBuilder: false
	  minorKey: searchPatternHelpSpec
	)
       )

      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]

    "Modified: / 12-12-2007 / 11:21:27 / janfrog"
! !

!MethodRewriter methodsFor:'accessing'!

classes
    ^ classes ifNil:[classes := List new]

    "Created: / 20-07-2007 / 16:31:18 / janfrog"
!

classes:aCollectionOfClasses
    |answer classesToAdd unloadedClasses|

    classesToAdd := aCollectionOfClasses.
    
    unloadedClasses := classesToAdd reject:[:cls | cls isLoaded].
    unloadedClasses notEmpty ifTrue:[
        answer := Dialog confirmWithCancel:(resources stringWithCRs:'Some classes are unloaded.\\Load them now?').
        answer isNil ifTrue:[ AbortSignal raise. ].
        answer == true ifTrue:[
            unloadedClasses do:[:each | each autoload].
        ] ifFalse:[
            classesToAdd := classesToAdd select:[:cls | cls isLoaded].
        ].    
    ].
    classesToAdd := (classesToAdd collect:[:cls|cls theNonMetaclass])
                        asOrderedCollection sortBySelector:#name.
    
    self classes contents:classesToAdd.
    self classesChanged


    "Created: / 20-07-2007 / 16:31:18 / janfrog"
    "Modified: / 12-12-2007 / 09:47:01 / janfrog"
!

info: aString

    self infoHolder value: aString

    "Created: / 12-12-2007 / 10:00:50 / janfrog"
!

progress: anInteger
    self actionInProgressHolder value:true.
    self progressHolder value: anInteger

    "Created: / 12-12-2007 / 10:01:03 / janfrog"
!

projects: aCollection
    |allClasses|

    allClasses := OrderedCollection new.
    aCollection do:[:eachPackage |
	allClasses addAll:(Smalltalk allClassesInPackage:eachPackage)
    ].
    self classes:allClasses.
!

replacePattern
    ^ replaceTextView contents withoutSeparators

    "Created: / 21-07-2007 / 06:29:22 / janfrog"
!

replacePattern: pattern
    ^ replaceTextView contents: pattern withoutSeparators

    "Created: / 12-12-2007 / 11:38:22 / janfrog"
!

ruleTemplate

    ^self rules at:self selectedRuleIndex value
!

rules
    RBTransformationRule isNil ifTrue:[
        Smalltalk loadPackage:'stx:goodies/refactoryBrowser/lint'.
    ].

    rules isNil ifTrue:[
        |knownRules separator1 separator2 separator3|

        "/ construct a pseudo list from existing transformation rules
        separator1 := '----------- search for:' withColor:Color grey.
        separator2 := '----------- replace by:' withColor:Color grey.
        separator3 := '\=================================================================================\' withCRs withColor:Color grey.

        knownRules := OrderedCollection new.
        (RBTransformationRule allSubclasses asNewOrderedCollection sort:[:a :b | a basicNew name < b basicNew name])
        do:[:each |
            |rule |

            rule := each new.
            knownRules add:{ rule .
                             (rule rewriteRule searches
                                collectAll:[:each |
                                    {
                                      separator1.
                                      each searchString
                                        asText backgroundColorizeAllWith:(Color red lightened lightened lightened) .
                                      separator2.
                                      each replaceString asText
                                        asText backgroundColorizeAllWith:(Color green lightened lightened lightened) .
                                      separator3
                                    }
                                ]
                             ) asStringCollection asString.
                           }
        ].

        rules := knownRules
    ].
    ^ rules

    "
     self new rules
    "
!

searchPattern
    ^ searchTextView contents withoutSeparators

    "Created: / 20-07-2007 / 16:51:49 / janfrog"
    "Modified: / 21-07-2007 / 06:29:29 / janfrog"
!

searchPattern: pattern
    ^ searchTextView contents: pattern withoutSeparators

    "Created: / 12-12-2007 / 11:38:12 / janfrog"
!

selectedClasses

    ^self selectedClassesHolder value

    "Created: / 12-12-2007 / 12:02:03 / janfrog"
!

selectedRule

    ^self selectedRuleSpec first
!

selectedRuleSpec

    ^self rules at:(self selectedRuleIndex value)
!

selectedTemplate

    ^self templates at:self selectedTemplateIndex value

    "Created: / 12-12-2007 / 11:20:32 / janfrog"
!

templates
    templates isNil ifTrue:[
	templates := self class templates.
    ].
    ^ templates

    "Created: / 12-12-2007 / 11:17:55 / janfrog"
! !

!MethodRewriter methodsFor:'actions'!

addAllPackagesAction
    |classes|

    classes := Smalltalk allClasses.
    self classes: classes
!

addAllYourPackagesAction
    |classes|

    classes := Smalltalk 
                    allClassesForWhich:[:cls | 
                        cls isNameSpace not
                        and:[ ((cls package ?'') startsWith:'stx:') not]
                    ].
    self classes: classes
!

doRewrite: methodsMatching
    | changes compositeChangeCollector |

    changes := ChangeSet new name:'Rewrite Changes'.

    methodsMatching isEmptyOrNil ifTrue:[^Dialog warn:(resources string:'No methods matching')].

    self withMethods: methodsMatching do:[:mth|
	| rewriter newTree change |

	rewriter := ParseTreeSourceRewriter new.
	(self isMethodPatternHolder value) ifTrue:[
	    rewriter replaceMethod: self searchPattern with: self replacePattern
	] ifFalse:[
	    rewriter replace: self searchPattern with: self replacePattern
	].
	newTree := rewriter
			executeTree: mth parseTree;
			tree.

	change := InteractiveAddMethodChange compile: newTree newSource in:(mth mclass ? mth getMclass) classified:mth category.

	"/ collect in order to have only one change in the undo-list (instead of many)
	changes add: change.

"/        mth mclass
"/            compile: newTree formattedCode
"/            classified: mth category
    ].

    changes isEmpty ifTrue:[ ^ self ].

    "/Let the user to inspect and confirm changes...."
    changes := ChangeSetBrowser2 confirmChanges: changes.
    changes isEmpty ifTrue:[ ^ self ].

    "/Perform the refactoring..."
    compositeChangeCollector := CompositeRefactoryChange new.
    compositeChangeCollector name:'Rewrite Change'.
    compositeChangeCollector changes: changes.
    RefactoryChangeManager performChange:compositeChangeCollector.

    "Created: / 20-07-2007 / 16:03:47 / janfrog"
    "Modified: / 21-07-2007 / 06:55:42 / janfrog"
    "Modified: / 04-08-2011 / 19:05:25 / cg"
    "Created: / 22-03-2012 / 18:22:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 26-08-2015 / 19:38:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRewriteAction

    self replacePattern isEmptyOrNil ifTrue:[
	(Dialog confirm:'No replace-pattern given.\\Proceed to delete that code.') ifFalse:[
	    AbortSignal raise
	].
    ].

    self
	doSearchPattern: self searchPattern
	withResultDo: [:methodsMatching|
	    self doRewrite:  methodsMatching
	].

    "Created: / 12-12-2007 / 11:14:19 / janfrog"
    "Modified: / 22-03-2012 / 18:23:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSearchAction
    |methods what|

    ruleForRewriteOrNilForAdHoc notNil ifTrue:[
       self
	    doSearchRule: self selectedRule
	    withResultDo:[:matchingMethods|
		matchingMethods isEmpty
		    ifTrue:[
			Dialog warn:'No methods found by rule: ', self selectedRule name
		    ]
		    ifFalse:[
			self
			    showMethods: matchingMethods asArray
			    title: 'Methods matching rule: ', self selectedRule name
		    ]
	    ]
    ] ifFalse:[
       self
	    doSearchPattern: self searchPattern
	    withResultDo:[:matchingMethods|
		matchingMethods isEmpty
		    ifTrue:[
			Dialog warn:'No methods found for search pattern'
		    ]
		    ifFalse:[
			self
			    showMethods: matchingMethods asArray
			    title: 'Methods matching ', self searchPattern
		    ]
	    ]
    ]

    "Created: / 12-12-2007 / 11:14:25 / janfrog"
!

removeSeletedClassesAction
    |toRemove|

    toRemove := self selectedClasses.
    toRemove notEmptyOrNil ifTrue:[
        self classes removeAll: self selectedClasses.
        classes changed:#content.
        self classesChanged.
    ].
    
    "Created: / 12-12-2007 / 12:05:15 / janfrog"
!

useAsRuleAction
    self adHocFindAndReplaceVisibleHolder value:false.
    ruleForRewriteOrNilForAdHoc := self selectedRule.
    ruleNameHolder value: ruleForRewriteOrNilForAdHoc name.

    self selectedTabIndex value:1
!

useAsTemplateAction
    self adHocFindAndReplaceVisibleHolder value:true.
    ruleForRewriteOrNilForAdHoc := nil. "/ ad hoc
    self searchPattern: self templateSearchPatternHolder value.
    self replacePattern: self templateReplacePatternHolder value.
    self selectedTabIndex value:1

    "Created: / 12-12-2007 / 11:14:15 / janfrog"
! !

!MethodRewriter methodsFor:'aspects'!

actionInProgressHolder
    actionInProgressHolder isNil ifTrue:[
	actionInProgressHolder := false asValue.
    ].
    ^ actionInProgressHolder.

    "Created: / 12-12-2007 / 10:00:05 / janfrog"
!

adHocFindAndReplaceVisibleHolder
    adHocFindAndReplaceVisibleHolder isNil ifTrue:[
	adHocFindAndReplaceVisibleHolder := true asValue.
    ].
    ^ adHocFindAndReplaceVisibleHolder.
!

classesInfoTextHolder
    classesInfoTextHolder isNil ifTrue:[
	classesInfoTextHolder := '' asValue.
    ].
    ^ classesInfoTextHolder.
!

howToUseRewriteToolURL
    ^ HTMLDocumentFrame documentFileFor:'help/Browser/RewriteToolHelp.html'
!

infoHolder
    infoHolder isNil ifTrue:[
	infoHolder := 'Really cool tool!!' asValue.
    ].
    ^ infoHolder.

    "Created: / 12-12-2007 / 10:00:05 / janfrog"
    "Modified: / 12-12-2007 / 11:40:17 / janfrog"
!

isMethodPatternHolder
    isMethodPatternHolder isNil ifTrue:[
	isMethodPatternHolder := false asValue
    ].
    ^ isMethodPatternHolder.
!

progressHolder
    progressHolder isNil ifTrue:[
	progressHolder := 0 asValue
    ].
    ^ progressHolder.

    "Created: / 12-12-2007 / 10:00:05 / janfrog"
!

ruleExecutionVisibleHolder
    ^ BlockValue forLogicalNot:self adHocFindAndReplaceVisibleHolder
!

ruleNameHolder
    ruleNameHolder isNil ifTrue:[
	ruleNameHolder := '' asValue.
    ].
    ^ ruleNameHolder.
!

ruleNameList

    ^self rules collect:[:ruleSpec | ruleSpec first name ]
!

ruleSearchAndReplacePatternHolder
    ruleSearchAndReplacePatternHolder isNil ifTrue:[
	ruleSearchAndReplacePatternHolder := '' asValue.
    ].
    ^ ruleSearchAndReplacePatternHolder.
!

searchPatternHelpURL
    ^ HTMLDocumentFrame documentFileFor:'help/Browser/RBSearchPatterns.html'
!

selectedClassesHolder
    selectedClassesHolder isNil ifTrue:[
	selectedClassesHolder := ValueHolder new.
    ].
    ^ selectedClassesHolder.

    "Created: / 12-12-2007 / 12:01:40 / janfrog"
!

selectedRuleIndex

    selectedRuleIndex isNil ifTrue:[
	selectedRuleIndex := ValueHolder new.
	selectedRuleIndex onChangeSend:#selectedRuleIndexChanged to:self.
    ].
    ^ selectedRuleIndex.
!

selectedTabIndex
    selectedTabIndex isNil ifTrue:[
	selectedTabIndex := ValueHolder new.
    ].
    ^ selectedTabIndex.

    "Created: / 12-12-2007 / 11:39:29 / janfrog"
!

selectedTemplateIndex

    selectedTemplateIndex isNil ifTrue:[
	selectedTemplateIndex := ValueHolder new.
	selectedTemplateIndex onChangeSend:#selectedTemplateIndexChanged to:self.
    ].
    ^ selectedTemplateIndex.

    "Created: / 12-12-2007 / 11:17:16 / janfrog"
!

tabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#tabList) isNil ifTrue:[
	builder aspectAt:#tabList put:(list := self class tabList).
    ].
    ^ list

    "Created: / 20-07-2007 / 16:54:27 / janfrog"
!

templateNameList

    ^self templates collect:[:tmpl|tmpl first]

    "Created: / 12-12-2007 / 11:17:16 / janfrog"
!

templateReplacePatternHolder
    templateReplacePatternHolder isNil ifTrue:[
	templateReplacePatternHolder := '' asValue.
    ].
    ^ templateReplacePatternHolder.

    "Created: / 12-12-2007 / 11:17:16 / janfrog"
!

templateReplacePatternIsEditable
    |holder|

    (holder := builder bindingAt:#templateReplacePatternIsEditable) isNil ifTrue:[
	builder aspectAt:#templateReplacePatternIsEditable put:(holder := true asValue).
    ].
    ^ holder.
!

templateSearchPatternHolder
    templateSearchPatternHolder isNil ifTrue:[
	templateSearchPatternHolder := '' asValue.
    ].
    ^ templateSearchPatternHolder.

    "Created: / 12-12-2007 / 11:17:16 / janfrog"
!

templateSearchPatternIsEditable
    |holder|

    (holder := builder bindingAt:#templateSearchPatternIsEditable) isNil ifTrue:[
	builder aspectAt:#templateSearchPatternIsEditable put:(holder := true asValue).
    ].
    ^ holder.
! !

!MethodRewriter methodsFor:'change & update'!

classesChanged
    cachedMethodsFromClasses := nil. "/ flush
    methods := nil.

    self classesInfoTextHolder
        value:(((classes size == 1) 
                    ifTrue:['%1 class / %2 method(s)'] 
                    ifFalse:['%1 classes / %2 methods'])
                        bindWith:classes size
                        with:self methods size)
!

selectedRuleIndexChanged
    |selectedRuleSpec|

    selectedRuleSpec := self selectedRuleSpec.
    "/ entries are:
    "/ 1) rule
    "/ 2) search & replacement pattern

    self ruleSearchAndReplacePatternHolder value: selectedRuleSpec second.
!

selectedTemplateIndexChanged
    |selectedTemplate|

    selectedTemplate := self selectedTemplate.
    "/ entries are:
    "/ 1) name
    "/ 2) search pattern
    "/ 3) replacement pattern
    "/ 4) rule or nil; nil for ad-hoc rewrite
    selectedTemplate fourth isNil ifTrue:[
	"/ ad hoc
	self templateReplacePatternIsEditable value:true.
	self templateSearchPatternIsEditable value:true.
    ] ifFalse:[
	"/ existing rule
	self templateReplacePatternIsEditable value:false.
	self templateSearchPatternIsEditable value:false.
    ].
    self templateSearchPatternHolder value: selectedTemplate second.
    self templateReplacePatternHolder value: selectedTemplate third.

    "Created: / 12-12-2007 / 11:20:16 / janfrog"
! !

!MethodRewriter methodsFor:'drag & drop'!

canDropClasses: dropContext
    "I accept classes, methods and packages"

    ^dropContext dropObjects
	allSatisfy: [:obj|
	    obj isClassObject
	    or:[ obj isMethodObject
	    or:[ obj isProjectObject ]]]

    "Created: / 20-07-2007 / 16:58:13 / janfrog"
!

doDropClasses: dropContext
    "I accept classes, methods and packages"

    | droppedProjects droppedClasses newClasses classesAlready|

    droppedProjects := dropContext dropObjects
		    select:[:obj| obj isProjectObject]
		    thenCollect:[:obj | obj theObject].

    droppedClasses := dropContext dropObjects
		    select:[:obj| obj isClassObject or:[obj isMethodObject]]
		    thenCollect:[:obj|
			|clsOrMethod|

			clsOrMethod := obj theObject.
			clsOrMethod isMethod ifTrue:[
			    clsOrMethod containingClass
			] ifFalse:[
			    clsOrMethod
			]
		    ] as:IdentitySet.

    droppedProjects do:[:eachPackage |
	droppedClasses addAll:(Smalltalk allClassesInPackage:eachPackage)
    ].

    classesAlready := self classes asSet.
    newClasses := droppedClasses reject:[:cls | classesAlready includes:cls].

    self classes
	addAll: newClasses;
	sortBySelector:#name.
    self classesChanged

    "Created: / 20-07-2007 / 16:58:16 / janfrog"
! !

!MethodRewriter methodsFor:'hooks'!

postBuildFindTextView: scrollableView

    searchTextView := scrollableView scrolledView

    "Created: / 20-07-2007 / 15:55:16 / janfrog"
!

postBuildReplaceTextView: scrollableView

    replaceTextView := scrollableView scrolledView

    "Created: / 20-07-2007 / 15:55:29 / janfrog"
! !

!MethodRewriter methodsFor:'private'!

actionInProgress: aBoolean

    self actionInProgressHolder value: aBoolean.
    self windowGroup processEvents.

    "Created: / 12-12-2007 / 10:06:16 / janfrog"
!

doSearchPattern: pattern withResultDo: block

    | matchingMethods |

    pattern isEmptyOrNil ifTrue:[
	Dialog warn:'No searchpattern given.'.
	AbortSignal raise
    ].

    matchingMethods := Set new.
    self
	withMethodsDo:[:mthd|
	    | tree searcher |
	    tree := mthd parseTree.
	    tree
		ifNil:[
		    Transcript showCR:'MethodRewriter: parse tree error in ',mthd whoString.
		    self breakPoint: #jv
		]
		ifNotNil:[
		    searcher := ParseTreeSearcher new.
		    (self isMethodPatternHolder value)
			ifTrue:[
			    searcher matchesMethod:pattern do:[:aNode :answer | matchingMethods add:mthd ]
			]
			ifFalse:[
			    searcher matches:pattern do:[:aNode :answer | matchingMethods add:mthd ]
			].
		    searcher executeTree: tree
		]
	]
	finallyDo:[
	    block value: matchingMethods
	]

    "Created: / 12-12-2007 / 10:34:50 / janfrog"
    "Modified: / 07-04-2011 / 22:02:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSearchRule: rule withResultDo: block

    | matchingMethods searcher currentMethod|

    rule isNil ifTrue:[
        Dialog warn:'No rule selected.'.
        AbortSignal raise
    ].

    searcher := ParseTreeSearcher new.
    rule rewriteRule searches do:[:eachSearch |
        searcher
            matchesTree:eachSearch searchTree
            do:[:aNode :answer |
                (eachSearch canMatch: aNode) ifTrue:[
                    matchingMethods add:currentMethod
                ]
            ]
    ].
    searcher computeQuickSearchStrings.

    matchingMethods := Set new.
    self
        withMethodsDo:[:mthd|
            | tree |

            (searcher canQuicklyReject:mthd source) ifFalse:[
                tree := mthd parseTree.
                tree
                    ifNil:[
                        Transcript showCR:'MethodRewriter: parse tree error in ',mthd whoString.
                        self breakPoint: #jv
                    ]
                    ifNotNil:[
                        currentMethod := mthd.
                        searcher executeTree: tree
                    ]
            ]
        ]
        finallyDo:[
            block value: matchingMethods
        ]

    "Created: / 12-12-2007 / 10:34:50 / janfrog"
    "Modified: / 07-04-2011 / 22:02:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methods
    methods notEmptyOrNil ifTrue:[^ methods].

    ^self methodsForClasses

    "Modified: / 21-07-2007 / 06:24:07 / janfrog"
    "Modified: / 05-07-2011 / 14:50:43 / cg"
!

methods:aCollection
    "to explicitly set the set of methods to be processed"

    methods := aCollection

    "Created: / 05-07-2011 / 14:50:52 / cg"
!

methodsForClasses
    cachedMethodsFromClasses isNil ifTrue:[
	cachedMethodsFromClasses :=
	    (classes
		inject: OrderedCollection new
		into:[:methods :cls|
		    methods
			addAll: cls methodDictionary values;
			addAll: cls class methodDictionary values;
			yourself]
	    ) asArray.
    ].
    ^ cachedMethodsFromClasses
!

methodsMatchingPattern: searchPattern
    |methods matchingMethods|

    searchPattern isEmptyOrNil ifTrue:[
	Dialog warn:'No searchpattern given'.
	AbortSignal raise
    ].
    methods := self methodsToSearchOrAbortIfNone.

    matchingMethods := OrderedCollection new.
    methods do:[:mth |
	(ParseTreeSearcher new)
	    matches:searchPattern do:[:aNode :answer | matchingMethods add:mth ];
	    executeTree:mth parseTree.
    ].
    ^ matchingMethods

    "Created: / 21-07-2007 / 06:26:19 / janfrog"
!

methodsMatchingRule: rule
    |methods matchingMethods|

    rule isNil ifTrue:[
	Dialog warn:'No rule given'.
	AbortSignal raise
    ].
    methods := self methodsToSearchOrAbortIfNone.

    matchingMethods := OrderedCollection new.
    methods do:[:mth |
	|searcher|

	searcher := ParseTreeSearcher new.
	rule searches halt.
"/            matches:searchPattern do:[:aNode :answer | matchingMethods add:mth ];
"/            executeTree:mth parseTree.
    ].
    ^ matchingMethods
!

methodsToSearchOrAbortIfNone
    (methods := self methods) isEmptyOrNil ifTrue:[
	Dialog warn:'No methods or classes defined for search'.
	AbortSignal raise.
    ].
    ^ methods
!

showMethods: methods title: title

    NewSystemBrowser
		browseMethods:methods
		title:title
		sort:true

    "Created: / 21-07-2007 / 06:51:36 / janfrog"
!

withMethods: givenMethods do: methodBlock

    ^self withMethods: givenMethods do: methodBlock finallyDo: []

    "Created: / 22-03-2012 / 18:25:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withMethods: methods do: methodBlock finallyDo: finallyBlock

    [
        |numMethods|

        numMethods := methods size.

        self actionInProgress: true.
        self progress: 0.

        methods asArray keysAndValuesDo:[:idx :mth|
            |mclass|

            mclass := mth mclass.
            mclass isNil ifTrue:[
                Transcript showCR:'method no longer valid in ',mth getMclass printString.
            ] ifFalse:[    
                numMethods > 100 ifTrue:[
                    self info: mclass name.
                ] ifFalse:[
                    self info: mth selector storeString.
                ].
                methodBlock value: mth.
                self progress: ((100 / methods size) * idx) rounded
            ].
        ].
        finallyBlock value
    ] ensure:[
        "/self actionInProgress: false.
        self progress: 0.
        self info: ''
    ]

    "Created: / 12-12-2007 / 10:32:16 / janfrog"
    "Modified: / 26-08-2015 / 16:43:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withMethodsDo: methodBlock finallyDo: finallyBlock

   ^self
	withMethods: self methodsToSearchOrAbortIfNone asArray
	do: methodBlock
	finallyDo: finallyBlock

    "Modified: / 12-12-2007 / 10:32:48 / janfrog"
! !

!MethodRewriter methodsFor:'testing method'!

testXXX
    self halt:'Was halt'

    "Created: / 21-07-2007 / 07:55:24 / janfrog"
    "Modified: / 12-12-2007 / 10:45:20 / janfrog"
! !

!MethodRewriter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

