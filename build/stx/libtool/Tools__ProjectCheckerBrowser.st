"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2006 by eXept Software AG
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

ApplicationModel subclass:#ProjectCheckerBrowser
	instanceVariableNames:'projectCheckerHolder problemSelectionHolder problemListHolder
		infoPanel accepted showCancel'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Projects'
!

!ProjectCheckerBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    A simple tool to browse issues found by ProjectChecker.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        ProjectChecker

"
! !

!ProjectCheckerBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectCheckerBrowser andSelector:#windowSpec
     Tools::ProjectCheckerBrowser new openInterface:#windowSpec
     Tools::ProjectCheckerBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Package Issues'
          name: 'Package Issues'
          bounds: (Rectangle 0 0 581 467)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableVerticalPanelSpec
              name: 'VariableVerticalPanel1'
              layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
              component: 
             (SpecCollection
                collection: (
                 (ViewSpec
                    name: 'ListPanel'
                    component: 
                   (SpecCollection
                      collection: (
                       (SubCanvasSpec
                          name: 'InfoPanel'
                          layout: (LayoutFrame 0 0 0 0 0 1 40 0)
                          level: 0
                          initiallyInvisible: true
                          hasHorizontalScrollBar: false
                          hasVerticalScrollBar: false
                          clientKey: infoPanel
                          createNewBuilder: false
                        )
                       (SelectionInListModelViewSpec
                          name: 'List'
                          layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                          model: problemSelectionHolder
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          listModel: problemListHolder
                          useIndex: false
                          highlightMode: line
                        )
                       )
                     
                    )
                  )
                 (ViewSpec
                    name: 'Detail'
                    component: 
                   (SpecCollection
                      collection: (
                       (HTMLViewSpec
                          name: 'Description'
                          layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                          level: 0
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          htmlText: problemDescriptionTextHolder
                          postBuildCallback: setupHTMLView:
                        )
                       )
                     
                    )
                  )
                 )
               
              )
              handles: (Any 0.421052631578947 1.0)
            )
           (HorizontalPanelViewSpec
              name: 'ButtonPanel'
              layout: (LayoutFrame 0 0 -30 1 -16 1 0 1)
              horizontalLayout: fit
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Check Again'
                    name: 'CheckAgain'
                    translateLabel: true
                    model: doCheckAgain
                    extent: (Point 139 22)
                  )
                 (ActionButtonSpec
                    label: 'Close'
                    name: 'CloseButton'
                    visibilityChannel: doNotShowCancel
                    translateLabel: true
                    model: doClose
                    extent: (Point 139 22)
                  )
                 (ActionButtonSpec
                    label: 'Done'
                    name: 'Button1'
                    visibilityChannel: showCancel
                    translateLabel: true
                    model: doClose
                    extent: (Point 139 22)
                  )
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button2'
                    visibilityChannel: showCancel
                    translateLabel: true
                    model: doCancel
                    extent: (Point 139 22)
                  )
                 )
               
              )
              keepSpaceForOSXResizeHandleH: true
            )
           )
         
        )
      )
! !

!ProjectCheckerBrowser methodsFor:'accessing'!

accepted
    ^  accepted ? true
!

doNotShowCancel
    ^ self showCancel not
!

problemList: problems

    self problemListHolder value: problems

    "Created: / 13-02-2012 / 17:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

projectChecker

    ^self projectCheckerHolder value

    "Created: / 13-02-2012 / 17:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

projectChecker: value

    self projectCheckerHolder value: value

    "Created: / 13-02-2012 / 17:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showCancel
    ^ showCancel ? false
!

showCancel:something
    showCancel := something.
! !

!ProjectCheckerBrowser methodsFor:'actions'!

doCancel
    <resource: #uiCallback>

    accepted := false.
    AbortSignal raiseRequest
!

doCheckAgain
    <resource: #uiCallback>

    self infoPanel showProgressLabeled: (resources string: 'Checking...') while:[
        | checker |

        checker := self projectChecker.
        checker check.
        self problemListHolder value: checker problems.
        checker problems isEmptyOrNil ifTrue:[
            self infoPanel
                reset;
                showMessage: (resources string: 'Excellent, no problems found!!');
                addButtonWithLabel:(resources string:'Close') action:[self doClose]

        ]
    ]

    "Modified: / 26-07-2012 / 10:50:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doClose
    <resource: #uiCallback>

    self closeRequest

    "Modified: / 25-07-2012 / 17:47:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFix: index
    <resource: #uiCallback>

    [ 
        self problemSelectionHolder value doFix: index
    ] on: UserNotification do:[:not|
        self infoPanel showMessage: not description.
    ].
    (self builder componentAt:'List') invalidate.

    "Created: / 26-07-2012 / 10:06:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectCheckerBrowser methodsFor:'aspects'!

infoPanel
    infoPanel isNil ifTrue:[
        infoPanel := InlineMessageDialog new
    ].
    ^ infoPanel

    "Created: / 09-02-2012 / 19:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoText
    ^ resources string:'Select a problem in the above list to get detail information and a hint for repair'.
!

problemDescriptionAspect
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#problemDescriptionAspect) isNil ifTrue:[
        holder :=  (AspectAdaptor forAspect: #descriptionAndFixes)
                        subjectChannel: self problemSelectionHolder.
        builder aspectAt:#problemDescriptionAspect put:holder.
    ].
    ^ holder.

    "Modified: / 26-07-2012 / 09:44:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

problemDescriptionTextHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#problemDescriptionTextHolder) isNil ifTrue:[
        holder := ValueHolder with:(self infoText).
        builder aspectAt:#problemDescriptionTextHolder put:holder.
    ].
    ^ holder.
!

problemListHolder
    <resource: #uiAspect>

    problemListHolder isNil ifTrue:[
        problemListHolder := ValueHolder new.
    ].
    ^ problemListHolder.

    "Modified: / 13-02-2012 / 18:47:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

problemSelectionHolder
    <resource: #uiAspect>

    problemSelectionHolder isNil ifTrue:[
        problemSelectionHolder := ValueHolder new.
        problemSelectionHolder onChangeSend:#problemSelectionChanged to:self.
    ].
    ^ problemSelectionHolder.
!

projectCheckerHolder
    "return/create the 'projectCheckerHolder' value holder (automatically generated)"

    projectCheckerHolder isNil ifTrue:[
        projectCheckerHolder := ValueHolder new.
        projectCheckerHolder addDependent:self.
    ].
    ^ projectCheckerHolder
!

projectCheckerHolder:something
    "set the 'projectCheckerHolder' value holder (automatically generated)"

    |oldValue newValue|

    projectCheckerHolder notNil ifTrue:[
        oldValue := projectCheckerHolder value.
        projectCheckerHolder removeDependent:self.
    ].
    projectCheckerHolder := something.
    projectCheckerHolder notNil ifTrue:[
        projectCheckerHolder addDependent:self.
    ].
    newValue := projectCheckerHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:projectCheckerHolder.
    ].
! !

!ProjectCheckerBrowser methodsFor:'change & update'!

problemSelectionChanged
    self problemDescriptionTextHolder value:
        (self problemSelectionHolder value notNil 
            ifTrue:[self problemDescriptionAspect value]
            ifFalse:[self infoText])
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == projectCheckerHolder ifTrue:[
         self updateFromProjectCheckerHolder.
         ^ self.
    ].
    super update:something with:aParameter from:changedObject
!

updateFromProjectCheckerHolder

    self problemListHolder value: self projectChecker problems.

    "Modified: / 25-07-2012 / 18:01:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectCheckerBrowser methodsFor:'hooks'!

setupHTMLView:aView
    aView linkActionPerformer:self.
    aView painter
        leftMargin:20;
        topMargin:5.

    "Created: / 23-02-2012 / 14:04:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectCheckerBrowser class methodsFor:'documentation'!

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

