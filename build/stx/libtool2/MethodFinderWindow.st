"
 Copyright (C) Original Authors (Kaehler, Scott Wallace and Dan Ingalls)
 Copyright (C) 2001 eXept Software AG

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#MethodFinderWindow
	instanceVariableNames:'resultHolder selectorPatternHolder classOfResultHolder
		selectedClassOfResultHolder selectedImplementorsHolder
		argumentsEditor messageAnswerEditor receiverEditor receiver
		resultSelectors arg2BoxVisible arg1BoxVisible arg4BoxVisible
		arg3BoxVisible argCountHolder argCountList argument1Editor
		argument2Editor argument3Editor argument4Editor resultSelected
		lookAtResultEditor codeHolder searchProcess'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools'
!

!MethodFinderWindow class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original Authors (Kaehler, Scott Wallace and Dan Ingalls)
 Copyright (C) 2001 eXept Software AG

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
  a tool to find implementing methods by example.
  Give it values for a receiver, optional arguments and a desired result,
  and it will find methods which do that for you.
  Please read the online documentation for details (open via the tool's help menu).

  [author:]
    original squeak version by Ted Kaehler, Scott Wallace and Dan Ingalls.
    ported from Squeak and GUI enhanced 2001 by James Hayes james@exept.de.
    improved by Claus Gittinger.
"
! !

!MethodFinderWindow class methodsFor:'constants'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary methodFinder24x24Icon

    "Created: / 01-06-2012 / 13:05:11 / cg"
!

markerForImplementingClass
    ^ '=> '.
    ^ '*'

    "Created: / 13.11.2001 / 12:09:52 / cg"
    "Modified: / 13.11.2001 / 12:11:57 / cg"
! !

!MethodFinderWindow class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:MethodFinderWindow    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#receiverValue
'Enter a receiver value here.\Can be a constant (like ''hello'')\or an expression, such as "Rectangle basicNew".'

#answerValue
'Enter result value here.\Can be a constant (like ''hello'')\or an expression, such as "Rectangle basicNew".'

#arg1Value
'Enter a value for the first argument here.\Can be a constant or an expression.'

#arg2Value
'Enter a value for the second argument here.\Can be a constant or an expression.'

#arg3Value
'Enter a value for the third argument here.\Can be a constant or an expression.'

#argumentCount
'Specify the number of arguments here.'

#clearButton
'Clear all sample value fields.'

#startSearchButton
'Search for methods which answer the desired value,\given the concrete arguments'

#selectorPatternSearch
'Search by name.\You can use match characters '*' as in GLOB patterns (i.e. like filename patterns)'

)
! !

!MethodFinderWindow class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MethodFinderWindow andSelector:#windowSpec
     MethodFinderWindow new openInterface:#windowSpec
     MethodFinderWindow open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'MethodFinder'
         name: 'MethodFinder'
         bounds: (Rectangle 0 0 816 738)
         menu: menu
         icon: defaultIcon
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             showHandle: true
             snapMode: both
             component: 
            (SpecCollection
               collection: (
                (VariableVerticalPanelSpec
                   name: 'LeftBox'
                   showHandle: true
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'MethodFinderBox'
                         component: 
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'ReceiverArgBox'
                               layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Receiver'
                                     name: 'ReceiverLabel'
                                     layout: (LayoutFrame 0 0 0 0 0 0.34000000000000002 28 0)
                                     translateLabel: true
                                   )
                                  (ComboListSpec
                                     name: 'allowedArgments'
                                     layout: (LayoutFrame 0 0.34000000000000002 1 0 0 0.64000000000000135 28 0)
                                     activeHelpKey: argumentCount
                                     model: argCountHolder
                                     comboList: argCountList
                                     useIndex: true
                                   )
                                  (LabelSpec
                                     label: 'Answer'
                                     name: 'MessageAnswerLabel'
                                     layout: (LayoutFrame 0 0.64000000000000135 0 0 0 1 28 0)
                                     activeHelpKey: arg1Value
                                     translateLabel: true
                                   )
                                  (HorizontalPanelViewSpec
                                     name: 'HorizontalPanel1'
                                     layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                                     horizontalLayout: fit
                                     verticalLayout: fit
                                     horizontalSpace: 3
                                     verticalSpace: 3
                                     component: 
                                    (SpecCollection
                                       collection: (
                                        (WorkspaceSpec
                                           name: 'ReceiverEditor'
                                           activeHelpKey: receiverValue
                                           tabable: true
                                           hasHorizontalScrollBar: true
                                           hasVerticalScrollBar: true
                                           miniScrollerHorizontal: true
                                           miniScrollerVertical: true
                                           autoHideScrollBars: true
                                           hasKeyboardFocusInitially: false
                                           extent: (Point 85 142)
                                           postBuildCallback: receiverWidgetCreated:
                                         )
                                        (VerticalPanelViewSpec
                                           name: 'VerticalPanel1'
                                           horizontalLayout: fit
                                           verticalLayout: fit
                                           horizontalSpace: 3
                                           verticalSpace: 3
                                           component: 
                                          (SpecCollection
                                             collection: (
                                              (ViewSpec
                                                 name: 'Box1'
                                                 visibilityChannel: arg1BoxVisible
                                                 component: 
                                                (SpecCollection
                                                   collection: (
                                                    (WorkspaceSpec
                                                       name: 'Arg1Editor'
                                                       layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                                                       activeHelpKey: arg1Value
                                                       tabable: true
                                                       hasHorizontalScrollBar: true
                                                       hasVerticalScrollBar: true
                                                       miniScrollerHorizontal: true
                                                       miniScrollerVertical: true
                                                       autoHideScrollBars: true
                                                       hasKeyboardFocusInitially: false
                                                       postBuildCallback: argument1WidgetCreated:
                                                     )
                                                    )
                                                  
                                                 )
                                                 extent: (Point 86 45)
                                               )
                                              (ViewSpec
                                                 name: 'Box2'
                                                 visibilityChannel: arg2BoxVisible
                                                 component: 
                                                (SpecCollection
                                                   collection: (
                                                    (WorkspaceSpec
                                                       name: 'TextEditor5'
                                                       layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                                                       activeHelpKey: arg2Value
                                                       tabable: true
                                                       hasHorizontalScrollBar: true
                                                       hasVerticalScrollBar: true
                                                       miniScrollerHorizontal: true
                                                       miniScrollerVertical: true
                                                       autoHideScrollBars: true
                                                       hasKeyboardFocusInitially: false
                                                       postBuildCallback: argument2WidgetCreated:
                                                     )
                                                    )
                                                  
                                                 )
                                                 extent: (Point 86 46)
                                               )
                                              (ViewSpec
                                                 name: 'Box3'
                                                 visibilityChannel: arg3BoxVisible
                                                 component: 
                                                (SpecCollection
                                                   collection: (
                                                    (WorkspaceSpec
                                                       name: 'TextEditor6'
                                                       layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                                                       activeHelpKey: arg3Value
                                                       tabable: true
                                                       hasHorizontalScrollBar: true
                                                       hasVerticalScrollBar: true
                                                       miniScrollerHorizontal: true
                                                       miniScrollerVertical: true
                                                       autoHideScrollBars: true
                                                       hasKeyboardFocusInitially: false
                                                       postBuildCallback: argument3WidgetCreated:
                                                     )
                                                    )
                                                  
                                                 )
                                                 extent: (Point 86 45)
                                               )
                                              )
                                            
                                           )
                                           extent: (Point 86 142)
                                         )
                                        (WorkspaceSpec
                                           name: 'AnswerEditor'
                                           activeHelpKey: answerValue
                                           tabable: true
                                           hasHorizontalScrollBar: true
                                           hasVerticalScrollBar: true
                                           miniScrollerHorizontal: true
                                           miniScrollerVertical: true
                                           autoHideScrollBars: true
                                           hasKeyboardFocusInitially: false
                                           extent: (Point 86 142)
                                           postBuildCallback: messageAnswerWidgetCreated:
                                         )
                                        )
                                      
                                     )
                                   )
                                  )
                                
                               )
                             )
                            (ViewSpec
                               name: 'ReceiverArgBoxActionBox'
                               layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
                               component: 
                              (SpecCollection
                                 collection: (
                                  (ActionButtonSpec
                                     label: 'Clear'
                                     name: 'Button2'
                                     layout: (LayoutFrame 5 0 0 0 -5 0.5 0 1)
                                     activeHelpKey: clearButton
                                     translateLabel: true
                                     model: clear
                                   )
                                  (ActionButtonSpec
                                     label: 'Search'
                                     name: 'Button1'
                                     layout: (LayoutFrame 5 0.5 0 0 -5 1 0 1)
                                     activeHelpKey: startSearchButton
                                     translateLabel: true
                                     tabable: true
                                     model: search
                                   )
                                  )
                                
                               )
                             )
                            )
                          
                         )
                       )
                      (ViewSpec
                         name: 'SelectorFinderBox'
                         component: 
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'MatchActionBox'
                               layout: (LayoutFrame 0 0 0 0 0 1 90 0)
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Selector Pattern:'
                                     name: 'Label1'
                                     layout: (LayoutFrame 0 0 0 0 0 0.5 25 0)
                                     translateLabel: true
                                     adjust: left
                                   )
                                  (InputFieldSpec
                                     name: 'EntryField1'
                                     layout: (LayoutFrame 2 0 -54 1 -2 1 -29 1)
                                     model: selectorPatternHolder
                                     immediateAccept: true
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnPointerLeave: true
                                   )
                                  (ActionButtonSpec
                                     label: 'Search'
                                     name: 'Button4'
                                     layout: (LayoutFrame 5 0.5 -25 1 -5 1 0 1)
                                     translateLabel: true
                                     tabable: true
                                     model: searchPatternMatchesInBackground
                                   )
                                  )
                                
                               )
                             )
                            (SequenceViewSpec
                               name: 'ResultList'
                               layout: (LayoutFrame 0 0 94 0 0 1 0 1)
                               model: selectedImplementorsHolder
                               menu: resultListMenu
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               autoHideScrollBars: true
                               useIndex: true
                               sequenceList: resultHolder
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   handles: (Any 0.28000000000000003 1.0)
                 )
                (VariableVerticalPanelSpec
                   name: 'RightBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (SequenceViewSpec
                         name: 'List2'
                         model: selectedClassOfResultHolder
                         menu: implementorListMenu
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         autoHideScrollBars: true
                         doubleClickSelector: openBrowserOn:
                         valueChangeSelector: selectedClassOfResultHolderChanged
                         useIndex: false
                         sequenceList: classOfResultHolder
                       )
                      (CodeViewSpec
                         name: 'CodeView'
                         model: codeHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         autoHideScrollBars: true
                         hasKeyboardFocusInitially: false
                         postBuildCallback: sourceCodeWidgetCreated:
                         viewClassName: 'codeViewClass'
                       )
                      )
                    
                   )
                   handles: (Any 0.23999999999999999 1.0)
                 )
                )
              
             )
             handles: (Any 0.33000000000000002 1.0)
           )
          )
        
       )
     )
!

windowSpec_old
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MethodFinderWindow andSelector:#windowSpec
     MethodFinderWindow new openInterface:#windowSpec
     MethodFinderWindow open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'MethodFinder'
         name: 'MethodFinder'
         bounds: (Rectangle 0 0 920 690)
         menu: menu
         icon: defaultIcon
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             snapMode: both
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'LeftBox'
                   level: 1
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'ReceiverArgBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 -100 0.5)
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Receiver'
                               name: 'ReceiverLabel'
                               layout: (LayoutFrame 0 0 0 0 0 0.34000000000000002 28 0)
                               translateLabel: true
                             )
                            (ComboListSpec
                               name: 'allowedArgments'
                               layout: (LayoutFrame 0 0.34000000000000002 1 0 0 0.64000000000000046 28 0)
                               activeHelpKey: argumentCount
                               model: argCountHolder
                               comboList: argCountList
                               useIndex: true
                             )
                            (LabelSpec
                               label: 'Answer'
                               name: 'MessageAnswerLabel'
                               layout: (LayoutFrame 0 0.64000000000000046 0 0 0 1 28 0)
                               activeHelpKey: arg1Value
                               translateLabel: true
                             )
                            (HorizontalPanelViewSpec
                               name: 'HorizontalPanel1'
                               layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                               horizontalLayout: fit
                               verticalLayout: fit
                               horizontalSpace: 3
                               verticalSpace: 3
                               component: 
                              (SpecCollection
                                 collection: (
                                  (WorkspaceSpec
                                     name: 'ReceiverEditor'
                                     activeHelpKey: receiverValue
                                     tabable: true
                                     hasHorizontalScrollBar: true
                                     hasVerticalScrollBar: true
                                     miniScrollerHorizontal: true
                                     miniScrollerVertical: true
                                     autoHideScrollBars: true
                                     hasKeyboardFocusInitially: false
                                     extent: (Point 110 214)
                                     postBuildCallback: receiverWidgetCreated:
                                   )
                                  (VerticalPanelViewSpec
                                     name: 'VerticalPanel1'
                                     horizontalLayout: fit
                                     verticalLayout: fit
                                     horizontalSpace: 3
                                     verticalSpace: 3
                                     component: 
                                    (SpecCollection
                                       collection: (
                                        (ViewSpec
                                           name: 'Box1'
                                           visibilityChannel: arg1BoxVisible
                                           component: 
                                          (SpecCollection
                                             collection: (
                                              (WorkspaceSpec
                                                 name: 'Arg1Editor'
                                                 layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                                                 activeHelpKey: arg1Value
                                                 tabable: true
                                                 hasHorizontalScrollBar: true
                                                 hasVerticalScrollBar: true
                                                 miniScrollerHorizontal: true
                                                 miniScrollerVertical: true
                                                 autoHideScrollBars: true
                                                 hasKeyboardFocusInitially: false
                                                 postBuildCallback: argument1WidgetCreated:
                                               )
                                              )
                                            
                                           )
                                           extent: (Point 110 69)
                                         )
                                        (ViewSpec
                                           name: 'Box2'
                                           visibilityChannel: arg2BoxVisible
                                           component: 
                                          (SpecCollection
                                             collection: (
                                              (WorkspaceSpec
                                                 name: 'TextEditor5'
                                                 layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                                                 activeHelpKey: arg2Value
                                                 tabable: true
                                                 hasHorizontalScrollBar: true
                                                 hasVerticalScrollBar: true
                                                 miniScrollerHorizontal: true
                                                 miniScrollerVertical: true
                                                 autoHideScrollBars: true
                                                 hasKeyboardFocusInitially: false
                                                 postBuildCallback: argument2WidgetCreated:
                                               )
                                              )
                                            
                                           )
                                           extent: (Point 110 70)
                                         )
                                        (ViewSpec
                                           name: 'Box3'
                                           visibilityChannel: arg3BoxVisible
                                           component: 
                                          (SpecCollection
                                             collection: (
                                              (WorkspaceSpec
                                                 name: 'TextEditor6'
                                                 layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                                                 activeHelpKey: arg3Value
                                                 tabable: true
                                                 hasHorizontalScrollBar: true
                                                 hasVerticalScrollBar: true
                                                 miniScrollerHorizontal: true
                                                 miniScrollerVertical: true
                                                 autoHideScrollBars: true
                                                 hasKeyboardFocusInitially: false
                                                 postBuildCallback: argument3WidgetCreated:
                                               )
                                              )
                                            
                                           )
                                           extent: (Point 110 69)
                                         )
                                        )
                                      
                                     )
                                     extent: (Point 110 214)
                                   )
                                  (WorkspaceSpec
                                     name: 'AnswerEditor'
                                     activeHelpKey: answerValue
                                     tabable: true
                                     hasHorizontalScrollBar: true
                                     hasVerticalScrollBar: true
                                     miniScrollerHorizontal: true
                                     miniScrollerVertical: true
                                     autoHideScrollBars: true
                                     hasKeyboardFocusInitially: false
                                     extent: (Point 110 214)
                                     postBuildCallback: messageAnswerWidgetCreated:
                                   )
                                  )
                                
                               )
                             )
                            )
                          
                         )
                       )
                      (ViewSpec
                         name: 'ReceiverArgBoxActionBox'
                         layout: (LayoutFrame 0 0 -98 0.5 0 1 -75 0.5)
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               activeHelpKey: clearButton    
                               label: 'Clear'
                               name: 'Button2'
                               layout: (LayoutFrame 5 0 0 0 -5 0.5 0 1)
                               translateLabel: true
                               model: clear
                             )
                            (ActionButtonSpec
                               activeHelpKey: startSearchButton    
                               label: 'Search'
                               name: 'Button1'
                               layout: (LayoutFrame 5 0.5 0 0 -5 1 0 1)
                               translateLabel: true
                               tabable: true
                               model: search
                             )
                            )
                          
                         )
                       )
                      (ViewSpec
                         name: 'MatchActionBox'
                         layout: (LayoutFrame 0 0 -70 0.5 0 1 10 0.5)
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Selector Pattern:'
                               name: 'Label1'
                               layout: (LayoutFrame 0 0 0 0 0 0.5 25 0)
                               translateLabel: true
                               adjust: left
                             )
                            (InputFieldSpec
                               name: 'EntryField1'
                               layout: (LayoutFrame 2 0 -54 1 -2 1 -29 1)
                               model: selectorPatternHolder
                               immediateAccept: true
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnPointerLeave: true
                             )
                            (ActionButtonSpec
                               label: 'Search'
                               name: 'Button4'
                               layout: (LayoutFrame 5 0.5 -25 1 -5 1 0 1)
                               translateLabel: true
                               tabable: true
                               model: searchPatternMatchesInBackground
                             )
                            )
                          
                         )
                       )
                      (SequenceViewSpec
                         name: 'ResultList'
                         layout: (LayoutFrame 0 0 15 0.5 0 1 0 1)
                         model: selectedImplementorsHolder
                         menu: resultListMenu
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         autoHideScrollBars: true
                         useIndex: true
                         sequenceList: resultHolder
                       )
                      )
                    
                   )
                 )
                (VariableVerticalPanelSpec
                   name: 'VariableVerticalPanel1'
                   component: 
                  (SpecCollection
                     collection: (
                      (SequenceViewSpec
                         name: 'List2'
                         model: selectedClassOfResultHolder
                         menu: implementorListMenu
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         autoHideScrollBars: true
                         doubleClickSelector: openBrowserOn:
                         valueChangeSelector: selectedClassOfResultHolderChanged
                         useIndex: false
                         sequenceList: classOfResultHolder
                       )
                      (CodeViewSpec
                         name: 'CodeView'
                         model: codeHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         autoHideScrollBars: true
                         hasKeyboardFocusInitially: false
                         postBuildCallback: sourceCodeWidgetCreated:
                         viewClassName: 'codeViewClass'
                       )
                      )
                    
                   )
                   handles: (Any 0.5 1.0)
                 )
                )
              
             )
             handles: (Any 0.37391304347826104 1.0)
           )
          )
        
       )
     )
! !

!MethodFinderWindow class methodsFor:'menu specs'!

implementorListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MethodFinderWindow andSelector:#implementorListMenu
     (Menu new fromLiteralArrayEncoding:(MethodFinderWindow implementorListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Browse'
            #translateLabel: true
            #value: #openBrowserOnSelectedItem
          )
         )
        nil
        nil
      )
!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MethodFinderWindow andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(MethodFinderWindow menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: '&File'
            #activeHelpKey: #file
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Exit'
                  #value: #closeRequest
                  #activeHelpKey: #fileExit
                )
               )
              nil
              nil
            )
          )
         #(#MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Documentation'
                  #value: #openHTMLDocumentation
                  #activeHelpKey: #helpTutorial
                )
               #(#MenuItem
                  #label: 'About MethodFinder...'
                  #value: #openAboutThisApplication
                  #activeHelpKey: #aboutThisAppliaction
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

    "Modified: / 13.11.2001 / 12:36:39 / cg"
!

resultListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MethodFinderWindow andSelector:#implementorListMenu
     (Menu new fromLiteralArrayEncoding:(MethodFinderWindow implementorListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Browse Senders'
            #translateLabel: true
            #value: #openBrowserOnSenderOfSelectedResultItem
          )
         #(#MenuItem
            #label: 'Browse Implementors'
            #translateLabel: true
            #value: #openBrowserOnSelectedResultItem
          )
         )
        nil
        nil
      )

    "Created: / 21-09-2012 / 11:05:15 / cg"
! !

!MethodFinderWindow class methodsFor:'startup'!

openOnSelectorPattern:selector
    |app|

    app := self new.
    app allButOpen.
    app selectorPatternHolder value:selector.
    app openWindow.
    "/ app waitForBackgroundSearchFinished.
    
    ^ app

    "
     self openOnSelectorPattern:'asLowercase'
    "
! !

!MethodFinderWindow methodsFor:'accessing'!

receiver
    "Return a copy of the value of the instance variable 'receiver' "

    ^ receiver copy
! !

!MethodFinderWindow methodsFor:'actions'!

clear
    "Reset the contents of all the outputs."

    receiverEditor contents:nil.
    argument1Editor contents:nil.
    argument2Editor contents:nil.
    argument3Editor contents:nil.
    messageAnswerEditor contents:nil.
    self resultHolder value:nil.
    self classOfResultHolder value: nil.
    codeHolder value:nil.
!

messageAnswerEditorContents
    "Return a cleaned up version of message answer taken from the messageAnswerEditor
     as an association. The association has cleanedAnswerString as a key and the
     compiledAnswer as value."
    
    |aCleanedAnswerString compiledAnswer|

    aCleanedAnswerString := self cleanInputs:(messageAnswerEditor contents).
    compiledAnswer := Compiler evaluate:aCleanedAnswerString.
    ((self isExpression:aCleanedAnswerString) or:[ compiledAnswer isNil ]) ifTrue:[
        aCleanedAnswerString := compiledAnswer printString
    ].
    ^ aCleanedAnswerString -> compiledAnswer.
!

openBrowserOn:anArgument 
    "Opens browser on theArgument of a specific class. anArgument being a string with the
       Class and the selector upon which the browser is to be opened. Return the receiver."

    |classAndSelector|

    classAndSelector := self extractClassAndSelectorFrom:anArgument.
    classAndSelector isNil ifTrue:[
        ^ self
    ].
    UserPreferences systemBrowserClass
        openInClass:classAndSelector key 
        selector:classAndSelector value   

"
MethodFinderWindow new openBrowserOn: '*SmallInteger +'
MethodFinderWindow new openBrowserOn: 'String ,'
MethodFinderWindow new openBrowserOn: 'Number detentBy:atMultiplesOf:snap:' 


"

    "Modified: / 13.11.2001 / 12:46:17 / cg"
!

openBrowserOnSelectedItem 
    "on the selected implementor"

    |sel|

    sel := self selectedClassOfResultHolder value.
    self openBrowserOn:sel

    "Modified: / 13-11-2001 / 12:47:39 / cg"
    "Modified (comment): / 21-09-2012 / 11:08:33 / cg"
!

openBrowserOnSelectedResultItem 
    "on an item in the lower left list,
     on all implementors of that message"

    |selIndex selector|

    selIndex := self selectedImplementorsHolder value.
    selIndex isNil ifTrue:[^ self].

    selector := resultSelectors at:selIndex.
    UserPreferences browserClass browseImplementorsOf:selector.

    "Created: / 21-09-2012 / 11:05:46 / cg"
!

openBrowserOnSenderOfSelectedResultItem
    "on an item in the lower left list,
     on all implementors of that message"

    |selIndex selector|

    selIndex := self selectedImplementorsHolder value.
    selIndex isNil ifTrue:[^ self].

    selector := resultSelectors at:selIndex.
    UserPreferences browserClass browseSendersOf:selector.
!

search
    "Do a search based on the input in the various text editors. Return the receiver."

    |tempReceiver tempAnswer tempArguments anArray resultArray receiverWithArgument mf|

    self resultHolder value:nil.
    self classOfResultHolder value:nil.
    self codeHolder value:nil.
    tempArguments := self argumentEditorsContents.
    tempReceiver := self receiverEditorContents.
    tempAnswer := self messageAnswerEditorContents.
     "self cleanInputRec:tempReceiver arg:tempArguments ans:tempAnswer."
    anArray := Array new:2.
    receiverWithArgument := self mergeReceiver:(tempReceiver value)
                                 withArgument:(tempArguments values).
    anArray
        at:1 put:receiverWithArgument;
        at:2 put:tempAnswer value.
     "an array now holds the following array #(#(receiver argument) answer) or #(#(receiver) answer). which should
     be suitable input for the method finder."
    self withCursor:Cursor execute
        do:[
            mf := MethodFinder new.
            resultArray := mf
                    load:anArray;
                    findMessage.
        ].
    ((resultArray at:1) includesSubString:'no single') ifTrue:[
        self warn:(resultArray at:1).
        ^ self
    ].
     "the following then replaces data1 and data2 created by the method finder to the appropriate arguments"
    resultArray
        keysAndValuesDo:[:key :value |
            |newValue|

            newValue := value replString:'data1' withString:(tempReceiver key).
            (tempArguments size) >= 1 ifTrue:[
                newValue := newValue replString:'data2'
                        withString:(tempArguments keyAt:1)
            ].
            (tempArguments size) > 1 ifTrue:[
                newValue := newValue replString:'data3'
                        withString:(tempArguments keyAt:2).
            ].
            (tempArguments size) > 2 ifTrue:[
                newValue := newValue replString:'data4'
                        withString:(tempArguments keyAt:3).
            ].
            (tempArguments size) > 3 ifTrue:[
                self halt:'unimplemented'.
            ].
             "    newValue:= value replString: 'data3' withString:(self messageAnswer key). "
            newValue := newValue , ' --> ' , (tempAnswer key).
            newValue replaceAll:Character cr with:Character space.
            resultArray at:key put:newValue.
        ].
    self resultHolder value:resultArray.
    resultSelectors := mf selectors.
    receiver := tempReceiver

    "Modified: / 26-09-2011 / 12:42:28 / cg"
!

searchPatternMatchesInBackground
    "Do a search based on the pattern match as a background task"

    | p pattern|

    (p := searchProcess) notNil ifTrue:[
        searchProcess := nil.
        p terminate.
    ].

    pattern := self selectorPatternHolder value.
    pattern isEmptyOrNil ifTrue:[
        self resultHolder value:self resultInfoText.
        self classOfResultHolder value:nil.
        self codeHolder value:nil.
        ^ self
    ].

    searchProcess := 
        [
            |list counts firsts seconds selectors resultList idx match|

            self withCursor:Cursor execute do:[
                pattern includesMatchCharacters ifFalse:[   
                    list := SystemBrowser findImplementorsOf:pattern in:Smalltalk allClasses ignoreCase:true.
                    list isEmptyOrNil ifTrue:[
                        match := pattern,'*'.
                        list := SystemBrowser findImplementorsMatching:match in:Smalltalk allClasses ignoreCase:true.
                    ].
                ] ifTrue:[
                    "/ match := '*',pattern,'*'.
                    match := pattern.
                    list := SystemBrowser findImplementorsMatching:match in:Smalltalk allClasses ignoreCase:true.
                ].
            ].

            counts := IdentityDictionary new.
            firsts := IdentityDictionary new.
            seconds := IdentityDictionary new.
            selectors := IdentitySet new.
            list do:[:eachMethod |
                |msel|

                msel := eachMethod selector.
                selectors add:msel.
                (counts at:msel ifAbsentPut:[ 0 asValue ]) increment.
                (firsts includesKey:msel) ifTrue:[
                    (seconds includesKey:msel) ifFalse:[
                        seconds at:msel ifAbsentPut:[ eachMethod mclass ].
                    ].
                ] ifFalse:[
                    firsts at:msel ifAbsentPut:[ eachMethod mclass ].
                ].
            ].
            resultSelectors := selectors asOrderedCollection sort.
            resultList := resultSelectors 
                            collect:[:sel | 
                                |cnt s|

                                s := sel allBold , ' --> '.
                                cnt := (counts at:sel) value.
                                cnt == 1 ifTrue:[
                                    s , (firsts at:sel) name
                                ] ifFalse:[
                                    cnt == 2 ifTrue:[
                                        s , (firsts at:sel) name , ' and ' , (seconds at:sel) name
                                    ] ifFalse:[
                                        s , cnt printString , ' implementor(s)'
                                    ]
                                ].
                            ].
                            
            self enqueueDelayedAction:[ self updateListAfterPatternSearch: resultList ].
        ] fork.

    "Created: / 01-06-2012 / 13:16:54 / cg"
!

updateImplementorsOf:anInteger 
    "Request the implementors of the selected argument provided by aNumber.
     Return the receiver."
    
    |methods classList aNumber|

    (anInteger isNil) ifTrue:[
        ^ self
    ].
    anInteger isNil ifTrue:[
        aNumber := 1
    ] ifFalse:[
        aNumber := anInteger
    ].
    methods := SystemBrowser 
            findImplementorsOf:(resultSelectors at:aNumber)
            in:Smalltalk allClasses
            ignoreCase:false.
    classList := methods asOrderedCollection 
            collect:[:m | m mclass name , ' ' , m selector ].
    classList := (self markMatchingClasses:(resultSelectors at:aNumber)
            classesWithSelector:classList).
    self classOfResultHolder value:classList.
    classList size > 0 ifTrue:[
        self selectedClassOfResultHolder value:(classList first).
        self selectedClassOfResultHolderChanged.
    ] ifFalse:[
        self selectedClassOfResultHolder value:nil.
    ].

    "Modified (comment): / 24-06-2012 / 18:41:45 / cg"
!

updateListAfterPatternSearch:resultList
    |searchPattern idx|
    
    self classOfResultHolder value:nil.
    self codeHolder value:nil.
    self resultHolder value:resultList.

    searchPattern := self selectorPatternHolder value.
    "/ is the search pattern in the list (i.e. a perfect match)?
    "/ Then select it.
    idx := resultSelectors indexOf:searchPattern.
    idx ~~ 0 ifTrue:[
        self selectedImplementorsHolder setValue:idx; changed
    ].    
! !

!MethodFinderWindow methodsFor:'aspects'!

arg1BoxVisible
    "Determines if the box should be visible or not. 
     Return a holder providing true or false"

    arg1BoxVisible isNil ifTrue:[
        arg1BoxVisible := BlockValue
                              with:[:vh | vh value >= 2 ]
                              argument:(self argCountHolder)
    ].
    ^ arg1BoxVisible.
!

arg2BoxVisible
    "Determines if the box should be visible or not. 
     Return a holder providing true or false"

    arg2BoxVisible isNil ifTrue:[
        arg2BoxVisible := BlockValue
                              with:[:vh | vh value >= 3 ]
                              argument:(self argCountHolder)
    ].
    ^ arg2BoxVisible.
!

arg3BoxVisible
    "Determines if the box should be visible or not. 
     Return a holder providing true or false"

    arg3BoxVisible isNil ifTrue:[
        arg3BoxVisible := BlockValue
                              with:[:vh | vh value >= 4 ]
                              argument:(self argCountHolder)
    ].
    ^ arg3BoxVisible.
!

arg4BoxVisible
    "Determines if the box should be visible or not. 
     Return a holder providing true or false"

    arg4BoxVisible isNil ifTrue:[
        arg4BoxVisible := BlockValue
                              with:[:vh | vh value >= 5 ]
                              argument:(self argCountHolder)
    ].
    ^ arg4BoxVisible.
!

argCountHolder
    "Return an argCounterHolder which is initialized at 2."
    
    argCountHolder isNil ifTrue:[
        argCountHolder := 2 asValue.
    ].     
    ^ argCountHolder.
!

argCountList
    "Return the argCountList (shown in the combo)"

    argCountList isNil ifTrue:[
        argCountList := #('0 arguments' '1 argument' '2 arguments' '3 arguments') asValue  
    ].
    ^ argCountList.
!

classOfResultHolder
    "Return a valueHolder which contains a collection with the names of the 
     implementors of a specific message.   "

    classOfResultHolder isNil ifTrue:[
        classOfResultHolder := ValueHolder new.
    ].
    ^ classOfResultHolder
!

codeHolder
    codeHolder isNil ifTrue:[
        codeHolder := '' asValue.
    ].
    ^ codeHolder.

    "Created: / 13.11.2001 / 12:44:11 / cg"
!

codeViewClass
    "the species of view to be created as codeview"
    
    ^ Tools::CodeView2 ? CodeView
!

resultHolder
    "Return a value holder which contains the results of a search as a collection."

    resultHolder isNil ifTrue:[
        resultHolder := ValueHolder new.
        resultHolder value:(self resultInfoText collect:[:l | l withColor:Color darkGrey]).
    ].
    ^ resultHolder.

    "Modified: / 01-06-2012 / 13:06:02 / cg"
!

resultInfoText
    ^  {
          'Please enter combination of' .
          '    ',('receiver, arg and result' allBold) .
          'or a'.
          '    ',('selector search pattern' allBold) .
          'into the above fields.' .
          'Then click on either ',('"search"' allBold),'-button.'
       }
!

selectedClassOfResultHolder
    "valueHolder which contains the index of the selected result class (right list)"

    selectedClassOfResultHolder isNil ifTrue:[
        selectedClassOfResultHolder := ValueHolder new.
    ].
    ^ selectedClassOfResultHolder

    "Modified (comment): / 21-09-2012 / 11:10:29 / cg"
!

selectedImplementorsHolder
    "valueHolder which contains the index of the selected implementors list (left list)"

    selectedImplementorsHolder isNil ifTrue:[
        selectedImplementorsHolder := ValueHolder new.
        selectedImplementorsHolder onChangeEvaluate:[self updateImplementorsOf:selectedImplementorsHolder value].
    ].
    ^ selectedImplementorsHolder

    "Created: / 21-09-2012 / 11:10:13 / cg"
!

selectorPatternHolder
    selectorPatternHolder isNil ifTrue:[
        selectorPatternHolder := ValueHolder new.
        selectorPatternHolder onChangeSend:#selectorPatternChanged to:self.
    ].
    ^ selectorPatternHolder

    "Created: / 27-04-2012 / 14:44:01 / cg"
! !

!MethodFinderWindow methodsFor:'controlInput'!

cleanInputs:aDirtyString 
    "Find and remove common mistakes made by the user. Return the 
     'aStringToBeCleaned' variable"
    
    |aStringToBeCleaned rs position|

    aStringToBeCleaned := aDirtyString.
    (aStringToBeCleaned endsWith:(Character cr)) ifTrue:[
        aStringToBeCleaned := aStringToBeCleaned copyFrom:1 to:(aStringToBeCleaned size - 1).
    ].
    aStringToBeCleaned := aStringToBeCleaned withoutSeparators.
    rs := ReadStream on:aStringToBeCleaned.
    [
        rs upToAll_positionBefore:'#true'.
        rs atEnd
    ] whileFalse:[
        position := rs position.
        aStringToBeCleaned := aStringToBeCleaned 
                copyReplaceFrom:position
                to:position
                with:''.
        rs := ReadStream on:aStringToBeCleaned.
    ].
    rs := ReadStream on:aStringToBeCleaned.
    [
        rs upToAll_positionBefore:'#false'.
        rs atEnd
    ] whileFalse:[
        position := rs position.
        aStringToBeCleaned := aStringToBeCleaned 
                copyReplaceFrom:position
                to:position
                with:''.
        rs := ReadStream on:aStringToBeCleaned.
    ].
    [
        rs upToAll_positionBefore:'#nil'.
        rs atEnd
    ] whileFalse:[
        position := rs position.
        aStringToBeCleaned := aStringToBeCleaned 
                copyReplaceFrom:position
                to:position
                with:''.
        rs := ReadStream on:aStringToBeCleaned.
    ].
    ^ aStringToBeCleaned
!

markMatchingClasses:aSelector classesWithSelector:anOrderedCollection
    " Matches the class of the receiver with all the elements in anOrderedCollection
     (which are classes with selectors). If a match is found it is marked with an asterisk.
     The classes are then sorted so the asterisk appears first. Return the
     markedClassList."
    
    |marker recClass unmarkedClassList markedClassList|

    marker := self class markerForImplementingClass.
    recClass := receiver value class.
    unmarkedClassList := anOrderedCollection copy.
    unmarkedClassList do:[:classAndMethod |
        |className class sel|

        className := classAndMethod copyButLast:aSelector size.
        class := Smalltalk classNamed:className. "/ Compiler evaluate:className.

        "/ (recClass == class)

        (recClass whichClassImplements:aSelector) == class ifTrue:[
            "/ unmarkedClassList add: marker, classAndMethod.
            unmarkedClassList add:classAndMethod allBold.
            unmarkedClassList remove:classAndMethod.
        ].
    ].
    unmarkedClassList
        sort:[:a :b |
            |rawA rawB|

            rawA := a string withoutPrefix:marker.
            rawB := b string withoutPrefix:marker.
            rawA < rawB.
        ].
    markedClassList := unmarkedClassList.
    ^ markedClassList

    "Modified: / 13.11.2001 / 12:16:05 / cg"
!

mergeReceiver: aReceiver withArgument: arguments

"Puts the receiver and arguments into an array so it can be of a suitable input for the
 MethodFinder. Return an array."

| tempReceiver tempArguments receiverWithArgument|

  tempReceiver:= aReceiver.
 tempArguments :=  arguments.

(tempArguments isEmpty or:[(tempArguments) isNil])
                ifTrue:[  receiverWithArgument:=Array new:1."no argument"
                          receiverWithArgument at:1 put: tempReceiver.     
                        ]
                ifFalse:[
        (tempArguments size = 1)
                        ifTrue:[ receiverWithArgument:=Array new:2.
                                  receiverWithArgument at:1 put: tempReceiver.      
                                  receiverWithArgument at:2 put: (tempArguments at:1)
                                ].  "a receiver with an argument"

        (tempArguments size = 2)
                        ifTrue:[ receiverWithArgument:=Array new:3.
                                  receiverWithArgument at:1 put: tempReceiver.      
                                  (receiverWithArgument at:2 put: (tempArguments at:1)).
                                  (receiverWithArgument at:3 put: (tempArguments at:2))
                                ].  "a receiver with an argument"
        (tempArguments size = 3)
                        ifTrue:[ receiverWithArgument:=Array new:4.
                                  receiverWithArgument at:1 put: tempReceiver.      
                                  (receiverWithArgument at:2 put: (tempArguments at:1)).
                                  (receiverWithArgument at:3 put: (tempArguments at:2)).
                                  (receiverWithArgument at:4 put: (tempArguments at:3)).

                                ].  "a receiver with an argument"

                        ].
^receiverWithArgument
! !

!MethodFinderWindow methodsFor:'initialization'!

argument1WidgetCreated: aWidget
    "UI post creation hook. remember the widget as an instance variable."

    argument1Editor := aWidget scrolledView.
    aWidget tabMeansNextField:true.

    "Modified: / 13.11.2001 / 12:21:41 / cg"
!

argument2WidgetCreated: aWidget
    "UI post creation hook. remember the widget as an instance variable."

    argument2Editor := aWidget scrolledView.
    aWidget tabMeansNextField:true.

    "Modified: / 13.11.2001 / 12:21:45 / cg"
!

argument3WidgetCreated: aWidget
    "UI post creation hook. remember the widget as an instance variable"

    argument3Editor := aWidget scrolledView.
    aWidget tabMeansNextField:true.

    "Modified: / 13.11.2001 / 12:21:49 / cg"
!

messageAnswerWidgetCreated: aWidget
    "UI post creation hook. remember the widget as an instance variable."

    messageAnswerEditor := aWidget scrolledView.
    aWidget tabMeansNextField:true.

    "Modified: / 13.11.2001 / 12:24:55 / cg"
!

receiverWidgetCreated: aWidget
    "UI post creation hook. remember the widget as an instance variable."

    receiverEditor := aWidget scrolledView.
    aWidget tabMeansNextField:true.

    "Modified: / 13.11.2001 / 12:24:49 / cg"
!

sourceCodeWidgetCreated: aWidget
    "UI post creation hook. make the codeView readonly"
    
    aWidget acceptAction:nil.
    aWidget readOnly:true

    "Created: / 13.11.2001 / 12:50:27 / cg"
    "Modified: / 13.11.2001 / 12:51:23 / cg"
! !

!MethodFinderWindow methodsFor:'menu actions'!

aboutThisApplicationText
    |msg|

    msg := super aboutThisApplicationText.
    msg := msg , '\\Original written by Ted Kaehler, Scott Wallace and Dan Ingalls.
Ported from Squeak to ST/X by James Hayes (2001 james@exept.de).
Improved by Claus Gittinger.    
'.
    ^msg withCRs.

    "Modified: / 13.11.2001 / 12:56:44 / cg"
!

openHTMLDocumentation
    "about/help menu action"
    
    HTMLDocumentView openFullOnDocumentationFile:'tools/misc/TOP.html#METHODFINDER'
! !

!MethodFinderWindow methodsFor:'private'!

argumentEditorsContents

"Determine how many text editors of the arguments are used and store the result
as argCounter. The result being the minimum between how many editors have
expressions in and how many are displayed.

Add each argument string (key)and the evaluated version (value) to an Ordered Dictionary
from each of the text editors.

Return the OrderedDictionary with the expressions from all the text editors. "

     | tempArguments argCounter tempArgument1Editor tempArgument2Editor tempArgument3Editor
associationKey associationValue|

argCounter:=0.

tempArgument1Editor:= (self cleanInputs: argument1Editor contents).
tempArgument2Editor:=  (self cleanInputs: argument2Editor contents).
tempArgument3Editor:= (self cleanInputs: argument3Editor contents).

tempArgument1Editor = '' ifFalse:[argCounter:=argCounter +1].
tempArgument2Editor = '' ifFalse:[argCounter:=argCounter +1].
tempArgument3Editor = '' ifFalse:[argCounter:=argCounter +1].


argCounter:= (argCounter min: (self argCountHolder value -1)).
tempArguments:= OrderedDictionary new:argCounter. 

(argCounter value >= 1) 
                ifTrue:[associationValue:= (Compiler evaluate: tempArgument1Editor).
                        ((self isExpression:tempArgument1Editor) or:[ associationValue isNil]) ifTrue:[                  "looks if an expression is typed in"
                                        associationKey:=associationValue printString]
                                                          ifFalse:[
                                        associationKey:=tempArgument1Editor].

                        tempArguments add: associationKey-> associationValue.
                        ].
(argCounter value >= 2) 
                ifTrue:[ associationValue:= (Compiler evaluate: tempArgument2Editor).
                        (((self isExpression:tempArgument2Editor) or:[ associationValue isNil])) ifTrue:[                  "looks if an expression is typed in"
                                        associationKey:=associationValue printString]
                                                          ifFalse:[
                                        associationKey:=tempArgument2Editor].

                        tempArguments add: associationKey-> associationValue].

(argCounter value >= 3)
                ifTrue:[ associationValue:= (Compiler evaluate: tempArgument3Editor).
                        ((self isExpression:tempArgument3Editor) or:[ associationValue isNil]) ifTrue:[                  "looks if an expression is typed in"
                                        associationKey:=associationValue printString]
                                                          ifFalse:[
                                        associationKey:=tempArgument3Editor].

                        tempArguments add: associationKey-> associationValue].


^tempArguments
!

extractClassAndSelectorFrom:anArgument 
    "Opens browser on theArgument of a specific class. anArgument being a string with the
       Class and the selector upon which the browser is to be opened. Return the receiver."

    |aClass aSelector x theArgument marker|

    anArgument isNil ifTrue:[
        ^ nil
    ].
    marker := self class markerForImplementingClass.

    theArgument := anArgument string withoutPrefix:marker.
    aClass := theArgument copyUpTo:(Character space).
    x := aClass size + 2.
    aSelector := theArgument copyFrom:x.
    aClass := Smalltalk classNamed:aClass.
    (aSelector startsWith:'class ') ifTrue:[
        aSelector := aSelector withoutPrefix:'class '.
        aClass := aClass class.
    ].
    ^ aClass -> aSelector asSymbol

"
MethodFinderWindow new extractClassAndSelectorFrom: '*SmallInteger +'
MethodFinderWindow new extractClassAndSelectorFrom: 'String ,'       
MethodFinderWindow new extractClassAndSelectorFrom: 'Number detentBy:atMultiplesOf:snap:' 


"

    "Modified: / 27-04-2012 / 15:05:53 / cg"
!

isExpression:aString 
    "Return true or false depending on if the subString includes certain characters"
    
    "/ cg: this is naive - why not ask the parser, if it is a literal?
    (aString includesSubString:': ') ifTrue:[
        ^ true
    ].
    (aString includes:$+) ifTrue:[
        ^ true
    ].
    (aString includes:$-) ifTrue:[
        ^ true
    ].
    (aString includes:$*) ifTrue:[
        ^ true
    ].
    (aString includes:$/) ifTrue:[
        ^ true
    ].
    (aString includes:$>) ifTrue:[
        ^ true
    ].
    (aString includes:$<) ifTrue:[
        ^ true
    ].
    (aString includesSubString:' new') ifTrue:[
        ^ true
    ].
    (aString includes:$[) 
        & (aString includes:$]) 
        & (aString includes:$.) ifTrue:[ ^ false ].

    (aString includes:$.) ifTrue:[
        ^ true
    ].
    ^ false
!

receiverEditorContents
    "Return a cleaned up version of receiver taken from the receiverEditor
     as an association. The association has aCleanedReceiverString as a key and the
     compiledReceiver as value."

    |aCleanedReceiverString compiledReceiver|

    aCleanedReceiverString := self cleanInputs:(receiverEditor contents).
    compiledReceiver := Compiler evaluate:aCleanedReceiverString.
    ((self isExpression:aCleanedReceiverString) or:[ compiledReceiver isNil ]) ifTrue:[
        aCleanedReceiverString := compiledReceiver printString
    ].
    ^ aCleanedReceiverString -> compiledReceiver.
!

waitForBackgroundSearchFinished
    | p |

    (p := searchProcess) isNil ifTrue:[^ self].
    p isDead ifTrue:[^ self].
    p waitUntilTerminated 
! !

!MethodFinderWindow methodsFor:'user actions'!

selectedClassOfResultHolderChanged
    |sel classAndSelector mthd|

    sel := self selectedClassOfResultHolder value.

    classAndSelector := self extractClassAndSelectorFrom:sel.
    classAndSelector isNil ifTrue:[
        ^ self
    ].
    mthd := classAndSelector key >> classAndSelector value.   
    mthd notNil ifTrue:[
        self withWaitCursorDo:[
            self codeHolder value:mthd source
        ]
    ] ifFalse:[
        self codeHolder value:nil
    ].

    "Created: / 13.11.2001 / 12:43:43 / cg"
    "Modified: / 13.11.2001 / 12:48:56 / cg"
!

selectorPatternChanged
    self searchPatternMatchesInBackground

    "Created: / 01-06-2012 / 13:18:16 / cg"
! !

!MethodFinderWindow class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

