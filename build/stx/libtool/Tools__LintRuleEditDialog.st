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

SimpleDialog subclass:#LintRuleEditDialog
	instanceVariableNames:'ruleHolder nameHolder selectionHolder variablePanel
		relativeCorners detailsShown listSelection nameEditableHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Lint'
!

!LintRuleEditDialog class methodsFor:'documentation'!

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
    documentation to be added.

    [author:]
        Jan Vrany (jv@neso)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    Tools::LintRuleSelectionDialog open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!LintRuleEditDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::LintRuleEditDialog andSelector:#windowSpec
     Tools::LintRuleEditDialog new openInterface:#windowSpec
     Tools::LintRuleEditDialog open
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
         bounds: (Rectangle 0 0 630 644)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'Content'
             layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
             horizontalLayout: fit
             verticalLayout: topFit
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'NameBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Name:'
                         name: 'Label1'
                         layout: (LayoutFrame 0 0 0 0 60 0 0 1)
                         translateLabel: true
                         adjust: left
                       )
                      (InputFieldSpec
                         name: 'EntryField1'
                         layout: (LayoutFrame 60 0 3 0 -2 1 -2 1)
                         enableChannel: nameEditableHolder
                         model: nameHolder
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnPointerLeave: true
                       )
                      )
                    
                   )
                   extent: (Point 630 30)
                 )
                (ViewSpec
                   name: 'Spacer'
                   extent: (Point 630 7)
                 )
                (LabelSpec
                   label: 'Rules'
                   name: 'Label2'
                   translateLabel: true
                   adjust: left
                   extent: (Point 630 25)
                 )
                (VariableVerticalPanelSpec
                   name: 'VariableVerticalPanel1'
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
                   extent: (Point 630 543)
                   handles: (Any 0.47999999999999998 1.0)
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'ButtonPanel'
             layout: (LayoutFrame 0 0 -30 1 -16 1 0 1)
             horizontalLayout: fitSpace
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
                   extent: (Point 301 31)
                   usePreferredHeight: true
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'OKButton'
                   translateLabel: true
                   model: doAccept
                   isDefault: true
                   defaultable: true
                   extent: (Point 301 31)
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

!LintRuleEditDialog methodsFor:'accessing'!

rule: anRBCompositeLintRule
    self ruleHolder value: anRBCompositeLintRule

    "Created: / 27-02-2013 / 11:53:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection

    ^self selectionHolder value

    "Created: / 25-08-2010 / 14:10:03 / Jan Vrany <enter your email here>"
!

selection: anObject

    self selectionHolder value: anObject

    "Created: / 25-08-2010 / 14:09:40 / Jan Vrany <enter your email here>"
! !

!LintRuleEditDialog methodsFor:'actions'!

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

!LintRuleEditDialog methodsFor:'aspects'!

allRulesHolder

    ^[(RBCompositeLintRule allRules) rules]

    "Created: / 15-04-2010 / 20:09:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

    ^[#select]

    "Created: / 15-04-2010 / 20:13:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameEditableHolder
    "return/create the 'nameEditableHolder' value holder (automatically generated)"

    nameEditableHolder isNil ifTrue:[
        nameEditableHolder := ValueHolder with: true.
    ].
    ^ nameEditableHolder

    "Modified: / 16-10-2014 / 11:12:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameHolder
    "return/create the 'nameHolder' value holder (automatically generated)"

    nameHolder isNil ifTrue:[
        nameHolder := ValueHolder new.
    ].
    ^ nameHolder
!

ruleHolder
    "return/create the 'ruleHolder' value holder (automatically generated)"

    ruleHolder isNil ifTrue:[
        ruleHolder := ValueHolder new.
        ruleHolder addDependent:self.
    ].
    ^ ruleHolder
!

ruleHolder:something
    "set the 'ruleHolder' value holder (automatically generated)"

    |oldValue newValue|

    ruleHolder notNil ifTrue:[
        oldValue := ruleHolder value.
        ruleHolder removeDependent:self.
    ].
    ruleHolder := something.
    ruleHolder notNil ifTrue:[
        ruleHolder addDependent:self.
    ].
    newValue := ruleHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:ruleHolder.
    ].
!

selectionHolder
    "return/create the 'selectionHolder' value holder (automatically generated)"

    selectionHolder isNil ifTrue:[
        selectionHolder := ValueHolder new.
    ].
    ^ selectionHolder
! !

!LintRuleEditDialog methodsFor:'callbacks - post build'!

postBuildVariablePanel: aPanel

    variablePanel := aPanel.

    "Created: / 24-07-2010 / 15:05:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleEditDialog methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == ruleHolder ifTrue:[
         self updateSelection.
         self updateName.
         ^ self.
    ].
    changedObject == accept ifTrue:[
        self ruleHolder value name: self nameHolder value.
        self ruleHolder value rules: self selectionHolder value.
        self acceptValue:self ruleHolder value.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 27-02-2013 / 11:52:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateName
    self nameHolder value: (self ruleHolder value name)

    "Created: / 27-02-2013 / 11:46:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSelection
    self selectionHolder value: (self ruleHolder value flattened)

    "Created: / 27-02-2013 / 11:42:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleEditDialog methodsFor:'initialization'!

initialize
    super initialize.
    accept addDependent: self.

    "Created: / 27-02-2013 / 11:45:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleEditDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

