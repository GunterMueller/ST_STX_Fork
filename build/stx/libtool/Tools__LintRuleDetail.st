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

ApplicationModel subclass:#LintRuleDetail
	instanceVariableNames:'ruleHolder rationaleVisibleHolder rationalView
		selectedMethodsHolder selectedClassesHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Lint'
!

!LintRuleDetail class methodsFor:'documentation'!

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
    Embeddable list to display affected methods from a selected SmallLint rules.
    (this is embedded in the browser when showing lint check outcomes)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!LintRuleDetail class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::LintRuleDetail    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#ruleName
'Click to browse the lint rule'

)

    "Created: / 07-09-2011 / 04:08:11 / cg"
! !

!LintRuleDetail class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::LintRuleDetail andSelector:#windowSpec
     Tools::LintRuleDetail new openInterface:#windowSpec
     Tools::LintRuleDetail open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'SmalllintRuleDetail'
          name: 'SmalllintRuleDetail'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 560 300)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'Panel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: topSpaceFit
              horizontalSpace: 0
              verticalSpace: 0
              ignoreInvisibleComponents: true
              component: 
             (SpecCollection
                collection: (
                 (ViewSpec
                    name: 'Label'
                    visibilityChannel: false
                    component: 
                   (SpecCollection
                      collection: (
                       (LinkButtonSpec
                          name: 'Button1'
                          layout: (LayoutFrame 0 0 0 0 -150 1 30 0)
                          activeHelpKey: ruleName
                          translateLabel: true
                          labelChannel: ruleNameAspect
                          adjust: left
                          model: browseLintRule
                        )
                       (CheckBoxSpec
                          label: 'Show Rationale'
                          name: 'CheckBox1'
                          layout: (LayoutFrame -150 1 0 0 0 1 30 0)
                          model: rationaleVisibleHolder
                          translateLabel: true
                        )
                       )
                     
                    )
                    extent: (Point 560 30)
                  )
                 (HTMLViewSpec
                    name: 'Rationale'
                    level: 0
                    visibilityChannel: rationaleVisibleHolder
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    backgroundColor: (Color 86.9993133440147 86.9993133440147 86.9993133440147)
                    htmlText: ruleRationaleAspect
                    extent: (Point 560 270)
                    postBuildCallback: setupHTMLView:
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!LintRuleDetail class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #ruleHolder
        #ruleRationaleAspect
        #selectedMethodsHolder
        #selectedClassesHolder
      ).

    "Modified: / 01-03-2012 / 16:31:04 / cg"
! !

!LintRuleDetail methodsFor:'actions'!

browseLintRule
    |rule ruleClass sel|

    rule := self ruleHolder value.
    rule isNil ifTrue:[^ self].
    
    ruleClass := rule class.
    (ruleClass implements:#rationale) ifTrue:[
        sel := #rationale.
    ].
    UserPreferences systemBrowserClass
       openInClass:ruleClass selector:sel

    "Created: / 07-09-2011 / 04:09:38 / cg"
! !

!LintRuleDetail methodsFor:'aspects'!

rationaleVisibleHolder
    "return/create the 'rationaleVisibleHolder' value holder (automatically generated)"

    rationaleVisibleHolder isNil ifTrue:[
        rationaleVisibleHolder := ValueHolder with: true "false".
        rationaleVisibleHolder addDependent:self.
    ].
    ^ rationaleVisibleHolder

    "Modified: / 04-08-2011 / 21:39:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 08:50:20 / cg"
!

rationaleVisibleHolder:aValueHolder
    "set the 'rationaleVisibleHolder' value holder (automatically generated)"

    |oldValue newValue|

    rationaleVisibleHolder notNil ifTrue:[
        oldValue := rationaleVisibleHolder value.
        rationaleVisibleHolder removeDependent:self.
    ].
    rationaleVisibleHolder := aValueHolder.
    rationaleVisibleHolder notNil ifTrue:[
        rationaleVisibleHolder addDependent:self.
    ].
    newValue := rationaleVisibleHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:rationaleVisibleHolder.
    ].
!

ruleHolder
    "return/create the 'ruleHolder' value holder (automatically generated)"

    ruleHolder isNil ifTrue:[
        ruleHolder := ValueHolder new.
    ].
    ^ ruleHolder

    "Modified: / 01-03-2012 / 08:51:03 / cg"
!

ruleHolder:aValueHolder
    "set the 'ruleHolder' value holder (automatically generated)"

    |oldValue newValue|

    ruleHolder notNil ifTrue:[
        oldValue := ruleHolder value.
        ruleHolder removeDependent:self.
    ].
    ruleHolder := aValueHolder.
    ruleHolder notNil ifTrue:[
        ruleHolder addDependent:self.
    ].
    newValue := ruleHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:ruleHolder.
    ].

    "Modified: / 01-03-2012 / 15:29:30 / cg"
!

ruleNameAspect
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#ruleNameAspect) isNil ifTrue:[
        holder := BlockValue
                    with:[:h | 
                        "/ h displayString , ' ' , (('[browse]' actionForAll:[ self browseLintRule]) colorizeAllWith:Color blue) 
                        (h ? '') displayString asActionLinkTo:[ self browseLintRule ] 
                    ]
                    argument: self ruleHolder.
        builder aspectAt:#ruleNameAspect put:holder.
    ].
    ^ holder.

    "Modified: / 05-02-2010 / 12:51:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 08:44:23 / cg"
!

ruleRationaleAspect
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#ruleRationaleAspect) isNil ifTrue:[
        "cannot use a BlockValue linked on the ruleHolder for the
         ruleRationaleAspect, because the ruleHolder might be changed dynamically
         via the aspect-linking mechanism"
"/        holder := (AspectAdaptor forAspect: #rationale) subjectChannel: self ruleHolder.
        holder := '' asValue.
        builder aspectAt:#ruleRationaleAspect put:holder.
    ].
    ^ holder.

    "Modified: / 05-02-2010 / 12:51:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 15:29:16 / cg"
!

selectedClassesHolder
    "return/create the 'selectedClassesHolder' value holder (automatically generated)"

    selectedClassesHolder isNil ifTrue:[
        selectedClassesHolder := #() asValue.
        selectedClassesHolder addDependent:self.
    ].
    ^ selectedClassesHolder
!

selectedClassesHolder:aValueHolder
    "set the 'selectedClassesHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedClassesHolder notNil ifTrue:[
        oldValue := selectedClassesHolder value.
        selectedClassesHolder removeDependent:self.
    ].
    selectedClassesHolder := aValueHolder.
    selectedClassesHolder notNil ifTrue:[
        selectedClassesHolder addDependent:self.
    ].
    newValue := selectedClassesHolder value.
    oldValue ~= newValue ifTrue:[
        self update:#value with:newValue from:selectedClassesHolder.
    ].
!

selectedMethodsHolder
    "return/create the 'selectedMethodsHolder' value holder (automatically generated)"

    selectedMethodsHolder isNil ifTrue:[
        selectedMethodsHolder := #() asValue.
        selectedMethodsHolder addDependent:self.
    ].
    ^ selectedMethodsHolder
!

selectedMethodsHolder:aValueHolder
    "set the 'selectedMethodsHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedMethodsHolder notNil ifTrue:[
        oldValue := selectedMethodsHolder value.
        selectedMethodsHolder removeDependent:self.
    ].
    selectedMethodsHolder := aValueHolder.
    selectedMethodsHolder notNil ifTrue:[
        selectedMethodsHolder addDependent:self.
    ].
    newValue := selectedMethodsHolder value.
    oldValue ~= newValue ifTrue:[
        self update:#value with:newValue from:selectedMethodsHolder.
    ].
! !

!LintRuleDetail methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == ruleHolder ifTrue:[
        self updateVisibility.
        self updateRule.
         ^ self.
    ].
    changedObject == rationaleVisibleHolder ifTrue:[
        self updateVisibility.
         ^ self.
    ].
    changedObject == selectedMethodsHolder ifTrue:[
        "/ cg: preparations to show method-specific text in rationale/detail view
        "/ Not yet done...
        self updateRule.
        ^ self 
    ].

    changedObject == selectedClassesHolder ifTrue:[
        "/ cg: preparations to show class-specific text in rationale/detail view
        "/ Not yet done...
        self updateRule.
        ^ self 
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 04-08-2011 / 21:31:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 15:27:38 / cg"
!

updateRule
    "cannot use a BlockValue linked on the ruleHolder for the
     ruleRationaleAspect, because the ruleHolder maight be changed dynamically
     via the aspect-linking mechanism"

    |rule text|

    text := ''.
    
    rule := self ruleHolder value.
    rule notNil ifTrue:[
        selectedMethodsHolder value size == 1 ifTrue:[
            text := rule rationaleWithAnchorForMethod:(selectedMethodsHolder value first).
        ] ifFalse:[    
            selectedClassesHolder value size == 1 ifTrue:[
                text := rule rationaleWithAnchorForClass:(selectedClassesHolder value first).
            ] ifFalse:[    
                text := rule rationaleWithAnchor.
            ]
        ]    
    ].
    self ruleRationaleAspect value:text.

    "Created: / 01-03-2012 / 15:28:18 / cg"
!

updateVisibility

    self ruleHolder value notNil
        ifTrue:[self show]
        ifFalse:[self hide].

    "Created: / 04-08-2011 / 16:39:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2011 / 20:18:48 / cg"
! !

!LintRuleDetail methodsFor:'initialization'!

setupHTMLView:aView
    rationalView := aView.
    rationalView linkActionPerformer:self.
    aView painter
        leftMargin:20;
        topMargin:5.

    "Created: / 04-08-2011 / 18:00:36 / cg"
! !

!LintRuleDetail methodsFor:'private'!

heightWhenNotShowingRationale
    ^ 30

    "Created: / 07-09-2011 / 04:02:34 / cg"
!

heightWhenShowingRationale
    ^ 100

    "Created: / 07-09-2011 / 04:02:24 / cg"
!

hide

    self visibility: false height: 0

    "Created: / 11-03-2010 / 09:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

show
    self 
        visibility: true 
        height: (self rationaleVisibleHolder value 
                    ifTrue:[ self heightWhenShowingRationale ] 
                    ifFalse:[ self heightWhenNotShowingRationale ])

    "Created: / 11-03-2010 / 09:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 04:03:07 / cg"
!

visibility: visibility height: height
    | container list detail h |

"/ cg: the whole conatiner-container access chains below is ugly - use a name to access components.
"/ and also: there is no layout in list, so the code does crash.
"/ I disabled the whole visibility stuff.
^ self.

    (container := self window container) isNil ifTrue:[^self].
    h := visibility ifFalse:[0] ifTrue:[height].

    container isVisible == visibility ifFalse: [
        container isVisible: visibility
    ].

    list := container container subViews first.
    detail := container container subViews second.

    (list layout bottomOffset ~= height negated) ifTrue:[
        list layout: (list layout bottomOffset: height negated; yourself)
    ].
    (detail layout topOffset ~= height negated) ifTrue:[
        detail layout: (detail layout topOffset: height negated; yourself)
    ].

    "Created: / 11-03-2010 / 09:51:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 10:35:51 / cg"
! !

!LintRuleDetail class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

