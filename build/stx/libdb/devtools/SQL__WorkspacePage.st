"{ Package: 'stx:libdb/devtools' }"

"{ NameSpace: SQL }"

ApplicationModel subclass:#WorkspacePage
	instanceVariableNames:'connectionHolder currentQueryResultId variablePanel shouldResize
		relativeCorners workspaceView evaluateQueryBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Tools'
!

ApplicationModel subclass:#ResultBrowser
	instanceVariableNames:'cursorHolder selectionHolder listHolder columnsHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:WorkspacePage
!


!WorkspacePage class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::WorkspacePage andSelector:#windowSpec
     SQL::WorkspacePage new openInterface:#windowSpec
     SQL::WorkspacePage open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'SQL Workspace'
          name: 'SQL Workspace'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 800 600)
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
                    name: 'Workspace'
                    hasBorder: false
                    component: workspaceView
                  )
                 (NoteBookViewSpec
                    name: 'ResultNotebook'
                    model: selectedResultIndexAspect
                    menu: queryResultNameListAspect
                    useIndex: true
                    fitLastRow: false
                    destroyTabAction: removeResultWithIndex:
                    canvas: selectedDOMInspectorAspect
                    keepCanvasAlive: true
                  )
                 )
               
              )
              handles: (Any 0.99 1.0)
              postBuildCallback: postBuildVariablePanel:
            )
           )
         
        )
      )
! !

!WorkspacePage methodsFor:'accessing'!

compilerClass
    ^SQL::LanguageDefinition instance evaluatorClass

    "Created: / 10-05-2012 / 20:36:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

connection

    ^self connectionHolder value

    "Created: / 11-05-2012 / 10:33:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

connection: aSQLConnection

    self connectionHolder value: aSQLConnection

    "Created: / 11-05-2012 / 10:33:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluateQueryBlock
    evaluateQueryBlock isNil ifTrue:[
        evaluateQueryBlock := [:code| self evaluate: code ]
    ].
    ^evaluateQueryBlock

    "Created: / 17-10-2007 / 13:28:49 / janfrog"
    "Modified: / 10-05-2012 / 18:19:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluateQueryBlock:aBlock
    evaluateQueryBlock := aBlock.
    workspaceView notNil ifTrue:[
        workspaceView doItAction: evaluateQueryBlock 
    ].

    "Created: / 17-10-2007 / 13:28:49 / janfrog"
    "Modified: / 10-05-2012 / 18:17:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

scrolledView
    "ScrollableView mimicry - to better support legacy WorkspaceApplication"

    ^workspaceView

    "Created: / 11-05-2012 / 16:02:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspacePage methodsFor:'accessing - views'!

workspaceScrollableView


    ^HVScrollableView new 
        scrolledView:self workspaceView;
        yourself

    "Created: / 12-04-2007 / 13:24:03 / janfrog"
!

workspaceView

    workspaceView isNil ifTrue:[
        workspaceView := Tools::CodeView2 new.
        workspaceView doItAction:self evaluateQueryBlock.
        workspaceView delegate: self.
    ].
    ^workspaceView

    "Created: / 12-12-2006 / 12:30:59 / janfrog"
    "Modified: / 17-10-2007 / 13:30:07 / janfrog"
    "Modified: / 18-09-2008 / 18:05:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 11-05-2012 / 10:20:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspacePage methodsFor:'actions'!

doIt
    self doWithValueDo: [:value|
        self addResult: value 
    ]

    "Created: / 11-05-2012 / 10:27:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doWithValueDo: aBlock
    
    ^ workspaceView do:(workspaceView selectionOrTextOfCursorLine) withValueDo:aBlock

    "Created: / 11-05-2012 / 11:32:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspectIt
    self doWithValueDo: [:value|value inspect]

    "Created: / 11-05-2012 / 10:27:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printIt
    self doIt

    "Created: / 11-05-2012 / 10:27:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

switchToBookmarkEntry: bookmark
    | file page |

    page := self.
    bookmark isFileBookmark ifTrue:[
        file := bookmark path asFilename.
        file exists ifFalse:[
            Transcript showCR:('Bookmarked workspace file no longer exists: %1' bindWith:file)
        ] ifTrue:[
            (workspaceView contents notEmpty) ifTrue:[
                masterApplication addWindow: (page := masterApplication createWorkspaceViewSQL) named:  file withoutSuffix baseName.
                page := page application.
            ].
            page menuOpen: file.
        ].
        ^ self.
    ].

    "Created: / 11-05-2012 / 16:42:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspacePage methodsFor:'adding & removing results'!

addResult:aCursor 
    |wasFirst|

    aCursor ifNil:[^self].

    wasFirst := self queryResultList size isZero.
    self queryResultNameListAspect 
        add:('Result ' , self nextQueryResultId printString , ' [' 
                , Time now printString , ']').
    self queryResultListAspect    
        add:(ResultBrowser new cursor:aCursor).
    self selectedResultIndexAspect value:(self queryResultListAspect size).
    wasFirst ifTrue:[
        self showResultView
         "self masterApplication ifNotNil:
         [self window extent:(self window extent x)@(self window extent y * 2)]."
    ]

    "Created: / 12-12-2006 / 13:24:52 / janfrog"
    "Modified: / 10-02-2007 / 11:38:26 / janfrog"
    "Modified: / 02-12-2008 / 13:19:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 11-05-2012 / 14:51:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

!WorkspacePage methodsFor:'aspects'!

connectionHolder
    "return/create the 'connectionHolder' value holder (automatically generated)"

    connectionHolder isNil ifTrue:[
        connectionHolder := ValueHolder new.
    ].
    ^ connectionHolder
!

connectionHolder:something
    "set the 'connectionHolder' value holder (automatically generated)"

    connectionHolder := something.
!

cursorColHolder
    ^workspaceView notNil 
        ifTrue:[workspaceView cursorColHolder]
        ifFalse:[nil].

    "Created: / 10-05-2012 / 20:06:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cursorLineHolder
    ^workspaceView notNil 
        ifTrue:[workspaceView cursorLineHolder]
        ifFalse:[nil].

    "Created: / 10-05-2012 / 20:06:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modeLabelHolder
    ^workspaceView notNil 
        ifTrue:[workspaceView modeLabelHolder]
        ifFalse:[nil].

    "Created: / 10-05-2012 / 20:07:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

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

!WorkspacePage methodsFor:'event handling'!

handlesKeyPress:key inView:aView

    aView ~~ workspaceView textView ifTrue:[ ^ false ].
    ^#(DoIt PrintIt InspectIt) includes: key

    "Created: / 11-05-2012 / 10:26:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:key x:x y:y view:aView

    key == #DoIt ifTrue:[
        self doIt.
        ^true
    ].
    key == #PrintIt ifTrue:[
        self printIt.
        ^true
    ].
    key == #InspectIt ifTrue:[
        self inspectIt.
        ^true
    ].
    ^false.

    "Created: / 11-05-2012 / 10:27:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspacePage methodsFor:'hooks'!

postBuildVariablePanel: aPanel

    variablePanel := aPanel.

    "Created: / 14-12-2006 / 19:56:10 / janfrog"
! !

!WorkspacePage methodsFor:'initialization & release'!

destroy

    "nothing to do"

    "Created: / 19-04-2010 / 12:41:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize

    super initialize.
    currentQueryResultId := 0.
    relativeCorners := #(0.5 1.0)

    "Created: / 12-12-2006 / 13:27:41 / janfrog"
    "Modified: / 10-02-2007 / 11:41:44 / janfrog"
! !

!WorkspacePage methodsFor:'menu-actions'!

menuConnect

    self halt: 'Not yet implemented'

    "Created: / 11-05-2012 / 10:01:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuOpen: aFilename
    | content |

    content := aFilename asFilename contents asString.
    workspaceView defaultFileNameForFileDialog: aFilename.
    workspaceView contents: content.
    workspaceView beUnmodified.

    "Created: / 11-05-2012 / 16:44:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuSave

    workspaceView defaultFileNameForFileDialog isNil ifTrue:[
        self menuSaveAs
    ] ifFalse:[
        self menuSaveAs: workspaceView defaultFileNameForFileDialog
    ].

    "Created: / 11-05-2012 / 16:24:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuSaveAs
    | f |

    f := Dialog
            requestFileName: (resources string:'Save File As...')
            default:'script.sql'
            pattern:'*.sql'.
    f notEmptyOrNil ifTrue:[
        self menuSaveAs: f.
    ]

    "Created: / 11-05-2012 / 16:23:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuSaveAs: aFilename

    aFilename asFilename writingFileDo:[:s|
        s nextPutAll: workspaceView contents.
        workspaceView defaultFileNameForFileDialog: aFilename.
        workspaceView beUnmodified.
    ]

    "Created: / 11-05-2012 / 16:28:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspacePage methodsFor:'menu-actions-adding'!

menuAddBookmarkTo: folder

    | ws file |

    ws := workspaceView.
    ws isTextView ifTrue:[
        file := ws defaultFileNameForFileDialog.
        file ifNotNil:[folder add: (Bookmark forFile: file)].
        folder model save.
    ] ifFalse:[
        self shouldImplement
    ]

    "Created: / 21-06-2011 / 08:56:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspacePage methodsFor:'private'!

evaluate: code

    ^self connection executeQuery: code

    "Created: / 10-05-2012 / 18:19:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

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

!WorkspacePage methodsFor:'queries'!

canAddBookmark

    ^self canSave

    "Created: / 11-05-2012 / 16:21:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canOpen

    ^true

    "Created: / 11-05-2012 / 15:37:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSave

    ^workspaceView notNil and:[workspaceView defaultFileNameForFileDialog notNil]

    "Created: / 11-05-2012 / 15:37:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSaveAs

    ^workspaceView notNil and:[workspaceView contents asString indexOfNonSeparator ~~ 0].

    "Created: / 11-05-2012 / 15:38:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspacePage::ResultBrowser class methodsFor:'class access'!

dataSetViewClass
    ^ DataSetView

    "Created: / 06-07-2006 / 18:32:47 / cg"
! !

!WorkspacePage::ResultBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!WorkspacePage::ResultBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::QueryResultBrowser andSelector:#windowSpec
     SQL::QueryResultBrowser new openInterface:#windowSpec
     SQL::QueryResultBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'SQL::ODBCResultTable'
          name: 'SQL::ODBCResultTable'
          min: (Point 10 10)
          max: (Point 1024 768)
          bounds: (Rectangle 0 0 300 300)
          menu: menu
        )
        component: 
       (SpecCollection
          collection: (
           (DataSetSpec
              name: 'Table'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: selectionHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              dataList: listHolder
              columnHolder: columnsHolder
            )
           )
         
        )
      )
! !

!WorkspacePage::ResultBrowser class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SQL::ODBCResultTable andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(SQL::ODBCResultTable menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'ResultType'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Table output'
                  itemValue: changeResultApp:
                  translateLabel: true
                  choice: outputApp
                  choiceValue: true
                )
               (MenuItem
                  label: 'HTML output'
                  itemValue: changeResultApp:
                  translateLabel: true
                  choice: outputApp
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
! !

!WorkspacePage::ResultBrowser methodsFor:'accessing'!

cursor

    ^self cursorHolder value

    "Created: / 11-05-2012 / 14:31:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cursor: anObject

    self cursorHolder value: anObject

    "Created: / 11-05-2012 / 14:31:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspacePage::ResultBrowser methodsFor:'aspects'!

columnsHolder
    "return/create the 'columnsHolder' value holder (automatically generated)"

    columnsHolder isNil ifTrue:[
        columnsHolder := ValueHolder with: #().
    ].
    ^ columnsHolder

    "Modified: / 11-05-2012 / 14:27:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

columnsHolder:something
    "set the 'columnsHolder' value holder (automatically generated)"

    columnsHolder := something.
!

cursorHolder
    "return/create the 'cursorHolder' value holder (automatically generated)"

    cursorHolder isNil ifTrue:[
        cursorHolder := ValueHolder new.
        cursorHolder addDependent:self.
    ].
    ^ cursorHolder
!

cursorHolder:something
    "set the 'cursorHolder' value holder (automatically generated)"

    |oldValue newValue|

    cursorHolder notNil ifTrue:[
        oldValue := cursorHolder value.
        cursorHolder removeDependent:self.
    ].
    cursorHolder := something.
    cursorHolder notNil ifTrue:[
        cursorHolder addDependent:self.
    ].
    newValue := cursorHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:cursorHolder.
    ].
!

listHolder
    "return/create the 'listHolder' value holder (automatically generated)"

    listHolder isNil ifTrue:[
        listHolder := ValueHolder with:#().
    ].
    ^ listHolder

    "Modified: / 11-05-2012 / 14:27:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listHolder:something
    "set the 'listHolder' value holder (automatically generated)"

    listHolder := something.
!

selectionHolder
    "return/create the 'selectionHolder' value holder (automatically generated)"

    selectionHolder isNil ifTrue:[
        selectionHolder := ValueHolder new.
    ].
    ^ selectionHolder
!

selectionHolder:something
    "set the 'selectionHolder' value holder (automatically generated)"

    selectionHolder := something.
! !

!WorkspacePage::ResultBrowser methodsFor:'call backs'!

activeCursor:activeCursor
    |columnDescriptions columns rows rdWtSel dsv idx|

    columns := OrderedCollection new.
    rdWtSel := #( #at: #at:put: ).

    columnDescriptions := activeCursor columnDescriptions.
    columnDescriptions do:[:desc |
        columns add:(DataSetColumnSpec label:desc name editorType:#None selector:rdWtSel )
    ].

    rows := OrderedCollection new.
    dsv := Smalltalk::DataSetView new.

    idx := 1.
    [activeCursor next notNil and:[idx < 100]] whileTrue:[
        rows add:activeCursor rowAsArray.
        idx := idx + 1.
    ].

    dsv columnDescriptors: columns.
    dsv list: rows.
    self viewHolder value: dsv.
! !

!WorkspacePage::ResultBrowser methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == cursorHolder ifTrue:[
        self updateFromCursor.
        ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 11-05-2012 / 14:26:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateFromCursor
    |activeCursor columnDescriptions columns rows rdWtSel idx|


    activeCursor := self cursorHolder value.
    columns := OrderedCollection new.
    rdWtSel := #( #at: #at:put: ).

    columnDescriptions := activeCursor columnDescriptions.
    columnDescriptions do:[:desc |
        columns add:(DataSetColumnSpec label:desc name editorType:#None selector:rdWtSel )
    ].

    rows := OrderedCollection new.

    idx := 1.
    [activeCursor next notNil and:[idx < 100]] whileTrue:[
        rows add:activeCursor rowAsArray.
        idx := idx + 1.
    ].

    self columnsHolder value: columns.
    self listHolder value: rows.

    "Created: / 11-05-2012 / 14:26:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspacePage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/devtools/SQL__WorkspacePage.st,v 1.1 2012-05-11 16:10:42 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/devtools/SQL__WorkspacePage.st,v 1.1 2012-05-11 16:10:42 vrany Exp $'
! !
