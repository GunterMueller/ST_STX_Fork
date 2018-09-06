"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

ApplicationModel subclass:#WorkspaceUI
	instanceVariableNames:'statusBar currentQueryResultId variablePanel shouldResize
		documentProvider relativeCorners workspaceView interpreter
		evaluateQueryBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-UI'
!


!WorkspaceUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:XQuery::WorkspaceUI andSelector:#windowSpec
     XQuery::WorkspaceUI new openInterface:#windowSpec
     XQuery::WorkspaceUI open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'XQuery Workspace'
          name: 'XQuery Workspace'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 488 220)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableVerticalPanelSpec
              name: 'WorkspaceAndResultPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              showHandle: true
              snapMode: both
              handlePosition: left
              component: 
             (SpecCollection
                collection: (
                 (ArbitraryComponentSpec
                    name: 'WorkspaceView'
                    hasBorder: false
                    component: workspaceScrollableView
                  )
                 (NoteBookViewSpec
                    name: 'ResultNotebook'
                    model: selectedResultIndexAspect
                    menu: queryResultNameListAspect
                    useIndex: true
                    fitLastRow: false
                    destroyTabAction: removeResultWithIndex:
                    canvas: selectedDOMInspectorAspect
                  )
                 )
               
              )
              handles: (Any 0.99 1.0)
              postBuildCallback: postBuildVariablePanel:
            )
           )
         
        )
      )

    "Modified: / 12-04-2007 / 13:24:20 / janfrog"
! !

!WorkspaceUI methodsFor:'* As yet uncategorized *'!

destroy

    "nothing to do"

    "Created: / 19-04-2010 / 12:41:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspaceUI methodsFor:'accessing'!

documentProvider

    documentProvider ifNil:[documentProvider := XQuery::DefaultXDMAdaptorProvider default].
    ^ documentProvider

    "Created: / 15-12-2006 / 07:47:01 / janfrog"
    "Modified: / 28-01-2010 / 11:32:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

documentProvider:anXPathDocumentProvider
    documentProvider := anXPathDocumentProvider.

    "Created: / 15-12-2006 / 07:47:01 / janfrog"
!

evaluateQueryBlock
    evaluateQueryBlock ifNil:[
        evaluateQueryBlock := [:query|self interpreter
                                        setDocumentProvider: self documentProvider;
                                        evaluate: query]].
    ^evaluateQueryBlock

    "Created: / 17-10-2007 / 13:28:49 / janfrog"
!

evaluateQueryBlock:something
    evaluateQueryBlock := something.

    "Created: / 17-10-2007 / 13:28:49 / janfrog"
!

interpreter
    interpreter ifNil:[
        interpreter := XQueryInterpreter new.
        interpreter openPerseusDebuggerOnError:false.        
    ].
    ^interpreter.

    "Created: / 29-08-2007 / 09:47:27 / janfrog"
    "Modified: / 18-09-2008 / 18:05:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

interpreter:something
    interpreter := something.

    "Created: / 29-08-2007 / 09:45:44 / janfrog"
!

nextQueryResultId

    ^currentQueryResultId := currentQueryResultId + 1

    "Created: / 12-12-2006 / 13:28:00 / janfrog"
!

queryResultList

    ^self queryResultListAspect value

    "Created: / 12-12-2006 / 13:28:32 / janfrog"
!

queryResultNameList

    ^self queryResultNameListAspect value

    "Created: / 12-12-2006 / 13:29:02 / janfrog"
!

resultViewShown

    variablePanel ifNil:[^false].

    ^ (variablePanel relativeCorners) asArray ~= #( 0.99 1.0 )

    "Created: / 10-02-2007 / 11:47:25 / janfrog"
!

resultViewShown: aBoolean

    aBoolean 
        ifTrue:[self showResultView]
        ifFalse:[self hideResultView]

    "Created: / 10-02-2007 / 11:47:13 / janfrog"
!

statusBar

    ^(self masterApplication respondsTo:#statusBar)
        ifTrue:[self masterApplication statusBar]
        ifFalse:[statusBar ifNil:[statusBar := StatusBarUI new]]

    "Created: / 12-12-2006 / 12:16:51 / janfrog"
! !

!WorkspaceUI methodsFor:'accessing - views'!

workspaceScrollableView


    ^HVScrollableView new 
        scrolledView:self workspaceView;
        yourself

    "Created: / 12-04-2007 / 13:24:03 / janfrog"
!

workspaceView

    ^workspaceView ifNil:
        [workspaceView := XQuery::Workspace new
                                    workspaceUI: self;
                                    interpreter: self interpreter;
                                    doItAction:self evaluateQueryBlock;
                                    documentProvider: self documentProvider].

    "Created: / 12-12-2006 / 12:30:59 / janfrog"
    "Modified: / 17-10-2007 / 13:30:07 / janfrog"
    "Modified: / 18-09-2008 / 18:05:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WorkspaceUI methodsFor:'actions'!

hideResultView
    relativeCorners := variablePanel relativeCorners.

    variablePanel
        relativeCorners:#( 0.99 1.0 );
        resizeSubviews

    "Created: / 10-02-2007 / 11:39:10 / janfrog"
!

showResultView
    variablePanel
        relativeCorners:relativeCorners;
        resizeSubviews

    "Created: / 10-02-2007 / 11:38:26 / janfrog"
! !

!WorkspaceUI methodsFor:'adding & removing results'!

addResult:anXQueryResult 
    |wasFirst|

    anXQueryResult ifNil:[^self].

    wasFirst := self queryResultList size isZero.
    self queryResultNameListAspect 
        add:('Result ' , self nextQueryResultId printString , ' [' 
                , Time now printString , ']').
    self queryResultListAspect    
        add:(XMLv2::DOM3Inspector on:anXQueryResult asDocumentFragment).
    self selectedResultIndexAspect value:(self queryResultListAspect size).
    wasFirst ifTrue:[
        self showResultView
         "self masterApplication ifNotNil:
         [self window extent:(self window extent x)@(self window extent y * 2)]."
    ]

    "Created: / 12-12-2006 / 13:24:52 / janfrog"
    "Modified: / 10-02-2007 / 11:38:26 / janfrog"
    "Modified: / 02-12-2008 / 13:19:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

removeResultWithIndex:idx 
    |newIndex size|

    size := self queryResultListAspect size.
    size == 0 ifTrue:[
        ^ self
    ].
    newIndex := size == 1 ifTrue:[
                nil
            ] ifFalse:[
                idx == size ifTrue:[
                    idx - 1
                ] ifFalse:[ idx ]
            ].
    self selectedResultIndexAspect value:newIndex.
    self queryResultListAspect size >= idx ifTrue:
        [self queryResultListAspect removeIndex:idx].
    self queryResultNameListAspect size >= idx ifTrue:
        [self queryResultNameListAspect removeIndex:idx].
    self queryResultList size isZero ifTrue:[
        self hideResultView
    ]

    "Created: / 14-12-2006 / 20:18:05 / janfrog"
    "Modified: / 10-02-2007 / 11:39:10 / janfrog"
    "Modified: / 20-04-2010 / 20:05:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedDOMInspectorAspect

    ^SubCanvas new
              clientHolder:((PluggableAdaptor on:self selectedResultIndexAspect)
                getter:[:m|m value 
                        ifNil:[nil]
                        ifNotNil:[
                            m value isZero
                                ifTrue:[nil]
                                ifFalse:[self queryResultList at:m value]]])

    "Created: / 12-12-2006 / 13:35:29 / janfrog"
    "Modified: / 14-12-2006 / 20:38:34 / janfrog"
! !

!WorkspaceUI methodsFor:'aspects'!

queryResultListAspect
    <resource: #uiAspect>


    |holder|

    (holder := builder bindingAt:#queryResultListAspect) isNil ifTrue:[
        holder := List new.
        builder aspectAt:#queryResultListAspect put:holder.
    ].
    ^ holder.
!

queryResultNameListAspect
    <resource: #uiAspect>


    |holder|

    (holder := builder bindingAt:#queryResultNameListAspect) isNil ifTrue:[
        holder := List new.
        builder aspectAt:#queryResultNameListAspect put:holder.
    ].
    ^ holder.
!

selectedResultIndexAspect
    <resource: #uiAspect>


    |holder|

    (holder := builder bindingAt:#selectedResultIndexAspect) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#selectedResultIndexAspect put:holder.
    ].
    ^ holder.
! !

!WorkspaceUI methodsFor:'hooks'!

postBuildVariablePanel: aPanel

    variablePanel := aPanel.

    "Created: / 14-12-2006 / 19:56:10 / janfrog"
! !

!WorkspaceUI methodsFor:'initialization'!

initialize

    super initialize.
    currentQueryResultId := 0.
    relativeCorners := #(0.5 1.0)

    "Created: / 12-12-2006 / 13:27:41 / janfrog"
    "Modified: / 10-02-2007 / 11:41:44 / janfrog"
! !

!WorkspaceUI class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
