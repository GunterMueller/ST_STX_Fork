"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

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

SimpleDialog subclass:#LintRuleSelectionDialog
	instanceVariableNames:'selectionHolder variablePanel relativeCorners detailsShown
		listSelection rulesetList rulesetHolder rulesetNameList
		rulesetNameHolder canAcceptHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Lint'
!

!LintRuleSelectionDialog class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

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
!

documentation
"
    A dialog to select SmallLint rules. 

    [example:]
        | dialog rules |

        dialog := Tools::LintRuleSelectionDialog new.
        dialog open.
        dialog accepted ifTrue:[
            rules := dialog selectionAsRule
        ] ifFalse:[ 
            Dialog warn: 'Cancelled...'.
        ].

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Ask user to select some SmallLint rules
                                                                [exBegin]
    | dialog rules |

    dialog := Tools::LintRuleSelectionDialog new.
    dialog open.
    dialog accepted ifTrue:[
        rules := dialog selectionAsRule
    ].
    rules inspect.

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!LintRuleSelectionDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::LintRuleSelectionDialog andSelector:#windowSpec
     Tools::LintRuleSelectionDialog new openInterface:#windowSpec
     Tools::LintRuleSelectionDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Select Lint Rules'
         name: 'Select Lint Rules'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 603 569)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'ContentPanel'
             layout: (LayoutFrame 10 0 0 0 -10 1 -40 1)
             component: 
            (SpecCollection
               collection: (
                (VariableVerticalPanelSpec
                   name: 'VariableVerticalPanel1'
                   layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                   component: 
                  (SpecCollection
                     collection: (
                      (SubCanvasSpec
                         name: 'RuleList'
                         hasHorizontalScrollBar: false
                         hasVerticalScrollBar: false
                         majorKey: #'Tools::HierarchicalLintRuleList'
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: inGeneratorHolder
                             aspect: allRulesHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: listSelection
                             aspect: listSelection
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: modeHolder
                             aspect: modeHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: outGeneratorHolder
                             aspect: selectedRulesHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectionHolder
                             aspect: selectionHolder
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'RuleDesc'
                         hasHorizontalScrollBar: false
                         hasVerticalScrollBar: false
                         majorKey: #'Tools::LintRuleDetail'
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: ruleHolder
                             aspect: listSelection
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
          (HorizontalPanelViewSpec
             name: 'ButtonPanel'
             layout: (LayoutFrame 10 0 -40 1 -16 1 0 1)
             horizontalLayout: okCancelBox
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'CancelButton'
                   translateLabel: true
                   model: doCancel
                   extent: (Point 282 25)
                   usePreferredHeight: true
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'OKButton'
                   translateLabel: true
                   model: doAccept
                   isDefault: true
                   defaultable: true
                   extent: (Point 283 22)
                   usePreferredHeight: true
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
! !

!LintRuleSelectionDialog methodsFor:'accessing'!

selection

    ^self selectionHolder value

    "Created: / 25-08-2010 / 14:10:03 / Jan Vrany <enter your email here>"
!

selection: anObject

    self selectionHolder value: anObject

    "Created: / 25-08-2010 / 14:09:40 / Jan Vrany <enter your email here>"
!

selectionAsRule
    ^ RBCompositeLintRule rules: self selection name: (resources string: 'Selected Rules')

    "Created: / 25-08-2010 / 14:10:58 / Jan Vrany <enter your email here>"
    "Modified: / 27-11-2014 / 09:26:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleSelectionDialog methodsFor:'actions'!

hideResultView

    detailsShown == true ifFalse:[^self].

    variablePanel shown ifFalse:[^self].

    relativeCorners := variablePanel relativeCorners.

    variablePanel
        relativeCorners:#( 0.99 1.0 );
        resizeSubviews.
    detailsShown := false.

    "Created: / 10-02-2007 / 11:39:10 / janfrog"
    "Modified: / 24-07-2010 / 15:30:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showResultView
    detailsShown == true ifTrue:[^self].
    variablePanel
        relativeCorners:relativeCorners ? #(0.5 1.0);
        resizeSubviews.
    detailsShown := true.

    "Created: / 10-02-2007 / 11:38:26 / janfrog"
    "Modified: / 24-07-2010 / 15:30:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleSelectionDialog methodsFor:'aspects'!

allRulesHolder

    ^[(RBCompositeLintRule allRules) rules]

    "Created: / 15-04-2010 / 20:09:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canAcceptHolder
    <resource: #uiAspect>

    canAcceptHolder isNil ifTrue:[
        canAcceptHolder := true asValue.
    ].
    ^ canAcceptHolder.

    "Modified (comment): / 27-11-2014 / 09:17:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listSelection
    "return/create the 'listSelection' value holder (automatically generated)"

    listSelection isNil ifTrue:[
        listSelection := ValueHolder new.
    ].
    ^ listSelection
!

listSelection:something
    "set the 'listSelection' value holder (automatically generated)"

    listSelection := something.
!

modeHolder

    ^ [ #select ]

    "Created: / 15-04-2010 / 20:13:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-11-2014 / 09:19:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionHolder
    "return/create the 'selectionHolder' value holder (automatically generated)"

    selectionHolder isNil ifTrue:[
        selectionHolder := ValueHolder new.
    ].
    ^ selectionHolder
! !

!LintRuleSelectionDialog methodsFor:'callbacks - post build'!

postBuildVariablePanel: aPanel

    variablePanel := aPanel.

    "Created: / 24-07-2010 / 15:05:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleSelectionDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

