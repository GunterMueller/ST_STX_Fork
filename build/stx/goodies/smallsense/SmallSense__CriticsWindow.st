"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2015 Claus Gittinger

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

SimpleDialog subclass:#CriticsWindow
	instanceVariableNames:'ruleHolder ruleRationaleAndFixesHTMLHolder rationalView fixer
		entered codeView closeOnLeave'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface'
!

!CriticsWindow class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2015 Claus Gittinger

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

!CriticsWindow class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:SmallSense::CriticsWindow
    "



    ^ super flyByHelpSpec addPairsFrom:#(

#disableRule
'Disable this rule in the future\(for the rest of this session, unless you save the ruleset)'

#browseRule
'Open a browser on the rule'

)
! !

!CriticsWindow class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::CriticsWindow andSelector:#windowSpec
     SmallSense::CriticsWindow new openInterface:#windowSpec
     SmallSense::CriticsWindow open
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
         bounds: (Rectangle 0 0 563 384)
         backgroundColor: (Color 100.0 100.0 75.0)
         forceRecursiveBackgroundOfDefaultBackground: true
       )
       component: 
      (SpecCollection
         collection: (
          (ActionButtonSpec
             label: 'closeIcon'
             name: 'Button4'
             layout: (AlignmentOrigin 0 1 0 0 1 0)
             visibilityChannel: notCloseOnLeave
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: closeRequest
           )
          (HTMLViewSpec
             name: 'Rationale'
             layout: (LayoutFrame 0 0 20 0 0 1 -65 1)
             level: 0
             visibilityChannel: rationaleVisibleHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             miniScrollerHorizontal: true
             miniScrollerVertical: true
             htmlText: ruleRationaleAndFixesHTMLHolder
             postBuildCallback: setupHTMLView:
           )
          (LinkButtonSpec
             label: 'Disable this Rule'
             name: 'Button3'
             layout: (LayoutFrame -1 0 -59 1 -16 1 -30 1)
             activeHelpKey: disableRule
             level: 0
             translateLabel: true
             labelChannel: disableRuleString
             adjust: left
             model: disableLintRule
             keepSpaceForOSXResizeHandleH: true
           )
          (LinkButtonSpec
             name: 'Button1'
             layout: (LayoutFrame 0 0 -29 1 -16 1 0 1)
             activeHelpKey: browseRule
             level: 0
             translateLabel: true
             labelChannel: ruleNameAspect
             adjust: left
             model: browseLintRule
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
! !

!CriticsWindow class methodsFor:'plugIn spec'!

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
      ).

! !

!CriticsWindow methodsFor:'accessing'!

closeOnLeave
    "set if used as a flyBy tooltip, which should close automatically.
     false, if used as a modal dialog, which needs explicit close.
     The default is false."

    ^ closeOnLeave ? false
!

closeOnLeave:aBoolean
    "set this if used as a flyBy tooltip, which should close automatically.
     Leave false, if used as a modal dialog, which needs explicit close.
     The default is false."

    closeOnLeave := aBoolean
!

codeView
    ^ codeView
!

codeView:aCodeView2
    codeView := aCodeView2.
!

notCloseOnLeave:aBoolean
    ^ self closeOnLeave not
!

rule

    ^self ruleHolder value.

    "Created: / 30-01-2012 / 21:45:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rule: anRBLintRule

    ^self ruleHolder value: anRBLintRule

    "Created: / 30-01-2012 / 21:45:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CriticsWindow methodsFor:'actions'!

browseLintRule
    self browseLintRule:self ruleHolder value
!

browseLintRule:rule
    |ruleClass|

    rule isNil ifTrue:[^ self].

    ruleClass := rule class.
    self close.
    SystemBrowser default openInClass:ruleClass selector:#rationale

    "Created: / 07-09-2011 / 04:09:38 / cg"
    "Modified: / 31-01-2012 / 11:30:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

disableLintRule
    |rule|

    rule := self ruleHolder value.
    rule isNil ifTrue:[^ self].

    "/ how do I disable the rule in the current smalllint checker service?
    "/ for now, a hack: keep a global disabledRules collection, and skip rules which are in it

    "/ if multiple rules complained, an anonymous composite rule is created;
    "/ then disable them all
    rule isComposite ifTrue:[
        rule rules do:[:each |
            SmalltalkChecker disableRule:each class.
        ].
    ] ifFalse:[
        SmalltalkChecker disableRule:rule class.
    ].
    self close.
!

doQuickFix: quickFixNo
    self closeDownViews.
    "/ cg: why fork here?
    "[" fixer performFix: quickFixNo "] fork".

    "Created: / 16-02-2012 / 14:19:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CriticsWindow methodsFor:'aspects'!

closeIcon
    ^ ToolbarIconLibrary removeTab16x16Icon
!

disableRuleString


    ^ ('Disable this Rule'
        colorizeAllWith: Color blue)
        actionForAll:[ self disableLintRule]
!

ruleHolder
    "return/create the 'ruleHolder' value holder (automatically generated)"

    ruleHolder isNil ifTrue:[
        ruleHolder := ValueHolder with: (RBDebuggingCodeLeftInMethodsRule new)
    ].
    ^ ruleHolder

    "Modified: / 30-01-2012 / 21:43:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

ruleNameAspect


    |holder|

    (holder := builder bindingAt:#ruleNameAspect) isNil ifTrue:[
        holder := BlockValue
                    with:[:h |
                        |text rules|

                        text := ''.
                        rules := h isComposite ifTrue:[ h rules ] ifFalse:[ { h } ].
                        rules 
                            do:[:each |
                                |anchor|

                                "/ h displayString , ' ' , (('[browse]' actionForAll:[ self browseLintRule]) colorizeAllWith:Color blue)
                                anchor :=
                                        (('Browse Rule Class (',each class name,')' "displayString")
                                            colorizeAllWith: Color blue)
                                                actionForAll:[ self browseLintRule:each ].
                                text := text , anchor.
                            ]
                            separatedBy:[
                                text := text , '<br>'
                            ].
                        text.
                    ]
                    argument: self ruleHolder.
        builder aspectAt:#ruleNameAspect put:holder.
    ].
    ^ holder.

    "Modified: / 05-02-2010 / 12:51:30 / Jan Vrany "
    "Modified: / 07-09-2011 / 04:54:24 / cg"
!

ruleRationaleAndFixesHTMLHolder
    "return/create the 'ruleRationaleAndFixesHTMLHolder' value holder (automatically generated)"

    ruleRationaleAndFixesHTMLHolder isNil ifTrue:[
        ruleRationaleAndFixesHTMLHolder := ValueHolder new.
    ].
    ^ ruleRationaleAndFixesHTMLHolder

    "Modified (format): / 01-02-2012 / 10:57:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CriticsWindow methodsFor:'change & update'!

generateHTMLForRule: rule on: stream
    | fixes |    
     stream 
        nextPutAll: rule name; 
        nextPutAll:'<P>';  
        nextPutLine: rule rationale.

    "/ Generate fixes...
    rule fixes: fixer.
    fixes := fixer fixesForRule: rule.
    fixes isEmptyOrNil ifTrue:[ ^ self ].

    stream nextPutAll: '<p>'.
    fixes size > 1 ifTrue:[
        stream nextPutAll: '<br>'.
        stream nextPutLine: 'Possible fixes:'.
    ].
    stream nextPutLine:'<ul indent="0">'.
    fixes withIndexDo:[:fix :index|
        stream
            nextPutAll:'<li><a action="doit: linkActionPerformer doQuickFix:';
            nextPutAll: index printString;
            nextPutAll:'">';
            nextPutAll: fix label;
            nextPutAll:'</a></li>'.
    ].
    stream nextPutLine:'</ul>'.

    "Created: / 15-12-2014 / 16:49:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 18:17:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == ruleHolder ifTrue:[
         self updateRationaleAndFixes.
         ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 01-02-2012 / 10:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateRationaleAndFixes
    | rule html |

    rule := self ruleHolder value.
    rule isNil ifTrue:[
        fixer := nil.
        html :=  'No rule...'.
    ] ifFalse:[
        fixer := SmalltalkQuickFixer forView: codeView.

        html := String streamContents:[:s|
            rule isComposite ifFalse:[ 
                self generateHTMLForRule: rule on: s.
            ] ifTrue:[ 
                rule flatten 
                    do:[:each | self generateHTMLForRule: each on: s. ]
                    separatedBy:[ s nextPutLine: '<hr>' ]
            ]
        ].
    ].

    self ruleRationaleAndFixesHTMLHolder value: html

    "Created: / 01-02-2012 / 10:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 18:18:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CriticsWindow methodsFor:'event processing'!

processEvent: anEvent

    anEvent isKeyReleaseEvent ifTrue:[
        anEvent key == #Escape ifTrue:[
            self closeRequest. "/ closeDownViews.
            ^true.
        ].
    ].

    "/ cg: if this is a modal dialog - do not exit on leave.
    "/ if used as a flyBy, set the closeOnLeave flag.
    self closeOnLeave ifTrue:[
        anEvent isPointerLeaveEvent ifTrue:[
            anEvent view == self window ifTrue:[
                self closeRequest. "/ closeDownViews.
                ^true.
            ]
        ].
    ].

    ^false

    "Created: / 16-02-2012 / 14:09:33 / Jan Vrany "
    "Modified (format): / 31-03-2014 / 16:53:41 / Jan Vrany "
! !

!CriticsWindow methodsFor:'hooks'!

postBuildWith: aBuilder
    super postBuildWith:aBuilder.

    aBuilder window allViewBackground:(aBuilder window viewBackground).

    entered := false.
    self updateRationaleAndFixes.
    aBuilder window beSlave.

    "Created: / 03-04-2011 / 10:45:10 / Jan Vrany "
    "Modified: / 16-02-2012 / 14:14:07 / Jan Vrany "
!

postOpenWith: bldr
    super postOpenWith: bldr.
    self windowGroup addPreEventHook: self.

    "Created: / 16-02-2012 / 14:09:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CriticsWindow methodsFor:'initialization'!

setupHTMLView:aView
    rationalView := aView.
    rationalView linkActionPerformer:self.
    aView painter
        leftMargin:20;
        topMargin:5.

    "Created: / 04-08-2011 / 18:00:36 / cg"
! !

!CriticsWindow class methodsFor:'documentation'!

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

