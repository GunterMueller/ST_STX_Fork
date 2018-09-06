"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

SimpleDialog subclass:#AbstractDIalog
	instanceVariableNames:'titleHolder buttons buttonsPanelView acceptEnabledHolder
		optionsVisibleLabelHolder optionsVisibleHolder optionsPanelView'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!AbstractDIalog class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!AbstractDIalog class methodsFor:'interface specs'!

dialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::AbstractDIalog andSelector:#dialogSpec
     SmallSense::AbstractDIalog new openInterface:#dialogSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: dialogSpec
       window: 
      (WindowSpec
         label: 'Search...'
         name: 'Search...'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 708 404)
         menu: mainMenuSpec
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Layput'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'Content'
                   layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                   minorKey: contentPaneSpec
                 )
                (UISubSpecification
                   name: 'Options'
                   layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
                   visibilityChannel: optionsVisibleHolder
                   minorKey: optionsPaneSpec
                   postBuildCallback: postBuildOptionsPanelView:
                 )
                )
              
             )
           )
          )
        
       )
     )

    "Modified: / 03-05-2014 / 00:49:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::AbstractDIalog andSelector:#windowSpec
     SmallSense::AbstractDIalog new openInterface:#windowSpec
     SmallSense::AbstractDIalog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Search...'
         name: 'Search...'
         labelChannel: titleHolder
         min: (Point 10 10)
         bounds: (Rectangle 0 0 708 404)
         menu: mainMenuSpec
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'ContentPane'
             layout: (LayoutFrame 10 0 0 0 -10 1 -40 1)
             minorKey: dialogSpec
           )
          (UISubSpecification
             name: 'ButtonsPane'
             layout: (LayoutFrame 10 0 -40 1 -10 1 0 1)
             minorKey: buttonsPaneSpec
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
! !

!AbstractDIalog class methodsFor:'interface specs-content'!

buttonsPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::AbstractDIalog andSelector:#buttonsPaneSpec
     SmallSense::AbstractDIalog new openInterface:#buttonsPaneSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: buttonsPaneSpec
       window: 
      (WindowSpec
         label: 'Search...'
         name: 'Search...'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 708 38)
         menu: mainMenuSpec
       )
       component: 
      (SpecCollection
         collection: (
          (HorizontalPanelViewSpec
             name: 'Buttons'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: okCancelBox
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             postBuildCallback: postBuildButtonsPanelView:
           )
          )
        
       )
     )
!

contentPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::AbstractSearchDialog andSelector:#optionsPaneSpec
     SmallSense::AbstractSearchDialog new openInterface:#optionsPaneSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: contentPaneSpec
       window: 
      (WindowSpec
         label: 'Search ...'
         name: 'Search Options...'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 634 40)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'No content (override #contentPaneSpec)'
             name: 'NoOptionsLabel'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             translateLabel: true
           )
          )
        
       )
     )

    "Created: / 02-05-2014 / 00:17:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

optionsPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::AbstractSearchDialog andSelector:#optionsPaneSpec
     SmallSense::AbstractSearchDialog new openInterface:#optionsPaneSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: optionsPaneSpec
       window: 
      (WindowSpec
         label: 'Search Options...'
         name: 'Search Options...'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 634 40)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'No options (override #optionsPaneSpec)'
             name: 'NoOptionsLabel'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             translateLabel: true
           )
          )
        
       )
     )
!

optionsShowHideLeftAlignedPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::AbstractDIalog andSelector:#optionsShowHideLeftAlignedPaneSpec
     SmallSense::AbstractDIalog new openInterface:#optionsShowHideLeftAlignedPaneSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: optionsShowHideLeftAlignedPaneSpec
       window: 
      (WindowSpec
         label: 'Show / Hide options'
         name: 'Show / Hide options'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 452 20)
       )
       component: 
      (SpecCollection
         collection: (
          (LinkButtonSpec
             label: 'Options'
             name: 'ShowHideOptions'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             translateLabel: true
             labelChannel: optionsVisibleLabelHolder
             adjust: left
             model: doOptionsShowOrHide
           )
          )
        
       )
     )
!

optionsShowHideRightAlignedPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::AbstractDIalog andSelector:#optionsShowHideLeftAlignedPaneSpec
     SmallSense::AbstractDIalog new openInterface:#optionsShowHideLeftAlignedPaneSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: optionsShowHideLeftAlignedPaneSpec
       window: 
      (WindowSpec
         label: 'Show / Hide options'
         name: 'Show / Hide options'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 452 20)
       )
       component: 
      (SpecCollection
         collection: (
          (LinkButtonSpec
             label: 'Options'
             name: 'ShowHideOptions'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             translateLabel: true
             labelChannel: optionsVisibleLabelHolder
             adjust: right
             model: doOptionsShowOrHide
           )
          )
        
       )
     )

    "Created: / 03-05-2014 / 00:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractDIalog class methodsFor:'testing'!

isAbstract
    ^ self == SmallSense::AbstractDIalog
! !

!AbstractDIalog methodsFor:'accessing-defaults'!

defaultTitle
    ^ self subclassResponsibility

    "Created: / 05-05-2014 / 23:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractDIalog methodsFor:'actions'!

doOptionsShowOrHide
    | optionsView optionsViewHeight otherView otherViewIsBelow layout |

    optionsView := optionsPanelView.
    optionsView superView subViews last == optionsView ifTrue:[ 
        otherView := optionsView superView subViews before: optionsView.
        otherViewIsBelow := false.
    ] ifFalse:[
        otherView := optionsView superView subViews after: optionsView.
        otherViewIsBelow := true.
    ].
    self optionsVisibleHolder value ifFalse:[ 
        "/ Show
        self optionsVisibleHolder value: true.
        optionsViewHeight := ((self class optionsPaneSpec at: 5) at: 9) at: 5.
        otherViewIsBelow ifFalse:[
            layout := otherView layout copy.
            layout bottomOffset: (layout bottomOffset - optionsViewHeight).  
            otherView  layout: layout.

            layout := optionsView layout copy.
            layout topOffset: (layout topOffset - optionsViewHeight).  
            optionsView  layout: layout.
        ] ifTrue:[ 
            layout := optionsView layout copy.
            layout bottomOffset: (layout bottomOffset + optionsViewHeight).  
            optionsView  layout: layout.

            layout := otherView layout copy.
            layout topOffset: (layout topOffset + optionsViewHeight).  
            otherView  layout: layout.
        ].
    ] ifTrue:[ 
        "/ Hide
        self optionsVisibleHolder value: false. 
        optionsViewHeight := ((self class optionsPaneSpec at: 5) at: 9) at: 5.
        otherViewIsBelow ifFalse:[
            layout := otherView layout copy.
            layout bottomOffset: (layout bottomOffset + optionsViewHeight).  
            otherView  layout: layout.

            layout := optionsView layout copy.
            layout topOffset: (layout topOffset + optionsViewHeight).  
            optionsView  layout: layout.
        ] ifTrue:[ 
            layout := optionsView layout copy.
            layout bottomOffset: (layout bottomOffset - optionsViewHeight).  
            optionsView  layout: layout.

            layout := otherView layout copy.
            layout topOffset: (layout topOffset - optionsViewHeight).  
            otherView  layout: layout.
        ].                                                                    
    ].

    "Modified: / 03-05-2014 / 00:27:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractDIalog methodsFor:'adding & removing components'!

addButton: aButton
    buttons add: aButton.
    buttonsPanelView notNil ifTrue:[ 
        buttonsPanelView addComponent: aButton.
    ].

    "Created: / 10-04-2012 / 20:49:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-04-2014 / 22:52:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addButtonAccept

    ^self addButtonAcceptWithLabel: (resources string:'OK')

    "Created: / 28-04-2014 / 22:51:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-01-2015 / 07:00:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addButtonAcceptWithLabel: label

    ^self addButtonWithLabel: label action: [ self doAccept ] enablement: self acceptEnabledHolder.

    "Created: / 29-01-2015 / 06:59:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addButtonCancel

    ^self addButtonCancelWithLabel: (resources string:'Cancel')

    "Created: / 28-04-2014 / 22:50:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-01-2015 / 07:00:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addButtonCancelWithLabel: label

    ^self addButtonWithLabel: label action: [ self doCancel ]

    "Created: / 29-01-2015 / 07:00:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addButtonWithLabel: label action: action
    ^self addButtonWithLabel: label action: action enablement: true.

    "Created: / 10-04-2012 / 20:50:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-04-2014 / 22:55:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addButtonWithLabel: label action: action enablement: enablement
    | button |

    button := Button label: label action: action.
    button enableChannel: enablement.
    ^self addButton: button.

    "Created: / 28-04-2014 / 22:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractDIalog methodsFor:'aspects'!

acceptEnabledHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    acceptEnabledHolder isNil ifTrue:[
        acceptEnabledHolder := true asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       acceptEnabledHolder addDependent:self.
"/       acceptEnabledHolder onChangeSend:#acceptEnabledHolderChanged to:self.
    ].
    ^ acceptEnabledHolder.
!

optionsVisibleHolder
    "return/create the 'optionsVisibleHolder' value holder (automatically generated)"

    optionsVisibleHolder isNil ifTrue:[
        optionsVisibleHolder := false asValue.
        optionsVisibleHolder addDependent:self.
    ].
    ^ optionsVisibleHolder

    "Modified: / 02-05-2014 / 00:26:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

optionsVisibleHolder:something
    "set the 'optionsVisibleHolder' value holder (automatically generated)"

    |oldValue newValue|

    optionsVisibleHolder notNil ifTrue:[
        oldValue := optionsVisibleHolder value.
        optionsVisibleHolder removeDependent:self.
    ].
    optionsVisibleHolder := something.
    optionsVisibleHolder notNil ifTrue:[
        optionsVisibleHolder addDependent:self.
    ].
    newValue := optionsVisibleHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:optionsVisibleHolder.
    ].
!

optionsVisibleLabelHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    optionsVisibleLabelHolder isNil ifTrue:[
        optionsVisibleLabelHolder := (resources string: 'Options') asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       optionsVisibleLabelHolder addDependent:self.
"/       optionsVisibleLabelHolder onChangeSend:#optionsVisibleLabelHolderChanged to:self.
    ].
    ^ optionsVisibleLabelHolder.

    "Modified: / 02-05-2014 / 00:25:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

titleHolder
    "return/create the 'titleHolder' value holder (automatically generated)"

    titleHolder isNil ifTrue:[
        titleHolder := self defaultTitle asValue.
        titleHolder addDependent:self.
    ].
    ^ titleHolder

    "Modified: / 05-05-2014 / 23:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

titleHolder:something
    "set the 'titleHolder' value holder (automatically generated)"

    |oldValue newValue|

    titleHolder notNil ifTrue:[
        oldValue := titleHolder value.
        titleHolder removeDependent:self.
    ].
    titleHolder := something.
    titleHolder notNil ifTrue:[
        titleHolder addDependent:self.
    ].
    newValue := titleHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:titleHolder.
    ].
! !

!AbstractDIalog methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == optionsVisibleHolder ifTrue:[
        self updateOptionsVisibleLabel.
        ^ self.
    ].     
    ^ super update:something with:aParameter from:changedObject

    "Created: / 02-05-2014 / 00:29:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateOptionsVisibleLabel
    | label |

    label := 
        self optionsVisibleHolder value 
            ifTrue:[ resources string: 'Hide options']
            ifFalse:[ resources string: 'Options'].
    label := label asText colorizeAllWith: Color blue.
    self optionsVisibleLabelHolder value: label.

    "Created: / 02-05-2014 / 00:29:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2014 / 23:56:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractDIalog methodsFor:'hooks'!

postBuildButtonsPanelView: aHorizontalPanelView
    buttonsPanelView := aHorizontalPanelView.

    "Created: / 28-04-2014 / 22:42:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildOptionsPanelView:aView
    optionsPanelView := aView

    "Modified: / 03-05-2014 / 00:00:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildWith: anUIBuilder
    | w |

    super postBuildWith: anUIBuilder.
    self updateOptionsVisibleLabel.

    buttons isEmpty ifTrue:[ 
        | savedButtonsPanelView |

        savedButtonsPanelView := buttonsPanelView.
        buttonsPanelView := nil.                  
        self addButtonCancel.    
        self addButtonAccept.   
        buttonsPanelView := savedButtonsPanelView.
    ].

    w := buttons inject: 0 into: [ :width :button | width max: (button preferredExtent x) ].
    w := (w + 20) max: 100.
    buttons do:[:button | 
        button preferredExtent: w @ 25.
        buttonsPanelView addComponent: button.  
    ].

    "Created: / 28-04-2014 / 22:53:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-01-2015 / 07:10:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractDIalog methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    buttons := OrderedCollection new.
    "/ buttonsPanelView := nil.

    super initialize.

    "Modified: / 28-04-2014 / 22:49:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractDIalog class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

