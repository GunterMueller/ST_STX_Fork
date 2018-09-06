"{ Encoding: utf8 }"

"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#JavaLintPopupWindow
	instanceVariableNames:'rationalView fixer entered codeView problem
		problemDescriptionAndFixesHTMLHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Editor-Lint'
!


!JavaLintPopupWindow class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:JavaCompilerProblemPopup andSelector:#windowSpec
     JavaCompilerProblemPopup new openInterface:#windowSpec
     JavaCompilerProblemPopup open
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
         bounds: (Rectangle 0 0 396 109)
         forceRecursiveBackgroundOfDefaultBackground: true
       )
       component: 
      (SpecCollection
         collection: (
          (ActionButtonSpec
             label: 'X'
             name: 'Button2'
             layout: (LayoutFrame -30 1 0 0 0 1 30 0)
             level: 0
             hasCharacterOrientedLabel: false
             translateLabel: true
             labelChannel: closeIcon
             model: closeRequest
           )
          (HTMLViewSpec
             name: 'Rationale'
             layout: (LayoutFrame 0 0 28 0 0 1 0 1)
             level: 0
             visibilityChannel: rationaleVisibleHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             htmlText: problemDescriptionAndFixesHTMLHolder
             postBuildCallback: setupHTMLView:
           )
          )
        
       )
     )

    "Modified: / 06-08-2013 / 23:58:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintPopupWindow methodsFor:'accessing'!

codeView
    ^ codeView
!

codeView:aCodeView2
    codeView := aCodeView2.
!

problem
    ^ problem
!

problem:anIProblem
    problem := anIProblem.
    self problemDescriptionAndFixesHTMLHolder value:
        (problem getMessage)

    "Modified: / 06-08-2013 / 23:52:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintPopupWindow methodsFor:'actions'!

doQuickFix: quickFixNo

    self closeDownViews.
    [ fixer performFix: quickFixNo ] fork.

    "Created: / 16-02-2012 / 14:19:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintPopupWindow methodsFor:'aspects'!

closeIcon
    <resource: #uiAspect>
    ^ ToolbarIconLibrary removeTab16x16Icon

    "Modified: / 06-08-2013 / 23:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

problemDescriptionAndFixesHTMLHolder
    "return/create the 'ruleRationaleAndFixesHTMLHolder' value holder (automatically generated)"

    problemDescriptionAndFixesHTMLHolder isNil ifTrue:[
        problemDescriptionAndFixesHTMLHolder := ValueHolder new.
    ].
    ^ problemDescriptionAndFixesHTMLHolder

    "Created: / 06-08-2013 / 23:50:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintPopupWindow methodsFor:'event processing'!

processEvent: anEvent

"/    entered ifFalse:[
"/        anEvent isPointerLeaveEvent ifTrue:[
"/            anEvent view == self window ifTrue:[
"/                entered := true.
"/            ]
"/        ]
"/    ] ifTrue:[
        anEvent isPointerLeaveEvent ifTrue:[
            anEvent view == self window ifTrue:[
                self closeDownViews.
                ^true.
            ]
        ].
"/    ].

    ^false

    "Created: / 16-02-2012 / 14:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintPopupWindow methodsFor:'hooks'!

postBuildWith: bldr
    | bg fg setbg |

    entered := false.

    bg := View styleSheet colorAt:#'activeHelp.backgroundColor' default:nil.
    fg := bg contrastingBlackOrWhite.
    setbg := [:view|
        view backgroundColor: bg.
        view foregroundColor: fg.
        view subViews do: setbg.
    ].
    rationalView style textFGColor: fg.
    setbg value: bldr window.
    bldr window 
        "windowGroup: codeView windowGroup;"
        bePopUpView; 
        beSlave.

    "Created: / 03-04-2011 / 10:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2013 / 00:13:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postOpenWith: bldr

    self windowGroup addPreEventHook: self.

    "Created: / 16-02-2012 / 14:09:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintPopupWindow methodsFor:'initialization'!

setupHTMLView:aView
    rationalView := aView.
    rationalView linkActionPerformer:self.
    aView painter
        leftMargin:20;
        topMargin:0.

    "Created: / 04-08-2011 / 18:00:36 / cg"
    "Modified: / 07-08-2013 / 00:14:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintPopupWindow class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

