"
 COPYRIGHT (c) 2001 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::WorkspaceApplication subclass:#WorkspaceApplication
	instanceVariableNames:'documentProvider evaluateQueryBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-UI'
!

!WorkspaceApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    A simple wrapper around a WorkSpace-View, adding a pullDown menu.

    [author:]
        Claus Gittinger
"
! !

!WorkspaceApplication class methodsFor:'initialization'!

initialize

    self installInLauncher

    "Created: / 12-04-2007 / 15:08:23 / janfrog"
!

installInLauncher

    | toolbarItem menuItem |
    "toolbarItem := MenuItem new
                    label:'Simple XML Editor';
                    icon:self icon;
                    value:[XMLv2::SimpleXMLEditor open];
                    isButton:true.

    NewLauncher
        addMenuItem:toolbarItem
        from:XMLv2::SimpleXMLEditor
        in:'toolbar'
        position:#(before help)
        space:true."


    menuItem := (MenuItem label:'XQuery Workspace') 
                    value:[XQuery::WorkspaceApplication open];
                    isButton:false.


    NewLauncher
        addMenuItem:menuItem
        from:self
        in:'menu'
        position:#(before startSmaCCParserGenerator)
        space:false.

    "
        self installInLauncher
    "

    "Created: / 12-04-2007 / 15:08:23 / janfrog"
! !

!WorkspaceApplication class methodsFor:'menu specs'!

tabMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#tabMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication tabMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Add Tab'
            #translateLabel: true
            "/ #triggerOnDown: true
            #value: #addWorkspace
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Remove Tab'
            #translateLabel: true
            "/ #triggerOnDown: true
            #value: #removeWorkspace:
            #enabled: #canRemoveWorkspace:
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Rename...'
            #translateLabel: true
            "/ #triggerOnDown: true
            #value: #renameWorkspace:
          )
         )
        nil
        nil
      )

    "Created: / 12-12-2006 / 14:31:17 / janfrog"
! !

!WorkspaceApplication class methodsFor:'special startup'!

openOnFile:aFilename
    "launch a new workspace on the contents of some file"

    |ws|

    ws := self openWith:nil.
    ws loadFile:aFilename.
    ^ ws

    "
     WorkspaceApplication openOnFile:'Makefile'
    "

    "Created: / 12-12-2006 / 14:31:17 / janfrog"
!

openWith:initialText
    "launch a new workspace with some initial contents"

    ^ self openWith:initialText selected:false

    "
     WorkspaceApplication openWith:'Transcript showCR:''hello world'''
    "

    "Created: / 12-12-2006 / 14:31:17 / janfrog"
!

openWith:initialText selected:selectedBoolean
    "launch a new workspace with some initial contents"

    |workspace|

    workspace := self new.
    workspace open.
    workspace selectedWorkspace contents:initialText selected:selectedBoolean.
    ^ workspace

    "
     WorkspaceApplication openWith:'Transcript showCR:''hello world'''
    "

    "Created: / 12-12-2006 / 14:31:17 / janfrog"
! !

!WorkspaceApplication methodsFor:'accessing'!

documentProvider

    documentProvider ifNil:[documentProvider := XQuery::DefaultXDMAdaptorProvider default].
    ^ documentProvider

    "Created: / 15-12-2006 / 07:47:25 / janfrog"
    "Modified: / 28-01-2010 / 11:32:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

documentProvider:anXPathDocumentProvider
    documentProvider := anXPathDocumentProvider.

    "Created: / 15-12-2006 / 07:47:25 / janfrog"
!

evaluateQueryBlock
     evaluateQueryBlock ifNil:[
        evaluateQueryBlock := [:query|self interpreter
                                        setDocumentProvider: self documentProvider;
                                        evaluate: query]].
    ^evaluateQueryBlock

    "Created: / 17-10-2007 / 13:28:24 / janfrog"
!

evaluateQueryBlock:something
    evaluateQueryBlock := something.

    "Created: / 17-10-2007 / 13:28:25 / janfrog"
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

    interpreter := something

    "Created: / 29-08-2007 / 09:47:27 / janfrog"
!

selectedWorkspaceIndex

    ^self selectedWorkspaceIndexHolder value

    "Created: / 10-02-2007 / 10:23:02 / janfrog"
! !

!WorkspaceApplication methodsFor:'aspects'!

hasHistory
    ^ Workspace doItHistory size > 0.

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

showResultViewAspect

    ^(AspectAdaptor forAspect:#resultViewShown)
        subjectChannel:
            ((AspectAdaptor forAspect:#client)
                subjectChannel:self workspaceHolder)

    "Created: / 10-02-2007 / 11:49:22 / janfrog"
!

workspaceWidget

    ^SubCanvas new
        clientHolder: self workspaceHolder

    "Created: / 07-07-2010 / 21:27:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspaceApplication methodsFor:'hooks'!

closeRequest

    Smalltalk isStandAloneApp ifTrue:[
        (Dialog confirm:'Really quit?') ifTrue:
            [^Smalltalk exit]
    ] ifFalse:
            [^super closeRequest]

    "Modified: / 13-02-2007 / 15:52:43 / janfrog"
! !

!WorkspaceApplication methodsFor:'menu-actions'!

addWorkspace
    self addWindow:(self createWorkspace) named:'Workspace%1'

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

askForFilterBlock:message template:template rememberIn:nameOfClassVar
    |filterBlockString filterBlock dialog textHolder classVarValue|

    classVarValue := self class classVarAt:nameOfClassVar ifAbsent:nil.
    classVarValue isNil ifTrue:[
        self class classVarAt:nameOfClassVar put:template. 
        classVarValue := template.
    ].

    textHolder := ValueHolder new.
    dialog := Dialog 
                 forRequestText:(resources string:message)
                 lines:25 
                 columns:70
                 initialAnswer:classVarValue
                 model:textHolder.
    dialog addButton:(Button label:'Template' action:[textHolder value:template. textHolder changed:#value.]).
    dialog open.
    dialog accepted ifFalse:[^ nil].

    filterBlockString := textHolder value.
    self class classVarAt:nameOfClassVar put:filterBlockString. 

    filterBlock := Parser evaluate:filterBlockString.
    filterBlock isBlock ifFalse:[
        self error:'bad input for filterBlock' mayProceed:true.
        ^ nil
    ].

    ^ filterBlock

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

basicInspectIt
    self inspectIt:true

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

clearHistory
    Workspace clearDoItHistory

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

defaultFileNameForSave

    ^tabList size isZero
        ifTrue:['file.xq']
        ifFalse:[(tabList at:self selectedWorkspaceIndex) , '.xq'].

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
    "Modified: / 10-02-2007 / 10:24:29 / janfrog"
!

inspectQuery

    self selectedWorkspacesTextView inspectQuery

    "Created: / 12-04-2007 / 12:48:47 / janfrog"
!

loadFile:aFileName 
    self loadFile:aFileName encoding:nil

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

loadFile:aFileName encoding:encodingSymbolOrNil
    |lbl|

    lbl := aFileName asFilename withoutSuffix baseName.
    self loadFile:aFileName encoding:encodingSymbolOrNil label:lbl.

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

loadFile:aFileName encoding:encodingSymbolOrNil label:label
    |file ws|

    file := aFileName asFilename.
    ws := self selectedWorkspacesTextView.
    [
        |contents|

        contents := file contents.
        encodingSymbolOrNil notNil ifTrue:[
            contents := contents encodeFrom:encodingSymbolOrNil into:#'unicode'.
            ws externalEncoding:encodingSymbolOrNil.
        ].
        ws contents:contents.
        ws defaultFileNameForFileDialog:file pathName.
    ] on:StreamError do:[:ex|
        Dialog warn:(resources string:'Cannot open %1: %2' with:file asString with:ex description).
        ^ self
    ].
    ws modified:false.

    tabList size <= 1 ifTrue:[
        self window label:label.
    ] ifFalse:[
        tabList at:self selectedWorkspaceIndexHolder value put:label
    ]

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

menuLoad
    |file|

    (self askIfModified:'Text was modified. Load anyway ?' yesButton:'Load') ifFalse:[ ^ self].

    file := Dialog requestFileName:(resources string:'Load file') default:'file.xq' pattern:'*.xq'.
    file size ~~ 0 ifTrue:[
        self loadFile:file
    ]

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
    "Modified: / 10-02-2007 / 10:16:39 / janfrog"
!

openAboutThisApplication

    (AboutBoxUI new)
        windowTitle:'About XQuery Workspace';
        about:'XQuery Workspace Application v1.0';

        authorsHtml:'<ul>
            <li>Jan Zak <a href="maito:zakj2@fel.cvut.cz">&lt;zajk2@fel.cvut.cz&gt;</a></li>
            <li>Jan Vrany <a href="maito:vranyj1@fel.cvut.cz">&lt;vranyj1@fel.cvut.cz&gt;</a></li>
        </ul>';
        license:License GPL;
        open

    "Created: / 10-02-2007 / 16:00:28 / janfrog"
!

openDocumentation
    "opens the documentation file"

    self openHTMLDocument: 'tools/misc/TOP.html#WORKSPACE'

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

pasteAndExecute:aString
    self paste:aString.
    self printIt

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

processText
    |template filterBlock newList oldList answer nChanged changedLines flags|

    template :=
'"/ general text processor;
"/ the following block should evaluate to a new line, 
"/ given the original line as argument.
"/ Beginner warning: Smalltalk know-how is useful here.

[:line |
     "/ any processing on line.
     "/ Notice, that line might be a Text object (i.e. non-string),
     "/ 
     "/ Useful operations on the line are:
     "/     - '' .... '' ,                      concatenation of any prefix/suffix
     "/     - leftPaddedTo:size                 padding
     "/     - rightPaddedTo:size                padding
     "/     - copyTo:(size min:N)               
     "/     - asUppercase 
     "/     - asLowercase
     "/     - withoutSeparators                 remove whiteSpace
     "/     - asCollectionOfWords               words

     "/ makes everything bold
     "/
     "/ line allBold

     "/ first word only
     "/
     "/ line withoutSeparators asCollectionOfWords first

     "/ dummy filter (keeps all lines as-is)
     "/
     line
]
'.
    filterBlock := self askForFilterBlock:'Processing block:'
                        template:template
                        rememberIn:#LastProcessingBlockString.
    filterBlock isNil ifTrue:[^ self].

    oldList := self selectedWorkspacesTextView list.
    oldList := oldList collect:[:lineOrNil | lineOrNil ? ''].
    newList := oldList collect:[:line | |newLine|
                newLine := line.
                Error handle:[:ex |
                ] do:[
                    newLine := filterBlock value:line
                ].
                newLine
               ].
    newList := newList collect:[:line | (line isString and:[line size == 0]) ifTrue:[nil] ifFalse:[line]].

    flags := (1 to:oldList size) collect:[:i | (oldList at:i) ~= (newList at:i)].
    flags := flags select:[:flag | flag].
    nChanged := flags size.
    nChanged == 0 ifTrue:[
        self information:'No lines were changed.'.
        ^ self
    ].

    answer := Dialog confirmWithCancel:(resources 
                        string:'%1 lines changed. Change text ?'
                        with:nChanged)
                labels:#( 'Cancel' 'No, Show Changed' 'Yes').
    answer isNil ifTrue:[^ self].
    answer ifFalse:[
        changedLines := (1 to:oldList size) select:[:i | (oldList at:i) ~= (newList at:i)].
        changedLines := changedLines collect:[:i | (newList at:i)].
        TextBox openOn:(changedLines asStringCollection) title:'Changed lines'.
        ^ self.
    ].

    self selectedWorkspacesTextView list:newList.

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

redoLastDoIt
    |s|

    s := self lastDoItsString.
    s notNil ifTrue:[
        self pasteAndExecute:s
    ]

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
! !

!WorkspaceApplication methodsFor:'menu-actions-editing'!

fileInText
    self selectedWorkspacesTextView contentsAsString readStream fileIn

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

filterText
    |template filterBlock newList oldList answer nDeleted deletedLines|

    template :=
'"/ general text filter;
"/ the following block should evaluate to true for all lines
"/ you want to keep - lines for which the block returns false will be removed.
"/ Beginner warning: Smalltalk know-how is useful here.

[:line |
     "/ any condition on line.
     "/ Notice, that line might be a Text object (i.e. non-string),
     "/ so you may want to use line string.
     "/ 
     "/ Useful queries on the line are:
     "/     - size                   the length of the line
     "/     - hasChangeOfEmphasis    any bold, italic etc.
     "/     - startsWith:someString
     "/     - endsWith:someString

     "/ example filter (removes all empty lines)
     "/
     "/ line size > 0

     "/ example filter (removes all lines which do not end with some suffix)
     "/
     "/ (line asLowercase endsWith:''foo'') not

     "/ dummy filter (keeps all lines)
     "/
     true
]
'.

    filterBlock := self askForFilterBlock:'Filter block:'
                        template:template
                        rememberIn:#LastFilterBlockString.
    filterBlock isNil ifTrue:[^ self].

    oldList := self selectedWorkspacesTextView list.
    oldList := oldList collect:[:lineOrNil | lineOrNil ? ''].
    newList := oldList select:filterBlock.
    newList := newList collect:[:line | (line isString and:[line size == 0]) ifTrue:[nil] ifFalse:[line]].
    nDeleted := oldList size - newList size.
    nDeleted == 0 ifTrue:[
        self information:'No lines were deleted.'.
        ^ self
    ].

    answer := Dialog confirmWithCancel:(resources 
                        string:'%1 lines remain (%2 deleted). Change text ?'
                        with:newList size
                        with:nDeleted)
                labels:#( 'Cancel' 'No, Show Deleted' 'Yes').
    answer isNil ifTrue:[^ self].
    answer ifFalse:[
        deletedLines := oldList reject:filterBlock.
        TextBox openOn:(deletedLines asStringCollection) title:'Filtered lines'.
        ^ self.
    ].

    self selectedWorkspacesTextView list:newList.

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

pasteLastDoIt
    |s|

    s := self lastDoItsString.
    s notNil ifTrue:[
        self paste:s
    ]

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
! !

!WorkspaceApplication methodsFor:'menu-dynamic'!

pasteRecentDoItMenu
    <resource: #programMenu >

    ^ self recentDoItsMenuFor:#'paste:'

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

recentDoItsMenuFor:aSelector
    <resource: #programMenu >

    ^ [
        |doIts m classHistory currentClass|

        doIts := Workspace doItHistory.
        doIts size > 0 ifTrue:[
            m := Menu new.
            doIts do:[:doItEntry |
                |lines label item|

                label := doItEntry withoutLeadingSeparators asStringCollection first.
                (label size > 20) ifTrue:[
                    label := (label contractTo:20)
                ] ifFalse:[
                    (lines size > 1) ifTrue:[
                        label := label , '...'
                    ].
                ].
                label := '''' , label , ''''.

                item := MenuItem label:label.
                m addItem:item.
                item value:aSelector.
                item argument:doItEntry.
            ].
            m addItem: (MenuItem new label:'-').
            m addItem: (MenuItem new 
                        label: (resources string:'Clear History'); 
                        value: #clearHistory; 
                        activeHelpKey: #historyEmptyMenu;
                        translateLabel:true).
       ].
        m
    ].

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

redoRecentDoItMenu
    <resource: #programMenu >

    ^ self recentDoItsMenuFor:#'pasteAndExecute:'

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
! !

!WorkspaceApplication methodsFor:'private'!

askIfAnyModified:question yesButton:yesButtonText
    (workspaces contains:[:aView | self isModifiedWorkspace:aView]) ifFalse:[^ true].

    (Dialog 
        confirm:(resources stringWithCRs:question)
        yesLabel:(resources string:yesButtonText)
        noLabel:(resources string:'Cancel'))
    ifTrue:[
        "/ reset modified flag so question is asked only once
        workspaces 
            select:[:aView | (self isModifiedWorkspace:aView)]
            thenDo:[:eachModifiedTextView |
                        eachModifiedTextView modified:false.
                    ].
        ^ true
    ].
    ^ false

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

compilerClassForSyntaxName:syntax
    syntax == #Smalltalk ifTrue:[
        ^ Compiler
    ].
    syntax == #JavaScript ifTrue:[
        ^ JavaScriptCompiler
    ].
    ^ Compiler

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

createEvaluationWorkspace
    |ws l box resultView environmentView panel workspaceVariables|

    workspaceVariables := Workspace workspaceVariables.

    panel := VariableVerticalPanel new.

      box := View new.
      l := Label new.
      l label:'Eval:'.
      l layout:((0.0@0.0 corner:1.0@0.0) asLayout bottomOffset:22).
      l adjust:#left.
      box add:l.

      ws := HVScrollableView for:Workspace.
      ws autoDefineVariables:#workspace.
      ws layout:((0.0@0.0 corner:1.0@1.0) asLayout topOffset:22).
      box add:ws.
    panel add:box.

      box := View new.
      box add:(Label new label:'Value:'; adjust:#left; layout:((0.0@0.0 corner:1.0@0.0) asLayout bottomOffset:22)).
      resultView := HVScrollableView for:TextCollector.
      box add:(resultView layout:((0@0 corner:1.0@1.0) asLayout topOffset:22); yourself).

    panel add:box.

      box := View new.
      box add:(Label new label:'Environment:'; adjust:#left; layout:((0.0@0.0 corner:1.0@0.0) asLayout bottomOffset:22)).
      environmentView := DictionaryInspectorView new.
      environmentView suppressPseudoSlots:true.
      environmentView inspect:workspaceVariables.
      environmentView dereferenceValueHolders:true.
      environmentView fieldListLabel:'Variable'.
      box add:(environmentView layout:((0@0 corner:1.0@1.0) asLayout topOffset:22); yourself).

    panel add:box.

"/     self renameWorkspace:(self selectedWorkspaceIndexHolder value) to:'Eval'.

    ws doItAction:[:theCode |
        |result resultString|

        result := ws executeDoIt:theCode.
        resultString := [
                            result storeString
                        ] on:Error do:[
                            result printString
                        ].  
                        
        resultView showCR:resultString.
        9 to:2 by:-1 do:[:h|
            (workspaceVariables includesKey:('$%1' bindWith:h-1)) ifTrue:[
                workspaceVariables 
                        at:('$%1' bindWith:h)
                        put:(workspaceVariables at:('$%1' bindWith:h-1)).
            ].
        ].
        (workspaceVariables includesKey:'$') ifTrue:[
            workspaceVariables at:'$1' put:(workspaceVariables at:'$').
        ].
        workspaceVariables at:'$' put:(ValueHolder with:result).
        environmentView doUpdate.
        result.
    ].

    ^ panel

    "Created: / 14-12-2006 / 21:52:06 / janfrog"
!

createWorkspace

    ^
    "/ApplicationSubView new
    "/    client:
            (WorkspaceUI new 
                interpreter: self interpreter;
                evaluateQueryBlock: self evaluateQueryBlock;
                documentProvider: self documentProvider)
   "/; yourself

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
    "Modified: / 17-10-2007 / 13:32:36 / janfrog"
    "Modified: / 19-04-2010 / 12:02:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSelectionInActiveWorkspace

    ^(self selectedWorkspacesTextView selectionOrTextOfCursorLine:false) isNilOrEmptyCollection not

    "Created: / 12-04-2007 / 13:29:40 / janfrog"
!

isModifiedWorkspace:aView
    |view|

    view := self workspaceViewOfView:aView.

    (view isNil
    or:[view modified not 
    or:[view contentsWasSaved
    or:[view contents withoutSeparators isEmpty]]]) ifTrue:[
        ^ false
    ].
    ^ true

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

lastDoItsString
    |history|

    history := Workspace doItHistory.
    history size > 0 ifFalse:[
        self selectedWorkspacesTextView flash.
        ^ nil
    ].
    ^ history first

    "Created: / 14-12-2006 / 21:52:05 / janfrog"
!

syntaxNameForCompilerClass:aClass
    aClass == Compiler ifTrue:[
        ^ #Smalltalk
    ].
    aClass == JavaScriptCompiler ifTrue:[
        ^ #JavaScript
    ].
    ^ #Smalltalk

    "Created: / 14-12-2006 / 21:52:06 / janfrog"
!

workspaceSelectionChanged
    |wsIndex windowLabel v|

    "/ self selected
    self workspaceHolder value:(v := self selectedWorkspace).
    wsIndex := self selectedWorkspaceIndexHolder value.

    wsIndex ~~ 0 ifTrue:[
        windowLabel := tabList at:wsIndex ifAbsent:nil.
        windowLabel notNil ifTrue:[self window label:windowLabel, ' - XQuery Workspace'].
    ].

    "Created: / 14-12-2006 / 22:02:11 / janfrog"
!

workspaceViewOfView: aView

   ^(aView isKindOf: XQuery::WorkspaceUI) 
        ifTrue:[aView workspaceView]
        ifFalse:[super workspaceViewOfView: aView]

    "Created: / 10-02-2007 / 12:17:25 / janfrog"
    "Modified: / 12-04-2007 / 13:26:17 / janfrog"
    "Modified: / 19-04-2010 / 12:40:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspaceApplication class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !

WorkspaceApplication initialize!
